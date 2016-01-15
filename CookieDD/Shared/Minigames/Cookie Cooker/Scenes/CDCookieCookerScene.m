//
//  CDCookieJarOperationScene.m
//  CookieDD
//
//  Created by gary johnston on 9/12/13.
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

#import "CDCookieCookerScene.h"
#import "CDCookieCookerCookieObject.h"
#import "CDCookieCookerCookieJarObject.h"
#import "CDCookieCookerTrashCanObject.h"
#import "CDParticleEmitter.h"
#import "SGAudioManager.h"

@interface CDCookieCookerScene()

@property (strong, nonatomic) CDCookieCookerCookieObject *cookieObject;
@property (strong, nonatomic) CDCookieCookerCookieJarObject *cookieJarObject;
@property (strong, nonatomic) CDCookieCookerTrashCanObject *trashCanObject;
@property (strong, nonatomic) CDCookieCookerCookieObject *clickedCookieObject;

@property (strong, nonatomic) SKSpriteNode *bakingPanObject;
@property (strong, nonatomic) SKSpriteNode *spatulaObject;
@property (strong, nonatomic) SKSpriteNode *counterObject;

@property (strong, nonatomic) SKTextureAtlas *atlas;
@property (strong, nonatomic) SKTextureAtlas *accessoryAtlas;
@property (strong, nonatomic) SKTexture *spatulaTexture;

@property (strong, nonatomic) SKLabelNode *scoreLabel;
//@property (strong, nonatomic) SKLabelNode *trashedLabel;
//@property (strong, nonatomic) SKLabelNode *missedLabel;
@property (strong, nonatomic) SKLabelNode *timerLabel;

//@property (strong, nonatomic) SKAction* DropSound1;
//@property (strong, nonatomic) SKAction* DropSound2;
//@property (strong, nonatomic) SKAction* DropSound3;
//@property (strong, nonatomic) SKAction* DropSound4;

//@property (strong, nonatomic) SKAction* ScreamSound1;
//@property (strong, nonatomic) SKAction* ScreamSound2;
//@property (strong, nonatomic) SKAction* ScreamSound3;
//@property (strong, nonatomic) SKAction* ScreamSound4;
//@property (strong, nonatomic) SKAction* ScreamSound5;
//@property (strong, nonatomic) SKAction* ScreamSound6;

//@property (strong, nonatomic) SKAction* SpatulaSound1;
//@property (strong, nonatomic) SKAction* SpatulaSound2;
//@property (strong, nonatomic) SKAction* SpatulaSound3;
//@property (strong, nonatomic) SKAction* SpatulaSound4;
//@property (strong, nonatomic) SKAction* SpatulaSound5;

//@property (strong, nonatomic) SKAction* deathPoofSound;

//@property (strong, nonatomic) SKAction* WinSound1;
//@property (strong, nonatomic) SKAction* WinSound2;
//@property (strong, nonatomic) SKAction* WinSound3;
//@property (strong, nonatomic) SKAction* WinSound4;
//@property (strong, nonatomic) SKAction* WinSound5;

@property (strong, nonatomic) NSString *volumeButtonState;
@property (strong, nonatomic) NSUserDefaults *volumeButtonStateDefault;

@property (assign, nonatomic) BOOL isBurnt;
@property (assign, nonatomic) BOOL contentCreated;
@property (assign, nonatomic) BOOL hasStarted;
@property (assign, nonatomic) BOOL didWin;
@property (assign, nonatomic) BOOL didCreatePopup;
@property (assign, nonatomic) BOOL isSceaming;

@property (assign, nonatomic) int score;
@property (assign, nonatomic) int goalScore;
@property (assign, nonatomic) int trashedCount;
@property (assign, nonatomic) int missedCount;
@property (assign, nonatomic) int respawnDelayTime;
@property (assign, nonatomic) int numberOfBurningCookies;

@property (assign, nonatomic) float speedOfContainers;
@property (assign, nonatomic) float previousTime;


// Dustins sound stuff

//@property (strong, nonatomic) AVAudioPlayer* FryingSound;

@end


@implementation CDCookieCookerScene

dispatch_queue_t sizz_sound_queue;

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
//    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    self.name = @"scene";
    
    
    //[[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"Cookie-Cooker" FileType:@"m4a" volume:0.3f numberOfLoopes:-1];
    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"Cookie-Cooker" FileType:@"caf" volume:0.3f numberOfLoopes:-1];
    
    if(IS_IPHONE_5)
    {
        self.accessoryAtlas = [SKTextureAtlas atlasNamed:@"cookieCooker_accessories_iphone5"];
        self.atlas = [SKTextureAtlas atlasNamed:@"cookieCooker_iphone5"];
    }
    else if (IS_IPHONE_4)
    {
        self.accessoryAtlas = [SKTextureAtlas atlasNamed:@"cookieCooker_accessories_iphone5"];
        self.atlas = [SKTextureAtlas atlasNamed:@"cookieCooker_iphone4_retina"];
    }
    else
    {
        self.accessoryAtlas = [SKTextureAtlas atlasNamed:@"cookieCooker_accessories_ipad"];
        
        // NonRetina is missing graphics
//        if (IS_RETINA)
//        {
            self.atlas = [SKTextureAtlas atlasNamed:@"cookieCooker_ipad_retina"];
//        }
//        else
//        {
//            self.atlas = [SKTextureAtlas atlasNamed:@"cookieCooker_ipad"];
//        }
    }
    
    _volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
    _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
    
    self.score = 0;
    self.trashedCount = 0;
    self.missedCount = 0;
    self.cookieCount = 12;
    self.respawnDelayTime = 5;
    self.currentSeconds = 500;
    
    self.didWin = NO;
    self.didClickCookie = NO;
    self.didCreatePopup = NO;
    
    self.cookieArray = [NSMutableArray new];
    self.respawnPointArray = [NSMutableArray new];
    
    // sound setup
    
    self.numberOfBurningCookies = 0;
    self.isSceaming = NO;
    
//    self.FryingSound = [[SGAudioManager audioManager] MakeAudioPlayerForSoundEffect:@"Cookie_Cooker_Frying" withType:@".m4a"];
//    self.FryingSound.numberOfLoops = -1;
	
	//self.FryingSound = [[SGAudioManager audioManager]playSoundEffectWithFilename:@"Cookie_Cooker_Frying" FileType:@"m4a" volume:1.0f numberOfLoopes:-1];
    
	
//    self.DropSound1 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Drops1" withFileType:@".m4a"];
//    self.DropSound2 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Drops2" withFileType:@".m4a"];
//    self.DropSound3 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Drops3" withFileType:@".m4a"];
//    self.DropSound4 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Drops4" withFileType:@".m4a"];
//    self.ScreamSound1 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Scream1" withFileType:@".m4a"];
//    self.ScreamSound2 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Scream2" withFileType:@".m4a"];
//    self.ScreamSound3 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Scream3" withFileType:@".m4a"];
//    self.ScreamSound4 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Scream4" withFileType:@".m4a"];
//    self.ScreamSound5 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Scream5" withFileType:@".m4a"];
//    self.ScreamSound6 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Scream4" withFileType:@".m4a"];
	
//    self.SpatulaSound1 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Spatula1" withFileType:@".m4a"];
//    self.SpatulaSound2 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Spatula2" withFileType:@".m4a"];
//    self.SpatulaSound3 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Spatula3" withFileType:@".m4a"];
//    self.SpatulaSound4 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Spatula4" withFileType:@".m4a"];
//    self.SpatulaSound5 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Spatula5" withFileType:@".m4a"];
//    self.WinSound1 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Win1" withFileType:@".m4a"];
//    self.WinSound2 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Win2" withFileType:@".m4a"];
//    self.WinSound3 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Win3" withFileType:@".m4a"];
//    self.WinSound4 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Win4" withFileType:@".m4a"];
	
//    self.deathPoofSound = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_DeathPoof" withFileType:@".m4a"];
//    self.WinSound5 = [SGAudioManager MakeSoundEffectAction:@"Cookie_Cooker_Win5"];

    [self addChildren];
}

- (void)setup
{
    self.hasStarted = NO;
    self.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(cookieCookerWillPresentDifficultyScreen:)])
    {
        [self.delegate cookieCookerWillPresentDifficultyScreen:self];
    }
}

//- (void)stopBackGroundMusic
//{
//    [self StopTheBurningSound];
//    [[SGAudioManager audioManager] stopAllAudio];
//}

- (void)startMiniGame
{
    switch (self.difficulty)
    {
        case gameDifficultyLevelEasy:
            self.maxSeconds = 60;
            self.goalScore = 20;
			self.speedOfContainers = 0;
            break;
            
        case gameDifficultyLevelMedium:
            self.maxSeconds = 60;
            self.goalScore = 30;
			self.speedOfContainers = 1;
            break;
            
        case gameDifficultyLevelHard:
            self.maxSeconds = 60;
            self.goalScore = 45;
			self.speedOfContainers = .5;
            break;
            
        case gameDifficultyLevelCrazy:
            self.maxSeconds = 60;
            self.goalScore = 50;
			self.speedOfContainers = .5;
            break;
        
        default:
            break;
    }
    
    self.previousTime = 0.0f;
    self.currentSeconds = self.maxSeconds;

    self.userInteractionEnabled = YES;
    self.hasStarted = YES;
    
    int minutes = _currentSeconds/60;
    int seconds = _currentSeconds%60;
    
    [_timerLabel setText:[NSString stringWithFormat:@"%02i:%02i", minutes, seconds]];
    _timerLabel.hidden = NO;
    
    _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
    _scoreLabel.hidden = NO;
	
    // Run the jar/trash actions
	if (_difficulty != gameDifficultyLevelEasy)
	{
		float jarXPos = _cookieJarObject.position.x;
		SKAction *moveJarAction = [SKAction customActionWithDuration:_speedOfContainers actionBlock:^(SKNode *node, CGFloat elapsedTime) {
			_cookieJarObject.position = CGPointMake(jarXPos, [_cookieJarObject moveTheJar:_cookieJarObject.position.y]) ;
		}];
		[_cookieJarObject runAction:[SKAction repeatActionForever:moveJarAction]];
		
		float trashXPos = _trashCanObject.position.x;
		SKAction *moveTrashAction = [SKAction customActionWithDuration:_speedOfContainers actionBlock:^(SKNode *node, CGFloat elapsedTime) {
			_trashCanObject.position = CGPointMake(trashXPos, [_trashCanObject moveTheTrash:_trashCanObject.position.y]);
		}];
		[_trashCanObject runAction:[SKAction repeatActionForever:moveTrashAction]];
    }
}

- (void)addChildren
{
    SKSpriteNode *backgroundImage;
    if (IS_IPHONE_5)
    {
        backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"cookieCooker_background-568h"];
    }
    else
    {
        backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"cookieCooker_background"];
    }
    
    backgroundImage.name = @"background";
    backgroundImage.position = CGPointMake(backgroundImage.size.width*.5, CGRectGetMidY(self.frame));
    [self addChild:backgroundImage];
    
    SKTexture *counterTexture = [_atlas textureNamed:@"cookieCooker_counter"];
    _counterObject = [SKSpriteNode spriteNodeWithTexture:counterTexture];
    _counterObject.name = @"background";
    _counterObject.position = CGPointMake((_counterObject.size.width*.5), CGRectGetMidY(self.frame));
    [self addChild:self.counterObject];
    
    SKTexture *bakingPanTexture = [_atlas textureNamed:@"cookieCooker_stove"];
    _bakingPanObject = [SKSpriteNode spriteNodeWithTexture:bakingPanTexture];
    _bakingPanObject.name = @"bakingPanObject";
    
    _cookieJarObject = [[CDCookieCookerCookieJarObject alloc]initWithScene:self];
    _cookieJarObject.name = @"cookieJarObject";
    
    _trashCanObject = [[CDCookieCookerTrashCanObject alloc] initWithScene:self];
    _trashCanObject.name = @"trashCanObject";
    
    
    // Adjust the position of the jar/trash/timer based on device
    if (IS_IPHONE_5)
    {
        _bakingPanObject.position = CGPointMake(CGRectGetMidX(self.frame)-6, CGRectGetMidY(self.frame));
        _cookieJarObject.position = CGPointMake((_cookieJarObject.size.width*.5)+35, CGRectGetMidY(self.frame));
        _trashCanObject.position = CGPointMake(CGRectGetMaxX(self.frame) - (_trashCanObject.size.width*.5)-40, CGRectGetMidY(self.frame));
    }
    else if (IS_IPHONE_4)
    {
        _bakingPanObject.position = CGPointMake(CGRectGetMidX(self.frame)-7, CGRectGetMidY(self.frame));
        _cookieJarObject.position = CGPointMake((_cookieJarObject.size.width*.5)+10, CGRectGetMidY(self.frame));
        _trashCanObject.position = CGPointMake(CGRectGetMaxX(self.frame) - (_trashCanObject.size.width*.5)-20, CGRectGetMidY(self.frame));
    }
    else
    {
        _bakingPanObject.position = CGPointMake(CGRectGetMidX(self.frame)+40, CGRectGetMidY(self.frame));
        _cookieJarObject.position = CGPointMake((_cookieJarObject.size.width*.5)+10, CGRectGetMidY(self.frame));
        _trashCanObject.position = CGPointMake(CGRectGetMaxX(self.frame) - (_trashCanObject.size.width*.5)-5, CGRectGetMidY(self.frame));
    }
    
    [self addChild:_bakingPanObject];
    [self addChild:_cookieJarObject];
    [self addChild:_trashCanObject];
    
    
    [self spawnCookies];
    
//    _trashedLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    _trashedLabel.text = [NSString stringWithFormat:@"Trashed: %i", _trashedCount];
//    _trashedLabel.fontSize = 10;
//    _trashedLabel.position = CGPointMake(30+(_trashedLabel.frame.size.width*.5), 40);
//    [self addChild:self.trashedLabel];
//    
//    _missedLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    _missedLabel.text = [NSString stringWithFormat:@"Missed: %i", _missedCount];
//    _missedLabel.fontSize = 10;
//    _missedLabel.position = CGPointMake(30+(_missedLabel.frame.size.width*.5), 60);
//    [self addChild:_missedLabel];
    
    _spatulaTexture = [_accessoryAtlas textureNamed:@"cookieCooker_spatula"];
    _spatulaObject = [SKSpriteNode spriteNodeWithTexture:_spatulaTexture];
    _spatulaObject.xScale = .6;
    _spatulaObject.yScale = .6;
    _spatulaObject.zPosition = 1;
    _spatulaObject.name = @"spatula";
    _spatulaObject.hidden = YES;
    [self addChild:_spatulaObject];
    
    
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

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL foundCookie = NO;
    
    if (_clickedCookieObject == nil)
    {
        for (UITouch *touch in touches)
        {
            CGPoint touchLocation = [touch locationInNode:self];
            NSArray *nodes = [self nodesAtPoint:touchLocation];
            
            if ([nodes count])
            {
                for (SKNode *node in nodes)
                {
//                    DebugLog(@"Nodes: %@", nodes);
                    //Make sure it's the proper type.
                    if (([node isKindOfClass:[CDCookieCookerCookieObject class]] || [node.name isEqualToString:@"cookieObject"]) && (!foundCookie))
                    {
                        foundCookie = YES;
                        _didClickCookie = YES;
                        
                        _spatulaObject.anchorPoint = CGPointMake(0.5, 1);
                        [_spatulaObject removeAllActions];
                        
                        if (IS_IPHONE_4 || IS_IPHONE_5)
                        {
                            _spatulaObject.position = CGPointMake(touchLocation.x, touchLocation.y);
                            
                        }
                        else
                        {
                            _spatulaObject.position = CGPointMake(touchLocation.x, touchLocation.y);
                        }
                        
                        _clickedCookieObject = (CDCookieCookerCookieObject *) node;
                        _clickedCookieObject.cooking = NO;
                        _clickedCookieObject.position = CGPointMake(0, 0);
                        [_clickedCookieObject removeFromParent];
                        [_spatulaObject addChild:_clickedCookieObject];
                        _clickedCookieObject.xScale = 1.4;
                        _clickedCookieObject.yScale = 1.4;
                        
                        _clickedCookieObject.zPosition = 2;
                        _spatulaObject.hidden = NO;
                        
                        
                        SKAction * move_spatula_a_litte = [SKAction sequence:@[[SKAction runBlock:^{
                            
                            _spatulaObject.anchorPoint = CGPointMake(0.5, _spatulaObject.anchorPoint.y - 0.075);
                            _clickedCookieObject.position = CGPointMake(0, _clickedCookieObject.position.y + (_spatulaObject.size.height * 0.1));
                            
                        }],[SKAction waitForDuration:0.025]]];
                        
                        SKAction * reaped_movement = [SKAction repeatAction:move_spatula_a_litte count:10];
                        
                        [_spatulaObject runAction:reaped_movement];
                        
                        _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
                        if (![_volumeButtonState isEqualToString:@"mute"])
                        {
                            int whichSound = arc4random() % 5;
                            switch (whichSound) {
                                case 0:
                                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Spatula1" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
                                    break;
                                case 1:
                                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Spatula2" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
                                    break;
                                case 2:
                                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Spatula3" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
                                    break;
                                case 3:
                                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Spatula4" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
                                    break;
                                case 4:
                                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Spatula5" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
                                    break;
                            }
                        }
                    }
                    else
                    {
//                        DebugLog(@"Node Class: %@", [node class]);
                    }
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_didClickCookie)
    {
        for (UITouch *touch in touches)
        {
            CGPoint touchLocation = [touch locationInNode:self];
            if (touchLocation.y+(_spatulaObject.size.height*.5) < self.size.height)
            {
                if (IS_IPHONE_4 || IS_IPHONE_5)
                {
                    _spatulaObject.position = CGPointMake(touchLocation.x, touchLocation.y);
                }
                else
                {
                    _spatulaObject.position = CGPointMake(touchLocation.x, touchLocation.y);
                }
            }
            else
            {
                _spatulaObject.position = CGPointMake(touchLocation.x, _spatulaObject.position.y);
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint cookiePostion = [_trashCanObject.parent convertPoint:_clickedCookieObject.position fromNode:_spatulaObject];
    
    if (_didClickCookie)
    {
        if ((cookiePostion.x < (_trashCanObject.position.x + _trashCanObject.size.width*.5))   &&
            (cookiePostion.x > (_trashCanObject.position.x - _trashCanObject.size.width*.5))   &&
            (cookiePostion.y < (_trashCanObject.position.y + _trashCanObject.size.height*.5))  &&
            (cookiePostion.y > (_trashCanObject.position.y - _trashCanObject.size.height*.5)))
        {
            // Dropped in Trash Can
            if (_clickedCookieObject.raw)
            {
                _score--;
                
                if (_score < _goalScore)
                {
                    _didWin = NO;
                }
                
				_clickedCookieObject.didScoreIncrease = NO;
				_clickedCookieObject.willDisplayPopUpScore = YES;
				
                _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
            }
            else if (_clickedCookieObject.burnt)
            {
				_clickedCookieObject.didScoreIncrease = NO;
				_clickedCookieObject.willDisplayPopUpScore = NO;
				
                _trashedCount += 1;
//                _trashedLabel.text = [NSString stringWithFormat:@"Trashed: %i", _trashedCount];
                
                self.numberOfBurningCookies--;
                
                if(self.numberOfBurningCookies <= 0)
                {
                    [self StopTheBurningSound];
                }
            }
            else
            {
				_clickedCookieObject.didScoreIncrease = NO;
				_clickedCookieObject.willDisplayPopUpScore = YES;
				
                _score--;
                
                if (_score < _goalScore)
                {
                    _didWin = NO;
                }
                
                _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
            }
            
            [_respawnPointArray addObject:[NSValue valueWithCGPoint:_clickedCookieObject.pointForRespawn]];
            
            [self performSelector:@selector(respawn) withObject:self afterDelay:_respawnDelayTime];
            
            [_clickedCookieObject removeFromParent];
            _clickedCookieObject.xScale = 0.8;
            _clickedCookieObject.yScale = 0.8;
            _clickedCookieObject.position = cookiePostion;
            [self addChild:_clickedCookieObject];
            
            [_cookieArray removeObject:_clickedCookieObject];
            [_clickedCookieObject removeCookieWillAnimateForMaxTime:YES];
            _clickedCookieObject = nil;
            
            
            _didClickCookie = NO;
            _spatulaObject.hidden = YES;
            
            _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
            if (![_volumeButtonState isEqualToString:@"mute"])
            {
                [self playDropSound];
            }
            
        }
        else if ((cookiePostion.x < (_cookieJarObject.position.x + _cookieJarObject.size.width*.5)-20)   &&
                 (cookiePostion.x > (_cookieJarObject.position.x - _cookieJarObject.size.width*.5)+20)   &&
                 (cookiePostion.y < (_cookieJarObject.position.y + _cookieJarObject.size.height*.5)-20)  &&
                 (cookiePostion.y > (_cookieJarObject.position.y - _cookieJarObject.size.height*.5)+20))
        {
            // Dropped in Cookie Jar
            if (self.clickedCookieObject.raw)
            {
				_clickedCookieObject.didScoreIncrease = NO;
				_clickedCookieObject.willDisplayPopUpScore = YES;
				
                _score--;
                
                if (_score < _goalScore)
                {
                    _didWin = NO;
                }
                
                _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
            }
            else if (self.clickedCookieObject.burnt)
            {
				_clickedCookieObject.didScoreIncrease = NO;
				_clickedCookieObject.willDisplayPopUpScore = YES;
				
                _score--;
                
                if (_score < _goalScore)
                {
                    _didWin = NO;
                }
                
                _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
                
                
                self.numberOfBurningCookies--;
                
                if(self.numberOfBurningCookies <= 0){
                    
                    [self StopTheBurningSound];
                }
            }
            else
            {
				_clickedCookieObject.didScoreIncrease = YES;
				_clickedCookieObject.willDisplayPopUpScore = YES;
				
                _score++;
                
                if (_score >= _goalScore)
                {
                    _didWin = YES;
                }
                
                _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
                
                _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
                if (![_volumeButtonState isEqualToString:@"mute"])
                {
                    int whichSound = arc4random() % 4;
                    switch (whichSound) {
                        case 0:
                            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Win1" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
                            break;
                        case 1:
                            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Win2" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
                            break;
                        case 2:
                            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Win3" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
                            break;
                        case 3:
                            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Win4" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
                            break;
                    }
                }
            }
            
            [_respawnPointArray addObject:[NSValue valueWithCGPoint:_clickedCookieObject.pointForRespawn]];
            
            [self performSelector:@selector(respawn) withObject:nil afterDelay:_respawnDelayTime];
            
            [_clickedCookieObject removeFromParent];
            _clickedCookieObject.xScale = 0.8;
            _clickedCookieObject.yScale = 0.8;
            _clickedCookieObject.position = cookiePostion;
            [self addChild:_clickedCookieObject];
            
            [_cookieArray removeObject:_clickedCookieObject];
            [_clickedCookieObject removeCookieWillAnimateForMaxTime:NO];
            _clickedCookieObject = nil;
            
            
            _didClickCookie = NO;
            _spatulaObject.hidden = YES;
            
            
            _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
            if (![_volumeButtonState isEqualToString:@"mute"])
            {
                [self playDropSound];
            }
        }
        else if ((cookiePostion.x < (_counterObject.position.x + _counterObject.size.width*.5))   &&
                 (cookiePostion.x > (_counterObject.position.x - _counterObject.size.width*.5))   &&
                 (cookiePostion.y < (_counterObject.position.y + _counterObject.size.height*.5))  &&
                 (cookiePostion.y > (_counterObject.position.y - _counterObject.size.height*.5)))
        {
            // Dropped on Floor
            _missedCount += 1;
//            _missedLabel.text = [NSString stringWithFormat:@"Missed: %i", _missedCount];
            
			_clickedCookieObject.didScoreIncrease = NO;
			_clickedCookieObject.willDisplayPopUpScore = YES;
			
            _score--;
            
            if (_score < _goalScore)
            {
                _didWin = NO;
            }
            
            _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
            
            if(self.clickedCookieObject.burnt)
                self.numberOfBurningCookies--;
            
            if(self.numberOfBurningCookies <= 0){
                
                [self StopTheBurningSound];
            }
            
            [_respawnPointArray addObject:[NSValue valueWithCGPoint:_clickedCookieObject.pointForRespawn]];
            
            [self performSelector:@selector(respawn) withObject:nil afterDelay:_respawnDelayTime];
            
            [_clickedCookieObject removeFromParent];
            _clickedCookieObject.xScale = 0.8;
            _clickedCookieObject.yScale = 0.8;
            _clickedCookieObject.position = cookiePostion;
            [self addChild:_clickedCookieObject];
            
            [_cookieArray removeObject:_clickedCookieObject];
            [_clickedCookieObject removeCookieWillAnimateForMaxTime:NO];
            _clickedCookieObject = nil;
            
            
            _didClickCookie = NO;
            _spatulaObject.hidden = YES;
            
            _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
            if (![_volumeButtonState isEqualToString:@"mute"])
            {
                [self playDropSound];
            }
        }
        else if ((_spatulaObject.position.x > (_bakingPanObject.position.x + _bakingPanObject.size.width*.5) - (_bakingPanObject.size.width*.1))   ||
                 (_spatulaObject.position.x < (_bakingPanObject.position.x - _bakingPanObject.size.width*.5) + (_bakingPanObject.size.width*.1))   ||
                 (_spatulaObject.position.y > (_bakingPanObject.position.y + _bakingPanObject.size.height*.5))  ||
                 (_spatulaObject.position.y < (_bakingPanObject.position.y - _bakingPanObject.size.height*.5)))
        {
            self.missedCount += 1;
			_clickedCookieObject.willDisplayPopUpScore = YES;
//            self.missedLabel.text = [NSString stringWithFormat:@"Missed: %i", _missedCount];
            
            _score--;
            
            if (_score < _goalScore)
            {
                _didWin = NO;
            }
            
            _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
            
            
            if(self.clickedCookieObject.burnt)
                self.numberOfBurningCookies--;
            
            if (self.numberOfBurningCookies <= 0){
                
                [self StopTheBurningSound];
            }
            
            [_respawnPointArray addObject:[NSValue valueWithCGPoint:_clickedCookieObject.pointForRespawn]];
            
            [self performSelector:@selector(respawn) withObject:nil afterDelay:_respawnDelayTime];
            
            [_clickedCookieObject removeFromParent];
            _clickedCookieObject.xScale = 0.8;
            _clickedCookieObject.yScale = 0.8;
            _clickedCookieObject.position = cookiePostion;
            [self addChild:_clickedCookieObject];
            
            [_cookieArray removeObject:_clickedCookieObject];
            [_clickedCookieObject removeCookieWillAnimateForMaxTime:YES];
            _clickedCookieObject = nil;
            
            
            _didClickCookie = NO;
            _spatulaObject.hidden = YES;
            
            _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
            if (![_volumeButtonState isEqualToString:@"mute"])
            {
                [self playDropSound];
            }
        }
        else
        {
            DebugLog(@"Still over pan");
        }
    }
    
    DebugLog(@"%i",self.numberOfBurningCookies);
}

- (void)playDropSound
{
    int whichSound = arc4random() % 4;
    switch (whichSound) {
        case 0:
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Drops1" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
            break;
        case 1:
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Drops2" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
            break;
        case 2:
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Drops3" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
            break;
        case 3:
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Drops4" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
            break;
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    // Check for the burn victims....
    if (_hasStarted && !_didCreatePopup)
    {
        for (CDCookieCookerCookieObject *cookie in _cookieArray)
        {
            [cookie updateCookie];
        }
    }
    if (currentTime > _previousTime+1)
    {
        _previousTime = currentTime;
        [self updateTimer];
    }
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive)
	{
		self.view.paused = YES;
		self.paused = YES;
		
		[[SGAudioManager audioManager] pauseAllAudio];
	}
}

#pragma mark - Timer Methods

- (void)updateTimer
{
    if (self.currentSeconds >= 0)
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
		[self removeAllActions];
		
        _didClickCookie = NO;
        _clickedCookieObject = nil;
        _didCreatePopup = YES;
        
        [_trashCanObject removeAllActions];
        [_cookieJarObject removeAllActions];
        
        self.paused = YES;
        self.userInteractionEnabled = NO;
        
        [self touchesEnded:nil withEvent:nil];
        
        if ([self.delegate respondsToSelector:@selector(cookieCookerSceneDidEndScene:WithScore:WithGoalScore:WithWin:)])
        {
			//[[SGAudioManager audioManager] stopAllAudio];
            //[self.FryingSound stop];
            [self.delegate cookieCookerSceneDidEndScene:self WithScore:_score WithGoalScore:_goalScore WithWin:_didWin];
        }
    }
}


#pragma mark - Spawning

- (void)spawnCookies
{
    ///////////////////////
    //// Spawn Cookies ////
    ///////////////////////
    
    SKTextureAtlas *tempAtlas;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        tempAtlas = [SKTextureAtlas atlasNamed:@"cookieCookerCookie_iphone"];
    }
    else
    {
        tempAtlas = [SKTextureAtlas atlasNamed:@"cookieCookerCookie_ipad"];
    }
    SKTexture *cookieImage = [tempAtlas textureNamed:@"cookieFace00"];
    
    float burnerSpacerY = _bakingPanObject.size.height * .158;
    float burnerSpacerX = _bakingPanObject.size.width * .225;
    float topSpacer = _bakingPanObject.size.height * .225;
    float sideSpacer = _bakingPanObject.size.width * .175;
    
    int numPerRow = 3;
    int numInRow = 0;
    
    int xPos = ((_bakingPanObject.position.x - (_bakingPanObject.size.width*.5)) + (cookieImage.size.width*.5)) + sideSpacer + 5;
    int xPosOrigin = xPos;
    int yPos = ((_bakingPanObject.position.y + (_bakingPanObject.size.height*.5)) - (cookieImage.size.height*.5)) - topSpacer;
    
    for (int count = 0; count < _cookieCount; count++)
    {
        numInRow += 1;
        CDCookieCookerCookieObject *myCookie = [[[CDCookieCookerCookieObject alloc] init] initWithScene:self];
        
        if (numInRow <= numPerRow)
        {
            myCookie.position = CGPointMake(xPos, yPos);
//            myCookie.name = @"cookieObject";
            myCookie.pointForRespawn = myCookie.position;
            myCookie.xScale = .8;
            myCookie.yScale = .8;
            
            [_cookieArray addObject:myCookie];
            [self addChild:myCookie];
            
            xPos += burnerSpacerX;
        }
        if (numInRow == numPerRow)
        {
            yPos -= burnerSpacerY;
            xPos = xPosOrigin;
            
            numInRow = 0;
        }
    }
}

- (void)respawn
{
    if (!self.paused)
    {
        if ([_respawnPointArray count] > 0)
        {
            int random = arc4random()%[_respawnPointArray count];
            
            NSValue *value = _respawnPointArray[random];
            CDCookieCookerCookieObject *myCookie = [[CDCookieCookerCookieObject alloc]initWithScene:self];
            myCookie.position = [value CGPointValue];
            myCookie.name = @"cookieObject";
            myCookie.pointForRespawn = myCookie.position;
            myCookie.xScale = .8;
            myCookie.yScale = .8;
            
            [_cookieArray addObject:myCookie];
            [_respawnPointArray removeObject:_respawnPointArray[random]];
            
            [self addChild:myCookie];
        }
    }
    else
    {
        [self performSelector:@selector(respawn) withObject:nil afterDelay:_respawnDelayTime];
    }
}

- (void)PlayTheBurningSound
{
    DebugLog(@"play burning sound");
    
    _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
    if (![_volumeButtonState isEqualToString:@"mute"])
    {
        if(self.numberOfBurningCookies == 0)
        {
            //if(!self.FryingSound.isPlaying)
            //{
                //[self.FryingSound play];
            //}
        }
    }
    self.numberOfBurningCookies++;
}

-(void)StopTheBurningSound
{
    DebugLog(@"stop the burning");
    //[self.FryingSound stop];
    
}

- (void)playScreamWithSoundName:(NSString *)soundName
{
    self.isSceaming = YES;
    
    //[[SGAudioManager audioManager] playSoundEffectWithFilename:soundName FileType:@"m4a" volume:1.0f completion:^(BOOL completion) {
    [[SGAudioManager audioManager] playSoundEffectWithFilename:soundName FileType:@"caf" volume:1.0f completion:^{
        self.isSceaming = NO;
    }];
}

- (void)ScreamForMe
{
    _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
    if (![_volumeButtonState isEqualToString:@"mute"])
    {
        if(!self.isSceaming){
            
//            SKAction* screaming;
            
            int whichScream = arc4random() % 3;
            switch (whichScream) {
                case 0:
                    [self playScreamWithSoundName:@"Cookie_Cooker_Scream1"];
                    break;
                case 1:
                    [self playScreamWithSoundName:@"Cookie_Cooker_Scream2"];
                    break;
                case 2:
                    [self playScreamWithSoundName:@"Cookie_Cooker_Scream3"];
                    break;
                case 3:
                    [self playScreamWithSoundName:@"Cookie_Cooker_Scream4"];
                    break;
                case 4:
                    [self playScreamWithSoundName:@"Cookie_Cooker_Scream5"];
                    break;
                case 5:
                    [self playScreamWithSoundName:@"Cookie_Cooker_Scream6"];
                    break;
            }
        }
    }
}

- (void)deathPoof
{
    _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
    if (![_volumeButtonState isEqualToString:@"mute"])
	{
		if(!self.isSceaming)
		{
			self.isSceaming = YES;
            
			//[[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_DeathPoof" FileType:@"m4a" volume:1.0f completion:^(BOOL finishedSuccessfully) {
			[[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_DeathPoof" FileType:@"caf" volume:1.0f completion:^{
				self.isSceaming = NO;
			}];
        }
	}
}

- (void)volumeWasTurnedOff
{
    DebugLog(@"number of cookies burning: %i", _numberOfBurningCookies);
    for (int count = 0; count < _numberOfBurningCookies; count++)
    {
        //[_FryingSound stop];
    }
}

- (void)volumeWasTurnedOn
{
    DebugLog(@"number of cookies burning: %i", _numberOfBurningCookies);
    for (int count = 0; count < _numberOfBurningCookies; count++)
    {
        //[_FryingSound play];
    }
}



#pragma mark - Dealloc
- (void)dealloc
{
	DebugLog(@"Scene did dealloc!");
}

@end
