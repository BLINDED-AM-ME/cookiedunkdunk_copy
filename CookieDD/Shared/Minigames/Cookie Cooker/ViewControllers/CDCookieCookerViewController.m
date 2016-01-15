//
//  CDCookieCookerViewController.m
//  CookieDD
//
//  Created by gary johnston on 9/26/13.
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

#import "CDCookieCookerViewController.h"
#import "CDMiniGamePopupView.h"
#import "CDAccountPopupView.h"
#import "CDAwardPopupViewController.h"
#import "CDStoreViewController.h"
#import "CDStandardPopupView.h"
#import "SGFileManager.h"
#import "SGStoreItemInfoViewController.h"

@interface CDCookieCookerViewController () <CDMiniGamePopupViewDelegate, CDMainButtonViewControllerDelegate, CDStandardPopupViewDelegate, CDAccountPopupViewDelegate, CDAwardPopupViewControllerDelegate>

@property (strong, nonatomic) CDCookieCookerScene *scene;
@property (weak, nonatomic) CDMiniGamePopupView *difficultyView;
@property (strong, nonatomic) CDMainButtonViewController *mainButtonViewController;
@property (weak, nonatomic) CDStandardPopupView *helpPopup;

@property (assign, nonatomic) BOOL didCreateScene;
@property (assign, nonatomic) BOOL didCreatePopup;
@property (assign, nonatomic) BOOL loadingScreenIsUp;

@end


@implementation CDCookieCookerViewController

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
    
    // Play the theme music.
//    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"Cookie-Cooker" FileType:@"m4a" volume:0.3f numberOfLoopes:-1];
    
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
        }
        [[SGAudioManager audioManager] pauseAllAudio];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!self.didCreateScene)
    {
        SKView *skView = (SKView *)self.view;
        self.scene = [CDCookieCookerScene sceneWithSize:skView.bounds.size];
        self.scene.delegate = self;
        self.scene.scaleMode = SKSceneScaleModeResizeFill;
        [skView presentScene:self.scene];
        [self.scene setup];
    
        self.didCreateScene = YES;
        
        _mainButtonViewController.parentViewFrame = self.view.frame;
        _mainButtonViewController.conditionalViewFrame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);;
    }
}

- (void)openShop
{
    _mainButtonViewController.view.clipsToBounds = YES;
    
    [self loadingScreenHandler];
    
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self dismissViewControllerAnimated:NO completion:^{
                           if ([self.delegate respondsToSelector:@selector(storeButtonWasHitInCookieCooker)])
                           {
                               [self.delegate storeButtonWasHitInCookieCooker];
                           }
                           [_loadingScreen.view removeFromSuperview];
                       }];
                   });
}

#pragma mark - Loading Screen

- (void)loadingScreenHandler
{
    _loadingScreenIsUp = YES;
    [_scene removeAllActions];
    [_scene removeAllChildren];
    //[_scene stopBackGroundMusic];
    [[SGAudioManager audioManager] stopAllAudio];
    _scene = nil;
    
    NSString *bgImageString = [NSString stringWithFormat:@"Default-landscape%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
    [self createLoadingScreenWithImageNamed:bgImageString];
}


- (void)createLoadingScreenWithImageNamed:(NSString *)imageName
{
    self.loadingScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CDLoadingScreenViewController"];
    [self.view addSubview:self.loadingScreen.view];
    
    self.loadingScreen.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);
    
    [self.loadingScreen createLoadingScreenWithImageName:imageName];
}

#pragma mark - CDCookieCookerScene Delegate

- (void)cookieCookerWillPresentDifficultyScreen:(CDCookieCookerScene *)scene
{
    NSUserDefaults *highScoreDefault = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [highScoreDefault integerForKey:CookieCookerHighScoreDefault];

    _difficultyView = [[[NSBundle mainBundle] loadNibNamed:@"CDDifficultySelectPopupIPhone5View" owner:self options:nil] objectAtIndex:0];
    _difficultyView.delegate = self;
    _difficultyView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    [self.view insertSubview:_difficultyView belowSubview:_mainButtonViewController.view];
    [_difficultyView setup];
    [_difficultyView.bestScoreLabel setText:[NSString stringWithFormat:@"BEST SCORE: %li", (long)highScore]];
    _difficultyView.gameNameLabel.text = @"Cookie Cooker";
}

- (void)cookieCookerSceneDidEndScene:(CDCookieCookerScene *)scene WithScore:(int)score WithGoalScore:(int)goalScore WithWin:(BOOL)didWin
{
    NSUserDefaults *highScoreDefault = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [highScoreDefault integerForKey:CookieCookerHighScoreDefault];
    if (!self.didCreatePopup)
    {  
        _difficultyView = [[[NSBundle mainBundle] loadNibNamed:@"CDEndMinigamePopupIPhone5View" owner:self options:nil] objectAtIndex:0];
        _difficultyView.parentalViewController = self;
        _difficultyView.delegate = self;
        _difficultyView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        [self.view insertSubview:_difficultyView belowSubview:_mainButtonViewController.view];
        [_difficultyView setup];
        _difficultyView.gameNameLabel.text = @"Cookie Cooker";
        
        if (score > highScore)
        {
            [highScoreDefault setInteger:score forKey:CookieCookerHighScoreDefault];
            [_difficultyView.bestScoreLabel setText:[NSString stringWithFormat:@"BEST SCORE: %i", score]];
        }
        else
        {
            [_difficultyView.bestScoreLabel setText:[NSString stringWithFormat:@"BEST SCORE: %li", (long)highScore]];
        }
        
        [_difficultyView.scoreLabel setText:[NSString stringWithFormat:@"SCORE: %i", score]];
        _difficultyView.score = score;
        _difficultyView.minigameName = @"Cookie Cooker";
        
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
            
            NSUserDefaults *timeOfAwardLockout = [NSUserDefaults standardUserDefaults];
            
            NSDate *lockoutDate = [timeOfAwardLockout objectForKey:AwardLockoutTimeDefault];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:lockoutDate];
            double secondsInAnHour = 3600;
            NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;

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
            
            CDAwardPopupViewController *awardPopup = [self.storyboard instantiateViewControllerWithIdentifier:@"CDAwardPopupViewController"];
            awardPopup.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
            awardPopup.delegate = self;
            awardPopup.difficulty = _scene.difficulty;
            
            if (scene.difficulty == gameDifficultyLevelHard)
            {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                BOOL doNotAwardGem = [userDefault boolForKey:CookieCookerAwardGemDefault];
                
                if (!doNotAwardGem)
                {
                    awardPopup.awardGem = YES;
                    [userDefault setBool:YES forKey:CookieCookerAwardGemDefault];
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
            
            [self addChildViewController:awardPopup];
            [self.view addSubview:awardPopup.view];
        }
        else
        {
            _difficultyView.winLoseTextLabel.text = @"OH NO!";
            [_difficultyView.cookieIconImage setImage:[UIImage imageNamed:@"cdd-hud-ico-sadcookie"]];
        }
        
        _didCreatePopup = YES;
        
        _scene.userInteractionEnabled = NO;
        _scene.didClickCookie = NO;
        [_scene touchesEnded:nil withEvent:nil];
    }
}

#pragma mark - CDMiniGamePopupView Delegate

-(void)helpButtonWasHitOnMiniGamePopupView:(BOOL)isOpen
{
    if (isOpen)
    {
        _helpPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
        
        _helpPopup.delegate = self;
        _helpPopup.whatAmILoading = @"cookieCookerHelp";
        
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
    [_scene removeAllActions];
    [_scene removeAllChildren];
    _scene = nil;
    
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
    
    [_scene removeAllActions];
    [_scene removeAllChildren];
    _scene = nil;
    
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
                           if ([self.delegate respondsToSelector:@selector(replayButtonWasHitInCookieCooker)])
                           {
                               [self.delegate replayButtonWasHitInCookieCooker];
                           }
                       }];
                   });
}

#pragma mark - Main Button Delegates
- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction
{
    SKView *spriteView = (SKView *) self.view;
    spriteView.paused = willDisableInteraction;
    
    _scene.userInteractionEnabled = !willDisableInteraction;
    _scene.paused = willDisableInteraction;
    
    if (willDisableInteraction)
    {
        _difficultyView.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _helpPopup.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
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
        DebugLog(@"BackButton - CookieCookerViewController");
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
        NSUserDefaults *volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
        NSString *volumeButtonState = [volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
        
        DebugLog(@"button state: %@", volumeButtonState);
        if ([volumeButtonState isEqualToString:@"high"])
        {
            [_scene volumeWasTurnedOn];
        }
        else if ([volumeButtonState isEqualToString:@"low"])
        {
            
        }
        else if ([volumeButtonState isEqualToString:@"mute"])
        {
            [_scene volumeWasTurnedOff];
        }
        else
        {
            DebugLog(@"Volume Default Error: A default of %@ is not valid....", volumeButtonState);
        }
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
            popup.frame = _scene.frame;//CGRectMake(0, 0, _scene.frame.size.height, _scene.frame.size.width);
            [_mainButtonViewController.view addSubview:popup];
            [popup setupWithParentalViewController:_mainButtonViewController];
            
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
//        _mainButtonViewController.subPopupWasUpSomewhere = NO;
        
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

#pragma mark - Award Popup Delegate
- (void)didTapScreenToDismissAwardsPopupViewController:(CDAwardPopupViewController *)awardsPopupViewController
{
    [awardsPopupViewController.view removeFromSuperview];
}

#pragma mark - Device Orientation

- (BOOL)shouldAutorotate
{
//    if (_loadingScreenIsUp)
//    {
        return YES;
//    }
//    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (_loadingScreenIsUp)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (_presentRight)
    {
        return UIInterfaceOrientationLandscapeRight;
    }
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    DebugLog(@"HELLO");
    if (_mainButtonViewController)
    {
        [_mainButtonViewController orientationHasChanged:toInterfaceOrientation WithDuration:duration];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
