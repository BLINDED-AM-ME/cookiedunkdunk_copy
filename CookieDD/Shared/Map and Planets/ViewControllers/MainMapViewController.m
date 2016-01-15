//
//  MainMapViewController.m
//  Map_Plist
//
//  Created by Josh on 9/24/13.
//  Copyright (c) 2013 Josh. All rights reserved.
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

#import "MainMapViewController.h"
#import "LevelInfoViewController.h"
#import "CDStoreViewController.h"
#import "SGFileManager.h"

//#import "CDCardMatchViewController.h"
#import "CDCookieBombViewController.h"
#import "CDCookieCookerViewController.h"
//#import "CDHotCookieViewController.h"
#import "GingerDeadMenViewController.h"
//#import "CDSpiceInvadersViewController.h"
//#import "CDCookibeanViewController.h"
//#import "CDSpaceInvadersViewController.h"
#import "CDStandardPopupView.h"
#import "CDAccountPopupView.h"
#import "SGStoreItemInfoViewController.h"
#import "CDVideoPlayerViewController.h"
#import "CDAwardPopupViewController.h"
#import "CDAbductionViewController.h"
#import "CDCardMatchViewController.h"
#import "CDNotificationView.h"

#include "CDTutorialDialogueViewController.h"
#include "SGFocusableFadeView.h"

@interface MainMapViewController () <LevelInfoViewControllerDelegate, CDMainButtonViewControllerDelegate, CDStandardPopupViewDelegate, CDAccountPopupViewDelegate, CDCookieCookerViewControllerDelegate, CDCookieBombViewControllerDelegate, CDCookieDunkDunKViewControllerDelegate, CDVideoPlayerViewControllerDelegate, CDAwardPopupViewControllerDelegate, GingerDeadMenViewControllerDelegate, CDAbductionViewControllerDelegate, FocusableFadeViewDelegate, CDCardMatchViewControllerDelegate, CDNotificationViewDelegate>

@property (strong, nonatomic) LevelInfoViewController *levelInfoViewController;
@property (weak, nonatomic) CDCookieDunkDunKViewController *cddController;
@property (strong, nonatomic) WorldViewController *worldViewController;
@property (strong, nonatomic) CDAccountPopupView *accountView;
@property (strong, nonatomic) CDStandardPopupView *standardPopup;

@property (strong, nonatomic) CDMainButtonViewController *mainButtonViewController;
@property (strong, nonatomic) CDVideoPlayerViewController *videoViewController;
@property (strong, nonatomic) CDAwardPopupViewController *awardPopup;

@property (strong, nonatomic) UIView *worldView;

@property (assign, nonatomic) int switchOrientation;

@property (assign, nonatomic) float mapWidth;
@property (assign, nonatomic) float mapHeight;
@property (assign, nonatomic) float minZoomScale;
@property (assign, nonatomic) float previousTime;

@property (assign, nonatomic) BOOL loadingScreenIsOpen;

@property (strong, nonatomic) NSString *planetHitName;
@property (strong, nonatomic) NSString *minigameOrientation;


@property (assign, nonatomic) float nebulaSpeedMultiplier;
@property (assign, nonatomic) float closeStarsSpeedMultiplier;

@property (strong, nonatomic) SGAudioPlayer *livesDing;
@property (assign, nonatomic) BOOL loadMusic;

@property (assign, nonatomic) BOOL showLives;

@property (strong, nonatomic) SGFocusableFadeView *fadeView;

@property (strong, nonatomic) NSTimer *shootingStarsInitialTimer;
@property (strong, nonatomic) NSTimer *shootingStarsRepeatingTimer;

@property (nonatomic, strong) NSMutableArray *notificationsArray;

@end

@implementation MainMapViewController

-(BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.multipleTouchEnabled = NO;
    
    self.showLives = YES;
    [self.livesDisplayView hideDisplayAnimated:NO];
    [self.livesDisplayView setupLives];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    if (_levelInfoViewController)
    {
        [_levelInfoViewController.view removeFromSuperview];
    }
    
//    if (_loadMusic)
//    {
//        // Play the map theme.
//        DebugLog(@"Playing map music");
//        
//        [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"CCDDD_THEME_MIX_Map" FileType:@"m4a" volume:0.15f numberOfLoopes:-1];
//        
//        _loadMusic = NO;
//    }
    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"CCDDD_THEME_MIX_Map" FileType:@"m4a" volume:0.15f numberOfLoopes:-1];
    
    // NOTE
    // JOSH HERE IS YOUR 
   // [self requestServerTime];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.view.userInteractionEnabled = YES;
    
    _mainButtonViewController.view.userInteractionEnabled = YES;
    _mapScrollView.userInteractionEnabled = YES;
    _rootMapView.userInteractionEnabled = YES;
    
    
//    // Setup the button
//    if (!_loadingScreenIsOpen)
//    {
//        _mainButtonViewController = [[CDMainButtonViewController mainButton] didCreateMainButtonViewWithParentalViewController:self];
//    }
//    _mainButtonViewController.delegate = self;
    
    
    if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        _mainButtonViewController.parentViewFrame = self.view.frame;
        _mainButtonViewController.conditionalViewFrame = self.view.frame;
    }
    else
    {
        _mainButtonViewController.parentViewFrame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        _mainButtonViewController.conditionalViewFrame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }
    
    
    _didTapSomething = NO;
    
    
    if (_showLives)
    {
        [self.livesDisplayView setHidden:NO];
        [self.livesDisplayView showDisplayAnimated:YES completion:^{
            //[self.fadeView giveFocus:@[self.worldViewController.regionIconsArray[0], self.worldViewController.storeShip]];
        }];
    }
    else
    {
        _showLives = YES;
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if ([self.delegate respondsToSelector:@selector(mainMapDidAppearAndWillDeallocMainMenu)])
    {
        [self.delegate mainMapDidAppearAndWillDeallocMainMenu];
    }
    
    // This sets up all the planets and such for this world.
    //[_worldViewController buildWorldFromProperties:[self createWorldPropertiesDictionary]];
    
//    _switchOrientation = allButUpsideDownOrientation;
    [self activateTravelDots];

    [self setupTutorial];

    [self restartAnimations];
    
    //[self beginShootingStars];

}

- (void)activateTravelDots
{
    for (UIView *view in _worldViewController.view.subviews)
    {
        if ([view isMemberOfClass:[CDTravelDot class]])
        {
            //DebugLog(@"Found a TravelDot");
            CDTravelDot *dot = (CDTravelDot *)view;
            [dot performSelector:@selector(activateStrobe) withObject:nil afterDelay:0.1f inModes:@[NSRunLoopCommonModes]];
            //dot.isEnabled = YES;
        }
    }
}

- (void)restartAnimations
{
    for (UIView *view in self.worldViewController.view.subviews)
    {
        if ([view isMemberOfClass:[CDStoreObject class]])
        {
            CDStoreObject *store = (CDStoreObject *)view;
            [store animateStore];
        }
        else if ([view isMemberOfClass:[CDSateliteObject class]])
        {
            CDSateliteObject *satellite = (CDSateliteObject *)view;
            [satellite animateSatellite:satellite];
        }
        else if ([view isMemberOfClass:[CDPlanetoidObject class]])
        {
            CDPlanetoidObject *planetoid = (CDPlanetoidObject *)view;
            [planetoid morphBubble:planetoid.backgroundImageView.layer];
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //_showLives = YES;
    
    // Setup the button
    _mainButtonViewController = [[CDMainButtonViewController mainButton] didCreateMainButtonViewWithParentalViewController:self];
    _mainButtonViewController.delegate = self;

    
    _switchOrientation = allButUpsideDownOrientation;
    _minigameOrientation = @"no minigame";
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                         pathForResource:@"Soothing"
//                                         ofType:@"mp3"]];
    NSURL *url = [[SGFileManager fileManager] urlForFileNamed:@"Soothing" fileType:nil];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.audioPlayer setNumberOfLoops:-1];
//    [self.audioPlayer play];
    
//    [self playSoundWithSongTitle:@"Soothing" WillLoop:YES WithAudioPlayer:self.audioPlayer];
    
    // These need to not be hard coded.
    if (IS_IPAD)
    {
        self.mapWidth = 72000.0f;
        self.mapHeight = self.rootMapView.frame.size.height*2.5;
    }
    else
    {
        self.mapWidth = 3000.0f;
        self.mapHeight = 700; //self.rootMapView.frame.size.height;
    }
    // Check for retina.
    if (IS_RETINA) {
        self.mapHeight *= 2;
    }
    
    self.previousTime = 0.0f;
    
    self.planetHitName = nil;
    
    // This is a world layered on top of the main map view. (This is where the planents go.)
    _worldViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorldViewController"];
    CGRect worldViewRect = CGRectMake(0.0f, 0.0f, self.mapWidth, self.mapHeight);
    _worldViewController.view.frame = worldViewRect;
    _worldViewController.delegate = self;
    self.worldView = _worldViewController.view;
    
    
    
    [self.nebulaScrollView setContentSize:self.nebulaImageView.frame.size];
    self.nebulaSpeedMultiplier = 0.0f;
    
    self.closeStarsImageView.frame = self.nebulaImageView.frame;
    [self.closeStarsScrollView setContentSize:self.closeStarsImageView.frame.size];
    self.closeStarsSpeedMultiplier = 0.1f;
    
    
    [self.mapScrollView addSubview:self.worldView];
    //[self.mapScrollView setContentSize:_worldViewController.view.frame.size];
    [self.mapScrollView setContentSize:CGSizeMake(_mapWidth, _mapHeight)];
    self.mapScrollView.canCancelContentTouches = YES;
    [self.mapScrollView setScrollEnabled:YES];
    
    
    // This sets up all the planets and such for this world.
    //[_worldViewController buildWorldFromProperties:[self createWorldPropertiesDictionary]];
    
    
    // Get the starting point for the view set up.
    [self gotoPosition:CGPointMake(-500, -800) AndZoomTo:0.5f Animated:NO completion:nil];//675f Animated:NO];
    
    
    // Preload anything necessary.
    self.levelInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LevelInfoViewController"];
    self.levelInfoViewController.delegate = self;
    self.cddController = nil;
    
    
    // Setup the Lives Display.
    [self.livesDisplayView initialize];
    self.livesDisplayView.delegate = self;
//    [self.livesDisplayView setNumLivesTo:[[CDPlayerObject player].lives intValue]];
    [self.livesDisplayView setHidden:YES];
    [self.livesDisplayView hideDisplayAnimated:NO];
//    [self setupLivesDisplayCountdown];
    
    // Set background music to play on loading
    _loadMusic = YES;
    
    
    // This sets up all the planets and such for this world.
    [_worldViewController buildWorldFromProperties:[self createWorldPropertiesDictionary]];
    
    // Request notifications to send to notifications view
    [self requestNotifications];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitApp) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterApp) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
#if DevModeActivated
    //self.toggleTimerButton.hidden = NO;
    //self.toggleDisplayButton.hidden = NO;
    self.addLifeButton.hidden = NO;
    self.subtractLifeButton.hidden = NO;
    //self.shootStarsButton.hidden = NO;
    //self.sendGiftButton.hidden = NO;
    //self.notificationsButton.hidden = NO;
    self.removeNotificationsButton.hidden = NO;
#else
    self.toggleTimerButton.hidden = YES;
    self.toggleDisplayButton.hidden = YES;
    self.addLifeButton.hidden = YES;
    self.subtractLifeButton.hidden = YES;
    self.shootStarsButton.hidden = YES;
    self.sendGiftButton.hidden = YES;
    self.notificationsButton.hidden = YES;
    self.removeNotificationsButton.hidden = YES;
#endif
}

- (void)requestServerTime
{
    [[WebserviceManager sharedManager] requestServerTimeWithMinutes:[NSNumber numberWithInt:15]
                                                  completionHandler:^
     (NSError *error, NSDictionary *timeInfo)
    {
        if (!error && timeInfo)
        {
            if (timeInfo[@"startTime"])
            {
                
            }
            
            if (timeInfo[@"endTime"])
            {
                
            }
        }
    }];
}

- (void)exitApp
{
    DebugLog(@"exiting app!");
    
    //[[SGAudioManager audioManager].player stop];
    [[SGAudioManager audioManager] stopAllAudio];
    //[[SGAudioManager audioManager].musicPlayer pause];
    
    [self removeShootingStarsTimers];
}

- (void)enterApp
{
    DebugLog(@"entering app!");
    
    //[[SGAudioManager audioManager].player play];
    [[SGAudioManager audioManager] playAllAudio];
    //[[SGAudioManager audioManager].musicPlayer play];
    
    [self activateTravelDots];
    [self restartAnimations];
    
    [self.livesDisplayView checkForAccumulatedLives];
    
    //[self beginShootingStars];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (CDPlanetoidObject *planetoid in _worldViewController.regionIconsArray)
    {
        [planetoid endMorphBubble];
    }
    
    //DebugLog(@"ViewWillDisapear: Main Map View");
    //[[SGAudioManager audioManager] stopAllAudio];
}

- (void)viewDidDisappear:(BOOL)animated
{

}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    if (_mainButtonViewController)
    {
        [_mainButtonViewController.view removeFromSuperview];
        _mainButtonViewController = nil;
    }
    
//    int travelDotCount = 0;
//    int planetCount = 0;
//    int satelliteCount = 0;
//    int storeCount = 0;
//    int otherViewCount = 0;
//    
//    for (UIView *view in _worldViewController.view.subviews)
//    {
//        
//        if ([view isMemberOfClass:[CDTravelDot class]])
//        {
//            travelDotCount++;
//        }
//        else if ([view isMemberOfClass:[CDPlanetoidObject class]])
//        {
//            planetCount++;
//        }
//        else if ([view isMemberOfClass:[CDSateliteObject class]])
//        {
//            satelliteCount++;
//        }
//        else if ([view isMemberOfClass:[CDStoreObject class]])
//        {
//            storeCount++;
//        }
//        else
//        {
//            otherViewCount++;
//        }
//        
//        // Remove all views from worldViewController so they are not recreated
//        [view removeFromSuperview];
//    }
//    
//    DebugLog(@"TravelDots: %u", travelDotCount);
//    DebugLog(@"Planets: %u", planetCount);
//    DebugLog(@"Satellites: %u", satelliteCount);
//    DebugLog(@"Stores: %u", storeCount);
//    DebugLog(@"OtherViews: %u", otherViewCount);

}

- (void)didReceiveMemoryWarning
{
    DebugLog(@"MainMapViewController Received Memory Warning!");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)unlockOrientation
{
    _switchOrientation = allButUpsideDownOrientation;
    
//    UIViewController *disposableViewController = [UIViewController new];
//    [self presentViewController:disposableViewController animated:NO completion:nil];
//    [self.navigationController dismissViewControllerAnimated:NO completion:^{
//        
//    }];
}

- (void)showLevelsPopupForPlantoid:(CDPlanetoidObject *)planetoidObject
{
    self.levelInfoViewController.view.frame = self.view.bounds;
    [self.view insertSubview:self.levelInfoViewController.view belowSubview:_mainButtonViewController.view];
    [self.levelInfoViewController loadPlanetoid:planetoidObject];
    
    [self.levelInfoViewController animateIn];
}

- (void)loadingScreenHandlerInLandscape:(BOOL)inLandscape
{
    [[SGAudioManager audioManager] stopAllAudio];

    if (inLandscape)
    {
        NSString *bgImageString = [NSString stringWithFormat:@"Default-landscape%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
        [self createLoadingScreenWithImageNamed:bgImageString InLandscape:inLandscape];
    }
    else
    {
        NSString *bgImageString = [NSString stringWithFormat:@"Default%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
        [self createLoadingScreenWithImageNamed:bgImageString InLandscape:inLandscape];
    }
}



#pragma mark - Audio

//- (void)playThemeMusic
//{
//    NSUserDefaults *musicButtonStateDefault = [NSUserDefaults standardUserDefaults];
//    NSString *musicButtonState = [musicButtonStateDefault objectForKey:MusicButtonStateDefault];
//    
//    //[[SGAudioManager audioManager] playSoundWithName:@"CCDDD_THEME_MIX_Map" withFileType:@"m4a" volume:0.3f numberOfLoops:-1];
//    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"CCDDD_THEME_MIX_Map" FileType:@"m4a" volume:0.3f numberOfLoopes:-1];
////    if ([musicButtonState isEqualToString:@"play"])
////    {
////        [SGAudioManager audioManager].player.volume = [SGAppDelegate appDelegate].masterVolume;
////    }
////    else if ([musicButtonState isEqualToString:@"mute"])
////    {
////        [[SGAudioManager audioManager] muteTheAudioPlayer:YES];
////    }
//}

#pragma mark - Lives Display Test Methods

// Debug Buttons
- (IBAction)toggleTimer:(id)sender {
    
    [self.livesDisplayView toggleTimerAnimated:YES];
}

- (IBAction)toggleDisplay:(id)sender {
    
    [self.livesDisplayView toggleDisplayAnimated:YES];
}

- (IBAction)addLife:(id)sender {
    //[self.livesDisplayView setNumLivesTo:self.livesDisplayView.numLives + 1];
    self.livesDisplayView.numLives = self.livesDisplayView.numLives + 1;
    
    // Create and play a sound effect.
//    NSURL *url = [[SGFileManager fileManager] urlForFileNamed:@"GlassBreak" fileType:@"m4a"]; //@"m4a"];
//    if (url) {
//        NSError *error = nil;
//        self.livesDing = [[SGAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        if (error) {
//            DebugLog(@"Error initializing sound effect player: %@", error.description);
//            return;
//        }
//        
//        [[SGAudioManager audioManager] playAudioPlayer:self.livesDing];
//    }
}

- (IBAction)subtractLife:(id)sender {
    if (self.livesDisplayView.numLives > 0) {
//        [self.livesDisplayView setNumLivesTo:self.livesDisplayView.numLives - 1];
        self.livesDisplayView.numLives = self.livesDisplayView.numLives - 1;
    }
}


#pragma mark - Lives Display Delegate

- (void)livesDisplayView:(CDLivesDisplayView *)livesDisplayView DidReachLifeUnlockDate:(NSDate *)lifeUnlockDate {
    // Woo Hoo!
}


#pragma mark - Map Navigation

- (void)setMapMinimumZoomScale:(float)minScale {
    _mapScrollView.minimumZoomScale = minScale;
}

//- (void) gotoPosition:(CGPoint)positionPoint Animated:(BOOL)shouldAnimate {
//    CGRect viewRect = CGRectMake(positionPoint.x, positionPoint.y, self.view.frame.size.width, self.view.frame.size.height);
//    [_mapScrollView zoomToRect:viewRect animated:shouldAnimate];
//    
//}

- (void)gotoPosition:(CGPoint)positionPoint AndZoomTo:(float)zoomScale Animated:(BOOL)shouldAnimate completion:(void(^)(void))block  {
    
    if (zoomScale < _mapScrollView.minimumZoomScale) {
        zoomScale = _mapScrollView.minimumZoomScale;
    }
    else if (zoomScale > _mapScrollView.maximumZoomScale) {
        zoomScale = _mapScrollView.maximumZoomScale;
    }
    
    CGRect viewRect = CGRectMake(positionPoint.x, positionPoint.y, self.view.frame.size.width/zoomScale, self.view.frame.size.height/zoomScale);
    [UIView animateWithDuration:(shouldAnimate? 1.5f:0.0f) animations:^{
        [_mapScrollView zoomToRect:viewRect animated:NO];
    } completion:^(BOOL finished) {
        DebugLog(@"Finished Zooming");
        if (block) block();
    }];
}

//- (void)goFromPosition:(CGPoint)positionPoint AndZoomTo:(float)zoomScale Animated:(BOOL)shouldAnimate {
//    
//    if (zoomScale < _mapScrollView.minimumZoomScale) {
//        zoomScale = _mapScrollView.minimumZoomScale;
//    }
//    else if (zoomScale > _mapScrollView.maximumZoomScale) {
//        zoomScale = _mapScrollView.maximumZoomScale;
//    }
//    
//    CGRect viewRect = CGRectMake(positionPoint.x, positionPoint.y, self.view.frame.size.width/zoomScale, self.view.frame.size.height/zoomScale);
//    [_mapScrollView zoomToRect:viewRect animated:shouldAnimate];
//}


#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.worldView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self.mapScrollView setContentSize:CGSizeMake(_mapWidth * scale, _mapHeight * scale)];
    CGRect worldFrame = _worldViewController.view.frame;
    _worldViewController.view.frame = worldFrame;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mapScrollView) {
        self.nebulaScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x * _nebulaSpeedMultiplier, scrollView.contentOffset.y * _nebulaSpeedMultiplier);
        self.closeStarsScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x * _closeStarsSpeedMultiplier, scrollView.contentOffset.y * _closeStarsSpeedMultiplier);
    }
}

- (void)scrollMapToPlanetoid:(UIView *)mapObject completion:(void(^)(void))block {
    float xCoord = mapObject.frame.origin.x - ((self.view.window.frame.size.width - mapObject.frame.size.width)/2);
    float yCoord = mapObject.frame.origin.y - ((self.view.window.frame.size.height - mapObject.frame.size.height)/2);
    CGRect frame = CGRectMake(xCoord, yCoord, self.view.window.frame.size.width, self.view.window.frame.size.height);
    
    [self gotoPosition:frame.origin AndZoomTo:1.0f Animated:YES completion:^{
        if (block) block();
    }];
}

- (void)scrollMapOutwardFromPlanetoid:(UIView *)mapObject {
    
    CGRect frame;
    
    if ([mapObject isKindOfClass:[CDSateliteObject class]])
    {
        //CDSateliteObject *satelite = (CDSateliteObject *)mapObject;
        
        float xCoord = mapObject.frame.origin.x - ((self.view.window.frame.size.width - mapObject.frame.size.width)/2);
        float yCoord = mapObject.frame.origin.y - ((self.view.window.frame.size.height - mapObject.frame.size.height)/2);
        
        frame = CGRectMake(xCoord, yCoord, self.view.window.frame.size.width, self.view.window.frame.size.height);
    }
    else
    {
        float xCoord = mapObject.frame.origin.x - ((self.view.window.frame.size.width - mapObject.frame.size.width)/2);
        float yCoord = mapObject.frame.origin.y - ((self.view.window.frame.size.height - mapObject.frame.size.height)/2);
        
        frame = CGRectMake(xCoord, yCoord, self.view.window.frame.size.width, self.view.window.frame.size.height);
    }
    
    [self gotoPosition:frame.origin AndZoomTo:0.5f Animated:YES completion:nil];
}

#pragma mark - WorldViewController Delegate

- (void)userSelectedPlanetoid:(CDPlanetoidObject *)planetoidObject
{
    if (!_didTapSomething)
    {
        _didTapSomething = YES;
        
        _switchOrientation = portraitOrientation;

        _showLives = NO;
        
//        UIViewController *disposableViewController = [UIViewController new];
//        [self presentViewController:disposableViewController animated:NO completion:nil];
//        [self.navigationController dismissViewControllerAnimated:NO completion:^{
//
//        }];

        _mainButtonViewController.view.userInteractionEnabled = NO;
        
        // Set music to play after disposableViewController has finished
        _loadMusic = YES;
        //DebugLog(@"DisposableViewController: end");
        
        self.lastSelectedPlanetoid = planetoidObject;
        [self scrollMapToPlanetoid:planetoidObject completion:^{
            if (IsoMapsEnabled) {
                [self performSegueWithIdentifier:@"GoToIsometricSegue" sender:self];
            }
            else {
                [self showLevelsPopupForPlantoid:planetoidObject];
                
                self.planetHitName = planetoidObject.name;
                [SGGameManager gameManager].what_planet_am_I_on = planetoidObject.name;
                
                NSURL *url = [[SGFileManager fileManager] urlForFileNamed:self.planetHitName fileType:nil];
                
                NSError *error;
                self.worldAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                
                
                for (int count = 0; count < 1000; count++)
                {
                    self.audioPlayer.volume -= .001;
                }
                
                [self.audioPlayer stop];
                
                [self.worldAudioPlayer setNumberOfLoops:-1];
                
                self.worldAudioPlayer.volume = 0;
                //[self.worldAudioPlayer play];
                
                for (int count = 0; count < 1000; count++)
                {
                    self.worldAudioPlayer.volume += .001;
                }
            }
        }];
    }
}

- (void)worldViewController:(WorldViewController *)controller
 didSelectPlanetoidSatelite:(CDSateliteObject *)sateliteObject
{
    sateliteObject.isSelected = !sateliteObject.isSelected;
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf" volume:1.0f];
    
    if (!sateliteObject.isSelected)
    {
        //[sateliteObject.layer removeAllAnimations];
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = sateliteObject.frame;
            frame.origin.x = frame.origin.x + frame.size.width * 1.5;
            sateliteObject.frame = frame;
        } completion:^(BOOL finished) {
            [self addSateliteBGViewWithSatelite:sateliteObject];
        }];
    }
    else
    {
        [self animateSateliteOut:sateliteObject];
    }
}

- (void)animateSateliteOut:(CDSateliteObject *)satelite
{
    [satelite.bgView removeFromSuperview];
    [satelite.hologramImageView removeFromSuperview];
    [satelite.friendScrollView removeFromSuperview];
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = satelite.frame;
        frame.origin = satelite.originPosition;
        satelite.frame = frame;
        //[self scrollMapOutwardFromPlanetoid:satelite];
    } completion:^ (BOOL finished) {
        // Restart satellite animation after it closes
        [satelite animateSatellite:satelite];
    }];
    
}

- (void)addSateliteBGViewWithSatelite:(CDSateliteObject *)satelite
{
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view addSubview:bgView];
//    bgView.backgroundColor = [UIColor blackColor];
//    bgView.alpha = 0.5f;
//
//    [self.view insertSubview:bgView aboveSubview:self.view.subviews[1]];
//    satelite.bgView = bgView;
    [_worldViewController addHologramWithSatelite:satelite];

}

- (void)userSelectedStore:(CDStoreObject *)storeObject {
    [self presentStore];
}

#pragma mark - Temporary Dictionary Creation
// TODO: Replace this section with a legitamate dictionary from the editor, when
// that is ready.

// Each world has one of these.  We only have one world right now.
- (NSDictionary *)createWorldPropertiesDictionary {
    NSMutableDictionary *theDictionary = [[NSMutableDictionary alloc] init];
    
    [theDictionary setObject:[self loadTravelDots] forKey:@"travelDots"];
    [theDictionary setObject:[self loadPlanetoids] forKey:@"planetoids"];
    [theDictionary setObject:[self createDetailObjectsDictionary] forKey:@"detailObjects"];
    //[theDictionary setObject:@"no_image" forKey:@"imageName"];
    
    return theDictionary;
}

- (NSArray *)loadTravelDots {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *travelDotsPath = [[NSBundle mainBundle] pathForResource:@"traveldots" ofType:@"plist"];
    if ([fileManager fileExistsAtPath:travelDotsPath]) {
        NSArray *travelDotsArray = [[NSArray alloc] initWithContentsOfFile:travelDotsPath];
        return travelDotsArray;
    }
    
    DebugLog(@"Error: Couldn't find file at path '%@'.", travelDotsPath);
    return nil;
}

- (NSArray *)loadPlanetoids {
    NSMutableArray *tempHolderArray = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *masterListPath = [[NSBundle mainBundle] pathForResource:@"planetoids-master-list" ofType:@"plist"];
    if ([fileManager fileExistsAtPath:masterListPath]) {
        NSArray *planetoidsArray = [[NSArray alloc] initWithContentsOfFile:masterListPath];
        for (NSString *planetoidName in planetoidsArray) {
            //DebugLog(@"Loading %@.", planetoidName);
            NSString *planetoidPath = [[NSBundle mainBundle] pathForResource:planetoidName ofType:@"plist"];
            if ([fileManager fileExistsAtPath:planetoidPath]) {
                NSDictionary *planetoidDict = [[NSDictionary alloc] initWithContentsOfFile:planetoidPath];
                [tempHolderArray addObject:planetoidDict];
            } else {
                DebugLog(@"Error: Couldn't find %@.plist", planetoidName);
            }
        }
    } else {
        DebugLog(@"Error: Couldn't find planetoids-master-list.plist");
    }
    
    return tempHolderArray;
}

// This describes all the detail objects on the map, such as animating
// monsters/props.
- (NSArray *)createDetailObjectsDictionary {
    NSMutableArray *worldDetailsArray = [[NSMutableArray alloc] init];
    
    for (int counter = 0; counter < 0; counter++) {
        NSMutableDictionary *objectDict = [[NSMutableDictionary alloc] init];
        // Image
        NSString *iconImageName = @"mountain-icon-blue";
        [objectDict setObject:iconImageName forKey:@"imageName"];
        
        // Position
        CGPoint iconPositionPoint = CGPointMake((counter * 40.0f) + 70, counter * 40.0f);
        NSValue *iconPositionValue = [NSValue valueWithCGPoint:iconPositionPoint];
        [objectDict setObject:iconPositionValue  forKey:@"position"];
        
        // Id
        NSNumber *iconId = [NSNumber numberWithInt:counter];
        [objectDict setObject:iconId forKey:@"id"];
        
        // Commit
        [worldDetailsArray addObject:objectDict];
    }
    
    return worldDetailsArray;
}


- (void)createMainGame
{
    self.cddController = [self.storyboard instantiateViewControllerWithIdentifier:@"CDCookieDunkDunKViewController"];
    self.cddController.delegate = self;
    [self.navigationController presentViewController:self.cddController animated:NO completion:^{
        [_loadingScreen.view removeFromSuperview];
        _loadingScreenIsOpen = NO;
        _switchOrientation = allButUpsideDownOrientation;
        _minigameOrientation = @"portrait";
    }];
}

#pragma mark - Create The MiniGames

- (void)openMinigameForPlanetWithID:(NSNumber *)planetID {
    DebugLog(@"Finding the minigame.");
    
    _loadMusic = NO;
    
    //NSArray *testArray = [NSArray arrayWithObjects:@"CDCardMatchViewController", @"CDCookieBombViewController", @"CDCookieCookerViewController", nil];
    //UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:[testArray objectAtIndex:[planetID intValue]]];
    
    if ([planetID isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        // MilkyWaie
        if ([SGAppDelegate appDelegate].unlockCookieCooker)
        {
            // TODO: Product Push - Make sure the correct mini game is loaded
            [self createCookieCooker];
//            [self createCardMatch];
        }
        else
        {
            [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.view.frame errorDescription:@"This minigame is currently locked. Please come back tomorrow to play again." loadingText:nil];
        }
    }
    else if ([planetID isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        // Dunkopolis
        if ([SGAppDelegate appDelegate].unlockCookieDrop)
        {
            // TODO: Product Push - Make sure the correct mini game is loaded
            [self createCookieDrop];
        }
        else
        {
            [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.view.frame errorDescription:@"This minigame is currently locked. Please come back tomorrow to play again." loadingText:nil];
        }
    }
    else if ([planetID isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        // Abduction Junction
        if ([SGAppDelegate appDelegate].unlockCowAbduction)
        {
            // TODO: Product Push - Make sure the correct mini game is loaded
            [self createAbductionMinigame];
        }
        else
        {
            [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.view.frame errorDescription:@"This minigame is currently locked. Please come back tomorrow to play again." loadingText:nil];
        }
    }
    else if ([planetID isEqualToNumber:[NSNumber numberWithInt:3]])
    {
        // Macaroon City
        if ([SGAppDelegate appDelegate].unlockLeft4Bread)
        {
            // TODO: Product Push - Make sure the correct mini game is loaded
            [self createGingerDead];
        }
        else
        {
            [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.view.frame errorDescription:@"This minigame is currently locked. Please come back tomorrow to play again." loadingText:nil];
        }
    }
    else if ([planetID isEqualToNumber:[NSNumber numberWithInt:4]])
    {
        // Zombie
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
//        
//        [self loadingScreenHandlerInLandscape:YES];
//        
//        double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//                       {
//                                       GingerDeadMenViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GingerDeadMenViewController"];
//                                     [self.navigationController presentViewController:controller animated:NO completion:^{
//                                           [_loadingScreen.view removeFromSuperview];
//                                           _switchOrientation = allButUpsideDownOrientation;
//                                           _minigameOrientation = @"landscape";
//                                       }];
//                       });
    }
    else if ([planetID isEqualToNumber:[NSNumber numberWithInt:5]])
    {
        // Pirate
        //        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
        //        CDCookibeanViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CDCookibeanViewController"];
        //        [self.navigationController presentViewController:controller animated:NO completion:^{
        //
        //        }];
    }
    else if ([planetID isEqualToNumber:[NSNumber numberWithInt:6]])
    {
        // Egypt
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
//        
//        [self loadingScreenHandlerInLandscape:NO];
//        
//        double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//                       {
                           //            CDSpaceInvadersViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CDSpaceInvadersViewController"];
                           //            [self.navigationController presentViewController:controller animated:NO completion:^{
                           //                [_loadingScreen.view removeFromSuperview];
                           //                _switchOrientation = allButUpsideDownOrientation;
                           //                _minigameOrientation = @"portrait";
                           //            }];
//                       });
    }
    
    else
    {
        DebugLog(@"Error opening minigame: Planet ID %@ is not recognized.", planetID);
    }
    
    _loadMusic = YES;
}

- (BOOL)returnLandscapeOrientation
{
    BOOL isRight;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        isRight = YES;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    }
    else
    {
        isRight = NO;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    
    return isRight;
}

- (void)createGingerDead
{
    DebugLog(@"Open Ginger Dead.");
    BOOL isRight = [self returnLandscapeOrientation];
    
    [self loadingScreenHandlerInLandscape:YES];
    
    __weak typeof(self) weakSelf = self;
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       _loadMusic = NO;
                       
                       GingerDeadMenViewController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"GingerDeadMenViewController"];
                       controller.delegate = weakSelf;
                       
                       if (isRight)
                       {
                           controller.presentRight = YES;
                           [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
                       }
                       else
                       {
                           controller.presentRight = NO;
                           [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
                       }
                       
                       [weakSelf.navigationController presentViewController:controller animated:NO completion:^{
                           [_loadingScreen.view removeFromSuperview];
                           _loadingScreenIsOpen = NO;
                           _switchOrientation = allButUpsideDownOrientation;
                           _minigameOrientation = @"landscape";
                           
                           _loadMusic = YES;
                       }];
                   });
    
//    GingerDeadMenViewController *gingerDeadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GingerDeadMenViewController"];
//    [self.navigationController presentViewController:gingerDeadViewController animated:NO completion:^{
//        [_loadingScreen.view removeFromSuperview];
//        _switchOrientation = allButUpsideDownOrientation;
//        _minigameOrientation = @"landscape";
//    }];
}


- (void)createAbductionMinigame
{
    DebugLog(@"Open Abduction");
    
    BOOL isRight = [self returnLandscapeOrientation];
    
    [self loadingScreenHandlerInLandscape:YES];
    
    __weak typeof(self) weakSelf = self;
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        _loadMusic = NO;
        
        CDAbductionViewController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"CDAbductionViewController"];
        controller.delegate = weakSelf;
       
        if (isRight)
        {
            controller.presentRight = YES;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        }
        else
        {
            controller.presentRight = NO;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
        }
        
        [weakSelf.navigationController presentViewController:controller animated:NO completion:^{
            [_loadingScreen.view removeFromSuperview];
            _loadingScreenIsOpen = NO;
            _switchOrientation = allButUpsideDownOrientation;
            _minigameOrientation = @"landscape";
            
            _loadMusic = YES;
        }];
    });
}

- (void)createCookieCooker
{
    DebugLog(@"Open Cookie Cooker.");
    BOOL isRight = [self returnLandscapeOrientation];
    
    _loadMusic = NO;
    [self loadingScreenHandlerInLandscape:YES];
    
    __weak typeof(self) weakSelf = self;
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        _loadMusic = NO;
        
        CDCookieCookerViewController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"CDCookieCookerViewController"];
        controller.delegate = weakSelf;
        
        if (isRight)
        {
            controller.presentRight = YES;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        }
        else
        {
            controller.presentRight = NO;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
        }
        
        [weakSelf.navigationController presentViewController:controller animated:NO completion:^{
            [_loadingScreen.view removeFromSuperview];
            _loadingScreenIsOpen = NO;
            _switchOrientation = allButUpsideDownOrientation;
            _minigameOrientation = @"landscape";
            
            _loadMusic = YES;
        }];
    });
}

- (void)createCookieDrop
{
    DebugLog(@"Open Cookie Bomb.");
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
 
    _loadMusic = NO;
    [self loadingScreenHandlerInLandscape:NO];
    
    __weak typeof(self) weakSelf = self;
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        _loadMusic = NO;
        
        CDCookieBombViewController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"CDCookieBombViewController"];
        controller.delegate = weakSelf;
        [weakSelf.navigationController presentViewController:controller animated:YES completion:^{
            [_loadingScreen.view removeFromSuperview];
            _loadingScreenIsOpen = NO;
            _switchOrientation = allButUpsideDownOrientation;
            _minigameOrientation = @"portrait";
            
            _loadMusic = YES;
        }];
    });
}

- (void)createCardMatch
{
    DebugLog(@"Open Card Match");
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    _loadMusic = NO;
    [self loadingScreenHandlerInLandscape:NO];
    
    __weak typeof(self) weakSelf = self;
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        _loadMusic = NO;
        
        CDCardMatchViewController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"CDCardMatchViewController"];
        controller.delegate = weakSelf;
        [weakSelf.navigationController presentViewController:controller animated:YES completion:^{
            [_loadingScreen.view removeFromSuperview];
            _loadingScreenIsOpen = NO;
            _switchOrientation = allButUpsideDownOrientation;
            _minigameOrientation = @"portrait";
            
            _loadMusic = YES;
        }];
    });
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToIsometricSegue"])
    {
        // Load the isometric view.
        CDIsometricMapViewController *isoViewController = (CDIsometricMapViewController *)segue.destinationViewController;
        
//        // Make sure it's being displayed in portrait.
//        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
//            [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
//            
//            isoViewController.transitionCoverView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:isoViewController.view]];
//            
//            // Tint the new view for debugging.
////            UIView *tintView = [[UIView alloc] initWithFrame:isoViewController.transitionCoverView.frame];
////            tintView.backgroundColor = [UIColor colorWithRed:0.791 green:0.209 blue:0.020 alpha:0.270];
////            [isoViewController.transitionCoverView addSubview:tintView];
//            
//            // Gary J: what are we rotating and why???? It makes no sense to....
//            // Mess with the transform.
//            float rotationDegrees = 0.0f;
//            if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) {
//                rotationDegrees = 90.0f;
//            } else {
//                rotationDegrees = -90.0f;
//            }
//            CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(DegreesToRadians(rotationDegrees));
//            float offset = IS_IPHONE_5? 124.0f : 80.0f; // 3.5" = (80,-80) | 4" = (124,-124)
//            CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(offset, -offset);
//            CGAffineTransform concatTransform = CGAffineTransformConcat(rotateTransform, translateTransform);
//            isoViewController.transitionCoverView.transform = concatTransform;
//
//            // Commenting this out for now.  I need to figure out how to remove it
//            // when the segue animation ends.
//            //[isoViewController.view addSubview:isoViewController.transitionCoverView];
//        }
        
        // Set the required properties.
        isoViewController.bubbleCoords = _lastSelectedPlanetoid.bubbleCoords;
        isoViewController.bubbleScales = _lastSelectedPlanetoid.bubbleScales;
        isoViewController.friendImageOrientations = _lastSelectedPlanetoid.friendImageOrientations;
        isoViewController.minigameStartPoint = _lastSelectedPlanetoid.minigameStartPoint;
        isoViewController.planetDisplayName = _lastSelectedPlanetoid.displayName;
        isoViewController.planetName = _lastSelectedPlanetoid.name;
        isoViewController.delegate = self;
        
        // Get the list of levels for the selected planet.
        for (NSDictionary *worldDict in [SGAppDelegate appDelegate].accountDict[@"worlds"]) {
            if ([worldDict[@"type"] isEqualToNumber:[NSNumber numberWithInt:[_lastSelectedPlanetoid.planetID intValue] + 1]]) {
                isoViewController.levelProperties = worldDict[@"levels"];
                isoViewController.planetID = _lastSelectedPlanetoid.planetID;
                break;
            }
        }
        
        
        
        
        
//        NSPredicate *filterWorldsPredicate = [NSPredicate predicateWithFormat:@"type = %i", [_lastSelectedPlanetoid.planetID intValue]+1];
//        NSArray *filteredWorldsArray = [[SGAppDelegate appDelegate].accountDict[@"worlds"] filteredArrayUsingPredicate:filterWorldsPredicate];
//        if ([filteredWorldsArray count] > 0) {
//            isoViewController.levelProperties = filteredWorldsArray[0][@"levels"];
//            isoViewController.planetID = [NSNumber numberWithInt:[filteredWorldsArray[0][@"type"] intValue] - 1];
//        }
        
        DebugLog(@"stop");
        _switchOrientation = portraitOrientation;
    }
}

#pragma mark - LevelSelectInfoViewControllerDelegate

- (void)levelInfoViewControllerDidCancel:(LevelInfoViewController *)viewController
{
    _didTapSomething = NO;
    for (int count = 0; count < 1000; count++)
    {
        self.worldAudioPlayer.volume -= .001;
    }
    
    [self.worldAudioPlayer stop];
    
    self.audioPlayer.volume = 0;
//    [self.audioPlayer play];
    for (int count = 0; count < 1000; count++)
    {
        self.audioPlayer.volume += .001;
    }
}

- (void)levelInfoViewController:(LevelInfoViewController *)levelInfoVC DidSelectLevel:(NSNumber *)levelType OnPlanet:(NSNumber *)planetType
{
    [self loadingScreenHandlerInLandscape:NO];

    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [self createMainGame];
        [self.cddController createLevelWithID:levelType ForPlanet:planetType];
    });
}

- (void)levelInfoViewController:(LevelInfoViewController *)controller DidSelectMinigameForPlanetWithID:(NSNumber *)planetID {
    [self openMinigameForPlanetWithID:planetID];
}


#pragma mark - Isometric Map Delegate

- (void)isometricMap:(CDIsometricMapViewController *)isoMap didSelectLevel:(NSNumber *)levelID planet:(NSNumber *)planetID {
    [self loadingScreenHandlerInLandscape:NO];
    
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [self createMainGame];
        [self.cddController createLevelWithID:levelID ForPlanet:planetID];
    });
}

- (void)isometricMap:(CDIsometricMapViewController *)isoMap didSelectMinigameForPlanetWithID:(NSNumber *)planetID {
    DebugLog(@"Opening Minigame");
    [self openMinigameForPlanetWithID:planetID];
}

- (void)shopWasSelectedInTheIsoMap
{
    [self presentStore];
}

- (void)isometricMapWillExit:(CDIsometricMapViewController *)isoMap withVideoName:(NSString *)videoName
{
    [[SGAudioManager audioManager] stopAllAudio];
    [_audioPlayer stop];
    
    [isoMap dismissViewControllerAnimated:NO completion:^{
        
        _switchOrientation = portraitOrientation;
        
        UIViewController *disposableViewController = [UIViewController new];
        [self presentViewController:disposableViewController animated:NO completion:nil];
        [self.navigationController dismissViewControllerAnimated:NO completion:^{
            
        }];
        
        _videoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CDVideoPlayerViewController"];
        _videoViewController.delegate = self;
        [self.view addSubview:_videoViewController.view];

        [[SGAudioManager audioManager] stopAllAudio];
        [_videoViewController playVideoNamed:videoName];
    }];
}

- (void)isometricMapWillExit:(CDIsometricMapViewController *)isoMap WithAnimation:(BOOL)willAnimate ToStore:(BOOL)toTheStore
{
    [[SGAudioManager audioManager] stopAllAudio];
    [_audioPlayer stop];
    
    [isoMap dismissViewControllerAnimated:willAnimate completion:^{
        [self unlockOrientation];
        
        if (toTheStore)
        {
            [self presentStore];
        }
    }];
}

#pragma mark - Main Button

- (void)presentHelpView
{
    _standardPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
    
    _standardPopup.delegate = self;
    _standardPopup.whatAmILoading = @"mainGameHelp";
    
    _standardPopup.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view insertSubview:_standardPopup aboveSubview:_mainButtonViewController.view];
    [_standardPopup setup];
    
    _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

- (void)presentAccountView
{
    DebugLog(@"THE ACCOUNT BUTTON WAS HIT");
    if ([SGAppDelegate appDelegate].accountDict)
    {
        _accountView = [[[NSBundle mainBundle] loadNibNamed:@"CDAccountPopupIphone5View" owner:self options:nil] objectAtIndex:0];
        [_accountView.backgroundImage setImage:[UIImage imageNamed:@"cdd-main-board-hud-minigamepanel-v-568h"]];
        _accountView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        _accountView.delegate = self;
        _accountView.leaderboardIsUp = _leaderboardIsOpen;
        _accountView.leaderBoardIsGlobal = _leaderBoardIsGlobal;
        
        _accountView.buttonIsOpenForRotation = _accountButtonIsOpenForOrientation;
        
        [self.view insertSubview:_accountView aboveSubview:_mainButtonViewController.view];
        [_accountView setupWithParentalViewController:self];
        
        _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.view.frame errorDescription:@"You are not currently logged in. Please Login to view your account." loadingText:nil];
        
        _mainButtonViewController.popupIsUp = NO;
        [_mainButtonViewController enableButtons:YES];
    }
}

- (void)presentStore
{
    BOOL isRight = NO;
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        isRight = YES;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    }
    else
    {
        isRight = NO;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    
    
    
    CDStoreViewController *storeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CDStoreViewController"];
    storeViewController.presentRight = isRight;
//    [self.navigationController pushViewController:storeViewController animated:YES];
    
    [[SGAppDelegate appDelegate] transitionFadeWithParentViewController:self
                                            endTransitionViewController:storeViewController
                                                          withImageName:nil
                                                          navController:NavControllerTransitionType_Push
                                                  willAnimateTransition:NO];
    
//    _switchOrientation = landscapeOrientation;
    
//    UIViewController *disposableViewController = [[UIViewController alloc] init];
//    [self presentViewController:disposableViewController animated:NO completion:nil];
//    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    
//    [self.navigationController pushViewController:storeViewController animated:NO];
    
    // Set MainMap music to play when store is presented
    _loadMusic = YES;
}


#pragma mark - CookieDunkDunkViewController Delegate

- (void)cookieDunkDunkViewController:(CDCookieDunkDunKViewController *)cddViewController unlockLevel:(NSNumber *)levelType planet:(NSNumber *)planetType animated:(BOOL)animated {
    
    
    // Load and select the proper planet.
//    NSString *planetNameString = [[SGFileManager fileManager] ]
//    NSDictionary *planetDict = [[SGFileManager fileManager]loadDictionaryWithFileName:planetName OfType:@"plist"];
//    CDPlanetoidObject *planet = [CDPlanetoidObject new];
//    [planet setPropertiesFromDictionary:planetDict];
//    [self userSelectedPlanetoid:planet];
    
    //DebugLog(@"player account = %@", [SGAppDelegate appDelegate].accountDict);
    
    
    
    
    
            
    // Load and select the proper planet.
    NSString *planetName = [[SGFileManager fileManager] stringFromIndex:[planetType intValue] - 1 inFile:@"planetoids-master-list"];
    NSDictionary *planetDict = [[SGFileManager fileManager]loadDictionaryWithFileName:planetName OfType:@"plist"];
    CDPlanetoidObject *planet = [CDPlanetoidObject new];
    [planet setPropertiesFromDictionary:planetDict];
    [self userSelectedPlanetoid:planet];
    
    NSString *email = [[SGAppDelegate appDelegate] fetchPlayerEmail];
    NSString *deviceID = [[SGAppDelegate appDelegate] fetchPlayerDeviceID];
    [[WebserviceManager sharedManager] updateLevelParametersWithEmail:email
                                                             deviceId:deviceID
                                                            worldType:planetType
                                                            worldName:planetName
                                                            levelType:levelType
                                                            starCount:0
                                                            highScore:0
                                                    completionHandler:^
     (NSError *error, NSDictionary *levelInfo)
    {
        
        if (!error)
        {
            DebugLog(@"levelInfo => %@", levelInfo);
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.levelInfoViewController.levelsCollectionView reloadData];  // <<< Not happening?
            });
        }
        
    }];
    
    
    
    
    
    
    
//                        [[WebserviceManager sharedManager] requestToFetchAccountWithAccountId:[SGAppDelegate appDelegate].accountDict[@"_id"] completionHandler:^(NSError *error, NSDictionary *accountDict) {
//                            
//                            if (!error && accountDict)
//                            {
//                                DebugLog(@"RETURNED accountDict => %@", accountDict);
//                            }
                        
//                            if (error == nil) {
//                                if (accountDict != nil) {
//                                    DebugLog(@"Player account was reloaded.");
//                                    [SGAppDelegate appDelegate].accountDict = [NSMutableDictionary dictionaryWithDictionary:accountDict];
//                                    [_levelInfoViewController.levelsCollectionView reloadData];
//                                    
////                                    // Load and select the proper planet.
////                                    NSString *planetName = [[SGFileManager fileManager] stringFromIndex:[worldType intValue] - 1 inFile:@"planetoids-master-list"];
////                                    NSDictionary *planetDict = [[SGFileManager fileManager]loadDictionaryWithFileName:planetName OfType:@"plist"];
////                                    CDPlanetoidObject *planet = [CDPlanetoidObject new];
////                                    [planet setPropertiesFromDictionary:planetDict];
////                                    [self userSelectedPlanetoid:planet];
//                                }
//                                else {
//                                    DebugLog(@"Error fetching account: Returned accountDict is nil.");
//                                }
//                            }
//                            else {
//                                DebugLog(@"Error fetching account: %@", error.description);
//                            }
//                        }];
//                    }
//                    else {
//                        DebugLog(@"Error updating level parameters: levelInfo dictionary is nil.");
//                    }
//                }
//                else {
//                    DebugLog(@"Error updating level parameters: %@", error.description);
//                }
//            }];
//        }
//        else {
//            DebugLog(@"Error: Levels array could not be loaded.");
//        }
//    }
//    else {
//        DebugLog(@"Error: Player's worlds array could not be loaded.");
//    }
    
    
    
    
//    NSDictionary *planetDict = [[SGFileManager fileManager]loadDictionaryWithFileName:planetName OfType:@"plist"];
//    NSArray *levelsArray = planetDict[@"levelsArray"];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", levelID];
//    NSArray *filter = [levelsArray filteredArrayUsingPredicate:predicate];
//    DebugLog(@"%@",filter);
//    
//    if (filter.count > 0) {
//        
//        int levelIndex = (int) [levelsArray indexOfObject:filter.firstObject];
//        
//        
//        DebugLog(@"Just finished level at index '%i'.", levelIndex);
//        
//        if (levelIndex < 30) {
//           
//            _levelInfoViewController.willUpdateLevel = YES;
//            
//            CDPlanetoidObject *planet = [CDPlanetoidObject new];
//            [planet setPropertiesFromDictionary:planetDict];
//            [self userSelectedPlanetoid:planet];
//        }
//    }
//    else
//    {
//        DebugLog(@"Error: No level found with id '%@' on planet '%@'.", levelID, planetName);
//    }
}

#pragma mark - Loading Screen

- (void)createLoadingScreenWithImageNamed:(NSString *)imageName InLandscape:(BOOL)inLandscape
{
    
    // TODO: JOSH
//    return;
    
    _loadingScreenIsOpen = YES;
    
    self.loadingScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CDLoadingScreenViewController"];
    [self.view addSubview:self.loadingScreen.view];
    
    if (!inLandscape)
    {
        _switchOrientation = portraitOrientation;
        
        // IOS8 CHANGE: ORIENTATION
        UIViewController *disposableViewController = [UIViewController new];
        [self presentViewController:disposableViewController animated:NO completion:nil];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        
        self.loadingScreen.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }
    else
    {
        _switchOrientation = landscapeOrientation;
        
        // IOS8 CHANGE: ORIENTATION
        UIViewController *disposableViewController = [UIViewController new];
        [self presentViewController:disposableViewController animated:NO completion:nil];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        
        self.loadingScreen.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    
    // Dismissing that disposableViewController causes the underlying view controller to hit it's 'viewWill/DidAppear methods.
    // Those often start the music for that view controller, so stop the audio right here.
    [[SGAudioManager audioManager] stopAllAudio];
    
    [self.loadingScreen createLoadingScreenWithImageName:imageName];
}

#pragma mark - Main Button Delegates
- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction
{
    _rootMapView.userInteractionEnabled = !willDisableInteraction;
    _mapScrollView.userInteractionEnabled = !willDisableInteraction;
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
        DebugLog(@"ButtonIndex: MainMapViewController");
        
//        [self.mainButtonViewController mainButtonHit:self.mainButtonViewController.mainButton];
        
//        _mainButtonViewController.view.clipsToBounds
//        for (CDPlanetoidObject *planetoid in _worldViewController.regionIconsArray)
//        {
//            [planetoid endMorphBubble];
//        }
//        
//        [[SGAppDelegate appDelegate] transitionEndFadeWithParentViewController:self
//                                                   navControllerTransitionType:NavControllerTransitionEndType_Pop
//                                                                 withImageName:nil
//                                                         willAnimateTransition:NO];
//        
//        if ([self.delegate respondsToSelector:@selector(mainMapViewControllerDidPoptoMainMenu:)])
//        {
//            [self.delegate mainMapViewControllerDidPoptoMainMenu:self];
//        }
//        
//        [[SGAudioManager audioManager] stopTheAudioPlayer];
//        [[SGAppDelegate appDelegate] playThemeMusic];
//        
        [_mainButtonViewController mainButtonHit:_mainButtonViewController.mainButton];
    }
    else if (buttonIndex == helpButtonIndex)
    {
        DebugLog(@"THE HELP BUTTON WAS HIT");
        [self presentHelpView];
    }
    else if (buttonIndex == volumeButtonIndex)
    {
        DebugLog(@"THE VOLUME BUTTON WAS HIT");
    }
    else if (buttonIndex == shopButtonIndex)
    {
        DebugLog(@"THE SHOP BUTTON WAS HIT");
//        [self.mainButtonViewController mainButtonHit:self.mainButtonViewController.mainButton];
//        _mainButtonViewController.view.clipsToBounds = YES;
        [self presentStore];
    }
    else if (buttonIndex == accountButtonIndex)
    {
        DebugLog(@"THE ACCOUNT BUTTON WAS HIT");
        [self presentAccountView];
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
    _accountButtonIsOpenForOrientation = 1;
    _leaderBoardIsGlobal = NO;
    _leaderboardIsOpen = NO;
    
    [accountView removeFromSuperview];
    _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _mainButtonViewController.popupIsUp = NO;
    
    [_mainButtonViewController enableButtons:YES];
}

- (void)addCoinsButtonWasHitOnAccountPopup:(CDAccountPopupView *)accountView
{
    [accountView removeFromSuperview];
//    [self.mainButtonViewController mainButtonHit:self.mainButtonViewController.mainButton];
//    _mainButtonViewController.view.clipsToBounds = YES;
    [self presentStore];
}

#pragma mark - Standard Popup Delegate

- (void)exitButtonWasHitOnStandardPopupView:(CDStandardPopupView *)standardPopup
{
    [standardPopup removeFromSuperview];
    _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _mainButtonViewController.popupIsUp = NO;
//    _helpIsOpen = NO;
    
    [_mainButtonViewController enableButtons:YES];
}

#pragma mark - GingerDead Delegate
- (void)storeButtonHitInGingerDeadViewController
{
    if (!_didTapSomething)
    {
        _didTapSomething = YES;
        [self presentStore];
    }
}

#pragma mark - AbductionMinigame Delegate

- (void)replayButtonWasHitInAbductionMinigame
{
    [self createAbductionMinigame];
}

- (void)storeButtonHitInAbductionMinigame
{
    if (!_didTapSomething)
    {
        _didTapSomething = YES;
        [self presentStore];
    }
}

#pragma mark - CookieCooker Delegate

- (void)replayButtonWasHitInCookieCooker
{
    [self createCookieCooker];
}

- (void)storeButtonWasHitInCookieCooker
{
    if (!_didTapSomething)
    {
        _didTapSomething = YES;
        [self presentStore];
    }
}

#pragma mark - CookieDrop Delegate

- (void)replayButtonWasHitOnCookieDropViewController
{
    [self createCookieDrop];
}

- (void)storeButtonWasHitInCookieBombViewController
{
    if (!_didTapSomething)
    {
        _didTapSomething = YES;
        [self presentStore];
    }
}

#pragma mark - CardMatch Delegate
- (void)replayButtonWasHitInCardMatch
{
    [self createCardMatch];
}

- (void)storeButtonWasHitInCardMatch
{
    if (!_didTapSomething)
    {
        _didTapSomething = YES;
        [self presentStore];
    }
}

#pragma mark - Main Game Delegate
- (void)shopButtonWasHitInMainGameViewController
{
    if (!_didTapSomething)
    {
        _didTapSomething = YES;
        [self presentStore];
    }
}

- (void)cookieDunkDunkViewControllerWillGoBackToMap:(CDCookieDunkDunKViewController *)cookieDunkDunkViewController withVideoName:(NSString *)videoName
{
    
}

#pragma mark - Video Player Delegate
- (void)videoPlayerHasEnded:(CDVideoPlayerViewController *)videoViewController
{
    _videoViewController = nil;
    
    [self unlockOrientation];
    [_videoViewController.view removeFromSuperview];
    
    // Right Here
    [_audioPlayer play];
    _switchOrientation = allButUpsideDownOrientation;
    
    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"CCDDD_THEME_MIX_Map" FileType:@"m4a" volume:0.15f numberOfLoopes:-1];
    
//    UIViewController *disposableViewController = [UIViewController new];
//    [self presentViewController:disposableViewController animated:NO completion:nil];
//    [self.navigationController dismissViewControllerAnimated:NO completion:^{
//        
//    }];
    
    [videoViewController.view removeFromSuperview];
    
    NSDictionary *freeCostumeDictionary = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:FreeCookieCostumeDictionaryDefault]];
    DebugLog(@"%@", freeCostumeDictionary);
    if (freeCostumeDictionary && ![[freeCostumeDictionary objectForKey:@"name"] isEqualToString:@"nothingForYou"])
    {
        _awardPopup = [self.storyboard instantiateViewControllerWithIdentifier:@"CDAwardPopupViewController"];
        _awardPopup.view.frame = self.view.frame;
        _awardPopup.delegate = self;
        _awardPopup.awardFreeCostume = YES;
        [self.view insertSubview:_awardPopup.view aboveSubview:_mainButtonViewController.view];
    }
}

#pragma mark - Awards Popup Delegate
- (void)didTapScreenToDismissAwardsPopupViewController:(CDAwardPopupViewController *)awardsPopupViewController
{
    [awardsPopupViewController.view removeFromSuperview];
    awardsPopupViewController = nil;
}

#pragma mark - Device Orientation

- (void)orientationChanged:(NSNotification *)notification
{
    self.view.frame = self.view.superview.bounds;
}

- (BOOL)shouldAutorotate
{
    if (_switchOrientation == allButUpsideDownOrientation)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (_switchOrientation == portraitOrientation)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    else if (_switchOrientation == landscapeOrientation)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else if (_switchOrientation == allButUpsideDownOrientation)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (_switchOrientation == portraitOrientation)
    {
        return UIInterfaceOrientationPortrait;
    }
    else if (_switchOrientation == landscapeOrientation)
    {
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
        {
            return UIInterfaceOrientationLandscapeRight;
        }
        return UIInterfaceOrientationLandscapeLeft;
    }
    else if (_switchOrientation == allButUpsideDownOrientation)
    {
        if ([_minigameOrientation isEqualToString:@"portrait"])
        {
            return UIInterfaceOrientationPortrait;
        }
        else if ([_minigameOrientation isEqualToString:@"landscape"])
        {
            if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
            {
                return UIInterfaceOrientationLandscapeRight;
            }
            return UIInterfaceOrientationLandscapeLeft;
        }
        else
        {
            return UIInterfaceOrientationPortrait;
        }
    }
    else
    {
        return 0;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (_mainButtonViewController)
    {
        [_mainButtonViewController orientationHasChanged:toInterfaceOrientation WithDuration:duration];
        _mainButtonViewController.conditionalViewFrame = self.view.frame;
    }
}


#pragma mark - Tutorial

- (void)setupTutorial {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:HasSeenMapIntroTutorial]) {
        return;
    }
    else {
        [userDefaults setBool:YES forKey:HasSeenMapIntroTutorial];
        [userDefaults synchronize];
    }
    
    // Lock to portrait.
    _switchOrientation = portraitOrientation;
    
    // Create the fade view which whill control everything.
    self.fadeView = [[SGFocusableFadeView alloc] initWithFrame:self.view.frame];
    self.fadeView.delegate = self;
    [self.view addSubview:self.fadeView];
    
    //[[SGFileManager fileManager] listAllFonts];
    // ArialRoundedMTBold
    // Arial-BoldMT
    // HelveticaNeue-Bold
    // HelveticaNeue-CondensedBlack
    // HelveticaNeue-CondensedBold
    // HelveticaNeue-Medium
    // HelveticaNeue
    
    
    
    // Set the properties.
    self.fadeView.assistantScale = 0.6f;
    [self.fadeView.dialogueViewController.dialogueTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self.fadeView.dialogueViewController.dialogueTextLabel setTextAlignment:NSTextAlignmentLeft];
    self.fadeView.dialogueViewController.dialogueTextLabel.textColor = [UIColor colorWithRed:0.947 green:0.982 blue:1.000 alpha:1.000];
    self.fadeView.dialogueViewController.dialogueTextLabel.strokeSize = 1.0f;
    self.fadeView.dialogueViewController.dialogueTextLabel.strokeColor = [UIColor colorWithRed:0.043 green:0.051 blue:0.090 alpha:1.000];
    
    
    // Welcome to the map.
    [self.fadeView addNewPageWithFocusedViews:nil
                               assistantImage:[UIImage imageNamed:@"chip-idle-001"]
                            assistantPosition:CGPointMake(35, 310)
                                dialogueFrame:CGRectMake(65, 80, 170, 220)
                                 dialogueText:@" Hi There!\n\n My name is\n Chip, and this \n is the star map.\n\n Let me show\n you around."
                       dialogueSpikeDirection:DialogueSpikeDirectionDownLeft
                          dialogueSpikeOffset:20.0];
    
    // Introduce the Main Button.
    [self.fadeView addNewPageWithFocusedViews:@[self.mainButtonViewController.view]
                               assistantImage:[UIImage imageNamed:@"chip-idle-001"]
                            assistantPosition:CGPointMake(60, 340)
                                dialogueFrame:CGRectMake(78, 20, 220, 310)
                                 dialogueText:@" This is the Button\n Button!\n\n You can find it\n throughout the\n game.\n\n Tapping the Button\n Button gives you a\n whole bunch of\n options like settings,\n profile and more."
                       dialogueSpikeDirection:DialogueSpikeDirectionDownLeft
                          dialogueSpikeOffset:30.0];
    
    // Introduce Lives Heart.
    [self.fadeView addNewPageWithFocusedViews:@[self.livesDisplayView]
                               assistantImage:[UIImage imageNamed:@"chip-idle-001"]
                            assistantPosition:CGPointMake(30, 65)
                                dialogueFrame:CGRectMake(55, 180, 205, 195)
                                 dialogueText:@" This Heart up here\n keeps track of how \n many lives you\n have. Once you\'re\n out, you won\'t be\n able to play any\n more levels..."
                       dialogueSpikeDirection:DialogueSpikeDirectionUpLeft
                          dialogueSpikeOffset:20.0];
    
    // Explain life recharging.
    [self.fadeView addNewPageWithFocusedViews:@[self.livesDisplayView]
                               assistantImage:[UIImage imageNamed:@"chip-idle-001"]
                            assistantPosition:CGPointMake(30, 65)
                                dialogueFrame:CGRectMake(55, 180, 185, 180)
                                 dialogueText:@" But don\'t worry!\n If you lose any\n lives, they\'ll\n recharge back\n to full!"
                       dialogueSpikeDirection:DialogueSpikeDirectionUpLeft
                          dialogueSpikeOffset:20.0];
    
    // Point out the store.
    [self.fadeView addNewPageWithFocusedViews:@[self.worldViewController.storeShip]
                               assistantImage:[UIImage imageNamed:@"chip-idle-001"]
                            assistantPosition:CGPointMake(20, 255)
                                dialogueFrame:CGRectMake(30, 40, 225, 190)
                                 dialogueText:@" This beat up old RV\n is the Shop!\n\n Make sure you stop\n in from time to time\n and check out all the\n cool stuff in there!"
                       dialogueSpikeDirection:DialogueSpikeDirectionDownLeft
                          dialogueSpikeOffset:50.0];
    
    // Tap planets to play.
    [self.fadeView addNewPageWithFocusedViews:@[self.worldViewController.regionIconsArray[0]]
                               assistantImage:[UIImage imageNamed:@"chip-idle-001"]
                            assistantPosition:CGPointMake(190, 130)
                                dialogueFrame:CGRectMake(30, 230, 235, 150)
                                 dialogueText:@" When you\'re ready to\n start playing, tap on\n the planet to bring up\n the levels."
                       dialogueSpikeDirection:DialogueSpikeDirectionUpRight
                          dialogueSpikeOffset:170.0];
    
    // Good Luck!
    [self.fadeView addNewPageWithFocusedViews:nil
                               assistantImage:[UIImage imageNamed:@"chip-idle-001"]
                            assistantPosition:CGPointMake(100, 185)
                                dialogueFrame:CGRectMake(65, 85, 176, 80)
                                 dialogueText:@" Have fun,\n and Good Luck!"
                       dialogueSpikeDirection:DialogueSpikeDirectionDownRight
                          dialogueSpikeOffset:30.0];
    
    // Begin!
    [self.fadeView startTutorial];
    
}

- (void)focusableFadeView:(SGFocusableFadeView *)focusableFadeView movedToPage:(int)pageNumber pageDictionary:(NSDictionary *)pageDictionary {
    // Do any page specific actions here.
    
    /*
    switch (pageNumber) {
        case 3:
            DebugLog(@"Make lives display lose a heart.");
            break;
            
        default:
            break;
    }
     */
}

- (void)focusableFadeViewFinishedPages:(SGFocusableFadeView *)focusableFadeView {
    
    // Return orientation freedom.
    _switchOrientation = allButUpsideDownOrientation;
    
    // Clean up.
    [self.fadeView removeFromSuperview];
    self.fadeView = nil;
}


#pragma mark - Shooting Stars

- (void)beginShootingStars {
    
    float firstStarInterval = arc4random_uniform(900);
    
    self.shootingStarsInitialTimer = [NSTimer scheduledTimerWithTimeInterval:firstStarInterval
                                                                        target:self
                                                                      selector:@selector(shootStarsRepeatedly)
                                                                      userInfo:nil
                                                                       repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:self.shootingStarsInitialTimer forMode:UITrackingRunLoopMode];
}

- (void)shootStarsRepeatedly {
    
    // Get rid of the initial timer.
    [self.shootingStarsInitialTimer invalidate];
    self.shootingStarsInitialTimer = nil;
    
    // Start the real loop.
    self.shootingStarsRepeatingTimer = [NSTimer scheduledTimerWithTimeInterval:900 // 15 minutes.
                                                                        target:self
                                                                      selector:@selector(createStarShower)
                                                                      userInfo:nil
                                                                       repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.shootingStarsRepeatingTimer forMode:UITrackingRunLoopMode];
}

- (void)removeShootingStarsTimers {
    [self.shootingStarsInitialTimer invalidate];
    self.shootingStarsInitialTimer = nil;
    
    [self.shootingStarsRepeatingTimer invalidate];
    self.shootingStarsRepeatingTimer = nil;
}

- (MapObject *)createShootingStar {
    MapObject *shootingStar = [[MapObject alloc] initWithImageNamed:@"cdd-shootingstar-02"];
    [self.closeStarsScrollView addSubview:shootingStar];
    
    return shootingStar;
}

- (void)createStarShower {
    
    // Total number of stars in the shower.
    int totalStars = 1;
    
    // Potential for a star storm.
    if (arc4random_uniform(100) < 3) {
        DebugLog(@"Thar be a storm a brew'n!");
        totalStars = floor(arc4random() % 15) + 5;
    }
    
    // Max delay between stars.
    float maxDelay = 0.7f;
    
    // We'll need this for later.
    float currentDelay = 0.0f;
    
    // Distance from the trajectory center. (Constant value. Should always reach offscreen.)
    float magnitude = 600.0f;
    
    // Max X and Y distance from screen center.
    float maxTrajectoryOffset = 0.0f; //450.0f;
    
    // Current screen center, taking scroll into account.
    CGPoint screenCenter = CGPointMake(self.view.center.x + self.closeStarsScrollView.contentOffset.x,
                                       self.view.center.y + self.closeStarsScrollView.contentOffset.y);
    
    // Pick a random angle.
    float directionDeg = arc4random_uniform(360);
    
    // Create the shooting stars.
    for (int count = 0; count < totalStars; count++) {
        
        // Create a new shooting star.
        MapObject *shootingStar = [self createShootingStar];
        shootingStar.alpha = 0.7f;
        
        // Move the star's anchor point to the center of the left edge.
        [[shootingStar layer] setAnchorPoint:CGPointMake(0.0f, 0.5f)];
        
        // The shooting star will pass through this point halfway through it's flight.
        CGPoint trajectoryCenter = CGPointMake(screenCenter.x + (arc4random_uniform(maxTrajectoryOffset) - (maxTrajectoryOffset/2)),
                                               screenCenter.y + (arc4random_uniform(maxTrajectoryOffset) - (maxTrajectoryOffset/2)));
        
        // Position the star based on the chosen angle.
        CGPoint starOrigin = [BLINDED_Math positionFromMagnetude:magnitude Degrees:directionDeg];
        shootingStar.position = CGPointMake(starOrigin.x + trajectoryCenter.x,
                                            starOrigin.y + trajectoryCenter.y);
        
        // Rotate the star to match the chosen angle.
        shootingStar.transform = CGAffineTransformMakeRotation(DegreesToRadians(directionDeg));
        
        // Delay
        float delay = ((arc4random_uniform(100) / 100.0f) * maxDelay) + 0.15f;
        currentDelay += delay;
        
        // Animate the star.
        [UIView animateWithDuration:1.0f delay:currentDelay options:UIViewAnimationOptionTransitionNone animations:^{
            shootingStar.transform = CGAffineTransformTranslate(shootingStar.transform, -magnitude * 2, 0);
        } completion:^(BOOL finished) {
            // Clean up.
            [shootingStar removeFromSuperview];
        }];
    }
}

- (IBAction)shootStars:(id)sender {
    [self createStarShower];
}

#pragma mark - Gift

- (IBAction)sendGift:(id)sender
{
    DebugLog(@"Sending Gift...");
    
    // requestToGiftFriendWithAccountEmail:(NSString *)sender
    // friendEmail:(NSString *)recipient
    // giftType:(NSString *)command
    // giftAmount:(NSString *)value
    // giftCostType:(NSString *)giftCostType
    // giftCostValue:(NSNumber *)giftCostValue
    // giftingMessage:(NSString *)message

    // Gift types
    // @"lives"
    // @"moves"
    // @"gems"
    // @"coins"
    
    // Powerups
    // @"powerGlove"
    // @"wrappedCookie"
    // @"bomb"
    // @"smore"
    
    // Boosters
    // @"radioactiveSprinkle"
    // @"spatula"
    // @"slotMachine"
    // @"thunderbolt"
    
    [[WebserviceManager sharedManager] requestToGiftFriendWithAccountEmail:[SGAppDelegate appDelegate].accountDict[@"email"]
                                                               //friendEmail:@"cz52@7gungames.com"
                                                               //friendEmail:@"vincentnate@yahoo.com"
                                                               friendEmail:@"rdj_rodjenk@yahoo.com"
                                                                  giftType:@"smore"
                                                                giftAmount:@"20"
                                                              giftCostType:@"coins"
                                                             giftCostValue:@100
                                                            giftingMessage:[NSString stringWithFormat:@"%@ %@ sent you a gift!", [SGAppDelegate appDelegate].accountDict[@"firstName"], [SGAppDelegate appDelegate].accountDict[@"lastName"]]
                                                         completionHandler:^
     (NSError *error, NSDictionary *giftInfo)
     {
         if (!error && giftInfo)
         {
             DebugLog(@"%@", giftInfo);
             
         }
         else if (error)
         {
             DebugLog(@"%@", error.description);
         }
         
     }];

}

- (IBAction)notifications:(id)sender
{
    NSMutableArray *notificationIds = [[NSMutableArray alloc] init];

    [[WebserviceManager sharedManager] requestToShowNotificationsWithAccountId:[SGAppDelegate appDelegate].accountDict[@"_id"] completionHandler:^
     (NSError *error, NSDictionary *notificationsInfoDict)
     {
         if (!error && notificationsInfoDict)
         {
             NSMutableArray *notificationsArray = [[NSMutableArray alloc] init];
             
             if (notificationsInfoDict[@"notifications"])
             {
                 notificationsArray = [notificationsInfoDict[@"notifications"] mutableCopy];
                 
                 for (NSDictionary *notification in notificationsArray)
                 {
                     [notificationIds addObject:notification[@"_id"]];
                     
                     DebugLog(@"%@", notification[@"command"]);
                     BOOL acceptGift = YES;
                     
                     if (acceptGift && [notification[@"command"] isEqualToString:@"powerGlove"])
                     {
                         NSMutableDictionary *parametersDict = [NSMutableDictionary new];
                         
                         //parametersDict[@"powerups"] = [NSNumber numberWithInt:1];
                         
                         //[parametersDict setValue:[NSNumber numberWithInt:1] forKey:@"smore"];
                         NSMutableDictionary *powerupsDict = [NSMutableDictionary new];
                         
                         if ([SGAppDelegate appDelegate].accountDict[@"powerups"])
                         {
                             powerupsDict = [[SGAppDelegate appDelegate].accountDict[@"powerups"] mutableCopy];
                         }
                         if (powerupsDict[@"powerGlove"] && notification[@"value"])//(powerupsDict[@"smore"] && notification[@"value"])
                         {
                             //parametersDict[@"powerGlove"] = [NSNumber numberWithInt:([powerupsDict[@"powerGlove"] intValue] + [notification[@"value"] intValue])];
                             parametersDict[@"powerGlove"] = [NSNumber numberWithInt:([notification[@"value"] intValue])];
                             //parametersDict[@"smore"] = [NSNumber numberWithInt:([powerupsDict[@"smore"] intValue] + 1)];
                         }
                         
//                         [[WebserviceManager sharedManager] requestAcceptGiftWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
//                                                                              deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
//                                                                            parameters:parametersDict
//                                                                     completionHandler:^
//                          (NSError *error, NSDictionary *acceptedGiftInfo)
//                          {
//                              if (!error && acceptedGiftInfo)
//                              {
//                                  DebugLog(@"%@", acceptedGiftInfo);
//                                  DebugLog(@"Removing notification");
//                                  
//                                  [[WebserviceManager sharedManager] requestToRemoveNotificationsWithAccountId:[SGAppDelegate appDelegate].accountDict[@"_id"]
//                                                                                               notificationIds:notificationIds
//                                                                                             completionHandler:^
//                                   (NSError *error, NSDictionary *notificationsInfoDict)
//                                   {
//                                       DebugLog(@"%@", notificationsInfoDict);
//                                   }];
//                              }
//                          }];
                     }
                 }
                 
             }
         }
     }];
}

- (IBAction)removeNotifications:(id)sender
{
//    NSMutableArray *notificationIds = [[NSMutableArray alloc] init];
//    // Retrieve notifications from account dictionary
////    NSDictionary *notificationDict = [[NSDictionary alloc] init];
////    notificationDict = [SGAppDelegate appDelegate].accountDict[@"notifications"];
////    DebugLog(@"NotificationDict: %@", notificationDict);
//    
//    [[WebserviceManager sharedManager] requestToShowNotificationsWithAccountId:[SGAppDelegate appDelegate].accountDict[@"_id"] completionHandler:^
//     (NSError *error, NSDictionary *notificationsInfoDict)
//     {
//         if (!error && notificationsInfoDict)
//         {
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 NSMutableArray *notificationsArray = [[NSMutableArray alloc] init];
//                 
//                 if (notificationsInfoDict[@"notifications"])
//                 {
//                     notificationsArray = [notificationsInfoDict[@"notifications"] mutableCopy];
//                     
//                     for (NSDictionary *notification in notificationsArray)
//                     {
//                         [notificationIds addObject:notification[@"_id"]];
//                     }
//                 }
//                 
//                 //-------------------
//                 // Notifications View
//                 //-------------------
////                 CDNotificationView *notificationView;
////                 notificationView = [[[NSBundle mainBundle] loadNibNamed:@"CDNotificationView" owner:self options:nil] objectAtIndex:0];
////                 notificationView.delegate = self;
////                 notificationView.frame = self.view.frame;
////                 notificationView.notificationsArray = [notificationsArray mutableCopy];
////                 [self.view addSubview:notificationView];
////                 [notificationView setupNotificationView];
//                 
//                 //    for (NSString *notification in notificationDict)
//                 //    {
//                 //        [notificationIds addObject:notification];
//                 //    }
//                 DebugLog(@"NotificationIdArray: %@", notificationIds);
//                 
//                 DebugLog(@"Removing notification");
//                 //    [[WebserviceManager sharedManager] requestToRemoveNotificationsWithAccountId:[SGAppDelegate appDelegate].accountDict[@"_id"]
//                 //                                                                 notificationIds:notificationIds[0]
//                 //                                                               completionHandler:^
//                 //     (NSError *error, NSDictionary *notificationsInfoDict)
//                 //     {
//                 //         if (!error && notificationsInfoDict)
//                 //         {
//                 //             DebugLog(@"%@", notificationsInfoDict);
//                 //             // Update account dictionary
//                 //         }
//                 //         else if (error)
//                 //         {
//                 //             DebugLog(@"%@", error.description);
//                 //         }
//                 //     }];
//             });
//         }
//     }];
    
    //-------------------
    // Notification View
    //-------------------    
    CDNotificationView *notificationView;
    notificationView = [[[NSBundle mainBundle] loadNibNamed:@"CDNotificationView" owner:self options:nil] objectAtIndex:0];
    notificationView.delegate = self;
    notificationView.frame = self.view.frame;
    if (self.notificationsArray)
    {
        notificationView.notificationsArray = [self.notificationsArray mutableCopy];
    }
    [self.view addSubview:notificationView];
}

- (void)requestNotifications
{
    [[WebserviceManager sharedManager] requestToShowNotificationsWithAccountId:[SGAppDelegate appDelegate].accountDict[@"_id"] completionHandler:^
     (NSError *error, NSDictionary *notificationsInfoDict)
     {
         if (!error && notificationsInfoDict)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (notificationsInfoDict[@"notifications"])
                 {
                     self.notificationsArray = [notificationsInfoDict[@"notifications"] mutableCopy];
                 }
            });
         }
         else if (error)
         {
             DebugLog(@"Request Notifications error: %@", error.description);
         }
         else
         {
             DebugLog(@"Could not request notifications");
             // Retrieve notifications from account dictionary (this only retrieves notification ids)
//             NSDictionary *notificationDict = [[NSDictionary alloc] init];
//             notificationDict = [SGAppDelegate appDelegate].accountDict[@"notifications"];
//             DebugLog(@"NotificationDict: %@", notificationDict);
         }
     }];

}

@end
