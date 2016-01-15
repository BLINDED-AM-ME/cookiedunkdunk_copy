//
//  CDIsometricMapViewController.m
//  CookieDD
//
//  Created by Josh on 6/17/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDIsometricMapViewController.h"
#include "CDStandardPopupView.h"
#include "CDLoadingScreenViewController.h"
#include "CDPickedLeveView.h"
#include "SGFileManager.h"
#import "CDAccountPopupView.h"

@interface CDIsometricMapViewController () <CDAccountPopupViewDelegate, CDStandardPopupViewDelegate, CDPickedLeveViewDelegate>

@property (strong, nonatomic) CDLoadingScreenViewController *loadingScreen;
//@property (strong, nonatomic) CDPickedLeveView *pickedLevelView;

@property (assign, nonatomic) int switchOrientation;
@property (strong, nonatomic) NSString *minigameOrientation;

@property (assign, nonatomic) BOOL loadMusic;
@property (strong, nonatomic) UIImageView *bubbleOverlay;

@end

@implementation CDIsometricMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)exitApp
{
    DebugLog(@"exiting app!");
    [[SGAudioManager audioManager] stopAllAudio];
}

- (void)enterApp
{
    DebugLog(@"entering app!");
    [[SGAudioManager audioManager] playAllAudio];
    
    [self.livesDisplayView checkForAccumulatedLives];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //DebugLog(@"IsometricMap - viewDidLoad");
    [self setup];
    
    // Do not load music until super view has finished unloading
    // otherwise music stops and then starts again
    _loadMusic = NO;
    
    // Setup the Lives Display.
    [self.livesDisplayView initialize];
    self.livesDisplayView.delegate = self;
    //    [self.livesDisplayView setNumLivesTo:[[CDPlayerObject player].lives intValue]];

    // HERE
    [self.livesDisplayView setHidden:YES];
//    [self.livesDisplayView hideDisplayAnimated:NO];
    //[self setupLivesDisplayCountdown];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitApp) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterApp) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.userInteractionEnabled = YES;
    
    // Get the list of levels for the selected planet.
//    NSPredicate *filterWorldsPredicate = [NSPredicate predicateWithFormat:@"type = %i", [self.planetID intValue]+1];
//    NSArray *filteredWorldsArray = [[SGAppDelegate appDelegate].accountDict[@"worlds"] filteredArrayUsingPredicate:filterWorldsPredicate];
//    if ([filteredWorldsArray count] > 0) {
//        self.levelProperties = filteredWorldsArray[0][@"levels"];
//    }
    
    [self loadPlayerInfo];
    [self updateLevelBubbles];
    [self updateMinigameBubble];
    
    //DebugLog(@"IsometricMap - viewWillAppear");
//    if (_loadMusic)
//    {
//        [self playIsometricMapMusic];
//        _loadMusic = NO;
//    }
    [self playIsometricMapMusic];
    _loadMusic = YES;
    
    [self removeLoadingScreen];
    
//    [self.livesDisplayView hideDisplayAnimated:NO];
    [self.livesDisplayView setupLives];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.transitionCoverView removeFromSuperview];
    
    // HERE
    [self.livesDisplayView setHidden:NO];

//    [self.livesDisplayView showDisplayAnimated:YES];
}

-(void)playIsometricMapMusic
{
    // Stop all previous playing sounds
    //[[SGAudioManager audioManager] stopAllAudio];
    
    //NSNumber *worldType = [NSNumber numberWithInt:[[SGGameManager gameManager].worldType intValue] + 1];
    
    // Choose which world we're on and load the appropriate background
    // music for that iso map
    
    if ([self.planetID intValue] == 0)          // MilkyWaie - Mountain
    {
        [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"MilkyWay2" FileType:@"m4a" volume:0.15f numberOfLoopes:-1];
    }
    else if ([self.planetID intValue] == 1)     // Dunkopolis
    {
        [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"Dunkopolis2" FileType:@"m4a" volume:0.3f numberOfLoopes:-1];
    }
    else if ([self.planetID intValue] == 2)     // Abduction Junction
    {
        [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"AmbienceFarmer" FileType:@"m4a" volume:0.4f numberOfLoopes:-1];
    }
    else if ([self.planetID intValue] == 3)     // Macaroon City
    {
        [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"Zombie" FileType:@"m4a" volume:4.0f numberOfLoopes:-1];
    }
//    else if ([self.planetID intValue] == 4)     // Western
//    {
//        
//    }
//    else if ([self.planetID intValue] == 5)     // Pirate
//    {
//        
//    }
//    else if ([self.planetID intValue] == 6)     // Egypt
//    {
//        
//    }
    else                                        // Play default Isometric map track
    {
        [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"CCDDD_THEME_MIX_Map" FileType:@"m4a" volume:0.15f numberOfLoopes:-1];
    }    
}

- (void)setup
{
    _switchOrientation = portraitOrientation;
    
    // Initialize friends arrays
    self.friendsArray = [[NSMutableArray alloc] init];
    self.friendIdArray = [[NSMutableArray alloc] init];
    // Fetch list of Facebook friends
    //[self fetchFriends];
    
    NSString *backgroundImageName = [NSString stringWithFormat:@"iso-%@", _planetName];
    [_backgroundImageView setImage:[UIImage imageNamed:backgroundImageName]];
    [_rootScrollView setContentSize:_backgroundImageView.frame.size];
    [_rootScrollView setShowsVerticalScrollIndicator:YES];
    CGPoint contentOffset = CGPointMake(0.0f, (_rootScrollView.contentSize.height - _rootScrollView.frame.size.height));
    [_rootScrollView setContentOffset:contentOffset];
    
#if DevModeActivated
        [self.nextLevelButtonLabel setFont:[UIFont fontWithName:@"DamnNoisyKids" size:self.nextLevelButtonLabel.font.pointSize]];
        [self.nextLevelButtonLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 5 : 3];
        self.nextLevelButton.hidden = NO;
        self.nextLevelButtonLabel.hidden = NO;
#else
        self.nextLevelButton.hidden = YES;
        self.nextLevelButtonLabel.hidden = YES;
#endif
    
    self.isProcessingNextLevel = NO;
    
    [self setupMainButton];
    
//    [self setupStore];
    
    // Overlay image for when bubble is pressed
    self.bubbleOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cdd-iso-leveldot-overlay"]];
    
    [self createMapBubbles];
    [self createMinigameBubble];
    
    // Fetch list of Facebook friends
    [self fetchFriends];
    
    //[self createGameController];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [super viewDidDisappear:animated];
//    
//    int rootViews = 0;
//    for (UIView *view in self.rootScrollView.subviews)
//    {
//        rootViews++;
//        [view removeFromSuperview];
//    }
//    DebugLog(@"RootViews: %u", rootViews);
//    
//    int viewCount = 0;
//    for (UIView *view in self.view.subviews)
//    {
//        viewCount++;
//        
//        [view removeFromSuperview];
//    }
//    DebugLog(@"IsometricViews: %u", viewCount);
}

- (void)didReceiveMemoryWarning
{
    DebugLog(@"IsometricMapView Received Memory Warning!");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)createGameController {
//    self.cddViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CDCookieDunkDunKViewController"];
//    self.cddViewController.delegate = self;
//}

- (void)setupMainButton {
    self.mainButtonVC = [[CDMainButtonViewController mainButton] didCreateMainButtonViewWithParentalViewController:self];
    _mainButtonVC.delegate = self;
    
    if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        _mainButtonVC.parentViewFrame = self.view.frame;
        _mainButtonVC.conditionalViewFrame = self.view.frame;
    }
    else
    {
        _mainButtonVC.parentViewFrame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        _mainButtonVC.conditionalViewFrame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }
}

//- (void)setupStore {
//    self.storeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CDStoreViewController"];
//}


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

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    if (_switchOrientation == portraitOrientation)
//    {
//        return UIInterfaceOrientationPortrait;
//    }
//    else if (_switchOrientation == landscapeOrientation)
//    {
//        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
//        {
//            return UIInterfaceOrientationLandscapeRight;
//        }
//        return UIInterfaceOrientationLandscapeLeft;
//    }
//    else if (_switchOrientation == allButUpsideDownOrientation)
//    {
//        if ([_minigameOrientation isEqualToString:@"portrait"])
//        {
//            return UIInterfaceOrientationPortrait;
//        }
//        else if ([_minigameOrientation isEqualToString:@"landscape"])
//        {
//            if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
//            {
//                return UIInterfaceOrientationLandscapeRight;
//            }
//            return UIInterfaceOrientationLandscapeLeft;
//        }
//        else
//        {
//            return UIInterfaceOrientationPortrait;
//        }
//    }
//    else
//    {
//        return 0;
//    }
//}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - Scoll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //return self.rootScrollView;
    return self.backgroundImageView;
}

#pragma mark - Level Bubbles

- (void)createMapBubbles {
    NSMutableArray *tempArray = [NSMutableArray new];
    for (int index = 0; index < numLevelsPerPlanet; index++) {
        
        // Grab the position of this bubble.
        CGPoint position = CGPointZero;
        if (index < [_bubbleCoords count]) {
            position = CGPointFromString(_bubbleCoords[index]);
        }
        
        // Create the bubble instance.
        CDMapBubble *newBubble = [[CDMapBubble alloc] initWithImageNamed:@"cdd-iso-leveldot-emptydot00" AndPosition:position];
        newBubble.tag = index;
        
        
        // Set the properties, based on player info.
        // (Extras will use the default values.)
        if (index < [_levelProperties count]) {
            NSDictionary *levelDict = _levelProperties[index];
            newBubble.highScore = [levelDict[@"highScore"] intValue];
            newBubble.starCount = [levelDict[@"starCount"] intValue];
            newBubble.isUnlocked = YES;
        }

        [self setColorForBubble:newBubble];
        
        // Set the scale, if available.
        if (index < [_bubbleScales count]) {
            newBubble.scale = [_bubbleScales[index] floatValue];
        }
        
        // Set friend image orientation
        if (index < [self.friendImageOrientations count])
        {
            newBubble.friendImageOrientation = self.friendImageOrientations[index];
        }
        
        // Add level number label to map bubble.
        newBubble.levelNumber = index + 1;
        
        // Add the overlay for when the bubble is pressed.
        newBubble.overlayImage = self.bubbleOverlay;
        
        // Finish up.
        newBubble.delegate = self;
        [tempArray addObject:newBubble];
        [self.rootScrollView addSubview:newBubble];
        
        // Fetch list of Facebook friends
        //[self fetchFriends:newBubble levelNumber:index + 1];
    }
    
    self.levelBubblesArray = [[NSArray alloc] initWithArray:tempArray];
}

- (void)updateLevelBubbles {
    for (CDMapBubble *bubble in _levelBubblesArray) {
        [self setLockStateForBubble:bubble];
        [self setStarCountForBubble:bubble];
        [self setHighScoreForBubble:bubble];
    }
}

- (void)setLockStateForBubble:(CDMapBubble *)bubble {
    if (bubble.levelNumber <= [_levelProperties count]) {
    //DebugLog(@"Updating lock state for bubble %i.", bubble.tag + 1);
        bubble.isUnlocked = YES;
    }
    else {
        bubble.isUnlocked = NO;
    }
    
    [self setColorForBubble:bubble];
}

- (void)setStarCountForBubble:(CDMapBubble *)bubble {
    if (bubble.tag < [self.levelProperties count]) {
        //DebugLog(@"Updating star count for bubble %i.", bubble.tag + 1);
        NSDictionary *levelDict = self.levelProperties[bubble.tag];
        int starCount = [levelDict[@"starCount"] intValue];
        bubble.starCount = starCount;
    }
}

- (void)setHighScoreForBubble:(CDMapBubble *)bubble {
    if (bubble.tag < [self.levelProperties count]) {
        //DebugLog(@"Updating high score for bubble %i.", bubble.tag + 1);
        NSDictionary *levelDict = self.levelProperties[bubble.tag];
        int highScore = [levelDict[@"highScore"] intValue];
        bubble.highScore = highScore;
    }
}

- (void)setColorForBubble:(CDMapBubble *)bubble {
    if (bubble.isUnlocked) {
        int levelNumber = ([_planetID intValue] * 30) + (int)bubble.levelNumber;
        
        NSString *levelName = [NSString stringWithFormat:@"cdd_level_%03d", levelNumber];
        
        NSDictionary *levelDict = [[SGFileManager fileManager] loadDictionaryWithFileName:levelName OfType:@"plist"];
        if (levelDict) {
            NSString *limiterType = levelDict[@"limiterType"];
            if ([limiterType isEqualToString:@"TIME_LIMIT"]) {
                // Timed level.
                [bubble setLevelType:LevelType_Timed];
            }
            else {
                NSString *primaryGoalType = levelDict[@"goalType"];
                NSString *secondaryGoalType = levelDict[@"secondarygoalType"];
                if ([primaryGoalType isEqualToString:@"CLEAR_TYPE"]) {
                    NSString *primaryGoalItem = levelDict[@"goalItems"][0];
                    NSRange range = [primaryGoalItem rangeOfString:@"INGREDIENT" options:NSCaseInsensitiveSearch];
                    if (range.location != NSNotFound) {
                        // Ingredient Level.
                        [bubble setLevelType:LevelType_Ingredients];
                    }
                    else {
                        [bubble setLevelType:LevelType_ClearObjects];
                    }
                }
                else if ([secondaryGoalType isEqualToString:@"CLEAR_TYPE"]) {
                    NSString *secondaryGoalItem = levelDict[@"secondarygoalItems"][0];
                    NSRange range = [secondaryGoalItem rangeOfString:@"INGREDIENT" options:NSCaseInsensitiveSearch];
                    if (range.location != NSNotFound) {
                        // Ingredient Level.
                        [bubble setLevelType:LevelType_Ingredients];
                    }
                    else {
                        [bubble setLevelType:LevelType_ClearObjects];
                    }
                }
                else {
                    [bubble setLevelType:LevelType_Score];
                }
            }
        }
        bubble.starCount = [[self.levelProperties[bubble.tag] objectForKey:@"starCount"] intValue];
    }
}

#pragma mark - Minigame Bubble

- (void)createMinigameBubble
{
    CGPoint position = CGPointFromString([_bubbleCoords lastObject]);
    
    CDMapBubble *minigameBubble = [[CDMapBubble alloc] initWithImageNamed:@"cdd-iso-leveldot-emptydot01" AndPosition:position];
    minigameBubble.delegate = self;
    [minigameBubble setLevelType:LevelType_Minigame];
    [minigameBubble setScale:[[_bubbleScales lastObject] floatValue]];
    
    minigameBubble.overlayImage = self.bubbleOverlay;
    
    self.minigameBubble = minigameBubble;
    [self.rootScrollView addSubview:minigameBubble];
}

- (void)updateMinigameBubble {
    if ([_levelProperties count] > [_minigameStartPoint intValue]) {
        _minigameBubble.isUnlocked = YES;
        _minigameBubble.levelType = LevelType_Minigame;
        _minigameBubble.backgroundImageView.image = [UIImage imageNamed:@"cdd-iso-leveldot-emptydot01"];
    }
    else {
        _minigameBubble.isUnlocked = NO;
        _minigameBubble.levelType = LevelType_Minigame;
        _minigameBubble.backgroundImageView.image = [UIImage imageNamed:@"cdd-iso-leveldot-emptydot01locked"];
    }
}

#pragma mark - Navigation
- (void)mapBubbleDidTrigger:(CDMapBubble *)mapBubble
{
    if (mapBubble == _minigameBubble)
    {
        DebugLog(@"Open minigame.");
        if (_minigameBubble.isUnlocked)
        {
            self.view.userInteractionEnabled = NO;
            _mainButtonVC.view.clipsToBounds = YES;
            [self loadingScreenHandler];
            
            __weak typeof(self) weakSelf = self;
            double delayInSeconds = .5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
            {
                if ([weakSelf.delegate respondsToSelector:@selector(isometricMap:didSelectMinigameForPlanetWithID:)])
                {
                    [weakSelf.delegate isometricMap:weakSelf didSelectMinigameForPlanetWithID:weakSelf.planetID];
                    [weakSelf removeLoadingScreen];
                    
                    if (!weakSelf.mainButtonVC.mainButtonIsDown)
                    {
                        [weakSelf.mainButtonVC mainButtonHit:weakSelf.mainButtonVC.mainButton];
                    }
                }
            });
        }
    }
    else
    {
        DebugLog(@"Open level %i", (int)mapBubble.levelNumber);

        if (mapBubble.isUnlocked)
        {
            CDPickedLeveView *pickedLevelView;
            pickedLevelView = [[[NSBundle mainBundle] loadNibNamed:@"CDPickedLevelView" owner:self options:nil] objectAtIndex:0];
            
            pickedLevelView.delegate = self;
            pickedLevelView.frame = self.view.frame;
            pickedLevelView.friendIdArray = [self.friendIdArray mutableCopy];
            //[self.view insertSubview:pickedLevelView belowSubview:_mainButtonVC.view];
            [self.view addSubview:pickedLevelView];
            [pickedLevelView setupWithParentalViewController:self WithMapBubble:mapBubble WithPlanetID:_planetID];
        }
        
//        DebugLog(@"Open level %i", (int)mapBubble.tag);
//        if (mapBubble.isUnlocked)
//        {
//            self.view.userInteractionEnabled = NO;
//            _mainButtonVC.view.clipsToBounds = YES;
//            [self loadingScreenHandler];
//            
//            __weak typeof(self) weakSelf = self;
//            double delayInSeconds = .5;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//            {
//                [weakSelf presentViewController:weakSelf.cddViewController animated:NO completion:^{
//                    [weakSelf.cddViewController createLevelWithID:[NSNumber numberWithInteger:mapBubble.tag] ForPlanet:weakSelf.planetID];
//                    [weakSelf removeLoadingScreen];
//                    
//                    if (!weakSelf.mainButtonVC.mainButtonIsDown)
//                    {
//                        [weakSelf.mainButtonVC mainButtonHit:weakSelf.mainButtonVC.mainButton];
//                    }
//                }];
//            });
//        }
        
        
    }
}

- (void)dismissMapAnimated:(BOOL)shouldAnimate ToTheStore:(BOOL)toTheStore {
    //self.cddViewController = nil;
    self.livesDisplayView = nil;
    self.mainButtonVC = nil;
    self.loadingScreen = nil;
    
    if ([self.delegate respondsToSelector:@selector(isometricMapWillExit:WithAnimation:ToStore:)])
    {
        [self.delegate isometricMapWillExit:self WithAnimation:shouldAnimate ToStore:toTheStore];
    }
    
//    self.delegate = nil;
//
//    [self dismissViewControllerAnimated:shouldAnimate completion:^{
//        [self dismissViewControllerAnimated:shouldAnimate completion:^{
//            
//        }];
//    }];
}

- (void)removeLoadingScreen
{
    [[self.view viewWithTag:0] removeFromSuperview];
    [_loadingScreen.view removeFromSuperview];
    _loadingScreen = nil;
}

- (void)createLoadingScreenWithImageNamed:(NSString *)imageName
{
    _loadingScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CDLoadingScreenViewController"];
    _loadingScreen.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _loadingScreen.view.tag = 0;
    [_loadingScreen createLoadingScreenWithImageName:imageName];
    
    [self.view insertSubview:_loadingScreen.view aboveSubview:_mainButtonVC.view];
}

- (void)loadingScreenHandler
{
    [[SGAudioManager audioManager] stopAllAudio];

    NSString *bgImageString = [NSString stringWithFormat:@"Default%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
    [self createLoadingScreenWithImageNamed:bgImageString];
}

#pragma mark - Main Game Delegate
- (void)shopButtonWasHitInMainGameViewController
{
    [self presentStore];
}

- (void)goingBackToPlanetsFromMainGameViewController
{
    [self dismissMapAnimated:NO ToTheStore:NO];
}

- (void)cookieDunkDunkViewControllerWillGoBackToMap:(CDCookieDunkDunKViewController *)cookieDunkDunkViewController withVideoName:(NSString *)videoName
{
    [cookieDunkDunkViewController dismissViewControllerAnimated:NO completion:^{
        if ([self.delegate respondsToSelector:@selector(isometricMapWillExit:withVideoName:)])
        {
            [self.delegate isometricMapWillExit:self withVideoName:videoName];
        }
    }];
}

- (void)dismissingCookieDunkDunkViewController:(CDCookieDunkDunKViewController *)cookieDunkDunkViewController
{
    [cookieDunkDunkViewController dismissViewControllerAnimated:NO completion:^{
        [self dismissMapAnimated:NO ToTheStore:NO];
    }];
}

#pragma mark - Main Button Delegate

- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction
{
    
}

- (void)mainButtonSubButtonWasHitWithIndex:(int)buttonIndex
{
    switch (buttonIndex)
    {
        case backButtonIndex:
            DebugLog(@"Main Button - back");
            self.mainButtonVC.faderView.frame = self.view.frame;
            [self dismissMapAnimated:YES ToTheStore:NO];
            _loadMusic = YES;
            [self.mainButtonVC removeFromParentViewController];
            break;
            
        case helpButtonIndex:
            DebugLog(@"Main Button - help");
            [self presentHelp];
            break;
            
        case volumeButtonIndex:
            DebugLog(@"Main Button - volume");
            break;
            
        case shopButtonIndex:
            DebugLog(@"Main Button - shop");
            [self presentStore];
            break;
            
        case accountButtonIndex:
            DebugLog(@"Main Button - account");
            [self presentAccount];
            break;
            
        case settingsButtonIndex:
            DebugLog(@"Main Button - settings");
            break;
            
        case facebookButtonIndex:
            DebugLog(@"Main Button - facebook");
            break;
            
        case twitterButtonIndex:
            DebugLog(@"Main Button - twitter");
            break;
            
        case googleButtonIndex:
            DebugLog(@"Main Button - google");
            break;
            
        default:
            break;
    }
}

- (void)presentHelp
{
    CDStandardPopupView *popup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
    
    popup.delegate = self;
    popup.whatAmILoading = @"mainGameHelp";
    
    popup.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view insertSubview:popup aboveSubview:_mainButtonVC.view];
    [popup setup];
    
    _mainButtonVC.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

- (void)presentAccount
{
    if ([SGAppDelegate appDelegate].accountDict)
    {
        CDAccountPopupView *popup;
        popup = [[[NSBundle mainBundle] loadNibNamed:@"CDAccountPopupIphone5View" owner:self options:nil] objectAtIndex:0];
        
        popup.delegate = self;
        popup.frame = self.view.frame;
        [_mainButtonVC.view addSubview:popup];
        [popup setupWithParentalViewController:_mainButtonVC];
        
        _mainButtonVC.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.view.frame errorDescription:@"You are not currently logged in. Please Login to view your account." loadingText:nil];
        
        _mainButtonVC.popupIsUp = NO;
        [_mainButtonVC enableButtons:YES];
    }
}

- (void)presentStore
{
    [self dismissMapAnimated:NO ToTheStore:YES];
//    if ([self.delegate respondsToSelector:@selector(shopWasSelectedInTheIsoMap)])
//    {
//        [self.delegate shopWasSelectedInTheIsoMap];
//    }
}


#pragma mark - Account View Delegate
- (void)exitButtonWasHitOnAccountPopup:(CDAccountPopupView *)accountView
{
    [accountView removeFromSuperview];
    _mainButtonVC.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _mainButtonVC.popupIsUp = NO;
    //    _accountIsOpen = NO;
    
    [_mainButtonVC enableButtons:YES];
}

#pragma mark - Help View Delegates
- (void)exitButtonWasHitOnStandardPopupView:(CDStandardPopupView *)standardPopup
{
    [standardPopup removeFromSuperview];
    _mainButtonVC.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _mainButtonVC.popupIsUp = NO;
    //    _helpIsOpen = NO;
    
    [_mainButtonVC enableButtons:YES];
}


#pragma mark - Lives Display Delegate

- (void)livesDisplayView:(CDLivesDisplayView *)livesDisplayView DidReachLifeUnlockDate:(NSDate *)lifeUnlockDate {
    // Woo Hoo!
}

#pragma mark - Picked Level View Controller
- (void)exitButtonWasHitOnPickedLevelView:(CDPickedLeveView *)pickedLevelView
{
    [pickedLevelView removeFromSuperview];
    pickedLevelView = nil;
}

- (void)playButtonWasHitOnPickedLevelView:(CDPickedLeveView *)pickedLevelView withMapBubble:(CDMapBubble *)mapBubble WithPlanetID:(NSNumber *)planetType
{
    if (_livesDisplayView.numLives > 0) {
        self.view.userInteractionEnabled = NO;
        _mainButtonVC.view.clipsToBounds = YES;
        
        [pickedLevelView removeFromSuperview];
        [self loadingScreenHandler];
        
        __weak typeof(self) weakSelf = self;
        double delayInSeconds = .5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           CDCookieDunkDunKViewController *cddViewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"CDCookieDunkDunKViewController"];
                           cddViewController.delegate = weakSelf;
                           
                           [weakSelf presentViewController:cddViewController animated:NO completion:^{
                               
                               [cddViewController createLevelWithID:[NSNumber numberWithInteger:mapBubble.levelNumber] ForPlanet:weakSelf.planetID];

                               [weakSelf removeLoadingScreen];
                               
                               if (!weakSelf.mainButtonVC.mainButtonIsDown)
                               {
                                   [weakSelf.mainButtonVC mainButtonHit:weakSelf.mainButtonVC.mainButton];
                               }
                           }];
                           
                           /*
                           [weakSelf presentViewController:weakSelf.cddViewController animated:NO completion:^{
                               [weakSelf.cddViewController createLevelWithID:[NSNumber numberWithInteger:mapBubble.tag] ForPlanet:weakSelf.planetID];
                               [weakSelf removeLoadingScreen];
                               
                               if (!weakSelf.mainButtonVC.mainButtonIsDown)
                               {
                                   [weakSelf.mainButtonVC mainButtonHit:weakSelf.mainButtonVC.mainButton];
                               }
                               
                               [pickedLevelView removeFromSuperview];
                           }];
                            */
                       });
    }
    else {
        DebugLog(@"Warning: No lives available.");
    }
}

#pragma mark - Facebook

- (void)fetchFriends
{
    [[SGSocialManager socialManager] requestFacebookFriendsWithQueryType:FacebookTypeQueryFriendsHaveApp
                                                       CompletionHandler:^
     (FBRequestConnection *connection, NSArray *friendArray, NSError *error)
     {
         if (!error && friendArray)
         {
             // DebugLog(@"friends have app! %@", friendArray);
             
             for (NSDictionary *friendDict in friendArray)
             {
                 if (friendDict[@"uid"])
                 {
                     NSString *facebookUID = [friendDict[@"uid"] stringValue];
                     [self.friendIdArray addObject:facebookUID];
                 }
             }
             
             // Request friends CDD account info from CDD server
             [[WebserviceManager sharedManager] requestFriends:self.friendIdArray completionHandler:^
              (NSError *error, NSDictionary *friends)
              {
                  if (!error && friends)
                  {
                      if (friends[@"accounts"])
                      {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              self.friendsArray = [friends[@"accounts"] mutableCopy];
                              for (CDMapBubble *mapBubble in _levelBubblesArray)
                              {
                                  [self showFriends:mapBubble levelNumber:mapBubble.levelNumber];
                              }
                          });
                      }
                  }
              }];
         }
     }];
}

- (void)fetchFriends:(CDMapBubble *)mapBubble levelNumber:(int)levelNumber
{
    [[SGSocialManager socialManager] requestFacebookFriendsWithQueryType:FacebookTypeQueryFriendsHaveApp
                                                       CompletionHandler:^
     (FBRequestConnection *connection, NSArray *friendArray, NSError *error)
     {
         if (!error && friendArray)
         {
             // DebugLog(@"friends have app! %@", friendArray);
             
             //NSMutableArray *friendIdArray = [NSMutableArray new];
             for (NSDictionary *friendDict in friendArray)
             {
                 if (friendDict[@"uid"])
                 {
                     NSString *facebookUID = [friendDict[@"uid"] stringValue];
                     [self.friendIdArray addObject:facebookUID];
                 }
             }
             
             // Request friends CDD account info from CDD server
             [[WebserviceManager sharedManager] requestFriends:self.friendIdArray completionHandler:^
              (NSError *error, NSDictionary *friends)
              {
                  if (!error && friends)
                  {
                      if (friends[@"accounts"])
                      {
                          if (!self.friendsArray)
                          {
                              self.friendsArray = [friends[@"accounts"] mutableCopy];
                          }
                        
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self showFriends:mapBubble levelNumber:levelNumber];
                          });
                      }
                  }
              }];
         }
     }];
}

- (void)showFriends:(CDMapBubble *)mapBubble levelNumber:(int)levelNumber
{
    // Create a temporary array to hold all friends that are on the current level
    NSMutableArray *currentLevelFriendsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *friend in self.friendsArray)
    {
        NSDictionary *friendInfoDict = friend;
        if ([friendInfoDict[@"currentGameProgress"][@"worldType"] intValue] == [self.planetID intValue] + 1)
        {
            //[currentWorldFriendsArray addObject:[friend mutableCopy]];
            if ( [friendInfoDict[@"currentGameProgress"][@"levelType"] intValue] == levelNumber)
            {
                // Add friend by level
                [currentLevelFriendsArray addObject:[friend mutableCopy]];
            }
        }
        // Add all friends to current friends array
        //[currentLevelFriendsArray addObject:[friend mutableCopy]];
        
        //----------------------------------------
        // Limit number of friends to be displayed per level
        //----------------------------------------
        if ([currentLevelFriendsArray count] >= 4)
        {
            break;
        }
    }

    // Grab a random friend from those currently playing on this planet to be displayed
    if ([currentLevelFriendsArray count] > 0)
    {
        //int randomIndex = arc4random() % [currentLevelFriendsArray count];
        
        // Position friend image container to the right of the map bubble if
        // specified otherwise postition on the left side
        CGRect location;
        if ( [mapBubble.friendImageOrientation  isEqual: @"r"] )
        {
            location = CGRectMake(mapBubble.frame.origin.x + mapBubble.frame.size.width - 14, mapBubble.frame.origin.y - (mapBubble.frame.size.height / 2) - 2, 24, 24);
        }
        else
        {
            location = CGRectMake(mapBubble.frame.origin.x - 10, mapBubble.frame.origin.y - (mapBubble.frame.size.height / 2) - 2, 24, 24);
        }
        
        //DebugLog(@"location: x = %f y = %f width = %f height = %f", location.origin.x, location.origin.y, location.size.width, location.size.height);
        //DebugLog(@"mapBubble: x = %f y = %f width = %f height = %f", mapBubble.frame.origin.x, mapBubble.frame.origin.y, mapBubble.frame.size.width, mapBubble.frame.size.height);
        
        CDFriendContainer *friendContainer = [[CDFriendContainer alloc] initWithFrame:location];
        //[friendContainer.layer setBackgroundColor:[[UIColor blueColor] CGColor]];
        [self.rootScrollView addSubview:friendContainer];
        friendContainer.delegate = self;
        friendContainer.scale = mapBubble.scale;
        
        // Set direction to open image animation depending on which side
        // of the screen the map bubble is located
        if (mapBubble.frame.origin.x <= self.view.frame.size.width / 2)
        {
            friendContainer.openRight = YES;
        }
        else
        {
            friendContainer.openRight = NO;
        }

        // Size of final image in front
        float imageSize = 20.0f;
        
        // Start with the last image to be drawn first so it is at the back
        __block float offSet = 0.5f * [currentLevelFriendsArray count];
        
        //for (NSDictionary *currentFriend in [currentLevelFriendsArray reverseObjectEnumerator])
        for (NSDictionary *currentFriend in currentLevelFriendsArray)
        {
            //        if (randomIndex == _currentFriendIndex && [currentLevelFriendsArray count] > 1)
            //        {
            //            if ((randomIndex+1) < ([currentWorldFriendsArray count]-1))
            //            {
            //                randomIndex += 1;
            //            }
            //            else if(randomIndex > 0)
            //            {
            //                randomIndex -= 1;
            //            }
            //        }
            //    // Get random friend from friends list
            //    if ([self.friendsArray count] > 0)
            //    {
            //        int randomIndex = arc4random() % [self.friendsArray count];
            //
            //        if (randomIndex == _currentFriendIndex && [self.friendsArray count] > 1)
            //        {
            //            if ((randomIndex+1) < ([self.friendsArray count]-1))
            //            {
            //                randomIndex += 1;
            //            }
            //            else if(randomIndex > 0)
            //            {
            //                randomIndex -= 1;
            //            }
            //        }
            
            //        if (_currentFriendImage) [_currentFriendImage removeFromSuperview];
            //        if (_currentFriendNameLabel) [_currentFriendNameLabel removeFromSuperview];
            //        if (_currentFriendStatsLabel) [_currentFriendStatsLabel removeFromSuperview];
            
            //_currentFriendIndex = randomIndex;
            
            //NSDictionary *friendInfoDict = currentLevelFriendsArray[randomIndex];
            
            NSDictionary *friendInfoDict = currentFriend;
            
            if ([friendInfoDict isKindOfClass:[NSDictionary class]])
            {
                if (friendInfoDict[@"profileAvatar"])
                {
                    NSString *stringURL = friendInfoDict[@"profileAvatar"];
                    NSRange range = [stringURL rangeOfString:@"?" options:NSBackwardsSearch];
                    NSString *modifiedStringURL = [stringURL substringToIndex:range.location];
                    NSString *pictureSize = [NSString stringWithFormat:@"?width=120&height=120"];
                    modifiedStringURL = [modifiedStringURL stringByAppendingString:pictureSize];
                    NSURL *url = [NSURL URLWithString:modifiedStringURL];
                    
                    [[WebserviceManager sharedManager] requestImageAtURL:url completionHandler:^
                     (NSError *error, NSIndexPath *indexPath, UIImage *image)
                     {
                         if (!error && image)
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 // Display friend image
                                 UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                 UIImage *croppedImage = [[WebserviceManager sharedManager] cropPhoto:imageView withMaskedImage:[UIImage imageNamed:@"Profile-88x88"]];
                                 imageView.image = croppedImage;
                                 [imageView setContentMode:UIViewContentModeScaleAspectFit];
                                 //[imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                                 //[imageView.layer setBorderWidth:1.0f];
                                 //[self.view addSubview:imageView];
                                 
                                 CGFloat scaleImageSize = imageSize * mapBubble.scale;
                                 CGRect newFrame = imageView.frame;
                                 newFrame.size = CGSizeMake(scaleImageSize, scaleImageSize);
                                 //newFrame.origin.x = newFrame.origin.x - imageSize / 4 + offSet;
                                 //newFrame.origin.y = newFrame.origin.y - (imageSize / 2) - offSet * 3;
                                 newFrame.origin.x = newFrame.origin.x + offSet + 3;
                                 newFrame.origin.y = newFrame.origin.y - offSet * 3 + 6;
                                 imageView.frame = newFrame;
                                 
                                 UIImageView *borderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cdd-hud-ico-playerphoto"]];
                                 //[borderImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                                 //[borderImageView.layer setBorderWidth:1.0f];
                                 // Position cookie hud image over friend image
                                 CGFloat ratio = scaleImageSize / 120;
                                 CGFloat borderSize =  166 * ratio;
                                 CGFloat borderOffSet = borderSize * 0.1385;
                                 newFrame.size = CGSizeMake(borderSize, borderSize);
                                 newFrame.origin.x = newFrame.origin.x - borderOffSet;
                                 newFrame.origin.y = newFrame.origin.y - borderOffSet;
                                 borderImageView.frame = newFrame;

                                 mapBubble.friendImageView = imageView;

                                 // Create container view to hold friend image with border
                                 UIView *friendPic = [[UIView alloc] initWithFrame:CGRectMake(0, 0, borderSize, borderSize)];
                                 //[friendPic.layer setBackgroundColor:[[UIColor yellowColor] CGColor]];
                                 
                                 [friendPic addSubview:imageView];
                                 [friendPic addSubview:borderImageView];
                                 [friendContainer addSubview:friendPic];
                                 [friendContainer.friendImages addObject:friendPic];
                                 
                                 offSet = offSet - 0.5f;
                             }); // dispatch_async
                         }
                     }]; // Webservice completion handler
                }
            }
        } // For in currentFriend
    }
    else
    {
        DebugLog(@"No friends found on level: %i", levelNumber);
    }
}

- (void)updateFriends
{
    [self fetchFriends];
}

#pragma mark - Friend Container Delegate

- (void)friendContainerDidTrigger:(CDFriendContainer *)friendContainer
{
    DebugLog(@"friendContainer triggered");
    [friendContainer animateOut:friendContainer];
}


#pragma mark - Cheats

- (IBAction)unlockNextLevel:(id)sender {
    if (!_isProcessingNextLevel) {
        DebugLog(@"Unlock!");
        self.isProcessingNextLevel = YES;
        
        NSString *email = [[SGAppDelegate appDelegate] fetchPlayerEmail];
        NSString *deviceID = [[SGAppDelegate appDelegate] fetchPlayerDeviceID];
        
        NSNumber *nextLevelType;
        NSNumber *nextworldType;
        if ([_levelProperties count] < numLevelsPerPlanet) {
            // Unlock the next level of the current world.
            nextLevelType = [NSNumber numberWithInt:[[_levelProperties lastObject][@"type"] intValue] + 1];
            nextworldType = [NSNumber numberWithInt:[_planetID intValue] + 1];
            
            NSString *worldName = [[SGFileManager fileManager] stringFromIndex:([nextworldType intValue]) inFile:@"planetoids-master-list"];
            
            [[WebserviceManager sharedManager] updateLevelParametersWithEmail:email
                                                                     deviceId:deviceID
                                                                    worldType:nextworldType
                                                                    worldName:worldName
                                                                    levelType:nextLevelType
                                                                    starCount:[NSNumber numberWithInt:0]
                                                                    highScore:[NSNumber numberWithInt:0]
                                                            completionHandler:^(NSError *error, NSDictionary *returnDict) {
                                                                if (error) {
                                                                    DebugLog(@"Error updating level: %@", error.localizedDescription);
                                                                    self.isProcessingNextLevel = NO;
                                                                    return;
                                                                }
                                                                
                                                                if (returnDict[@"error"]) {
                                                                    DebugLog(@"Server Error updating level: %@", returnDict[@"error"]);
                                                                    self.isProcessingNextLevel = NO;
                                                                    return;
                                                                }
                                                                
                                                                DebugLog(@"Unlocked level %@ - %@", nextworldType, nextLevelType);
                                                                
                                                                [self loadPlayerInfo];
                                                                
                                                                // Force this on the main thread for visual updating.
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [self updateLevelBubbles];
                                                                    [self updateMinigameBubble];
                                                                    self.isProcessingNextLevel = NO;
                                                                });
                                                            }];
        }
        else if ([_planetID intValue]+1 < numUnlockablePlanets) {
            // If the next world is already unlocked, stop right here.
            for (NSDictionary *worldDict in [SGAppDelegate appDelegate].accountDict[@"worlds"]) {
                DebugLog(@"Checking world %@", worldDict[@"type"]);
                if ([worldDict[@"type"] isEqualToNumber:[NSNumber numberWithInt:[_planetID intValue] + 2]]) { // Yes, +2 is the next world.
                    DebugLog(@"Warning: That world is already unlocked.");
                    self.isProcessingNextLevel = NO;
                    return;
                }
            }
            
            nextworldType = [NSNumber numberWithInt:[_planetID intValue] + 2]; // Yes, +2 is the next world.
            
            NSString *worldName = [[SGFileManager fileManager] stringFromIndex:([nextworldType intValue] - 1) inFile:@"planetoids-master-list"];
            
            [[WebserviceManager sharedManager] updateWorldParametersWithEmail:email
                                                                     deviceId:deviceID
                                                                    worldType:nextworldType
                                                                    worldName:worldName
                                                            completionHandler:^(NSError *error, NSDictionary *returnDict) {
                                                                
                                                                self.isProcessingNextLevel = NO;
                                                                
                                                                if (error) {
                                                                    DebugLog(@"Error unlocking planet %@: %@", worldName, error.localizedDescription);
                                                                    return;
                                                                }
                                                                
                                                                if (returnDict[@"error"]) {
                                                                    DebugLog(@"Error unlocking planet %@: %@", worldName, returnDict[@"error"]);
                                                                    return;
                                                                }
                                                            }];
            
            
            // Unlock the free costume.
            [self checkAndUnlockFreeCostumeForWorld:[[SGFileManager fileManager] stringFromIndex:([nextworldType intValue] - 1) inFile:@"planetoids-master-list"]];
            // End unlock.
        }
        else {
            DebugLog(@"There are no more levels or planets to unlock.");
            self.isProcessingNextLevel = NO;
        }
    }
    else {
        DebugLog(@"Hold On: The next level is still processing.");
    }
}

- (void)checkAndUnlockFreeCostumeForWorld:(NSString *)worldName {
    NSString *email = [[SGAppDelegate appDelegate] fetchPlayerEmail];
    NSString *deviceID = [[SGAppDelegate appDelegate] fetchPlayerDeviceID];
    
    NSDictionary *worldDict = [[SGFileManager fileManager] loadDictionaryWithFileName:worldName OfType:@"plist"];
    if (worldDict[@"freeCostume"]) {
        NSDictionary *freeCostumeDict = worldDict[@"freeCostume"];
        //BOOL shouldBother = YES;
        
        
        NSDictionary *accountDict = [SGAppDelegate appDelegate].accountDict;
        NSArray *cookieCostumesArray = [accountDict objectForKey:@"cookieCostumes"];
        for (NSDictionary *dict in cookieCostumesArray) {
            // Check name and theme.
            if ([dict[@"name"] isEqualToString:freeCostumeDict[@"keyName"]] &&
                [dict[@"theme"] isEqualToString:freeCostumeDict[@"keyTheme"]]) {
                //DebugLog(@"Found %@ costume for %@", freeCostumeDict[@"keyTheme"], freeCostumeDict[@"keyName"]);
                if (![dict[@"isUnlocked"] boolValue]) {
                    DebugLog(@"Now unlocking the %@ costume for %@.", dict[@"theme"], dict[@"name"]);
                    NSMutableDictionary *tempDict = [dict mutableCopy];
                    [tempDict setValue:[NSNumber numberWithBool:YES] forKey:@"isUnlocked"];
                    //[tempCookieCostumesArray addObject:tempDict];
                    NSMutableArray *freeCostumeArray = [NSMutableArray arrayWithArray:@[tempDict]];
                    [[WebserviceManager sharedManager] requestToUpdateCookieCostumesWithEmail:email
                                                                                     deviceId:deviceID
                                                                               cookieCostumes:freeCostumeArray
                                                                            completionHandler:^(NSError *error, NSDictionary *returnDict) {
                                                                                if (error) {
                                                                                    DebugLog(@"Error updating cookie costumes: %@", error.localizedDescription);
                                                                                    return;
                                                                                }
                                                                                if (returnDict) {
                                                                                    if (returnDict[@"account"]) {
                                                                                        if (returnDict[@"account"][@"cookieCostumes"]) {
                                                                                            [[SGAppDelegate appDelegate].accountDict setObject:returnDict[@"account"][@"cookieCostumes"] forKey:@"cookieCostumes"];
                                                                                            NSString *identifierName = [NSString stringWithFormat:@"IAPIdentifiers_%@%@",
                                                                                                                        freeCostumeDict[@"keyTheme"],
                                                                                                                        freeCostumeDict[@"keyName"]];
//                                                                                            NSString *iapIdentifier = [[CDIAPManager iapMananger] valueForKey:identifierName]; // <<< Use this in the 'forKey' value below.
                                                                                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:identifierName];
                                                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                        }
                                                                                        else {
                                                                                            DebugLog(@"Error: No cookie costumes found in returned account when updating cookie costumes.");
                                                                                        }
                                                                                    }
                                                                                    else {
                                                                                        DebugLog(@"Error: No account returned when updating cookie costumes.");
                                                                                    }
                                                                                }
                                                                                else {
                                                                                    DebugLog(@"Error: No return dict when updating cookie costumes.");
                                                                                }
                                                                            }];
                    break;
                }
                else {
                    DebugLog(@"The %@ costume for %@ has already been unlocked.", dict[@"theme"], dict[@"name"]);
                    break;
                }
            }
        }
    }
}

- (void)loadPlayerInfo {
    self.levelProperties = [[NSArray alloc] init];
    NSArray *worldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
    if (worldsArray != nil && [_planetID intValue] <= [worldsArray count]) {
        int planetIndex = [_planetID intValue];
        NSDictionary *thisWorldDict = worldsArray[planetIndex];
        _planetID = [NSNumber numberWithInt:[thisWorldDict[@"type"] intValue] - 1];
        NSArray *levelsArray = thisWorldDict[@"levels"];
        if (levelsArray != nil) {
            self.levelProperties = levelsArray;
        }
        else {
            DebugLog(@"Warning: Levels array for player account is nil.");
        }
    
        // Check if there needs to be a costume unlock.
        NSString *worldName = [[SGFileManager fileManager] stringFromIndex:([_planetID intValue]) inFile:@"planetoids-master-list"];
        [self checkAndUnlockFreeCostumeForWorld:worldName];
    }
    else {
        DebugLog(@"Warning: Worlds array for player account is nil or locked.");
    }
}

@end
