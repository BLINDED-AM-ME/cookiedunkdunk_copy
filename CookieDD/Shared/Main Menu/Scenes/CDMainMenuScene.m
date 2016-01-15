
//  CDMainMenuScene.m
//  CookieDD
//
//  Created by gary johnston on 10/29/13.
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

#import "CDMainMenuScene.h"
#import "SGAudioManager.h"

@interface CDMainMenuScene()


@property (strong, nonatomic) SKAction *sequenceAction;

@property (assign, nonatomic) CGPoint cookieToDunkPlayPos;
@property (assign, nonatomic) CGPoint cookieToDunkSocialPos;

@property (strong, nonatomic) SKSpriteNode *TitleLogo;
@property (strong, nonatomic) SKSpriteNode *LeftBorder;
@property (strong, nonatomic) SKSpriteNode *RightBorder;
@property (strong, nonatomic) SKSpriteNode *BottomBorder;
@property (strong, nonatomic) SKSpriteNode *theBoard;
@property (strong, nonatomic) SKSpriteNode *companyName;
@property (strong, nonatomic) SKSpriteNode *milkCollider;
@property (strong, nonatomic) SKSpriteNode *redReflection;
@property (strong, nonatomic) SKSpriteNode *blueReflection;
@property (strong, nonatomic) SKSpriteNode *cookieToDunkPlay;
@property (strong, nonatomic) SKSpriteNode *cookieToDunkSocial;
@property (strong, nonatomic) SKSpriteNode *milkCupObject;
@property (strong, nonatomic) SKSpriteNode *playButton;
@property (strong, nonatomic) SKSpriteNode *rightCupWall;
@property (strong, nonatomic) SKSpriteNode *leftCupWall;
@property (strong, nonatomic) SKSpriteNode *socialButton;

@property (strong, nonatomic) SKSpriteNode *galaxyBackground;
@property (strong, nonatomic) SKSpriteNode *starParallaxOne;
@property (strong, nonatomic) SKSpriteNode *starParallaxOneSpare;
@property (strong, nonatomic) SKSpriteNode *starParallaxTwo;
@property (strong, nonatomic) SKSpriteNode *starParallaxTwoSpare;
@property (assign, nonatomic) CGPoint parallaxStartPointOne;
@property (assign, nonatomic) CGPoint parallaxStartPointTwo;

@property (strong, nonatomic) SKSpriteNode *playButtonBottom;
@property (strong, nonatomic) SKSpriteNode *socialButtonBottom;

@property (strong, nonatomic) SKPhysicsBody *cookieBody;
@property (strong, nonatomic) SKPhysicsBody *CupWalls_body;
@property (strong, nonatomic) SKPhysicsBody *milk_body;
@property (strong, nonatomic) SKPhysicsBody *buttonBody;

@property (strong, nonatomic) AVAudioPlayer *cookieDunkDunkAnnouncement;

//@property (strong, nonatomic) SKAction *runParallaxOneAction;
//@property (strong, nonatomic) SKAction *runParallaxTwoAction;

@property (assign,nonatomic) int hitSoundEffect;
@property (assign, nonatomic) BOOL isPlayingHitSound;

// milk splash

@property (strong, nonatomic) SKSpriteNode* milkSplashCup;
@property (strong, nonatomic) SKAction* milkSplash;

@property (assign, nonatomic) BOOL isLockedOut;
@property (assign, nonatomic) BOOL contentCreated;
@property (assign, nonatomic) BOOL createdCookie;
@property (assign, nonatomic) BOOL cookieWasDropped;
@property (assign, nonatomic) BOOL playCookieWasDropped;
@property (assign, nonatomic) BOOL socialCookieWasDropped;
@property (assign, nonatomic) BOOL triggerPlayButton;
@property (assign, nonatomic) BOOL triggerSocialButton;
@property (assign, nonatomic) BOOL isMessingAround;


@end


@implementation CDMainMenuScene

- (void)dealloc
{
    DebugLog(@"Did dealloc main menu scene");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didMoveToView:(SKView *)view
{
    
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        if (!self.contentCreated)
        {
            [self createSceneContents];
            self.contentCreated = YES;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repositionCookies) name:UIApplicationDidBecomeActiveNotification object:nil];
        }
        else
        {
        }
    }
    return self;
}

- (void)update:(NSTimeInterval)currentTime
{
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive)
	{
		self.view.paused = YES;
		self.paused = YES;
		
		[[SGAudioManager audioManager] pauseAllAudio];
	}
}

- (void)createSceneContents
{
    float half_screenWidth = kScreenWidth * 0.5;
    float half_screenHeight = kScreenHeight * 0.5;
    self.allFather = [SKNode new];
    self.allFather.position = CGPointMake(half_screenWidth, half_screenHeight);
    [self addChild:self.allFather];
    
    self.view.multipleTouchEnabled = NO;
    
    self.physicsWorld.contactDelegate = self;
    self.name = @"scene";
    
    self.cookieWasDropped = NO;
    self.createdCookie = NO;
    self.isMessingAround = NO;
    self.isPlayingHitSound = NO;
    self.isLockedOut = NO;
    
    self.playCookieWasDropped = NO;
    self.socialCookieWasDropped = NO;
    
    self.hitSoundEffect = 1;
    
    // load the right device textures
//    NSString * deviceType = @"iphone5";
//    
//    if(IS_IPHONE_5){
//        
//        deviceType = @"iphone5";
//        
//    }else
//        if(IS_IPHONE_4){
//            
//            deviceType = @"iphone4";
//            
//        }else{
//            
//            deviceType = @"ipad";
//        }
    
    //    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"MainMenu_background-%@", deviceType]];
    
    _galaxyBackground = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-mainmenu-starsbackground"];
    _galaxyBackground.position = CGPointMake(0 + (_galaxyBackground.size.width * .5), (kScreenHeight * .5) - (_galaxyBackground.size.height * .5));
    
    _starParallaxOne = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-map-starfield-1"];
    _starParallaxOne.position = _galaxyBackground.position;
    _starParallaxOneSpare = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-map-starfield-1"];
    _starParallaxOneSpare.position = CGPointMake(_starParallaxOne.position.x + (_starParallaxOne.size.width * .5), _starParallaxOne.position.y);
    
    
    _starParallaxTwo = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-map-starfield-2"];
    _starParallaxTwo.position = _galaxyBackground.position;
    _starParallaxTwoSpare = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-map-starfield-2"];
    _starParallaxTwoSpare.position = CGPointMake(_starParallaxTwo.position.x + (_starParallaxTwo.size.width * .5), _starParallaxTwo.position.y);
    
    _parallaxStartPointOne = CGPointMake(_starParallaxOneSpare.position.x + (_starParallaxOneSpare.size.width * .5), _starParallaxOneSpare.position.y);
    _parallaxStartPointTwo = CGPointMake(_starParallaxTwoSpare.position.x + (_starParallaxTwoSpare.size.width * .5), _starParallaxTwoSpare.position.y);
    
//    _runParallaxOneAction = [SKAction moveTo:CGPointMake(_galaxyBackground.position.x - (_galaxyBackground.size.width * .5) - (_starParallaxOne.size.width * .5), _starParallaxOne.position.y) duration:3];
//    _runParallaxTwoAction = [SKAction moveTo:CGPointMake(_galaxyBackground.position.x - (_galaxyBackground.size.width * .5) - (_starParallaxTwo.size.width * .5), _starParallaxTwo.position.y) duration:4];
    
    [_allFather addChild:_galaxyBackground];
    [_allFather addChild:_starParallaxOne];
    [_allFather addChild:_starParallaxTwo];
    
    [self runParallaxOne];
    [self runParallaxOneSpare];
    [self runParallaxTwo];
    [self runParallaxTwoSpare];
    
    SKSpriteNode *background;
    if (IS_IPHONE_5)
    {
        background = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-background-568h"];
    }
    else
    {
        background = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-background"];
    }
    [self.allFather addChild:background];
    
    SKTextureAtlas* milksplashAtlas = [SKTextureAtlas atlasNamed:@"Main_menu_milksplash"];
    
    self.milkCupObject = [SKSpriteNode spriteNodeWithTexture:[milksplashAtlas textureNamed:@"mainmenu-milkglass-back"]];
    SKSpriteNode* midBackCupPiece = [SKSpriteNode spriteNodeWithTexture:[milksplashAtlas textureNamed:@"mainmenu-milksplash-back-01"]];
    [self.milkCupObject addChild:midBackCupPiece];
    midBackCupPiece.zPosition = 1;
    
    SKSpriteNode* middleCupPiece = [SKSpriteNode spriteNodeWithTexture:[milksplashAtlas textureNamed:@"mainmenu-milksplash-front-01"]];
    [self.milkCupObject addChild:middleCupPiece];
    middleCupPiece.position = CGPointMake(0, 1);
    middleCupPiece.zPosition = 3;
    
    SKSpriteNode* frontCupPiece = [SKSpriteNode spriteNodeWithTexture:[milksplashAtlas textureNamed:@"mainmenu-milkglass-front"]];
    [self.milkCupObject addChild:frontCupPiece];
    frontCupPiece.zPosition = 4;
    
//    SKAction* afterTheFall = [SKAction waitForDuration:1];
    
    // Title logo animation
    {
        self.TitleLogo = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-cookie-logo"];
        SKSpriteNode * logo2 = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-logo-subtitle"];
        logo2.anchorPoint = CGPointMake(0, 1);
        logo2.position = CGPointMake(-kScreenHeight, -self.TitleLogo.size.height*0.65);
        SKAction *animateSubtitle = [SKAction group:@[[SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"MilkyHit2" FileType:@"caf"];}],
                                                      [SKAction moveToX:(-self.TitleLogo.size.width*0.5) duration: 0.25]]];
        [logo2 runAction:[SKAction sequence:@[[SKAction waitForDuration:5],animateSubtitle]]];
        
        //chip
        
        SKSpriteNode* chip = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-logo-chip-frame1"];
        chip.position = CGPointMake(0, 300);
        chip.xScale = 1.03;
        chip.yScale = 1.03;
        
        CGPoint chipTargetPoint = CGPointMake(-self.TitleLogo.size.width * 0.205, -3);
        SKAction* chipRolling = [SKAction rotateByAngle: -720 * 0.0174532925 duration:1];
        SKAction* chipMoveMent = [SKAction moveTo:chipTargetPoint duration:1];
        SKAction* chipGroupMovement = [SKAction group:@[chipRolling, chipMoveMent]];
        

        //chip's face
        NSArray *chipBlinkingFrames = @[[SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame1"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame8"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame9"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame10"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame11"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame12"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame13"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame14"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame15"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame14"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame13"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame14"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame15"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame14"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame13"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame14"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame15"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame14"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame13"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame12"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame11"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame10"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame9"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame8"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-chip-frame1"]];
        
        SKAction* chipBlinkingSequence = [SKAction sequence:@[[SKAction waitForDuration:15],[SKAction animateWithTextures:chipBlinkingFrames timePerFrame:0.05 resize:YES restore:NO]]];
        
        
        SKAction *moveChipBack = [SKAction moveTo:CGPointMake(-self.TitleLogo.size.width * 0.205, 2) duration:.2];
        SKAction *chipWait = [SKAction waitForDuration:.5];
        [chip runAction:[SKAction sequence:@[chipWait,
                                             chipGroupMovement,
                                             [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"Flip 2" FileType:@"caf"];}],
                                             moveChipBack]]
                                completion:^{
            [chip runAction:[SKAction waitForDuration:15]];
            
            [chip runAction:[SKAction repeatActionForever:chipBlinkingSequence]];
            
        }];
        
        
        //mike
        SKSpriteNode* mike = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-logo-mike-frame1"];
        mike.position = CGPointMake(0, 300);
        mike.xScale = 1.03;
        mike.yScale = 1.03;
        
        
        CGPoint mikeTargetPoint = CGPointMake(-self.TitleLogo.size.width * 0.019, -3);
        SKAction* mikeRolling = [SKAction rotateByAngle:720 * 0.0174532925 duration:1];
        SKAction* mikeMoveMent = [SKAction moveTo:mikeTargetPoint duration:1];
        SKAction* mikeGroupMovement = [SKAction group:@[mikeRolling, mikeMoveMent]];
        
        //mike's face
        NSArray *mikeBlinkingFrames = @[[SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame1"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame17"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame18"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame19"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame20"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame21"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame22"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame23"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame24"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame25"],
                                        
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame26"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame27"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame28"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame29"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame30"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame31"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame32"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame33"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame34"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame35"],
                                        
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame36"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame37"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame38"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame39"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame40"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame41"],
                                        [SKTexture sgtextureWithImageNamed:@"mainmenu-logo-mike-frame1"]];
        
        
        SKAction* mikeBlinkingSequence = [SKAction sequence:@[[SKAction waitForDuration:8],[SKAction animateWithTextures:mikeBlinkingFrames timePerFrame:0.05 resize:YES restore:NO]]];
        
        SKAction *moveMikeBack = [SKAction moveTo:CGPointMake(-self.TitleLogo.size.width * 0.019, 2) duration:.2];
        SKAction *mikeWait = [SKAction waitForDuration:.8];
        [mike runAction:[SKAction sequence:@[mikeWait,
                                             mikeGroupMovement,
                                             [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"Flip 1" FileType:@"caf"];}],
                                             moveMikeBack]] completion:^{
            [mike runAction:[SKAction waitForDuration:8]];
            
            [mike runAction:[SKAction repeatActionForever:mikeBlinkingSequence]];
    
        }];
        
        

        
        // now for the dunk dunk part
        
        SKSpriteNode* dunk1 = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-dunkdunk01-logo"];
        dunk1.position = CGPointMake(self.TitleLogo.size.width * 0.46 - (dunk1.frame.size.width * .385), -dunk1.size.height * 0.27);
        dunk1.zPosition = 2;
        
        SKSpriteNode *dunk2 = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-dunkdunk02-logo"];
        dunk2.position = CGPointMake(self.TitleLogo.size.width * 0.40 + (dunk2.frame.size.width * .6), -dunk1.size.height * 0.07);
        dunk2.zPosition = 2;
        
        SKSpriteNode *splat1 = [SKSpriteNode spriteNodeWithImageNamed:@"mainMenu-splat"];
        splat1.position = dunk1.position;
        splat1.zPosition = 3;
        splat1.xScale = 4;
        splat1.yScale = 4;
        
        SKSpriteNode *splat2 = [SKSpriteNode spriteNodeWithImageNamed:@"mainMenu-splat"];
        splat2.position = dunk2.position;
        splat2.zPosition = 3;
        splat2.xScale = 4;
        splat2.yScale = 4;
        
        SKAction *splatScaleDown = [SKAction scaleXTo:1.2 y:1.2 duration:.1];
        SKAction *splatScaleUp = [SKAction scaleXTo:1.5 y:1.5 duration:.1];
        SKAction *splatFade = [SKAction fadeOutWithDuration:.5];
        
        splat1.position = dunk1.position;
        [self.TitleLogo runAction:[SKAction waitForDuration:2] completion:^{
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd-kidAnouncements-CookieDunkDunk" FileType:@".caf" volume:0.3f]; //@".m4a" volume:0.3f];
        }];
        
        [self.TitleLogo runAction:[SKAction waitForDuration:2.5] completion:^{
            
            [self.TitleLogo addChild:splat1];
            [splat1 runAction:splatScaleDown completion:^{
                [self.TitleLogo addChild:dunk1];
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Splat" FileType:@"caf"];
                [splat1 runAction:splatScaleUp completion:^{
                    
                    [splat1 runAction:splatFade completion:^{
                        [splat1 removeFromParent];
                    }];
                }];
            }];
        }];
        
        [self.TitleLogo runAction:[SKAction waitForDuration:2.7] completion:^{
            [self.TitleLogo addChild:splat2];
            [splat2 runAction:splatScaleDown completion:^{
                [self.TitleLogo addChild:dunk2];
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Splat" FileType:@"caf"];
                [splat2 runAction:splatScaleUp completion:^{
                    
                    [splat2 runAction:splatFade completion:^{
                        [splat2 removeFromParent];
                    }];
                }];
            }];
        }];
        
        [self.TitleLogo addChild:mike];
        [self.TitleLogo addChild:chip];
        [self.TitleLogo addChild:logo2];
    }
    
    self.playButton = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-red-bag-top"];
    self.socialButton = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-blue-bag-top"];
    
    // Positive is up for the height+x
    _playButtonBottom = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-red-bag-bottom"];
    _playButtonBottom.position = CGPointMake(_playButton.size.width-199, _playButton.size.height-178);
    _playButtonBottom.zPosition = -1;
//    [self addChild:_playButtonBottom];
    
    _socialButtonBottom = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-blue-bag-bottom"];
    _socialButtonBottom.position = CGPointMake(_socialButton.size.width+1, _socialButton.size.height-166.5);
    _socialButtonBottom.zPosition = -1;
//    [self addChild:_socialButtonBottom];
    
    
    self.theBoard = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-board"];
    self.companyName = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-sevengun-logo"];
    
    
    // milk cup
    {
        
        self.milkCupObject.position = CGPointMake(0, -self.milkCupObject.size.height * 0.25);
        self.milkCupObject.name = @"milkCupObject";
        self.milkCupObject.zPosition = 1;
        
        [self.allFather addChild:self.milkCupObject];
        
        self.milkCollider = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.milkCupObject.size.width * 0.2, self.milkCupObject.size.height * 0.7)];
        self.milkCollider.position = CGPointMake(0, 0);
        self.milkCollider.zPosition = 6;
        
        [self.milkCupObject addChild:self.milkCollider];
        
    }
    
    // title
    {
        
        CGPoint logoPoint = CGPointMake(- half_screenWidth - self.TitleLogo.size.width, kScreenHeight * 0.3);//kScreenHeight * 0.75);
        self.TitleLogo.position = logoPoint;
        [self.allFather addChild:self.TitleLogo];

//        float targetY = kScreenHeight * 0.3;
//        
//        SKAction * Title_drop = [SKAction sequence:@[[SKAction waitForDuration:1],
//                                                     [SKAction moveToY:targetY - (self.TitleLogo.size.height * 0.1) duration:0.5],
//                                                     [SKAction moveToY:targetY + (self.TitleLogo.size.height * 0.05) duration:0.25],
//                                                     [SKAction moveToY:targetY duration:0.1]]];
//        
//        [self.TitleLogo runAction:Title_drop];
        
        SKAction *logoWait = [SKAction waitForDuration:.5];
        SKAction *moveLogoRight = [SKAction moveToX:self.TitleLogo.size.width * .01 duration:.4];
        moveLogoRight.timingMode = SKActionTimingEaseInEaseOut;
        SKAction *moveLogoLeft = [SKAction moveToX:self.TitleLogo.size.width * -.2 duration:.2];
        moveLogoLeft.timingMode = SKActionTimingEaseInEaseOut;
        SKAction *moveLogoRightAgain = [SKAction moveByX:.05 y:0 duration:.15];
        moveLogoRightAgain.timingMode = SKActionTimingEaseInEaseOut;
        SKAction *titleSound = [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"Swoosh 4" FileType:@"caf"];}];
        
        [self.TitleLogo runAction:[SKAction sequence:@[logoWait, titleSound, moveLogoRight, moveLogoLeft, moveLogoRightAgain]]];
    }
    
    // Play Button
    {

        self.playButton.name = @"playButton";
        self.playButton.position = CGPointMake(-half_screenWidth + (self.theBoard.size.width) + (self.playButton.size.width * 0.5), self.milkCupObject.position.y);
        self.playButton.zPosition = 1;
//        [self.allFather addChild:self.playButton];
        
        
        self.redReflection = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-red-bag-reflection"];
        self.redReflection.position = CGPointMake(self.playButton.position.x, self.playButton.position.y + (-self.playButton.size.height * 0.5) + (-self.redReflection.size.height * 0.5));
        
        [self.allFather addChild:self.redReflection];
        
    }
    
    // Social Button
    {
        
        self.socialButton.name = @"socialButton";
        self.socialButton.position = CGPointMake(-self.playButton.position.x, self.milkCupObject.position.y);
        self.socialButton.zPosition = 1;
        [self.allFather addChild:self.socialButton];
        // Im faking this 
        
        self.blueReflection = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-blue-bag-reflection"];
        self.blueReflection.position = CGPointMake(self.socialButton.position.x, self.socialButton.position.y + (-self.socialButton.size.height * 0.5) + (-self.blueReflection.size.height * 0.5));
        [self.allFather addChild:self.blueReflection];
        
    }
    
    
    [self.allFather addChild:self.playButtonBottom];
    [self.allFather addChild:self.playButton];
    [self.allFather addChild:_socialButtonBottom];
    
    self.isLockedOut = NO;
    self.userInteractionEnabled = YES;
    
    
    self.cookieToDunkPlay = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-cookie-select-chip-frame01"];
    
    // give it a face
    {
        NSArray *chipBlinkingFrames = @[[SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame01"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame02"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame03"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame04"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame05"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame06"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame07"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame08"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame07"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame06"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame05"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame04"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame03"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame02"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-chip-frame01"]];
        
        //SKSpriteNode* chipsface = [SKSpriteNode spriteNodeWithTexture:[chipBlinkingAtlas textureNamed:@"mainmenu-cookie-select-chocolate-blink1"]];
        
        SKAction* chipBlinkingSequence = [SKAction sequence:@[[SKAction waitForDuration:8],[SKAction animateWithTextures:chipBlinkingFrames timePerFrame:0.05 resize:YES restore:NO]]];
        
        [_cookieToDunkPlay runAction:[SKAction waitForDuration:8]];
        [_cookieToDunkPlay runAction:[SKAction repeatActionForever:chipBlinkingSequence]];
    }
    
    self.cookieToDunkSocial = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-cookie-select-mikey-frame01"];
    {
        NSArray *mikeBlinkingFrames = @[[SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame01"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame02"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame03"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame04"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame05"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame06"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame07"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame08"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame09"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame10"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame11"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame10"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame09"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame08"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame07"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame06"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame05"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame04"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame03"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame02"],
                                        [SKTexture   sgtextureWithImageNamed:@"mainmenu-cookie-select-mikey-frame01"]];
        
        SKAction* mikeBlinkingSequence = [SKAction sequence:@[[SKAction waitForDuration:11],[SKAction animateWithTextures:mikeBlinkingFrames timePerFrame:0.05 resize:YES restore:NO]]];
        
        // cookies
        self.cookieToDunkPlay.name = @"play";
        self.cookieToDunkSocial.name = @"social";
        
        if (IS_IPAD)
        {
            self.cookieToDunkPlay.position = CGPointMake(self.playButton.position.x, self.playButton.position.y+110);
            self.cookieToDunkSocial.position = CGPointMake(self.socialButton.position.x, self.socialButton.position.y+110);
        }
        else
        {
            self.cookieToDunkPlay.position = CGPointMake(self.playButton.position.x, self.playButton.position.y+55);
            self.cookieToDunkSocial.position = CGPointMake(self.socialButton.position.x, self.socialButton.position.y+55);
        }
        
        self.cookieToDunkPlayPos = self.cookieToDunkPlay.position;
        self.cookieToDunkSocialPos = self.cookieToDunkSocial.position;
        
        [self.allFather addChild:self.cookieToDunkPlay];
        [self.allFather addChild:self.cookieToDunkSocial];
        
        [self bobUpAndDownWithNode:self.playButton withDuration:1];
        [self bobUpAndDownWithNode:self.playButtonBottom withDuration:1];
        [self bobUpAndDownWithNode:self.cookieToDunkPlay withDuration:1];
        
        [self bobUpAndDownWithNode:self.socialButtonBottom withDuration:.8];
        [self bobUpAndDownWithNode:self.cookieToDunkSocial withDuration:.8];
        [self bobUpAndDownWithNode:self.socialButton withDuration:.8];
        
        [_cookieToDunkSocial runAction:[SKAction waitForDuration:11]];
        [_cookieToDunkSocial runAction:[SKAction repeatActionForever:mikeBlinkingSequence]];
    }
    
    //_playButton.zPosition = 300;
    
    // Walls
    {
        self.rightCupWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(5, (self.milkCupObject.size.height * 0.65))];
        self.rightCupWall.position = CGPointMake((self.milkCupObject.size.width * 0.4), self.milkCupObject.size.height * 0.1);
        self.rightCupWall.name = @"cup";
        [self.milkCupObject addChild:self.rightCupWall];
        
        self.leftCupWall = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(5, (self.milkCupObject.size.height * 0.65))];
        self.leftCupWall.position = CGPointMake(-(self.milkCupObject.size.width * 0.4), self.milkCupObject.size.height * 0.1);
        self.leftCupWall.name = @"cup";
        [self.milkCupObject addChild:self.leftCupWall];
        
        self.leftCupWall.zRotation = 6 * 0.0174532925;
        self.rightCupWall.zRotation = -6 * 0.0174532925;
        
    }
    // the board
    {
        
        self.theBoard.position = CGPointMake(-half_screenWidth, -half_screenHeight * 0.5);
        self.theBoard.anchorPoint = CGPointMake(0, 0.5);
        [self.allFather addChild:self.theBoard];
        
    }
    // Company name
    {
        self.companyName.position = CGPointMake(0, -half_screenHeight + (self.companyName.size.height * 0.75));
        [self.allFather addChild:self.companyName];
    }
    
    // physics bodies
    {
        
        self.CupWalls_body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.leftCupWall.size.width, self.leftCupWall.size.height)];
        self.CupWalls_body.usesPreciseCollisionDetection = NO;
        self.CupWalls_body.dynamic = NO;
        self.CupWalls_body.categoryBitMask = wallCategory;
        self.CupWalls_body.contactTestBitMask = cookieCategory;
        self.CupWalls_body.collisionBitMask = cookieCategory;
        
        self.milk_body = [SKPhysicsBody bodyWithRectangleOfSize:self.milkCollider.size];
        self.milk_body.usesPreciseCollisionDetection = NO;
        self.milk_body.dynamic = NO;
        self.milk_body.categoryBitMask = cupCategory;
        self.milk_body.contactTestBitMask = cookieCategory;
        self.milk_body.collisionBitMask = cookieCategory;
        
        self.cookieBody = [SKPhysicsBody bodyWithCircleOfRadius:self.cookieToDunkPlay.size.width * 0.5];
        
        self.cookieBody.usesPreciseCollisionDetection = NO;
        self.cookieBody.categoryBitMask = cookieCategory;
        self.cookieBody.contactTestBitMask = cupCategory | wallCategory;
        self.cookieBody.collisionBitMask = cupCategory | wallCategory | cookieCategory;
        self.cookieBody.dynamic = YES;
        
        
        self.LeftBorder = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(15, kScreenHeight)];
        self.LeftBorder.position = CGPointMake(-half_screenWidth - 7.5, 0);
        self.LeftBorder.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.LeftBorder.size];
        self.LeftBorder.physicsBody.dynamic = NO;
        [self.allFather addChild:self.LeftBorder];
        
        self.RightBorder = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(15, kScreenHeight)];
        self.RightBorder.position = CGPointMake(half_screenWidth+ 7.5, 0);
        self.RightBorder.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.LeftBorder.size];
        self.RightBorder.physicsBody.dynamic = NO;
        [self.allFather addChild:self.RightBorder];
        
        self.BottomBorder = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(kScreenHeight, 15)];
        self.BottomBorder.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.BottomBorder.size];
        self.BottomBorder.physicsBody.dynamic = NO;
        self.BottomBorder.position = CGPointMake(0, -half_screenHeight - 7.5);
        [self.allFather addChild:self.BottomBorder];
        
    }
    
    //milksplash
    {
        SKTextureAtlas* milksplashAtlas = [SKTextureAtlas atlasNamed:@"Main_menu_milksplash"];
        
        NSArray* backMilk = @[
                              
                              [milksplashAtlas textureNamed:@"mainmenu-milksplash-back-01"],
                              [milksplashAtlas textureNamed:@"mainmenu-milksplash-back-02"],
                              [milksplashAtlas textureNamed:@"mainmenu-milksplash-back-03"],
                              [milksplashAtlas textureNamed:@"mainmenu-milksplash-back-04"],
                              [milksplashAtlas textureNamed:@"mainmenu-milksplash-back-05"],
                              [milksplashAtlas textureNamed:@"mainmenu-milksplash-back-06"],
                              [milksplashAtlas textureNamed:@"mainmenu-milksplash-back-07"],
                              [milksplashAtlas textureNamed:@"mainmenu-milksplash-back-01"]
                              
                              ];
        
        SKAction* backSplash = [SKAction animateWithTextures:backMilk timePerFrame:0.075 resize:YES restore:NO];
        
        NSArray* frontMilk = @[
                               
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-front-01"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-front-02"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-front-03"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-front-04"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-front-05"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-front-06"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-front-07"],
                               
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-08"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-09"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-10"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-11"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-12"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-13"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-14"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-15"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-16"],
                               [milksplashAtlas textureNamed:@"mainmenu-milksplash-whole-17"]
                               
                               ];
        
        SKAction* frontSplash = [SKAction animateWithTextures:frontMilk timePerFrame:0.075 resize:YES restore:NO];
        
        
        self.milkSplashCup = [SKSpriteNode spriteNodeWithTexture:[milksplashAtlas textureNamed:@"mainmenu-milkglass-back"]];
        self.milkSplashCup.position = self.milkCupObject.position;
        self.milkSplashCup.alpha = 0;
        [self.allFather addChild:self.milkSplashCup];
        
        SKSpriteNode* MilkBackPiece = [SKSpriteNode spriteNodeWithTexture:[backMilk objectAtIndex:0]];
//        MilkBackPiece.position = CGPointMake(0, -1);
        [self.milkSplashCup addChild:MilkBackPiece];
        MilkBackPiece.zPosition = 1;
        
        SKSpriteNode* MilkBackPieceLastFrame = [SKSpriteNode spriteNodeWithTexture:[backMilk objectAtIndex:0]];
        [self.milkSplashCup addChild:MilkBackPieceLastFrame];
        MilkBackPieceLastFrame.zPosition = 1;
        MilkBackPieceLastFrame.alpha = 0;
        
        SKSpriteNode* MilkFrontPiece = [SKSpriteNode spriteNodeWithTexture:[frontMilk objectAtIndex:0]];
        [self.milkSplashCup addChild:MilkFrontPiece];
        MilkFrontPiece.zPosition = 3;
        
        SKSpriteNode* MilkFrontPieceLastFrame = [SKSpriteNode spriteNodeWithTexture:[frontMilk objectAtIndex:0]];
        [self.milkSplashCup addChild:MilkFrontPieceLastFrame];
        MilkFrontPieceLastFrame.zPosition = 3;
        MilkFrontPieceLastFrame.alpha = 0;
        
        SKSpriteNode* FrontCupPiece = [SKSpriteNode spriteNodeWithTexture:[milksplashAtlas textureNamed:@"mainmenu-milkglass-front"]];
        [self.milkSplashCup addChild:FrontCupPiece];
        FrontCupPiece.zPosition = 4;
        
        
        SKAction* BackBlock = [SKAction runBlock:^{
            
            [MilkBackPiece runAction:backSplash completion:^{
                
                MilkBackPiece.alpha = 0.0;
                
            }];
            
        }];
        SKAction* FrontBlock = [SKAction runBlock:^{
            
            [MilkFrontPiece runAction:frontSplash completion:^{
                
                MilkFrontPiece.alpha = 0;
                
                MilkBackPieceLastFrame.alpha = 1;
                MilkFrontPieceLastFrame.alpha = 1;
                
            }];
            
        }];
        
        
//        SKAction* MilkDrip_Sound;
        
//        int which_sound = arc4random() % 3;
//        if(which_sound == 0){
//            MilkDrip_Sound = [SGAudioManager MakeSoundEffectAction:@"Cookie_Dunk1" withFileType:@".wav"];
//        }
//        else
//            if(which_sound == 1){
//                MilkDrip_Sound = [SGAudioManager MakeSoundEffectAction:@"Cookie_Dunk2" withFileType:@".wav"];
//            }
//            else
//                if(which_sound == 2){
//                    MilkDrip_Sound = [SGAudioManager MakeSoundEffectAction:@"Cookie_Dunk3" withFileType:@".wav"];
//                }
//                else{
//                    MilkDrip_Sound = [SGAudioManager MakeSoundEffectAction:@"Cookie_Dunk1" withFileType:@".wav"];
//                }
//        
//        SKAction* MilkDrip = [SKAction sequence:@[[SKAction waitForDuration:0.15], MilkDrip_Sound]];
        
        self.milkSplash = [SKAction sequence:@[[SKAction group:@[FrontBlock, BackBlock]]]];
        
    }
    

    self.paused = NO;
    
    // Button Button Collider
    
    SKSpriteNode *mainButtonColliderObject = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(80, 80)];
    self.buttonBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(80, 80)];
    self.buttonBody.usesPreciseCollisionDetection = NO;
    self.buttonBody.dynamic = NO;
    self.buttonBody.categoryBitMask = wallCategory;
    self.buttonBody.contactTestBitMask = cookieCategory;
    self.buttonBody.collisionBitMask = cookieCategory;
    
    mainButtonColliderObject.name = @"buttonCollider";
    mainButtonColliderObject.physicsBody = [self.buttonBody copy];
    mainButtonColliderObject.position = CGPointMake(0, 0);
    [self addChild:mainButtonColliderObject];
    
    
    // Version Number
    SKLabelNode *versionLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    versionLabel.position = CGPointMake(self.size.width * 0.98, self.size.height * 0.02);
    versionLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    versionLabel.fontSize = 8.0f;
    versionLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    versionLabel.color = [UIColor orangeColor];
    [self addChild:versionLabel];
}

- (void)repositionCookies
{
    self.cookieToDunkPlay.position = self.cookieToDunkPlayPos;
    self.cookieToDunkSocial.position = self.cookieToDunkSocialPos;
}

- (void)removeCookies
{
//    if (_cookieToDunkPlay)
//    {
//        _cookieToDunkPlay = nil;
//        [_cookieToDunkPlay removeFromParent];
//    }
//    if (_cookieToDunkSocial)
//    {
//        _cookieToDunkSocial = nil;
//        [_cookieToDunkSocial removeFromParent];
//    }
}

- (void)putTheCookiesInTheWrappers
{
    self.isLockedOut = NO;
//    _cookieToDunkPlay.position = _cookieToDunkPlayPos;
//    _cookieToDunkSocial.position = _cookieToDunkSocialPos;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isLockedOut == YES)
        return;
    
    self.isMessingAround = NO;
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        NSArray *nodes = [self nodesAtPoint:touchLocation];
        
        if ([nodes count])
        {
            for (SKNode *node in nodes)
            {
                //Make sure it's the proper type.
                if ([node.name isEqualToString:@"play"])
                {
                    self.cookieToDunkPlay.zPosition = 10;
                    self.cookieToDunkPlay.physicsBody = nil;
                    self.sequenceAction = nil;
                    [self.cookieToDunkPlay removeAllActions];
                    [self.cookieToDunkPlay setTexture:[SKTexture textureWithImageNamed:@"mainmenu-cookie-select-chip-frame01"]];
                    self.whichCookie = 1;
                    self.cookieWasDropped = NO;
                    if (!self.playCookieWasDropped) {
                        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"CookieWrap" FileType:@"caf"]; //@"m4a"];
                        self.playCookieWasDropped = YES;
                    }
                }
                else if ([node.name isEqualToString:@"social"])
                {
                    self.cookieToDunkSocial.zPosition = 10;
                    self.cookieToDunkSocial.physicsBody = nil;
                    self.sequenceAction = nil;
                    [self.cookieToDunkSocial removeAllActions];
                    [self.cookieToDunkSocial setTexture:[SKTexture textureWithImageNamed:@"mainmenu-cookie-select-mikey-frame01"]];
                    self.whichCookie = 2;
                    self.cookieWasDropped = NO;
                    if (!self.socialCookieWasDropped) {
                        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"CookieWrap" FileType:@"caf"]; //@"m4a"];
                        self.socialCookieWasDropped = YES;
                    }
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        if (self.whichCookie == 1)
        {
            self.isMessingAround = YES;
            
            self.cookieToDunkPlay.position = [self convertPoint:touchLocation toNode:self.allFather];
            
        }
        else if (self.whichCookie == 2)
        {
            self.isMessingAround = YES;
            
            self.cookieToDunkSocial.position = [self convertPoint:touchLocation toNode:self.allFather];
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        NSArray *nodes = [self nodesAtPoint:touchLocation];
        
        if ([nodes count])
        {
            for (SKNode *node in nodes)
            {
                if ([node.name isEqualToString:@"playButton"])
                {
                    if(self.isMessingAround == NO)
                        if((self.cookieToDunkPlay.position.x == self.cookieToDunkPlayPos.x && self.cookieToDunkPlay.position.y == self.cookieToDunkPlayPos.y) || self.whichCookie == 0)
                            if ([self.delegate respondsToSelector:@selector(didDunkACookie:)])
                            {
//                                [self.allFather removeAllActions];
//                                [self.allFather removeFromParent];
//                                self.allFather = nil;
                                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"CookieWrap" FileType:@"caf"]; //@"m4a"];
                                [self.delegate didDunkACookie:YES];
                                return;
                            }
                }
                else if ([node.name isEqualToString:@"socialButton"])
                {
                    if(self.isMessingAround == NO)
                        if((self.cookieToDunkSocial.position.x == self.cookieToDunkSocialPos.x && self.cookieToDunkSocial.position.y == self.cookieToDunkSocialPos.y) || self.whichCookie == 0)
                            if ([self.delegate respondsToSelector:@selector(didDunkACookie:)])
                            {
                                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"CookieWrap" FileType:@"caf"]; //@"m4a"];
                                [self.delegate didDunkACookie:NO];
                                return;
                            }
                }
            }
        }
    }
    
    if (self.whichCookie == 1)
    {
        self.cookieToDunkPlay.physicsBody = [self.cookieBody copy];
        self.whichCookie = 0;
        
        if(self.cookieToDunkPlay.position.y > self.milkCupObject.position.y + (self.milkCupObject.size.height*0.5)){
            
            self.cookieToDunkPlay.zPosition = self.milkCupObject.zPosition+2;
            [self Give_theCup_Physics];
            
        }else
        {
            [self TakeAway_theCup_Physics];
            
        }
    }
    else if (self.whichCookie == 2)
    {
        self.cookieToDunkSocial.physicsBody = [self.cookieBody copy];
        self.whichCookie = 0;
        
        if(self.cookieToDunkSocial.position.y > self.milkCupObject.position.y + (self.milkCupObject.size.height*0.5)){
            
            self.cookieToDunkSocial.zPosition = self.milkCupObject.zPosition+2;
            [self Give_theCup_Physics];
            
        }else
        {
            [self TakeAway_theCup_Physics];
        }
    }
}

-(void)Give_theCup_Physics{
    
    self.leftCupWall.physicsBody = [self.CupWalls_body copy];
    self.rightCupWall.physicsBody = [self.CupWalls_body copy];
    self.milkCollider.physicsBody = [self.milk_body copy];
    
}

-(void)TakeAway_theCup_Physics{
    
    self.leftCupWall.physicsBody = nil;
    self.rightCupWall.physicsBody = nil;
    self.milkCollider.physicsBody = nil;
    
}

- (void)bobUpAndDownWithNode:(SKNode *)node withDuration:(NSTimeInterval)timeDuration
{
//    DebugLog(@"run started");
    SKAction *bobUp = [SKAction moveBy:CGVectorMake(0, 10) duration:timeDuration];
    SKAction *bobDown = [SKAction moveBy:CGVectorMake(0, -10) duration:timeDuration];

//    SKAction *bobUpCompletion = [SKAction runBlock:^{
//        bobUp.timingMode = SKActionTimingEaseInEaseOut;
//        [node runAction:bobDown completion:^{
//            bobUp.timingMode = SKActionTimingEaseInEaseOut;
//            [self bobUpAndDownWithNode:node withDuration:timeDuration];
//        }];
//    }];
//
//    SKAction *sequence = [SKAction sequence:@[bobUp, bobUpCompletion]];
//    [node runAction:sequence withKey:@"bobbingAction"];
    
    [node runAction:bobUp completion:^{
        bobUp.timingMode = SKActionTimingEaseInEaseOut;
        [node runAction:bobDown completion:^{
            bobUp.timingMode = SKActionTimingEaseInEaseOut;
            [self bobUpAndDownWithNode:node withDuration:timeDuration];
        }];
    }];
}

- (void)runParallaxOne
{
    [_starParallaxOne runAction:[SKAction moveTo:CGPointMake(_galaxyBackground.position.x - (_galaxyBackground.size.width * .5) - (_starParallaxOne.size.width * .5), _starParallaxOne.position.y) duration:3] completion:^{
        _starParallaxOne.position = _parallaxStartPointOne;
        [self runParallaxOne];
    }];
}

- (void)runParallaxOneSpare
{
    [_starParallaxOneSpare runAction:[SKAction moveTo:CGPointMake(_galaxyBackground.position.x - (_galaxyBackground.size.width * .5) - (_starParallaxOne.size.width), _starParallaxOne.position.y) duration:3] completion:^{
        _starParallaxOneSpare.position = _parallaxStartPointOne;
        [self runParallaxOneSpare];
    }];
}

- (void)runParallaxTwo
{
    [_starParallaxTwo runAction:[SKAction moveTo:CGPointMake(_galaxyBackground.position.x - (_galaxyBackground.size.width * .5) - (_starParallaxTwo.size.width * .5), _starParallaxTwo.position.y) duration:4] completion:^{
        _starParallaxTwo.position = _parallaxStartPointTwo;
        [self runParallaxTwo];
    }];
}

- (void)runParallaxTwoSpare
{
    [_starParallaxTwoSpare runAction:[SKAction moveTo:CGPointMake(_galaxyBackground.position.x - (_galaxyBackground.size.width * .5) - (_starParallaxTwo.size.width), _starParallaxTwo.position.y) duration:4] completion:^{
        _starParallaxTwoSpare.position = _parallaxStartPointTwo;
        [self runParallaxTwoSpare];
    }];
}

#pragma mark - contact delegates

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.node == self.milkCollider || contact.bodyB.node == self.milkCollider)
    {
        if(contact.bodyA.node == self.cookieToDunkPlay || contact.bodyB.node == self.cookieToDunkPlay){
            
            self.cookieToDunkPlay.physicsBody = nil;
            [self Splash_the_Milk:YES];
            [self.cookieToDunkPlay runAction:[SKAction moveTo:self.milkCollider.position duration:0.2] completion:^{
                
                self.cookieToDunkPlay.alpha = 0;
                
            }];
            
        }
        
        if(contact.bodyA.node == self.cookieToDunkSocial || contact.bodyB.node == self.cookieToDunkSocial){
            
            self.cookieToDunkSocial.physicsBody = nil;
            [self Splash_the_Milk:NO];
            [self.cookieToDunkSocial runAction:[SKAction moveTo:self.milkCollider.position duration:0.2] completion:^{
                
                self.cookieToDunkSocial.alpha = 0;
                
            }];
        }
    }
    else
        if([contact.bodyA.node.name isEqualToString:@"cup"] || [contact.bodyB.node.name isEqualToString:@"cup"]){
            
            
        }
        else
        {
            if (!self.isPlayingHitSound)
            {
                self.isPlayingHitSound = YES;
                
                NSString* soundName = [NSString stringWithFormat:@"Cookie_Hits_Hit%i",self.hitSoundEffect];
                
//                [self runAction:[SKAction sequence:@[[SGAudioManager MakeSoundEffectAction:soundName withFileType:@".wav"],[SKAction waitForDuration:0.5]]] completion:^{
//                    self.isPlayingHitSound = NO;
//                }];
                
                [[SGAudioManager audioManager] playSoundEffectWithFilename:soundName FileType:@"wav" volume:1.0f completion:^{
                    self.isPlayingHitSound = NO;
                }];
                
                
                self.hitSoundEffect++;
                
                if(self.hitSoundEffect >= 5)
                {
                    self.hitSoundEffect = 1;
                }
            }
        }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    if (([contact.bodyA.node.name isEqualToString:@"scene"] && contact.bodyB.node == self.cookieToDunkPlay) || ([contact.bodyB.node.name isEqualToString:@"scene"] && contact.bodyA.node == self.cookieToDunkPlay))
    {
        //        [self resetCookie];
    }
    else if (([contact.bodyA.node.name isEqualToString:@"scene"] && contact.bodyB.node == self.cookieToDunkSocial) || ([contact.bodyB.node.name isEqualToString:@"scene"] && contact.bodyA.node == self.cookieToDunkSocial))
    {
        //        [self resetCookie];
    }
}

- (void)cookieWasDunked:(NSNumber *)wasPlay
{
    if ([self.delegate respondsToSelector:@selector(didDunkACookie:)])
    {
        [self.delegate didDunkACookie:[wasPlay boolValue]];
    }
}

- (void)milkSplashCompletion:(BOOL)wasPlayCookie
{
    int whichSound = arc4random() % 3;
    
    NSString *soundName = @"";
    
    switch (whichSound) {
        case 0:
            soundName = @"Cookie_Dunk1";
            break;
            
        case 1:
            soundName = @"Cookie_Dunk2";
            break;
            
        case 2:
            soundName = @"Cookie_Dunk3";
            break;
            
        case 3:
            soundName = @"Cookie_Dunk4";
            break;
            
        default:
            soundName = @"Cookie_Dunk4";
            break;
    }
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:soundName FileType:@"wav" volume:1.0f completion:^{
        [self performSelector:@selector(cookieWasDunked:) withObject:[NSNumber numberWithBool:wasPlayCookie] afterDelay:2];
    }];
    
//    if(whichSound == 0)
//    {
//        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Dunk1" FileType:@"wav" volume:1.0f completion:^(BOOL completion) {
//            [self performSelector:@selector(cookieWasDunked:) withObject:[NSNumber numberWithBool:wasPlayCookie] afterDelay:2];
//        }];
//    }
//    else if(whichSound == 1)
//    {
//        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Dunk2" FileType:@"wav" volume:1.0f completion:^(BOOL completion) {
//            [self performSelector:@selector(cookieWasDunked:) withObject:[NSNumber numberWithBool:wasPlayCookie] afterDelay:2];
//        }];
//    }
//    else if(whichSound == 2)
//    {
//        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Dunk3" FileType:@"wav" volume:1.0f completion:^(BOOL completion) {
//            [self performSelector:@selector(cookieWasDunked:) withObject:[NSNumber numberWithBool:wasPlayCookie] afterDelay:2];
//        }];
//    }
//    else
//    {
//        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Dunk4" FileType:@"wav" volume:1.0f completion:^(BOOL completion) {
//            [self performSelector:@selector(cookieWasDunked:) withObject:[NSNumber numberWithBool:wasPlayCookie] afterDelay:2];
//        }];
//    }
}

-(void)Splash_the_Milk:(BOOL)playOrSocial{
    
    self.isLockedOut = YES;
    
//    [self.milkCupObject removeFromParent];
    
    self.milkSplashCup.alpha = 1.0;
    self.milkCupObject.alpha = 0;
    
    if (playOrSocial)
    {
        // Run the milk splash, then head to the map.
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.08], self.milkSplash]]];
        [self milkSplashCompletion:YES];
        
        // Check for the achievement.
        if ([[SGGameCenterManager gcManager] progressOfAchievementWithIdentifier:@"Cookie_Dunk_Dunk"] < 100.0f) {
            DebugLog(@"Dunked a cookie");
            // We interrupt your regular program to give you this achievement report.
            [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"cookie_dunk_dunked" percentComplete:100.0f Completion:^(BOOL wasSuccessful) {
                if (wasSuccessful) {
                    [[SGGameCenterManager gcManager] displayAchievementAlertForAchievementWithIdentifier:@"cookie_dunk_dunked" InView:[SGAppDelegate appDelegate].window.rootViewController.view Completion:^(BOOL completion) {
                        
                    }];
                }
            }];
        }
        
        
    }else{
        
        // Dunked Social cookie.
        if ([self.delegate respondsToSelector:@selector(didDunkACookie:)])
        {
            [self runAction:self.milkSplash completion:^{
                [self milkSplashCompletion:NO];
            }];
        }
        
    }
    
}

#pragma mark - screen rotation

- (void)Rotate_to_Landscape:(float)duration
{
    DebugLog(@"Land");
    
    float half_screenWidth = self.view.frame.size.width * 0.5f;//kScreenHeight * 0.5;
    float half_screenHeight = self.view.frame.size.height * 0.5f;//kScreenWidth * 0.5;
    
    self.allFather.position = CGPointMake(half_screenWidth, half_screenHeight);
    
//    [self.TitleLogo removeAllActions];
//    self.TitleLogo.position = CGPointMake(self.TitleLogo.position.x, half_screenHeight - self.TitleLogo.size.height * 0.5);
    
    self.milkCupObject.position = CGPointMake(0, -self.milkCupObject.size.height * 0.25);
    self.milkSplashCup.position = self.milkCupObject.position;
    
    self.playButton.position = CGPointMake(-half_screenWidth * 0.5, self.milkCupObject.position.y);
    self.redReflection.position = CGPointMake(self.playButton.position.x, self.playButton.position.y + (-self.playButton.size.height * 0.5) + (-self.redReflection.size.height * 0.5));
    self.socialButton.position = CGPointMake(-self.playButton.position.x,self.milkCupObject.position.y);
    self.blueReflection.position = CGPointMake(self.socialButton.position.x, self.socialButton.position.y + (-self.socialButton.size.height * 0.5) + (-self.blueReflection.size.height * 0.5));
    
    if (IS_IPAD)
    {
        self.cookieToDunkPlay.position = CGPointMake(self.playButton.position.x, self.playButton.position.y+110);
        self.cookieToDunkSocial.position = CGPointMake(self.socialButton.position.x, self.socialButton.position.y+110);
    }
    else
    {
        self.cookieToDunkPlay.position = CGPointMake(self.playButton.position.x, self.playButton.position.y+55);
        self.cookieToDunkSocial.position = CGPointMake(self.socialButton.position.x, self.socialButton.position.y+55);
    }
    
    [self.cookieToDunkPlay removeAllActions];
    self.cookieToDunkPlay.physicsBody = nil;
    self.cookieToDunkPlay.zPosition = self.playButton.zPosition-1;
    
    self.cookieToDunkPlayPos = self.cookieToDunkPlay.position;
    
    [self.cookieToDunkSocial removeAllActions];
    self.cookieToDunkSocial.physicsBody = nil;
    self.cookieToDunkSocial.zPosition = self.socialButton.zPosition-1;
    
    self.cookieToDunkSocialPos = self.cookieToDunkSocial.position;
    
    self.LeftBorder.position = CGPointMake(-half_screenWidth - 7.5, 0);
    self.RightBorder.position = CGPointMake(half_screenWidth + 7.5, 0);
    self.BottomBorder.position = CGPointMake(0, -half_screenHeight - 7.5);
    
    self.theBoard.position = CGPointMake(-half_screenWidth, -half_screenHeight * 0.5);
    
    self.companyName.position = CGPointMake(0, -half_screenHeight + (self.companyName.size.height * 0.75));
    
}
- (void)Rotate_to_Portrait:(float)duration
{
    DebugLog(@"Port");
    
    float half_screenWidth = kScreenWidth * 0.5;
    float half_screenHeight = kScreenHeight * 0.5;
    
    self.allFather.position = CGPointMake(half_screenWidth, half_screenHeight);
    
//    [self.TitleLogo removeAllActions];
//    self.TitleLogo.position = CGPointMake(self.TitleLogo.position.x, kScreenHeight * 0.3);
    
    self.milkCupObject.position = CGPointMake(0, -self.milkCupObject.size.height * 0.25);
    self.milkSplashCup.position = self.milkCupObject.position;
    
    self.playButton.position = CGPointMake(-half_screenWidth + (self.theBoard.size.width) + (self.playButton.size.width * 0.5), self.milkCupObject.position.y);
    self.redReflection.position = CGPointMake(self.playButton.position.x, self.playButton.position.y + (-self.playButton.size.height * 0.5) + (-self.redReflection.size.height * 0.5));
    self.socialButton.position = CGPointMake(-self.playButton.position.x,self.milkCupObject.position.y);
    self.blueReflection.position = CGPointMake(self.socialButton.position.x, self.socialButton.position.y + (-self.socialButton.size.height * 0.5) + (-self.blueReflection.size.height * 0.5));
    
    if (IS_IPAD)
    {
        self.cookieToDunkPlay.position = CGPointMake(self.playButton.position.x, self.playButton.position.y+110);
        self.cookieToDunkSocial.position = CGPointMake(self.socialButton.position.x, self.socialButton.position.y+110);
    }
    else
    {
        self.cookieToDunkPlay.position = CGPointMake(self.playButton.position.x, self.playButton.position.y+55);
        self.cookieToDunkSocial.position = CGPointMake(self.socialButton.position.x, self.socialButton.position.y+55);
    }
    
    [self.cookieToDunkPlay removeAllActions];
    self.cookieToDunkPlay.physicsBody = nil;
    self.cookieToDunkPlay.zPosition = self.playButton.zPosition-1;
    
    self.cookieToDunkPlayPos = self.cookieToDunkPlay.position;
    
    [self.cookieToDunkSocial removeAllActions];
    self.cookieToDunkSocial.physicsBody = nil;
    self.cookieToDunkSocial.zPosition = self.socialButton.zPosition-1;
    
    self.cookieToDunkSocialPos = self.cookieToDunkSocial.position;
    
    self.LeftBorder.position = CGPointMake(-half_screenWidth - 7.5, 0);
    self.RightBorder.position = CGPointMake(half_screenWidth + 7.5, 0);
    self.BottomBorder.position = CGPointMake(0, -half_screenHeight - 7.5);
    
    self.theBoard.position = CGPointMake(-half_screenWidth, -half_screenHeight * 0.5);
    
    self.companyName.position = CGPointMake(0, -half_screenHeight + (self.companyName.size.height * 0.75));
    
}
@end

