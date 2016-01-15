
//  SGSocialManager.m

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

#import "SGSocialManager.h"
//#import "SHLocationSetupViewController.h"
#define kSocialClassRequstTimeOutInterval                  10.0f
#define TMP NSTemporaryDirectory()

NSString * const FaceBookAppKey              = @"467203473397188";
NSString * const SGSocialManagerErrorDomain    = @"SGSocialManagerErrorDomain";

// NOTE:
// YOU CAN PUT A LIMIT ON HOW MANY FIRENDS YOU WANT FROM FACEBOOK WITH QUERY WITH LIMIT "= me() LIMIT 25"
// @"SELECT uid, name, pic_square FROM user WHERE uid IN " @"(SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 25)"
//  if you need more information than what is retrieved from the query, YOU MUST ASK FOR PERMISSIONS DURING LOGIN PROCESS FOR SPECIFIC FRIEND INFORMATION SUCH AS TIMEZONE FOR EXAMPLE
// THEN PASS IT IN THE QUERY "uid, name, hometown_location, pic_square"
/*search query
 SELECT uid, username, first_name, last_name FROM user WHERE uid IN
 (SELECT uid2 FROM friend WHERE uid1 = me()) AND first_name = 'tim'
 */
/*
 NSString *fql = [NSString stringWithFormat:@"SELECT name,uid, pic_small FROM user WHERE is_app_user = 1 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = %@) order by concat(first_name,last_name) asc",userId,userId]];
 
 NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:fql ,@"query", [facebook accessToken], @"access_token", nil];
 
 [facebook requestWithMethodName:@"fql.query" andParams:params andHttpMethod:@"GET" andDelegate:self];
 
 //this query works for filter all facebook
 //    NSString *query = [NSString stringWithFormat:@"SELECT uid, username, name, pic_square FROM user WHERE contains('%@')", self.searchTextField.text];
 
 */
//@"Select name, uid, pic_small from user where is_app_user = 1 and  uid in (select uid2 from friend where uid1 = me()) order by concat(first_name,last_name) asc"


//"SELECT name,uid, pic_small FROM user WHERE is_app_user = 1 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = %@) order by concat(first_name,last_name
NSString *const FacebookTypeQuery = @"SELECT uid, name, first_name, hometown_location, pic_square FROM user WHERE uid IN " @"(SELECT uid2 FROM friend WHERE uid1 = me())";
NSString *const FacebookTypeMultiQuery =   @"{"
@"'friends':'SELECT uid2 FROM friend WHERE uid1 = me() ',"
@"'friendinfo':'SELECT uid, name, first_name, hometown_location, pic_square FROM user WHERE uid IN (SELECT uid2 FROM #friends)',"
@"}";                                               // SELECT uid, name, first_name, hometown_location, pic_square FROM user WHERE has_added_app = 1
NSString *const FacebookTypeQueryFriendsHaveApp = @"SELECT uid, name, first_name, hometown_location, pic_square FROM user WHERE is_app_user = 1 AND uid IN " @"(SELECT uid2 FROM friend WHERE uid1 = me())";

NSString *const FacebookTypeQueryFriendsDontHaveApp = @"SELECT uid, name, first_name, hometown_location,  pic_square FROM user WHERE is_app_user = 0 AND uid IN " @"(SELECT uid2 FROM friend WHERE uid1 = me())";
//SELECT uid FROM user
//WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = ?)
//AND is_app_user = 1

// SELECT daily_active_users, weekly_active_users, monthly_active_users
// FROM application WHERE app_id = APPLICATION_ID

NSString *const socialErrorMessage = @"Error: Cookie Dunk Dunk encountered an error and has been logged. Please try again shortly.";
//SELECT uid, name, pic_square FROM user WHERE has_added_app = 1 AND uid IN " + "(SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 200)

@interface SGSocialManager ()
@property (assign, nonatomic) int photoID;
@property (strong, nonatomic) NSOperationQueue *requestQueue;
@property (strong, nonatomic) NSOperationQueue *imageRequestQueue;
@property (strong, nonatomic) NSMutableArray *contactsArray;
@property (strong, nonatomic) UIViewController *viewController;
@end

@implementation SGSocialManager


/*
 These method is for registering login process with facebook
 */

+ (SGSocialManager *) socialManager
{
    static SGSocialManager *socialManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
      {
          socialManager = [[SGSocialManager alloc] init];
          socialManager.accountStore = [[ACAccountStore alloc]init];
          socialManager.facebookAccount = [[ACAccount alloc] init];
          socialManager.requestQueue = [[NSOperationQueue alloc] init];
          socialManager.imageRequestQueue = [[NSOperationQueue alloc] init];
          socialManager.contactsArray = [NSMutableArray new];
      });
    return socialManager;
}

#pragma mark - Images Request

- (void)cancelAllRequests {
    [self.imageRequestQueue cancelAllOperations];
    [self.requestQueue cancelAllOperations];
}

/*
- (void)requestImageAtURL:(NSURL *)url completionHandler:(ImageRequestCompletionHandler)handler
{
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
    
    NSBlockOperation *op = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = op;
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:imageRequest
                                                queue:self.imageRequestQueue
                                    completionHandler:^(NSURLResponse *response,
                                                        NSData *data,
                                                        NSError *error)
              {
                  NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  NSInteger statusCode = [urlResponse statusCode];
                  DebugLog(@"Response Code => %d", statusCode);
                  
                  UIImage *image = nil;
                  if (statusCode == 200 && data)
                  {
                      image = [UIImage imageWithData:data scale:1.0f];
                  }
                  else if (data)
                  {
                      NSMutableDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      if (errorDict)
                      {
                          NSDictionary *userInfo = errorDict[@"data"];
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                      else
                      {
                          NSDictionary *userInfo = @{@"title":@"Error",@"text":socialErrorMessage};
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                  }
                  else
                  {
                      if ([error code] == NSURLErrorTimedOut)
                      {
                          NSDictionary *userInfo = @{@"title":@"Error",@"text":@"Your request has timed out. Please try again."};
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                      else
                      {
                          NSDictionary *userInfo = @{@"title":@"Error",@"text":socialErrorMessage};
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                  }
                  
                  if (handler) {
                      dispatch_async(dispatch_get_main_queue(), ^
                                     {
                                         handler(error, nil, image);
                                     });
                  }
              }];
         }
     }];
    [self.requestQueue addOperation:op];
}

- (void)requestImageAtURL:(NSURL *)url indexPath:(NSIndexPath *)indexPath completionHandler:(ImageRequestCompletionHandler)handler
{
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    
    NSBlockOperation *op = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = op;
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:imageRequest
                                                queue:self.imageRequestQueue
                                    completionHandler:^(NSURLResponse *response,
                                                        NSData *data,
                                                        NSError *error)
              {
                  NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  NSInteger statusCode = [urlResponse statusCode];
                  DebugLog(@"Response Code => %d", statusCode);
                  
                  UIImage *image = nil;
                  if (statusCode == 200 && data)
                  {
                      image = [UIImage imageWithData:data scale:1.0f];
                  }
                  else if (data)
                  {
                      NSMutableDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      if (errorDict)
                      {
                          NSDictionary *userInfo = errorDict[@"data"];
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                      else
                      {
                          NSDictionary *userInfo = @{@"title":@"Error",@"text":socialErrorMessage};
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                  }
                  else
                  {
                      if ([error code] == NSURLErrorTimedOut)
                      {
                          NSDictionary *userInfo = @{@"title":@"Error",@"text":@"Your request has timed out. Please try again."};
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                      else
                      {
                          NSDictionary *userInfo = @{@"title":@"Error",@"text":socialErrorMessage};
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                  }
                  
                  if (handler)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^
                                     {
                                         handler(error, indexPath, image);
                                     });
                  }
              }];
         }
     }];
    [self.requestQueue addOperation:op];
}
*/

- (void)requestMaskImage:(NSURL *)url
               indexPath:(NSIndexPath *)indexPath
             imageToMask:(UIImageView *)imageToMask
               maskImage:(UIImage *)maskImage
       completionHandler:(ImageMaskRequestSocialCompletionHandler)handler
{
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    
    NSBlockOperation *op = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = op;
    [weakOp addExecutionBlock:^
     {
         if (![weakOp isCancelled])
         {
             [NSURLConnection sendAsynchronousRequest:imageRequest
                                                queue:self.imageRequestQueue
                                    completionHandler:^(NSURLResponse *response,
                                                        NSData *data,
                                                        NSError *error)
              {
                  NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                  NSInteger statusCode = [urlResponse statusCode];
                  DebugLog(@"Response Code => %ld", (long)statusCode);
                  
                  UIImage *image = nil;
                  if (statusCode == 200 && data)
                  {
                      image = [UIImage imageWithData:data scale:1.0f];
                      imageToMask.image = image;
                      image = [self cropPhoto:imageToMask withMaskedImage:maskImage];
                  }
                  else if (data)
                  {
                      NSMutableDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      if (errorDict)
                      {
                          NSDictionary *userInfo = errorDict[@"data"];
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                      else
                      {
                          NSDictionary *userInfo = @{@"title":@"Error",@"text":socialErrorMessage};
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                  }
                  else
                  {
                      if ([error code] == NSURLErrorTimedOut)
                      {
                          NSDictionary *userInfo = @{@"title":@"Error",@"text":@"Your request has timed out. Please try again."};
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                      else
                      {
                          NSDictionary *userInfo = @{@"title":@"Error",@"text":socialErrorMessage};
                          error = [NSError errorWithDomain:SGSocialManagerErrorDomain code:[urlResponse statusCode] userInfo:userInfo];
                      }
                  }
                  
                  if (handler)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^
                                     {
                                         handler(error, indexPath, image);
                                     });
                  }
              }];
         }
     }];
    [self.requestQueue addOperation:op];
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
    UIGraphicsBeginImageContextWithOptions(imageToCrop.frame.size, YES, [UIScreen mainScreen].scale);
    
    [imageToCrop.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *pickImage = UIGraphicsGetImageFromCurrentImageContext();
    CGRect imageFrame = CGRectMake(0, 0, 88, 88);
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(pickImage.CGImage, imageFrame);
    
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

- (void)showSocialAlertViewWithError:(NSError *)error
{
#ifdef DEBUG
    if (error)
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           UIAlertView *alertView = [[UIAlertView alloc]
                                                     initWithTitle:@"Error"
                                                     message:[error localizedDescription]
                                                     delegate:weakSelf cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
                           [alertView show];
                       });
    }
#else
    // code for release version put here to handle error
#endif
    
}

- (void) sessionStateChanged:(FBSession *)session
                       state:(FBSessionState) state
                       error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            DebugLog(@"FBSessionStateOpen");
        }
            break;
        case FBSessionStateClosed:
        {
            DebugLog(@"FBSessionStateClosed");
        }
            break;
        case FBSessionStateClosedLoginFailed:
        {
            DebugLog(@"FBSessionStateClosedLoginFailed");
        }
            break;
        case FBSessionStateCreated:
        {
            DebugLog(@"FBSessionStateCreated");
        }
            break;
        case FBSessionStateCreatedOpening:
        {
            DebugLog(@"FBSessionStateCreatedOpening");
        }
            break;
        case FBSessionStateCreatedTokenLoaded:
        {
            DebugLog(@"FBSessionStateCreatedTokenLoaded");
        }
            break;
        case FBSessionStateOpenTokenExtended:
        {
            DebugLog(@"FBSessionStateOpenTokenExtended");
        }
            break;
        default:
            break;
    }
}

/**
 *  Handle Facebook Errors
 */
- (void)handleAuthError:(NSError *)error
{
//    NSString *alertTitle, *alertMessage;
//    
//    if (error.fberrorShouldNotifyUser) {
//        if ([[error userInfo][FBErrorLoginFailedReason] isEqualToString:FBErrorLoginFailedReasonInlineCancelledValue]) {
//            alertMessage = @"Your connection to Facebook was cancelled.  Please try again.";
//        } else if ([[error userInfo][FBErrorLoginFailedReason] isEqualToString:FBErrorLoginFailedReasonSystemDisallowedWithoutErrorValue]) {
//            alertMessage = @"Please make sure that we are able to connect with Facebook.  Go to Settings > Facebook, and authorize Cookie Dunk Dunk.";
//        } else if ([[error userInfo][FBErrorLoginFailedReason] isEqualToString:FBErrorLoginFailedReasonUserCancelledSystemValue]) {
//            alertMessage = @"Your connection to Facebook was cancelled.  Please try again.";
//        } else if ([[error userInfo][FBErrorLoginFailedReason] isEqualToString:FBErrorLoginFailedReasonUserCancelledValue]) {
//            alertMessage = @"Your connection to Facebook was cancelled.  Please try again.";
//        }
//    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
//        alertMessage = @"Your current Facebook session is no longer valid.  Please log in again.";
//    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
//        alertMessage = @"Your connection to Facebook was cancelled.  Please try again.";
//    } else {
//        alertMessage = @"Facebook is experiencing difficulties.  Please try again later.";
//        DebugLog(@"Unexpected error %@", error);
//    }
//    
//    if (alertMessage) {
//        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//    }
}

/*
 Call this method to log in through Facebook
 */
- (void) openSessionFacebookWithCompletionHandler:(RequestFacebookStatus)handler
{
    [FBSession.activeSession closeAndClearTokenInformation];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", @"user_hometown",@"user_birthday", @"user_about_me", @"user_hometown", @"friends_hometown", @"friends_about_me", nil];
    // @"user_likes", @"read_stream", @"read_friendlists", @"read_insights", @"read_mailbox", @"read_requests", @"publish_stream", @"publish_checkins",
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
     {
         if (handler)
         {
            handler(session, status, error);
         }
     }];
}

- (BOOL) openSessionWithAllowLoginUI:(BOOL)allowLoginUI completionHandler:(RequestFacebookStatus)handler
{
    BOOL result = NO;
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", @"user_hometown",@"user_birthday", @"user_about_me", @"user_hometown", @"friends_hometown", @"friends_about_me", nil];
    FBSession *session =
    [[FBSession alloc] initWithAppID:FaceBookAppKey
                         permissions:permissions
                     urlSchemeSuffix:@"CDD"
                  tokenCacheStrategy:nil];
    
    if (allowLoginUI ||
        (session.state == FBSessionStateCreatedTokenLoaded)) {
        [FBSession setActiveSession:session];
        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
                completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
             if (error) {
                 [self handleAuthError:error];
             } else {
                 if (handler)
                 {
                     handler(session, state, error);
                 }
             }
         }];
        result = session.isOpen;
    }
    
    return result;
}

// IOS 6 ^ grab user account fro settings ios app
// Request access to user account.
- (void) requestUserFacebookwithACAccount
{
    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:FaceBookAppKey,ACFacebookAppIdKey,@[@"email"],ACFacebookPermissionsKey, nil];
    
    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
             //it will always be the last object with single sign on
             self.facebookAccount = [accounts lastObject];
             DebugLog(@"facebook account =%@",self.facebookAccount);
             [self getACAccountFacebook];
         }
         else
         {
             [self handleAuthError:error];
         }
     }];
}

- (void) getACAccountFacebook
{
    
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:requestURL
                                               parameters:nil];
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *response,
                                         NSError *error)
     {
         if(!error)
         {
             self.list =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             DebugLog(@"Dictionary contains: %@", self.list );
             if([self.list objectForKey:@"error"]!=nil)
             {
                 [self attemptRenewCredentials];
             }
         }
         else
         {
             [self handleAuthError:error];
         }
     }];
    
    self.accountStore = [[ACAccountStore alloc]init];
    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *key = @"374196292695988";
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"friends_videos"],ACFacebookPermissionsKey, nil];
    
    
    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {}];
}

-(void) attemptRenewCredentials
{
    [self.accountStore renewCredentialsForAccount:(ACAccount *)self.facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error)
     {
         if(!error)
         {
             switch (renewResult)
             {
                 case ACAccountCredentialRenewResultRenewed:
                     DebugLog(@"Good to go");
                     [self getACAccountFacebook];
                     break;
                 case ACAccountCredentialRenewResultRejected:
                     DebugLog(@"User declined permission");
                     break;
                 case ACAccountCredentialRenewResultFailed:
                     DebugLog(@"non-user-initiated cancel, you may attempt to retry");
                     break;
                 default:
                     break;
             }
             
         }
         else
         {
             [self handleAuthError:error];
         }
     }];
}

/*
 Grab the user Info From Facebook
 
 After calling this method - (void)openSessionFacebookWithCompletionHandler:(RequestFacebookStatus)handler
 
 call the method - (void)requestUserInfoFromFacebookWithCompletionHandler:(RequestuserFromFacebookCompletionHandler)handler
 
 to retrieve the user info such as there First and Last Name.
 */

- (void) requestUserInfoFromFacebookWithCompletionHandler:
(RequestuserFromFacebookCompletionHandler)handler
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         if (error) {
             [self handleAuthError:error];
         } else {
             if (handler)
             {
                 handler(error, user);
             }
         }
     }];
}

- (void) requestCompleteUserInfoFacebookWithCompletionHandler:(RequestuserFromFacebookCompletionHandler)handler
{
    [[FBRequest requestForGraphPath:@"me"]startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         if (!error)
         {
             DebugLog(@"retrieved friends from facebook");
             if (handler) {
                 handler(error, user);
             }
         } else {
             [self handleAuthError:error];
         }
     }];
}

- (void) requestFriendsFromFacebookWithCompletionHandler:(RequestfriendsFromFacebookCompletionHandler)handler
{
    [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error) {
        if (error) {
            [self handleAuthError:error];
        } else {
            if (handler) {
                handler(error, result);
            }
        }
    }];
}

/*
 These methods are for sharing on Facebook
 */

- (void) SGSocialManagerDidShareFacebbokWithTitle:(NSString *)title
                                  withMessage:(NSString *)message
                                    withImage:(UIImage *)image
                           withViewController:(UIViewController *)controller
                            completionHandler:(SocialCompletionHandler)handler
{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        __block BOOL didShare = NO;
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //initiate the Social Controller
        
        [mySLComposerSheet setTitle:title]; // The title of the message
        [mySLComposerSheet setInitialText:message]; //the message you want to post
        if (image)
        {
            [mySLComposerSheet addImage:image]; // image you wish to share
        }
            [controller presentViewController:mySLComposerSheet animated:YES completion:nil];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    DebugLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    DebugLog(@"Post Sucessful");
                    didShare = YES;
                    break;
                    
                default:
                    break;
            }
            

            if (handler)
            {
                handler(didShare);
            }
            
        }];
    }
    else
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                message, @"message",
                                image, @"picture",
                                title, @"name",
                                nil, @"caption",
                                nil ];
        
        [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObject:@"status_update"]  allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error){
            
            [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
            }];
            
        }];
        
        CGRect frame;
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            frame = CGRectMake(0, 0, controller.view.frame.size.height, controller.view.frame.size.width);
        }
        else
        {
            frame = CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height);
        }
        
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:controller withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:frame errorDescription:@"In order to post to Facebook, please go into your device settings and login." loadingText:nil];
    }
}

// NOTE:
// New method for handling uiactivity view controller
- (void)shareActivityControllerWithMessage:(NSString *)message
                                   subject:(NSString *)subject
                                     image:(UIImage *)image
                                       URL:(NSURL *)URL
                  presentingViewController:(UIViewController *)controller
                         completionHandler:(UIActivityViewControllerDismissedCompletionHandler)handler
{

    NSMutableArray *shareItemsArray = [NSMutableArray new];
    if (message) [shareItemsArray addObject:message];
    if (URL) [shareItemsArray addObject:URL];
    if (image) [shareItemsArray addObject:image];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:shareItemsArray applicationActivities:nil];
    [activityViewController setValue:subject forKey:@"subject"];
    
     activityViewController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToVimeo, UIActivityTypePostToFlickr, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:activityViewController animated:YES completion:nil];
    });
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed)
     {
         DebugLog(@"completed dialog - activity: %@ - finished flag: %d", activityType, completed);
         if (handler)
         {
             handler(completed);
         }
     }];
    
}

/*
 grab user friends from facebook
 */
- (void) socialClassRequestAccessFriendsFromFacebook
{
    self.fbFriendPics = [NSMutableArray new];
    self.fbFriendNames = [NSMutableArray new];
    [[FBRequest requestForGraphPath:@"me/friends"]startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *friends, NSError *error)
     {
         if (!error)
         {
             DebugLog(@"retrieved friends from facebook");
             dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
             dispatch_async(queue, ^
                            {
                                if (friends)
                                {
                                    
                                    
                                }
                            });
         } else {
             [self handleAuthError:error];
         }
     }];
}


#pragma mark - FaceBook Friends

- (void)requestFacebookFriendsWithQueryType:(NSString *)queryType
                          CompletionHandler:(FacebookFriendsCompletionHandler)handler
{
    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:queryType, @"q", nil];
    
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^
     (FBRequestConnection *connection, NSDictionary *result, NSError *error)
     {
         NSArray *friendArray = nil;
         
         if (!error && result)
         {
             
             if (result[@"data"])
             {
                 friendArray = result[@"data"];
             }
             if (handler)
             {
                 handler(connection, friendArray, error);
             }
         }
         else
         {
             if (handler)
             {
                 handler(connection, friendArray, error);
             }
             [self handleAuthError:error];
         }
         
//         if (error) {
//             [self handleAuthError:error];
//         } else {
//             NSArray *friendArray = nil;
//             if (result[@"data"])
//             {
//                 friendArray = result[@"data"];
//             }
//             if (handler)
//             {
//                 handler(connection, friendArray, error);
//             }
//         }
     }];
}


#pragma mark request friends from facebook to app

- (void)inViteFacebookFriendsWithFacebookUid:(NSString *)fbUid
                           CompletionHandler:(FacebookInviteToAppCompletionHandler)handler
{
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     // 2. Optionally provide a 'to' param to direct the request at
                                     @"286400088", @"to", // Ali
                                     nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:[FBSession activeSession]
                                                  message:[NSString stringWithFormat:@"This is the message"]
                                                    title:@"This is the title"
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
     {
         if (error) {
             [self handleAuthError:error];
         } else {
             if (handler)
             {
                 handler(result, resultURL, error);
             }
         }
     }];
}

- (void)frictionlessInviteFacebookFriendsWithFacebookUid:(NSString *)fbUID
                                       CompletionHandler:(FacebookInviteToAppCompletionHandler)handler
{
    NSString *description = @"This is the description";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:@{
                        @"test": description,}
                        options:0
                        error:&error];
    if (!jsonData) {
        DebugLog(@"JSON error: %@", error);
        return;
    }
    //    NSString *dataString = [[NSString alloc]
    //                         initWithData:jsonData
    //                         encoding:NSUTF8StringEncoding];
    //    FBFrictionlessRecipientCache *friendCache = [[FBFrictionlessRecipientCache alloc] init];
    //    [friendCache prefetchAndCacheForSession:nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"to"] = fbUID;
    params[@"message"] = description;
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:[FBSession activeSession]
                                                  message:description
                                                    title:@"This is the title"
                                               parameters:params
                                                  handler:^
     (FBWebDialogResult result, NSURL *resultURL, NSError *error)
     {
         if (handler)
         {
             handler(result, resultURL, error);
         }
     }];
    //  friendCache:friendCache];
}

#pragma mark - Addressbook Retrieve Contacts

/** retrieve other information..
 From Addressbook
 street = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressStreetKey) copy];
 zip = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey) copy];
 country = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryKey) copy];
 */

/*
- (void)requestAccessAddressBookContactsWithCompletionHandler:(AddressBookRequestContactsCompletionHandler)handler
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    __block BOOL isAllowedAccess = NO;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     // First time access has been granted, add the contact
                                                     isAllowedAccess = YES;
                                                 });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        // The user has previously given access, add the contact
        isAllowedAccess = YES;
    }
    else
    {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        isAllowedAccess = NO;
    }
    CFRelease(addressBookRef);
    if (handler)
    {
        handler(isAllowedAccess);
    }
}

- (void)requestSyncContactDataWithCompletionHandler:(AddressBookCompletionHandler)handler
{
    if ([self.contactsArray count] > 0)
    {
        [self.contactsArray removeAllObjects];
    }
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, &error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    for( int i = 0 ; i < nPeople ; i++ )
    {
        NSMutableDictionary *dicContact = [[NSMutableDictionary alloc] init];
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i );
        
        if(ABRecordCopyValue(ref, kABPersonFirstNameProperty) != nil || [[NSString stringWithFormat:@"%@",ABRecordCopyValue(ref, kABPersonFirstNameProperty)] length] == 0)
        {
            [dicContact setValue:[NSString stringWithFormat:@"%@",ABRecordCopyValue(ref, kABPersonFirstNameProperty)] forKey:@"firstname"];
        }
        else
        {
            [dicContact setValue:@"" forKey:@"firstname"];
        }
        if(ABRecordCopyValue(ref, kABPersonLastNameProperty) != nil || [[NSString stringWithFormat:@"%@",ABRecordCopyValue(ref, kABPersonLastNameProperty)] length] == 0)
        {
            [dicContact setValue:[NSString stringWithFormat:@"%@",ABRecordCopyValue(ref, kABPersonLastNameProperty)] forKey:@"lastname"];
        }
        else
        {
            [dicContact setValue:@"" forKey:@"lastname"];
        }
        if(ABRecordCopyValue(ref, kABPersonOrganizationProperty) != nil || [[NSString stringWithFormat:@"%@",ABRecordCopyValue(ref, kABPersonOrganizationProperty)] length] == 0)
        {
            [dicContact setValue:[NSString stringWithFormat:@"%@",ABRecordCopyValue(ref, kABPersonOrganizationProperty)] forKey:@"name"];
        }
        else
        {
            [dicContact setValue:[NSString stringWithFormat:@"%@ %@",[dicContact valueForKey:@"firstname"],[dicContact valueForKey:@"lastname"]] forKey:@"name"];
        }
        NSData *data1 = (__bridge NSData *) ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail);
        
        if(data1 == nil)
        {
            [dicContact setObject:@"" forKey:@"image"];
        }
        else
        {
            [dicContact setObject:data1 forKey:@"image"];
        }
        
        ABMultiValueRef multival = ABRecordCopyValue(ref, kABPersonAddressProperty);
        NSArray *arrayAddress = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(multival);
        
        if([arrayAddress count] > 0)
        {
            if([[arrayAddress objectAtIndex:0] valueForKey:@"City"] != nil)
            {
                [dicContact setValue:[[arrayAddress objectAtIndex:0] valueForKey:@"City"] forKey:@"city"];
            }
            else
            {
                [dicContact setValue:@"" forKey:@"city"];
            }
            if([[arrayAddress objectAtIndex:0] valueForKey:@"State"] != nil)
            {
                [dicContact setValue:[[arrayAddress objectAtIndex:0] valueForKey:@"State"] forKey:@"state"];
            }
            else
            {
                [dicContact setValue:@"" forKey:@"state"];
            }
            if([[arrayAddress objectAtIndex:0] valueForKey:@"Street"] != nil)
            {
                [dicContact setValue:[[arrayAddress objectAtIndex:0] valueForKey:@"Street"] forKey:@"address1"];
            }
            else
            {
                [dicContact setValue:@"" forKey:@"address1"];
            }
            if([[arrayAddress objectAtIndex:0] valueForKey:@"ZIP"] != nil)
            {
                [dicContact setValue:[[arrayAddress objectAtIndex:0] valueForKey:@"ZIP"] forKey:@"postcode"];
            }
            else
                [dicContact setValue:@"" forKey:@"postcode"];
        }
        else
        {
            [dicContact setValue:@"" forKey:@"city"];
            [dicContact setValue:@"" forKey:@"address1"];
            [dicContact setValue:@"" forKey:@"state"];
            [dicContact setValue:@"" forKey:@"postcode"];
        }
        multival = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        NSArray *arrayPhone = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(multival);
        if([arrayPhone count] > 0)
        {
            [dicContact setValue:[arrayPhone objectAtIndex:0] forKey:@"telephone"];
        }
        else
        {
            [dicContact setValue:@"" forKey:@"telephone"];
        }
        multival = ABRecordCopyValue(ref, kABPersonEmailProperty);
        NSArray *arrayEmail = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(multival);
        if([arrayEmail count])
        {
            [dicContact setValue:[arrayEmail objectAtIndex:0] forKey:@"email"];
        }
        else
        {
            [dicContact setValue:@"" forKey:@"email"];
        }
        multival = ABRecordCopyValue(ref, kABPersonURLProperty);
        NSArray *arrayURL = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(multival);
        if([arrayURL count])
        {
            [dicContact setValue:[arrayURL objectAtIndex:0] forKey:@"website"];
        }
        else
        {
            [dicContact setValue:@"" forKey:@"website"];
        }
        [dicContact setValue:@"" forKey:@"address2"];
        [dicContact setValue:@"" forKey:@"mobile"];
        [dicContact setValue:@"" forKey:@"fax"];
        [dicContact setValue:@"1.000000,1.000000,0.000000,0.000000" forKey:@"color"];
        // only add contacts who have email address
        if (dicContact[@"email"])
        {
            if (![dicContact[@"email"] isEqualToString:@""])
            {
                [self.contactsArray addObject:dicContact];
            }
        }
        
        CFRelease(multival);
    }
    CFRelease(addressBook);
    CFRelease(allPeople);
    //DebugLog(@"Contact Array : %@", self.contactsArray);
    if (handler)
    {
        handler((__bridge NSError *)(error), self.contactsArray);
    }
}
*/
#pragma mark - Twitter

- (void)requestUserTwitterInfo
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            // Check if the users has setup at least one Twitter account
            if (accounts.count > 0)
            {
//                ACAccount *twitterAccount = [accounts objectAtIndex:0];
            }
        } else {
            DebugLog(@"No access granted");
        }
    }];
}

-(void)SGSocialManagerDidSendTweet:(SGSocialManager *)socialManager UIViewController:(UIViewController *)controller titleMessage:(NSString *)title bodyMessageOne:(NSString *)messageOne bodyMessagetwo:(NSString *)messageTwo picture:(UIImage *)image completionHandler:(SocialCompletionHandler)handler
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) //check if Facebook Account is linked
    {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        ;

        //mySLComposerSheet.serviceType
        // THIS THING!!!!
//        mySLComposerSheet = [SLComposeViewController new]; //initiate the Social Controller
//        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [mySLComposerSheet setInitialText:messageOne]; //the message you want to post
        //[mySLComposerSheet addURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/stun-o-matic/id301317579?mt=8"]];
        [mySLComposerSheet addImage:image]; //an image you could post
        //for more instance methodes, go here:https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012205
        [controller presentViewController:mySLComposerSheet animated:YES completion:nil];
        
        __block BOOL didShare = NO;
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    DebugLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    DebugLog(@"Post Sucessful");
                    didShare = YES;
                    break;
                    
                default:
                    break;
            }
            
            
            if (handler)
            {
                handler(didShare);
            }
            
        }];
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:controller withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:controller.view.frame errorDescription:@"In order to post to Twitter, please go into your device settings and login." loadingText:nil];
    }
}

#pragma mark - Google Plus
//
//- (void)SGSocialGPPAuthenticate:(NSDictionary *)inviteDict viewController:(UIViewController *) viewController activityIndicator:(UIActivityIndicatorView *)activityIndicator
//{
//    self.inviteDict = inviteDict;
//    self.viewController = viewController;
//    self.activityIndicator = activityIndicator;
//    
//    gp_sign_in = [GPPSignIn sharedInstance];
//    gp_sign_in.clientID = GOOGLE_PLUS_CLIENT_ID;
//    gp_sign_in.scopes = [NSArray arrayWithObjects:
//                         kGTLAuthScopePlusLogin,
//                         nil];
//    gp_sign_in.actions = [NSArray arrayWithObjects:
//                          @"http://schemas.google.com/AddActivity",
//                          @"http://schemas.google.com/BuyActivity",
//                          @"http://schemas.google.com/CheckInActivity",
//                          @"http://schemas.google.com/CommentActivity",
//                          @"http://schemas.google.com/CreateActivity",
//                          @"http://schemas.google.com/ListenActivity",
//                          @"http://schemas.google.com/ReserveActivity",
//                          @"http://schemas.google.com/ReviewActivity",
//                          nil];
//    gp_sign_in.shouldFetchGoogleUserEmail = YES;
//    gp_sign_in.shouldFetchGoogleUserID = YES;
//    gp_sign_in.delegate = self;
//    
//    [[GPPSignIn sharedInstance] authenticate];
//}
//
//- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error: (NSError *) error
//{
//    DebugLog(@"Received error %@ and auth object %@",error, auth);
//    
//    if (error) {
//        // Do some error handling here.
//        DebugLog(@"Error => %@", [error localizedDescription]);
//        DebugLog(@"Error => %@", [error localizedFailureReason]);
//        DebugLog(@"Error => %@", [error localizedRecoveryOptions]);
//        DebugLog(@"Error => %@", [error localizedRecoverySuggestion]);
//    } else {
//        
//        GTLServicePlus *plusService = [[GTLServicePlus alloc] init];
//        plusService.retryEnabled = YES;
//        
//        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
//        
//        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
//        
//        plusService.apiVersion = @"v1";
//        
//        [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
//            
//            if (error) {
//                DebugLog(@"plusService error %@", [error localizedDescription]);
//            } else {
//                
//                NSString *emailAddress          = nil;
//                NSString *firstName             = nil;
//                NSString *lastName              = nil;
//                NSString *gender                = nil;
//                NSString *biography             = nil;
//                NSString *userLocation          = nil;
//                NSString *imageURL              = nil;
//                NSDate *birthDate               = nil;
//                NSString *inviteAccountId       = nil;
//                NSString *inviteRelationship    = nil;
//                
//                if (gp_sign_in.authentication.userEmail) {
//                    emailAddress = gp_sign_in.authentication.userEmail;
//                }
//                if (person.name.givenName) {
//                    firstName = person.name.givenName;
//                }
//                if (person.name.familyName) {
//                    lastName = person.name.familyName;
//                }
//                if (person.gender) {
//                    gender = person.gender;
//                }
//                if (person.aboutMe) {
//                    biography = person.aboutMe;
//                }
//                
//                if (person.identifier)
//                {
//                    NSString *gpID = person.identifier;
//                    [[NSUserDefaults standardUserDefaults] setObject:gpID forKey:@"gpID"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                }
//                
//                if (self.inviteDict[@"account"])
//                {
//                    inviteAccountId = self.inviteDict[@"account"];
//                    inviteRelationship = @"Friend";
//                    /*
//                     if (self.inviteDict[@"relationship"]) {
//                     inviteRelationship = self.inviteDict[@"relationship"];
//                     }*/
//                }
//                
//                NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAPIToken];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_activityIndicator startAnimating];
//                    _viewController.view.userInteractionEnabled = NO;
//                });
//                
//                [[WebserviceManager sharedManager] requestToCreateUpdateAccountWithEmailAdress:emailAddress
//                                                                                     firstName:firstName
//                                                                                      lastName:lastName
//                                                                                     birthdate:birthDate
//                                                                                      imageURL:imageURL
//                                                                                      apiToken:apiToken
//                                                                                         phone:nil
//                                                                               inviteAccountId:inviteAccountId
//                                                                            inviteRelationShip:inviteRelationship
//                                                                             completionHandler:^
//                 (NSError *error, NSDictionary *account)
//                 {
//                     
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         [_activityIndicator stopAnimating];
//                         _viewController.view.userInteractionEnabled = YES;
//                     });
//                     
//                     if (!error && account)
//                     {
//                         [AppDelegate appDelegate].accountDictionary = account;
//                         dispatch_async(dispatch_get_main_queue(), ^{
//                             [[AppDelegate appDelegate] restoreCoreData];
//                             SHLocationSetupViewController *viewController = [_viewController.storyboard instantiateViewControllerWithIdentifier:@""];
//                             [_viewController.navigationController pushViewController:viewController animated:YES];
//                         });
//                         
//                         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GPDidSignIn"];
//                     }
//                     else if (error)
//                     {
//                         [[WebserviceManager sharedManager] showAlertViewWithError:error];
//                     }
//                     
//                 }];
//
//            }
//            
//        }];
//    }
//}
//
//- (void)SGSocialManagerDidSendGPActivity:(SGSocialManager *)socialManager
//                        UIViewController:(UIViewController *)controller
//                            titleMessage:(NSString *)title
//                          bodyMessageOne:(NSString *)messageOne
//                          bodyMessagetwo:(NSString *)messageTwo
//                                 picture:(NSURL *)image
//{
//    if ([GPPSignIn sharedInstance].authentication) {
//        id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
//        
//        [shareBuilder setTitle:messageOne description:nil thumbnailURL:image];
//        
//        [shareBuilder setContentDeepLinkID:@"CDD"];
//        
//        [shareBuilder open];
//    } else {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"You are not signed in with Google+. Please go to Settings and turn Google+ ON." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//    }
//}
//
//- (void)SGSocialManagerDidSendGPURLShare:(SGSocialManager *)socialManager
//                        UIViewController:(UIViewController *)controller
//                            titleMessage:(NSString *)title
//                          bodyMessageOne:(NSURL *)messageOne
//{
//    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
//    
//    [shareBuilder setURLToShare:messageOne];
//    
//    [shareBuilder setPrefillText:title];
//    
//    [shareBuilder setContentDeepLinkID:title];
//    
//    [shareBuilder open];
//}

#pragma mark - Email

-(void)SGSocialManagerDidSendEmail:(SGSocialManager *)socialManager
                  UIViewController:(UIViewController *)controller
                      titleMessage:(NSString *)title
                    bodyMessageOne:(NSString *)messageOne
                    bodyMessagetwo:(NSString *)messageTwo
                         urlString:(NSString *)urlString
                           picture:(UIImage *)image
                                recipients:(NSArray *)recipients
                                cc:(NSArray *)cc
{
    self.viewController = controller;
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail]) {
        NSMutableString *messageBodyText = [NSMutableString string];
        if (messageOne)
        {
            // 
            NSString *formatString = [NSString stringWithFormat:@"<p>%@</p>\n<a href=%@> </a>\n", messageOne, urlString];
            [messageBodyText appendString: formatString];
        }
        
        if (recipients)
        {
            [composer setToRecipients:recipients];
        }
        
        if (cc)
        {
            [composer setCcRecipients:cc];
        }
        
        if (image)
        {
            NSData *myData = UIImageJPEGRepresentation(image, 1.0);
            [composer addAttachmentData:myData mimeType:@"image/png" fileName:@""];
        }
        
        [composer setSubject:messageTwo];
        [composer setMessageBody:(NSString*)messageBodyText isHTML:YES];
        composer.title = title;
        [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [controller presentViewController:composer animated:YES completion:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            DebugLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
            break;
        case MFMailComposeResultSaved:
            DebugLog(@"Mail saved: you saved the email message in the Drafts folder");
            break;
        case MFMailComposeResultSent:
            DebugLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
            break;
        case MFMailComposeResultFailed:
            DebugLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
            break;
        default:
            DebugLog(@"Mail not sent");
            break;
    }

    if (error) {
        NSString *message = @"Can't Send message, please try again later.";
        UIAlertView *shareAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        [shareAlert show];
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Social Sharing
- (void)shareAcrossSocialNetworksWithViewController:(UIViewController *)viewController WithMessage:(NSString *)message WithImage:(UIImage *)image WithUrl:(NSURL *)url
{
    SharingActivityProvider *sharingActivityProvider = [[SharingActivityProvider alloc] init];
    //    UIImage *shareImage = [UIImage imageNamed:@"7logo-main-menu"];
    //    NSURL *shareUrl = [NSURL URLWithString:];
    
    sharingActivityProvider.shareMessage = message;
    
    NSArray *activityProviders = nil;
    if (sharingActivityProvider)
    {
        if (image && url)
        {
            activityProviders = @[sharingActivityProvider, image, url];
        }
        else if (image)
        {
            activityProviders = @[sharingActivityProvider, image];
        }
        else if (url)
        {
            activityProviders = @[sharingActivityProvider, url];
        }
        else
        {
            activityProviders = @[sharingActivityProvider];
        }
    }
    
//    GooglePlusActivity *gPlusActivity = [[GooglePlusActivity alloc] init];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityProviders applicationActivities:nil/*@[gPlusActivity]*/];
    activityViewController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToVimeo, UIActivityTypePostToFlickr, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo];
    
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [viewController presentViewController:activityViewController animated:YES completion:nil];
}
@end
