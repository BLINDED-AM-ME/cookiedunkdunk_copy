//
//  CDParticleEmitter.m
//  particleTestingSite
//
//  Created by gary johnston on 9/24/13.
//  Copyright (c) 2013 gary johnston. All rights reserved.
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

#import "CDParticleEmitter.h"
#import "CDCookieSpriteNode.h"

static CDParticleEmitter *particleEmitter = nil;

@interface CDParticleEmitter ()
@property (strong, nonatomic) NSArray *ashFramesArray;
@property (strong, nonatomic) SKTexture *black; //= [SKTexture sgtextureWithImageNamed:@"cookieBlack"];

@end

@implementation CDParticleEmitter

- (id)initWithParticleSetup:(SKScene *)scene 
{
    return [super init];
}

+ (CDParticleEmitter *)particleEmitter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        particleEmitter = [CDParticleEmitter new];
        particleEmitter.ashFramesArray = [NSArray arrayWithObjects:[SKTexture sgtextureWithImageNamed:@"cookieDisintigration_01"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_02"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_03"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_04"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_05"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_06"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_08"], nil];
        particleEmitter.black = [SKTexture sgtextureWithImageNamed:@"cookieBlack"];

    });
    
    return particleEmitter;
}

// Multipliers are used for scaling purposes. DO NOT RESIZE THE ACTUAL PARTICLES!!!!
- (SKEmitterNode *)emitter:(SKNode *)parent Position:(CGPoint)position EmitterName:(NSString *)name EmitterMultiplier:(float)emitterMultiplier DeletionTime:(float)deletionTime
{
    SKEmitterNode *node = [self emitterCreator:parent Multiplier:emitterMultiplier EmitterName:name];
   // DebugLog(@"position.x: %f", position.x);
    // DebugLog(@"position.y: %f", position.y);
    node.position = position;
    
    //node.particleLifetime *= emitterMultiplier;
    //node.particleLifetimeRange *= emitterMultiplier;
    
//    node.particleBirthRate *= emitterMultiplier;
//    node.numParticlesToEmit *= emitterMultiplier;
    
    [parent addChild:node];
    
    if (deletionTime > 0)
    {
        [node performSelector:@selector(removeFromParent) withObject:nil afterDelay:deletionTime];
    }
    
    return node;
}

- (void)emitNode:(SKEmitterNode *)emitterNode
      emitterParent:(SKNode *)parent
           Position:(CGPoint)position
  emitterMultiplier:(float)emitterMultiplier
    deletionTime:(float)deletionTime
 isFirstParticle:(BOOL)isFirstParticle
{
    emitterNode.particlePositionRange = CGVectorMake((emitterNode.particlePositionRange.dx * emitterMultiplier), (emitterNode.particlePositionRange.dy * emitterMultiplier));
    
    emitterNode.particleScale *= emitterMultiplier;
    emitterNode.particleScaleRange *= emitterMultiplier;
    
    emitterNode.particleSpeed *= emitterMultiplier;
    emitterNode.particleSpeedRange *= emitterMultiplier;
    
    emitterNode.xAcceleration *= emitterMultiplier;
    emitterNode.yAcceleration *= emitterMultiplier;
    
    emitterNode.position = position;
    
    
    [parent addChild:emitterNode];
    
    /*
    if ([parent isKindOfClass:[CDCookieSpriteNode class]])
    {
        CDCookieSpriteNode *cookie = (CDCookieSpriteNode *)parent;
        
        if(cookie.particleDeletionType == ParticleDeletionType_ASH)
        {
           // [self ashAnimationWithCookie:cookie];
        }
    }
     */
    
    if (deletionTime > 0)
    {
        [emitterNode performSelector:@selector(removeFromParent) withObject:nil afterDelay:deletionTime];
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(deletionTime * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [emitterNode removeFromParent];
//
//        });
    }
}

// YES IT IS EXCESSIVE BUT, IT WORKS!!!!
- (void)burnAnimation:(SKNode *)parent TargetNode:(SKNode *)targetNode Position:(CGPoint)position ObjectSize:(CGSize)size DeletionTime:(float)deletionTime WithSmokeConstant:(BOOL)smokeConstant WithFireEffect:(BOOL)fireEffect WithAshesEffect:(BOOL)ashEffect CookieType:(NSString *)cookieType DelayForFire:(float)fireDelayTime DelayForAsh:(float)ashDelayTime;
{
    float emitterMultiplier = size.height/50;
    
    NSMutableArray *emitterArray = [[NSMutableArray alloc]init];
    
    if (smokeConstant)
    {
        NSString *emitterName = @"SmokeParticleConstant";
        [emitterArray addObject:emitterName];
    }
    if (fireEffect)
    {
        NSString *smokeEmitterName = @"SmokeParticle";
        [emitterArray addObject:smokeEmitterName];
        
        NSString *fireEmitterName = @"FireParticle";
        [emitterArray addObject:fireEmitterName];
        
        NSString *sparksEmitterName = @"FireSparksParticle";
        [emitterArray addObject:sparksEmitterName];
        
        NSString *glowEmitterName = @"FireGlowParticle";
        [emitterArray addObject:glowEmitterName];
        
    }
    if (ashEffect)
    {
        NSString *emitterName = @"AshParticle";
        [emitterArray addObject:emitterName];
    }
    
    
    for (NSString *name in emitterArray)
    {
        SKEmitterNode *node = [self emitterCreator:parent Multiplier:emitterMultiplier EmitterName:name];
        
        if(node == nil)
            return;
        
        node.position = position;

        if ([name isEqualToString:@"FireParticle"] || [name isEqualToString:@"FireSparksParticle"] || [name isEqualToString:@"SmokeParticle"] || [name isEqualToString:@"FireGlowParticle"])
        {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fireDelayTime * NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^(void)
            {
                [parent addChild:node];
            });
        }
        else if ([name isEqualToString:@"AshParticle"])
        {
            [self createAshAnimationWithParent:parent WithEmitterMultiplier:emitterMultiplier WithDelayTime:ashDelayTime];
        }
        else
        {
            [parent addChild:node];
        }
        
        node.targetNode = targetNode;
        if (deletionTime > 0)
        {
            [node performSelector:@selector(removeFromParent) withObject:nil afterDelay:deletionTime];
        }
    }
}

- (SKEmitterNode *)emitterCreator:(SKNode *)node Multiplier:(float)emitterMultiplier EmitterName:(NSString *)emitterName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:emitterName ofType:@"sks"];
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    emitter.particlePositionRange = CGVectorMake((emitter.particlePositionRange.dx * emitterMultiplier), (emitter.particlePositionRange.dy * emitterMultiplier));
    
    emitter.particleScale *= emitterMultiplier;
    emitter.particleScaleRange *= emitterMultiplier;
    
    emitter.particleSpeed *= emitterMultiplier;
    emitter.particleSpeedRange *= emitterMultiplier;
    
    emitter.xAcceleration *= emitterMultiplier;
    emitter.yAcceleration *= emitterMultiplier;
    
    return emitter;
}


- (void)createAshAnimationWithParent:(SKNode *)parent WithEmitterMultiplier:(float)emitterMultiplier WithDelayTime:(float)ashDelayTime
{
    SKSpriteNode *parentSprite = (SKSpriteNode *)parent;
    SKTexture *black = [SKTexture sgtextureWithImageNamed:@"cookieBlack"];
    [(SKSpriteNode *)parent setTexture:black];
    
    dispatch_time_t ashTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ashDelayTime * NSEC_PER_SEC));
    dispatch_after(ashTime, dispatch_get_main_queue(), ^(void){
       SKEmitterNode *node = [self emitterCreator:parent Multiplier:emitterMultiplier EmitterName:@"AshParticle"];
       node.position = CGPointMake(0, 15 * (emitterMultiplier /* << (Offset at Base Size)*(Current Size / Base Size) */));
       node.targetNode = self.parent;
       
       //SKTexture *eyes = [SKTexture sgtextureWithImageNamed:@"cookieBlack_half_07"];
       SKTexture *eyes = [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_07"];
       
       SKSpriteNode *eyesNode = [SKSpriteNode spriteNodeWithTexture:eyes];
       eyesNode.position = CGPointMake(0, 0);
       [parent addChild:eyesNode];
       
       NSArray *ashFramesArray = [NSArray arrayWithObjects:[SKTexture sgtextureWithImageNamed:@"cookieDisintigration_01"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_02"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_03"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_04"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_05"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_06"], [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_08"], nil];
       
       
//        SKAction *animatePile = [SKAction animateWithTextures:ashFramesArray timePerFrame:.0714];//.1190f];//0.1429f];
        SKAction *animatePile = [SKAction animateWithTextures:ashFramesArray timePerFrame:.0004 resize:YES restore:NO];//.1190f];//0.1429f];
        
        
       [parent runAction:animatePile completion:^
        {
//            SKAction *eyeFall = [SKAction moveByX:0 y:-1 * (parentSprite.size.height * 0.4) duration:0.15f];
            SKAction *eyeFall = [SKAction moveByX:0 y:-1 * (parentSprite.size.height * 0.4) duration:0.3f];
            eyeFall.timingMode = SKActionTimingEaseIn;
            [eyesNode runAction:eyeFall completion:^
             {
                 [eyesNode removeFromParent];
                // [parent performSelector:@selector(removeFromParent) withObject:nil afterDelay:1];
             }];
        }];
   });
}

- (void)ashAnimationWithCookie:(CDCookieSpriteNode *)cookie
{
//    cookie.particleDeletionType = ParticleDeletionType_MILK;
    
    [cookie setTexture:_black];
    
    SKTexture *eyes = [SKTexture sgtextureWithImageNamed:@"cookieDisintigration_07"];
    
    SKSpriteNode *eyesNode = [SKSpriteNode spriteNodeWithTexture:eyes];
    eyesNode.position = CGPointMake(0, 0);
    [cookie addChild:eyesNode];
    
    SKAction *animatePile = [SKAction animateWithTextures:_ashFramesArray timePerFrame:.0004 resize:YES restore:NO];
    
    
    [cookie runAction:animatePile completion:^
     {
         //            SKAction *eyeFall = [SKAction moveByX:0 y:-1 * (parentSprite.size.height * 0.4) duration:0.15f];
         SKAction *eyeFall = [SKAction moveByX:0 y:-1 * (cookie.size.height * 0.4) duration:0.3f];
         eyeFall.timingMode = SKActionTimingEaseIn;
         [eyesNode runAction:eyeFall completion:^
          {
              [eyesNode removeFromParent];
          }];
     }];
    
    
}


@end


#pragma mark - SKEmitterNode Category

@implementation SKEmitterNode (CDDAdditions)
+ (instancetype)cdd_emiterNodeWithEmitterNamed:(NSString *)emitterFileName
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:emitterFileName ofType:@"sks"]];
}
@end

#pragma mark - SKTexture Category

@implementation SKTexture (CDDAdditions)

+ (SKTexture *)sgtextureWithImageNamed:(NSString *)imageName
{
//    UIImage *image = [UIImage imageNamed:imageName];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    
    return texture;
}

@end