//
//  CDCookieDunkDunKViewController.m
//  CookieDD
//
//  Created by Luke McDonald on 10/18/13.
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

#import "CDCookieDunkDunKViewController.h"
#import "SGCookieDunkDunkScene.h"
#import "SGAudioManager.h"
#import "CDParticleEmitter.h"
#import "CDStoreViewController.h"
#import "CDAccountPopupView.h"
#import "CDStandardPopupView.h"
#import "SGStoreItemInfoViewController.h"
#import "CDHowtoPopup.h"
#import "CDAwardPopupViewController.h"
#import "CDPurchasableItemPopupViewController.h"
//#import "CDVideoPlayerViewController.h"

@interface CDCookieDunkDunKViewController () <SGCookieDunkDunkDelegate, CDMainButtonViewControllerDelegate, CDStandardPopupViewDelegate, CDAccountPopupViewDelegate, CDAwardPopupViewControllerDelegate, CDPurchasableItemPopupViewControllerDelegate>//, CDVideoPlayerViewControllerDelegate>

@property (strong, nonatomic) SGCookieDunkDunkScene *scene;
@property (strong, nonatomic) CDLoadingScreenViewController *loadingScreen;
//@property (weak, nonatomic) CDStandardPopupView *standardPopup;
//@property (weak, nonatomic) CDAccountPopupView *accountView;
@property (strong, nonatomic) CDPurchasableItemPopupViewController *purchasePopup;

@property (assign, nonatomic) BOOL didFinishSwipe;
@property (assign, nonatomic) BOOL lockOrientation;
//@property (assign, nonatomic) BOOL helpIsOpen;
//@property (assign, nonatomic) BOOL accountIsOpen;

@property (strong, nonatomic) NSSet *touches;
@property (strong, nonatomic) UIEvent *event;
@property (assign, nonatomic) CGPoint startPosition;
@property (assign, nonatomic) SKTextureAtlas *atlas;

//@property (strong, nonatomic) CDVideoPlayerViewController *videoPlayerVC;

@end

@implementation CDCookieDunkDunKViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    
    //[self createGameScene];
    
    _chargedItem = EMPTY_ITEM;
  
    _didFinishSwipe = YES;
    _lockOrientation = NO;
//    _helpIsOpen = NO;
//    _accountIsOpen = NO;
    
    // Setup the button
    _mainButtonViewController = [[CDMainButtonViewController mainButton] didCreateMainButtonViewWithParentalViewController:self];
    _mainButtonViewController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitApp) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterApp) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self loadingScreenHandler];
}

- (void)exitApp
{
    DebugLog(@"exiting app!");
    
    if (self.scene)
    {
        SKView *skView = (SKView *) self.view;
        skView.paused = YES;
        
        self.scene.paused = YES;
        [self.scene.view setPaused:YES];
        [[SGAudioManager audioManager] pauseAllAudio];
        
//        __weak typeof(self) weakSelf = self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            SKView *skView = (SKView *) weakSelf.view;
//            skView.paused = YES;
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
    
    if (self.scene)
    {
        SKView *skView = (SKView *) self.view;
        skView.paused = NO;
        
        self.scene.paused = NO;
        [self.scene.view setPaused:NO];
        [[SGAudioManager audioManager] playAllAudio];
        
//        __weak typeof(self) weakSelf = self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            SKView *skView = (SKView *) weakSelf.view;
//            skView.paused = NO;
//            
//            weakSelf.scene.paused = NO;
//            [weakSelf.scene.view setPaused:NO];
//            [[SGAudioManager audioManager] playAllAudio];
//        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)createGameScene {
    
    SKView *skView = (SKView *)self.view;
    //[skView setShowsNodeCount:YES];
    //skView.showsNodeCount = YES;
    //skView.showsFPS = YES;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        weakSelf.scene = [SGCookieDunkDunkScene sceneWithSize:skView.bounds.size];
        weakSelf.scene.boosterSelectedObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_boosterActive_whiteDash"];
        
        weakSelf.scene.parentController = weakSelf;
        
        weakSelf.scene.delegate = weakSelf;
        //    self.scene.limiter = self.limiter;
        [skView presentScene:weakSelf.scene];
        
        [[SGGameManager gameManager] ShowGoals];
        
        weakSelf.mainButtonViewController.parentViewFrame = weakSelf.view.frame;
        weakSelf.mainButtonViewController.conditionalViewFrame = weakSelf.scene.frame;
    });
}


/*
 - (void)viewDidLoad
 {
     [super viewDidLoad];
     // Do any additional setup after loading the view.
     [self.navigationController setNavigationBarHidden:YES];
     
     SKView *skView = (SKView *)self.view;
     
     // Textures
     
     _atlas = [[SGGameManager gameManager] textureAtlasNamed:@"cddMain"];
     
     [SGGameManager gameManager].atlas = _atlas;
         
         
     [_atlas preloadWithCompletionHandler:^
     {
         [self loadAssets];
     //    self.scene.limiter = self.limiter;
         
         _scene.parentController = self;
         
         _scene = [SGCookieDunkDunkScene sceneWithSize:skView.bounds.size];
         
         _scene.delegate = self;
         
         [skView presentScene:self.scene];
     
     }];
     
     UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
     
     [self.view addGestureRecognizer:panner];
     
     _didFinishSwipe = YES;
 }
 
 
 - (void)loadAssets
 {
 
 // Partices
 [SGGameManager gameManager].shockwaveParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"ShockwaveParticle"];
 
 [SGGameManager gameManager].milkDropsParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"MilkDropsParticle"];
 
 [SGGameManager gameManager].milkSplatParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"MilkSplatParticle"];
 
 [SGGameManager gameManager].smokeParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"SmokeParticle"];
 
 [SGGameManager gameManager].nukeCloudFireParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"NukeCloudFireParticle"];
 
 [SGGameManager gameManager].nukeCollumnFireParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"NukeCollumnFireParticle"];
 
 [SGGameManager gameManager].nukeShockwaveParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"NukeShockwaveParticle"];
 
 // textures
 
 
 
 [SGGameManager gameManager].cookieOneTexture = [_atlas textureNamed:@"chipcookie"];
 
 [SGGameManager gameManager].cookieTwoTexture = [_atlas textureNamed:@"blueberrycookie"];
 
 [SGGameManager gameManager].cookieThreeTexture = [_atlas textureNamed:@"purplecookie"];
 
 [SGGameManager gameManager].cookieFourTexture = [_atlas textureNamed:@"aliencookie"];
 
 [SGGameManager gameManager].cookieFiveTexture = [_atlas textureNamed:@"orangecookie"];
 
 [SGGameManager gameManager].cookieSixTexture = [_atlas textureNamed:@"srawberrycookie"];
 
 [SGGameManager gameManager].ingredientTexture = [SKTexture sgtextureWithImageNamed:@"tempIngredient"];
 
 [SGGameManager gameManager].bombTexture = [SKTexture sgtextureWithImageNamed:@"PowerBomb-72"];
 }
*/


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)openShop
{
    [[SGAudioManager audioManager] stopAllAudio];
    
//    _mainButtonViewController.view.clipsToBounds = YES;
    
    [self loadingScreenHandler];
    double delayInSeconds = .5;//[SGAppDelegate appDelegate].loadingScreenTimeDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self dismissViewControllerAnimated:NO completion:^{
                           
                           if ([self.delegate respondsToSelector:@selector(shopButtonWasHitInMainGameViewController)])
                           {
                               [self.delegate shopButtonWasHitInMainGameViewController];
                           }
                           [_loadingScreen.view removeFromSuperview];
                           
                           [_scene removeAllActions];
                           [_scene removeAllChildren];
                           [_scene removeFromParent];
                           _scene = nil;
                           [[SGGameManager gameManager] Remove_Scene];
                           
                       }];
                   });
}
#pragma mark - Board Creation

- (void)createLevelWithID:(NSNumber *)levelType
                ForPlanet:(NSNumber *)planetType
{
    [[SGAudioManager audioManager] stopAllAudio];
    
    [_scene removeAllActions];
    [_scene removeAllChildren];
    [_scene removeFromParent];
    _scene = nil;
    [[SGGameManager gameManager] Remove_Scene];
    
    _levelType = levelType;
    _planetType = planetType;
    
    NSString *planetName = [[SGFileManager fileManager] stringFromIndex:[planetType intValue] inFile:@"planetoids-master-list"];
    NSDictionary *planetDict = [[SGFileManager fileManager] loadDictionaryWithFileName:planetName OfType:@"plist"];
    int levelNumber = ([planetType intValue] * 30) + [levelType intValue];
    
    NSString *levelName = [NSString stringWithFormat:@"cdd_level_%03d", ([planetType intValue] * 30) + [levelType intValue]];
    DebugLog(@"Create level %@ for planet %@.", levelType, planetName);
    
    NSDictionary *levelDict = [[SGFileManager fileManager] loadDictionaryWithFileName:levelName OfType:@"plist"];
   
    if (planetDict)
    {
        [SGGameManager gameManager].backgroundImageOffsetArray = @[@"{0,0}", @"{0,0}"];
        
        if (IS_IPHONE_5)
        {
            if (planetDict[@"iPhone5ImageOffset"])
            {
                [SGGameManager gameManager].backgroundImageOffsetArray = planetDict[@"iPhone5ImageOffset"];
            }
            
        }
        else if (IS_IPHONE_4)
        {
            if (planetDict[@"iPhone4ImageOffset"])
            {
                [SGGameManager gameManager].backgroundImageOffsetArray = planetDict[@"iPhone4ImageOffset"];
            }
        }
        else
        {
            DebugLog(@"No offset values found for image.");
        }
    }
    
    if (levelDict )
    {
        [SGGameManager gameManager].what_level_am_I_at = levelNumber;
        [SGGameManager gameManager].what_planet_am_I_on = planetDict[@"displayName"];
        [SGGameManager gameManager].planetName = planetDict[@"name"];
        //DebugLog(@"Found the level file.");
        
        [SGGameManager gameManager].levelName = levelName;
        
        // Set the level location info.
        [SGGameManager gameManager].worldType = planetType;
        [SGGameManager gameManager].levelType = levelType;
        
        //DebugLog(@"Set Spawnable Items.");
        [self setSpawnableItemsWithArray:levelDict[@"spawnableItems"]];
       
        //DebugLog(@"Set Goal Type.");
        [self setGoalWithType:levelDict[@"goalType"] UsingValue:levelDict[@"goalValue"] Bronze:levelDict[@"Bronze_Star_Goal"] Silver:levelDict[@"Silver_Star_Goal"] Gold:levelDict[@"Gold_Star_Goal"] ForItems:levelDict[@"goalItems"] SecondGoalType:levelDict[@"secondarygoalType"] SecondGoalValue:levelDict[@"secondarygoalValue"] SecondGoalItems:levelDict[@"secondarygoalItems"]];
        
        //DebugLog(@"Set Limiter Type.");
        [self setLimiterWithType:levelDict[@"limiterType"] UsingValue:levelDict[@"limiterValue"]];
        
        //DebugLog(@"Set Initial Board Items");
        [SGGameManager gameManager].initialBoardItemsArray = levelDict[@"tiles"];
        [SGGameManager gameManager].theGameBoardBackgroundTiles = levelDict[@"gameBoardBackground"];
        
        //DebugLog(@"Set the level's boosters.");
        if (levelDict[@"Boosters"]) {
            [SGGameManager gameManager].availableBoosters = levelDict[@"Boosters"];
        }
        
        //DebugLog(@"Set the stage.");
        
        //DebugLog(@"createGameScene");
        [self createGameScene];
    
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (levelNumber) {
                case 1:
                {
                    CDHowtoPopup* howtoPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDHowtoPopup" owner:self options:nil] objectAtIndex:0];
                    [howtoPopup setup:@"Match"];
                    howtoPopup.frame = weakSelf.scene.frame;
                    
                    [self.view addSubview:howtoPopup];
                    
                    break;
                }
                    
                case 5:
                {
                    CDHowtoPopup* howtoPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDHowtoPopup" owner:self options:nil] objectAtIndex:0];
                    [howtoPopup setup:@"Ing. Drop"];
                    howtoPopup.frame = weakSelf.scene.frame;
                    
                    [self.view addSubview:howtoPopup];
                    
                    break;
                }
                    
                case 11:
                {
                    CDHowtoPopup* howtoPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDHowtoPopup" owner:self options:nil] objectAtIndex:0];
                    [howtoPopup setup:@"Glass"];
                    howtoPopup.frame = weakSelf.scene.frame;
                    
                    [self.view addSubview:howtoPopup];
                    
                    break;
                }
                    
                case 14:
                {
                    CDHowtoPopup* howtoPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDHowtoPopup" owner:self options:nil] objectAtIndex:0];
                    [howtoPopup setup:@"RAD"];
                    howtoPopup.frame = weakSelf.scene.frame;
                    
                    [self.view addSubview:howtoPopup];
                    
                    break;
                }
                    
                case 15:
                {
                    CDHowtoPopup* howtoPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDHowtoPopup" owner:self options:nil] objectAtIndex:0];
                    [howtoPopup setup:@"SLOT"];
                    howtoPopup.frame = weakSelf.scene.frame;
                    
                    [self.view addSubview:howtoPopup];
                    
                    break;
                }
                
                case 22:
                {
                    CDHowtoPopup* howtoPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDHowtoPopup" owner:self options:nil] objectAtIndex:0];
                    [howtoPopup setup:@"WRAP"];
                    howtoPopup.frame = weakSelf.scene.frame;
                    
                    [self.view addSubview:howtoPopup];
                    
                    break;
                }
                    
                case 28:
                {
                    CDHowtoPopup* howtoPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDHowtoPopup" owner:self options:nil] objectAtIndex:0];
                    [howtoPopup setup:@"Ice Cream"];
                    howtoPopup.frame = weakSelf.scene.frame;
                    
                    [self.view addSubview:howtoPopup];
                    
                    break;
                }
                
               /*
                case 45:
                {
                    CDHowtoPopup* howtoPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDHowtoPopup" owner:self options:nil] objectAtIndex:0];
                    [howtoPopup setup:@"Locked Pieces"];
                    
                    [self.view addSubview:howtoPopup];
                
                    break;
                }
                    break;
                    
                 */
                default:
                    break;
            }
        });
    }
    else
    {
        DebugLog(@"Error: Couldn't find levelDict.  This is what I got: %@", levelDict);
    }
}


// Simply loads and returns a dictionary from a given file.
//- (NSDictionary *)loadDictionaryWithFileName:(NSString *)fileName
//{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//   
//    if ([fileManager fileExistsAtPath:filePath])
//    {
//        NSDictionary *fileDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
//       
//        return fileDict;
//    }
//    else
//    {
//        DebugLog(@"Error: Could not find a file named '%@'", fileName);
//    }
//    
//    return nil;
//}

// User the master-list files to convert string values to their int counterparts.

//- (int)findTypeIndexFromString:(NSString *)typeString
//                   InFileNamed:(NSString *)fileName
//{
//    NSDictionary *referenceDict = [self loadDictionaryWithFileName:fileName];
//   
//    return [[referenceDict objectForKey:typeString] integerValue];
//    
//    
//}

- (void)setGoalWithType:(NSString *)goalType
             UsingValue:(NSNumber *)goalValue
                Bronze:(NSNumber *)bronze
                Silver:(NSNumber *)silver
                Gold:(NSNumber *)gold
               ForItems:(NSArray *)goalItems
         SecondGoalType:(NSString *)secondGoalType
         SecondGoalValue:(NSNumber *)secondGoalValue
         SecondGoalItems:(NSArray *)secondGoalItems
{
   
    //DebugLog(@"goalType = %@", goalType);
    //DebugLog(@"goalValue = %@", goalValue);
    //DebugLog(@"goalItems = %@", goalItems);

    GoalTypes goal;
    
    if([goalType  isEqual: @"TOTAL_SCORE"]){
        goal = GoalTypes_TOTALSCORE;
    }else
    if([goalType  isEqual: @"CLEAR_TYPE"]){
        goal = GoalTypes_TYPECLEAR;
    }else
    if([goalType  isEqual: @"STAR_COUNT"]){
        goal = GoalTypes_STARCOUNT;
    }else
    if([goalType  isEqual: @"INGREDIENT"]){
        goal = GoalTypes_INGREDIENT;
    }else{
        goal = GoalTypes_TOTALSCORE;
    }

    
    GoalTypes secondGoal;
    
    if([secondGoalType  isEqual: @"TOTAL_SCORE"]){
        secondGoal = GoalTypes_TOTALSCORE;
    }else
        if([secondGoalType  isEqual: @"CLEAR_TYPE"]){
            secondGoal = GoalTypes_TYPECLEAR;
        }else
            if([secondGoalType  isEqual: @"STAR_COUNT"]){
                secondGoal = GoalTypes_STARCOUNT;
            }else
                if([secondGoalType  isEqual: @"INGREDIENT"]){
                    secondGoal = GoalTypes_INGREDIENT;
                }else{
                    secondGoal = GoalTypes_TOTALSCORE;
                }

    
    
    [[SGGameManager gameManager] setGoalType:goal WithValue:[goalValue intValue] WithBronze:[bronze intValue] WithSilver:[silver intValue] WithGold:[gold intValue] WithItems:goalItems SecondaryGoalType:secondGoal SecondaryGoalValue:[secondGoalValue intValue] SecondaryGoalItems:secondGoalItems];

}

- (void)setLimiterWithType:(NSString *)limiterType
                UsingValue:(NSNumber *)limiterValue
{
    if (limiterType)
    {
       // "MOVE_LIMIT",
	   // "TIME_LIMIT",
	   // "MARATHON"
        
        GoalLimiters limit;
        
        if([limiterType isEqualToString:@"MOVE_LIMIT"]){

            limit = GoalLimiters_MOVE_LIMIT;
            
        }else{
            
            limit = GoalLimiters_TIME_LIMIT;
            
        }
        
        //DebugLog(@"limiterType = %@", limiterType);
        //DebugLog(@"limiterValue = %@", limiterValue);
        
        [[SGGameManager gameManager] setLimiterValueTo:limit WithValue:[limiterValue intValue]];
    }
}

- (void)setSpawnableItemsWithArray:(NSArray *)spawnableItems
{
    if (spawnableItems)
    {
        //DebugLog(@"spawnableItems = %@", spawnableItems);
        
        [[SGGameManager gameManager] setSpawnableItemsWithArray:spawnableItems];
    }
}

//- (void)setInitialBoardItemsWithArray:(NSArray *)boardArray
//{
//    if (boardArray)
//    {
//        //DebugLog(@"tilesArray = %@", tilesArray);
////        for (NSArray *rowsArray in boardArray)
////        {
////            // Set each tile in this row.
////            for (NSDictionary *tileDict in rowsArray)
////            {
////                //DebugLog(@"tileDict = %@", tileDict);
////                
////                //DebugLog(@"ItemType = %@", tileDict[@"ItemType"]); //     I'm leaving the 'I' uppercase for now,
//                                                                       //     but newer versions of the editor have this fixed.
////                //DebugLog(@"isBottom = %@", tileDict[@"isBottom"]);
////                //DebugLog(@"isLocked = %@", tileDict[@"isLocked"]);
////                //DebugLog(@"plateLevel = %@", tileDict[@"plateLevel"]);
////                
////            }
////        }
//        
//        
//        
//        
//        [[SGGameManager gameManager] createInitialBoardItems:boardArray];
//    }
//}


#pragma mark - Orientation

// Ensure it opens in protrait due to the how-to popup not allowing landscape....
// NEED LANDSCAPE GRAPHICS!!!!
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

// Don't ask, just keep this for insurance purposes....
- (void)viewWillLayoutSubviews
{
    self.view.frame = self.view.superview.bounds;
}

- (void)orientationChanged:(NSNotification *)notification
{
    self.view.frame = self.view.superview.bounds;
}

- (BOOL)shouldAutorotate
{
//    if(![SGGameManager gameManager].isTakingInput)
        return NO;
    
//    if (!_lockOrientation)
//    {
//        return YES;  // f@#$k you!  I'm rotating!
//    }
//    else
//    {
//        return NO;
//    }
}

- (NSUInteger)supportedInterfaceOrientations
{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//    else
//    {
//        return UIInterfaceOrientationMaskAll;
//    }
    return UIInterfaceOrientationPortrait;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    SKView * skView = (SKView *)self.view;
    
    _scene.size = skView.bounds.size;
    
    [_scene SetupHUDForOrientation:toInterfaceOrientation];
    
    //[_scene resetGameBoardPositionToInterface:toInterfaceOrientation];
    
    if (_mainButtonViewController)
    {
        [_mainButtonViewController orientationHasChanged:toInterfaceOrientation WithDuration:duration];
    }
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        DebugLog(@"land");
        [[SGGameManager gameManager] To_Landscape];
        _mainButtonViewController.parentViewFrame = self.view.frame;
        _mainButtonViewController.conditionalViewFrame = _scene.frame;
      //  [self.theScene Rotate_to_Landscape:duration];
    }
    else
    {
        DebugLog(@"port");
        [[SGGameManager gameManager] To_Portrait];
        _mainButtonViewController.parentViewFrame = self.view.frame;
        _mainButtonViewController.conditionalViewFrame = _scene.frame;
       // [self.theScene Rotate_to_Portrait:duration];
    }
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _touches = touches;
    
    _event = event;
    
    _scene.direction = Direction_Default;

    for (UITouch *touch in touches)
    {
        _startPosition = [touch locationInNode:_scene.gameBoard];
    }
}


#pragma mark - Custom Methods


#pragma mark - SGCookieDunkDunkScene delegate
-(void)cookieDunkDunkSceneWillRemoveLoadingScreen
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.loadingScreen.view removeFromSuperview];
        weakSelf.loadingScreen = nil;
    });
}

- (void)cookieDunkDunkMainGameDidEnd:(SGCookieDunkDunkScene *)scene
{
//    DebugLog(@"Final score = %i", [SGGameManager gameManager].score);
//    
//    CDPopUpViewController *popUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CDPopUpViewController"];
//    [self addChildViewController:popUpViewController];
//    popUpViewController.socialMessage = [NSString stringWithFormat:@"I just scored %i on a level in Cookie Dunk Dunk", [SGGameManager gameManager].score];
//    [self.view insertSubview:popUpViewController.view belowSubview:_mainButtonViewController.view];
//    popUpViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    popUpViewController.delegate = self;
//    [popUpViewController.scoreLabel setText:[NSString stringWithFormat:@"You Scored %i Points!", [SGGameManager gameManager].score]];
}

- (void)itemButton:(CDButtonSpriteNode *)buttonSprite wasSelectedForItemType:(ItemType)itemType {
    
    [_scene.boosterSelectedObject removeAllActions];
    [_scene.boosterSelectedObject removeFromParent];

    _scene.throwAwayButton = nil;
    if (_scene.ApplyPowerupOnCookie == itemType)
    {
        DebugLog(@"Discharging Item!");
        // Deactivate the item.
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"BPop1" FileType:@"caf"]; //@"m4a"];
        _chargedItem = EMPTY_ITEM;
        _scene.ApplyPowerupOnCookie = EMPTY_ITEM;
    }
    else if (buttonSprite.boosterCount > 0)
    {
        DebugLog(@"Charging Item!");
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"BPop2" FileType:@"caf"]; //@"m4a"];
        _chargedItem = itemType;
        _scene.ApplyPowerupOnCookie = itemType;
        
        _scene.throwAwayButton = buttonSprite;
        
//        _scene.boosterSelectedObject.position = buttonSprite.position;
        [buttonSprite addChild:_scene.boosterSelectedObject];
        _scene.boosterSelectedObject.xScale = .6;
        _scene.boosterSelectedObject.yScale = .6;
        _scene.boosterSelectedObject.color = [SKColor redColor];
        _scene.boosterSelectedObject.colorBlendFactor = 0.7;
        
        [_scene.boosterSelectedObject runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:2]]];
    }
    else if (buttonSprite.boosterCount <= 0)
    {
        DebugLog(@"Discharging Item!");
        // Deactivate the item.
        _chargedItem = EMPTY_ITEM;
        _scene.ApplyPowerupOnCookie = EMPTY_ITEM;
        
        _scene.userInteractionEnabled = NO;
        
        for (CDButtonSpriteNode *button in _scene.topBarBoostersArray)
        {
            button.userInteractionEnabled = NO;
        }
        
        _purchasePopup = [self.storyboard instantiateViewControllerWithIdentifier:@"CDPurchasableItemPopupViewController"];
        _purchasePopup.view.frame = _scene.frame;
        _purchasePopup.itemType = itemType;
        _purchasePopup.delegate = self;
        _purchasePopup.buttonSprite = buttonSprite;
        [self.view insertSubview:_purchasePopup.view belowSubview:_mainButtonViewController.view];
        [_purchasePopup setupUI];
        
        buttonSprite.color = [SKColor blackColor];
        buttonSprite.colorBlendFactor = 0.5;
    }
}

- (void)sgCookieDunkDunkSceneDidQuit:(SGCookieDunkDunkScene *)cookieScene shouldContinue:(BOOL)shouldContinue {
    
    int currentLives = [[SGAppDelegate appDelegate].accountDict[@"lives"] intValue];
    if (shouldContinue && currentLives > 0) {
            
        if ([_levelType intValue] < numLevelsPerPlanet) {
            // Same planet.
            [self createLevelWithID:[NSNumber numberWithInt:[_levelType intValue] + 1] ForPlanet:_planetType];
        }
        else if ([_planetType intValue]+1 < numUnlockablePlanets) {
            // Next planet.
            if ([_planetType intValue] == 0) // if (Milkyway)
            {
                BOOL watchedVideo = [[NSUserDefaults standardUserDefaults] boolForKey:WatchedDunkopolisIntroVideoDefault];
                if (!watchedVideo)
                {
                    if ([self.delegate respondsToSelector:@selector(cookieDunkDunkViewControllerWillGoBackToMap:withVideoName:)])
                    {
                        [self.delegate cookieDunkDunkViewControllerWillGoBackToMap:self withVideoName:@"CDDVID2"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WatchedDunkopolisIntroVideoDefault];
                    }
                    else
                    {
                        if ([self.delegate respondsToSelector:@selector(dismissingCookieDunkDunkViewController:)])
                        {
                            [self.delegate dismissingCookieDunkDunkViewController:self];
                        }
                    }
                }
                else
                {
                    if ([self.delegate respondsToSelector:@selector(dismissingCookieDunkDunkViewController:)])
                    {
                        [self.delegate dismissingCookieDunkDunkViewController:self];
                    }
                }
            }
            else if ([_planetType intValue] == 1) // if (Dunkopolis)
            {
                BOOL watchedVideo = [[NSUserDefaults standardUserDefaults] boolForKey:WatchedAbductionJunctionIntroVideoDefault];
                if (!watchedVideo)
                {
                    if ([self.delegate respondsToSelector:@selector(cookieDunkDunkViewControllerWillGoBackToMap:withVideoName:)])
                    {
                        [self.delegate cookieDunkDunkViewControllerWillGoBackToMap:self withVideoName:@"FarmerVid"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WatchedAbductionJunctionIntroVideoDefault];
                    }
                    else
                    {
                        if ([self.delegate respondsToSelector:@selector(dismissingCookieDunkDunkViewController:)])
                        {
                            [self.delegate dismissingCookieDunkDunkViewController:self];
                        }
                    }
                }
                else
                {
                    if ([self.delegate respondsToSelector:@selector(dismissingCookieDunkDunkViewController:)])
                    {
                        [self.delegate dismissingCookieDunkDunkViewController:self];
                    }
                }
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(dismissingCookieDunkDunkViewController:)])
                {
                    [self.delegate dismissingCookieDunkDunkViewController:self];
                }
            }
        }
        else {
            // There are no more levels.
        }
        //[[SGGameManager gameManager] Remove_Scene];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
            DebugLog(@"Removing MainGamePopupView");
            [_scene removeAllActions];
            [_scene removeAllChildren];
            [_scene removeFromParent];
            _scene = nil;
            
            [[SGGameManager gameManager] Remove_Scene];
        }];
    }
}



#pragma mark - CDPopUpViewController Delegate
//- (void)didEndGame:(CDPopUpViewController *)viewController
//{
//    _scene.userInteractionEnabled = NO;
//    
//    DebugLog(@"\n\n end \n\n");
//    [[SGGameManager gameManager] Remove_Scene];
//    
//    [viewController.view removeFromSuperview];
//    [viewController removeFromParentViewController];
//    
//    //    [[SGAudioManager audioManager] stopTheAudioPlayer];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - Main Button Delegates
- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction
{
    _scene.userInteractionEnabled = !willDisableInteraction;
    //_scene.paused = willDisableInteraction;
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
        DebugLog(@"BackButton - CookieDunkDunkViewController");
        
        // Don't take away a life if the game is already over. (Losing already takes away a life.)
        if (![SGGameManager gameManager].gameIsOver) {
            [[CDIAPManager iapMananger] requestToDecreaseLivesValue:[NSNumber numberWithInt:1] costValue:[NSNumber numberWithInt:0] costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                // Close to map.
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                });
            }];
        }
        else {
            // Close to map.
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
            });
        }
        
        
        _mainButtonViewController.view.clipsToBounds = YES;
        
        
//        [_scene removeAllActions];
//        [_scene removeAllChildren];
        [_scene removeFromParent];
//        _scene = nil;
        [[SGGameManager gameManager] Remove_Scene];
        [[SGAudioManager audioManager] stopAllAudio];
        
        [self loadingScreenHandler];
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
        [[CDIAPManager iapMananger] requestToDecreaseLivesValue:[NSNumber numberWithInt:1] costValue:[NSNumber numberWithInt:0] costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                DebugLog(@"THE SHOP BUTTON WAS HIT");
                [self openShop];
        }];
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

- (void)goingBackToPlanets:(BOOL)toPlanets
{
    DebugLog(@"goingBackToPlanets");
    
    [[CDIAPManager iapMananger] requestToDecreaseLivesValue:[NSNumber numberWithInt:1] costValue:[NSNumber numberWithInt:0] costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
        // Close to map.
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        });
    }];
    
    _mainButtonViewController.view.clipsToBounds = YES;
    
    
    [_scene removeAllActions];
    [_scene removeAllChildren];
    [_scene removeFromParent];
    _scene = nil;
    [[SGGameManager gameManager] Remove_Scene];
    [[SGAudioManager audioManager] stopAllAudio];
    
    [self loadingScreenHandler];
    
//    if (toPlanets)
//    {
//        if ([_delegate respondsToSelector:@selector(goingBackToPlanetsFromMainGameViewController)])
//        {
//            [_delegate goingBackToPlanetsFromMainGameViewController];
//        }
//    }
}

#pragma mark - Loading Screen

- (void)createLoadingScreenWithImageNamed:(NSString *)imageName
{
    //TODO: JOSH
//    return;
    
    _loadingScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CDLoadingScreenViewController"];
    [self.view addSubview:_loadingScreen.view];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
    {
        _loadingScreen.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }
    else
    {
        _loadingScreen.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);
    }
    
    [_loadingScreen createLoadingScreenWithImageName:imageName];
}

- (void)loadingScreenHandler
{
    _lockOrientation = YES;
    
    NSString *bgImageString;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
    {
        bgImageString = [NSString stringWithFormat:@"Default%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
    }
    else
    {
        bgImageString = [NSString stringWithFormat:@"Default-landscape%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
    }
    
    [self createLoadingScreenWithImageNamed:bgImageString];
}

#pragma mark - present popups

- (void)presentHelpView
{
    CDStandardPopupView *standardPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
    
    standardPopup.delegate = self;
    standardPopup.whatAmILoading = @"mainGameHelp";
    
    standardPopup.frame = _scene.frame;//CGRectMake(0, 0, _scene.frame.size.width, _scene.frame.size.height);
    [self.view insertSubview:standardPopup aboveSubview:_mainButtonViewController.view];
    [standardPopup setup];
    
    _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

- (void)presentAccountView
{
    DebugLog(@"Presenting Account View");
    if ([SGAppDelegate appDelegate].accountDict)
    {
        CDAccountPopupView *accountView = [[[NSBundle mainBundle] loadNibNamed:@"CDAccountPopupIphone5View" owner:self options:nil] objectAtIndex:0];
        [accountView.backgroundImage setImage:[UIImage imageNamed:@"cdd-main-board-hud-minigamepanel-v-568h"]];
        accountView.frame = _scene.frame;
        
        accountView.delegate = self;
        accountView.isMainGame = YES;
        [self.view insertSubview:accountView aboveSubview:_mainButtonViewController.view];
        [accountView setupWithParentalViewController:self];
        
        _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
//        _accountIsOpen = YES;
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:_scene.frame errorDescription:@"You are not currently logged in. Please Login to view your account." loadingText:nil];
        
        _mainButtonViewController.popupIsUp = NO;
        [_mainButtonViewController enableButtons:YES];
    }
}

#pragma mark - Standard popup delegates
- (void)exitButtonWasHitOnStandardPopupView:(CDStandardPopupView *)standardPopup
{
    [standardPopup removeFromSuperview];
    _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _mainButtonViewController.popupIsUp = NO;
//    _helpIsOpen = NO;
    
    [_mainButtonViewController enableButtons:YES];
}

#pragma mark - account screen delegates
- (void)exitButtonWasHitOnAccountPopup:(CDAccountPopupView *)accountView
{
    [accountView removeFromSuperview];
    _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _mainButtonViewController.popupIsUp = NO;
//    _accountIsOpen = NO;
    
    [_mainButtonViewController enableButtons:YES];
}

- (void)addCoinsButtonWasHitOnAccountPopup:(CDAccountPopupView *)accountView
{
    [accountView removeFromSuperview];
    [self openShop];
}

#pragma mark - award popup delegate
- (void)didTapScreenToDismissAwardsPopupViewController:(CDAwardPopupViewController *)awardsPopupViewController
{
    DebugLog(@"Check 2");
    [awardsPopupViewController removeFromParentViewController];
    [awardsPopupViewController.view removeFromSuperview];
}

#pragma mark - purchase item popup delegate
- (void)cancelButtonWasHitOnPurchasableItemPopup:(CDPurchasableItemPopupViewController *)purchasableItemViewController
{
    for (CDButtonSpriteNode *button in _scene.topBarBoostersArray)
    {
        button.userInteractionEnabled = YES;
    }
//    purchasableItemViewController.buttonSprite.userInteractionEnabled = YES;
    [purchasableItemViewController.view removeFromSuperview];
    _scene.userInteractionEnabled = YES;
}

- (void)boughtSomethingInPurchaseableItemPopup:(CDPurchasableItemPopupViewController *)purchasableItemViewController WithItemCount:(int)itemAddedCount
{
    DebugLog(@"Hello out there!");
    purchasableItemViewController.buttonSprite.color = [SKColor whiteColor];
    purchasableItemViewController.buttonSprite.colorBlendFactor = 0.5;
    
    for (CDButtonSpriteNode *button in _scene.topBarBoostersArray)
    {
        button.userInteractionEnabled = YES;
    }
//    purchasableItemViewController.buttonSprite.userInteractionEnabled = YES;
    
    purchasableItemViewController.buttonSprite.boosterCount = itemAddedCount;
    
    if (purchasableItemViewController.buttonSprite.boosterCount <= 99)
    {
        [purchasableItemViewController.buttonSprite.boosterCountLabel setText:[NSString stringWithFormat:@"%i", purchasableItemViewController.buttonSprite.boosterCount]];
    }
    else if (purchasableItemViewController.buttonSprite.boosterCount > 99)
    {
        [purchasableItemViewController.buttonSprite.boosterCountLabel setText:@"99+"];
    }
    
//    [purchasableItemViewController.buttonSprite.boosterCountLabel setText:[NSString stringWithFormat:@"%i", purchasableItemViewController.buttonSprite.boosterCount]];
    [purchasableItemViewController.view removeFromSuperview];
    _scene.userInteractionEnabled = YES;
}

#pragma mark - CDVideoPlayerDelegate
//
//- (void)videoPlayerHasEnded:(CDVideoPlayerViewController *)videoViewController {
//    
//    [_videoPlayerVC.view removeFromSuperview];
//    [self createLevelWithID:[NSNumber numberWithInt:1] ForPlanet:[NSNumber numberWithInt:[_planetType intValue] + 1]];
//    
//    // Gary J: Todo!!!
////    [self goingBackToPlanets:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DebugLog(@"Dealloc - CookieDunkDunkViewContoller");
}
@end
