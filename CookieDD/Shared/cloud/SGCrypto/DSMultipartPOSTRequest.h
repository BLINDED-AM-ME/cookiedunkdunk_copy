//
//  DSPMultipartPOSTRequest.h
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

#import <Foundation/Foundation.h>

@class DSMultipartPOSTRequest;

typedef void (^DSBodyCompletionBlock)(DSMultipartPOSTRequest *);
typedef void (^DSPostProgressHandler)(NSNumber *percentComplete);
typedef void (^DSBodyErrorBlock)(DSMultipartPOSTRequest *, NSError *);

@interface DSMultipartPOSTRequest : NSMutableURLRequest <NSStreamDelegate> {}

- (void)setUploadFile:(NSString *)path
          contentType:(NSString *)type
            nameParam:(NSString *)nameParam
             filename:(NSString *)fileName
           authParam:(NSString *)authParam;

- (void)prepareForUploadWithCompletionBlock:(DSBodyCompletionBlock)completion
                              progressBlock:(DSPostProgressHandler)progressBlock
                                 errorBlock:(DSBodyErrorBlock)error;

@property (nonatomic, copy) NSString *HTTPBoundary;
@property (nonatomic, strong) NSDictionary *formParameters;

@end