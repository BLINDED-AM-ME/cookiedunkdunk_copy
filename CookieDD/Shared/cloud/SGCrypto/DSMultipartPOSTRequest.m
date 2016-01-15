//
//  DSPMultipartPOSTRequest.m
//  DSPMultipartPOSTRequest

/*
 
 Credits:
 
 President/CEO - Duane Schor
 
 Art Director - Neisha Bergman
 Artists - Ecieño Carmona
 Eric Eining
 Mike Swarts
 Erik Aamland
 Duane Schor
 
 Lead Programmer - Luke McDonald
 Programmers - Josh McGee
 Gary Johnston
 Dustin Whirle
 Jeremy Pagley
 Rodney Jenkins
 
 Server Programmer - Josh Pagley
 
 Lead Sound Designer - Ramsees Mechan
 Sound Designers - Richard Würth
 D’Andre Amos
 
 Voice Actors - Adrian Knapp
 Duane Schor
 Luke McDonald
 Neisha Bergman
 
 Lead Web Designer - Brittany Steed
 Web Designers - Yannik Bloscheck
 Lisa Menerick
 Andrew Gianikas
 
 Graphic Designer - Freddy Garcia
 
 Tech Support - Jonathan Marr-Cox
 
 Story - Audra Hudson
 Duane Schor
 
 Marketing Director - Rodney Jenkins
 Marketer - CJ Anderson
 
 Business Development Manager - Adam Hunt
 
 Quality Assurance - Vinny Spaulding
 
 Level Editing - Abner Velez
 
 
 Special Thanks - Jon Kurtz
 Benjamin Stahlhood II
 Andrew Nunley
 Steven Edsall
 And to all our friends and family that have supported us along the way!
 
 */

#import "DSMultipartPOSTRequest.h"


@interface DSUploadFileInfo : NSObject {}

@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *nameParam;
@property (nonatomic, copy) NSString *fileName;
@property (copy, nonatomic) NSString *authParam;

@end


@interface DSMultipartPOSTRequest ()

- (NSString *)preparedBoundary;

- (void)startRequestBody;
- (NSInteger)appendBodyString:(NSString *)string;
- (void)finishRequestBody;

- (void)finishMediaInputStream;
- (void)handleStreamCompletion;
- (void)handleStreamError:(NSError *)error;

@property (nonatomic, assign) NSInteger totalBytesToBeWritten;
@property (nonatomic, assign) NSInteger totalBytesWritten;

@property (nonatomic, copy) NSString *pathToBodyFile;
@property (nonatomic, strong) NSOutputStream *bodyFileOutputStream;

@property (nonatomic, strong) DSUploadFileInfo *fileToUpload;
@property (nonatomic, strong) NSInputStream *uploadFileInputStream;

@property (nonatomic, copy) DSBodyCompletionBlock prepCompletionBlock;
@property (nonatomic, copy) DSPostProgressHandler progressBlock;
@property (nonatomic, copy) DSBodyErrorBlock prepErrorBlock;

@property (nonatomic, assign, getter=isStarted) BOOL started;
@property (nonatomic, assign, getter=isFirstBoundaryWritten) BOOL firstBoundaryWritten;


@end


@implementation DSMultipartPOSTRequest

@synthesize totalBytesToBeWritten;
@synthesize totalBytesWritten;

@synthesize HTTPBoundary;

@synthesize formParameters;
@synthesize fileToUpload;
@synthesize uploadFileInputStream;

@synthesize pathToBodyFile;
@synthesize bodyFileOutputStream;

@synthesize prepCompletionBlock;
@synthesize progressBlock;
@synthesize prepErrorBlock;

@synthesize started;
@synthesize firstBoundaryWritten;

- (void)setUploadFile:(NSString *)path
          contentType:(NSString *)type
            nameParam:(NSString *)nameParam
             filename:(NSString *)fileName
            authParam:(NSString *)authParam {
    
    DSUploadFileInfo *info = [[DSUploadFileInfo alloc] init];
    info.localPath = path;
    info.fileName = fileName;
    info.nameParam = nameParam;
    info.contentType = type;
    info.authParam = authParam;
    
    self.fileToUpload = info;
}

#pragma mark -
#pragma mark Request body preparation

- (void)startRequestBody {
    if (!self.started) {
        self.started = YES;
        
        [self setHTTPMethod:@"POST"];
        NSString *format = @"multipart/form-data; boundary=%@";
        NSString *contentType = [NSString stringWithFormat:format,
                                 self.HTTPBoundary];
        [self setValue:contentType forHTTPHeaderField:@"Content-Type"];
        [self setValue:self.fileToUpload.authParam forHTTPHeaderField:@"Authorization"];
        
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        NSString *extension = @"multipartbody";
        NSString *bodyFileName = [(__bridge NSString *)uuidStr
                                  stringByAppendingPathExtension:extension];
        CFRelease(uuidStr);
        CFRelease(uuid);        

        self.pathToBodyFile = [NSTemporaryDirectory()
                               stringByAppendingPathComponent:bodyFileName];
        NSString *bodyPath = self.pathToBodyFile;
        self.bodyFileOutputStream = [NSOutputStream
                                     outputStreamToFileAtPath:bodyPath
                                                       append:YES];
        
        [self.bodyFileOutputStream open];
    }
}

- (void)finishRequestBody {
    [self appendBodyString:[NSString stringWithFormat:@"\r\n--%@--\r\n", self.HTTPBoundary]];
    [self.bodyFileOutputStream close];
    self.bodyFileOutputStream = nil;
    
    NSError *fileReadError = nil;
    NSDictionary *fileAttrs = [[NSFileManager defaultManager] attributesOfItemAtPath:self.pathToBodyFile error:&fileReadError];
    NSAssert1((fileAttrs != nil), @"Couldn't read post body file;", fileReadError);
    NSNumber *contentLength = [fileAttrs objectForKey:NSFileSize];
    [self setValue:[contentLength stringValue] forHTTPHeaderField:@"Content-Length"];
    
    NSInputStream *bodyStream = [[NSInputStream alloc] initWithFileAtPath:self.pathToBodyFile];
    [self setHTTPBodyStream:bodyStream];
}

- (NSInteger)appendBodyString:(NSString *)string {
    [self startRequestBody];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self.bodyFileOutputStream write:[data bytes] maxLength:[data length]];
}

- (NSString *)preparedBoundary {
    NSString *boundaryFormat =  self.firstBoundaryWritten ? @"\r\n--%@\r\n" : @"--%@\r\n";
    self.firstBoundaryWritten = YES;
    return [NSString stringWithFormat:boundaryFormat, self.HTTPBoundary];
}

- (void)prepareForUploadWithCompletionBlock:(DSBodyCompletionBlock)completion 
                              progressBlock:(DSPostProgressHandler)progress
                                 errorBlock:(DSBodyErrorBlock)error
{
    self.prepCompletionBlock = completion;
    self.progressBlock = progress;
    self.prepErrorBlock = error;
    
    [self startRequestBody];

    NSMutableString *params = [NSMutableString string];
    NSArray *keys = [self.formParameters allKeys];
    for (NSString *key in keys) {
        @autoreleasepool {
            [params appendString:[self preparedBoundary]];
            NSString *fmt = @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n";
            [params appendFormat:fmt, key];
            [params appendFormat:@"%@", [self.formParameters objectForKey:key]];
        }
    }
    if ([params length]) {
        if ([self appendBodyString:params] == -1) {
            self.prepErrorBlock(self, [self.bodyFileOutputStream streamError]);
            return;
        }        
    }
   
    if (self.fileToUpload) {
        NSMutableString *str = [[NSMutableString alloc] init];
        [str appendString:[self preparedBoundary]];
        [str appendString:@"Content-Disposition: form-data; "];
        [str appendFormat:@"name=\"%@\"; ", self.fileToUpload.nameParam];
        [str appendFormat:@"filename=\"%@\"\r\n", self.fileToUpload.fileName];
        NSString *contentType = self.fileToUpload.contentType;
        [str appendFormat:@"Content-Type: %@\r\n\r\n", contentType];
        [self appendBodyString:str];
        
        NSString *path = self.fileToUpload.localPath;
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        self.totalBytesToBeWritten = [[attrs objectForKey:NSFileSize] integerValue];
        self.totalBytesWritten = 0;
        NSInputStream *mediaInputStream = [[NSInputStream alloc] 
                                           initWithFileAtPath:path];
        self.uploadFileInputStream = mediaInputStream;
        
        [self.uploadFileInputStream setDelegate:self];
        [self.uploadFileInputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                              forMode:NSRunLoopCommonModes];
        [self.uploadFileInputStream open];
    } else {
        [self handleStreamCompletion];
    }
}

#pragma mark -
#pragma mark Runloop handler for copying the upload file

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        uint8_t buf[1024*100];
        NSUInteger len = 0;
        switch(eventCode) {
            case NSStreamEventOpenCompleted:
               // DebugLog(@"Media file opened");
                break;
            case NSStreamEventHasBytesAvailable:
                len = [self.uploadFileInputStream read:buf maxLength:1024];
                if (len) {
                    self.totalBytesWritten += [self.bodyFileOutputStream write:buf maxLength:len];
                    self.progressBlock([NSNumber numberWithFloat:(float)self.totalBytesWritten/(float)self.totalBytesToBeWritten]);
                } else {
                    //DebugLog(@"Buffer finished; wrote to %@", self.pathToBodyFile);
                    [self handleStreamCompletion];
                    self.progressBlock([NSNumber numberWithFloat:1.0f]);
                }
                break;
            case NSStreamEventErrorOccurred:
               // DebugLog(@"ERROR piping image to body file %@", [stream streamError]);
                self.prepErrorBlock(self, [stream streamError]);
                break;
            default:
                break;
        }
//    });
}

- (void)handleStreamCompletion {
    [self finishMediaInputStream];
    [self finishRequestBody];
    self.prepCompletionBlock(self);
}

- (void)finishMediaInputStream {
    [self.uploadFileInputStream close];
    [self.uploadFileInputStream removeFromRunLoop:[NSRunLoop currentRunLoop] 
                                          forMode:NSDefaultRunLoopMode];
    self.uploadFileInputStream = nil;
}

- (void)handleStreamError:(NSError *)error {
    [self finishMediaInputStream];
    self.prepErrorBlock(self, error);
}

#pragma mark -
#pragma mark Accessors
- (NSString *)HTTPBoundary {
    NSAssert2(([HTTPBoundary length] > 0), @"-[%@ %@] Invalid or nil HTTPBoundary", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    return HTTPBoundary;
}

- (void)setHTTPBoundary:(NSString *)boundary {
    if (HTTPBoundary == nil) {
        HTTPBoundary = [boundary copy];
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"HTTPBoundary cannot be changed once set (old='%@' new='%@')", HTTPBoundary, boundary]
                                     userInfo:nil];
    }
}

@end


@implementation DSUploadFileInfo

@synthesize localPath, contentType, nameParam, fileName;

- (NSString *)fileName {
    if (fileName == nil) {
        return [localPath lastPathComponent];
    }
    return fileName;
}

@end