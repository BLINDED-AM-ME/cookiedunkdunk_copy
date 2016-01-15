
//  SGSocialManager.h

/*
 For Facebook Documentation
 http://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
 A good tutorial for looking into ACAccounts
 http://blogs.captechconsulting.com/blog/eric-stroh/ios-6-tutorial-integrating-facebook-your-applications
 Facebook Permissions
 https://developers.facebook.com/docs/howtos/ios-6/
 Facebook Invites for friends to app
 https://developers.facebook.com/docs/tutorials/ios-sdk-games/requests/
 
 https://developers.facebook.com/docs/reference/dialogs/requests/
 */

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
#import <FacebookSDK/FacebookSDK.h>
// #import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <AddressBook/AddressBook.h>
#import <Twitter/Twitter.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SharingActivityProvider.h"
//#import "GooglePlusActivity.h"

//#import <GoogleOpenSource/GoogleOpenSource.h>
//#import <GooglePlus/GooglePlus.h>

/*
 This NSString is for setting the appkey for facebook
 */
extern NSString * const FaceBookAppKey;
extern NSString * const SGSocialManagerErrorDomain;
/*
 For Retrieving Facebook Friends
 https://developers.facebook.com/docs/howtos/run-fql-queries-ios-sdk/
 */

/*
 For Friend Invites
 https://developers.facebook.com/docs/tutorials/ios-sdk-games/requests/
 
 https://developers.facebook.com/docs/howtos/send-requests-using-ios-sdk/
 
 http://developers.facebook.com/docs/howtos/link-to-your-native-app-ios-sdk/
 */

/*
 These difines are for the different query types for facebook
 see link above for more information regarding facebook query types
 */

//#define kFacebookTypeQuery     @"SELECT uid, name, pic_square FROM user WHERE uid IN " @"(SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 25)"
/*
 TWITTER API DOCUMENTATION
 https://dev.twitter.com/docs/auth/implementing-sign-twitter
 */
extern NSString *const FacebookTypeQuery;
extern NSString *const FacebookTypeMultiQuery;
extern NSString *const FacebookTypeSearchQuery;
extern NSString *const FacebookTypeQueryFriendsHaveApp;
extern NSString *const FacebookTypeQueryFriendsDontHaveApp;

typedef void (^ImageRequestSocialCompletionHandler)(NSError *error, NSIndexPath *indexPath, UIImage *image);
typedef void (^ImageMaskRequestSocialCompletionHandler)(NSError *error, NSIndexPath *indexPath, UIImage *image);

typedef void (^RequestuserFromFacebookCompletionHandler)(NSError *error, NSDictionary *userInfo);
typedef void (^RequestfriendsFromFacebookCompletionHandler)(NSError *error, NSDictionary *friends);
typedef void (^RequestFacebookStatus)(FBSession *session, FBSessionState state, NSError *error);
typedef void (^RequestFriendsFromFacebookCompletionHandler)(NSMutableArray *friendPics, NSMutableArray *friendNames);
typedef void (^FacebookFriendsCompletionHandler)(FBRequestConnection *connection, NSArray *friendArray, NSError *error);
typedef void (^FacebookInviteToAppCompletionHandler)(FBWebDialogResult result, NSURL *resultURL, NSError *error);
typedef void (^UIActivityViewControllerDismissedCompletionHandler)(BOOL didDismiss);
typedef void (^AddressBookCompletionHandler)(NSError *error, NSArray *contactsArray);
typedef void (^AddressBookRequestContactsCompletionHandler)(BOOL isAllowedAccess);
typedef void (^SocialCompletionHandler)(BOOL didFinishSharing);

@interface SGSocialManager : NSObject <UIActionSheetDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate/*, GPPSignInDelegate*/>

+ (SGSocialManager *)socialManager;
/*
 
 Handle Displaying Images
 
 */
//- (void)requestImageAtURL:(NSURL *)url completionHandler:(ImageRequestSocialCompletionHandler)handler;
//- (void)requestImageAtURL:(NSURL *)url indexPath:(NSIndexPath *)indexPath completionHandler:(ImageRequestSocialCompletionHandler)handler;
- (void)requestMaskImage:(NSURL *)url indexPath:(NSIndexPath *)indexPath imageToMask:(UIImageView *)imageToMask maskImage:(UIImage *)maskImage completionHandler:(ImageMaskRequestSocialCompletionHandler)handler;

- (void)requestMaskImageAtIndexPath:(NSIndexPath *)indexPath imageData:(NSData *)imageData imageToMask:(UIImageView *)imageToMask maskImage:(UIImage *)maskImage completionHandler:(ImageMaskRequestSocialCompletionHandler)handler;

/*
 Handle Errors from social class
 */

- (void)showSocialAlertViewWithError:(NSError *)error;

/*
 These method is for registering login process with facebook
 */
- (void) sessionStateChanged:(FBSession *)session
                       state:(FBSessionState) state
                       error:(NSError *)error;

- (void) openSessionFacebookWithCompletionHandler:(RequestFacebookStatus)handler;

- (BOOL) openSessionWithAllowLoginUI:(BOOL)allowLoginUI completionHandler:(RequestFacebookStatus)handler;

- (void) requestUserFacebookwithACAccount;

- (void) attemptRenewCredentials;

#pragma mark request friends from facebook to app

- (void)inViteFacebookFriendsWithFacebookUid:(NSString *)fbUid CompletionHandler:(FacebookInviteToAppCompletionHandler)handler;

- (void)frictionlessInviteFacebookFriendsWithFacebookUid:(NSString *)fbUID CompletionHandler:(FacebookInviteToAppCompletionHandler)handler;
/*
 These methods are for requesting user info
 */

- (void) requestUserInfoFromFacebookWithCompletionHandler:(RequestuserFromFacebookCompletionHandler)handler;

- (void) requestCompleteUserInfoFacebookWithCompletionHandler:(RequestuserFromFacebookCompletionHandler)handler;

- (void) requestFriendsFromFacebookWithCompletionHandler:(RequestfriendsFromFacebookCompletionHandler)handler;

/*
 These methods are for sharing on Facebook
 */
- (void) SGSocialManagerDidShareFacebbokWithTitle:(NSString *)title withMessage:(NSString *)message withImage:(UIImage *)image withViewController:(UIViewController *)controller completionHandler:(SocialCompletionHandler)handler;


//share with facebook, twitter and email with uiactivitycontroller
//- (void) socialClassWillShareWithIActivityControllerWithMessage:(NSString *)message withImage:(UIImage *)image withViewController:(UIViewController *)controller CompletionHandler:(UIActivityViewControllerDismissedCompletionHandler)handler;

- (void)shareActivityControllerWithMessage:(NSString *)message
                                   subject:(NSString *)subject
                                     image:(UIImage *)image
                                       URL:(NSURL *)URL
                  presentingViewController:(UIViewController *)controller
                         completionHandler:(UIActivityViewControllerDismissedCompletionHandler)handler;

/*
 grab friends from facebook
 */

- (void)socialClassRequestAccessFriendsFromFacebook;

- (void)requestFacebookFriendsWithQueryType:(NSString *)queryType CompletionHandler:(FacebookFriendsCompletionHandler)handler;

#pragma mark - Tweeter
-(void)SGSocialManagerDidSendTweet:(SGSocialManager *)socialManager
                  UIViewController:(UIViewController *)controller
                      titleMessage:(NSString *)title
                    bodyMessageOne:(NSString *)messageOne
                    bodyMessagetwo:(NSString *)messageTwo
                           picture:(UIImage *)image
                 completionHandler:(SocialCompletionHandler)handler;

#pragma mark - email/message
-(void)SGSocialManagerDidSendEmail:(SGSocialManager *)socialManager
                  UIViewController:(UIViewController *)controller
                      titleMessage:(NSString *)title
                    bodyMessageOne:(NSString *)messageOne
                    bodyMessagetwo:(NSString *)messageTwo
                         urlString:(NSString *)urlString
                           picture:(UIImage *)image
                        recipients:(NSArray *)to
                                cc:(NSArray *)cc;

#pragma mark - Google Plus
/*
- (void)SGSocialGPPAuthenticate:(NSDictionary *)inviteDict viewController:(UIViewController *)viewController activityIndicator:(UIActivityIndicatorView *)activityIndicator;
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error: (NSError *) error;
- (void)SGSocialManagerDidSendGPActivity:(SGSocialManager *)socialManager
                                         UIViewController:(UIViewController *)controller
                                         titleMessage:(NSString *)title
                                         bodyMessageOne:(NSString *)messageOne
                                         bodyMessagetwo:(NSString *)messageTwo
                                         picture:(UIImage *)image;
- (void)SGSocialManagerDidSendGPURLShare:(SGSocialManager *)socialManager
                        UIViewController:(UIViewController *)controller
                            titleMessage:(NSString *)title
                          bodyMessageOne:(NSURL *)messageOne;
*/
/*
 Addressbook methods
 */
//- (void)requestAccessAddressBookContactsWithCompletionHandler:(AddressBookRequestContactsCompletionHandler)handler;

// - (void)requestSyncContactDataWithCompletionHandler:(AddressBookCompletionHandler)handler;

#pragma mark - Social Sharing
- (void)shareAcrossSocialNetworksWithViewController:(UIViewController *)viewController WithMessage:(NSString *)message WithImage:(UIImage *)image WithUrl:(NSURL *)url;

/*
 Properties
 */
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong, nonatomic) NSDictionary *list;
@property (strong, nonatomic) NSMutableArray *fbFriendPics;
@property (strong, nonatomic) NSMutableArray *fbFriendNames;
@property (strong, nonatomic) NSString *searchTextForSearchQuery;
@property (strong, nonatomic) NSDictionary *inviteDict;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@class GTLServicePlus;
