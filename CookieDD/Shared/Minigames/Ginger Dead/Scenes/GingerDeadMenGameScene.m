//
//  MyScene.m
//  MiniGameTest
//
//  Created by Rodney Jenkins on 9/19/13.
//  Copyright (c) 2013 Rodney Jenkins. All rights reserved.
// http://stackoverflow.com/questions/15646433/measuring-tilt-angle-with-cmmotionmanager

#import "GingerDeadMenGameScene.h"
#import "GingerDeadMan.h"
#import "GingerDeadMen_projectile.h"
#import "GinderDeadMen_DeathNode.h"
#import "GingerDeadMen_ZombieSpawner.h"
#import "GingerDeadMen_ObstacleSpawner.h"
#import "SGAudioManager.h"
#import "BLINDED_Math.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define kUpdateInterval (1.0f/10.0f)
#define kAccelerationThreshold 0.5f

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t zombieCookieCategory   =  0x1 << 1;
static const uint32_t obstacleCategory   =  0x1 << 2;

@interface GingerDeadMenGameScene ()<SKPhysicsContactDelegate>

@property (assign, nonatomic) NSTimeInterval ZombieSpawnerUpdateTimetracker;
@property (strong, nonatomic) SKSpriteNode* background;

// game components
@property (strong, nonatomic) SKLabelNode* scoreDisplay;
@property (assign, nonatomic) int score;

@property (strong, nonatomic) GingerDeadMen_ZombieSpawner *ZombieSpawner;
@property (strong, nonatomic) GingerDeadMen_ObstacleSpawner *ObstacleSpawner;

@property (strong, nonatomic) SKLabelNode* timeDisplay;
@property (assign, nonatomic) int secondsLeft;

@property (assign, nonatomic) int magazineCap;
@property (assign, nonatomic) int shotsLeft;
@property (assign, nonatomic) float reloadTime;
@property (strong, nonatomic) SKSpriteNode* ammoGuage;
@property (strong, nonatomic) SKSpriteNode* reload_alert;
@property (assign, nonatomic) BOOL is_reload_alert_blinking;
@property (strong, nonatomic) SKAction* reload_alert_blinking;

// the chef
@property (strong,nonatomic) SKSpriteNode * theChef;
@property (strong,nonatomic) SKAction* chefReload;
@property (strong,nonatomic) SKAction* chefShoot;

// shooting

@property (assign, nonatomic) bool isShooting;
@property (assign, nonatomic) bool isReloading;

@property (assign, nonatomic) float fireRate;
@property (assign, nonatomic) float lastShotTimeStamp;

@property (strong, nonatomic) SKNode *barrelExit;
@property (assign, nonatomic) CGVector GunDirection;

// soundFX
@property (strong, nonatomic) SKAction* zombieGrowlSound1;
@property (strong, nonatomic) SKAction* zombieGrowlSound2;
@property (strong, nonatomic) SKAction* zombieGrowlSound3;

@property (strong, nonatomic) SKAction* ZombieDeathSound1;
@property (strong, nonatomic) SKAction* ZombieDeathSound2;
@property (strong, nonatomic) SKAction* ZombieDeathSound3;

@property (strong, nonatomic) SKAction* Shot1;
@property (strong, nonatomic) SKAction* Shot2;
@property (strong, nonatomic) SKAction* Shot3;

@property (strong, nonatomic) SKAction* ItalianTalk1;
@property (strong, nonatomic) SKAction* ItalianTalk2;
@property (strong, nonatomic) SKAction* ItalianTalk3;

@property (strong, nonatomic) SKAction* GameOverSound;

@property (strong, nonatomic) SKAction* ZombieHit;
@property (strong, nonatomic) SKAction* ZombieHit2;

// repeated properties

@property (assign, nonatomic) int fiftyShotsIndex;
@property (strong, nonatomic) NSMutableArray* fiftyShots;
@property (strong, nonatomic) SKAction* projectileAnimation;
@property (strong, nonatomic) SKAction* projectileHit;

@end

@implementation GingerDeadMenGameScene


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        
        self.isGameOver = true;
        self.isTakingPlayerInput = false;
        
        // load background
        SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"cdd-zombiemini-background@2x"];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        background.size = size;
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        background.zPosition = -5;
        
        [self addChild:background];
        self.background = background;
        
        
        _timeDisplay = [SKLabelNode labelNodeWithFontNamed:kFontDamnNoisyKids];
        
        if (IS_IPHONE_4 || IS_IPHONE_5)
        {
            _timeDisplay.fontSize = 28;
        }
        else if (IS_IPAD)
        {
            _timeDisplay.fontSize = 50;
        }
        
        
        SKSpriteNode* timerBackground = [SKSpriteNode spriteNodeWithImageNamed:@"minigame-timer@2x"];
        timerBackground.size = CGSizeMake((self.size.height * 0.15f) * 2.6f, self.size.height * 0.15f);
        timerBackground.zPosition = 20;
        timerBackground.position = CGPointMake(0, self.size.height * 0.95);
        timerBackground.anchorPoint = CGPointMake(0, 1);
        
        _timeDisplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        
        _timeDisplay.position = CGPointMake(timerBackground.size.width * 0.7090f,
                                            -timerBackground.size.height * 0.5391f);
        [self addChild:timerBackground];
        
        [timerBackground addChild:_timeDisplay];
        
        
        _scoreDisplay = [SKLabelNode labelNodeWithFontNamed:kFontDamnNoisyKids];
        
        _scoreDisplay.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        _scoreDisplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        
        if (IS_IPHONE_4 || IS_IPHONE_5)
        {
            _scoreDisplay.fontSize = 28;
        }
        else if (IS_IPAD)
        {
            _scoreDisplay.fontSize = 50;
        }
        
        SKSpriteNode* scoreBackground = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-mini-score@2x"];
        scoreBackground.size = CGSizeMake((self.size.height * 0.1f) * 3.3182f, self.size.height * 0.1f);
        scoreBackground.zPosition = 20;
        scoreBackground.position = CGPointMake(self.size.width * 0.95f, self.size.height * 0.95);
        scoreBackground.anchorPoint = CGPointMake(1, 1);
        
        _scoreDisplay.position = CGPointMake(-scoreBackground.size.width * 0.0959f,
                                            -scoreBackground.size.height * 0.5f);
        
        [scoreBackground addChild:_scoreDisplay];
        
        [self addChild:scoreBackground];
        
        
        
        float gaugeHeight = self.frame.size.height * 0.55f;
        CGSize ammoGaugeSize = CGSizeMake(gaugeHeight * 0.1832f, gaugeHeight);
        
        SKSpriteNode* ammoBase = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-ammobase@2x"];
        ammoBase.size = ammoGaugeSize;
        ammoBase.anchorPoint = CGPointMake(0, 0);
        ammoBase.zPosition = 20;
        ammoBase.position = CGPointMake(ammoGaugeSize.width * 0.25f,
                                        (self.frame.size.height * 0.5f) - (ammoGaugeSize.height*0.5));
        
        _ammoGuage = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-ammofill@2x"];
        _ammoGuage.size = CGSizeMake(ammoGaugeSize.width, ammoGaugeSize.height * 0.9319f);
        _ammoGuage.anchorPoint = CGPointMake(0, 0);
        _ammoGuage.position = CGPointMake(0, ammoGaugeSize.height * 0.0366f);
        [ammoBase addChild:_ammoGuage];
        
        SKSpriteNode* glassTop = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-ammoglass@2x"];
        glassTop.size = ammoGaugeSize;
        glassTop.anchorPoint = CGPointMake(0, 0);
        glassTop.zPosition = 1;
        [ammoBase addChild:glassTop];
        
        _reload_alert = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-ammoreload@2x"];
        _reload_alert.size = ammoGaugeSize;
        _reload_alert.anchorPoint = CGPointMake(0, 0);
        _reload_alert.alpha = 0;
        _reload_alert.zPosition = 2;
        [ammoBase addChild:_reload_alert];
        
        _reload_alert_blinking = [SKAction sequence:@[[SKAction fadeInWithDuration:0.25f],[SKAction fadeOutWithDuration:0.75f]]];
        
        [self addChild:ammoBase];
        
        // world physics
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        
        // Score stuff
        self.score = 0;
        // Shooting
        
        self.GunDirection = CGVectorMake(1.0f, 0.0f);
        self.fireRate = 0.25f;
        self.lastShotTimeStamp = 0.0f;
        self.isShooting = false;
        self.isReloading = false;
        
        
        // Milk Man
        {
            
            self.theChef = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-chef-006@2x"];
            
            self.theChef.size = CGSizeMake((ammoGaugeSize.height * 0.75f) * 1.040f, ammoGaugeSize.height * 0.75f);
            self.theChef.anchorPoint = CGPointMake(0.6100f, 0.5f);
            
            self.theChef.position = CGPointMake(ammoGaugeSize.width + (self.theChef.size.width * 0.4f), self.frame.size.height*0.5f);
            [self addChild:self.theChef];
            
            SKSpriteNode* redblock = [SKSpriteNode new];
            redblock.color = [SKColor redColor];
            redblock.blendMode = 1;
            redblock.size = CGSizeMake(20, 15);
            
            self.barrelExit = [SKNode new];
            [self.barrelExit addChild:redblock];
            self.barrelExit.position = CGPointMake(0,0.0f);
            
            [self.theChef addChild:self.barrelExit];
            
            
            _chefReload = [SKAction animateWithTextures:@[
                                                          [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-001@2x"],
                                                          [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-002@2x"],
                                                          [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-003@2x"],
                                                          [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-004@2x"],
                                                          [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-005@2x"],
                                                          [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-001@2x"]
                                                          ] timePerFrame:0.06];
            
            _chefShoot = [SKAction animateWithTextures:@[
                                                         [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-006@2x"],
                                                         [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-007@2x"],
                                                         [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-008@2x"],
                                                         [SKTexture textureWithImageNamed:@"cdd-zombiemini-chef-006@2x"]
                                                         ] timePerFrame:0.06];
            
            
        }
        
        
        // projectiles
        {
            
            _projectileAnimation = [SKAction animateWithTextures:@[
                                                                 
                                                                    [SKTexture textureWithImageNamed:@"cdd-zombiemini-particle-shot-001@2x"],
                                                                    [SKTexture textureWithImageNamed:@"cdd-zombiemini-particle-shot-002@2x"],
                                                                    [SKTexture textureWithImageNamed:@"cdd-zombiemini-particle-shot-003@2x"]

                                                                     ] timePerFrame:0.06f];
            
            _projectileHit = [SKAction animateWithTextures:@[
                                                             
                                                             [SKTexture textureWithImageNamed:@"cdd-zombiemini-particle-hit-001@2x"],
                                                             [SKTexture textureWithImageNamed:@"cdd-zombiemini-particle-hit-002@2x"],
                                                             [SKTexture textureWithImageNamed:@"cdd-zombiemini-particle-hit-003@2x"],
                                                             [SKTexture textureWithImageNamed:@"cdd-zombiemini-particle-hit-004@2x"]
                                                             
                                                             ] timePerFrame:0.06f];
            
            _fiftyShots = [NSMutableArray new];
            
            for(int i=0; i<50; i++){
            
                GingerDeadMen_projectile* shot = [GingerDeadMen_projectile spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake((self.size.height*0.05f) * 2.3571f, self.size.height*0.05f)];
                shot.damage = 100.0f;
                shot.zPosition = 50;
                
                SKPhysicsBody* physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:shot.size.width*0.5];
                physicsBody.categoryBitMask = projectileCategory;
                physicsBody.contactTestBitMask = zombieCookieCategory | obstacleCategory;
                physicsBody.collisionBitMask = 0;
                physicsBody.usesPreciseCollisionDetection = NO;
                
                shot.physicsBody = physicsBody;
                [_fiftyShots addObject:shot];
            }
            
        }
        
        self.ZombieSpawner = [GingerDeadMen_ZombieSpawner new];
        self.ZombieSpawner.bigdaddy = self;
        [self.ZombieSpawner LoadAssets];
        [self addChild:self.ZombieSpawner];
        
        self.ObstacleSpawner = [GingerDeadMen_ObstacleSpawner new];
        self.ObstacleSpawner.bigdaddy = self;
        [self.ObstacleSpawner LoadAssets];
        [self addChild:self.ObstacleSpawner];
        
        self.view.multipleTouchEnabled = NO;
        
        
        // soundFX stuff
        self.zombieGrowlSound1 = [SKAction playSoundFileNamed:@"Zombie_Growl1.wav" waitForCompletion:NO];
        self.zombieGrowlSound2 = [SKAction playSoundFileNamed:@"Zombie_Growl2.wav" waitForCompletion:NO];
        self.zombieGrowlSound3 = [SKAction playSoundFileNamed:@"Zombie_Growl3.wav" waitForCompletion:NO];
        
        self.ZombieDeathSound1 = [SKAction playSoundFileNamed:@"Zombie_Dead1.wav" waitForCompletion:NO];
        self.ZombieDeathSound2 = [SKAction playSoundFileNamed:@"Zombie_Dead2.wav" waitForCompletion:NO];
        self.ZombieDeathSound3 = [SKAction playSoundFileNamed:@"Zombie_Dead3.wav" waitForCompletion:NO];
        
        self.Shot1 = [SKAction playSoundFileNamed:@"Zombie_Shot1.wav" waitForCompletion:NO];
        self.Shot2 = [SKAction playSoundFileNamed:@"Zombie_Shot2.wav" waitForCompletion:NO];
        self.Shot3 = [SKAction playSoundFileNamed:@"Zombie_Shot3.wav" waitForCompletion:NO];
        
        self.ItalianTalk1 = [SKAction playSoundFileNamed:@"Zombie_Italian1.wav" waitForCompletion:NO];
        self.ItalianTalk2 = [SKAction playSoundFileNamed:@"Zombie_Italian2.wav" waitForCompletion:NO];
        self.ItalianTalk3 = [SKAction playSoundFileNamed:@"Zombie_Italian3.wav" waitForCompletion:NO];
        
        self.GameOverSound = [SKAction playSoundFileNamed:@"Zombie_Gameover.wav" waitForCompletion:NO];
        
        self.ZombieHit = [SKAction playSoundFileNamed:@"Zombie_zombieHit1.wav" waitForCompletion:NO];
        self.ZombieHit2 = [SKAction playSoundFileNamed:@"Zombie_zombieHit2.wav" waitForCompletion:NO];
        
    }
    
    return self;
}

-(void)SceneSetup:(Difficulty)difficulty
{
    
    _difficulty = difficulty;
    
    if(difficulty == Easy){
        
        DebugLog(@"\n\n\t easy game\n\n");
        
        // Zombie spawning
        self.secondsLeft = 45;
        
        self.magazineCap = 20;
        self.shotsLeft = 20;
        
        self.reloadTime = 1.0f;
       
    }else if(difficulty == Medium){
        
        DebugLog(@"\n\n\t medium game\n\n");
        
        self.secondsLeft = 90;
        
        self.magazineCap = 30;
        self.shotsLeft = 30;
        
        self.reloadTime = 2.0f;
        
    }else if(difficulty == Hard){
        
        DebugLog(@"\n\n\t hard game\n\n");
        
        self.secondsLeft = 150;
        
        self.magazineCap = 30;
        self.shotsLeft = 30;
        
        self.reloadTime = 3.0f;
        
    }else if(difficulty == Crazy){
        
        DebugLog(@"\n\n\t crazy game\n\n");
        
        self.secondsLeft = 300;
        
        self.magazineCap = 30;
        self.shotsLeft = 30;
        
        self.reloadTime = 3.0f;
        
    }
    
    _score = 0;
    
    _ZombieSpawner.position = CGPointMake(self.size.width, 0);
    
    _ObstacleSpawner.position = CGPointMake(self.size.width, 0);
    
}

-(void)RESET
{
    [_ZombieSpawner Carpetbomb];
    [_ObstacleSpawner ClearTheArea];
    _reloadTime = 0.05f;
    [self Reload];
}


-(void)Start_this_Bitch{
 
    _isGameOver = false;
    _isTakingPlayerInput = true;
    
    [_scoreDisplay setText:[NSString stringWithFormat:@"%i",_score]];
    [_timeDisplay setText:[NSString stringWithFormat:@"%i",_secondsLeft]];
    
    
    [_ZombieSpawner SetupZombieSpawner_Difficulty:_difficulty];
    
    _ObstacleSpawner.spawnPoints = _ZombieSpawner.zombieSpawnPoints;
    [_ObstacleSpawner Spawn:_difficulty];
    
    
    // start the countdown
    
    CGSize screenSize = self.frame.size;
    
    SKSpriteNode* symbol = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-particle-word-sym@2x"];
    symbol.zPosition = 50;
    symbol.position = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
    symbol.size = CGSizeMake(screenSize.height * 1.0811f, screenSize.height);
    
    SKSpriteNode* go = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-particle-word-go@2x"];
    SKSpriteNode* one = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-particle-word-1@2x"];
    SKSpriteNode* two = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-particle-word-2@2x"];
    SKSpriteNode* three = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-zombiemini-particle-word-3@2x"];
    
    go.alpha = 0;
    one.alpha = 0;
    two.alpha = 0;
    three.alpha = 0;
    
    go.size = CGSizeMake(symbol.size.width * 0.8101f, symbol.size.height * 0.5049f);
    one.size = CGSizeMake(symbol.size.width * 0.2680f, symbol.size.height * 0.601f);
    two.size = CGSizeMake(symbol.size.width * 0.487f, symbol.size.height * 0.6109f);
    three.size = CGSizeMake(symbol.size.width * 0.4732f, symbol.size.height * 0.6093f);

    [self addChild:symbol];
    [symbol addChild:go];
    [symbol addChild:one];
    [symbol addChild:two];
    [symbol addChild:three];
    
    float mississippi_Length = 1.5f;
    
    SKAction* fadeAndScale = [SKAction group:@[
                                               [SKAction fadeOutWithDuration:mississippi_Length],
                                               [SKAction scaleTo:0.25f duration:mississippi_Length]
                                               ]];
    
    [three runAction:[SKAction sequence:@[
                                        [SKAction fadeInWithDuration:0],
                                        [SKAction waitForDuration:mississippi_Length],
                                        [SKAction fadeOutWithDuration:0]
                                        ]]];
    
    [two runAction:[SKAction sequence:@[
                                        [SKAction waitForDuration:mississippi_Length],
                                        [SKAction fadeInWithDuration:0],
                                        [SKAction waitForDuration:mississippi_Length],
                                        [SKAction fadeOutWithDuration:0]
                                        ]]];
    
    [one runAction:[SKAction sequence:@[
                                        [SKAction waitForDuration:mississippi_Length * 2.0f],
                                        [SKAction fadeInWithDuration:0],
                                        [SKAction waitForDuration:mississippi_Length],
                                        [SKAction fadeOutWithDuration:0]
                                        ]]];
    
    [go runAction:[SKAction sequence:@[
                                        [SKAction waitForDuration:mississippi_Length * 3.0f],
                                        [SKAction fadeInWithDuration:0],
                                        [SKAction waitForDuration:mississippi_Length],
                                        [SKAction fadeOutWithDuration:0]
                                        ]]];
    
    [symbol runAction:[SKAction sequence:@[
                                           [SKAction fadeInWithDuration:0], // 3
                                           fadeAndScale,
                                           
                                           [SKAction scaleTo:1.0f duration:0], // 2
                                           [SKAction fadeInWithDuration:0],
                                           fadeAndScale,
                                           
                                           [SKAction scaleTo:1.0f duration:0], // 1
                                           [SKAction fadeInWithDuration:0],
                                           fadeAndScale,
                                           
                                           [SKAction scaleTo:1.0f duration:0], // go
                                           [SKAction fadeInWithDuration:0],
                                           fadeAndScale,
                                         
                                           ]] completion:^{
        
        [_ZombieSpawner StartSpawningTheArmyOfTheDamned];
        
        [self TimerLoop];
    
        [symbol removeFromParent];
    }];
}

-(void)TimerLoop
{
    if(self.isGameOver)
        return;
    
    [self runAction:[SKAction waitForDuration:1] completion:^{
    
        _secondsLeft -= 1;
        
        [_timeDisplay setText:[NSString stringWithFormat:@"%i", _secondsLeft]];
        
        if(_secondsLeft <= 0){
            
            [self YouWin];
            
        }else{
            
            [self TimerLoop];
        }
    
    }];
    
}

-(void)Shoot
{
    
    [_theChef runAction:_chefShoot];
    
    _shotsLeft--;
    _ammoGuage.yScale = [BLINDED_Math Value_from_another_Scope:_shotsLeft
                                                        OldMin:0
                                                        OldMax:_magazineCap
                                                        NewMin:0 NewMax:1];
    
    GingerDeadMen_projectile * projectile = _fiftyShots[_fiftyShotsIndex];
    
    _fiftyShotsIndex++;
    if(_fiftyShotsIndex >= _fiftyShots.count)
        _fiftyShotsIndex = 0;
    
    [projectile removeAllActions];
    [self addChild:projectile];
    
    [projectile runAction:[SKAction repeatActionForever:_projectileAnimation]];
    projectile.position = [self convertPoint:self.barrelExit.position fromNode:self.barrelExit.parent];
    
    float speed = self.size.width;
    
    projectile.physicsBody.velocity = CGVectorMake(self.GunDirection.dx * speed, self.GunDirection.dy * speed);
    
    [projectile runAction:[SKAction waitForDuration:3.0f] completion:^{
    
        [projectile removeAllActions];
        [projectile removeFromParent];
    
    }];
    
    projectile.zRotation = [BLINDED_Math VectorToAngle_Radians:_GunDirection];

    // sound
    
    int sound = arc4random() % 3;
    switch (sound) {
        case 0:
            [self runAction:self.Shot1];
            break;
        case 1:
            [self runAction:self.Shot2];
            break;
        case 2:
            [self runAction:self.Shot3];
            break;
            
    }
    
    
}

-(void)Reload
{
    [_theChef runAction:_chefReload];
    
    _isReloading = true;
    
    [_ammoGuage runAction:[SKAction scaleYTo:1 duration:_reloadTime] completion:^{
    
        _shotsLeft = _magazineCap;
    
        _isReloading = false;
    }];
    
}

-(void)ReloadAlertBlink
{
    
    [_reload_alert runAction:_reload_alert_blinking completion:^{
    
        if(_is_reload_alert_blinking && !_isReloading && !_isShooting)
           [self ReloadAlertBlink];
    
    }];
}

-(CGVector)rotateDir:(CGVector)dir Angle:(float)angle{
    
    float rads = angle * 0.0174532925f;
    
    float x = cos(rads)*dir.dx - sin(rads)*dir.dy;
    float y = sin(rads)*dir.dx + cos(rads)*dir.dy;
    
    
    return CGVectorMake(x, y);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(self.isGameOver)
        return;
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if(!self.isTakingPlayerInput)
        return;
    
    self.isShooting = true;
    
    if(location.x <= self.size.width * 0.1f){
        self.isShooting = false;
        [self Reload];
        return;
    }
    
    CGPoint GunBody = [self convertPoint:self.barrelExit.parent.position fromNode:self.barrelExit.parent.parent];
    CGVector lookDirection = CGVectorMake(location.x - GunBody.x, location.y - GunBody.y);
    
    float angle = [BLINDED_Math VectorToAngle_Degrees:lookDirection]; //atan2f( lookDirection.dy - 0.0f, lookDirection.dx - 1.0f);
    
    if(angle >= 45.0f){
        angle = 45.0f;
        
        lookDirection = [self rotateDir:CGVectorMake(1.0f, 0.0f) Angle:45];
    }
    else
        if(angle <= -45.0f){
            
            angle = -45.0f;
            
            lookDirection = [self rotateDir:CGVectorMake(1.0f, 0.0f) Angle:-45];
        }
    
    // now normalize that bitch
    
    float theSquareRoot = sqrtf((lookDirection.dx * lookDirection.dx) + (lookDirection.dy * lookDirection.dy));
    
    lookDirection.dx = lookDirection.dx/theSquareRoot;
    lookDirection.dy = lookDirection.dy/theSquareRoot;
    
    self.GunDirection = lookDirection;
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(!self.isShooting)
        return;
    
    if(self.isGameOver)
        return;
    
    if(!self.isTakingPlayerInput)
        return;
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    CGPoint GunBody = [self convertPoint:self.barrelExit.parent.position fromNode:self.barrelExit.parent.parent];
    
    
    CGVector lookDirection = CGVectorMake(location.x - GunBody.x, location.y - GunBody.y);
    
    float angle = [BLINDED_Math VectorToAngle_Degrees:lookDirection]; //tan2f( lookDirection.dy - 0.0f, lookDirection.dx - 1.0f);
    
    if(angle >= 45.0f){
        angle = 45.0f;
        
        float X = sinf(45.0f);
        float Y = cosf(45.0f);
        float Sum = (X * 1.0f) + (Y * 0.0f);
        lookDirection.dx = Sum;
        
        X = sinf(45.0f);
        Y = cosf(45.0f);
        Sum = (X * 0.0f) + (Y * 1.0f);
        lookDirection.dy = Sum;
        
    }
    else
        if(angle <= -45.0f){
            
            angle = -45.0f;
            
            float X = sinf(45.0f);
            float Y = cosf(45.0f);
            float Sum = (X * 1.0f) + (Y * 0.0f);
            lookDirection.dx = Sum;
            
            X = sinf(45.0f);
            Y = cosf(45.0f);
            Sum = (X * 0.0f) + (Y * 1.0f);
            lookDirection.dy = -Sum;
            
        }
    
    // now normalize that bitch
    
    float theSquareRoot = sqrtf((lookDirection.dx * lookDirection.dx) + (lookDirection.dy * lookDirection.dy));
    
    lookDirection.dx = lookDirection.dx/theSquareRoot;
    lookDirection.dy = lookDirection.dy/theSquareRoot;
    
    self.GunDirection = lookDirection;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    
    self.lastShotTimeStamp = 0.0f;
    
    self.isShooting = false;
    
}


- (void)update:(NSTimeInterval)currentTime {
    
    if(_isGameOver)
        return;
    
    if(_shotsLeft <= (_magazineCap*0.4f)){
        
        if(!_is_reload_alert_blinking)
           [self ReloadAlertBlink];
        
        _is_reload_alert_blinking = true;
    }else{
        _is_reload_alert_blinking = false;
    }
    
    
    // zombie update
    if(currentTime >= _ZombieSpawnerUpdateTimetracker){

        [_ZombieSpawner UpdateMethod];
        
        _ZombieSpawnerUpdateTimetracker = currentTime + 0.5f;
    }
    
    if(self.isReloading){
    
    
    }else if(self.isShooting){
        if(currentTime >= self.lastShotTimeStamp){
            
            [self Shoot];
            
            self.lastShotTimeStamp = currentTime + self.fireRate;
            
            if(_shotsLeft <= 0){
                [self Reload];
            }
        }
    }
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
        (secondBody.categoryBitMask & zombieCookieCategory) != 0)
    {
        
        GingerDeadMen_projectile * bullet = (GingerDeadMen_projectile*) firstBody.node;
        GingerDeadMan * zombie = (GingerDeadMan*) secondBody.node;
        
        [self BulletSplode:bullet Point:[_ZombieSpawner convertPoint:zombie.position toNode:self]];
        
        [self ZombieHit:zombie Bullet:bullet];
        
        [bullet removeAllActions];
        [bullet removeFromParent];
        
        
    }else if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
              (secondBody.categoryBitMask & obstacleCategory) != 0)
    {
        
        GingerDeadMen_projectile * bullet = (GingerDeadMen_projectile*) firstBody.node;
        
        
        
        [self BulletSplode:bullet Point:contact.contactPoint];
        
        [bullet removeAllActions];
        [bullet removeFromParent];
        
    }
}

-(void)BulletSplode:(SKSpriteNode*)bullet Point:(CGPoint)point;
{
    float width = bullet.size.width * 1.4697f;
    float height = bullet.size.height * 4.3214f;
    
    SKSpriteNode* splat = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(width, height)];
    
    splat.position = point;
    
    splat.zPosition = bullet.zPosition;
    splat.anchorPoint = CGPointMake(0.8660f, 0.6804f);
    
    [self addChild:splat];
    
    [splat runAction:_projectileHit completion:^{
    
        [splat removeFromParent];
    
    }];
    
}

-(void)ZombieHit:(GingerDeadMan*)zombie Bullet:(GingerDeadMen_projectile*)bullet
{
    
    zombie.zombieHealth -= bullet.damage;
    
    [_ZombieSpawner ZombieHurt:zombie];

    if(zombie.zombieHealth <= 0){
        
        int soundRoll = arc4random() % (int) 3;
        
        switch (soundRoll) {
            case 0:
                [self runAction:self.ZombieDeathSound1];
                break;
            case 1:
                [self runAction:self.ZombieDeathSound2];
                break;
            case 2:
                [self runAction:self.ZombieDeathSound3];
                break;
        }
        
        self.score++;
        [_scoreDisplay setText:[NSString stringWithFormat:@"%i",_score]];
    
        [zombie ZombieDeath];
    }
    else
    {
        int soundRoll = arc4random() % (int) 2;
        
        switch (soundRoll) {
            case 0:
                [self runAction:self.ZombieHit];
                break;
            case 1:
                [self runAction:self.ZombieHit2];
                break;
        }
        
    }
    
    
}



-(void)GameOver
{
    if(self.isGameOver)
    {
        return;
    }
    
    DebugLog(@"Yeah its over");
    
    [self runAction:self.GameOverSound];
    
    self.isGameOver = true;
    self.isShooting = false;
    
    SKNode * popUpParent = [SKNode new];
    popUpParent.position = CGPointMake(self.size.width*0.5f, self.size.height*0.5f);
    popUpParent.zPosition = 50;
    popUpParent.alpha = 0;
    
    SKSpriteNode * popUpBackground = [SKSpriteNode new];
    popUpBackground.size = CGSizeMake(self.size.width*0.5f, self.size.height*0.25f);
    popUpBackground.color = [SKColor blackColor];
    popUpBackground.alpha = 0.75;
    
    SKLabelNode * waveAnouncement = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    
    waveAnouncement.text = @"GameOver";
    waveAnouncement.fontSize = self.size.width*0.05f;
    waveAnouncement.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    
    [popUpParent addChild: popUpBackground];
    [popUpParent addChild:waveAnouncement];
    
    [self addChild:popUpParent];
    
    SKAction * scaling = [SKAction scaleYTo:1 duration:1];
    
    SKAction * Group1 = [SKAction group:@[[SKAction sequence:@[[SKAction scaleYTo:0 duration:0],scaling]], [SKAction fadeAlphaTo:1.0f duration:1]]];
    
    SKAction * Group2 = [SKAction group:@[[SKAction scaleYTo:0 duration:1], [SKAction fadeAlphaTo:0.0f duration:1]]];
    
    SKAction * PopupSequence = [SKAction sequence:@[Group1,[SKAction waitForDuration:2],Group2]];
    
    [popUpParent runAction:PopupSequence completion:^{
        
        if ([self.delegate respondsToSelector:@selector(gingerDeadSceneDidEnd: DidWin: WithScore:)])
        {
            [self.delegate gingerDeadSceneDidEnd:self DidWin:NO WithScore:_score];
            
        }
        
    }];
    
}

-(void)YouWin
{
    
    if(self.isGameOver)
    {
        return;
    }
    
    DebugLog(@"Yeah its over");
    
    [self runAction:self.GameOverSound];
    
    [_ZombieSpawner Carpetbomb];
    
    self.isGameOver = true;
    self.isShooting = false;
    
    SKNode * popUpParent = [SKNode new];
    popUpParent.position = CGPointMake(self.size.width*0.5f, self.size.height*0.5f);
    popUpParent.zPosition = 50;
    popUpParent.alpha = 0;
    
    SKSpriteNode * popUpBackground = [SKSpriteNode new];
    popUpBackground.size = CGSizeMake(self.size.width*0.5f, self.size.height*0.25f);
    popUpBackground.color = [SKColor blackColor];
    popUpBackground.alpha = 0.75;
    
    SKLabelNode * waveAnouncement = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    
    waveAnouncement.text = @"You Win";
    waveAnouncement.fontSize = self.size.width*0.05f;
    waveAnouncement.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    
    [popUpParent addChild: popUpBackground];
    [popUpParent addChild:waveAnouncement];
    
    [self addChild:popUpParent];
    
    SKAction * scaling = [SKAction scaleYTo:1 duration:1];
    
    SKAction * Group1 = [SKAction group:@[[SKAction sequence:@[[SKAction scaleYTo:0 duration:0],scaling]], [SKAction fadeAlphaTo:1.0f duration:1]]];
    
    SKAction * Group2 = [SKAction group:@[[SKAction scaleYTo:0 duration:1], [SKAction fadeAlphaTo:0.0f duration:1]]];
    
    SKAction * PopupSequence = [SKAction sequence:@[Group1,[SKAction waitForDuration:2],Group2]];
    
    [popUpParent runAction:PopupSequence completion:^{
        
        if ([self.delegate respondsToSelector:@selector(gingerDeadSceneDidEnd: DidWin: WithScore:)])
        {
            [self.delegate gingerDeadSceneDidEnd:self DidWin:YES WithScore:_score];
        }
        
    }];
    
}

-(void)EraseThisGameScene
{
    self.delegate = nil;
    _BigDaddy = nil;
    
    [self removeAllActions];
    
    [_ZombieSpawner KillTheGame];
    [_ObstacleSpawner KillTheGame];
    
    _ZombieSpawner = nil;
    _ObstacleSpawner = nil;
   
    _background = nil;
    _scoreDisplay = nil;
    _theChef = nil;
    _timeDisplay = nil;
    
    _ammoGuage = nil;
    
    _barrelExit = nil;
    _zombieGrowlSound1 = nil;
    _zombieGrowlSound2 = nil;
    _zombieGrowlSound3 = nil;
    _ZombieDeathSound1 = nil;
    _ZombieDeathSound2 = nil;
    _ZombieDeathSound3 = nil;
    _Shot1 = nil;
    _Shot2 = nil;
    _Shot3 = nil;
    _ItalianTalk1 = nil;
    _ItalianTalk2 = nil;
    _ItalianTalk3 = nil;
    _GameOverSound = nil;
    _ZombieHit = nil;
    _ZombieHit2 = nil;
    
    _projectileAnimation = nil;
    _projectileHit = nil;
    _fiftyShots = nil;
    
    _reload_alert = nil;
    _reload_alert_blinking = nil;
    
    _chefReload = nil;
    _chefShoot = nil;
    
    [self removeAllChildren];
    
}

@end
