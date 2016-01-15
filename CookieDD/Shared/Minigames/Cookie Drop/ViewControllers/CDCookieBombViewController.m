//
//  CDCookieBombViewController.m
//  CookieDD
//
//  Created by gary johnston on 10/4/13.
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

#import "CDCookieBombViewController.h"
#import "CDCookieBombScene.h"
#import "CDMiniGamePopupView.h"
#import "CDStandardPopupView.h"
#import "CDAccountPopupView.h"
#import "CDAwardPopupViewController.h"
#import "CDStoreViewController.h"
#import "SGStoreItemInfoViewController.h"
#import "SGFileManager.h"

@interface CDCookieBombViewController () <CDMiniGamePopupViewDelegate, CDMainButtonViewControllerDelegate, CDStandardPopupViewDelegate, CDAccountPopupViewDelegate, CDAwardPopupViewControllerDelegate, SGStoreItemInfoViewControllerDelegate>

@property (strong, nonatomic) CDCookieBombScene *scene;
@property (strong, nonatomic) CDMainButtonViewController *mainButtonViewController;
@property (weak, nonatomic) CDMiniGamePopupView *difficultyView;
@property (weak, nonatomic) CDStandardPopupView *helpPopup;

@property (assign, nonatomic) BOOL didCreateScene;
@property (assign, nonatomic) BOOL didCreatePopup;

@end


@implementation CDCookieBombViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.view.multipleTouchEnabled = NO;
    
    self.didCreateScene = NO;
    self.didCreatePopup = NO;
    
    UIViewController *disposableViewController = [[UIViewController alloc] init];
    [self presentViewController:disposableViewController animated:NO completion:nil];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    // Play the theme.
//    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"cookieDrop_theme" FileType:@"m4a" volume:0.3f numberOfLoopes:-1];
    
    // Setup the button
    _mainButtonViewController = [[CDMainButtonViewController mainButton] didCreateMainButtonViewWithParentalViewController:self];
    _mainButtonViewController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitApp) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterApp) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)exitApp
{
    DebugLog(@"exiting app!");
    
    if (self.scene)
    {
        SKView *spriteView = (SKView *) self.view;
        spriteView.paused = YES;
        
        self.scene.paused = YES;
        [self.scene.view setPaused:YES];
        self.scene.userInteractionEnabled = NO;
        [[SGAudioManager audioManager] pauseAllAudio];
    }
}

- (void)enterApp
{
    DebugLog(@"entering app!");
    
    if (self.scene)
    {
        if (self.mainButtonViewController.mainButtonIsDown)
        {
            SKView *spriteView = (SKView *) self.view;
            spriteView.paused = NO;
            self.scene.paused = NO;
            [self.scene.view setPaused:NO];
            self.scene.userInteractionEnabled = YES;
        }
        [[SGAudioManager audioManager] playAllAudio];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!self.didCreateScene)
    {
        SKView * skView = (SKView *)self.view;
        self.scene = [CDCookieBombScene sceneWithSize:skView.bounds.size];
        self.scene.delegate = self;
        self.scene.scaleMode = SKSceneScaleModeResizeFill;
        [skView presentScene:self.scene];
        [self.scene setup];
        
        _mainButtonViewController.parentViewFrame = self.view.frame;
        _mainButtonViewController.conditionalViewFrame = self.view.frame;
        
//        [[SGAudioManager audioManager] playSountrackWithLocation:@"cookieBomb"];
//        
//        NSUserDefaults *volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
//        NSString *volumeButtonState = [volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
//        
//        if ([volumeButtonState isEqualToString:@"high"])
//        {
//            [[SGAudioManager audioManager] adjustVolume:1];
//        }
//        else if ([volumeButtonState isEqualToString:@"low"])
//        {
//            [[SGAudioManager audioManager] adjustVolume:.5];
//        }
//        else if ([volumeButtonState isEqualToString:@"mute"])
//        {
//            [[SGAudioManager audioManager] adjustVolume:0];
//        }
        
        self.didCreateScene = YES;
    }
}

#pragma mark - CDCookieBombScene Delegate

- (void)cookieBombSceneDidEnd:(CDCookieBombScene *)scene WithScore:(int)score WithGoalScore:(int)goalScore WithWin:(BOOL)didWin
{
    NSUserDefaults *highScoreDefault = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [highScoreDefault integerForKey:CookieDropHighScoreDefault];
    if (!self.didCreatePopup)
    {
        _difficultyView = [[[NSBundle mainBundle] loadNibNamed:@"CDEndMinigamePopupIPhone5View" owner:self options:nil] objectAtIndex:0];
        _difficultyView.parentalViewController = self;

        _difficultyView.delegate = self;
        
        _difficultyView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view insertSubview:_difficultyView belowSubview:_mainButtonViewController.view];
        [_difficultyView setup];
        _difficultyView.gameNameLabel.text = @"Cookie Drop";
        
        if (score > highScore)
        {
            [highScoreDefault setInteger:score forKey:CookieDropHighScoreDefault];
//            highScore = score;
            [_difficultyView.bestScoreLabel setText:[NSString stringWithFormat:@"BEST SCORE: %i", score]];
        }
        else
        {
            [_difficultyView.bestScoreLabel setText:[NSString stringWithFormat:@"BEST SCORE: %li", (long)highScore]];
        }
        
        [_difficultyView.scoreLabel setText:[NSString stringWithFormat:@"SCORE: %i", score]];
        
        _difficultyView.score = score;
        _difficultyView.minigameName = @"Cookie Drop";
        
        if (didWin)
        {
            SGGameCenterManager *gcManager = [SGGameCenterManager gcManager];
            // Achievement: Arcade.
            [gcManager reportAchievementWithIdentifier:@"arcade" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
                if (reportWasSuccessful) {
                    [gcManager displayAchievementAlertForAchievementWithIdentifier:@"arcade" InView:_scene.view Completion:^(BOOL completedArcadeAlert) {
                        if (scene.difficulty > 2) { // Difficulty is at least hard.
                            [gcManager reportAchievementWithIdentifier:@"arcade_champ" percentComplete:100.0f Completion:^(BOOL completedChampAlert) {
                                [gcManager displayAchievementAlertForAchievementWithIdentifier:@"arcade_champ" InView:_scene.view Completion:nil];
                            }];
                        }
                    }];
                }
                else {
                    if (scene.difficulty > 2) { // Difficulty is at least hard.
                        [gcManager reportAchievementWithIdentifier:@"arcade_champ" percentComplete:100.0f Completion:^(BOOL completedChampAlert) {
                            [gcManager displayAchievementAlertForAchievementWithIdentifier:@"arcade_champ" InView:_scene.view Completion:nil];
                        }];
                    }
                }
            }];
            
            
            
            _difficultyView.winLoseTextLabel.text = @"GREAT JOB!";
            
            [_difficultyView.cookieIconImage setImage:[UIImage imageNamed:@"cdd-hud-ico-happycookie"]];
            
//            NSUserDefaults *awardsAvailableDefault = [NSUserDefaults standardUserDefaults];
//            NSUInteger awardsAvailable = [awardsAvailableDefault integerForKey:DailyPrizesAwardedDefault];
            
            NSUserDefaults *timeOfAwardLockout = [NSUserDefaults standardUserDefaults];
            
            NSDate *lockoutDate = [timeOfAwardLockout objectForKey:AwardLockoutTimeDefault];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:lockoutDate];
            double secondsInAnHour = 3600;
            NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
            
//            if (awardsAvailable > 0)
//            {
//                DebugLog(@"Awards are still available");
                if (hoursBetweenDates >= 24)
                {
                    DebugLog(@"GIMME THE TIME: %li", (long)hoursBetweenDates);
                    NSUserDefaults *awardsAvailableDefault = [NSUserDefaults standardUserDefaults];
                    [awardsAvailableDefault setInteger:[SGAppDelegate appDelegate].dailyAwardsAllowed forKey:DailyPrizesAwardedDefault];
                }
                else
                {
                    DebugLog(@"GIMME THE TIME: %li", (long)hoursBetweenDates);
                }
//            }
//            else
//            {
//                if (hoursBetweenDates >= 24)
//                {
//                    DebugLog(@"GIMME THE TIME: %li", (long)hoursBetweenDates);
//                    NSUserDefaults *awardsAvailableDefault = [NSUserDefaults standardUserDefaults];
//                    [awardsAvailableDefault setInteger:[SGAppDelegate appDelegate].dailyAwardsAllowed forKey:DailyPrizesAwardedDefault];
//                }
//                else
//                {
//                    DebugLog(@"GIMME THE TIME: %li", (long)hoursBetweenDates);
//                }
//            }
            
            CDAwardPopupViewController *awardPopup = [self.storyboard instantiateViewControllerWithIdentifier:@"CDAwardPopupViewController"];
            awardPopup.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            awardPopup.difficulty = _scene.difficulty;
            awardPopup.delegate = self;
            
            if (scene.difficulty == gameDifficultyLevelHard)
            {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                BOOL doNotAwardGem = [userDefault boolForKey:CookieDropAwardGemDefault];
                
                if (!doNotAwardGem)
                {
                    awardPopup.awardGem = YES;
                    [userDefault setBool:YES forKey:CookieDropAwardGemDefault];
                }
                else
                {
                    awardPopup.awardGem = NO;
                }
            }
            else
            {
                awardPopup.awardGem = NO;
            }
            [self.view addSubview:awardPopup.view];
            [self addChildViewController:awardPopup];
        }
        else
        {
            _difficultyView.winLoseTextLabel.text = @"OH NO!";
            [_difficultyView.cookieIconImage setImage:[UIImage imageNamed:@"cdd-hud-ico-sadcookie"]];

        }
        
        self.didCreatePopup = YES;
        
        self.scene.userInteractionEnabled = NO;
        [self.scene touchesEnded:nil withEvent:nil];
    }
}

- (void)cookieBombDifficultySelect:(CDCookieBombScene *)scene
{
    NSUserDefaults *highScoreDefault = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [highScoreDefault integerForKey:CookieDropHighScoreDefault];
    
    _difficultyView = [[[NSBundle mainBundle] loadNibNamed:@"CDDifficultySelectPopupIPhone5View" owner:self options:nil] objectAtIndex:0];
    _difficultyView.delegate = self;
    _difficultyView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view insertSubview:_difficultyView belowSubview:_mainButtonViewController.view];
    [_difficultyView setup];
    [_difficultyView.bestScoreLabel setText:[NSString stringWithFormat:@"BEST SCORE: %li", (long)highScore]];
    _difficultyView.gameNameLabel.text = @"Cookie Drop";
}

- (void)openShop
{
    _mainButtonViewController.view.clipsToBounds = YES;
    [self loadingScreenHandler];
    
    __weak typeof(self) weakSelf = self;
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [weakSelf dismissViewControllerAnimated:NO completion:^{
                           
                           if ([weakSelf.delegate respondsToSelector:@selector(storeButtonWasHitInCookieBombViewController)])
                           {
                               [weakSelf.delegate storeButtonWasHitInCookieBombViewController];
                           }
                           
                           [weakSelf.loadingScreen.view removeFromSuperview];
                       }];
                   });
}

#pragma mark - Loading Screen

- (void)createLoadingScreenWithImageNamed:(NSString *)imageName
{
    _loadingScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CDLoadingScreenViewController"];
    [self.view addSubview:_loadingScreen.view];
    
    _loadingScreen.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    [_loadingScreen createLoadingScreenWithImageName:imageName];
}

- (void)loadingScreenHandler
{
    [[SGAudioManager audioManager] stopAllAudio];
    //[_scene Shut_The_Cookies_up];
    //[_scene stopBackgroundMusic];
    [_scene removeAllActions];
    _scene = nil;
    
    [(SKView *)self.view presentScene:nil];
    
    NSString *bgImageString = [NSString stringWithFormat:@"Default%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
    [self createLoadingScreenWithImageNamed:bgImageString];
}

#pragma mark - Main Button Delegates

- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction
{
    SKView *spriteView = (SKView *) self.view;
    spriteView.paused = willDisableInteraction;
    
    _scene.userInteractionEnabled = !willDisableInteraction;
    _scene.paused = willDisableInteraction;
    _scene.canMoveCup = !willDisableInteraction;
    
    if (willDisableInteraction)
    {
        _difficultyView.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _helpPopup.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        [[SGAudioManager audioManager] pauseAllSoundEffects];
        //[_scene Shut_The_Cookies_up];
    }
    else {
        [[SGAudioManager audioManager] playAllSoundEffects];
    }
}

- (void)mainButtonIsGoingDown
{
    if (!_helpPopup)
    {
        _difficultyView.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    }
    else
    {
        _helpPopup.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    }
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
        DebugLog(@"BackButton - CookieBombViewController");
        _mainButtonViewController.view.clipsToBounds = YES;
        [self loadingScreenHandler];
        
        double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        });
    }
    else if (buttonIndex == helpButtonIndex)
    {
        DebugLog(@"THE HELP BUTTON WAS HIT");
        
        if (!_helpPopup)
        {
            _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            [_mainButtonViewController mainButtonHit:_mainButtonViewController.mainButton];
            [self helpButtonWasHitOnMiniGamePopupView:YES];
        }
        else
        {
            DebugLog(@"Help Is already up");
            [_mainButtonViewController mainButtonHit:_mainButtonViewController.mainButton];
        }
    }
    else if (buttonIndex == volumeButtonIndex)
    {
        DebugLog(@"THE VOLUME BUTTON WAS HIT");
        
//        NSUserDefaults *volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
//        NSString *volumeButtonState = [volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
//        
//        if ([volumeButtonState isEqualToString:@"mute"])
//        {
//            [_scene Shut_The_Cookies_up];
//        }
    }
    else if (buttonIndex == shopButtonIndex)
    {
        DebugLog(@"THE SHOP BUTTON WAS HIT");
        [self openShop];
    }
    else if (buttonIndex == accountButtonIndex)
    {
        DebugLog(@"THE ACCOUNT BUTTON WAS HIT");
        
        if ([SGAppDelegate appDelegate].accountDict)
        {
            CDAccountPopupView *popup;
            popup = [[[NSBundle mainBundle] loadNibNamed:@"CDAccountPopupIphone5View" owner:self options:nil] objectAtIndex:0];
            
            popup.delegate = self;
            popup.frame = CGRectMake(0, 0, _scene.frame.size.width, _scene.frame.size.height);
            [self.view insertSubview:popup aboveSubview:_mainButtonViewController.view];
            [popup setupWithParentalViewController:self];
            
            _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        }
        else
        {
            [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:_scene.frame errorDescription:@"You are not currently logged in. Please Login to view your account." loadingText:nil];
            
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
    [self openShop];
}

#pragma mark - Standard Popup Delegate
- (void)exitButtonWasHitOnStandardPopupView:(CDStandardPopupView *)standardPopup
{
    [standardPopup removeFromSuperview];
    if (!_mainButtonViewController.mainButtonIsDown)
    {
        _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    }
    else
    {
        _difficultyView.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    }
    _mainButtonViewController.popupIsUp = NO;

    [_mainButtonViewController enableButtons:YES];
}

#pragma mark - Awards Popup Delegate
- (void)didTapScreenToDismissAwardsPopupViewController:(CDAwardPopupViewController *)awardsPopupViewController
{
    [awardsPopupViewController.view removeFromSuperview];
}

#pragma mark - CDMiniGamePopupView Delegate

-(void)helpButtonWasHitOnMiniGamePopupView:(BOOL)isOpen
{
    if (isOpen)
    {
        _helpPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
        
        _helpPopup.delegate = self;
        _helpPopup.whatAmILoading = @"cookieDropHelp";
        
        _helpPopup.frame = _scene.frame;//CGRectMake(0, 0, _scene.frame.size.height, _scene.frame.size.width);
        [self.view insertSubview:_helpPopup belowSubview:_mainButtonViewController.view];
        [_helpPopup setup];
        
        _mainButtonViewController.popupIsUp = YES;
        _difficultyView.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else
    {
        _mainButtonViewController.popupIsUp = NO;
        _difficultyView.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        [_helpPopup removeFromSuperview];
        _helpPopup = nil;
    }
}

- (void)exitButtonWasHitOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView
{
    _mainButtonViewController.delegate = self;
    
    [miniGamePopupView removeFromSuperview];
    
    [[SGAudioManager audioManager] stopAllAudio];

    
    [self loadingScreenHandler];
    
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self dismissViewControllerAnimated:NO completion:nil];
                   });
}

- (void)difficultyWasSelectedOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView WithDifficulty:(int)difficulty
{
    [miniGamePopupView removeFromSuperview];
    
    self.scene.difficulty = difficulty;
    [self.scene startMiniGame];
}

- (void)shopWasSelectedOnMiniGamePopUpView
{
    DebugLog(@"shop button was hit");
}

- (void)menuWasSelectedOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView
{
    DebugLog(@"menu button was hit");
//    _mainButtonViewController.delegate = self;
    
    [miniGamePopupView removeFromSuperview];
    
    [[SGAudioManager audioManager] stopAllAudio];
    
    [self loadingScreenHandler];
    
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self dismissViewControllerAnimated:NO completion:nil];
                   });
}

- (void)replayWasSelectedOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView
{
    DebugLog(@"replay button was hit");
    
    [_scene removeAllActions];
    [_scene removeAllChildren];
    _scene = nil;
    
    [miniGamePopupView removeFromSuperview];
    
    [[SGAudioManager audioManager] stopAllAudio];
    
    [self loadingScreenHandler];
    
    double delayInSeconds = 0;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self dismissViewControllerAnimated:NO completion:^{
                           [_loadingScreen.view removeFromSuperview];
                           if ([self.delegate respondsToSelector:@selector(replayButtonWasHitOnCookieDropViewController)])
                           {
                               [self.delegate replayButtonWasHitOnCookieDropViewController];
                           }
                       }];
                   });
}

#pragma mark - Device Orientation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (_mainButtonViewController)
    {
        [_mainButtonViewController orientationHasChanged:toInterfaceOrientation WithDuration:duration];
    }
}

- (void)dealloc
{
    DebugLog(@"Did dealloc cookie drop!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
