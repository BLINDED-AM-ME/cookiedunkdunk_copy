//
//  SGAppDelegate.m
//  CookieDD
//
//  Created by Benjamin Stahlhood on 7/20/13.
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


#import "SGAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Crashlytics/Crashlytics.h>
#import "SGAudioManager.h"
#import "SGGameManager.h"
#import "CDMainMenuViewController.h"

@interface SGAppDelegate () <SGAudioManagerDelegate>

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) SGConditionalViewController *conditionalController;
@property (strong, nonatomic) UIButton *skipLogoButton;
@property (assign, nonatomic) BOOL didCloseLoadingScreen;

@end

@implementation SGAppDelegate

+ (SGAppDelegate *)appDelegate
{
    return (SGAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *emptyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"nothingForYou", @"name", nil];
    [[NSUserDefaults standardUserDefaults] setObject:emptyDictionary forKey:FreeCookieCostumeDictionaryDefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Allow video to play upon entry every time....
//    NSUserDefaults *willAllowVideoToPlay = [NSUserDefaults standardUserDefaults];
//    [willAllowVideoToPlay setBool:YES forKey:AllowVideoIntroToPlayDefault];
    
//    NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attemptRenewCredentials:) name:ACAccountStoreDidChangeNotification object:nil];
    
    application.applicationSupportsShakeToEdit = YES;
    
    [[Crashlytics sharedInstance] setDebugMode:NO];
    [Crashlytics startWithAPIKey:@"fa0637ff7e972002d74ee842b73a8b143eeb41e9"];
    
    _logoImageView = [[UIImageView alloc] initWithImage:[self defaultImage]];
    
    //[[SGAudioManager audioManager] playSoundWithName:@"7GT" withFileType:@"m4a" volume:1.0f numberOfLoops:-1];
    [SGAudioManager audioManager].delegate = self;
    
    [self.window.rootViewController.view addSubview:_logoImageView];
    
//    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
//    CDMainMenuViewController *controller = (CDMainMenuViewController *)navController.topViewController;
//    [controller presentScene];
    
    if (DevModeActivated) {
        self.skipLogoButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [self.skipLogoButton addTarget:self action:@selector(skipLoadscreen) forControlEvents:UIControlEventTouchUpInside];
        [self.skipLogoButton setTitle:@"..." forState:UIControlStateNormal];
        [self.skipLogoButton setBackgroundColor:[UIColor colorWithRed:0.612 green:0.000 blue:0.999 alpha:0.310]];
        [self.window.rootViewController.view addSubview:self.skipLogoButton];
        self.skipLogoButton.enabled = YES;
    }

    // Let the device know we want to receive push notifications
    [[UIApplication sharedApplication] registerForRemoteNotifications];
//	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    
    _dailyAwardsAllowed = 3;
    _loadingScreenTimeDelay = .5;
    
    _unlockCookieCooker = YES;
    _unlockCookieDrop = YES;
    _unlockLeft4Bread = YES;
    _unlockCowAbduction = YES;
    
    _didCloseLoadingScreen = NO;
    
    _isLoggedIntoFacebook = NO;
    
    // Set the User Defaults
    [self setUserDefaults];
    
    [SGAudioManager audioManager].delegate = self;
    
    if(!TARGET_IPHONE_SIMULATOR)
    {
        self.currentDeviceID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    _purchasesAllowedBeforeRemovingPack = 6;
    
    [[SGAudioManager audioManager] activateAudio];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[SGGameManager gameManager] Pause];
    [[SGAudioManager audioManager] pauseAllAudio];
    
//    if ([self.window.rootViewController.view isKindOfClass:[SKView class]])
//    {
//        DebugLog(@"Appdelegate is pausing SKView");
//        SKView *view = (SKView *)self.window.rootViewController.view;
//        view.paused = YES;
//    }
//    else if ([self.window.rootViewController.view isKindOfClass:[UIView class]])
//    {
//        DebugLog(@"can't pause a UIView....");
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[SGAudioManager audioManager] deactivateAudio];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[SGAudioManager audioManager] activateAudio];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [[SGGameManager gameManager] Resume];
    [[SGAudioManager audioManager] playAllAudio];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
   
//    if ([self.window.rootViewController.view isKindOfClass:[SKView class]])
//    {
//        DebugLog(@"Appdelegate is unpausing SKView");
//        SKView *view = (SKView *)self.window.rootViewController.view;
//        view.paused = NO;
//    }
//    else if ([self.window.rootViewController.view isKindOfClass:[UIView class]])
//    {
//        DebugLog(@"can't pause a UIView....");
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    DebugLog(@"App has been neutralized!");
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    
    [[SGAudioManager audioManager] deactivateAudio];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	// DebugLog(@"My token is: %@", deviceToken);
    
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	self.currentDeviceTokenId = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	DebugLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Detect if APN is received on Background or Foreground state
  
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [[FBSession activeSession] handleOpenURL:url];
}

#pragma mark - Custom Methods

- (UIImage *)defaultImage
{
    NSString *imageName = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            imageName = @"Default-568h";
        }
        else
        {
            imageName = @"Default";
        }
    }
    else // ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            imageName = @"Default-Landscape";
        }
        else // if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
        {
            imageName = @"Default-Portrait";
        }
    }
    return [UIImage imageNamed:imageName];
}

- (void)skipLoadscreen {
    DebugLog(@"Skipping load screen.");
    [[SGAudioManager audioManager] stopAllAudio];
    [self closeLoadScreen];
}

#pragma mark - Facebook

- (void)attemptRenewCredentials:(NSNotification *)note
{
    [[SGSocialManager socialManager] attemptRenewCredentials];
}


- (void)closeLoadScreen
{    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    CDMainMenuViewController *controller = (CDMainMenuViewController *)navController.topViewController;

    [controller supportedInterfaceOrientations];
    
    if ([controller isKindOfClass:[CDMainMenuViewController class]])
    {
        [controller presentScene];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        _logoImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_logoImageView removeFromSuperview];
        [_skipLogoButton removeFromSuperview];
        
        if (!_didCloseLoadingScreen)
        {
            // <<< Turn this back on at the first opportunity.
            [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"CCDDD_THEME_MIX_Opening" FileType:@"m4a" volume:0.3f numberOfLoopes:-1];
            
            _didCloseLoadingScreen = YES;
        }
    }];
}


#pragma mark - SGAudioManagerDelegate

- (void)audioManager:(SGAudioManager *)audioManager didFinishPlayingSoundWithAudioPLayer:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self closeLoadScreen];
}

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
{
    if (newStatusBarOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        DebugLog(@"This is Landscape Left");
    }
    else if (newStatusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        DebugLog(@"This is Landscape Right");
    }
    else if (newStatusBarOrientation == UIInterfaceOrientationPortrait)
    {
        DebugLog(@"This is Portrait");
    }
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
    if (oldStatusBarOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        DebugLog(@"Leaving Landscape Left");
    }
    else if (oldStatusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        DebugLog(@"Leaving Landscape Right");
    }
    else if (oldStatusBarOrientation == UIInterfaceOrientationPortrait)
    {
        DebugLog(@"Leaving Portrait");
    }
}

- (void)stopThemeMusic
{
    [[SGAudioManager audioManager] stopAllAudio];
}

- (void)setUserDefaults
{
    NSUserDefaults *isFirstTime = [NSUserDefaults standardUserDefaults];
    
    if (![isFirstTime boolForKey:IsFirstTimeDefault])
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:1 forKey:CurrentLevelDefault];
        [userDefaults setInteger:0 forKey:CookieCookerHighScoreDefault];
        [userDefaults setInteger:0 forKey:CowAbductionHighScoreDefault];
        [userDefaults setInteger:0 forKey:CookieDropHighScoreDefault];
        [userDefaults setObject:@"high" forKey:VolumeButtonStateDefault];
        [userDefaults setObject:@"play" forKey:MusicButtonStateDefault];
        [userDefaults setInteger:5 forKey:CurrentLivesDefault];
        [userDefaults setInteger:_dailyAwardsAllowed forKey:DailyPrizesAwardedDefault];
        [userDefaults setBool:NO forKey:HasSeenMapIntroTutorial];
        
        
        NSMutableDictionary *chipCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameChip, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-chip"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
        NSMutableDictionary *dustinCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameDustinMartianMint, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-dustin"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
        NSMutableDictionary *lukeCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameLukeLocoLemon, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-luke"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
        NSMutableDictionary *mikeyCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameMikeyMcSprinkles, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-mikey"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
        NSMutableDictionary *jjCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameJJJams, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-jj"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
        NSMutableDictionary *reggieCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameReginald, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-reginald"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
        NSMutableDictionary *gerryCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameGerryJ, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-gerry"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
        
        NSMutableArray *cookieCostumesArray = [[NSMutableArray alloc] initWithObjects:chipCostumeDictionary, dustinCostumeDictionary, lukeCostumeDictionary, mikeyCostumeDictionary, jjCostumeDictionary, reggieCostumeDictionary, gerryCostumeDictionary, nil];
    
        [userDefaults setObject:cookieCostumesArray forKey:CookieCostumeArrayDefault];
        
        [isFirstTime setBool:YES forKey:IsFirstTimeDefault];
    }
    else
    {
        NSArray *array =[NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:CookieCostumeArrayDefault]];
        
        if (!([array count] > 0))
        {
            NSMutableDictionary *chipCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameChip, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-chip"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
            NSMutableDictionary *dustinCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameDustinMartianMint, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-dustin"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
            NSMutableDictionary *lukeCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameLukeLocoLemon, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-luke"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
            NSMutableDictionary *mikeyCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameMikeyMcSprinkles, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-mikey"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
            NSMutableDictionary *jjCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameJJJams, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-jj"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
            NSMutableDictionary *reggieCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameReginald, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-reginald"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
            NSMutableDictionary *gerryCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameGerryJ, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-gerry"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
            
            NSMutableArray *cookieCostumesArray = [[NSMutableArray alloc] initWithObjects:chipCostumeDictionary, dustinCostumeDictionary, lukeCostumeDictionary, mikeyCostumeDictionary, jjCostumeDictionary, reggieCostumeDictionary, gerryCostumeDictionary, nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:cookieCostumesArray forKey:CookieCostumeArrayDefault];
        }
    }
    
    
    NSUserDefaults *volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
    NSString *volumeButtonState = [volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
    
    if ([volumeButtonState isEqualToString:@"high"])
    {
        _masterVolume = 1;
    }
    else if ([volumeButtonState isEqualToString:@"low"])
    {
        _masterVolume = .5;
    }
    else if ([volumeButtonState isEqualToString:@"mute"])
    {
        _masterVolume = 0;
    }
    
    // <<< Turn this back on at the first opportunity.
    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"7GT" FileType:@"m4a" volume:1.0f numberOfLoopes:0];
}

#pragma mark - Return Player Account Email/Device ID

- (NSString *)fetchPlayerEmail
{
    NSString *email = nil;
    
    if (self.accountDict[@"email"])
    {
        email = self.accountDict[@"email"];
    }
    
    return email;
}

- (NSString *)fetchPlayerDeviceID
{
    NSString *deviceID = nil;
    
    if (self.accountDict[@"deviceID"])
    {
        deviceID = self.accountDict[@"deviceID"];
    }
    
    return deviceID;
}

#pragma mark - Return Player Facebook ID

- (NSString *)fetchPlayerFacebookID
{
    NSString *facebookID = nil;
    
    if (self.accountDict[@"facebookID"])
    {
        facebookID = self.accountDict[@"facebookID"];
    }
    
    return facebookID;
}

#pragma mark - Present Conditional View Controller

- (void)presentConditionalViewControllerWithParentController:(UIViewController *)parentController
                                           withConditionType:(ConditionalType)conditionType
                                            presentationType:(PresentationType)presentationType
                                                   withFrame:(CGRect)frame
                                            errorDescription:(NSString *)errorDescription loadingText:(NSString *)loadingText
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!weakSelf.conditionalController)
        {
            weakSelf.conditionalController = [parentController.storyboard instantiateViewControllerWithIdentifier:@"SGConditionalViewController"];
            
            weakSelf.conditionalController.delegate = weakSelf;
        }
        
        weakSelf.conditionalController.view.frame = frame;
        weakSelf.conditionalController.conditionalType = conditionType;
        
        weakSelf.conditionalController.presentationType = presentationType;
        
        if (errorDescription)
        {
            weakSelf.conditionalController.errorDescription = errorDescription;
        }
        
        weakSelf.conditionalController.loadingText = loadingText;
        
        [parentController addChildViewController:weakSelf.conditionalController];
        
        [parentController.view addSubview:weakSelf.conditionalController.view];
        
//        weakSelf.conditionalController.view.frame = CGRectMake(0, 0, parentController.view.frame.size.width, parentController.view.frame.size.height);
        
        [weakSelf.conditionalController animateInErrorPopUpWithCompletionHandler:nil];
    });
}

- (void)dismissConditionalView
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conditionalController animateOutErrorPopUpWithCompletionHandler:^
         (BOOL didFinish)
         {
             if (didFinish)
             {
                 [weakSelf.conditionalController.view removeFromSuperview];
                 [weakSelf.conditionalController removeFromParentViewController];
             }
         }];
    });
}

#pragma mark - SGConditionalViewControllerDelegate

- (void)conditionalViewControllerDidAccept:(SGConditionalViewController *)controller
{
    [self dismissConditionalView];
}

- (void)conditionalViewControllerDidDeny:(SGConditionalViewController *)controller
{
    [self dismissConditionalView];
}

#pragma mark - Custom Transitions between ViewControllers

- (void)transitionFadeWithParentViewController:(UIViewController *)parentViewController
                   endTransitionViewController:(UIViewController *)endTransitionViewController
                                 withImageName:(NSString *)imageName
                                 navController:(NavControllerTransitionType)transitionType
                         willAnimateTransition:(BOOL)animated
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, parentViewController.view.frame.size.width, parentViewController.view.frame.size.height)];
    DebugLog(@"------------------------------<");
    DebugLog(@"parentViewController = %@", parentViewController);
    DebugLog(@"navicationController = %@", parentViewController.navigationController);
    DebugLog(@"------------------------------<");
    
    view.alpha = 0.0f;
    
    view.backgroundColor = [UIColor blackColor];
    
    [parentViewController.view addSubview:view];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        view.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        [view removeFromSuperview];
        
        UIView *mapCoverView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
        
        mapCoverView.backgroundColor = [UIColor blackColor];
        
        [self.window addSubview:mapCoverView];
        
        switch (transitionType)
        {
            case NavControllerTransitionType_Default:
            {
                
            }
                break;
                
            case NavControllerTransitionType_Present:
            {
                [parentViewController.navigationController presentViewController:endTransitionViewController animated:animated completion:nil];
            }
                break;
                
            case NavControllerTransitionType_Push:
            {
                [parentViewController.navigationController pushViewController:endTransitionViewController animated:animated];
            }
                break;
                
            default:
                break;
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            
            mapCoverView.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [mapCoverView removeFromSuperview];
        }];
        
    }];
}

- (void)transitionEndFadeWithParentViewController:(UIViewController *)parentViewController
                      navControllerTransitionType:(NavControllerTransitionEndType)transitionType
                                    withImageName:(NSString *)imageName
                            willAnimateTransition:(BOOL)animated
{
    UIView *view;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
    {
        view= [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenHeight * 3.0f, kScreenHeight * 3.0f)];
    }
    else
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenHeight * 3.0f, kScreenHeight * 3.0f )];
    }
    
    view.alpha = 0.0f;
    
    view.backgroundColor = [UIColor blackColor];
    
    [parentViewController.view addSubview:view];
    [parentViewController.view bringSubviewToFront:view];
    
    [UIView animateWithDuration:0.3f animations:^{
    
        view.alpha = 1.0f;
    
    } completion:^(BOOL finished) {
        
        [view removeFromSuperview];
        
        UIView *mapCoverView;
        
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
        {
            mapCoverView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            mapCoverView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.height, view.frame.size.width)];
        }
        
        mapCoverView.backgroundColor = [UIColor blackColor];
        
        [self.window addSubview:mapCoverView];
        
        switch (transitionType)
        {
            case NavControllerTransitionEndType_Default:
            {
                
            }
                break;
            
            case NavControllerTransitionEndType_Dismiss:
            {
                [parentViewController.navigationController dismissViewControllerAnimated:animated completion:nil];
            }
                break;
                
            case NavControllerTransitionEndType_Pop:
            {
                [parentViewController.navigationController popViewControllerAnimated:animated];
            }
                break;
                
            default:
                break;
        }
        
        [UIView animateWithDuration:0.3f animations:^{
          
            mapCoverView.alpha = 0.0f;
        
        } completion:^(BOOL finished) {
            
            [mapCoverView removeFromSuperview];
        }];
        
    }];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    DebugLog(@"Received memory warning!!!!");
}

#pragma mark - Retrieve Cookie Names
- (NSString *)retrieveProperCookieName:(NSString *)unFormattedName withTheme:(NSString *)theme
{
    NSString *name;
    if ([unFormattedName isEqualToString:KeyNameChip])
    {
        if ([theme isEqualToString:KeyThemeDefault])
        {
            name = @"Chip";
        }
        else if ([theme isEqualToString:KeyThemeChef])
        {
            name = @"Chef Chip";
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            name = @"Captain Chip";
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            name = @"Farmer Chip";
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            name = @"Survivor Chip";
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameDustinMartianMint])
    {
        if ([theme isEqualToString:KeyThemeDefault])
        {
            name = @"Dustin Double Mint";
        }
        else if ([theme isEqualToString:KeyThemeChef])
        {
            name = @"Chef Dustin Double Mint";
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            name = @"Super Fresh";
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            name = @"Farmer Dustin";
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            name = @"Survivor Dustin";
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameGerryJ])
    {
        if ([theme isEqualToString:KeyThemeDefault])
        {
            name = @"Gerry J.";
        }
        else if ([theme isEqualToString:KeyThemeChef])
        {
            name = @"Chef Gerry J.";
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            name = @"Gerry Fast";
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            name = @"Farmer Gerry";
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            name = @"Zombie Gerry";
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameJJJams])
    {
        if ([theme isEqualToString:KeyThemeDefault])
        {
            name = @"JJ Jamz";
        }
        else if ([theme isEqualToString:KeyThemeChef])
        {
            name = @"Chef JJ Jams";
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            name = @"JJ Jelly Man";
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            name = @"Farmer JJ Jams";
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            name = @"Survivor JJ";
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameLukeLocoLemon])
    {
        if ([theme isEqualToString:KeyThemeDefault])
        {
            name = @"Luke Loco Lemon";
        }
        else if ([theme isEqualToString:KeyThemeChef])
        {
            name = @"Chef Luke Loco Lemon";
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            name = @"The Luke";
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            name = @"Farmer Luke";
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            name = @"Zombie Luke";
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameMikeyMcSprinkles])
    {
        if ([theme isEqualToString:KeyThemeDefault])
        {
            name = @"Mikey McSprinkles";
        }
        else if ([theme isEqualToString:KeyThemeChef])
        {
            name = @"Chef Mikey McSprinkles";
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            name = @"Blue Devil";
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            name = @"Farmer Mikey";
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            name = @"Zombie Mikey";
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameReginald])
    {
        if ([theme isEqualToString:KeyThemeDefault])
        {
            name = @"Reginald";
        }
        else if ([theme isEqualToString:KeyThemeChef])
        {
            name = @"Chef Reginald";
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            name = @"RegiPool";
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            name = @"Farmer Reginald";
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            name = @"Zombie Reginald";
        }
    }
    else
    {
        name = @"Error: name not found";
    }
    
    if (!name)
    {
        name = @"Error: name not found";
    }
    
    return name;
}

#pragma mark - Retrieve Cookie Costume IAPIdentifiers
- (NSString *)retrieveProperIAPIdentifierWithCookieName:(NSString *)unFormattedName withTheme:(NSString *)theme
{
    NSString *iapIdentifier;
    if ([unFormattedName isEqualToString:KeyNameChip])
    {
        if ([theme isEqualToString:KeyThemeSuperHero])
        {
            iapIdentifier = IAPIdentifiers_SuperChip;
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            iapIdentifier = IAPIdentifiers_FarmerChip;
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            iapIdentifier = IAPIdentifiers_ZombieChip;
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameDustinMartianMint])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            iapIdentifier = IAPIdentifiers_ChefDustinDoubleMint;
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            iapIdentifier = IAPIdentifiers_SuperDustinDoubleMint;
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            iapIdentifier = IAPIdentifiers_ZombieDustinMartianMint;
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameGerryJ])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            iapIdentifier = IAPIdentifiers_ChefGerry;
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            iapIdentifier = IAPIdentifiers_SuperGerry;
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            iapIdentifier = IAPIdentifiers_FarmerGerryJ;
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameJJJams])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            iapIdentifier = IAPIdentifiers_ChefJJJams;
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            iapIdentifier = IAPIdentifiers_FarmerJJJams;
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            iapIdentifier = IAPIdentifiers_ZombieJJJams;
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameLukeLocoLemon])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            iapIdentifier = IAPIdentifiers_ChefLukeLocoLemon;
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            iapIdentifier = IAPIdentifiers_SuperLukeLocoLemon;
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            iapIdentifier = IAPIdentifiers_FarmerLukeLocoLemon;
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            iapIdentifier = IAPIdentifiers_ZombieLukeLocoLemon;
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameMikeyMcSprinkles])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            iapIdentifier = IAPIdentifiers_ChefMikeMcSprinkles;
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            iapIdentifier = IAPIdentifiers_SuperMikeMcSprinkles;
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            iapIdentifier = IAPIdentifiers_FarmerMikeyMcSprinkles;
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            iapIdentifier = IAPIdentifiers_ZombieMikeyMcSprinkles;
        }
    }
    else if ([unFormattedName isEqualToString:KeyNameReginald])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            iapIdentifier = IAPIdentifiers_ChefReginald;
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            iapIdentifier = IAPIdentifiers_SuperReginald;
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            iapIdentifier = IAPIdentifiers_FarmerReginald;
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            iapIdentifier = IAPIdentifiers_ZombieReginald;
        }
    }
    else
    {
        iapIdentifier = @"Error: IapIdentifier is not available for this cookie";
    }
    
    if (!iapIdentifier)
    {
        iapIdentifier = @"Error: IapIdentifier is not available for this cookie";
    }
    
    return iapIdentifier;
}

#pragma mark - Convert Points from UI to SK
- (CGPoint)convertPoint:(CGPoint)oldPoint WithSprite:(SKSpriteNode *)sprite WithScene:(SKScene *)scene
{
    CGPoint newPoint = CGPointMake((oldPoint.x * .5) + (.5 * sprite.frame.size.width), scene.frame.size.height - (oldPoint.y * .5) - (sprite.frame.size.height * .5));
    DebugLog(@"X: %f, Y: %f", (oldPoint.x * .5) + (.5 * sprite.frame.size.width), scene.frame.size.height - (oldPoint.y * .5) - (sprite.frame.size.height * .5));
    
    return newPoint;
}


@end
