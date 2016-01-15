//
//  CDMainMenuViewController.m
//  CookieDD
//
//  Created by gary johnston on 9/30/13.
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

#import "CDMainMenuViewController.h"
#import "MainMapViewController.h"
#import "CDStandardPopupView.h"
#import "CDAccountPopupView.h"
#import "SGAchievementAlertView.h"
#import "CDStoreViewController.h"
#import "SGStoreItemInfoViewController.h"
#import "CDVideoPlayerViewController.h"
#import "WebserviceManager.h"

@interface CDMainMenuViewController () <CDMainButtonViewControllerDelegate, MainMapViewControllerDelegate, CDStandardPopupViewDelegate, CDAccountPopupViewDelegate, CDVideoPlayerViewControllerDelegate>

@property (weak, nonatomic) CDMainMenuScene *theScene;
@property (strong, nonatomic) CDMainButtonViewController *mainButtonViewController;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *gender;

@property (strong, nonatomic) NSDate *birthDate;
@property (strong, nonatomic) NSURL *imageUrl;

@property (assign, nonatomic) BOOL didCreateScene;
@property (assign, nonatomic) BOOL loggingInWithFacebook;

@property (assign, nonatomic) int switchOrientation;
//@property (strong, nonatomic) MainMapViewController *mapViewController;
@property (strong, nonatomic) CDVideoPlayerViewController *videoViewController;

@end

@implementation CDMainMenuViewController

#pragma mark - Initialization

- (void)setup
{
    self.didCreateScene = NO;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
//        [self setup];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cleanupMemory];
}

- (void)cleanupMemory
{
    _firstName = nil;
    _lastName = nil;
    _emailAddress = nil;
    _gender = nil;
    _birthDate = nil;
    _imageUrl = nil;
    
    [_theScene removeAllActions];
    for (SKNode *node in _theScene.children) {
        [node removeAllActions];
    }
    [_theScene removeAllChildren];
    [_theScene.view removeFromSuperview];
    _theScene = nil;
    
    [_mainButtonViewController removeFromParentViewController];
    _mainButtonViewController = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.didCreateScene = NO;
    self.isProcessingAccountInformation = NO;
    self.loggingInWithFacebook = NO;
    
    self.firstName = @"First Name";
    self.lastName = @"Last Name";
    self.emailAddress = @"Email Address";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseMenuScene) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unpauseMenuScene) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if (!_mainButtonViewController) {
        _mainButtonViewController = [[CDMainButtonViewController mainButton] didCreateMainButtonViewWithParentalViewController:self];
        _mainButtonViewController.delegate = self;
    }
    
    // Debug control for achievements.
//    UIButton *resetAchievementsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, self.view.frame.size.height - 50, 100, 30)];
//    [resetAchievementsButton addTarget:self action:@selector(resetAchievements) forControlEvents:UIControlEventTouchUpInside];
//    [resetAchievementsButton setTitle:@"Reset Achievements" forState:UIControlStateNormal];
//    [resetAchievementsButton.titleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:9.0f]];
//    [resetAchievementsButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
//    [self.view addSubview:resetAchievementsButton];
    
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
//    _mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMapViewController"];
//    _mapViewController.delegate = self;
    
    _videoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CDVideoPlayerViewController"];
    _videoViewController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitApp) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterApp) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //JD's Test Calls
    
//    [[WebserviceManager sharedManager] requestToCreateAccountWithEmail:@"jdpagley@yahoo.com" deviceId:@"111111" firstName:@"Josh" lastName:@"Pagley" gender:@"male" birthdate:nil facebookID:@"111111" deviceToken:@"111111" profileImageStringURL:@"http://test.com/profileavatar" completionHandler:nil];
    
//    [[WebserviceManager sharedManager] requestToUpdateAccountWithEmail:@"jdpagley@yahoo.com" deviceId:nil firstName:nil lastName:@"pagley" gender:nil birthdate:nil facebookID:nil didRecieveGift:[NSNumber numberWithInt:1] completionHandler:nil];
    
//    [[WebserviceManager sharedManager] requestToFetchAccountWithAccountId:@"53583e0a1167214971000001" completionHandler:nil];
    
//    [[WebserviceManager sharedManager] updateWorldParametersWithEmail:@"jdpagley@yahoo.com" deviceId:nil worldType:[NSNumber numberWithInt:3] worldName:@"cookie city" completionHandler:nil];

//    [[WebserviceManager sharedManager] updateLevelParametersWithEmail:@"jdpagley@yahoo.com" deviceId:nil worldType:[NSNumber numberWithInt:3] levelType:[NSNumber numberWithInt:2] starCount:[NSNumber numberWithInt:3] highScore:[NSNumber numberWithInt:33000] completionHandler:nil];
    
    
//    [[WebserviceManager sharedManager] requestToUpdateLivesRegenerationTimeWithEmail:@"jdpagley@yahoo.com" minutes:[NSNumber numberWithInt:7733] completionhandler:nil];
    
//     [[WebserviceManager sharedManager] requestAwardRegenerationTimeWithEmail:@"jdpagley@yahoo.com" completionhandler:nil];
    
//       [[WebserviceManager sharedManager] requestToUpdateAwardRegenerationTimeWithEmail:@"jdpagley@yahoo.com" minutes:[NSNumber numberWithInt:700] completionhandler:nil];
    
//    [[WebserviceManager sharedManager] requestToUpdateAwardRegenerationTimeWithAccountId:@"53583e0a1167214971000001" minutes:[NSNumber numberWithInt:700] completionhandler:^
//     (NSError *error, NSDictionary *timeInfo)
//     {
//         if (!error && timeInfo)
//         {
//             DebugLog(@"timeInfo => %@", timeInfo);
//         }
//     }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    if (self.theScene)
    {
        self.theScene.paused = NO;
        self.theScene.userInteractionEnabled = YES;
    }
    if (_videoViewController.moviePlayer)
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.videoViewController.moviePlayer play];
        });
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
 
    self.view.userInteractionEnabled = YES;
    
    
}

- (void)exitApp
{
    DebugLog(@"exiting app!");
    
    if (self.theScene)
    {
        SKView *skView = (SKView *) self.view;
        skView.paused = YES;
        
        self.theScene.paused = YES;
        [self.theScene.view setPaused:YES];
        [[SGAudioManager audioManager] pauseAllAudio];
        
//        __weak typeof(self) weakSelf = self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            SKView *skView = (SKView *) weakSelf.view;
//            skView.paused = YES;
//            
//            weakSelf.theScene.paused = YES;
//            [weakSelf.theScene.view setPaused:YES];
//            [[SGAudioManager audioManager] pauseAllAudio];
//            DebugLog(@"Finished exiting the app.");
//        });
    }
    if (_videoViewController.moviePlayer)
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.videoViewController.moviePlayer pause];
        });
    }
}

- (void)enterApp
{
    self.theScene.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;

    DebugLog(@"entering app!");
    
    if (_isProcessingAccountInformation)
    {
        _isProcessingAccountInformation = NO;
    }
    
    if (self.theScene)
    {
        if (!self.loggingInWithFacebook)
        {
            SKView *skView = (SKView *) self.view;
            skView.paused = NO;
            skView.userInteractionEnabled = YES;
            
            self.theScene.userInteractionEnabled = YES;
        }
        else
        {
            self.theScene.userInteractionEnabled = NO;
        }
        
        self.theScene.whichCookie = 0;
        [self.theScene.view setPaused:NO];
        
        self.theScene.view.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
        [[SGAudioManager audioManager] playAllAudio];
        
//        __weak typeof(self) weakSelf = self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            SKView *skView = (SKView *) weakSelf.view;
//            skView.paused = NO;
//            
//            weakSelf.theScene.whichCookie = 0;
//            [weakSelf.theScene.view setPaused:NO];
//            weakSelf.theScene.view.userInteractionEnabled = YES;
//            weakSelf.view.userInteractionEnabled = YES;
//            [[SGAudioManager audioManager] playAllAudio];
//        });
    }
    if (_videoViewController.moviePlayer)
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.videoViewController.moviePlayer play];
        });
    }
}

- (void)resetAchievements {
    [[SGGameCenterManager gcManager] resetAchievements];
    [[CDPlayerObject player] resetAchievmentProperties];
}


- (void)viewDidAppear:(BOOL)animated {
    // Load Game Center.
    [[SGGameCenterManager gcManager] authenticateLocalUserOnViewController:self setCallbackObject:nil withPauseSelector:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Custom Methods

- (void)deallocMemory
{
    [self.theScene.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKNode* child = obj;
        [child removeAllActions];
        [child removeFromParent];
    }];
    
    [self.theScene removeAllChildren];
//    self.theScene = nil;
    self.didCreateScene = NO;
    [self.theScene removeFromParent];
    [self.theScene.view removeFromSuperview];
    self.theScene = nil;
    //DebugLog(@"MainMenu - remove scene");
    //[[SGGameManager gameManager] Remove_Scene];
}

- (void)pauseMenuScene
{
    SKView *skView = (SKView *)self.theScene.view;
    [skView setPaused:YES];
    [_theScene setPaused:YES];
    [[SGAppDelegate appDelegate] dismissConditionalView];
}

- (void)unpauseMenuScene
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SKView *skView = (SKView *)weakSelf.theScene.view;
        [skView setPaused:NO];
        [weakSelf.theScene setPaused:NO];
        
        if (weakSelf.loggingInWithFacebook)
        {
            weakSelf.theScene.userInteractionEnabled = YES;
        }
        
        weakSelf.theScene.paused = NO;
        skView.userInteractionEnabled = YES;
        weakSelf.view.userInteractionEnabled = YES;
    });
}

- (void)presentScene
{
    if (!self.didCreateScene)
    {
        // Setup the button
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            SKView *gameView = [[SKView alloc] initWithFrame:weakSelf.view.frame];
            [weakSelf.view insertSubview:gameView belowSubview:_mainButtonViewController.view];
            SKView * skView = (SKView *)gameView;
            weakSelf.theScene = [CDMainMenuScene sceneWithSize:skView.bounds.size];
            weakSelf.theScene.delegate = self;
            weakSelf.theScene.parentViewController = self;
            weakSelf.theScene.scaleMode = SKSceneScaleModeResizeFill;
            [skView presentScene:weakSelf.theScene];

            weakSelf.didCreateScene = YES;
            
            weakSelf.mainButtonViewController.parentViewFrame = weakSelf.view.frame;
            weakSelf.mainButtonViewController.conditionalViewFrame = weakSelf.theScene.frame;
        });
    }
    else
    {
        [_theScene putTheCookiesInTheWrappers];
        if (_loggingInWithFacebook)
        {
            _theScene.userInteractionEnabled = YES;
        }
    }

//    [self willAnimateRotationToInterfaceOrientation:[self interfaceOrientation] duration:0.0];
}

- (void)updateInfo
{
    [self playMainGame];
}

- (void)setupSomeDefaultStuff
{
    NSMutableArray *costumeArray = [NSMutableArray arrayWithArray:[[SGAppDelegate appDelegate].accountDict objectForKey:@"cookieCostumes"]];
    
    NSUserDefaults *cookieCostumesArrayDefault = [NSUserDefaults standardUserDefaults];
    NSArray *defaultArray = [NSMutableArray arrayWithArray:[cookieCostumesArrayDefault objectForKey:CookieCostumeArrayDefault]];
    
    NSMutableArray *costumesForDefaultArray = [NSMutableArray new];
    
    
    for (NSDictionary *dictionary in costumeArray)
    {
        for (NSDictionary *defaultDictionary in defaultArray)
        {
            if ([[dictionary objectForKey:@"name"] isEqualToString:[defaultDictionary objectForKey:@"cookieName"]] && [[dictionary objectForKey:@"theme"] isEqualToString:[defaultDictionary objectForKey:@"imageTheme"]])
            {
                if (![dictionary objectForKey:@"isUnlocked"])
                {
                    NSMutableDictionary *newCostumeDictionary = [NSMutableDictionary new];
                    
                    if ([[dictionary objectForKey:@"name"] isEqualToString:KeyNameChip])
                    {
                        newCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameChip, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-chip"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
                    }
                    else if ([[dictionary objectForKey:@"name"] isEqualToString:KeyNameDustinMartianMint])
                    {
                        newCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameDustinMartianMint, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-dustin"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
                    }
                    else if ([[dictionary objectForKey:@"name"] isEqualToString:KeyNameLukeLocoLemon])
                    {
                        newCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameLukeLocoLemon, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-luke"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
                    }
                    else if ([[dictionary objectForKey:@"name"] isEqualToString:KeyNameMikeyMcSprinkles])
                    {
                        newCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameMikeyMcSprinkles, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-mikey"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
                    }
                    else if ([[dictionary objectForKey:@"name"] isEqualToString:KeyNameJJJams])
                    {
                        newCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameJJJams, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-jj"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
                    }
                    else if ([[dictionary objectForKey:@"name"] isEqualToString:KeyNameReginald])
                    {
                        newCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameReginald, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-reginald"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
                    }
                    else if ([[dictionary objectForKey:@"name"] isEqualToString:KeyNameGerryJ])
                    {
                        newCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameGerryJ, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-gerry"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
                    }
                    else
                    {
                        DebugLog(@"WTF????");
                    }
                    
                    [costumesForDefaultArray addObject:newCostumeDictionary];
                }
                else
                {
                    [costumesForDefaultArray addObject:defaultDictionary];
                }
            }
            else if ([[defaultDictionary objectForKey:@"imageTheme"] isEqualToString:KeyThemeDefault] && !([costumesForDefaultArray containsObject:defaultDictionary]))
            {
                [costumesForDefaultArray addObject:defaultDictionary];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:costumesForDefaultArray forKey:CookieCostumeArrayDefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)runFacebookAuthorization
{
    if ([[SGAppDelegate appDelegate]fetchPlayerEmail] || [[SGAppDelegate appDelegate] fetchPlayerDeviceID])
    {
        _theScene.userInteractionEnabled = NO;
        _theScene.paused = YES;

        [self playMainGame];
    }
    else
    {
        _isProcessingAccountInformation = YES;
        [SGAppDelegate appDelegate].loggedInThroughFacebook = YES;
        
        __weak typeof(self) weakSelf = self;

        [[SGSocialManager socialManager] openSessionFacebookWithCompletionHandler:^(FBSession *session, FBSessionState state, NSError *error)
         {
             if (!error)
             {
                 if (state != FBSessionStateOpen)
                 {
                     
                 }
                 switch (state)
                 {
                     case FBSessionStateOpen:
                     {
                         DebugLog(@"FBSessionStateOpen");
                         _theScene.userInteractionEnabled = NO;
                         [[SGSocialManager socialManager] requestUserInfoFromFacebookWithCompletionHandler:^(NSError *error, NSDictionary *userInfo)
                          {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  if (!error && userInfo)
                                  {
                                      if (userInfo[@"email"])
                                      {
                                          weakSelf.emailAddress = userInfo[@"email"];
                                      }
                                      
                                      if (userInfo[@"first_name"])
                                      {
                                          weakSelf.firstName = userInfo[@"first_name"];
                                      }
                                      
                                      if (userInfo[@"last_name"])
                                      {
                                          weakSelf.lastName = userInfo[@"last_name"];
                                      }
                                      
                                      if (userInfo[@"birthday"])
                                      {
                                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                          [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                                          weakSelf.birthDate = [dateFormatter dateFromString:userInfo[@"birthday"]];
                                      }
                                      
                                      if (userInfo[@"gender"])
                                      {
                                          weakSelf.gender = userInfo[@"gender"];
                                      }
                                      
                                      NSString *facebookId = nil;
                                      
                                      NSString *stringURL = nil;
                                      if (userInfo[@"id"])
                                      {
                                          facebookId = userInfo[@"id"];
                                          
                                          [[NSUserDefaults standardUserDefaults] setObject:facebookId forKey:@"facebookId"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          stringURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=600&height=600", facebookId];
                                          weakSelf.imageUrl = [NSURL URLWithString:stringURL];
                                      }
                                      
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                      
                                      
                                      
                                      [[WebserviceManager sharedManager] requestToCreateAccountWithEmail:weakSelf.emailAddress
                                                                                                deviceId:[SGAppDelegate appDelegate].currentDeviceID
                                                                                               firstName:weakSelf.firstName
                                                                                                lastName:weakSelf.lastName
                                                                                                  gender:weakSelf.gender
                                                                                               birthdate:weakSelf.birthDate
                                                                                              facebookID:facebookId
                                                                                             deviceToken:[SGAppDelegate appDelegate].currentDeviceTokenId
                                                                                   profileImageStringURL:stringURL
                                                                                       completionHandler:^
                                       (NSDictionary *dictionary, NSError *error)
                                       {
                                           if (dictionary)
                                           {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   weakSelf.view.userInteractionEnabled = YES;
                                                   [SGAppDelegate appDelegate].isLoggedIntoFacebook = YES;
                                                   
                                                   if (dictionary[@"account"] && [dictionary[@"account"] isKindOfClass:[NSDictionary class]])
                                                   {
                                                       [SGAppDelegate appDelegate].accountDict = [dictionary[@"account"] mutableCopy];
                                                       
                                                       // GARY J: I'M WORKING HERE!
                                                       
                                                       [self setupSomeDefaultStuff];
                                                       
                                                       [weakSelf playMainGame];
                                                   }
                                                   else
                                                   {
                                                       [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:_theScene.frame errorDescription:@"An error has occurred" loadingText:nil];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           
                                                           weakSelf.view.userInteractionEnabled = YES;
                                                       });
                                                   }
                                               });
                                           }
                                           else if (error)
                                           {
                                               DebugLog(@"ERROR: %@", error);
                                               [[SGAppDelegate appDelegate] dismissConditionalView];
                                               [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:_theScene.frame errorDescription: [NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   weakSelf.view.userInteractionEnabled = YES;
                                               });
                                           }
                                           else
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   weakSelf.view.userInteractionEnabled = YES;
                                               });
                                           }
                                       }];
                                      
                                      [[SGSocialManager socialManager] socialClassRequestAccessFriendsFromFacebook];
                                  }
                              });
                          }];
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
             else
             {
                 __weak typeof(self) weakSelf = self;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[SGAppDelegate appDelegate] dismissConditionalView];
                     [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:_theScene.frame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];

                     
                     SKView *skView = (SKView *)weakSelf.theScene.view;
                     [skView setPaused:NO];
                     skView.userInteractionEnabled = YES;
                     
                     weakSelf.theScene.paused = NO;
                     weakSelf.theScene.userInteractionEnabled = YES;
                     weakSelf.view.userInteractionEnabled = YES;
                     
                     weakSelf.isProcessingAccountInformation = NO;
                 });
          
                 return;
             }
         }];
    }
}

- (void)playMainGame
{
    self.isProcessingAccountInformation = NO;

    [[SGAudioManager audioManager] stopTheMusic];
    [_theScene removeAllActions];
    [_theScene removeAllChildren];
    _theScene = nil;
    
    NSUserDefaults *videoDefault = [NSUserDefaults standardUserDefaults];
    BOOL playVideo = [videoDefault boolForKey:WatchedIntroVideoDefault];
    
    if (!playVideo)
    {
        SKView *skView = (SKView *) self.view;
        skView.userInteractionEnabled = YES;
        
        self.view.userInteractionEnabled = YES;
        
        [self.view addSubview:_videoViewController.view];
        [_videoViewController playVideoNamed:@"CDDIntroVid"];
        
        [videoDefault setBool:YES forKey:WatchedIntroVideoDefault];
    }
    else
    {
        [self gotoMap];
    }
    
    [[SGAppDelegate appDelegate] dismissConditionalView];
}

- (void)loginAnonymousAccount
{
    __weak typeof(self) weakSelf = self;

    if ([[SGAppDelegate appDelegate]fetchPlayerEmail] || [[SGAppDelegate appDelegate] fetchPlayerDeviceID])
    {
        self.view.userInteractionEnabled = YES;

        [self playMainGame];
    }
    else
    {
        _isProcessingAccountInformation = YES;
        [SGAppDelegate appDelegate].loggedInThroughFacebook = NO;
        [[WebserviceManager sharedManager] requestToCreateAccountWithEmail:nil
                                                                  deviceId:[SGAppDelegate appDelegate].currentDeviceID
                                                                 firstName:nil
                                                                  lastName:nil
                                                                    gender:nil
                                                                 birthdate:nil
                                                                facebookID:nil
                                                               deviceToken:[SGAppDelegate appDelegate].currentDeviceTokenId
                                                     profileImageStringURL:nil
                                                         completionHandler:^
         (NSDictionary *dictionary, NSError *error)
         {
             if (!error && dictionary)
             {
                 if (dictionary[@"account"])
                 {
                     [SGAppDelegate appDelegate].accountDict = [dictionary[@"account"] mutableCopy];
                 }
                 
                 [self setupSomeDefaultStuff];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     weakSelf.view.userInteractionEnabled = YES;
                     
                     [weakSelf playMainGame];
                 });
             }
             else if (error)
             {
                 [[SGAppDelegate appDelegate] dismissConditionalView];
                 [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:weakSelf.view.frame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     weakSelf.view.userInteractionEnabled = YES;
                 });
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     weakSelf.view.userInteractionEnabled = YES;
                 });
             }
         }];
    }
}

- (void)gotoMap {
    
    MainMapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMapViewController"];
    
    [[SGAppDelegate appDelegate] transitionFadeWithParentViewController:self
                                            endTransitionViewController:mapViewController
                                                          withImageName:nil
                                                          navController:NavControllerTransitionType_Push
                                                  willAnimateTransition:NO];
    
}

#pragma mark - CDMainMenuScene delegate

- (void)didDunkACookie:(BOOL)hitPlayButton
{
    if (!_isProcessingAccountInformation)
    {
        self.view.userInteractionEnabled = NO;

        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self
                                                                        withConditionType:ConditionalType_Default
                                                                         presentationType:PresentationType_Loading
                                                                                withFrame:self.view.frame
                                                                         errorDescription:nil loadingText:nil];
        if (hitPlayButton)
        {
            [self loginAnonymousAccount];
        }
        else
        {
            [self runFacebookAuthorization];
        }
    }
}


#pragma mark - MainMapViewControllerDelegate

- (void)mainMapViewControllerDidPoptoMainMenu:(MainMapViewController *)controller
{
    _switchOrientation = portraitOrientation;
    [self presentScene];
    
    UIViewController *disposableViewController = [[UIViewController alloc] init];
    [self presentViewController:disposableViewController animated:NO completion:nil];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)mainMapDidAppearAndWillDeallocMainMenu
{
    [self deallocMemory];
}

#pragma mark - Main Button Delegates

- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction
{
    _theScene.userInteractionEnabled = !willDisableInteraction;
    _theScene.paused = willDisableInteraction;
}

- (void)mainButtonSubButtonWasHitWithIndex:(int)buttonIndex
{
    if (buttonIndex == soundButtonIndex)
    {
        DebugLog(@"THE SOUND BUTTON WAS HIT");
        //[[SGAudioManager audioManager] updateSoundLevels];
    }
    else if (buttonIndex == backButtonIndex)
    {
        DebugLog(@"THE BACK BUTTON WAS HIT");
        [_mainButtonViewController mainButtonHit:_mainButtonViewController.mainButton];
    }
    else if (buttonIndex == helpButtonIndex)
    {
        DebugLog(@"THE HELP BUTTON WAS HIT");
        CDStandardPopupView *standardPopup;
        
        if (IS_IPHONE_4 || IS_IPAD)
        {
            standardPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
        }
        else if (IS_IPHONE_5)
        {
            standardPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
        }
        
        standardPopup.delegate = self;
        standardPopup.whatAmILoading = @"mainGameHelp";
        
        standardPopup.frame = CGRectMake(0, 0, _theScene.frame.size.width, _theScene.frame.size.height);
        [self.view insertSubview:standardPopup aboveSubview:_mainButtonViewController.view];
        [standardPopup setup];
        
        _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else if (buttonIndex == volumeButtonIndex)
    {
        DebugLog(@"THE VOLUME BUTTON WAS HIT");
        //[[SGAudioManager audioManager] updateSoundLevels];
    }
    else if (buttonIndex == shopButtonIndex)
    {
        DebugLog(@"THE SHOP BUTTON WAS HIT");
        _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else if (buttonIndex == accountButtonIndex)
    {
        DebugLog(@"THE ACCOUNT BUTTON WAS HIT");
        if ([SGAppDelegate appDelegate].accountDict)
        {
            CDAccountPopupView *popup;
            //        if (IS_IPHONE_4 || IS_IPAD)
            //        {
            //            popup = [[[NSBundle mainBundle] loadNibNamed:@"CDAccountPopupIphone5View" owner:self options:nil] objectAtIndex:0];
            //        }
            //        else if (IS_IPHONE_5)
            //        {
            popup = [[[NSBundle mainBundle] loadNibNamed:@"CDAccountPopupIphone5View" owner:self options:nil] objectAtIndex:0];
            //            [popup.backgroundImage setImage:[UIImage imageNamed:@"cdd-main-board-hud-minigamepanel-v-568h"]];
            //        }
            
            popup.delegate = self;
            popup.frame = CGRectMake(0, 0, _theScene.frame.size.width, _theScene.frame.size.height);
            [self.view insertSubview:popup aboveSubview:_mainButtonViewController.view];
            [popup setupWithParentalViewController:self];
            
            _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

        }
        else
        {
            [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:_theScene.frame errorDescription:@"You are not currently logged in. Please Login to view your account." loadingText:nil];
            
            _mainButtonViewController.popupIsUp = NO;
            [_mainButtonViewController enableButtons:YES];
        }
    }
    else if (buttonIndex == settingsButtonIndex)
    {
        DebugLog(@"THE SETTINGS BUTTON WAS HIT");
    }
    else if (buttonIndex == facebookButtonIndex)
    {
        DebugLog(@"THE FACEBOOK BUTTON WAS HIT");
    }
    else if (buttonIndex == twitterButtonIndex)
    {
        DebugLog(@"THE TWITTER BUTTON WAS HIT");
    }
    else if (buttonIndex == googleButtonIndex)
    {
        DebugLog(@"THE GOOGLE BUTTON WAS HIT");
    }
}

#pragma mark - Account Screen Delegate
- (void)exitButtonWasHitOnAccountPopup:(CDAccountPopupView *)accountView
{
    [accountView removeFromSuperview];
    _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _mainButtonViewController.popupIsUp = NO;
    
    [_mainButtonViewController enableButtons:YES];
}

- (void)addCoinsButtonWasHitOnAccountPopup:(CDAccountPopupView *)accountView
{
    [accountView removeFromSuperview];
}

#pragma mark - Help Screen Delegate
- (void)exitButtonWasHitOnStandardPopupView:(CDStandardPopupView *)standardPopup
{
    [standardPopup removeFromSuperview];
    _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _mainButtonViewController.popupIsUp = NO;
    
    [_mainButtonViewController enableButtons:YES];
}

#pragma mark - Video Player ViewController Delegate
- (void)videoPlayerHasEnded:(CDVideoPlayerViewController *)videoViewController
{
    DebugLog(@"Video has ended and reached delegate");
    [self gotoMap];
    
    _videoViewController = nil;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [_videoViewController.view removeFromSuperview];
    });
}

#pragma mark - Device Orientation

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
//    if (_mainButtonViewController)
//    {
//        [_mainButtonViewController orientationHasChanged:interfaceOrientation WithDuration:duration];
//    }
    
    //    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    //    {
    //        DebugLog(@"land");
    //        [self.theScene Rotate_to_Landscape:duration];
    //    }
    //    else
    //    {
    //        DebugLog(@"port");
    //        [self.theScene Rotate_to_Portrait:duration];
    //    }
}

- (void)orientationChanged:(NSNotification *)notification
{
//    self.view.frame = self.view.superview.bounds;
}

- (BOOL)shouldAutorotate
{
//    if (_switchOrientation == allButUpsideDownOrientation)
//    {
//        return YES;
//    }
//    else
//    {
        return NO;
//    }
}

- (NSUInteger)supportedInterfaceOrientations
{
//    if (_switchOrientation == portraitOrientation)
//    {
        return UIInterfaceOrientationMaskPortrait;
//    }
//    else if (_switchOrientation == landscapeOrientation)
//    {
//        return UIInterfaceOrientationMaskLandscape;
//    }
//    else if (_switchOrientation == allButUpsideDownOrientation)
//    {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//    else
//    {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
//    if (_switchOrientation == portraitOrientation)
//    {
        return UIInterfaceOrientationPortrait;
//    }
//    else if (_switchOrientation == landscapeLeftOrientation)
//    {
//        return UIInterfaceOrientationLandscapeLeft;
//    }
//    else if (_switchOrientation == landscapeLeftOrientation)
//    {
//        return UIInterfaceOrientationLandscapeLeft;
//    }
//    else if (_switchOrientation == allButUpsideDownOrientation)
//    {
//        return UIInterfaceOrientationPortrait;
//    }
//    else
//    {
//        return 0;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
