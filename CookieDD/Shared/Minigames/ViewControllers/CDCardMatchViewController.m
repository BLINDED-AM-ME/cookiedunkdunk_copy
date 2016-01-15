//
//  CardMatchViewController.m
//  NewGame
//
//  Created by Josh on 7/30/13.
//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import "CDCardMatchViewController.h"
#import "CDCookieMatchScene.h"
#import "CDDifficultySelectScreenViewController.h"
#import <QuartzCore/CADisplayLink.h>
#import "CDStandardPopupView.h"
#import "CDAccountPopupView.h"
#import "CDDifficultySelectScreenViewController.h"
#import "CDMiniGamePopupView.h"
#import "CDAwardPopupViewController.h"

@interface CDCardMatchViewController () <CDCookieMatchSceneDelegate, CDMainButtonViewControllerDelegate, CDAccountPopupViewDelegate, CDStandardPopupViewDelegate, CDDifficultySelectScreenViewControllerDelegate, CDMiniGamePopupViewDelegate, CDAwardPopupViewControllerDelegate>

@property (strong, nonatomic) CDCookieMatchScene *stovetopScene;
@property (strong, nonatomic) CDMainButtonViewController *mainButtonViewController;
@property (weak, nonatomic) CDMiniGamePopupView *difficultyView;
@property (weak, nonatomic) CDStandardPopupView *helpPopup;

@property (strong, nonatomic) AVAudioPlayer *bgMusicPlayer;
@property (strong, nonatomic) CADisplayLink *countdownTimer;

@property (assign, nonatomic) int difficulty;
@property (assign, nonatomic) int maxSeconds;
@property (assign, nonatomic) int currentSeconds;
@property (assign, nonatomic) int score;
@property (assign, nonatomic) int goalScore;

@property (assign, nonatomic) float previousTime;

@property (assign, nonatomic) BOOL didCreatePopup;
@property (assign, nonatomic) BOOL didWin;
@property (assign, nonatomic) BOOL infiniteTimeActive;
@property (assign, nonatomic) BOOL didCreateScene;

@end

@implementation CDCardMatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Configure the view.
    
    UIViewController *disposableViewController = [UIViewController new];
    [self presentViewController:disposableViewController animated:NO completion:nil];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    // Music
//    [[SGAudioManager audioManager] playSountrackWithLocation:@"cardMatch"];
    
//    NSUserDefaults *musicButtonStateDefault = [NSUserDefaults standardUserDefaults];
//    NSString *musicButtonState = [musicButtonStateDefault objectForKey:@"musicButtonState"];
    
//    if ([musicButtonState isEqualToString:@"mute"])
//    {
//        [[SGAudioManager audioManager] muteTheAudioPlayer:YES];
//    }
    //[self startbackgroundMusicWithFileNamed:@"cookie_casino_v1_5" ofType:@"m4a"];
    
    // Cheats
    self.infiniteTimeActive = NO;
    
    
    self.didCreateScene = NO;
    
    // Setup the button
    _mainButtonViewController = [[CDMainButtonViewController mainButton] didCreateMainButtonViewWithParentalViewController:self];
    _mainButtonViewController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitApp) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterApp) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!self.didCreateScene)
    {
        _mainButtonViewController.parentViewFrame = self.view.frame;
        _mainButtonViewController.conditionalViewFrame = self.view.frame;
        
        SKView *stovetopSKView = (SKView *)self.stovetopView;
        stovetopSKView.showsFPS = YES;
        
        // Set and start the timer.
//        [self.stovetopScene.timerLabel setFont:[UIFont fontWithName:@"Let's go Digital Regular" size:37.0f]];
        self.currentSeconds = self.maxSeconds;
        
        // Create and configure the scene.
        self.stovetopScene = [CDCookieMatchScene sceneWithSize:self.stovetopView.bounds.size];
        self.stovetopScene.delegate = self;
        self.stovetopScene.scaleMode = SKSceneScaleModeFill;
        [self.stovetopScene setup];

        // Present the scene.
        [stovetopSKView presentScene:self.stovetopScene];
        
        self.didCreateScene = YES;
    }
}

- (void)exitApp
{
    DebugLog(@"exiting app!");
    
    if (self.stovetopScene)
    {
        SKView *spriteView = (SKView *) self.view;
        spriteView.paused = YES;
        
        self.stovetopScene.paused = YES;
        [self.stovetopScene.view setPaused:YES];
        self.stovetopScene.userInteractionEnabled = NO;
        [[SGAudioManager audioManager] pauseAllAudio];
        
        //        __weak typeof(self) weakSelf = self;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            SKView *spriteView = (SKView *) weakSelf.view;
        //            spriteView.paused = YES;
        //
        //            weakSelf.scene.paused = YES;
        //            [weakSelf.scene.view setPaused:YES];
        //            [[SGAudioManager audioManager] pauseAllAudio];
        //        });
    }
}

- (void)enterApp
{
    DebugLog(@"entering app!");
    
    if (self.stovetopScene)
    {
        if (self.mainButtonViewController.mainButtonIsDown)
        {
            SKView *spriteView = (SKView *) self.view;
            spriteView.paused = NO;
            self.stovetopScene.paused = NO;
            [self.stovetopScene.view setPaused:NO];
            self.stovetopScene.userInteractionEnabled = YES;
        }
        [[SGAudioManager audioManager] playAllAudio];
        
        //        __weak typeof(self) weakSelf = self;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //
        //            if (weakSelf.mainButtonViewController.mainButtonIsDown)
        //            {
        //                SKView *spriteView = (SKView *) weakSelf.view;
        //                spriteView.paused = NO;
        //                weakSelf.scene.paused = NO;
        //                [weakSelf.scene.view setPaused:NO];
        //            }
        //            [[SGAudioManager audioManager] playAllAudio];
        //        });
    }
}

#pragma mark - Setup

// This initializes all the values that are based on difficulty.
- (void)setDifficultyLevel:(int)difficulty
{
    self.difficulty = difficulty;
    
    // Turn the knob.
    float radiansBetweenDifficulties = 0.785398163; // 45 degrees. (pi / (#difficulties + 1))
    self.stoveKnobImageView.transform = CGAffineTransformMakeRotation(radiansBetweenDifficulties * self.difficulty);
    
    // Set any values unique to each difficulty.
    switch (difficulty) {
        case gameDifficultyLevelEasy:
            self.maxSeconds = 90;
            break;
            
        case gameDifficultyLevelMedium:
            self.maxSeconds = 60;
            break;
            
        case gameDifficultyLevelHard:
            self.maxSeconds = 40;
            break;
            
        case gameDifficultyLevelCrazy:
            self.maxSeconds = 30;
            break;
            
        default:
            break;
    }
    
    self.currentSeconds = self.maxSeconds;
    self.stovetopScene.userInteractionEnabled = YES;
    self.stovetopScene.paused = NO;
    
    self.stovetopScene.timerLabel.hidden = NO;
}

#pragma mark - Timer Methods

- (void)updateTimer
{
    if (self.stovetopScene.hasStarted)
    {
        if (!self.infiniteTimeActive)
        {
            if (self.currentSeconds >= 0)
            {
                int minutes = self.currentSeconds/60;
                int seconds = self.currentSeconds%60;
                [self.stovetopScene.timerLabel setText:[NSString stringWithFormat:@"%02i:%02i", minutes, seconds]];
                
                self.currentSeconds -= 1;//timer.timestamp;
            }
            else
            {
                DebugLog(@"Time ran out.");
                
                [self gameOver];
            }
        }
    }
}

- (void)timerGarbageRun {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

- (void)gameOver {
    
    DebugLog(@"We dont need this but im a rebel!");
    
    self.stovetopScene.enabled = NO;
    
    if (!self.didCreatePopup)
    {
        [self showPopup];
    }
    
    // Turn off the timer once it runs out.
    [self timerGarbageRun];
}

#pragma mark - Audio

- (void)startbackgroundMusicWithFileNamed:(NSString *)fileName ofType:(NSString *)fileType {
//    NSURL *bgMusic = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileType]];
//    self.bgMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgMusic error:nil];
//    self.bgMusicPlayer.numberOfLoops = -1; // Background music should loop.
//    [self.bgMusicPlayer play];
}

- (void)audioGarbageRun {
    [self.bgMusicPlayer stop];
    self.bgMusicPlayer = nil;
}

#pragma mark - CDPopUpViewController Delegate

- (void)showPopup
{
//    CDPopUpViewController *popUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CDPopUpViewController"];
//    [self addChildViewController:popUpViewController];
//    [self.view insertSubview:popUpViewController.view belowSubview:_mainButtonViewController.view];
//    popUpViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    popUpViewController.socialMessage = @"I just completed Cookie Match in Cookie Dunk Dunk!";
//    popUpViewController.delegate = self;
//    popUpViewController.scoreLabel.text = [NSString stringWithFormat:@"score: %i/%i", self.score, self.goalScore];
//    
//    if (self.didWin)
//    {
//        popUpViewController.winLoseLabel.text = @"YOU WIN!!!!";
//    }
//    else
//    {
//        popUpViewController.winLoseLabel.text = @"YOU LOSE!!!!";
//    }
//    
//    self.didCreatePopup = YES;
}

//- (void)didEndGame:(CDPopUpViewController *)viewController
//{
//    // Cleanup Stuff
//    [self audioGarbageRun];
//    
//    // Remove the popup.
//    [viewController.view removeFromSuperview];
//    [viewController removeFromParentViewController];
//    
//    [[SGAudioManager audioManager] stopTheAudioPlayer];
//    
//    [self loadingScreenHandler];
//    
//    double delayInSeconds = [SGAppDelegate appDelegate].loadingScreenTimeDelay;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//    {
//        [self dismissViewControllerAnimated:NO completion:^{
//            [_loadingScreen startMapMusic];
//            [_loadingScreen.view removeFromSuperview];
//        }];
//    });
//}

- (void)loadingScreenHandler
{
    [self stopBackgroundMusic];
    
    NSString *bgImageString = [NSString stringWithFormat:@"Default%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
    [self createLoadingScreenWithImageNamed:bgImageString];
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
                           
                           if ([weakSelf.delegate respondsToSelector:@selector(storeButtonWasHitInCardMatch)])
                           {
                               [weakSelf.delegate storeButtonWasHitInCardMatch];
                           }
                           
                           [weakSelf.loadingScreen.view removeFromSuperview];
                       }];
                   });
}

#pragma mark - Loading Screen

- (void)createLoadingScreenWithImageNamed:(NSString *)imageName
{
    self.loadingScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CDLoadingScreenViewController"];
    [self.view addSubview:self.loadingScreen.view];
    
    self.loadingScreen.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.loadingScreen createLoadingScreenWithImageName:imageName];
}


#pragma mark - Cheats

- (IBAction)infiniteTime:(id)sender {
    self.infiniteTimeActive = !self.infiniteTimeActive;
}

#pragma mark - delegate

- (void)cookieMatchDidEndScene:(CDCookieMatchScene *)scene WithScore:(int)score WithGoalScore:(int)goalScore WithWin:(BOOL)didWin
{
    self.stovetopScene.enabled = NO;
    
    if (!self.didCreatePopup)
    {
        self.score = score;
        self.goalScore = goalScore;
        self.didWin = didWin;
        
        [self showPopup];
    }
    
    // Turn off the timer once it runs out.
    [self timerGarbageRun];
}


- (void)cookieMatchDifficultyWasSelected:(CDCookieMatchScene *)scene
{
    NSUserDefaults *highScoreDefault = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [highScoreDefault integerForKey:CardMatchHighScoreDefault];
    
    _difficultyView = [[[NSBundle mainBundle] loadNibNamed:@"CDDifficultySelectPopupIPhone5View" owner:self options:nil] objectAtIndex:0];
    _difficultyView.delegate = self;
    _difficultyView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view insertSubview:_difficultyView belowSubview:_mainButtonViewController.view];
    [_difficultyView setup];
    [_difficultyView.bestScoreLabel setText:[NSString stringWithFormat:@"BEST SCORE: %li", (long)highScore]];
    _difficultyView.gameNameLabel.text = @"Cookie Match";
}

- (void)timeDidPass:(CDCookieMatchScene *)scene WithScore:(int)score WithGoalScore:(int)goalScore WithWin:(BOOL)didWin
{
    self.score = score;
    self.didWin = didWin;
    self.goalScore = goalScore;
    
    [self updateTimer];
}

- (void)stopBackgroundMusic
{
    [[SGAudioManager audioManager] stopAllAudio];
}

#pragma mark - CDDifficultySelectViewController Delegate
- (void)difficultyHasBeenSelectedWithDifficulty:(int)difficulty
{
    self.stovetopScene.difficulty = difficulty;
    [self setDifficultyLevel:difficulty];
    
    [self.stovetopScene startMiniGame];
}

#pragma mark - Main Button Delegates

- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction
{
    SKView *spriteView = (SKView *) self.view;
    spriteView.paused = willDisableInteraction;
    
    _stovetopScene.userInteractionEnabled = !willDisableInteraction;
    _stovetopScene.paused = willDisableInteraction;
    
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
        
        double delayInSeconds = 0;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
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
            popup.frame = CGRectMake(0, 0, _stovetopScene.frame.size.width, _stovetopScene.frame.size.height);
            [self.view insertSubview:popup aboveSubview:_mainButtonViewController.view];
            [popup setupWithParentalViewController:self];
            
            _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        }
        else
        {
            [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:_stovetopScene.frame errorDescription:@"You are not currently logged in. Please Login to view your account." loadingText:nil];
            
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

#pragma mark - Difficulty Select Delegate
- (void)exitButtonWasHit
{
    
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
        
        _helpPopup.frame = _stovetopScene.frame;//CGRectMake(0, 0, _scene.frame.size.height, _scene.frame.size.width);
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
    
    self.stovetopScene.difficulty = difficulty;
    [self setDifficultyLevel:difficulty];
    
    [self.stovetopScene startMiniGame];
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
    
    [_stovetopScene removeAllActions];
    [_stovetopScene removeAllChildren];
    _stovetopScene = nil;
    
    [miniGamePopupView removeFromSuperview];
    
    [[SGAudioManager audioManager] stopAllAudio];
    
    [self loadingScreenHandler];
    
    double delayInSeconds = 0;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self dismissViewControllerAnimated:NO completion:^{
                           [_loadingScreen.view removeFromSuperview];
                           if ([self.delegate respondsToSelector:@selector(replayButtonWasHitInCardMatch)])
                           {
                               [self.delegate replayButtonWasHitInCardMatch];
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
    DebugLog(@"Did dealloc Card Match ViewController!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
