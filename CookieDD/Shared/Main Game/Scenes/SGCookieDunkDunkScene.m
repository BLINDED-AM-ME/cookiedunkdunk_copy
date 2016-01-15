//
//  SGCookieDunkDunkScene.m
//  CookieDD
//
//  Created by Luke McDonald on 9/18/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.
//http://upyun.cocimg.com/cocoachina/SpriteKit_PG.pdf
// cadisplaylink

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

#import "SGCookieDunkDunkScene.h"
#import "CDParticleEmitter.h"
#import <CoreMotion/CoreMotion.h>

@interface SGCookieDunkDunkScene () <SGGameManagerDelegate, CDButtonSpriteNodeDelegate>

@property (assign, nonatomic) BOOL didMakeValidMove;
@property (assign, nonatomic) BOOL contentCreated;
@property (assign, nonatomic) BOOL createdPopup;
@property (assign, nonatomic) BOOL setCookie;
@property (assign, nonatomic) BOOL cyclingCookie;
@property (assign, nonatomic) BOOL didSetFaceArrayToRandom;
@property (assign, nonatomic) BOOL didSetFaceArrayForFirstTime;

//@property (strong, nonatomic) NSTimer *countdownTimer;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *limiterLabel;
@property (assign, nonatomic) CGPoint startPosition;


@property (assign, nonatomic) float masterTime;
@property (assign, nonatomic) int milkBarSpriteCounter;

@property (assign, nonatomic) CGRect maxBoardArea;

@property (assign, nonatomic) BOOL debugSpritesEnabled;
@property (assign, nonatomic) SKSpriteNode *boardAreaDebug;
@property (assign, nonatomic) SKSpriteNode *gameBoardColor;

@end


@implementation SGCookieDunkDunkScene

#pragma mark - Init

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        // CURSE YOU FOR COMMENTING THIS OUT!!!!
       // [self createSceneContents];
        
        [self becomeFirstResponder];
        _contentCreated = YES;
    }
}

- (void)createSceneContents
{
    _gameDidEnd = NO;
    
    _createdPopup = NO;

}

- (void)createTheScoreLabel {
    
    self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    
   // self.scoreLabel = [[SKLabelNode alloc]initWithFontNamed:@"Evanescent"];
    
   // self.scoreLabel.fontColor = [SKColor greenColor];
    
   // self.scoreLabel.fontSize = 24;
    
   // self.scoreLabel.position = CGPointMake(kScreenWidth * 0.5f, kScreenHeight - 30.f);
                                       //self.frame.size.height-(//_scoreLabel.frame.size.height/2)-10);
    
    
    switch ([SGGameManager gameManager].mainGoalType) {
        case GoalTypes_TOTALSCORE:
            //_scoreLabel.text = @"Total Score!";
            break;
            
        case GoalTypes_INGREDIENT:
            //_scoreLabel.text = @"Ingredients!";
            break;
            
        case GoalTypes_STARCOUNT:
            //_scoreLabel.text = @"Star Count!";
            break;
            
        case GoalTypes_TYPECLEAR:
            //_scoreLabel.text = @"Item Removal!";
            break;
            
        default:
            //_scoreLabel.text = @"Derp";
//            DebugLog(@"Error: Unrecognized goal type: %d", [SGGameManager gameManager].goalType);
            break;
    }
    
    /*
    if ([SGGameManager gameManager].goalType == GoalTypes_TOTALSCORE)
    {
        //_scoreLabel.text = [NSString stringWithFormat:@"Score: %i/%i", _score, _maxScore];
    }
    else if ([SGGameManager gameManager].goalType == GoalTypes_STARCOUNT)
    {
        //_scoreLabel.text = [NSString stringWithFormat:@"Score: %i/%i", _score, _bronzeStarScore];
    }
    else if ([SGGameManager gameManager].goalType == GoalTypes_TYPECLEAR)
    {
        //_scoreLabel.text = [NSString stringWithFormat:@"%@: %i/%i", _clearTypeName, _clearTypeDeletionCount, _clearTypeDeletionCountMax];
    }
    else
    {
       // //_scoreLabel.text = [NSString stringWithFormat:@""];
    }
     */
    
   // //_scoreLabel.zPosition = 150;
    
   // [self addChild:self.scoreLabel];
}


- (void)setup
{
    
    _debugSpritesEnabled = NO; //YES; // <<< Enable this to show the boxes that the gameBoard sits in.
    
    _gameDidEnd = NO;
    
    _createdPopup = NO;
    
    
    _didSetFaceArrayToRandom = NO;
    _didSetFaceArrayForFirstTime = NO;
    
    _cyclingCookie = NO;
    _setCookie = NO;
    
    _didMoveCookie = NO;
    
    _didMakeValidMove = NO;
    
    _blockArray = [NSMutableArray new];
    
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    // Levels will be checked as 0 - 29 then + 1 to get 1 - 30
    int imageNumber = 1;
    if ( ([SGGameManager gameManager].what_level_am_I_at - 1) % 30  + 1 > 15)
    {
        imageNumber = 2;
    }
    
    // Background image offset from planet plist
    CGPoint offset = CGPointZero;
    offset = CGPointFromString([SGGameManager gameManager].backgroundImageOffsetArray[imageNumber - 1]);

    // World background image.
    NSString *imageName =  [NSString stringWithFormat:@"cdd-world-%@-background-image-%i-568h@2x",
                            [SGGameManager gameManager].planetName, imageNumber];
    
    self.sceneryBackgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
   
    // Half the image size since we are not working in @2x
    float imageWidth = self.sceneryBackgroundSprite.size.width / 2;
    float imageHeight = self.sceneryBackgroundSprite.size.height / 2;
    
    self.sceneryBackgroundSprite.size = CGSizeMake(imageWidth, imageHeight);
    
    if (IS_IPHONE_5)
    {
        self.sceneryBackgroundSprite.position = CGPointMake(kScreenWidth - (imageWidth / 2) + offset.x, imageHeight / 2 + offset.y);
    }
    else if (IS_IPHONE_4)
    {
        self.sceneryBackgroundSprite.position = CGPointMake(kScreenWidth - (imageWidth / 2) + offset.x, kScreenHeight - (imageHeight / 2) + offset.y);
    }
    else
    {
        self.sceneryBackgroundSprite.size = CGSizeMake(kScreenHeight, kScreenHeight);
        self.sceneryBackgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    }
    
    self.sceneryBackgroundSprite.zPosition = -10;
    [self addChild:self.sceneryBackgroundSprite];
    
    //_sceneryBackgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    //_sceneryBackgroundSprite.size = CGSizeMake(kScreenHeight, kScreenHeight);
    //_sceneryBackgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    //_sceneryBackgroundSprite.zPosition = -10;
    
    //_sceneryBackgroundSprite = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:self.size];
    //[_sceneryBackgroundSprite setTexture:[SKTexture sgtextureWithImageNamed:@"background-image-2-dunkopolis"]];
    //[self addChild:_sceneryBackgroundSprite];
    
//    // Random UI
    
    //[[SGFileManager fileManager] listAllFonts];
    
    // SFSlapstickComic-Bold
    
    // Fade
    CGSize bgSize;
    // Grab whichever axis is longer, so we're guarenteed to
    // still cover everything while the device rotates.
    if (self.size.width > self.size.height) {
        bgSize = CGSizeMake(self.size.width, self.size.width);
    } else {
        bgSize = CGSizeMake(self.size.height, self.size.height);
    }
    _bgFadeSpriteNode = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:bgSize];
    _bgFadeSpriteNode.alpha = 0.25;
    //[SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0/255 green:29/255 blue:60/255 alpha:0.65] size:bgSize];
    [self addChild:_bgFadeSpriteNode];
    
    
    ///////////////
    // UI Panels //
    ///////////////
        
    // Top Bar
    SKTexture *topBarTexture = [SKTexture sgtextureWithImageNamed:@"cdd-hud-game-topbar-v"];
    _topBarSpriteNode = [SKSpriteNode spriteNodeWithTexture:topBarTexture];
    //_topBarSpriteNode.size = CGSizeMake(topBarTexture.size.width/2, topBarTexture.size.height/2);
    _topBarSpriteNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), self.scene.size.height - (_topBarSpriteNode.size.height/2));
    [self addChild:_topBarSpriteNode];
    
    ////_scoreLabelNode = [[SGLabelNode alloc] initWithFontNamed:kFontDamnNoisyKids];
    ////_scoreLabelNode.fontSize = 11;
    ////_scoreLabelNode.position = CGPointZero;
    ////_scoreLabelNode.horizontalAlignment = SKLabelHorizontalAlignmentModeLeft;
    //[////_scoreLabelNode setText:@"Score: 0"];
    //[_topBarSpriteNode addChild:////_scoreLabelNode];
    
    // Circle Panel
    SKTexture *circlePanelTexture = [SKTexture sgtextureWithImageNamed:@"cdd-hud-game-cookieboard-v"];
    _circlePanelSprite = [SKSpriteNode spriteNodeWithTexture:circlePanelTexture];
    _circlePanelSprite.size = CGSizeMake(circlePanelTexture.size.width, circlePanelTexture.size.height);
    
    //_targetGoalLabelNode = [[SGLabelNode alloc] initWithFontNamed:kFontDamnNoisyKids];
    //_targetGoalLabelNode.fontSize = 11;
    //_targetGoalLabelNode.fontColor = [UIColor whiteColor];
    //_targetGoalLabelNode.horizontalAlignment = SKLabelHorizontalAlignmentModeLeft;
    //[//_targetGoalLabelNode setText:@"No goal is set."];
    //[_circlePanelSprite addChild://_targetGoalLabelNode];
    
    //_secondGoalLabelNode = [[SGLabelNode alloc] initWithFontNamed:kFontDamnNoisyKids];
    //_secondGoalLabelNode.fontSize = 11;
    //_secondGoalLabelNode.fontColor = [UIColor whiteColor];
    //_secondGoalLabelNode.horizontalAlignment = SKLabelHorizontalAlignmentModeLeft;
    //[//_secondGoalLabelNode setText:@""];
    //[_circlePanelSprite addChild://_secondGoalLabelNode];
    
    //_limiterLabelNode = [[SGLabelNode alloc] initWithFontNamed:kFontDamnNoisyKids];
    //_limiterLabelNode.fontSize = 23;
    //_limiterLabelNode.position = CGPointZero;
    //_limiterLabelNode.horizontalAlignment = SKLabelHorizontalAlignmentModeCenter;
    //[//_limiterLabelNode setText:@"LMT"];
    
    //_limitTitleLabelNode = [[SGLabelNode alloc] initWithFontNamed:kFontDamnNoisyKids];
    //_limitTitleLabelNode.fontSize = 11;
    //_limitTitleLabelNode.horizontalAlignment = SKLabelHorizontalAlignmentModeCenter;
    //_limitTitleLabelNode.fontColor = [UIColor whiteColor];
    //[//_limitTitleLabelNode setText:@"Limiter"];
    
    [self addChild:_circlePanelSprite];
//    [_circlePanelSprite addChild:////_scoreLabelNode];
   // [_circlePanelSprite addChild://_limiterLabelNode];
   // [_circlePanelSprite addChild://_limitTitleLabelNode];
    
    
    // Milk Cup
    NSArray *liquidArray = [NSArray arrayWithObjects:[SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-game-scoreglassmilk"], [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-game-scoreglassmilk-alpha"], nil];
    NSArray *cupArray = [NSArray arrayWithObjects:[SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-game-scoreglassback"], [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-game-scoreglassfront"], nil];
    SGVector3 *starLevels = [SGVector3 vector3WithX:[SGGameManager gameManager].score_bronze Y:[SGGameManager gameManager].score_silver Z:[SGGameManager gameManager].score_gold];
    NSArray *starMarkersArray = [NSArray arrayWithObjects:[SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-game-scoreglassbronze"],
                                 [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-game-scoreglasssilver"],
                                 [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-game-scoreglassgold"],
                                 nil];
    _milkCup = [[CDFillableCupNode alloc] initWithLiquid:liquidArray
                                                            MaskOffset:CGPointMake(0.0f, 15.0f)
                                                                   Cup:cupArray
                                                             CupOffset:4.0f
                                                                 Straw:[SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-game-scoreglassstraw"]
                                                           StrawOffset:CGPointMake(-18.0f, 12.0f)
                                                            StarLevels:starLevels
                                                           StarMarkers:starMarkersArray];
    [self addChild:_milkCup];
    
    [SGGameManager gameManager].delegate = self;
    
//    float buffer = 4;
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        buffer = 24.0f;
//    
//    }
    
    //Dustin
    {
        [_boosterSelectedObject removeFromParent];
        self.ApplyPowerupOnCookie = EMPTY_ITEM;
        
    }
    
    _gameBoard = [SKNode new];
    _gameBoard.zPosition = 1;
    [self addChild:_gameBoard];
    [[SGGameManager gameManager] initBoardWithScene:self
                                        withGameBoard:_gameBoard];
    
    
    {
        //////////////////////
        // Debug Rectangles // (Toggle with '_debugSpritesEnabled')
        //////////////////////
        if (_debugSpritesEnabled) {
            _gameBoardColor = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(20, 20)];
            _gameBoardColor.name = @"gameBoardColor";
            [_gameBoard addChild:_gameBoardColor];
            
            _boardAreaDebug = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(20, 20)];
            _boardAreaDebug.name = @"boardAreaDebug";
            [self addChild:_boardAreaDebug];
        }
    }
    
    [self SetupHUDForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    
    // Dev Cheats
    [self setupAutocompleteButtons];
    
    // Remove the loading screen.
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(cookieDunkDunkSceneWillRemoveLoadingScreen)])
        {
            [weakSelf.delegate cookieDunkDunkSceneWillRemoveLoadingScreen];
        }
    });
}

- (void)SetupHUDForOrientation:(UIInterfaceOrientation)orientation {
    //DebugLog(@"Orientation is '%d'.", orientation);
    
    // We'll use these when working with the board.
    float gameBoardWidth = [SGGameManager gameManager].columnWidth * [SGGameManager gameManager].numColumns;
    float gameBoardHeight = [SGGameManager gameManager].RowHeight * [SGGameManager gameManager].numRows;
    float maxAxis = [self calculateMaxAxis];
    CGSize gameBoardVisibleSize = CGSizeMake(gameBoardWidth, gameBoardHeight);
    
    
    // Debug Stuff
    if (_debugSpritesEnabled) {
        [_gameBoardColor setSize:gameBoardVisibleSize];
        CGPoint gameBoardVisibleOffset = CGPointMake([SGGameManager gameManager].columnWidth/2, [SGGameManager gameManager].RowHeight/2);
        _gameBoardColor.position = CGPointMake((_gameBoardColor.size.width/2) + gameBoardVisibleOffset.x, (_gameBoardColor.size.height/2) + gameBoardVisibleOffset.y);
        //DebugLog(@"gameBoardColor = %@", _gameBoardColor);
        
        [_boardAreaDebug setSize:CGSizeMake(maxAxis, maxAxis)];
    }
    
    
    
    
    // The background is always centered.
    _bgFadeSpriteNode.position = CGPointMake(self.scene.size.width / 2, self.scene.size.height / 2);
    //_sceneryBackgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        //DebugLog(@"Device is landscape.");
        
        
        // Designate an area for the gameBoard to fit inside.
        _maxBoardArea = CGRectMake(((self.size.width - maxAxis) / 2) + (self.size.width * 0.135f), ((self.size.height - maxAxis) / 2), maxAxis, maxAxis);
        //DebugLog(@"maxBoardArea = %@", NSStringFromCGRect(_maxBoardArea));
        
        // Debug
        if (_debugSpritesEnabled) {
            _boardAreaDebug.position = CGPointMake(_maxBoardArea.origin.x + (_boardAreaDebug.size.width/2), _maxBoardArea.origin.y + (_boardAreaDebug.size.height/2));
        }

        // Circle Panel
        SKTexture *circlePanelTexture = [SKTexture sgtextureWithImageNamed:@"cdd-hud-game-cookieboard-h"];
        [_circlePanelSprite setTexture:circlePanelTexture];
        [_circlePanelSprite setSize:CGSizeMake(circlePanelTexture.size.width, circlePanelTexture.size.height)];
        _circlePanelSprite.position = CGPointMake(_circlePanelSprite.size.width * 0.51f, self.size.height - _circlePanelSprite.size.height * 0.51);
        
        
//        ////_scoreLabelNode.position = CGPointMake(-_circlePanelSprite.size.width * 0.345, -_circlePanelSprite.size.height * 0.2);
        //_targetGoalLabelNode.position = CGPointMake(-_circlePanelSprite.size.width * 0.345, -_circlePanelSprite.size.height * 0.254);
        
        
        //_secondGoalLabelNode.position = CGPointMake(-_circlePanelSprite.size.width * 0.345, -_circlePanelSprite.size.height * 0.38);
        //_limitTitleLabelNode.position = CGPointMake(-_circlePanelSprite.size.width * 0.13, _circlePanelSprite.size.height * 0.05);
        //_limiterLabelNode.position = CGPointMake(-_circlePanelSprite.size.width * 0.13, _circlePanelSprite.size.height * 0.167);
        
        // Top Bar
        SKTexture *topBarTexture = [SKTexture sgtextureWithImageNamed:@"cdd-hud-game-topbar-h"];
        [_topBarSpriteNode setTexture: topBarTexture];
        _topBarSpriteNode.size = CGSizeMake(topBarTexture.size.width, topBarTexture.size.height);
        _topBarSpriteNode.position = CGPointMake(_topBarSpriteNode.size.width * 0.61, (_circlePanelSprite.position.y - (_circlePanelSprite.size.height/2)) - _topBarSpriteNode.size.height * 0.52);
        
//        //_targetGoalLabelNode.position = CGPointMake(-_topBarSpriteNode.size.width * 0.445, _topBarSpriteNode.size.height * 0.185);
        ////_scoreLabelNode.position = CGPointMake(-_topBarSpriteNode.size.width * 0.440, _topBarSpriteNode.size.height * 0.185);
        
        for (CDButtonSpriteNode *button in _topBarBoostersArray) {
            [button setScale:0.9f];
            float xPos = (-_topBarSpriteNode.size.width * 0.428) + (button.size.width / 2) + ((button.size.width * 1.1) * [_topBarBoostersArray indexOfObject:button]);
            float yPos = -_topBarSpriteNode.size.height * 0.13f;
            button.position = CGPointMake(xPos, yPos);
        }
        
        // Milk Meter
        _milkCup.position = CGPointMake(_milkCup.cupFront.size.width * 2.2f, _milkCup.cupFront.size.height * 0.5f);
    }
    else {
        //DebugLog(@"Device is Portrait.");
        
        
        
        // Designate an area for the gameBoard to fit inside.
        _maxBoardArea = CGRectMake((self.size.width - maxAxis) / 2, ((self.size.height - maxAxis) / 2) + 30, maxAxis, maxAxis);
        //DebugLog(@"maxBoardArea = %@", NSStringFromCGRect(_maxBoardArea));
        
        // Debug
        if (_debugSpritesEnabled) {
            _boardAreaDebug.position = CGPointMake(((self.size.width - _maxBoardArea.size.width) / 2) + (_boardAreaDebug.size.width/2), ((self.size.height - _maxBoardArea.size.height) / 2) + (_boardAreaDebug.size.width/2) + 30);
        }
        
        // Top Bar
        SKTexture *topBarTexture = [SKTexture sgtextureWithImageNamed:@"cdd-hud-game-topbar-v"];
        [_topBarSpriteNode setTexture: topBarTexture];
        _topBarSpriteNode.size = CGSizeMake(topBarTexture.size.width, topBarTexture.size.height);
        _topBarSpriteNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), self.scene.size.height - (_topBarSpriteNode.size.height/2));
        
//        //_targetGoalLabelNode.position = CGPointMake(_topBarSpriteNode.size.width * 0.06, -_topBarSpriteNode.size.height * 0.13);
        ////_scoreLabelNode.position = CGPointMake(_topBarSpriteNode.size.width * 0.07, -_topBarSpriteNode.size.height * 0.13);
        
        for (CDButtonSpriteNode *button in _topBarBoostersArray) {
            [button setScale:1.2f];
            float xPos = (-_topBarSpriteNode.size.width / 2.1) + (button.size.width / 2) + ((button.size.width * 1.1) * [_topBarBoostersArray indexOfObject:button]);
            float yPos = -_topBarSpriteNode.size.height * 0.2f;
            button.position = CGPointMake(xPos, yPos);
        }
        
        // Circle Panel
        SKTexture *circlePanelTexture = [SKTexture sgtextureWithImageNamed:@"cdd-hud-game-cookieboard-v"];
        [_circlePanelSprite setTexture:circlePanelTexture];
        [_circlePanelSprite setSize:CGSizeMake(circlePanelTexture.size.width, circlePanelTexture.size.height)];
        _circlePanelSprite.position = CGPointMake(self.scene.frame.size.width - (_circlePanelSprite.size.width * 0.525), _circlePanelSprite.size.height * 0.60);
        
//        ////_scoreLabelNode.position = CGPointMake(-_circlePanelSprite.size.width * 0.45, -_circlePanelSprite.size.height * 0.028);
        //_targetGoalLabelNode.position = CGPointMake(-_circlePanelSprite.size.width * 0.45, -_circlePanelSprite.size.height * 0.08);
        
        
        //_secondGoalLabelNode.position = CGPointMake(-_circlePanelSprite.size.width * 0.45, -_circlePanelSprite.size.height * 0.3);
        //_limitTitleLabelNode.position = CGPointMake(_circlePanelSprite.size.width * 0.3, -_circlePanelSprite.size.height * 0.18);
        //_limiterLabelNode.position = CGPointMake(_circlePanelSprite.size.width * 0.3, -_circlePanelSprite.size.height * 0.03);
        
        // Milk Meter
        _milkCup.position = CGPointMake(_milkCup.cupFront.size.width * 2.2f, _milkCup.cupFront.size.height * 0.5f);
    }
}

- (float)calculateMaxAxis {
    // Game Board
    float maxAxis = 0.0;
    if (self.size.width > self.size.height) {
        maxAxis = self.size.height;
    } else {
        maxAxis = self.size.width;
    }
    maxAxis -= 18.0f; // Add some buffer space around the edges.
    //DebugLog(@"maxAxis = %f", maxAxis);
    return maxAxis;
}

//- (void)animateStarPowerBar
//{
//    self.milkBarSpriteCounter++;
//
//    SKSpriteNode *milkBarSprite = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-milkbar"];
//    
//    milkBarSprite.position = CGPointMake(self.milkBarSprite.position.x + (milkBarSprite.size.width * self.milkBarSpriteCounter) - 0.3f, 1);
//    
//    milkBarSprite.zPosition = 1;
//    
//    [self.milkMeterSprite addChild:milkBarSprite];
//    
////    SKAction *moveAction = [SKAction moveByX:(milkBarSprite.size.width * self.milkBarSpriteCounter)- 0.3f y:0.0f duration:0.3f];
////    [milkBarSprite runAction:moveAction];
//}



- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        // setup scen initialization here
        [self setup];

        DebugLog(@"Loading level music");
        
        // Play world theme music based on world type
        //NSNumber *worldType = [NSNumber numberWithInt:[[SGGameManager gameManager].worldType intValue] + 1];
        //[[SGAudioManager audioManager] playBackgroundMusicWithFilename:[NSString stringWithFormat:@"WorldTheme%@_Gameplay", worldType]  FileType:@"m4a" volume:0.2f numberOfLoopes:-1];
        
        // Could add an overloaded playBackgroundMusicWithFilename method that returns true/false file is loaded.
        // If true play worldtheme, otherwise play default GamePlay theme
        
        // Play default GamePlay music
        [[SGAudioManager audioManager] playBackgroundMusicWithFilename:[NSString stringWithFormat:@"CCDDD_THEME_MIX_GamePlay"]  FileType:@"m4a" volume:0.2f numberOfLoopes:-1];
    }
    return self;
}

#pragma mark - Update

- (void)update:(NSTimeInterval)currentTime
{
        
//    double delayInSeconds = 2;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//    {
//        [self dismissViewControllerAnimated:NO completion:^{
//            [_loadingScreen startMapMusic];
//            [_loadingScreen.view removeFromSuperview];
//        }];
//    });
    
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive)
	{
		self.view.paused = YES;
		self.paused = YES;
		
		[[SGAudioManager audioManager] pauseAllAudio];
	}
}



#pragma mark - Animations

- (void)FindAndAnimateCookie {
    
    
}

- (void)handleThrowAwayButton
{
    if (_throwAwayButton.boosterCount > 0)
    {
        _throwAwayButton.boosterCount -= 1;
        
        if (_throwAwayButton.boosterCount <= 0)
        {
            _throwAwayButton.color = [SKColor blackColor];
            _throwAwayButton.colorBlendFactor = 0.5;
        }
        
        if (_throwAwayButton.boosterCount <= 99)
        {
            [_throwAwayButton.boosterCountLabel setText:[NSString stringWithFormat:@"%i", _throwAwayButton.boosterCount]];
        }
        else if (_throwAwayButton.boosterCount > 99)
        {
            [_throwAwayButton.boosterCountLabel setText:@"99+"];
        }
        
        if ([_throwAwayButton.boosterName isEqualToString:@"spatula"] && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"spatula"] intValue] > 0))
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithDecreaseRadioActiveSprinkleValue:nil spatulaValue:[NSNumber numberWithInt:1] slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                DebugLog(@"Successfuly decreased %@", _throwAwayButton.boosterName);
            }];
        }
        else if ([_throwAwayButton.boosterName isEqualToString:@"nuke"] && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"nuke"] intValue] > 0))
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithDecreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:nil thunderboltValue:nil nukeValue:[NSNumber numberWithInt:1] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                DebugLog(@"Successfuly decreased %@", _throwAwayButton.boosterName);
            }];
        }
        else if ([_throwAwayButton.boosterName isEqualToString:@"fortune"] && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"fortune"] intValue] > 0))
        {
            
        }
        else if ([_throwAwayButton.boosterName isEqualToString:@"thunderbolt"] && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"thunderbolt"] intValue] > 0))
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithDecreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:nil thunderboltValue:[NSNumber numberWithInt:1] nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                DebugLog(@"Successfuly decreased %@", _throwAwayButton.boosterName);
            }];
        }
        else if ([_throwAwayButton.boosterName isEqualToString:@"slotMachine"] && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"slotMachine"] intValue] > 0))
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithDecreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:[NSNumber numberWithInt:1] thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                DebugLog(@"Successfuly decreased %@", _throwAwayButton.boosterName);
            }];
        }
        else if ([_throwAwayButton.boosterName isEqualToString:@"smore"] && ([[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"smore"] intValue] > 0))
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithDecreasePowerGloveValue:nil wrappedCookieValue:nil bombValue:nil smoreValue:[NSNumber numberWithInt:1] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                DebugLog(@"Successfuly decreased %@", _throwAwayButton.boosterName);
            }];
        }
        else if ([_throwAwayButton.boosterName isEqualToString:@"radioactiveSprinkle"] && ([[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"radioactiveSprinkle"] intValue] > 0))
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithDecreaseRadioActiveSprinkleValue:[NSNumber numberWithInt:1] spatulaValue:nil slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                DebugLog(@"Successfuly decreased %@", _throwAwayButton.boosterName);
            }];
        }
        else if ([_throwAwayButton.boosterName isEqualToString:@"powerGlove"] && ([[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"powerGlove"] intValue] > 0))
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithDecreasePowerGloveValue:[NSNumber numberWithInt:1] wrappedCookieValue:nil bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                DebugLog(@"Successfuly decreased %@", _throwAwayButton.boosterName);
            }];
        }
        else if ([_throwAwayButton.boosterName isEqualToString:@"wrapper"] && ([[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"wrappedCookie"] intValue] > 0))
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithDecreasePowerGloveValue:nil wrappedCookieValue:[NSNumber numberWithInt:1] bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                DebugLog(@"Successfuly decreased %@", _throwAwayButton.boosterName);
            }];
        }
    }
    
    [_boosterSelectedObject removeFromParent];
}

#pragma mark - Touches Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if([SGGameManager gameManager].isTakingInput == NO)
    {
        return;
    }
    
    if(_ApplyPowerupOnCookie == BOOSTER_NUKE){
        
        [[SGGameManager gameManager] Drop_The_Nuke];
        [CDPlayerObject player].hasUsedBomb = YES;
        
        [self handleThrowAwayButton];
        _ApplyPowerupOnCookie = EMPTY_ITEM;
        
        // Run the achievement.
        CDPlayerObject *player = [CDPlayerObject player];
        if (player.hasUsedBomb && player.hasUsedLightning && player.hasUsedSlotMachine && player.hasUsedSpatula) {
            SGGameCenterManager *gcManager = [SGGameCenterManager gcManager];
            // Achievement: Arcade.
            [gcManager reportAchievementWithIdentifier:@"cookie_boost" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
                if (reportWasSuccessful) {
                    [gcManager displayAchievementAlertForAchievementWithIdentifier:@"cookie_boost" InView:[SGAppDelegate appDelegate].window.rootViewController.view Completion:nil];
                }
            }];
        }
        
        return;
        
    }else if(_ApplyPowerupOnCookie == BOOSTER_SPATULA){
        
        [[SGGameManager gameManager] Spatula];
        [CDPlayerObject player].hasUsedSpatula = YES;
        
        // Here
        [self handleThrowAwayButton];
        [_boosterSelectedObject removeFromParent];
        _ApplyPowerupOnCookie = EMPTY_ITEM;
        
        // Run the achievement.
        CDPlayerObject *player = [CDPlayerObject player];
        if (player.hasUsedBomb && player.hasUsedLightning && player.hasUsedSlotMachine && player.hasUsedSpatula) {
            SGGameCenterManager *gcManager = [SGGameCenterManager gcManager];
            // Achievement: Arcade.
            [gcManager reportAchievementWithIdentifier:@"cookie_boost" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
                if (reportWasSuccessful) {
                    [gcManager displayAchievementAlertForAchievementWithIdentifier:@"cookie_boost" InView:[SGAppDelegate appDelegate].window.rootViewController.view Completion:nil];
                }
            }];
        }
        
        return;
        
    }
    
    if(_theSelectedPiece != nil)
        return;
    
    _theGameGrid = [[SGGameManager gameManager]  SetTheGameGrid];
    //[self FindAndAnimateCookie];
    
    for(UITouch* touch in touches)
    {
        CGPoint touchPos = [touch locationInNode:_gameBoard];
        for(int i=0; i<_theGameGrid.count; i++)
        {
            CDGameBoardSpriteNode* piece = [_theGameGrid objectAtIndex:i];
            if(piece.typeID == BOOSTER_SLOTMACHINE) // contains point includes children
            {

                float distance = sqrt(pow((piece.position.x - touchPos.x), 2.0) + pow((piece.position.y - touchPos.y), 2.0));
                
                if(distance < piece.size.width*0.5){
                    [[SGGameManager gameManager] StopThatSlotCookie:(CDCookieSpriteNode*)piece];
                    break;
                }
                
            }else
            if(piece.typeID != CLEAR_BLOCK && piece.typeID != EMPTY_ITEM)
            if([piece containsPoint:touchPos]){
                
                if([piece isKindOfClass:[CDCookieSpriteNode class]])
                {
                    CDCookieSpriteNode* cookie = (CDCookieSpriteNode*) piece;
                
                    if(_ApplyPowerupOnCookie > EMPTY_ITEM){
                        
                        CDPlayerObject *player = [CDPlayerObject player];
                        switch (_ApplyPowerupOnCookie) {
                            case POWERUP_SUPERGLOVE:
                                if(![[SGGameManager gameManager].SuperCookies containsObject:cookie] && cookie.typeID != POWERUP_SMORE && cookie.typeID != BOOSTER_SLOTMACHINE && ![[SGGameManager gameManager].WrappedCookies containsObject:cookie]){
                                    [[SGGameManager gameManager] PowerGlove:cookie];
                                    [CDPlayerObject player].hasUsedSuperGlove = YES;
                                    
                                    // Run the achievement.
                                    if (player.hasUsedSuperGlove && player.hasUsedRadSprinkle && player.hasUsedSmoreUpgrade && player.hasUsedWrapperUpgrade) {
                                        SGGameCenterManager *gcManager = [SGGameCenterManager gcManager];
                                        // Achievement: Arcade.
                                        [gcManager reportAchievementWithIdentifier:@"bucket_o_water" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
                                            if (reportWasSuccessful) {
                                                [gcManager displayAchievementAlertForAchievementWithIdentifier:@"bucket_o_water" InView:[SGAppDelegate appDelegate].window.rootViewController.view Completion:nil];
                                            }
                                        }];
                                    }
                                    [self handleThrowAwayButton];
                                    [_boosterSelectedObject removeFromParent];
                                    _ApplyPowerupOnCookie = EMPTY_ITEM;
                                }
                                break;
                                
                            case POWERUP_WRAPPER:
                                if(![[SGGameManager gameManager].WrappedCookies containsObject:cookie] && cookie.typeID != POWERUP_SMORE && cookie.typeID != BOOSTER_SLOTMACHINE && ![[SGGameManager gameManager].SuperCookies containsObject:cookie]){

                                    [[SGGameManager gameManager] Wrap_that_cookie:cookie];
                                    [CDPlayerObject player].hasUsedWrapperUpgrade = YES;
                                    
                                    // Run the achievement.
                                    if (player.hasUsedSuperGlove && player.hasUsedRadSprinkle && player.hasUsedSmoreUpgrade && player.hasUsedWrapperUpgrade) {
                                        SGGameCenterManager *gcManager = [SGGameCenterManager gcManager];
                                        // Achievement: Arcade.
                                        [gcManager reportAchievementWithIdentifier:@"bucket_o_water" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
                                            if (reportWasSuccessful) {
                                                [gcManager displayAchievementAlertForAchievementWithIdentifier:@"bucket_o_water" InView:[SGAppDelegate appDelegate].window.rootViewController.view Completion:nil];
                                            }
                                        }];
                                    }
                                    [self handleThrowAwayButton];
                                    [_boosterSelectedObject removeFromParent];
                                    _ApplyPowerupOnCookie = EMPTY_ITEM;
                                }
                                break;
                                
                            case POWERUP_SMORE:
                                if(![[SGGameManager gameManager].SuperCookies containsObject:cookie] && cookie.typeID != POWERUP_SMORE && cookie.typeID != BOOSTER_SLOTMACHINE && ![[SGGameManager gameManager].WrappedCookies containsObject:cookie]){
                                    [[SGGameManager gameManager] Smore_that_cookie:cookie];
                                    [CDPlayerObject player].hasUsedSmoreUpgrade = YES;
                                    
                                    // Run the achievement.
                                    if (player.hasUsedSuperGlove && player.hasUsedRadSprinkle && player.hasUsedSmoreUpgrade && player.hasUsedWrapperUpgrade) {
                                        SGGameCenterManager *gcManager = [SGGameCenterManager gcManager];
                                        // Achievement: Arcade.
                                        [gcManager reportAchievementWithIdentifier:@"bucket_o_water" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
                                            if (reportWasSuccessful) {
                                                [gcManager displayAchievementAlertForAchievementWithIdentifier:@"bucket_o_water" InView:[SGAppDelegate appDelegate].window.rootViewController.view Completion:nil];
                                            }
                                        }];
                                    }
                                    
                                    [self handleThrowAwayButton];
                                    [_boosterSelectedObject removeFromParent];
                                    _ApplyPowerupOnCookie = EMPTY_ITEM;
                                }
                                break;
                                
                            case BOOSTER_SLOTMACHINE:
                                if(![[SGGameManager gameManager].SuperCookies containsObject:cookie] && cookie.typeID != POWERUP_SMORE && cookie.typeID != BOOSTER_SLOTMACHINE && ![[SGGameManager gameManager].WrappedCookies containsObject:cookie]){
                                    [[SGGameManager gameManager] SlotThatCookie:cookie];
                                    [CDPlayerObject player].hasUsedSlotMachine = YES;
                                    
                                    // Run the achievement.
                                    if (player.hasUsedBomb && player.hasUsedLightning && player.hasUsedSlotMachine && player.hasUsedSpatula) {
                                        SGGameCenterManager *gcManager = [SGGameCenterManager gcManager];
                                        // Achievement: Arcade.
                                        [gcManager reportAchievementWithIdentifier:@"cookie_boost" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
                                            if (reportWasSuccessful) {
                                                [gcManager displayAchievementAlertForAchievementWithIdentifier:@"cookie_boost" InView:[SGAppDelegate appDelegate].window.rootViewController.view Completion:nil];
                                            }
                                        }];
                                    }
                                    [self handleThrowAwayButton];
                                    [_boosterSelectedObject removeFromParent];
                                    _ApplyPowerupOnCookie = EMPTY_ITEM;
                                }
                                break;
                                
                            case BOOSTER_LIGHTNING:
                                [[SGGameManager gameManager] SmashThatCookie:cookie];
                                [CDPlayerObject player].hasUsedLightning = YES;
                                
                                // Run the achievement.
                                if (player.hasUsedBomb && player.hasUsedLightning && player.hasUsedSlotMachine && player.hasUsedSpatula) {
                                    SGGameCenterManager *gcManager = [SGGameCenterManager gcManager];
                                    // Achievement: Arcade.
                                    [gcManager reportAchievementWithIdentifier:@"cookie_boost" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
                                        if (reportWasSuccessful) {
                                            [gcManager displayAchievementAlertForAchievementWithIdentifier:@"cookie_boost" InView:[SGAppDelegate appDelegate].window.rootViewController.view Completion:nil];
                                        }
                                    }];
                                }
                                
                                [self handleThrowAwayButton];
                                [_boosterSelectedObject removeFromParent];
                                _ApplyPowerupOnCookie = EMPTY_ITEM;
                                break;
                                
                            case BOOSTER_RADSPRINKLE:
                                if (![[SGGameManager gameManager].SuperCookies containsObject:cookie] && cookie.typeID != POWERUP_SMORE && cookie.typeID != BOOSTER_SLOTMACHINE && ![[SGGameManager gameManager].WrappedCookies containsObject:cookie])
                                {
                                    if ([[SGGameManager gameManager] RadiateThatCookie:cookie])
                                    {
                                        [CDPlayerObject player].hasUsedRadSprinkle = YES;
                                        
                                        // Run the achievement.
                                        if (player.hasUsedSuperGlove && player.hasUsedRadSprinkle && player.hasUsedSmoreUpgrade && player.hasUsedWrapperUpgrade) {
                                            SGGameCenterManager *gcManager = [SGGameCenterManager gcManager];
                                            // Achievement: Arcade.
                                            [gcManager reportAchievementWithIdentifier:@"bucket_o_water" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
                                                if (reportWasSuccessful) {
                                                    [gcManager displayAchievementAlertForAchievementWithIdentifier:@"bucket_o_water" InView:[SGAppDelegate appDelegate].window.rootViewController.view Completion:nil];
                                                }
                                            }];
                                        }
                                        [self handleThrowAwayButton];
                                    }
                                    _ApplyPowerupOnCookie = EMPTY_ITEM;
                                    [_boosterSelectedObject removeFromParent];
                                }
                                break;
                                
                            default: //_ApplyPowerupOnCookie = EMPTY_ITEM;
                                break;
                        }
                        

                    }else{
                        
                        // now check its type for slot
                        if(cookie.typeID == CLEAR_BLOCK || cookie.typeID == EMPTY_ITEM){
                            
                            // don't do anything
                            
                        }else
                         if(cookie.isLocked){
                            
                            // do nothing
                            
                        }else
                            _theSelectedPiece = piece;
                    }
                    
                }// is cookie
                else
                if([piece isKindOfClass:[CDIngredientSpriteNode class]])
                {
                    if(piece.isLocked){
                    
                    }else{
                    
                        CDIngredientSpriteNode* ingredient = (CDIngredientSpriteNode*) piece;

                        _theSelectedPiece = ingredient;
    
                    }
                    
                }// is an Ingredient
                else
                    if(piece.typeID == BLOCKER_PRETZEL)
                    {
                        if(piece.isLocked){
                            
                        }else{
                            
                            CDPretzelSpriteNode* pretzel = (CDPretzelSpriteNode*) piece;
                            
                            _theSelectedPiece = pretzel;
                            
                        }
                        
                    }// is a pretzel
                
                
                break;
            }//containsPoint
        }//for
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if([SGGameManager gameManager].isTakingInput == NO)
    {
        DebugLog(@"no taking input");
        return;
    }
    
    if(_theSelectedPiece == nil)
        return;
    
    for(UITouch* touch in touches){
        
        CGPoint touchPos = [touch locationInNode:_gameBoard];
        
        CGVector dragDirection = CGVectorMake(touchPos.x - _theSelectedPiece.position.x, touchPos.y - _theSelectedPiece.position.y);// target - self
        
        float XPositive = dragDirection.dx;
        if(XPositive < 0)
            XPositive *= -1.0f;
        
        float YPositive = dragDirection.dy;
        if(YPositive < 0)
            YPositive *= -1.0f;
        
        
        if(XPositive > YPositive){ // horizontal swap
            if(dragDirection.dx > 0) // right
            {
                if(_theSelectedPiece.column < [SGGameManager gameManager].numColumns-1){
                    _theOtherPiece = [_theGameGrid objectAtIndex:(_theSelectedPiece.row * [SGGameManager gameManager].numColumns) + (_theSelectedPiece.column+1)];
                }
                else{
                    _theOtherPiece = nil;
                }
                
            }
            else{ // left
                if(_theSelectedPiece.column > 0){
                    _theOtherPiece = [_theGameGrid objectAtIndex:(_theSelectedPiece.row * [SGGameManager gameManager].numColumns) + (_theSelectedPiece.column-1)];
                }
                else{
                    _theOtherPiece = nil;
                }
            }
            
        }else{ // vertical
            
            if(dragDirection.dy > 0) // up
            {
                if(_theSelectedPiece.row < [SGGameManager gameManager].numRows-1){
                    _theOtherPiece = [_theGameGrid objectAtIndex:((_theSelectedPiece.row+1) * [SGGameManager gameManager].numColumns) + _theSelectedPiece.column];
                }
                else{
                    _theOtherPiece = nil;
                }
            }
            else{ // down
                
                if(_theSelectedPiece.row > 0){
                    _theOtherPiece = [_theGameGrid objectAtIndex:((_theSelectedPiece.row-1) * [SGGameManager gameManager].numColumns) + _theSelectedPiece.column];
                }
                else{
                    _theOtherPiece = nil;
                }
            }
        }
    }// touches
    
    if(_theOtherPiece.typeID == BLOCKER_COOKIEDOUGH || _theOtherPiece.typeID == CLEAR_BLOCK || _theOtherPiece.typeID == EMPTY_ITEM || _theOtherPiece.isLocked || _theOtherPiece.typeID == BLOCKER_ICECREAM)
        _theOtherPiece = nil;
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(_theSelectedPiece == nil || _theOtherPiece == nil){
        
        _theSelectedPiece = nil;
        _theOtherPiece = nil;
        
        return;
    }
    
    
    
    if([SGGameManager gameManager].isTakingInput == NO)
        DebugLog(@"no taking input");
    else{
        DebugLog(@"am taking input");
        
        
        [SGGameManager gameManager].isTakingInput = NO;
        
        //switch
        
        CGPoint newPoint1 = _theSelectedPiece.position;
        float row1 = _theSelectedPiece.row;
        float column1 = _theSelectedPiece.column;
        
        CGPoint newPoint2 = _theOtherPiece.position;
        float row2 = _theOtherPiece.row;
        float column2 = _theOtherPiece.column;
        
        _theSelectedPiece.row = row2;
        _theSelectedPiece.column = column2;
        
        _theOtherPiece.row = row1;
        _theOtherPiece.column = column1;
        
        [_theSelectedPiece removeAllActions];
        [_theOtherPiece removeAllActions];
        
        [[SGGameManager gameManager] PlaySwitchAnimation:_theSelectedPiece];
        [[SGGameManager gameManager] PlaySwitchAnimation:_theOtherPiece];
        
        [_theSelectedPiece runAction:[SKAction moveTo:newPoint2 duration:0.25] completion:^{
            
            _theSelectedPiece.position = newPoint2;
            
        }];
        [_theOtherPiece runAction:[SKAction moveTo:newPoint1 duration:0.25] completion:^{
            
            _theOtherPiece.position = newPoint1;
            
        }];
        
        [self runAction:[SKAction waitForDuration:0.1] completion:^{
            
            [[SGGameManager gameManager] Play_swipe_sound];
            
        }];
        
        [self runAction:[SKAction waitForDuration:0.5] completion:^{
            
            // this is where it needs to handle the rest of this method
            
            DebugLog(@"seting the grid");
            
            _theGameGrid = [[SGGameManager gameManager]  SetTheGameGrid];
            
            DebugLog(@"checking swap");
            
            // if the swap was not good
            if(![[SGGameManager gameManager]  checkSwap:_theSelectedPiece secondPiece:_theOtherPiece])
            {
                
                DebugLog(@"bad swap");
                
                // swith back
                
                // Swap error sound.
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ClearThroat" FileType:@"caf"]; //@"m4a"];
                
                
                CGPoint newPoint1 = _theSelectedPiece.position;
                float row1 = _theSelectedPiece.row;
                float column1 = _theSelectedPiece.column;
                
                CGPoint newPoint2 = _theOtherPiece.position;
                float row2 = _theOtherPiece.row;
                float column2 = _theOtherPiece.column;
                
                _theSelectedPiece.row = row2;
                _theSelectedPiece.column = column2;
                
                _theOtherPiece.row = row1;
                _theOtherPiece.column = column1;
                
                [_theSelectedPiece removeAllActions];
                [_theOtherPiece removeAllActions];
                
                [[SGGameManager gameManager] PlaySwitchBackAnimation:_theSelectedPiece];
                [[SGGameManager gameManager] PlaySwitchBackAnimation:_theOtherPiece];
                
                [_theSelectedPiece runAction:[SKAction moveTo:newPoint2 duration:0.25] completion:^{
                    
                    _theSelectedPiece.position = newPoint2;
                    
                }];
                [_theOtherPiece runAction:[SKAction moveTo:newPoint1 duration:0.25] completion:^{
                    
                    _theOtherPiece.position = newPoint1;
                    
                }];
                
                [self runAction:[SKAction waitForDuration:0.1] completion:^{
                    
                    [[SGGameManager gameManager] Play_swipe_sound];
                    
                }];
                
                [self runAction:[SKAction waitForDuration:0.5] completion:^{
                    
                    _theSelectedPiece = nil;
                    _theOtherPiece = nil;
                    
                    [SGGameManager gameManager].isTakingInput = YES;
                    
                    
                }];
                
            }else{
                
                
            }
            
        }];
    }
}


- (void)displayPopup
{
    self.scene.paused = YES;
    
    _throwAwayButton.boosterName = nil;
    _parentController.chargedItem = EMPTY_ITEM;
    _ApplyPowerupOnCookie = EMPTY_ITEM;
    
    [_boosterSelectedObject removeFromParent];
    
    if ([self.delegate respondsToSelector:@selector(cookieDunkDunkMainGameDidEnd:)])
    {
        [self.delegate cookieDunkDunkMainGameDidEnd:self];
    }
}

#pragma mark - Topbar Boosters

- (void)cdButtonSpriteNode:(CDButtonSpriteNode *)buttonSprite wasSelectedForItemType:(ItemType)itemType {
    // CRASHLYTICS
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"BPop1" FileType:@"caf"]; //@"m4a"];
    NSString *itemName = [[SGFileManager fileManager] loadArrayWithFileName:@"itemtypes-master-list" OfType:@"plist"][itemType];
    DebugLog(@"You selected to use a %@. Be careful where you put it.", itemName);
    if ([self.delegate respondsToSelector:@selector(itemButton:wasSelectedForItemType:)])
    {
        [self.delegate itemButton:buttonSprite wasSelectedForItemType:itemType];
    }
}

#pragma mark - SGGameManagerDelegate

- (void)gameManager:(SGGameManager *)manager didEndGameWithWinOrLoose:(BOOL)didWin
{
    if(didWin)
    {
        // Congrats
        
        DebugLog(@"You win");
        
        
    }
    else
    {
        
        // Offer more moves
        
        DebugLog(@" You Loose");
        
        
        
    }
}

- (void)quit:(BOOL)shouldContinue {
    if ([self.delegate respondsToSelector:@selector(sgCookieDunkDunkSceneDidQuit:shouldContinue:)]) {
        [self.delegate sgCookieDunkDunkSceneDidQuit:self shouldContinue:shouldContinue];
    }
}



#pragma mark - Dev Cheats

- (void)setupAutocompleteButtons {
    if (DevModeActivated) {
        // Lose
        SGButtonSpriteNode *loseButton = [[SGButtonSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(40, 18)];
        loseButton.delegate = self;
        loseButton.tag = [NSNumber numberWithInt:0];
        loseButton.position = CGPointMake(self.size.width * 0.93f, self.size.height * 0.03f);
        [loseButton.textLabel setText:@"Lose"];
        [self addChild:loseButton];
        
        // 1 Star
        SGButtonSpriteNode *win1StarButton = [[SGButtonSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(40, 18)];
        win1StarButton.delegate = self;
        win1StarButton.tag = [NSNumber numberWithInt:1];
        win1StarButton.position = CGPointMake(self.size.width * 0.8f, self.size.height * 0.03f);
        win1StarButton.textLabel.text = @"1 Star";
        [self addChild:win1StarButton];
        
        // 2 Star
        SGButtonSpriteNode *win2StarButton = [[SGButtonSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(40, 18)];
        win2StarButton.delegate = self;
        win2StarButton.tag = [NSNumber numberWithInt:2];
        win2StarButton.position = CGPointMake(self.size.width * 0.93f, self.size.height * 0.07f);
        win2StarButton.textLabel.text = @"2 Star";
        [self addChild:win2StarButton];
        
        // 3 Star
        SGButtonSpriteNode *win3StarButton = [[SGButtonSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(40, 18)];
        win3StarButton.delegate = self;
        win3StarButton.tag = [NSNumber numberWithInt:3];
        win3StarButton.position = CGPointMake(self.size.width * 0.8f, self.size.height * 0.07f);
        win3StarButton.textLabel.text = @"3 Star";
        [self addChild:win3StarButton];
    }
}

- (void)buttonSpriteNodeWasSelected:(SGButtonSpriteNode *)button {
    if ([button.tag isEqualToNumber:[NSNumber numberWithInt:0]]) {
        DebugLog(@"Dev -> Lose");
        [[SGGameManager gameManager] autoLose];
    }
    else if ([button.tag isEqualToNumber:[NSNumber numberWithInt:1]]) {
        DebugLog(@"Dev -> Win: 1 Star");
        [[SGGameManager gameManager] autoWinWithStarCount:1];
    }
    else if ([button.tag isEqualToNumber:[NSNumber numberWithInt:2]]) {
        DebugLog(@"Dev -> Win: 2 Star");
        [[SGGameManager gameManager] autoWinWithStarCount:2];
    }
    else if ([button.tag isEqualToNumber:[NSNumber numberWithInt:3]]) {
        DebugLog(@"Dev -> Win: 3 Star");
        [[SGGameManager gameManager] autoWinWithStarCount:3];
    }
}




@end
