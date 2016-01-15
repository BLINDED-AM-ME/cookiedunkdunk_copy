//
//  ViewController.m
//  MiniGameTest
//
//  Created by Rodney Jenkins on 9/19/13.
//  Copyright (c) 2013 Rodney Jenkins. All rights reserved.
//

#import "GingerDeadMenViewController.h"
#import "GingerDeadMenGameScene.h"

#import "CDMiniGamePopupView.h"
#import "CDAccountPopupView.h"
#import "CDAwardPopupViewController.h"
#import "CDStoreViewController.h"
#import "CDStandardPopupView.h"

@import AVFoundation;

@interface GingerDeadMenViewController () <GingerDeadMenGameSceneDelegate,CDMiniGamePopupViewDelegate, CDMainButtonViewControllerDelegate, CDStandardPopupViewDelegate, CDAccountPopupViewDelegate, CDAwardPopupViewControllerDelegate>

@property (weak, nonatomic) CDMiniGamePopupView *difficultyView;
@property (strong, nonatomic) CDMainButtonViewController *mainButtonViewController;
@property (weak, nonatomic) CDStandardPopupView *helpPopup;

@property (strong, nonatomic) GingerDeadMenGameScene *gameScene;

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@property (assign, nonatomic) BOOL didCreateScene;
@property (assign, nonatomic) BOOL didCreatePopup;
@property (assign, nonatomic) BOOL loadingScreenIsUp;

@end



@implementation GingerDeadMenViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIViewController *disposableViewController = [[UIViewController alloc] init];
    [self presentViewController:disposableViewController animated:NO completion:nil];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    
    // Setup the button
    _mainButtonViewController = [[CDMainButtonViewController mainButton] didCreateMainButtonViewWithParentalViewController:self];
    _mainButtonViewController.delegate = self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(_gameScene == nil){
        [self CreatGameScene];
    }
}

#pragma mark - Device Orientation

- (BOOL)shouldAutorotate
{
    //    if (_loadingScreenIsUp)
    //    {
    return NO;
    //    }
    //    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
//    if (_loadingScreenIsUp)
//    {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
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


-(void)CreatGameScene
{
    DebugLog(@"createGameScene");
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    //skView.showsPhysics = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    self.gameScene = [GingerDeadMenGameScene sceneWithSize:skView.bounds.size];
    
    self.gameScene.BigDaddy = self;
    self.gameScene.delegate = self;
    self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:self.gameScene];
    
    
    [self gingerDeadWillPresentDifficultyScreen:_gameScene];
}

-(void)ReuseGameScene
{
    [_gameScene RESET];
    [self gingerDeadWillPresentDifficultyScreen:_gameScene];
}

#pragma mark - Loading Screen

- (void)loadingScreenHandler
{
    _loadingScreenIsUp = YES;
    
    if(_gameScene){
        [_gameScene EraseThisGameScene];
        _gameScene = nil;
    }
    
    //[_scene stopBackGroundMusic];
    [[SGAudioManager audioManager] stopAllAudio];
    
    NSString *bgImageString = [NSString stringWithFormat:@"Default-landscape%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
    [self createLoadingScreenWithImageNamed:bgImageString];
}


- (void)createLoadingScreenWithImageNamed:(NSString *)imageName
{
    self.loadingScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CDLoadingScreenViewController"];
    [self.view addSubview:self.loadingScreen.view];
    
    // IOS8 CHANGE: ORIENTATION
//    self.loadingScreen.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);
    self.loadingScreen.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.loadingScreen createLoadingScreenWithImageName:imageName];
}


#pragma mark - CDMiniGamePopupView Delegate

-(void)helpButtonWasHitOnMiniGamePopupView:(BOOL)isOpen
{
    if (isOpen)
    {
        _helpPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
        
        _helpPopup.delegate = self;
        _helpPopup.whatAmILoading = @"cookieCookerHelp";
        
        _helpPopup.frame = _gameScene.frame;//CGRectMake(0, 0, _scene.frame.size.height, _scene.frame.size.width);
        [self.view insertSubview:_helpPopup aboveSubview:_mainButtonViewController.view];
        [_helpPopup setup];
        
        _mainButtonViewController.popupIsUp = YES;
        //        _mainButtonViewController.subPopupWasUpSomewhere = YES;
    }
    else
    {
        _mainButtonViewController.popupIsUp = NO;
        //        _mainButtonViewController.subPopupWasUpSomewhere = NO;
        _difficultyView.fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        [_helpPopup removeFromSuperview];
    }
}

- (void)exitButtonWasHitOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView
{
    [_gameScene EraseThisGameScene];
    _gameScene = nil;
    
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

- (void)difficultyWasSelectedOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView WithDifficulty:(int)difficulty
{
    [miniGamePopupView removeFromSuperview];
    
    _didCreatePopup = NO;
    
    _gameScene.userInteractionEnabled = YES;
    
    _gameScene.difficulty = difficulty;
    [_gameScene SceneSetup:difficulty];
    [_gameScene Start_this_Bitch];
}

- (void)shopWasSelectedOnMiniGamePopUpView
{
    DebugLog(@"shop button was hit");
}

- (void)menuWasSelectedOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView
{
    DebugLog(@"menu button was hit");
    
    [_gameScene EraseThisGameScene];
    _gameScene = nil;
    
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
    
    [_gameScene removeAllActions];
    
    [miniGamePopupView removeFromSuperview];
    
    [[SGAudioManager audioManager] stopAllAudio];

    [self ReuseGameScene];
    
    
}

#pragma mark - CDPopUpViewController Delegate

//- (void)didEndGame:(CDPopUpViewController *)viewController
//{
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

/*
-(void)TitleScreen{
    
    
    DebugLog(@"Title");
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    if(self.titleScene == nil){
        // Create and configure the scene.
        self.titleScene = [GingerDeadMenTitleScreen sceneWithSize:skView.bounds.size];
        self.titleScene.BigDaddy = self;
    }
    
    self.titleScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:self.titleScene];
    
    
}
 */

-(void)Quit{
    
    // later
    
}

- (void)stopBackgroundMusic
{
   // [[SGAudioManager audioManager] stopTheAudioPlayer];
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
                           if ([self.delegate respondsToSelector:@selector(storeButtonHitInGingerDeadViewController)])
                           {
                               [self.delegate storeButtonHitInGingerDeadViewController];
                           }
                           [_loadingScreen.view removeFromSuperview];
                       }];
                   });
}

#pragma mark - GingerDeadGameScene delegate

- (void)gingerDeadWillPresentDifficultyScreen:(GingerDeadMenGameScene *)scene
{
    
//    NSUserDefaults *highScoreDefault = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = 0;//[highScoreDefault integerForKey:CookieCookerHighScoreDefault];
    
    _difficultyView = [[[NSBundle mainBundle] loadNibNamed:@"CDDifficultySelectPopupIPhone5View" owner:self options:nil] objectAtIndex:0];
    _difficultyView.delegate = self;
    
    // IOS8 CHANGE: ORIENTATION
//    _difficultyView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    _difficultyView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view insertSubview:_difficultyView belowSubview:_mainButtonViewController.view];
    [_difficultyView setup];
    [_difficultyView.bestScoreLabel setText:[NSString stringWithFormat:@"BEST SCORE: %li", (long)highScore]];
    _difficultyView.gameNameLabel.text = @"GingerDead";
}

- (void)gingerDeadSceneDidEnd:(GingerDeadMenGameScene *)scene DidWin:(BOOL)didWin WithScore:(int)score
{
    if (!self.didCreatePopup)
    {
        _difficultyView = [[[NSBundle mainBundle] loadNibNamed:@"CDEndMinigamePopupIPhone5View" owner:self options:nil] objectAtIndex:0];
        _difficultyView.parentalViewController = self;
        _difficultyView.delegate = self;
        
        // IOS8 CHANGE: ORIENTATION
//        _difficultyView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        _difficultyView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view insertSubview:_difficultyView belowSubview:_mainButtonViewController.view];
        [_difficultyView setup];
        _difficultyView.gameNameLabel.text = @"Ginger Dead";
        
        [_difficultyView.scoreLabel setText:[NSString stringWithFormat:@"SCORE: %i", score]];
        _difficultyView.score = score;
        _difficultyView.minigameName = @"Ginger Dead";
        
        if (didWin)
        {
            
            _difficultyView.winLoseTextLabel.text = @"GREAT JOB!";
            
            [_difficultyView.cookieIconImage setImage:[UIImage imageNamed:@"cdd-hud-ico-happycookie"]];
            
            
        }
        else
        {
            _difficultyView.winLoseTextLabel.text = @"OH NO!";
            
            [_difficultyView.cookieIconImage setImage:[UIImage imageNamed:@"cdd-hud-ico-sadcookie"]];
        }
        
        _didCreatePopup = YES;
        
        _gameScene.userInteractionEnabled = NO;
        [_gameScene touchesEnded:nil withEvent:nil];
    }
    
}


#pragma mark - Main Button Delegates
- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction
{
    SKView *spriteView = (SKView *) self.view;
    spriteView.paused = willDisableInteraction;
    
    _gameScene.userInteractionEnabled = !willDisableInteraction;
    _gameScene.paused = willDisableInteraction;
}

- (void)mainButtonSubButtonWasHitWithIndex:(int)buttonIndex
{
    if (buttonIndex == soundButtonIndex)
    {
        DebugLog(@"THE SOUND BUTTON WAS HIT");
    }
    else if (buttonIndex == backButtonIndex)
    {
        [self loadingScreenHandler];
        
        double delayInSeconds = [SGAppDelegate appDelegate].loadingScreenTimeDelay;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [self dismissViewControllerAnimated:NO completion:^{
                               //[_loadingScreen startMapMusic];
                               [_loadingScreen.view removeFromSuperview];
                           }];
                       });
    }
    else if (buttonIndex == helpButtonIndex)
    {
        DebugLog(@"THE HELP BUTTON WAS HIT");
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

@end
