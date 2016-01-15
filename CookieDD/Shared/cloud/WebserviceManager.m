//
//  WebserviceManager.m
//  CookieDD
//
//  Created by Josh Pagley on 11/18/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.
//

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

#import "WebserviceManager.h"
#import "NSString+DSCrypto.h"
#import "NSData+Base64.h"
#import "SGAppDelegate.h"

#define kCookieDunkDunkRequestTimeOutInterval 15.0f

#define kCookieDDAppID                              @"BC10BF7D-E5E8-409D-91BC-8F2F6799DB2D"

#define kCookieDDSecret                             @"547DC35C1E354BAF95978344AF6AE721"

// Account endpoints
#define kCookieDunkDunkAccountsEndPoint             @"/api/cookiedunkdunk/accounts0.0.1" // Method POST, PUT
#define kCookieDunkDunkAccountsEndPointFMT          @"/api/cookiedunkdunk/accounts0.0.1?id=%@"
#define kCookieDunkDunkAccountsDeleteEndPointFMT    @"/api/cookiedunkdunk/accounts0.0.1" // Method DELETE
#define kCookieDunkDunkWorldsEndPoint               @"/api/cookiedunkdunk/accounts0.0.2/worlds" //Method POST
#define kCookieDunkDunkLevelsEndPoint               @"/api/cookiedunkdunk/accounts0.0.1/levels" //Method POST
#define kCookieDunkDunkCookieSettingsEndPoint       @"/api/cookiedunkdunk/accounts0.0.1/cookiesettnngs" //Method POST
#define kCookieDunkDunkMiniGamesEndPoint            @"/api/cookiedunkdunk/accounts0.0.1/minigames" //Method POST
#define kCookieDunkDunkUpdatePowerupsEndpoint       @"/api/cookiedunkdunk/accounts0.0.1/powerups" //Method POST
#define kCookieDunkDunkUpdateBoostersEndPoint       @"/api/cookiedunkdunk/accounts0.0.1/boosters" //Method POST
#define kCookieDunkDunkShowFriendsEndPoint          @"/api/cookiedunkdunk/accounts0.0.1/friends" // Method GET
#define kCookiedunkDunkAcceptGift                   @"/api/cookiedunkdunk/accounts0.0.1/acceptGift" // Method POST
#define kCookieDunkDunkUpdateCookieSettings         @"/api/cookiedunkdunk/accounts0.0.1/updateCookieSettings" // Method POST
// Leaderboard
#define kCookiedunkDunkLevelLeaderboardEndPoint     @"/api/cookiedunkdunk/leaderboard0.0.1/level" // Method POST

// cookie Costumes
#define kCookieDunkDunkUpdateCookieCostumesEndPoint @"/api/cookie/cookieCostumes0.0.1/updateCookieCostumes" // Method POST

// Update Game Parameters
#define kCookiedunkDunkGameParametersEndPoint       @"/api/cookiedunkdunk/accounts0.0.1/gameparameters" // Method POST

// Gifts
#define kCookiedunkDunkGiftFriendEndPoint           @"/api/cookiedunkdunk/gifts0.0.1" // Method POST

// Cookie Packs
#define kCookieDunkDunkShowCookiePacksEndPoint      @"/api/cookiedunkdunk/cookiePacks0.0.1" // Method PUT

// Time
#define kCookieDunkDunkTimeEndPoint                              @"/api/cookiedunkdunk/time0.0.1" // Method POST
#define kCookieDunkDunkRetrieveLivesRegenerationTimeEndPoint     @"/api/cookiedunkdunk/time0.0.1/%@/lives" //Method GET
#define kCookieDunkDunkUpdateLivesRegenerationTimeEndPoint       @"/api/cookiedunkdunk/time0.0.1/lives" //Method POST
#define kCookieDunkDunkRetrieveAwardRegenerationTimeEndPoint     @"/api/cookiedunkdunk/time0.0.1/%@/award" //Method GET 
#define kCookieDunkDunkUpdateAwardRegenerationTimeEndPoint       @"/api/cookiedunkdunk/time0.0.1/award" //Method POST

// Multipliers
#define kCookieDunkDunkMultipliersEndPoint          @"/api/cookiedunkdunk/multipliers0.0.1"

// Notifications

#define kCookieDunkDunkNotificationsEndPoint        @"/api/cookiedunkdunk/%@/notifications0.0.1" // Methods SHOW, DELETE, Pass in account id


//NSString *const kCookieDunkDunkAPIHost = @"http://JOSHS.local:8080";
//NSString *const kCookieDunkDunkAPIHost = @"http://Terminator.local:8080";
//NSString *const kCookieDunkDunkAPIHost = @"http://McGee.local:8080";
//NSString *const kCookieDunkDunkAPIHost = @"http://Nates-Mac-mini.local:8080";

#if DevModeActivated
    NSString *const kCookieDunkDunkAPIHost = @"http://stage.cookiedunkdunk.com"; // Staging Server
#else
    NSString *const kCookieDunkDunkAPIHost = @"http://api.cookiedunkdunk.com"; // Production Server
#endif






NSString *const kUpdatedAccountNotification = @"kUpdatedAccountNotification";

@interface WebserviceManager ()
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSCache *imageCache;
@end

@implementation WebserviceManager

static WebserviceManager *sharedManager = nil;

+ (WebserviceManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [WebserviceManager new];
        sharedManager.operationQueue = [NSOperationQueue new];
        sharedManager.imageCache = [[NSCache alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Error Handler

//- (void)showPopUpWithError:(NSError *)error
//{
//    if (error) {
//        NSDictionary *errorDict = [error userInfo];
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error"
//                                                            message: @""
//                                                           delegate:nil
//                                                  cancelButtonTitle: @"OK"
//                                                  otherButtonTitles:nil];
//        
//        [alertView show];
//    }
//}

#pragma mark - Cookie Costumes

/*
 // Key Values currentSelectedCookieID, isSelected, isUnlocked, newlySelectedCookieId
 
 [updateCookieCostumes addObject:@{
 @"currentSelectedCookieId": @"53534b30d43fe94d134f5abb",
 @"isSelected": [NSNumber numberWithBool:YES], 
 @"isUnlocked": [NSNumber numberWithBool:YES], 
 @"newlySelectedCookieId": @"53534b30d43fe94d134f5ac2"}];
 */

- (void)requestToUpdateCookieCostumesWithEmail:(NSString *)email
                                      deviceId:(NSString *)deviceId
                                cookieCostumes:(NSMutableArray *)cookieCostumes
                             completionHandler:(CookieCostumesCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    
    if (deviceId) params[@"deviceID"] = deviceId;
    
    if (cookieCostumes) params[@"cookieCostumes"] = cookieCostumes;
    
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkUpdateCookieCostumesEndPoint method:@"POST"
                          completionHandler:^
     (NSDictionary *dictionary, NSError *error)
     {
         [self refreshAccountWithUpdatedGameParamters:dictionary];
         if (handler) handler(error, dictionary);
     }];
}

#pragma mark - AcceptGift

- (void)requestAcceptGiftWithEmail:(NSString *)email
                          deviceId:(NSString *)deviceId
                        parameters:(NSMutableDictionary *)parameters
                 completionHandler:(AcceptGiftCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    
    if (deviceId) params[@"deviceID"] = deviceId;
    
    if (parameters) params[@"parameters"] = parameters;
    
    [self makeRequestToWebserviceWithParams:params url:kCookiedunkDunkAcceptGift method:@"POST"
                          completionHandler:^
     (NSDictionary *dictionary, NSError *error)
     {
         [self refreshAccountWithUpdatedGameParamters:dictionary];
         if (handler) handler(error, dictionary);
     }];
}

#pragma mark - Time

- (void)requestServerTimeWithMinutes:(NSNumber *)minutes completionHandler:(TimeCompletionHandler)handler
{
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingString:kCookieDunkDunkTimeEndPoint]];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (minutes) params[@"minutes"] = minutes;
    
    DebugLog(@"requestServerTime has been hit");
    
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
//    [request setTimeoutInterval:kCookieDunkDunkRequestTimeOutInterval];
//    
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"GET"];

    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"POST" dictionaryParams:params];

    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
             
                  NSDictionary *timeDict = nil;
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      //data returns a dictionary with a time property that has the milliseconds since January 1st 1970
                      timeDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      DebugLog(@"Time Dict: %@", timeDict);
                  }
                  
                  if (handler) handler(connectionError, timeDict);
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

- (void)requestLivesRegenerationTimeWithAccountId:(NSString *)accountId
                                completionhandler:(TimeCompletionHandler)handler
{
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookieDunkDunkRetrieveLivesRegenerationTimeEndPoint, accountId]];
    
    DebugLog(@"requestURL: %@", requestURL);
    
    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"GET" dictionaryParams:nil];
    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *regenerationTime = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      regenerationTime = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      DebugLog(@"regenerationTime = %@", regenerationTime);
                  }
                  
                  if (handler) handler(connectionError, regenerationTime);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

- (void)requestToUpdateLivesRegenerationTimeWithAccountId:(NSString *)accountId
                                                  minutes:(NSNumber *)minutes
                                        completionhandler:(TimeCompletionHandler)handler;
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (minutes) params[@"minutes"] = minutes;
    if (accountId) params[@"id"] = accountId;
    
    
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkUpdateLivesRegenerationTimeEndPoint method:@"POST" completionHandler:^
     (NSDictionary *dictionary, NSError *error)
     {
         DebugLog(@"regenerationTime = %@", dictionary);
         
         if (!error && dictionary)
         {
             [self refreshAccountWithUpdatedGameParamters:dictionary];
             
         }
         if (handler) handler(error, dictionary);
     }];
}

-(void)requestAwardRegenerationTimeWithAccountId:(NSString *)accountId
                           completionhandler:(TimeCompletionHandler)handler
{
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookieDunkDunkRetrieveAwardRegenerationTimeEndPoint, accountId]];
    
    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"GET" dictionaryParams:nil];
    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *regenerationTime = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      regenerationTime = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      DebugLog(@"regenerationTime = %@", regenerationTime);
                  }
                  
                  if (handler) handler(connectionError, regenerationTime);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

-(void)requestToUpdateAwardRegenerationTimeWithAccountId:(NSString *)accountId
                                                 minutes:(NSNumber *)minutes
                                       completionhandler:(TimeCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (minutes) params[@"minutes"] = minutes;
    if (accountId) params[@"id"] = accountId;
    
    
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkUpdateAwardRegenerationTimeEndPoint method:@"POST" completionHandler:^
     (NSDictionary *dictionary, NSError *error)
     {
         DebugLog(@"regenerationTime = %@", dictionary);
         
         if (!error && dictionary)
         {
             [self refreshAccountWithUpdatedGameParamters:dictionary];
             
         }
         if (handler) handler(error, dictionary);
     }];
}


#pragma mark - Images

- (void)requestImageAtURL:(NSURL *)url completionHandler:(ImageRequestCompletionHandler)handler {
    
    UIImage *image = [self.imageCache objectForKey:url.absoluteString];
    if (image) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, nil, image);
                
            });
        }
        return;
    }
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kCookieDunkDunkRequestTimeOutInterval];
    
    NSBlockOperation *op = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = op;
    [weakOp addExecutionBlock:^{
        if (![weakOp isCancelled]) {
            [NSURLConnection sendAsynchronousRequest:imageRequest
                                               queue:self.operationQueue
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *error)
             {
                 __strong UIImage *image = nil;
                 if (data) {
                     image = [UIImage imageWithData:data scale:1.0f];
                 }
                 
                 if (handler) {
                     handler(error, nil, image);
                 }
             }];
        }
    }];
    [self.operationQueue addOperation:op];
}

- (void)requestImageAtURL:(NSURL *)url indexPath:(NSIndexPath *)indexPath completionHandler:(ImageRequestWithIndexCompletionHandler)handler
{
    UIImage *image = [self.imageCache objectForKey:url.absoluteString];
    if (image) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(image, indexPath, nil);
            });
            
        }
        return;
    }
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kCookieDunkDunkRequestTimeOutInterval];
    
    NSBlockOperation *op = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = op;
    [weakOp addExecutionBlock:^{
        if (![weakOp isCancelled]) {
            [NSURLConnection sendAsynchronousRequest:imageRequest
                                               queue:self.operationQueue
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *error)
             {
                 //                 NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                 //                 NSInteger statusCode = [urlResponse statusCode];
                 //                 DebugLog(@"Request image at URL 02 Response Code => %d", statusCode);
                 
                 UIImage *image = nil;
                 if (data) {
                     image = [UIImage imageWithData:data scale:1.0f];
                 }
                 
                 if (handler) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         handler(image, indexPath, error);
                     });
                 }
             }];
        }
    }];
    [self.operationQueue addOperation:op];
}

- (void)requestMaskImageAtIndexPath:(NSIndexPath *)indexPath
                          imageData:(NSData *)imageData
                        imageToMask:(UIImageView *)imageToMask
                          maskImage:(UIImage *)maskImage
                  completionHandler:(ImageMaskRequestSocialCompletionHandler)handler
{
    NSError *error = nil;
    UIImage *userImage = [UIImage imageWithData:imageData];
    imageToMask.image = userImage;
    UIImage *croppedImage = [self cropPhoto:imageToMask withMaskedImage:maskImage];
    
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       if (handler)
                       {
                           handler(error, indexPath, croppedImage);
                       }
                   });
}

- (UIImage *)cropPhoto:(UIImageView *)imageToCrop withMaskedImage:(UIImage *)maskedImage
{
    //UIGraphicsBeginImageContextWithOptions(imageToCrop.frame.size, YES, [UIScreen mainScreen].scale);
    
    //[imageToCrop.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //UIImage *pickImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //CGRect imageFrame = CGRectMake(imageToCrop.frame.size.width * 0.5f, imageToCrop.frame.size.height * 0.5f, imageToCrop.frame.size.width, imageToCrop.frame.size.height);
    
    //CGRect imageFrame = CGRectMake(0, 0, pickImage.size.width, pickImage.size.height);
    
    //UIGraphicsEndImageContext();
    
    //CGImageRef imageRef = CGImageCreateWithImageInRect(pickImage.CGImage, imageFrame);
    
    CGRect imageFrame = CGRectMake(0, 0, imageToCrop.frame.size.width, imageToCrop.frame.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageToCrop.image.CGImage, imageFrame);
    CGImageRef maskRef = maskedImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask(imageRef, mask);
    CGImageRelease(mask);
    CGImageRelease(imageRef);
    UIImage *newImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);

    return newImage;
}


#pragma mark - Accounts

- (void)requestToCreateAccountWithEmail:(NSString *)email
                               deviceId:(NSString *)deviceId
                              firstName:(NSString *)firstName
                               lastName:(NSString *)lastName
                                 gender:(NSString *)gender
                              birthdate:(NSDate *)birthdate
                             facebookID:(NSString *)facebookID
                               deviceToken:(NSString *)deviceToken
                  profileImageStringURL:(NSString *)profileImageStringURL
                      completionHandler:(AccountsCreateCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (firstName) params[@"firstName"] = firstName;
    if (lastName) params[@"lastName"] = lastName;
    if (email) params[@"email"] = email;
    if (gender) params[@"gender"] = gender;
    //if (birthdate) params[@"birthdate"] = birthdate;
    if (profileImageStringURL) params[@"profileAvatar"] = profileImageStringURL;
    if (facebookID) params[@"facebookID"] = facebookID;
    if (deviceToken) params[@"deviceToken"] = deviceToken;
    if (deviceId) params[@"deviceID"] = deviceId;
    params[@"isIOSApp"] = [NSNumber numberWithBool:YES];
    
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkAccountsEndPoint method:@"POST" completionHandler:^
     (NSDictionary *dictionary, NSError *error)
    {
        if (handler) handler(dictionary, error);
    }];
    
}

- (void)requestToUpdateAccountWithEmail:(NSString *)email
                               deviceId:(NSString *)deviceId
                              firstName:(NSString *)firstName
                               lastName:(NSString *)lastName
                                 gender:(NSString *)gender
                              birthdate:(NSDate *)birthdate
                             facebookID:(NSString *)facebookID
                         didRecieveGift:(NSNumber *)didRecieveGift
                      completionHandler:(AccountsCreateCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (firstName) params[@"firstName"] = firstName;
    if (lastName) params[@"lastName"] = lastName;
    if (email) params[@"email"] = email;
    if (gender) params[@"gender"] = gender;
    //if (birthdate) params[@"birthdate"] = birthdate;
    if (facebookID) params[@"facebookID"] = facebookID;
    if (didRecieveGift) params[@"didRecieveGift"] = didRecieveGift;
    if (deviceId) params[@"deviceID"] = deviceId;

    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkAccountsEndPoint method:@"PUT" completionHandler:^
     (NSDictionary *dictionary, NSError *error)
    {
        if (!error && dictionary)
        {
            [self refreshAccountWithUpdatedGameParamters:dictionary];

        }
        if (handler) handler(dictionary, error);
    }];
    
}

- (void)requestToUpdateAccountWithParams:(NSMutableDictionary *)params completionHandler:(AccountsCreateCompletionHandler)handler
{
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkAccountsEndPoint method:@"PUT" completionHandler:^
     (NSDictionary *dictionary, NSError *error)
     {
         if (handler) handler(dictionary, error);
     }];
}

- (void)requestToFetchAccountWithAccountId:(NSString *)accountId completionHandler:(UpdatedAccountCompletionHandler)handler
{
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookieDunkDunkAccountsEndPointFMT, accountId]];
    
    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"GET" dictionaryParams:nil];
    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *accountDict = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      //DebugLog(@"accountDict = %@", accountDict);
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

- (void)requestToDeleteAccountWithEmail:(NSString *)email
                               deviceId:(NSString *)deviceId
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    
    if (deviceId) params[@"deviceID"] = deviceId;
    
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkAccountsEndPoint method:@"DELETE" completionHandler:nil];
}

#pragma mark - WORLD
- (void)updateWorldParametersWithEmail:(NSString *)email
                              deviceId:(NSString *)deviceId
                             worldType:(NSNumber *)worldType
                             worldName:(NSString *)worldName
                     completionHandler:(WorldCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    if (deviceId) params[@"deviceID"] = deviceId;
    if (worldType) params[@"worldType"] = worldType;
    if (worldName) params[@"worldName"] = worldName;
    
    if (worldName) params[@"worldName"] = worldName;
    
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkWorldsEndPoint method:@"POST"
                          completionHandler:^
     (NSDictionary *dictionary, NSError *error)
     {
         if (!error && dictionary) {
             if (dictionary[@"error"]) {
                 DebugLog(@"Error updating world paramaters: '%@'", dictionary[@"error"]);
             }
             else {
                 [self refreshAccountWithUpdatedGameParamters:dictionary];
             }
         }
         else if (error) {
             DebugLog(@"Error updating world paramaters: '%@'", error.description);
         }
         else {
             DebugLog(@"Warning: No dictionary returned to refresh the user account with.");
         }
         
        if (handler) handler(error, dictionary);
    }];
}

#pragma mark - Levels

- (void)updateLevelParametersWithEmail:(NSString *)email
                              deviceId:(NSString *)deviceId
                             worldType:(NSNumber *)worldType
                             worldName:(NSString *)worldName
                             levelType:(NSNumber *)levelType
                             starCount:(NSNumber *)starCount
                             highScore:(NSNumber *)highScore
                     completionHandler:(LevelCompletionHandler)handler
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    
    if (deviceId) params[@"deviceID"] = deviceId;
    
    if (worldType) params[@"worldType"] = worldType;
    
    if (levelType) params[@"levelType"] = levelType;
    
    if (starCount) params[@"starCount"] = starCount;
   
    if (highScore) params[@"highScore"] = highScore;
    
    if (worldName) params[@"worldName"] = worldName;
    
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkLevelsEndPoint  method:@"POST"
                          completionHandler:^
     (NSDictionary *dictionary, NSError *error)
    {
        if (!error && dictionary) {
            if (dictionary[@"error"]) {
                DebugLog(@"Error updating level paramaters: '%@'", dictionary[@"error"]);
            }
            else {
                [self refreshAccountWithUpdatedGameParamters:dictionary];
            }
        }
        else if (error) {
            DebugLog(@"Error updating level paramaters: '%@'", error.description);
        }
        else {
            DebugLog(@"Warning: No dictionary returned to refresh the user account with.");
        }
        
        if (handler) handler(error, dictionary);
    }];
    
}

#pragma mark - Cookie Settings

// type, theme, cookieIndex, _id
- (void)requestToUpdateCokieSettingsWithEmail:(NSString *)email
                                     deviceId:(NSString *)deviceId
                               cookieSettings:(NSMutableArray *)cookieSettings
                            completionHandler:(CookieSettingsCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    
    if (deviceId) params[@"deviceID"] = deviceId;
    
    if (cookieSettings) params[@"cookieSettings"] = cookieSettings;
    
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkUpdateCookieSettings  method:@"POST" completionHandler:^
     (NSDictionary *dictionary, NSError *error)
    {
        [self refreshAccountWithUpdatedGameParamters:dictionary];
        if (handler) handler(error, dictionary);
    }];
}

#pragma mark - Multipliers

- (void)requestToCreateMultiplierWithEmail:(NSString *)email
                                  deviceId:(NSString *)deviceId
                            multiplierType:(NSString *)multiplierType
                                 startTime:(NSString *)startTime
                                   endTime:(NSString *)endTime
                                    levels:(NSString *)levels
                                  gemCosts:(NSNumber *)gemCosts
                                 coinCosts:(NSNumber *)coinCosts
                         completionHandler:(MultipliersCompletionHandler)handler
{
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingString:kCookieDunkDunkMultipliersEndPoint]];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    
    if (deviceId) params[@"deviceID"] = deviceId;
    
    if (multiplierType) params[@"type"] = multiplierType;
    
    if (startTime) params[@"startTime"] = startTime;
    
    if (endTime) params[@"endTime"] = endTime;
    
    if (levels) params[@"levels"] = levels;
    
    if (gemCosts) params[@"gems"] = gemCosts;
    
    if (coinCosts) params[@"coins"] = coinCosts;
    
    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"POST" dictionaryParams:params];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    [request setHTTPBody:postData];
    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *accountDict = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      NSDictionary *parametersDict = [NSDictionary new];
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      if (accountDict[@"parameters"]) parametersDict = accountDict[@"parameters"];
                      [self refreshAccountWithUpdatedGameParamters:parametersDict];
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

- (void)requestToRemoveMultiplierWithEmail:(NSString *)email
                                  deviceId:(NSString *)deviceId
                              multiplierId:(NSString *)multiplierId
                         completionHandler:(MultipliersCompletionHandler)handler
{
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingString:kCookieDunkDunkMultipliersEndPoint]];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    
    if (deviceId) params[@"deviceID"] = deviceId;

    if (multiplierId) params[@"multiplierID"] = multiplierId;

    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"DELETE" dictionaryParams:params];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    [request setHTTPBody:postData];
    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  NSDictionary *accountDict = nil;
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      [self refreshAccountWithUpdatedGameParamters:accountDict];
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

#pragma mark - Minigames

- (void)updateMiniGameParametersWithEmail:(NSString *)email
                                 deviceId:(NSString *)deviceId
                                     name:(NSString *)name
                                     type:(NSNumber *)type
                                    world:(NSString *)world
                                starCount:(NSNumber *)starCount
                                highScore:(NSNumber *)highScore
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    
    if (deviceId) params[@"deviceID"] = deviceId;
    
    if (type) params[@"type"] = type;
    
    if (name) params[@"name"] = name;
    
    if (world) params[@"world"] = world;
    
    if (starCount) params[@"starCount"] = starCount;
        
    if (highScore) params[@"highScore"] = highScore;
    
//    DebugLog(@"Params From MiniGame Parameters %@", params);
    
    [self makeRequestToWebserviceWithParams:params url:kCookieDunkDunkMiniGamesEndPoint  method:@"POST" completionHandler:nil];
}

- (NSMutableURLRequest *)createAuthorizedRequestWithURL:(NSURL *)url
                                                 method:(NSString *)method
                                       dictionaryParams:(NSDictionary *)params
{
    float requestTimeStamp = [[NSDate date] timeIntervalSince1970];
    //Just trying to see what format the date is
    NSLog(@"requestTimeStamp: %f", requestTimeStamp);
    NSString *timeStampString = [NSString stringWithFormat:@"%.2lf", requestTimeStamp];
    
    NSMutableString *stringToSign = [[NSMutableString alloc] init];
    [stringToSign appendFormat:@"%@\n", method];
    [stringToSign appendString:@"\n"];
    [stringToSign appendString:@"\n"];
    [stringToSign appendFormat:@"%@\n", timeStampString];
    if ([url query].length > 0) {
        [stringToSign appendFormat:@"%@?%@", [url path], [url query]];
    } else {
        [stringToSign appendFormat:@"%@", [url path]];
    }
    
    DebugLog(@"String to sign => %@", stringToSign);
    
    NSString *sigDigest = [stringToSign stringDigestUsingHmacSha256WithKey:kCookieDDSecret];
    DebugLog(@"Digest => %@", sigDigest);
    
    NSString *authParam = [NSString stringWithFormat:@"OID %@:%@", kCookieDDAppID, [[sigDigest dataUsingEncoding:NSUTF8StringEncoding] encodedBase64String]];
    
    NSMutableURLRequest *authorizedRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [authorizedRequest setTimeoutInterval:kCookieDunkDunkRequestTimeOutInterval];
    [authorizedRequest addValue:timeStampString forHTTPHeaderField:@"Date"];
    [authorizedRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [authorizedRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [authorizedRequest addValue:authParam forHTTPHeaderField:@"Authorization"];
    [authorizedRequest setHTTPMethod:method];
    
    if (params) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        [authorizedRequest setHTTPBody:postData];
    }
    
    
    return authorizedRequest;
}


- (void)makeRequestToWebserviceWithParams:(NSMutableDictionary *)params
                                      url:(NSString *)url
                                   method:(NSString *)method
                        completionHandler:(GenericCompletionHandler)handler
{
    
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingString:url]];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    
    DebugLog(@"Params From Cookie Settings %@", postData);
    
    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:method dictionaryParams:params];
    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *accountDict = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      //DebugLog(@"data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                      //DebugLog(@"accountDict = %@", accountDict);
                      //DebugLog(@"error = %@", connectionError);
                      //DebugLog(@"parameters = %@", params);
                  }
                  
                  if (handler) handler(accountDict, connectionError);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

//===========================
//Socket.IO Methods
//===========================

//- (void)connectToSocketIOServer
//{
//    //create socket.io client instance
//    _socketIO = [[SocketIO alloc] initWithDelegate:self];
//    
//    //connect to socket.io server
//    [_socketIO connectToHost:@"localhost" onPort:8080];
//}


//#pragma mark socket.io-obj delegate methods
//
//- (void)socketIODidConnect:(SocketIO *)socket
//{
//    DebugLog(@"socket.io connected");
//    
//}
//
//- (void)socketIO:(SocketIO *)socket onError:(NSError *)error
//{
//    DebugLog(@"onError() %@", error);
//}
//
//- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
//{
//    DebugLog(@"socket.io disconnected. Did error occur? %@", error);
//}
//
//- (void)updateGameParametersWithEmail:(NSString *)email
//                                 type:(NSString *)type
//                                value:(NSNumber *)value
//{
////    NSDictionary *gameParameters = [NSDictionary dictionaryWithObjectsAndKeys:
////                                    email, @"email",
////                                    type, @"type",
////                                    value, @"value",
////                                    @"gameParameters", @"command"
////                                    , nil];
//    
//    NSDictionary *gameParameters = @{@"email": email,
//                                    @"type": type,
//                                    @"value": value,
//                                    @"cmd": @"gameParameters"};
//   
//    DebugLog(@"Your gameParameters are %@", gameParameters);
//    
//    //Send game parameters to socket.io server
//    [_socketIO sendJSON:gameParameters];
//}

#pragma mark - Update Game Parameters

- (void)requestToUpdateGameParametersWithEmail:(NSString *)accountEmail
                                      deviceId:(NSString *)deviceId
                                gameParamsDict:(NSMutableDictionary *)gameParams
                             completionHandler:(GameParametersCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (accountEmail) params[@"email"] = accountEmail;
    
    if (deviceId) params[@"deviceID"] = deviceId;
    
    if (gameParams) params[@"parameters"] = gameParams;
    
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookiedunkDunkGameParametersEndPoint]];

    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"POST" dictionaryParams:params];

    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *accountDict = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      
                      NSDictionary *parametersDict = nil;
                      if (accountDict[@"parameters"]) parametersDict = accountDict[@"parameters"];
                      [self refreshAccountWithUpdatedGameParamters:parametersDict];
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

- (void)refreshAccountWithUpdatedGameParamters:(NSDictionary *)updatedGameParametersInfoDict
{
    // Update Coins, Gems, Moves, And Lives....
    
    if (updatedGameParametersInfoDict[@"coins"] && [SGAppDelegate appDelegate].accountDict[@"coins"]) [SGAppDelegate appDelegate].accountDict[@"coins"] = updatedGameParametersInfoDict[@"coins"];
    
    if (updatedGameParametersInfoDict[@"gems"] && [SGAppDelegate appDelegate].accountDict[@"gems"]) [SGAppDelegate appDelegate].accountDict[@"gems"] = updatedGameParametersInfoDict[@"gems"];
    if (updatedGameParametersInfoDict[@"moves"] && [SGAppDelegate appDelegate].accountDict[@"moves"]) [SGAppDelegate appDelegate].accountDict[@"moves"] = updatedGameParametersInfoDict[@"moves"];
    if (updatedGameParametersInfoDict[@"lives"] && [SGAppDelegate appDelegate].accountDict[@"lives"]) [SGAppDelegate appDelegate].accountDict[@"lives"] = updatedGameParametersInfoDict[@"lives"];
    
    // Update Boosters....
    
    NSMutableDictionary *boosterDict = [NSMutableDictionary new];
    if ([SGAppDelegate appDelegate].accountDict[@"boosters"]) boosterDict = [[SGAppDelegate appDelegate].accountDict[@"boosters"] mutableCopy];
    if (updatedGameParametersInfoDict[@"radioactiveSprinkle"] && boosterDict[@"radioactiveSprinkle"]) boosterDict[@"radioactiveSprinkle"] = updatedGameParametersInfoDict[@"radioactiveSprinkle"];
    if (updatedGameParametersInfoDict[@"slotMachine"] && boosterDict[@"slotMachine"]) boosterDict[@"slotMachine"] = updatedGameParametersInfoDict[@"slotMachine"];
    if (updatedGameParametersInfoDict[@"spatula"] && boosterDict[@"spatula"]) boosterDict[@"spatula"] = updatedGameParametersInfoDict[@"spatula"];
    if (updatedGameParametersInfoDict[@"thunderbolt"] && boosterDict[@"thunderbolt"]) boosterDict[@"thunderbolt"] = updatedGameParametersInfoDict[@"thunderbolt"];
    if (updatedGameParametersInfoDict[@"nuke"] && boosterDict[@"nuke"]) boosterDict[@"nuke"] = updatedGameParametersInfoDict[@"nuke"];
  
    NSMutableDictionary *mutableAccountDict = nil;
    if ([SGAppDelegate appDelegate].accountDict) mutableAccountDict = [[SGAppDelegate appDelegate].accountDict mutableCopy];
    
    if (mutableAccountDict[@"boosters"]) mutableAccountDict[@"boosters"] = boosterDict;
    if ([SGAppDelegate appDelegate].accountDict) [SGAppDelegate appDelegate].accountDict = mutableAccountDict;
    
    
    // Update Powerups....
    NSMutableDictionary *powerupsDict = [NSMutableDictionary new];
    if ([SGAppDelegate appDelegate].accountDict[@"powerups"]) powerupsDict = [[SGAppDelegate appDelegate].accountDict[@"powerups"] mutableCopy];
    if (updatedGameParametersInfoDict[@"bomb"] && powerupsDict[@"bomb"]) powerupsDict[@"bomb"] = updatedGameParametersInfoDict[@"bomb"];
    if (updatedGameParametersInfoDict[@"powerGlove"] && powerupsDict[@"powerGlove"]) powerupsDict[@"powerGlove"] = updatedGameParametersInfoDict[@"powerGlove"];
    if (updatedGameParametersInfoDict[@"smore"] && powerupsDict[@"smore"]) powerupsDict[@"smore"] = updatedGameParametersInfoDict[@"smore"];
    if (updatedGameParametersInfoDict[@"wrappedCookie"] && powerupsDict[@"wrappedCookie"]) powerupsDict[@"wrappedCookie"] = updatedGameParametersInfoDict[@"wrappedCookie"];
   
    if (mutableAccountDict[@"powerups"] && powerupsDict) mutableAccountDict[@"powerups"] = powerupsDict;
    if ([SGAppDelegate appDelegate].accountDict) [SGAppDelegate appDelegate].accountDict = mutableAccountDict;
    
    if (updatedGameParametersInfoDict[@"account"]) [SGAppDelegate appDelegate].accountDict = [updatedGameParametersInfoDict[@"account"] mutableCopy];
    
    // Update Multipliers....
    
    if (updatedGameParametersInfoDict[@"multiplier"]) {
        
        NSDictionary *multiplierDict = updatedGameParametersInfoDict[@"multiplier"];
        
        // THIS THING!!!!
        NSMutableArray *multipliers;// = [NSMutableArray new];
        
        if ([SGAppDelegate appDelegate].accountDict[@"multipliers"])
        {
            multipliers = [NSMutableArray arrayWithArray:[[SGAppDelegate appDelegate].accountDict[@"multipliers"] mutableCopy]];
            
            if ([multipliers isKindOfClass:[NSMutableArray class]])
            {
                [multipliers addObject:multiplierDict];
                
                [SGAppDelegate appDelegate].accountDict[@"multipliers"] = multipliers;
            }
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatedAccountNotification object:nil];
}

- (void)refreshAccountWithUpdatedLevel:(NSDictionary *)level worldType:(NSNumber *)worldType
{
    // >>> Save this for later. <<<
    
//    // Update Levels...
//    if ([SGAppDelegate appDelegate].accountDict[@"worlds"])
//    {
//        NSMutableArray *worldsArray = [[SGAppDelegate appDelegate].accountDict[@"worlds"] mutableCopy];
//        
//        if ([worldsArray count] > 0)
//        {
//            NSPredicate *worldFilterPredicate = [NSPredicate predicateWithFormat:@"type == %i", [worldType intValue]];
//           
//            NSArray *worlds = [worldsArray filteredArrayUsingPredicate:worldFilterPredicate];
//            
//            if ([worlds count] > 0)
//            {
//                NSMutableDictionary *worldInfoDict = [worlds[0] mutableCopy];
//                
//                if (worldInfoDict[@"levels"])
//                {
//                    NSMutableArray *levelsArray = worldInfoDict[@"levels"];
//                    
//                    if (level[@"type"])
//                    {
//                        int type = [level[@"type"] intValue];
//                     
//                        NSPredicate *levelsFilterPredicate = [NSPredicate predicateWithFormat:@"type == %i", type];
//                        
//                        NSMutableArray *levels = [[levelsArray filteredArrayUsingPredicate:levelsFilterPredicate] mutableCopy];
//                        
//                        if ([levels count] > 0)
//                        {
//                            NSMutableDictionary *levelInfoDict = [levels[0] mutableCopy];
//                            
//                            levelInfoDict = [level mutableCopy];
//                            
//                            
////                            for (NSDictionary *level in levelsArray)
////                            {
////                                
////                            }
//                        }
//                        else
//                        {
//                            [levelsArray addObject:level];
//                            
//                            [SGAppDelegate appDelegate].accountDict[@"worlds"] = worldsArray;
//                        }
//                        
//                    }
//                }
//            }
//            
//        }
//    }
}


#pragma mark - Powerups

- (void)requestToUpdateAccountPowerUpsWithAccountEmail:(NSString *)email
                                              deviceId:(NSString *)deviceId
                                          powerupsDict:(NSMutableDictionary *)powerupsDict
                                     completionHandler:(UpdatedAccountCompletionHandler)handler
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    
    if (deviceId) params[@"deviceID"] = deviceId;
    
    if (powerupsDict[@"bomb"]) params[@"bomb"] = powerupsDict[@"bomb"];
    
    if (powerupsDict[@"superhero"]) params[@"superhero"] = powerupsDict[@"superhero"];
    
    if (powerupsDict[@"wrappedCookie"]) params[@"wrappedCookie"] = powerupsDict[@"wrappedCookie"];
    
    if (powerupsDict[@"_id"]) params[@"ID"] = powerupsDict[@"_id"];
    
    if (powerupsDict[@"coins"]) params[@"coins"] = powerupsDict[@"coins"];
    
    if (powerupsDict[@"gems"]) params[@"gems"] = powerupsDict[@"gems"];
    
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookieDunkDunkUpdatePowerupsEndpoint]];

    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"POST" dictionaryParams:params];

    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *accountDict = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

#pragma mark - Boosters

- (void)requestToUpdateAccountBoostersWithAccountEmail:(NSString *)email
                                              deviceId:(NSString *)deviceId
                                          boostersDict:(NSMutableDictionary *)boostersDict
                                     completionHandler:(UpdatedAccountCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (email) params[@"email"] = email;
    if (boostersDict[@"radioactiveSprinkle"]) params[@"radioactiveSprinkle"] = boostersDict[@"radioactiveSprinkle"];
    if (boostersDict[@"spatula"]) params[@"spatula"] = boostersDict[@"spatula"];
    if (boostersDict[@"slotMachine"]) params[@"slotMachine"] = boostersDict[@"slotMachine"];
    if (boostersDict[@"_id"]) params[@"ID"] = boostersDict[@"_id"];
    if (boostersDict[@"coins"]) params[@"coins"] = boostersDict[@"coins"];
    if (boostersDict[@"gems"]) params[@"gems"] = boostersDict[@"gems"];
    
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookieDunkDunkUpdateBoostersEndPoint]];

    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"POST" dictionaryParams:params];

    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *accountDict = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}


#pragma mark - Friends

- (void)requestFriends:(NSMutableArray *)friendsIdArray completionHandler:(FriendsCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (friendsIdArray) params[@"facebookIds"] = friendsIdArray;
    
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookieDunkDunkShowFriendsEndPoint]];

    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"PUT" dictionaryParams:params];

    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;

    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *accountDict = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

#pragma mark - Leaderboard

- (void)requestLevelLeaderboardWithFacebookId:(NSString *)playerId
                               friendsIdArray:(NSMutableArray *)friendsIdArray
                                        world:(NSNumber *)world
                                        level:(NSNumber *)level
                            completionHandler:(LeaderboardCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (playerId)
    {
        params[@"playerFacebookId"] = playerId;
    }
    if (friendsIdArray)
    {
        params[@"facebookIds"] = friendsIdArray;
    }
    if (world)
    {
        params[@"world"] = world;
    }
    if (level)
    {
        params[@"level"] = level;
    }
    
    [self makeRequestToWebserviceWithParams:params url:kCookiedunkDunkLevelLeaderboardEndPoint  method:@"POST"
                          completionHandler:^
     (NSDictionary *dictionary, NSError *error)
     {
         if (!error && dictionary) {
             if (dictionary[@"error"]) {
                 DebugLog(@"Error retrieving leaderboard: '%@'", dictionary[@"error"]);
             }
             //DebugLog(@"Leaderboard: %@", dictionary);
         }
         else if (error) {
             DebugLog(@"Error retrieving leaderboard paramaters: '%@'", error.description);
         }
         else {
             DebugLog(@"Warning: No dictionary returned from leaderboard request.");
         }
         
         if (handler) handler(error, dictionary);
     }];
}

#pragma mark - Gifts

- (void)requestToGiftFriendWithAccountEmail:(NSString *)sender
                                friendEmail:(NSString *)recipient
                                   giftType:(NSString *)command
                                 giftAmount:(NSString *)value
                               giftCostType:(NSString *)giftCostType
                              giftCostValue:(NSNumber *)giftCostValue
                             giftingMessage:(NSString *)message
                          completionHandler:(GiftsCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (sender) params[@"sender"] = sender;
    if (recipient) params[@"recipient"] = recipient;
    if (command) params[@"command"] = command;
    if (value) params[@"value"] = value;
    if (giftCostType) params[@"giftCostType"] = giftCostType;
    if (giftCostValue) params[@"giftCostValue"] = giftCostValue;
    if (message) params[@"message"] = message;
    
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookiedunkDunkGiftFriendEndPoint]];

    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"POST" dictionaryParams:params];

    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  //                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  //                NSInteger statusCode = [urlResponse statusCode];
                  NSDictionary *accountDict = nil;
                  
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      [self refreshAccountWithUpdatedGameParamters:accountDict];
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

#pragma mark - Notifications

- (void)requestToShowNotificationsWithAccountId:(NSString *)accountId
                              completionHandler:(NotificationsCompletionHandler)handler
{
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookieDunkDunkNotificationsEndPoint, accountId]];
    
    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"GET" dictionaryParams:nil];
    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  NSDictionary *accountDict = nil;
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      DebugLog(@"notifications = %@", accountDict);
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

- (void)requestToRemoveNotificationsWithAccountId:(NSString *)accountId
                                  notificationIds:(NSMutableArray *)notificationIds
                                completionHandler:(NotificationsCompletionHandler)handler
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (notificationIds) params[@"notifications"] = notificationIds;
    
    NSURL *requestURL = [NSURL URLWithString:[kCookieDunkDunkAPIHost stringByAppendingFormat:kCookieDunkDunkNotificationsEndPoint, accountId]];
    
    NSMutableURLRequest *request = [self createAuthorizedRequestWithURL:requestURL method:@"DELETE" dictionaryParams:params];
    
    NSBlockOperation *op = [NSBlockOperation new];
    __weak NSBlockOperation *weakOp = op;
    
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:self.operationQueue
                                    completionHandler:^
              (NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  NSDictionary *accountDict = nil;
                  
                  if (connectionError && [connectionError code] == NSURLErrorCannotFindHost)
                  {
                      DebugLog(@"Error: could not find host.");
                  }
                  else if (connectionError && [connectionError code] == NSURLErrorTimedOut)
                  {
                      DebugLog(@"Error: timeout");
                  }
                  else if (data)
                  {
                      accountDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      DebugLog(@"notifications = %@", accountDict);
                  }
                  
                  if (handler) handler(connectionError, accountDict);
                  
              }];
         }
     }];
    
    [self.operationQueue addOperation:op];
}

@end
