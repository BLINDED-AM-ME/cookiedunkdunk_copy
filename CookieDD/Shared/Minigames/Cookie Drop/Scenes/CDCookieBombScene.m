//
//  CDCookieBombScene.m
//  CookieDD
//
//  Created by Gary Johnston on 7/20/13.
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

#import "CDCookieBombScene.h"
#import "CDParticleEmitter.h"
#import "CDCookieBombMonster.h"
#import "SGAppDelegate.h"

@interface CDCookieBombScene() <SKPhysicsContactDelegate>

@property (strong, nonatomic) CDCookieBombMonster *milkMonster;


@property (strong, nonatomic) SKSpriteNode *rightWallObject;
@property (strong, nonatomic) SKSpriteNode *leftWallObject;
@property (strong, nonatomic) SKSpriteNode *floorObject;
@property (strong, nonatomic) SKSpriteNode *cookieObject;

@property (strong, nonatomic) SKTextureAtlas *atlas;

@property (strong, nonatomic) SKTexture *cupMiddleTexture;
@property (strong, nonatomic) SKTexture *milkSlosh1Texture;
@property (strong, nonatomic) SKTexture *milkSlosh2Texture;
@property (strong, nonatomic) SKTexture *milkSlosh3Texture;
@property (strong, nonatomic) SKTexture *milkSlosh4Texture;

@property (strong, nonatomic) SKLabelNode *timerLabel;

@property (strong, nonatomic) SKAction *animateMilk;

@property (strong, nonatomic) NSArray *milkAnimationArray;
@property (strong, nonatomic) NSArray *windowPositionArray;
@property (strong, nonatomic) NSMutableArray *existingBoxesArray;

@property (assign, nonatomic) BOOL contentCreated;
@property (assign, nonatomic) BOOL didCreatePopup;
@property (assign, nonatomic) BOOL hasStarted;
@property (assign, nonatomic) BOOL didWin;
@property (assign, nonatomic) BOOL createNewBoxes;
@property (assign, nonatomic) BOOL splashAnimationIsPlaying;

@property (assign, nonatomic) CGPoint lastPositionOfMilk;

@property (assign, nonatomic) int score;
@property (assign, nonatomic) int missedCount;
@property (assign, nonatomic) int cookieDropCounter;
@property (assign, nonatomic) int cookieDropTimer;
@property (assign, nonatomic) int goalScore;
@property (assign, nonatomic) int boxCount;
@property (assign, nonatomic) int maxBoxCount;
@property (assign, nonatomic) int windowRowCount;
@property (assign, nonatomic) int boxSpawnTimer;
@property (assign, nonatomic) int boxLifeSpanTimer;
@property (assign, nonatomic) int cantFindAnOpenWindowCount;
@property (assign, nonatomic) int cantFindAnOpenWindowCountMax;

@property (assign, nonatomic) float previousBoxTime;
@property (assign, nonatomic) float previousTime;

// Sound

@property (strong, nonatomic) NSArray *milkMonsterScreamStrings;
@property (assign, nonatomic) int milkMonsterVolume;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound1;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound2;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound3;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound4;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound5;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound6;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound7;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound8;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound9;
//@property (strong, nonatomic) AVAudioPlayer* MilkMonsterSound10;

@property (strong, nonatomic) NSArray *cookieScreamStrings;
@property (assign, nonatomic) int whichScream;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound1;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound2;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound3;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound4;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound5;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound6;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound7;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound8;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound9;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound10;
@property (strong, nonatomic) AVAudioPlayer* ScreamSound11;

@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie1;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie2;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie3;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie4;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie5;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie6;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie7;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie8;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie9;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie10;
@property (strong, nonatomic) SKSpriteNode* ScreamSoundCookie11;





//@property (strong, nonatomic) SKAction* SplashSound1;
//@property (strong, nonatomic) SKAction* SplashSound2;
//@property (strong, nonatomic) SKAction* SplashSound3;

//@property (strong, nonatomic) SKAction* ThrowSound1;
//@property (strong, nonatomic) SKAction* ThrowSound2;
//@property (strong, nonatomic) SKAction* ThrowSound3;
//@property (strong, nonatomic) SKAction* ThrowSound4;
//@property (strong, nonatomic) SKAction* ThrowSound5;

//@property (strong, nonatomic) SKAction* HitSound1;
//@property (strong, nonatomic) SKAction* HitSound2;
//@property (strong, nonatomic) SKAction* HitSound3;
//@property (strong, nonatomic) SKAction* HitSound4;

@property (strong, nonatomic) AVAudioPlayer *splashPlayer;




@end


@implementation CDCookieBombScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        
    }
    return self;
}

- (void)createSceneContents
{
//    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    //[[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"cookieDrop_theme" FileType:@"m4a" volume:0.3f numberOfLoopes:-1];
    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"cookieDrop_theme" FileType:@"caf" volume:0.3f numberOfLoopes:-1];
    
    
    
    self.score = 0;
    self.boxCount = 0;
    self.windowRowCount = 4;
    self.cookieDropCounter = 0;
    
    self.cantFindAnOpenWindowCount = 0;
    self.cantFindAnOpenWindowCount = 3;
    
    self.cookieDropTimer = .5; // in seconds!!!!
    self.cookieDropTimer *= 60; // to adjust for frame rate....
    
    self.canMoveCup = NO;
    self.didWin = NO;
    self.createNewBoxes = NO;
    self.splashAnimationIsPlaying = NO;
    
    self.existingBoxesArray = [NSMutableArray new];
    
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    self.physicsWorld.contactDelegate = self;
    self.name = @"scene";
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    self.physicsBody.categoryBitMask = sceneCategory;
    self.physicsBody.contactTestBitMask = cookieCategory;
    self.physicsBody.collisionBitMask = cookieCategory;
//    self.physicsWorld.gravity = CGVectorMake(0, -250);
    
    BOOL retina = NO;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
    {
        retina = YES;
    }
    
    if (IS_IPHONE_4)
    {
        if (retina)
        {
            self.atlas = [SKTextureAtlas atlasNamed:@"cookieBomb_iphone5"];

        }
    }
    else if (IS_IPHONE_5)
    {
        self.atlas = [SKTextureAtlas atlasNamed:@"cookieBomb_iphone5"];
    }
    else if (IS_IPAD)
    {
        if (retina)
        {
            self.atlas = [SKTextureAtlas atlasNamed:@"cookieBomb_ipad_retina"];
            
        }
        else
        {
            self.atlas = [SKTextureAtlas atlasNamed:@"cookieBomb_ipad"];
        }
    }
    
    [self addChildren];
    self.currentSeconds = 500;
    self.previousTime = 0.0f;
    
    self.hasStarted = NO;
    
    self.milkMonsterVolume = 2;
    
    self.milkMonsterScreamStrings = [NSArray arrayWithObjects:
                                     @"Cookie_Drop_Milk_Monster1",
                                     @"Cookie_Drop_Milk_Monster2",
                                     @"Cookie_Drop_Milk_Monster3",
                                     @"Cookie_Drop_Milk_Monster4",
                                     @"Cookie_Drop_Milk_Monster5",
                                     @"Cookie_Drop_Milk_Monster6",
                                     @"Cookie_Drop_Milk_Monster7",
                                     @"Cookie_Drop_Milk_Monster8",
                                     @"Cookie_Drop_Milk_Monster9",
                                     nil];
    
//    self.MilkMonsterSound1 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster1" withType:@"m4a"];
//    self.MilkMonsterSound2 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster2" withType:@"m4a"];
//    self.MilkMonsterSound3 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster3" withType:@"m4a"];
//    self.MilkMonsterSound4 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster4" withType:@"m4a"];
//    self.MilkMonsterSound5 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster5" withType:@"m4a"];
//    self.MilkMonsterSound6 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster6" withType:@"m4a"];
//    self.MilkMonsterSound7 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster7" withType:@"m4a"];
//    self.MilkMonsterSound8 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster8" withType:@"m4a"];
//    self.MilkMonsterSound9 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster9" withType:@"m4a"];
////    self.MilkMonsterSound10 = [SGAudioManager MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Milk_Monster10" withType:@"m4a"];
    
    
    
    self.cookieScreamStrings = [NSArray arrayWithObjects:
                                @"Cookie_Drop_Scream1",
                                @"Cookie_Drop_Scream2",
                                @"Cookie_Drop_Scream3",
                                @"Cookie_Drop_Scream4",
                                @"Cookie_Drop_Scream5",
                                @"Cookie_Drop_Scream6",
                                @"Cookie_Drop_Scream7",
                                @"Cookie_Drop_Scream8",
                                @"Cookie_Drop_Scream9",
                                @"Cookie_Drop_Scream10",
                                @"Cookie_Drop_Scream11",
                                nil];
    
//    self.ScreamSound1 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream1" withType:@"m4a"];
//    self.ScreamSound1.numberOfLoops= -1;
//    self.ScreamSound2 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream2" withType:@"m4a"];
//    self.ScreamSound2.numberOfLoops= -1;
//    self.ScreamSound3 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream3" withType:@"m4a"];
//    self.ScreamSound3.numberOfLoops= -1;
//    self.ScreamSound4 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream4" withType:@"m4a"];
//    self.ScreamSound4.numberOfLoops= -1;
//    self.ScreamSound5  = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream5" withType:@"m4a"];
//    self.ScreamSound5.numberOfLoops= -1;
//    self.ScreamSound6  = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream6" withType:@"m4a"];
//    self.ScreamSound6.numberOfLoops= -1;
//    self.ScreamSound7 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream7" withType:@"m4a"];
//    self.ScreamSound7.numberOfLoops= -1;
//    self.ScreamSound8 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream8" withType:@"m4a"];
//    self.ScreamSound8.numberOfLoops= -1;
//    self.ScreamSound9 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream9" withType:@"m4a"];
//    self.ScreamSound9.numberOfLoops= -1;
//    self.ScreamSound10 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream10" withType:@"m4a"];
//    self.ScreamSound10.numberOfLoops= -1;
//    self.ScreamSound11 = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Drop_Scream11" withType:@"m4a"];
//    self.ScreamSound11.numberOfLoops= -1;

//    self.SplashSound1 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Splashes1" withFileType:@".m4a"];
//    self.SplashSound2 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Splashes2" withFileType:@".m4a"];
//    self.SplashSound3 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Splashes3" withFileType:@".m4a"];
//    self.ThrowSound1 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Throws1" withFileType:@".m4a"];
//    self.ThrowSound2 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Throws2" withFileType:@".m4a"];
//    self.ThrowSound3 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Throws3" withFileType:@".m4a"];
//    self.ThrowSound4 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Throws4" withFileType:@".m4a"];
////    self.ThrowSound5 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Throws5" withFileType:@".m4a"];
//    
//    self.HitSound1 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit1" withFileType:@".wav"];
//    self.HitSound2 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit2" withFileType:@".wav"];
//    self.HitSound3 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit3" withFileType:@".wav"];
//    self.HitSound4 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit4" withFileType:@".wav"];
}

- (void)setup
{
    _hasStarted = NO;
    self.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(cookieBombDifficultySelect:)])
    {
        [self.delegate cookieBombDifficultySelect:self];
    }
}

- (void)startMiniGame
{
    self.userInteractionEnabled = YES;
    _canMoveCup = YES;
    _hasStarted = YES;

    SKAction *milkmansCue = [SKAction sequence:@[[SKAction runBlock:^{[self CueTheMilkman];}],
                                                 [SKAction waitForDuration:10]]];
    [self runAction:[SKAction repeatActionForever:milkmansCue]];
    
    switch (_difficulty)
    {
        case gameDifficultyLevelEasy:
            _maxSeconds = 60;
            _goalScore = 20;
            _maxBoxCount = 5;
            _boxLifeSpanTimer = 10;
            _boxSpawnTimer = _boxLifeSpanTimer + 10;
            break;
            
        case gameDifficultyLevelMedium:
            _maxSeconds = 60;
            _goalScore = 30;
            _maxBoxCount = 5;
            _boxLifeSpanTimer = 3;
            _boxSpawnTimer = _boxLifeSpanTimer + 3;
            break;
            
        case gameDifficultyLevelHard:
            _maxSeconds = 60;
            _goalScore = 30;
            _maxBoxCount = 10;
            _boxLifeSpanTimer = 10;
            _boxSpawnTimer = _boxLifeSpanTimer;
            break;
            
        case gameDifficultyLevelCrazy:
            _maxSeconds = 45;
            _goalScore = 30;
            _maxBoxCount = 10;
            _boxLifeSpanTimer = 5;
            _boxSpawnTimer = _boxLifeSpanTimer;
            break;
            
        default:
            break;
    }
    
    _currentSeconds = _maxSeconds;
    
    _boxCount = _maxBoxCount;
    
    int minutes = _currentSeconds/60;
    int seconds = _currentSeconds%60;
    
    [_timerLabel setText:[NSString stringWithFormat:@"%02i:%02i", minutes, seconds]];
    _timerLabel.hidden = NO;
    
    _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
    _scoreLabel.hidden = NO;
}

- (void)addChildren
{
    SKSpriteNode *backgroundObject;
    if (IS_IPHONE_5)
    {
        backgroundObject = [SKSpriteNode spriteNodeWithImageNamed:@"cookieBomb_background-568h"];
    }
    else
    {
        backgroundObject = [SKSpriteNode spriteNodeWithImageNamed:@"cookieBomb_background"];
    }
    backgroundObject.position = CGPointMake((backgroundObject.size.width/2), (backgroundObject.size.height/2));
    backgroundObject.zPosition = -10000;
    [self addChild:backgroundObject];
    
//    _missedLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    _missedLabel.text = [NSString stringWithFormat:@"Missed: %i", self.missedCount];
//    _missedLabel.fontSize = 10;
//    _missedLabel.position = CGPointMake(30+(_missedLabel.frame.size.width/2), 40);
//    _missedLabel.zPosition = -10;
//    [self addChild:_missedLabel];
//    
    _towerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cookieBomb_building"];
    _towerObject.position = CGPointMake((_towerObject.size.width/2), (_towerObject.size.height/2));
    _towerObject.name = @"towerObject";
    _towerObject.zPosition = -1000;
    [self addChild:_towerObject];
    
    ///////////////////////////////////
    //// Creating the window boxes ////
    ///////////////////////////////////
    
    // BOTTOM ROW
    NSDictionary *windowOneDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .30, _towerObject.size.height * .563)], @"position", [NSNumber numberWithFloat:1], @"scale", [NSNumber numberWithInt:1], @"row", @"box3", @"image", nil];
    NSDictionary *windowTwoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .5, _towerObject.size.height * .555)], @"position", [NSNumber numberWithFloat:1], @"scale", [NSNumber numberWithInt:1], @"row", @"box1", @"image", nil];
    NSDictionary *windowThreeDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .70, _towerObject.size.height * .563)], @"position", [NSNumber numberWithFloat:1], @"scale", [NSNumber numberWithInt:1], @"row", @"box2", @"image", nil];

    
    // SECOND ROW
    NSDictionary *windowFourDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .288, _towerObject.size.height * .67)], @"position", [NSNumber numberWithFloat:.5f], @"scale", [NSNumber numberWithInt:2], @"row", @"box3", @"image", nil];
    NSDictionary *windowFiveDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .350, _towerObject.size.height * .67)], @"position", [NSNumber numberWithFloat:.5f], @"scale", [NSNumber numberWithInt:2], @"row", @"box3", @"image", nil];
    NSDictionary *windowSixDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .418, _towerObject.size.height * .67)], @"position", [NSNumber numberWithFloat:.5f], @"scale", [NSNumber numberWithInt:2], @"row", @"box3", @"image", nil];
    NSDictionary *windowSevenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .5, _towerObject.size.height * .67)], @"position", [NSNumber numberWithFloat:.5f], @"scale", [NSNumber numberWithInt:2], @"row", @"box2", @"image", nil];
    NSDictionary *windowEightDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .578, _towerObject.size.height * .67)], @"position", [NSNumber numberWithFloat:.5f], @"scale", [NSNumber numberWithInt:2], @"row", @"box2", @"image", nil];
    NSDictionary *windowNineDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .64, _towerObject.size.height * .67)], @"position", [NSNumber numberWithFloat:.5f], @"scale", [NSNumber numberWithInt:2], @"row", @"box2", @"image", nil];
    NSDictionary *windowTenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .710, _towerObject.size.height * .67)], @"position", [NSNumber numberWithFloat:.5f], @"scale", [NSNumber numberWithInt:2], @"row", @"box2", @"image", nil];

    
    // THIRD ROW
    NSDictionary *windowElevenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .31, _towerObject.size.height * .733)], @"position", [NSNumber numberWithFloat:.4f], @"scale", [NSNumber numberWithInt:3], @"row", @"box3", @"image", nil];
    NSDictionary *windowTwelveDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .37, _towerObject.size.height * .733)], @"position", [NSNumber numberWithFloat:.4f], @"scale", [NSNumber numberWithInt:3], @"row", @"box3", @"image", nil];
    NSDictionary *windowThirteenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .454, _towerObject.size.height * .731)], @"position", [NSNumber numberWithFloat:.4f], @"scale", [NSNumber numberWithInt:3], @"row", @"box1", @"image", nil];
    NSDictionary *windowFourteenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .54, _towerObject.size.height * .731)], @"position", [NSNumber numberWithFloat:.4f], @"scale", [NSNumber numberWithInt:3], @"row", @"box1", @"image", nil];
    NSDictionary *windowFifteenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .62, _towerObject.size.height * .733)], @"position", [NSNumber numberWithFloat:.4f], @"scale", [NSNumber numberWithInt:3], @"row", @"box2", @"image", nil];
    NSDictionary *windowSixteenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .68, _towerObject.size.height * .733)], @"position", [NSNumber numberWithFloat:.4f], @"scale", [NSNumber numberWithInt:3], @"row", @"box2", @"image", nil];

    
    // TOP ROW
    NSDictionary *windowSeventeenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .331, _towerObject.size.height * .785)], @"position", [NSNumber numberWithFloat:.3f], @"scale", [NSNumber numberWithInt:4], @"row", @"box3", @"image", nil];
    NSDictionary *windowEighteenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .378, _towerObject.size.height * .785)], @"position", [NSNumber numberWithFloat:.3f], @"scale", [NSNumber numberWithInt:4], @"row", @"box3", @"image", nil];
    NSDictionary *windowNineteenDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .440, _towerObject.size.height * .785)], @"position", [NSNumber numberWithFloat:.3f], @"scale", [NSNumber numberWithInt:4], @"row", @"box3", @"image", nil];
    NSDictionary *windowTwentyDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .5, _towerObject.size.height * .785)], @"position", [NSNumber numberWithFloat:.3f], @"scale", [NSNumber numberWithInt:4], @"row", @"box2", @"image", nil];
    NSDictionary *windowTwentyoneDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .558, _towerObject.size.height * .785)], @"position", [NSNumber numberWithFloat:.3f], @"scale", [NSNumber numberWithInt:4], @"row", @"box2", @"image", nil];
    NSDictionary *windowTwentytwoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(_towerObject.size.width * .618, _towerObject.size.height * .785)], @"position", [NSNumber numberWithFloat:.3f], @"scale", [NSNumber numberWithInt:4], @"row", @"box2", @"image",  nil];
    NSDictionary *windowTwentythreeDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint: CGPointMake(_towerObject.size.width * .66, _towerObject.size.height * .785)], @"position", [NSNumber numberWithFloat:.3f], @"scale", [NSNumber numberWithInt:4], @"row", @"box2", @"image",  nil];
    
    
    _windowPositionArray = [NSArray arrayWithObjects:
                                windowOneDict, windowTwoDict, windowThreeDict, windowFourDict,
                                windowFiveDict, windowSixDict, windowSevenDict, windowEightDict,
                                windowNineDict, windowTenDict, windowElevenDict, windowTwelveDict, windowThirteenDict,
                                windowFourteenDict, windowFifteenDict, windowSixteenDict, windowSeventeenDict,
                                windowEighteenDict, windowNineteenDict, windowTwentyDict, windowTwentyoneDict,
                                windowTwentytwoDict, windowTwentythreeDict, nil];
    
    ////////////////////////////
    //// Creating the smoke ////
    ////////////////////////////
    SKEmitterNode *smoke1;
    SKEmitterNode *smoke2;
    SKEmitterNode *smoke3;
    SKEmitterNode *smoke4;
    
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        smoke1 = [[CDParticleEmitter particleEmitter] emitter:self Position:CGPointMake(0, _towerObject.size.height*.79) EmitterName:@"SmokeStackSmokeParticle_Right" EmitterMultiplier:1 DeletionTime:0];
        
        smoke2 = [[CDParticleEmitter particleEmitter] emitter:self Position:CGPointMake(_towerObject.size.width*.17, _towerObject.size.height*.79) EmitterName:@"SmokeStackSmokeParticle_Right" EmitterMultiplier:1 DeletionTime:0];
        
        smoke3 = [[CDParticleEmitter particleEmitter] emitter:self Position:CGPointMake(_towerObject.size.width*.83, _towerObject.size.height*.79) EmitterName:@"SmokeStackSmokeParticle_Right" EmitterMultiplier:.6 DeletionTime:0];
        
        smoke4 = [[CDParticleEmitter particleEmitter] emitter:self Position:CGPointMake(_towerObject.size.width, _towerObject.size.height*.79) EmitterName:@"SmokeStackSmokeParticle_Right" EmitterMultiplier:1 DeletionTime:0];
    }
    else
    {
        smoke1 = [[CDParticleEmitter particleEmitter] emitter:self Position:CGPointMake(_towerObject.size.width*.0586, _towerObject.size.height*.79) EmitterName:@"SmokeStackSmokeParticle_Right" EmitterMultiplier:1 DeletionTime:0];
        
        smoke2 = [[CDParticleEmitter particleEmitter] emitter:self Position:CGPointMake(_towerObject.size.width*.20, _towerObject.size.height*.79) EmitterName:@"SmokeStackSmokeParticle_Right" EmitterMultiplier:1 DeletionTime:0];
        
        smoke3 = [[CDParticleEmitter particleEmitter] emitter:self Position:CGPointMake(_towerObject.size.width*.79, _towerObject.size.height*.79) EmitterName:@"SmokeStackSmokeParticle_Right" EmitterMultiplier:1 DeletionTime:0];
        
        smoke4 = [[CDParticleEmitter particleEmitter] emitter:self Position:CGPointMake(_towerObject.size.width*.93, _towerObject.size.height*.79) EmitterName:@"SmokeStackSmokeParticle_Right" EmitterMultiplier:1 DeletionTime:0];
    }
    
    smoke1.zPosition = -10000;
    smoke2.zPosition = -10000;
    smoke3.zPosition = -10000;
    smoke4.zPosition = -10000;
    
    _floorObject = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, 10)];
    _floorObject.position = CGPointMake((_floorObject.size.width/2), (_floorObject.size.height/2));
    _floorObject.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_floorObject.size];
    _floorObject.physicsBody.usesPreciseCollisionDetection = YES;
    _floorObject.name = @"floorObject";
    _floorObject.physicsBody.dynamic = NO;
    _floorObject.physicsBody.categoryBitMask = floorCategory;
    _floorObject.physicsBody.contactTestBitMask = cookieCategory;
    _floorObject.physicsBody.collisionBitMask = cookieCategory;
    [self addChild:_floorObject];
    
    _rightWallObject = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(10, self.size.height)];
    _rightWallObject.position = CGPointMake(self.size.width-_rightWallObject.size.width/2, (_rightWallObject.size.height/2));
    _rightWallObject.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_rightWallObject.size];
    _rightWallObject.physicsBody.usesPreciseCollisionDetection = YES;
    _rightWallObject.name = @"wallRightObject";
    _rightWallObject.physicsBody.dynamic = NO;
    _rightWallObject.physicsBody.categoryBitMask = wallCategory;
    _rightWallObject.physicsBody.contactTestBitMask = cookieCategory;
    _rightWallObject.physicsBody.collisionBitMask = cookieCategory;
    [self addChild:_rightWallObject];
    
    _leftWallObject = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(10, self.size.height)];
    _leftWallObject.position = CGPointMake(self.leftWallObject.size.width/2, (_leftWallObject.size.height/2));
    _leftWallObject.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_leftWallObject.size];
    _leftWallObject.physicsBody.usesPreciseCollisionDetection = YES;
    _leftWallObject.name = @"wallLeftObject";
    _leftWallObject.physicsBody.dynamic = NO;
    _leftWallObject.physicsBody.categoryBitMask = wallCategory;
    _leftWallObject.physicsBody.contactTestBitMask = cookieCategory;
    _leftWallObject.physicsBody.collisionBitMask = cookieCategory;
    [self addChild:_leftWallObject];

    
    //////////////////////////
    //// Creating the cup ////
    //////////////////////////
    
    _cupMiddleTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-milk"];
    
    SKTexture *animation1 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash01"];
    SKTexture *animation2 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash02"];
    SKTexture *animation3 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash03"];
    SKTexture *animation4 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash04"];
    SKTexture *animation5 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash05"];
    SKTexture *animation6 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash06"];
    SKTexture *animation7 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash07"];
    SKTexture *animation8 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash08"];
    
    SKTexture *animation9 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash09"];
    SKTexture *animation10 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash10"];
    SKTexture *animation11 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash11"];
    SKTexture *animation12 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash12"];
    SKTexture *animation13 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash13"];
    SKTexture *animation14 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash14"];
    SKTexture *animation15 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash15"];
    SKTexture *animation16 = [_atlas textureNamed:@"cdd-mini-cookiedrop-milksplash16"];
    
    _milkAnimationArray = @[_cupMiddleTexture, animation1, animation2, animation3, animation4, animation5, animation6, animation7, animation8, animation9, animation10, animation11, animation12, animation13, animation14, animation15, animation16, _cupMiddleTexture];
    _animateMilk = [SKAction animateWithTextures:_milkAnimationArray timePerFrame:.05];
    
    _milkSlosh1Texture = [_atlas textureNamed:@"cdd-mini-cookiedrop-milkslosh01"];
    _milkSlosh2Texture = [_atlas textureNamed:@"cdd-mini-cookiedrop-milkslosh02"];
    _milkSlosh3Texture = [_atlas textureNamed:@"cdd-mini-cookiedrop-milkslosh03"];
    _milkSlosh4Texture = [_atlas textureNamed:@"cdd-mini-cookiedrop-milkslosh04"];
    
    SKTexture *backTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-glassback"];
    _cupBackObject = [SKSpriteNode spriteNodeWithTexture:backTexture];
    _cupBackObject.name = @"cupBackObject";
    _cupBackObject.position = CGPointMake(CGRectGetMidX(self.frame), (_cupBackObject.size.height/2));
    _cupBackObject.zPosition = -1000;
    
    _cupMiddleObject = [SKSpriteNode spriteNodeWithTexture:_cupMiddleTexture];
    _cupMiddleObject.name = @"cupMiddleObject";
    _cupMiddleObject.position = CGPointMake(CGRectGetMidX(self.frame), (_cupMiddleObject.size.height/2));
    _cupMiddleObject.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_cupMiddleObject.size.width*.3, _cupMiddleObject.size.height*.2)];
    _cupMiddleObject.physicsBody.usesPreciseCollisionDetection = YES;
    _cupMiddleObject.physicsBody.dynamic = NO;
    _cupMiddleObject.physicsBody.categoryBitMask = cupCategory;
    _cupMiddleObject.physicsBody.contactTestBitMask = cookieCategory;
    _cupMiddleObject.physicsBody.collisionBitMask = cookieCategory;
    _cupMiddleObject.zPosition = -1000;
    
    SKTexture *frontTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-glassFront"];
    _cupFrontObject = [SKSpriteNode spriteNodeWithTexture:frontTexture];
    _cupFrontObject.name = @"cupFrontObject";
    _cupFrontObject.position = CGPointMake(CGRectGetMidX(self.frame), (_cupFrontObject.size.height/2));
    _cupFrontObject.zPosition = 1000;
    
    [self addChild:_cupBackObject];
    [self addChild:_cupMiddleObject];
    [self addChild:_cupFrontObject];
    
    _cupSideRightObject = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(_cupFrontObject.size.width * 0.1 , _cupFrontObject.size.height * 0.9)];
    _cupSideRightObject.position = CGPointMake((_cupFrontObject.position.x+(_cupFrontObject.size.width/2)), _cupFrontObject.position.y);
    _cupSideRightObject.name = @"cupSideRightObject";
    _cupSideRightObject.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_cupSideRightObject.size];
    _cupSideRightObject.physicsBody.usesPreciseCollisionDetection = YES;
    _cupSideRightObject.physicsBody.dynamic = NO;
    _cupSideRightObject.physicsBody.categoryBitMask = wallCategory;
    _cupSideRightObject.physicsBody.contactTestBitMask = cookieCategory;
    _cupSideRightObject.physicsBody.collisionBitMask = cookieCategory;
    [self addChild:_cupSideRightObject];
    
    _cupSideLeftObject = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:_cupSideRightObject.size];
    _cupSideLeftObject.name = @"cupSideLeftObject";
    _cupSideLeftObject.position = CGPointMake((_cupFrontObject.position.x-(_cupFrontObject.size.width/2)), _cupFrontObject.position.y);
    _cupSideLeftObject.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_cupSideLeftObject.size];
    _cupSideLeftObject.physicsBody.usesPreciseCollisionDetection = YES;
    _cupSideLeftObject.physicsBody.dynamic = NO;
    _cupSideLeftObject.physicsBody.categoryBitMask = wallCategory;
    _cupSideLeftObject.physicsBody.contactTestBitMask = cookieCategory;
    _cupSideLeftObject.physicsBody.collisionBitMask = cookieCategory;
    [self addChild:_cupSideLeftObject];
    
    _lastPositionOfMilk = _cupMiddleObject.position;
    
    
    // The following warning should be ignored....
    _milkMonster = [[CDCookieBombMonster alloc]initWithScene:self];
    SKAction *moveMilkyTheTemporaryMilkMonster = [SKAction sequence:@[[SKAction performSelector:@selector(moveMilky) onTarget:_milkMonster],
                                                                      [SKAction waitForDuration:0 withRange:0.5]]];
    [self runAction:[SKAction repeatActionForever:moveMilkyTheTemporaryMilkMonster]];
    
    
    SKSpriteNode *timerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-mini-timer"];
    timerObject.position = CGPointMake(timerObject.frame.size.width * .5, self.frame.size.height - (.5 * timerObject.frame.size.height));
    [self addChild:timerObject];
    
    SKSpriteNode *scoreObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-mini-score"];
    scoreObject.position = CGPointMake(self.frame.size.width - (scoreObject.frame.size.width * .5), self.frame.size.height - (.5 * timerObject.frame.size.height));
    [self addChild:scoreObject];
    
    _timerLabel = [SKLabelNode labelNodeWithFontNamed:kFontDamnNoisyKids];
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:kFontDamnNoisyKids];
    
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        _timerLabel.fontSize = 15;
        _scoreLabel.fontSize = 15;
    }
    else if (IS_IPAD)
    {
        _timerLabel.fontSize = 50;
        _scoreLabel.fontSize = 50;
    }
    
    _timerLabel.position = CGPointMake((timerObject.frame.size.width * .20), 0 - (timerObject.frame.size.height * .17));
    _timerLabel.hidden = YES;
    [timerObject addChild:_timerLabel];
    
    _scoreLabel.text = [NSString stringWithFormat:@"%i", self.score];
    _scoreLabel.position = CGPointMake(0, 0 - (scoreObject.frame.size.height * .26));
    _scoreLabel.hidden = YES;
    [scoreObject addChild:_scoreLabel];
    
}

- (void)stopBackgroundMusic
{
    [[SGAudioManager audioManager] stopTheMusic];
}

- (void)update:(NSTimeInterval)currentTime
{
    //DebugLog(@"AHAHAHAAHHHAHA");
    if (!_didCreatePopup)
    {
        
        if (currentTime > _previousTime+1)
        {
            _previousTime = currentTime;
            [self updateTimer];
        }
        
        if (_hasStarted)
        {
            if (_cookieDropCounter == _cookieDropTimer)
            {
                _milkMonster.canDrop = YES;
                _cookieDropCounter = 0;
            }
            else
            {
                _cookieDropCounter += 1;
            }
            
            for (SKSpriteNode *cookie in [_milkMonster.cookiesToScaleArray copy])
            {
                float divider = cookie.position.y/_towerObject.size.height;
                [_milkMonster scaleCookieUp:cookie ScaleBy:divider];
            }
            
            if (currentTime > _previousBoxTime+_boxSpawnTimer)
            {
                if (_boxCount > 1)
                {
                    _boxCount--;
                    [self addBoxesToBoard];
                }
                else
                {
                    _previousBoxTime = currentTime;
                }
            }
            
            // screaming
            if(self.ScreamSoundCookie1 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 1);
               [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 1];
            }
            if(self.ScreamSoundCookie2 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 2);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 2];
            }
            if(self.ScreamSoundCookie3 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 3);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 3];
            }
            if(self.ScreamSoundCookie4 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 4);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 4];
            }
            if(self.ScreamSoundCookie5 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 4);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 4];
            }
            if(self.ScreamSoundCookie6 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 4);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 4];
            }
            if(self.ScreamSoundCookie7 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 4);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 4];
            }
            if(self.ScreamSoundCookie8 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 4);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 4];
            }
            if(self.ScreamSoundCookie9 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 4);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 4];
            }
            if(self.ScreamSoundCookie10 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 4);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 4];
            }
            if(self.ScreamSoundCookie11 != nil)
            {
                //DebugLog(@"Adjust Scream: %d", [SGAppDelegate appDelegate].masterVolume * 4);
                [self AdjustScreamVolume:[SGAppDelegate appDelegate].masterVolume * 4];
            }
        }
    }
    
    
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive)
	{
		self.view.paused = YES;
        self.userInteractionEnabled = NO;
		self.paused = YES;
		
		[[SGAudioManager audioManager] pauseAllAudio];
	}
}

- (void)addBoxesToBoard
{
    int randomBox = arc4random() % ([_windowPositionArray count]);
    
    NSDictionary *boxDict = [_windowPositionArray objectAtIndex:randomBox];
    NSDictionary *otherBoxDict;
    
    SKSpriteNode *boxObject = [SKSpriteNode spriteNodeWithImageNamed:[boxDict objectForKey:@"image"]];
    
    if (![_existingBoxesArray containsObject:[_windowPositionArray objectAtIndex:randomBox]])
    {
        if (randomBox == 0)
        {
            if (![_existingBoxesArray containsObject:[_windowPositionArray objectAtIndex:randomBox+1]])
            {
                [self createTheNewBox:boxObject WithBoxDict:boxDict WithNewBoxInt:randomBox];
                _cantFindAnOpenWindowCount = 0;
            }
            else
            {
                otherBoxDict = [_windowPositionArray objectAtIndex:randomBox+1];
                if ([boxDict objectForKey:@"row"] != [otherBoxDict objectForKey:@"row"])
                {
//                    DebugLog(@"Rows do not match.... Creating new box");
                    [self createTheNewBox:boxObject WithBoxDict:boxDict WithNewBoxInt:randomBox];
                    _cantFindAnOpenWindowCount = 0;
                }
                else
                {
                    if (_cantFindAnOpenWindowCount < _cantFindAnOpenWindowCountMax)
                    {
//                        DebugLog(@"A box exists at this spot.... Creating new one....");
                        _cantFindAnOpenWindowCount += 1;
                        [self addBoxesToBoard];
                    }
                    else
                    {
//                        DebugLog(@"Screw it.... I quit....");
                    }
                }
            }
        }
        else if (randomBox == [_windowPositionArray count]-1)
        {
            if (![_existingBoxesArray containsObject:[_windowPositionArray objectAtIndex:randomBox-1]])
            {
                [self createTheNewBox:boxObject WithBoxDict:boxDict WithNewBoxInt:randomBox];
                _cantFindAnOpenWindowCount = 0;
            }
            else
            {
                otherBoxDict = [_windowPositionArray objectAtIndex:randomBox-1];
                if ([boxDict objectForKey:@"row"] != [otherBoxDict objectForKey:@"row"])
                {
//                    DebugLog(@"Rows do not match.... Creating new box");
                    [self createTheNewBox:boxObject WithBoxDict:boxDict WithNewBoxInt:randomBox];
                    _cantFindAnOpenWindowCount = 0;
                }
                else
                {
                    if (_cantFindAnOpenWindowCount < _cantFindAnOpenWindowCountMax)
                    {
//                        DebugLog(@"A box exists at this spot.... Creating new one....");
                        _cantFindAnOpenWindowCount += 1;
                        [self addBoxesToBoard];
                    }
                    else
                    {
//                        DebugLog(@"Screw it.... I quit....");
                    }
                }
            }
        }
        else
        {
            if (![_existingBoxesArray containsObject:[_windowPositionArray objectAtIndex:randomBox+1]] && ![_existingBoxesArray containsObject:[_windowPositionArray objectAtIndex:randomBox-1]])
            {
                [self createTheNewBox:boxObject WithBoxDict:boxDict WithNewBoxInt:randomBox];
                _cantFindAnOpenWindowCount = 0;
            }
            else
            {
                if ([_existingBoxesArray containsObject:[_windowPositionArray objectAtIndex:randomBox+1]])
                {
                    otherBoxDict = [_windowPositionArray objectAtIndex:randomBox+1];
                    if ([boxDict objectForKey:@"row"] != [otherBoxDict objectForKey:@"row"])
                    {
//                        DebugLog(@"Rows do not match.... Creating new box");
                        [self createTheNewBox:boxObject WithBoxDict:boxDict WithNewBoxInt:randomBox];
                        _cantFindAnOpenWindowCount = 0;
                    }
                    else
                    {
                        if (_cantFindAnOpenWindowCount < _cantFindAnOpenWindowCountMax)
                        {
                            _cantFindAnOpenWindowCount += 1;
                            [self addBoxesToBoard];
                        }
                        else
                        {
//                            DebugLog(@"Screw it.... I quit....");
                        }
                    }
                }
                else if ([_existingBoxesArray containsObject:[_windowPositionArray objectAtIndex:randomBox-1]])
                {
                    otherBoxDict = [_windowPositionArray objectAtIndex:randomBox-1];
                    if ([boxDict objectForKey:@"row"] != [otherBoxDict objectForKey:@"row"])
                    {
                        [self createTheNewBox:boxObject WithBoxDict:boxDict WithNewBoxInt:randomBox];
                        _cantFindAnOpenWindowCount = 0;
                    }
                    else
                    {
                        if (_cantFindAnOpenWindowCount < _cantFindAnOpenWindowCountMax)
                        {
                            _cantFindAnOpenWindowCount += 1;
                            [self addBoxesToBoard];
                        }
                        else
                        {
//                            DebugLog(@"Screw it.... I quit....");
                        }
                    }
                }
            }
        }
    }
    else
    {
        if (_cantFindAnOpenWindowCount < _cantFindAnOpenWindowCountMax)
        {
//            DebugLog(@"A box exists at this spot.... Creating new one....");
            _cantFindAnOpenWindowCount += 1;
            [self addBoxesToBoard];
        }
        else
        {
//            DebugLog(@"Screw it.... I quit....");
        }
    }
}

- (void)createTheNewBox:(SKSpriteNode *)newBoxObject WithBoxDict:(NSDictionary *)boxDict WithNewBoxInt:(int)newBoxInt
{
    newBoxObject.position = [[boxDict objectForKey:@"position"] CGPointValue];
    newBoxObject.xScale = [[boxDict objectForKey:@"scale"] floatValue];
    newBoxObject.yScale = [[boxDict objectForKey:@"scale"] floatValue];
    
    newBoxObject.name = @"boxObject";
    
    newBoxObject.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:newBoxObject.size.width*.5];
    newBoxObject.physicsBody.categoryBitMask = boxCategory;
    newBoxObject.physicsBody.collisionBitMask = cookieCategory;
    newBoxObject.physicsBody.contactTestBitMask = cookieCategory;
    newBoxObject.physicsBody.dynamic = NO;
    
    newBoxObject.zPosition = 1500;
    
    [newBoxObject runAction:[SKAction waitForDuration:_boxLifeSpanTimer] completion:^{
        [newBoxObject removeFromParent];
        _boxCount = _maxBoxCount;
        if ([_existingBoxesArray containsObject:[_windowPositionArray objectAtIndex:newBoxInt]])
        {
            [_existingBoxesArray removeObject:[_windowPositionArray objectAtIndex:newBoxInt]];
        }

        _boxCount++;
    }];
    
    [_existingBoxesArray addObject:[_windowPositionArray objectAtIndex:newBoxInt]];
    [self addChild:newBoxObject];
}

#pragma mark - Timer Methods
// Prints the countdown to a label.
- (void)updateTimer
{
    if (_currentSeconds >= 0)
    {
        int minutes = _currentSeconds/60;
        int seconds = _currentSeconds%60;
        
        if (!_timerLabel.hidden)
        {
            [_timerLabel setText:[NSString stringWithFormat:@"%02i:%02i", minutes, seconds]];
        }
        
        if (_hasStarted)
        {
            _currentSeconds -= 1;
        }
    }
    else
    {
        DebugLog(@"Time ran out.");
        
        [self Shut_The_Cookies_up];
        
        self.paused = YES;
        self.userInteractionEnabled = NO;
        _canMoveCup = NO;
        
        if (!_didCreatePopup)
        {
            [self removeAllActions];
            [[SGAudioManager audioManager] stopAllAudio];
            [_milkMonster forceKillAudio];
            [_milkMonster removeAllActions];
            
            if ([self.delegate respondsToSelector:@selector(cookieBombSceneDidEnd:WithScore:WithGoalScore:WithWin:)])
            {
                [self.delegate cookieBombSceneDidEnd:self WithScore:_score WithGoalScore:_goalScore WithWin:_didWin];
            }
            _didCreatePopup = YES;
        }
    }
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        if (_canMoveCup)
        {
            CGPoint location = [touch locationInNode:self];
            if ((location.x > (_cupFrontObject.size.width/2)+(_leftWallObject.size.width)) && (location.x < (_cupFrontObject.size.width/2)-(_rightWallObject.size.width)))
            {
                _cupBackObject.position = CGPointMake(location.x, _cupBackObject.position.y);
                _cupMiddleObject.position = CGPointMake(location.x, _cupMiddleObject.position.y);
                
                location.y = _cupFrontObject.position.y;
                _cupFrontObject.position = location;
                _cupSideLeftObject.position = CGPointMake((location.x-(_cupFrontObject.size.width/2)), location.y);
                _cupSideRightObject.position = CGPointMake((location.x+(_cupFrontObject.size.width/2)), location.y);
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        if (_canMoveCup)
        {
            NSTimeInterval timestamp = [touch timestamp];
            CGPoint location = [touch locationInNode:self];
            if (!_splashAnimationIsPlaying)
            {
                float velocity = (location.x - _lastPositionOfMilk.x)/(float)timestamp;
//                DebugLog(@"velocity: %f", velocity);
     
                if (velocity > .001)
                {
//                    DebugLog(@"Right fast");
                    _cupMiddleObject.texture = _milkSlosh4Texture;
                }
                else if (velocity > .0001)
                {
//                    DebugLog(@"Right slow");
                    _cupMiddleObject.texture = _milkSlosh3Texture;
                }
                else if (velocity < -.001)
                {
//                    DebugLog(@"Left fast");
                    _cupMiddleObject.texture = _milkSlosh2Texture;
                }
                else if (velocity < -.0001)
                {
//                    DebugLog(@"Left Slow");
                    _cupMiddleObject.texture = _milkSlosh1Texture;
                }
                else
                {
//                    DebugLog(@"Too slow to care");
                    _cupMiddleObject.texture = _cupMiddleTexture;
                }
            }
            if ((location.x > ((_cupFrontObject.size.width/2)+_leftWallObject.size.width)) && (location.x < (self.size.width-(_cupFrontObject.size.width/2)-_rightWallObject.size.width)))
            {
                _cupBackObject.position = CGPointMake(location.x, _cupBackObject.position.y);
                _cupMiddleObject.position = CGPointMake(location.x, _cupMiddleObject.position.y);

                location.y = _cupFrontObject.position.y;
                _cupFrontObject.position = location;
                _cupSideLeftObject.position = CGPointMake((location.x-(_cupFrontObject.size.width/2)), location.y);
                _cupSideRightObject.position = CGPointMake((location.x+(_cupFrontObject.size.width/2)), location.y);
            
                _lastPositionOfMilk = _cupMiddleObject.position;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_cupMiddleObject setTexture:_cupMiddleTexture];
}

- (void)cookieCollided:(SKSpriteNode *)cookie WithMilkCup:(SKSpriteNode *)milkCup
{
    [_milkMonster.cookiesToScaleArray removeObject:cookie];
    
    [cookie removeFromParent];
    
    if ([cookie.name isEqualToString:@"cookieObject"])
    {
        _splashAnimationIsPlaying = YES;
        [_cupMiddleObject removeAllActions];
        [_cupMiddleObject runAction:_animateMilk completion:^
         {
             _splashAnimationIsPlaying = NO;
             _cupMiddleObject.texture = _cupMiddleTexture;
         }];
        
        NSUserDefaults *volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
        NSString *volumeButtonState = [volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
        
        if (![volumeButtonState isEqualToString:@"mute"])
        {
            int whichSplash = arc4random() % 3;
            switch (whichSplash) {
                case 0:
                    //[self playSoundWithName:@"Cookie_Drop_Splashes1" ofType:@"m4a" volume:.3];
                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Drop_Splashes1" FileType:@"caf" volume:0.3f]; //@"m4a" volume:0.3f];
                    break;
                case 1:
                    //[self playSoundWithName:@"Cookie_Drop_Splashes2" ofType:@"m4a" volume:.3];
                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Drop_Splashes2" FileType:@"caf" volume:0.3f]; //@"m4a" volume:0.3f];
                    break;
                case 2:
                    //[self playSoundWithName:@"Cookie_Drop_Splashes3" ofType:@"m4a" volume:.3];
                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Drop_Splashes3" FileType:@"caf" volume:0.3f]; //@"m4a" volume:0.3f];
                    break;
            }
        }
        if (_canMoveCup)
        {
            _score++;
            
            _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
            
            if (_score >= _goalScore)
            {
                _didWin = YES;
            }
            
            SKSpriteNode *pointPopup = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-particle-scoreplus"];
            
            pointPopup.position = cookie.position;
            
            [pointPopup runAction:[SKAction moveByX:0 y:50 duration:.5]];
            [pointPopup runAction:[SKAction fadeOutWithDuration:.5] completion:^{
                [pointPopup removeFromParent];
            }];
            
            [self addChild:pointPopup];
        }
        
        if (![volumeButtonState isEqualToString:@"mute"])
        {
            [self DeadCookie:cookie];
        }
    }
}

//- (void)playSoundWithName:(NSString *)soundName ofType:(NSString *)fileType volume:(float)volume {
//    
//    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:fileType];
//    
//    DebugLog(@"sound name %@",soundFilePath);
//    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
//    _splashPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
//    _splashPlayer.volume = volume;
//    [_splashPlayer prepareToPlay];
//    [_splashPlayer play];
//}

#pragma mark - contact delegates

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSUserDefaults *volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
    NSString *volumeButtonState = [volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
    
    if (contact.bodyA == _cupMiddleObject.physicsBody)
    {
        [self cookieCollided:(SKSpriteNode *)contact.bodyB.node WithMilkCup:(SKSpriteNode *)contact.bodyA.node];
    }
    else if (contact.bodyB == _cupMiddleObject.physicsBody)
    {
        [self cookieCollided:(SKSpriteNode *)contact.bodyA.node WithMilkCup:(SKSpriteNode *)contact.bodyB.node];
    }
    else if ([contact.bodyA.node.name isEqualToString:@"scene"] && ([contact.bodyB.node.name isEqualToString:@"cookieObject"] || [contact.bodyB.node.name isEqualToString:@"Cookie is too low!!!!"]))
    {
        if (contact.bodyB.node.position.y < 0)
        {
            [_milkMonster.cookiesToScaleArray removeObject:contact.bodyB.node];
            [contact.bodyB.node removeFromParent];
            
            SKSpriteNode* cookie = (SKSpriteNode*) contact.bodyB.node;
            
            if (![volumeButtonState isEqualToString:@"mute"])
            {
                [self DeadCookie:cookie];
            }
        }
    }
    else if ([contact.bodyB.node.name isEqualToString:@"scene"] && ([contact.bodyA.node.name isEqualToString:@"cookieObject"] || [contact.bodyA.node.name isEqualToString:@"Cookie is too low!!!!"]))
    {
        if (contact.bodyB.node.position.y < 0)
        {
            [_milkMonster.cookiesToScaleArray removeObject:contact.bodyA.node];
            [contact.bodyA.node removeFromParent];
            
            SKSpriteNode* cookie = (SKSpriteNode*) contact.bodyA.node;
            
            if (![volumeButtonState isEqualToString:@"mute"])
            {
                [self DeadCookie:cookie];
            }
        }
    }
    else if (([contact.bodyB.node.name isEqualToString:@"floorObject"] && ([contact.bodyA.node.name isEqualToString:@"cookieObject"] || [contact.bodyA.node.name isEqualToString:@"Cookie is too low!!!!"])) || ((([contact.bodyB.node.name isEqualToString:@"cookieObject"] || [contact.bodyB.node.name isEqualToString:@"Cookie is too low!!!!"]) && [contact.bodyA.node.name isEqualToString:@"floorObject"])))
    {
        if ([contact.bodyA.node.name isEqualToString:@"cookieObject"] || [contact.bodyA.node.name isEqualToString:@"Cookie is too low!!!!"])
        {
            [_milkMonster.cookiesToScaleArray removeObject:contact.bodyA.node];
            [contact.bodyA.node removeFromParent];
            
            SKSpriteNode* cookie = (SKSpriteNode*) contact.bodyA.node;
            
            if (![volumeButtonState isEqualToString:@"mute"])
            {
                [self DeadCookie:cookie];
            }
        }
        else if ([contact.bodyB.node.name isEqualToString:@"cookieObject"] || [contact.bodyB.node.name isEqualToString:@"Cookie is too low!!!!"])
        {
            [_milkMonster.cookiesToScaleArray removeObject:contact.bodyB.node];
            [contact.bodyB.node removeFromParent];
            
            SKSpriteNode* cookie = (SKSpriteNode*) contact.bodyB.node;
            
            if (![volumeButtonState isEqualToString:@"mute"])
            {
                [self DeadCookie:cookie];
            }
        }
//        if (_canMoveCup)
//        {
//            _missedCount += 1;
//            _missedLabel.text = [NSString stringWithFormat:@"Missed: %i", _missedCount];
//        }
    }
    else if (([contact.bodyB.node.name isEqualToString:@"floorObject"] && ([contact.bodyA.node.name isEqualToString:@"cookieObject"] || [contact.bodyA.node.name isEqualToString:@"Cookie is too low!!!!"])) || ((([contact.bodyB.node.name isEqualToString:@"cookieObject"] || [contact.bodyB.node.name isEqualToString:@"Cookie is too low!!!!"]) && [contact.bodyA.node.name isEqualToString:@"floorObject"])))
    {
        if ([contact.bodyA.node.name isEqualToString:@"cookieObject"] || [contact.bodyA.node.name isEqualToString:@"Cookie is too low!!!!"])
        {
            [_milkMonster.cookiesToScaleArray removeObject:contact.bodyA.node];
            [contact.bodyA.node removeFromParent];
            
            SKSpriteNode* cookie = (SKSpriteNode*) contact.bodyA.node;
            
            if (![volumeButtonState isEqualToString:@"mute"])
            {
                [self DeadCookie:cookie];
            }
        }
        else if ([contact.bodyB.node.name isEqualToString:@"cookieObject"] || [contact.bodyB.node.name isEqualToString:@"Cookie is too low!!!!"])
        {
            [_milkMonster.cookiesToScaleArray removeObject:contact.bodyB.node];
            [contact.bodyB.node removeFromParent];
            
            SKSpriteNode* cookie = (SKSpriteNode*) contact.bodyB.node;
            if (![volumeButtonState isEqualToString:@"mute"])
            {
                [self DeadCookie:cookie];
            }
        }
        
//        if (_canMoveCup)
//        {
//            _missedCount += 1;
//            _missedLabel.text = [NSString stringWithFormat:@"Missed: %i", _missedCount];
//        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    NSUserDefaults *volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
    NSString *volumeButtonState = [volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
    
    if ([contact.bodyA.node.name isEqualToString:@"scene"] && ([contact.bodyB.node.name isEqualToString:@"cookieObject"] || [contact.bodyB.node.name isEqualToString:@"Cookie is too low!!!!"]))
    {
        [_milkMonster.cookiesToScaleArray removeObject:contact.bodyB.node];
        [contact.bodyB.node removeFromParent];
        
        SKSpriteNode* cookie = (SKSpriteNode*) contact.bodyB.node;
        if (![volumeButtonState isEqualToString:@"mute"])
        {
            [self DeadCookie:cookie];
        }
    }
    else if ([contact.bodyB.node.name isEqualToString:@"scene"] && ([contact.bodyB.node.name isEqualToString:@"cookieObject"] || [contact.bodyB.node.name isEqualToString:@"Cookie is too low!!!!"]))
    {
        [_milkMonster.cookiesToScaleArray removeObject:contact.bodyA.node];
        [contact.bodyA.node removeFromParent];
        SKSpriteNode* cookie = (SKSpriteNode*) contact.bodyA.node;
        if (![volumeButtonState isEqualToString:@"mute"])
        {
            [self DeadCookie:cookie];
        }
    }
    else if (([contact.bodyA.node.name isEqualToString:@"cookieObject"] && [contact.bodyB.node.name isEqualToString:@"boxObject"]) || [contact.bodyA.node.name isEqualToString:@"cookieObject"])
    {
        if (contact.bodyA.node.position.y > contact.bodyB.node.position.y)
        {
            if (contact.bodyA.velocity.dx > 0)
            {
                [contact.bodyA applyImpulse:CGVectorMake(2, -1)];
            }
            else
            {
                [contact.bodyA applyImpulse:CGVectorMake(-2, -1)];
            }
        }
    }
    else if ((([contact.bodyB.node.name isEqualToString:@"cookieObject"] && [contact.bodyA.node.name isEqualToString:@"boxObject"]) || [contact.bodyB.node.name isEqualToString:@"cookieObject"]))
    {
        if (contact.bodyB.node.position.y > contact.bodyA.node.position.y)
        {
            if (contact.bodyB.velocity.dx > 0)
            {
                [contact.bodyB applyImpulse:CGVectorMake(2, -1)];
            }
            else
            {
                [contact.bodyB applyImpulse:CGVectorMake(-2, -1)];
            }
        }
    }
}

-(void)CueTheMilkman
{
    int index = arc4random() % [self.milkMonsterScreamStrings count];
    NSString *screamString = self.milkMonsterScreamStrings[index];
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:screamString FileType:@"caf"]; //@"m4a"];
    
    
    
//    NSUserDefaults *volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
//    NSString *volumeButtonState = [volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
//    
//    if (![volumeButtonState isEqualToString:@"mute"])
//    {
//        int whichTalk = arc4random() % 9;
//        switch (whichTalk) {
//            case 0:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
//                _MilkMonsterSound1.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
//                [_MilkMonsterSound1 play];
//                break;
//            case 1:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
//                _MilkMonsterSound2.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
//                [_MilkMonsterSound2 play];
//                break;
//            case 2:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
//                _MilkMonsterSound3.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
//                [_MilkMonsterSound3 play];
//                break;
//            case 3:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
//                _MilkMonsterSound4.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
//                [_MilkMonsterSound4 play];
//                break;
//            case 4:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
//                _MilkMonsterSound5.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
//                [_MilkMonsterSound5 play];
//                break;
//            case 5:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
//                _MilkMonsterSound6.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
//                [_MilkMonsterSound6 play];
//                break;
//            case 6:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
//                _MilkMonsterSound7.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
//                [_MilkMonsterSound7 play];
//                break;
//            case 7:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
//                _MilkMonsterSound8.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
//                [_MilkMonsterSound8 play];
//                break;
//            case 8:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
//                _MilkMonsterSound9.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
//                [_MilkMonsterSound9 play];
//                break;
////            case 9:
////                DebugLog(@"MilkMonster.volume: %f", [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume);
////                _MilkMonsterSound10.volume = [SGAppDelegate appDelegate].masterVolume * _milkMonsterVolume;
////                [_MilkMonsterSound10 play];
////                break;
//        }
//    }
}

-(void)playThrowSound:(SKSpriteNode*)cookie
{
//    NSUserDefaults *volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
//    NSString *volumeButtonState = [volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
    
    
    int which = arc4random() % 4;
    switch (which)
    {
        case 0:
            //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Throws1" withFileType:@".m4a"]];
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Drop_Throws1" FileType:@"caf"]; //@"m4a"];
            break;
        case 1:
            //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Throws2" withFileType:@".m4a"]];
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Drop_Throws2" FileType:@"caf"]; //@"m4a"];
            break;
        case 2:
            //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Throws3" withFileType:@".m4a"]];
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Drop_Throws3" FileType:@"caf"]; //@"m4a"];
            break;
        case 3:
            //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Drop_Throws4" withFileType:@".m4a"]];
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Drop_Throws4" FileType:@"caf"]; //@"m4a"];
            break;
//            case 4:
//                [self runAction:_ThrowSound5];
//                break;
    }
        
        
    if(_currentSeconds <= 0)
    {
        return;
    }
    
    //AVAudioPlayer* scream;
    switch (_whichScream)
    {
        case 0:
            self.ScreamSound1 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound1;
            _ScreamSoundCookie1 = cookie;
            break;
        case 1:
            self.ScreamSound2 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound2;
            _ScreamSoundCookie2 = cookie;
            break;
        case 2:
            self.ScreamSound3 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound3;
            _ScreamSoundCookie3 = cookie;
            break;
        case 3:
            self.ScreamSound4 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound4;
            _ScreamSoundCookie4 = cookie;
            break;
        case 4:
            self.ScreamSound5 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound5;
            _ScreamSoundCookie5 = cookie;
            break;
        case 5:
            self.ScreamSound6 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound6;
            _ScreamSoundCookie6 = cookie;
            break;
        case 6:
            self.ScreamSound7 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound7;
            _ScreamSoundCookie7 = cookie;
            break;
        case 7:
            self.ScreamSound8 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound8;
            _ScreamSoundCookie8 = cookie;
            break;
        case 8:
            self.ScreamSound9 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound9;
            _ScreamSoundCookie9 = cookie;
            break;
        case 9:
            self.ScreamSound10 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound10;
            _ScreamSoundCookie10 = cookie;
            break;
        case 10:
            self.ScreamSound11 = [[SGAudioManager audioManager] playSoundEffectWithFilename:self.cookieScreamStrings[_whichScream] FileType:@"caf"]; //@"m4a"];
            
            //scream = _ScreamSound11;
            _ScreamSoundCookie11 = cookie;
            break;
    }
    
    _whichScream++;
    if(_whichScream >= 4)
    {
        _whichScream = 0;
    }
    
//    if([scream isPlaying])
//    {
//        [scream stop];
//    }
//    
//    //DebugLog(@"Scream.volume: %f", [SGAppDelegate appDelegate].masterVolume);
//    
//    if (![volumeButtonState isEqualToString:@"mute"])
//    {
//        scream.volume = [SGAppDelegate appDelegate].masterVolume;
//        [scream play];
//    }
}

-(void)AdjustScreamVolume:(int)which;
{
    AVAudioPlayer* scream;
    SKSpriteNode* cookie;
    switch (which) {
        case 0:
            scream = _ScreamSound1;
            cookie = _ScreamSoundCookie1;
            break;
        case 1:
            scream = _ScreamSound2;
            cookie = _ScreamSoundCookie2;
            break;
        case 2:
            scream = _ScreamSound3;
            cookie = _ScreamSoundCookie3;
            break;
        case 3:
            scream = _ScreamSound4;
            cookie = _ScreamSoundCookie4;
            break;
        case 4:
            scream = _ScreamSound5;
            cookie = _ScreamSoundCookie5;
            break;
        case 5:
            scream = _ScreamSound6;
            cookie = _ScreamSoundCookie6;
            break;
        case 6:
            scream = _ScreamSound7;
            cookie = _ScreamSoundCookie7;
            break;
        case 7:
            scream = _ScreamSound8;
            cookie = _ScreamSoundCookie8;
            break;
        case 8:
            scream = _ScreamSound9;
            cookie = _ScreamSoundCookie9;
            break;
        case 9:
            scream = _ScreamSound10;
            cookie = _ScreamSoundCookie10;
            break;
        case 10:
            scream = _ScreamSound11;
            cookie = _ScreamSoundCookie11;
            break;
    }

    // values need to be floats
    
    // a <= x <= b
    
    // 	0 <= (x-a)/(b-a) <=1
    
    // 	new_value = ( (old_value - old_min) / (old_max - old_min) ) * (new_max - new_min) + newmin
    float Y1 = cookie.position.y;
    float Y2 = kScreenHeight;
    float Volume = Y1/Y2;
    
//    DebugLog(@"Scream.volume: %f", [SGAppDelegate appDelegate].masterVolume - Volume);
    
    float checkVolume = [SGAppDelegate appDelegate].masterVolume - Volume;
    if (checkVolume > 0)
    {
        scream.volume = checkVolume;
    }
    else
    {
        scream.volume = 0;
    }
}

-(void)DeadCookie:(SKSpriteNode*)cookie
{
    if(cookie == _ScreamSoundCookie1){
        _ScreamSoundCookie1 = nil;
        [_ScreamSound1 stop];
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit1" FileType:@"wav"];
        //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit1" withFileType:@".wav"]];
    }else
        if(cookie == _ScreamSoundCookie2){
            _ScreamSoundCookie2 = nil;
            [_ScreamSound2 stop];
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit2" FileType:@"wav"];
            //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit2" withFileType:@".wav"]];
        }else
            if(cookie == _ScreamSoundCookie3){
                _ScreamSoundCookie3 = nil;
                [_ScreamSound3 stop];
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit3" FileType:@"wav"];
                //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit3" withFileType:@".wav"]];
            }else
                if(cookie == _ScreamSoundCookie4){
                    _ScreamSoundCookie4 = nil;
                    [self.ScreamSound4 stop];
                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit4" FileType:@"wav"];
                    //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit4" withFileType:@".wav"]];
                }else
                    if(cookie == _ScreamSoundCookie5){
                        _ScreamSoundCookie5 = nil;
                        [self.ScreamSound5 stop];
                        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit4" FileType:@"wav"];
                        //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit4" withFileType:@".wav"]];
                    }else
                        if(cookie == _ScreamSoundCookie6){
                            _ScreamSoundCookie6 = nil;
                            [self.ScreamSound6 stop];
                            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit4" FileType:@"wav"];
                            //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit4" withFileType:@".wav"]];
                        }else
                            if(cookie == _ScreamSoundCookie7){
                                _ScreamSoundCookie7 = nil;
                                [self.ScreamSound7 stop];
                                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit4" FileType:@"wav"];
                                //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit4" withFileType:@".wav"]];
                            }else
                                if(cookie == _ScreamSoundCookie8){
                                    _ScreamSoundCookie8 = nil;
                                    [self.ScreamSound8 stop];
                                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit4" FileType:@"wav"];
                                    //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit4" withFileType:@".wav"]];
                                }else
                                    if(cookie == _ScreamSoundCookie9){
                                        _ScreamSoundCookie9 = nil;
                                        [self.ScreamSound9 stop];
                                        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit4" FileType:@"wav"];
                                        //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit4" withFileType:@".wav"]];
                                    }else
                                        if(cookie == _ScreamSoundCookie10){
                                            _ScreamSoundCookie10 = nil;
                                            [self.ScreamSound10 stop];
                                            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit4" FileType:@"wav"];
                                            //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit4" withFileType:@".wav"]];
                                        }else
                                            if(cookie == _ScreamSoundCookie11){
                                                _ScreamSoundCookie11 = nil;
                                                [self.ScreamSound11 stop];
                                                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Hits_Hit4" FileType:@"wav"];
                                                //[self runAction:[SGAudioManager MakeSoundEffectAction:@"Cookie_Hits_Hit4" withFileType:@".wav"]];
                                            }
}

-(void)Shut_The_Cookies_up
{
    [[SGAudioManager audioManager] stopAllSoundEffects];
    
//    [_MilkMonsterSound1 stop];
//    [_MilkMonsterSound2 stop];
//    [_MilkMonsterSound3 stop];
//    [_MilkMonsterSound4 stop];
//    [_MilkMonsterSound5 stop];
//    [_MilkMonsterSound6 stop];
//    [_MilkMonsterSound7 stop];
//    [_MilkMonsterSound8 stop];
//    [_MilkMonsterSound9 stop];

//    [_ScreamSound1 stop];
//    [_ScreamSound2 stop];
//    [_ScreamSound3 stop];
//    [_ScreamSound4 stop];
//    [_ScreamSound5 stop];
//    [_ScreamSound6 stop];
//    [_ScreamSound7 stop];
//    [_ScreamSound8 stop];
//    [_ScreamSound9 stop];
//    [_ScreamSound10 stop];
//    [_ScreamSound11 stop];
}

@end
