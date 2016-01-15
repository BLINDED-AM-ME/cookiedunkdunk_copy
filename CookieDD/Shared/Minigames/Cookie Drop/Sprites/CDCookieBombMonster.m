//
//  CDCookieBombMonster.m
//  CookieDD
//
//  Created by gary johnston on 8/7/13.
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

#import "CDCookieBombMonster.h"
#import "CDCookieBombScene.h"

@interface CDCookieBombMonster()

@property (strong, nonatomic) CDCookieBombScene *theScene;

@property (assign, nonatomic) BOOL inPlace;

@property (assign, nonatomic) int randX;
@property (assign, nonatomic) int timeDurationDivider;
@property (assign, nonatomic) int distToCheck;

//@property (strong, nonatomic) SKAction *animateLeft;
//@property (strong, nonatomic) SKAction *animateRight;

@property (strong, nonatomic) SKTexture *milkMonsterTexture;
@property (strong, nonatomic) SKTexture *cookieTexture;
@property (strong, nonatomic) SKTextureAtlas *atlas;

@end



@implementation CDCookieBombMonster

- (id)initWithScene:(CDCookieBombScene *)scene
{
    self = [super init];
    _cookiesToScaleArray = [[NSMutableArray alloc] init];
    _timeDurationDivider = 20;
    
    _theScene = scene;
    _isMovingLeft = YES;
    _inPlace = YES;
    _canDrop = NO;
    BOOL retina = NO;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
    {
        retina = YES;
    }
    
    // Hello Bug, Josh says "hi"....
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        _distToCheck = 20;
        _atlas = [SKTextureAtlas atlasNamed:@"cookieBomb_milkMonster_iphone5"];
    }
//    else if (IS_IPHONE_4)
//    {
//        _distToCheck = 20;
//        
//        if (retina)
//        {
//            _atlas = [SKTextureAtlas atlasNamed:@"cookieBomb_milkMonster_iphone4_retina"];
//        }
//        else
//        {
//            _atlas = [SKTextureAtlas atlasNamed:@"cookieBomb_milkMonster_iphone4"];
//        }
//    }
    else
    {
        self.distToCheck = 40;
        
        if (retina)
        {
            _atlas = [SKTextureAtlas atlasNamed:@"cookieBomb_milkMonster_ipad_retina"];
        }
        else
        {
            _atlas = [SKTextureAtlas atlasNamed:@"cookieBomb_milkMonster_ipad"];
        }

    }
    
    SKTexture *leftOne = [_atlas textureNamed:@"cookieBomb_milkMonster-left1"];
    SKTexture *leftTwo = [_atlas textureNamed:@"cookieBomb_milkMonster-left2"];
    SKTexture *leftThree = [_atlas textureNamed:@"cookieBomb_milkMonster-left3"];
    SKTexture *leftFour = [_atlas textureNamed:@"cookieBomb_milkMonster-left4"];
    SKTexture *leftFive = [_atlas textureNamed:@"cookieBomb_milkMonster-left5"];
    SKTexture *leftSix = [_atlas textureNamed:@"cookieBomb_milkMonster-left6"];
    SKTexture *leftSeven = [_atlas textureNamed:@"cookieBomb_milkMonster-left7"];

    _leftAnimationArray = @[leftOne, leftTwo, leftThree, leftFour, leftFive, leftSix, leftSeven];
//    _animateLeft = [SKAction animateWithTextures:_leftAnimationArray timePerFrame:.0714 resize:YES restore:NO];
    
    SKTexture *rightOne = [_atlas textureNamed:@"cookieBomb_milkMonster-right1"];
    SKTexture *rightTwo = [_atlas textureNamed:@"cookieBomb_milkMonster-right2"];
    SKTexture *rightThree = [_atlas textureNamed:@"cookieBomb_milkMonster-right3"];
    SKTexture *rightFour = [_atlas textureNamed:@"cookieBomb_milkMonster-right4"];
    SKTexture *rightFive = [_atlas textureNamed:@"cookieBomb_milkMonster-right5"];
    
    _rightAnimationArray = @[rightOne, rightTwo, rightThree, rightFour, rightFive];
//    _animateRight = [SKAction animateWithTextures:_rightAnimationArray timePerFrame:.0714 resize:YES restore:NO];
    
    _milkMonsterTexture = [_atlas textureNamed:@"cookieBomb_milkMonster-0"];
    _milkMonster = [SKSpriteNode spriteNodeWithTexture:_milkMonsterTexture];
    
    CGPoint monsterLocation;
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        monsterLocation = CGPointMake(_theScene.size.width*.5, (_theScene.towerObject.size.height)-50);
    }
//    else if (IS_IPHONE_5)
//    {
//        monsterLocation = CGPointMake(self.theScene.size.width*.5, (self.theScene.towerObject.size.height)-50);
//    }
    else
    {
        monsterLocation = CGPointMake(_theScene.size.width*.5, (_theScene.towerObject.size.height)-100);
    }
    
    _milkMonster.position = monsterLocation;
    _milkMonster.name = @"milky";
    _milkMonster.physicsBody.categoryBitMask = milkMonsterCategory;
    _milkMonster.physicsBody.contactTestBitMask = wallCategory;
    _milkMonster.physicsBody.collisionBitMask = wallCategory;
    _milkMonster.zPosition = -1001;
    [_theScene addChild:_milkMonster];
    
    return [super init];
}

- (void)moveMilky
{
    if (_inPlace)
    {
        _inPlace = NO;
        
        float milkyPercent = _milkMonster.size.width/_theScene.size.width;
        float movePercent = .406;
        
        int moveDist = (_theScene.size.width*(movePercent-milkyPercent));
        int remainder = _theScene.size.width - moveDist;
        int distance = 0;
        
        while (distance < _distToCheck)
        {
            _randX = arc4random()%moveDist;
            _randX += remainder*.5;
            
            distance = _milkMonster.position.x - _randX;
            
            if (distance < 0)
            {
                distance *= -1;
            }
        }
        SKAction *move = [SKAction moveToX:_randX duration:distance/_timeDurationDivider];
//        DebugLog(@"Moving!!!!");
        [_milkMonster runAction:move completion:^{
//            DebugLog(@"Reached Posisition!!!!");
            [self throwCookieWithMaxThrow:8 minThrow:-8 withMilkMonsterPosition:_milkMonster.position];
            _inPlace = YES;
        }];
    }
}

- (void)throwCookieWithMaxThrow:(int)max minThrow:(int)min withMilkMonsterPosition:(CGPoint)milkMonsterPosition
{
    if (_canDrop)
    {
        int randTexture = arc4random() % 7; // Number of cookies
        _canDrop = NO;
        
        switch (randTexture)
        {
            case 0:
                _cookieTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-cookie-chip"];
                break;
                
            case 1:
                _cookieTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-cookie-dustin"];
                break;
                
            case 2:
                _cookieTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-cookie-gerry"];
                break;
                
            case 3:
                _cookieTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-cookie-jj"];
                break;
                
            case 4:
                _cookieTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-cookie-luke"];
                break;
                
            case 5:
                _cookieTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-cookie-reginald"];
                break;
                
            case 6:
                _cookieTexture = [_atlas textureNamed:@"cdd-mini-cookiedrop-cookie-mikey"];
                break;
                
            default:
                break;
        }
        
//        DebugLog(@"Creating a new cookie");
        
        SKSpriteNode *cookie = [SKSpriteNode spriteNodeWithTexture:_cookieTexture];
        cookie.name = @"cookieObject";
        cookie.position = CGPointMake(_milkMonster.position.x, _milkMonster.position.y-(_milkMonster.size.height*.5));
        cookie.zPosition = -1000;
        cookie.xScale = .7;
        cookie.yScale = .7;
        
        cookie.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:cookie.size.width*.5];
        cookie.physicsBody.usesPreciseCollisionDetection = YES;
        cookie.physicsBody.categoryBitMask = cookieCategory;
        cookie.physicsBody.contactTestBitMask = cupCategory | sceneCategory | cookieCategory | floorCategory | wallCategory | boxCategory;
        cookie.physicsBody.collisionBitMask = cupCategory | sceneCategory | cookieCategory | floorCategory | wallCategory | boxCategory;
        cookie.physicsBody.dynamic = YES;
        cookie.physicsBody.affectedByGravity = YES;
        
        int randNum = rand() % (max - min) + min;
        
        cookie.position = milkMonsterPosition;
        
        [self.theScene addChild:cookie];
        
        [self enumerateChildNodesWithName:@"cookieObject" usingBlock:^(SKNode *node, BOOL *stop)
         {
             if (cookie != node && [cookie intersectsNode:node])
             {
                 [cookie removeFromParent];
             }
         }];
        
        if (randNum <= 0)
        {
            [cookie.physicsBody applyImpulse:CGVectorMake(randNum, randNum)];
            [cookie.physicsBody applyForce:CGVectorMake(randNum, randNum)];

            [_milkMonster runAction:[SKAction animateWithTextures:_leftAnimationArray timePerFrame:.0714 resize:YES restore:NO] completion:^
             {
                 _milkMonster.texture = _milkMonsterTexture;
             }];
        }
        else if (randNum > 0)
        {
            [cookie.physicsBody applyImpulse:CGVectorMake(randNum, -randNum)];
            [cookie.physicsBody applyForce:CGVectorMake(randNum, -randNum)];
            
            [_milkMonster runAction:[SKAction animateWithTextures:_rightAnimationArray timePerFrame:.0714 resize:YES restore:NO] completion:^
             {
                 _milkMonster.texture = _milkMonsterTexture;
             }];
        }
        
        [_cookiesToScaleArray addObject:cookie];
        
        CDCookieBombScene* bombScene = (CDCookieBombScene*) _theScene;
        [bombScene playThrowSound:cookie];
    }
}

- (void)scaleCookieUp:(SKSpriteNode *)cookie ScaleBy:(float)multiplier
{
    if ((cookie.position.y < _theScene.cupSideLeftObject.position.y + (_theScene.cupSideLeftObject.size.height*.5)) &&
        ((cookie.position.x < _theScene.cupSideLeftObject.position.x) || (cookie.position.x > _theScene.cupSideRightObject.position.x)))
    {
        cookie.name = @"Cookie is too low!!!!";
    }
    
    SKSpriteNode *testCookie = [SKSpriteNode spriteNodeWithTexture:[_atlas textureNamed:@"cdd-mini-cookiedrop-cookie-gerry"]];
    if ((cookie.size.height) < (testCookie.size.height))
    {
        float divider = cookie.size.height*multiplier;
        cookie.xScale /= divider*0.0547f;
        cookie.yScale /= divider*0.0547f;
        
        SKPhysicsBody *newBody = [SKPhysicsBody bodyWithCircleOfRadius:cookie.size.width*.5];
        newBody.velocity = cookie.physicsBody.velocity;
    
        cookie.physicsBody = newBody;
    }
    else
    {
        [_cookiesToScaleArray removeObject:cookie];
    }
}

- (void)forceKillAudio
{
    [[SGAudioManager audioManager] stopAllAudio];
}

@end
