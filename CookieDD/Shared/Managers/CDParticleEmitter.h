//
//  CDParticleEmitter.h
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

#import <SpriteKit/SpriteKit.h>



@interface CDParticleEmitter : SKNode

+ (CDParticleEmitter *)particleEmitter;

- (SKEmitterNode *)emitter:(SKNode *)parent Position:(CGPoint)position EmitterName:(NSString *)name EmitterMultiplier:(float)emitterMultiplier DeletionTime:(float)deletionTime;


- (void)emitNode:(SKEmitterNode *)emitterNode
   emitterParent:(SKNode *)parent
        Position:(CGPoint)position
emitterMultiplier:(float)emitterMultiplier
    deletionTime:(float)deletionTime
 isFirstParticle:(BOOL)isFirstParticle;

// We need to pass in the cookie type
- (void)burnAnimation:(SKNode *)parent TargetNode:(SKNode *)targetNode Position:(CGPoint)position ObjectSize:(CGSize)size DeletionTime:(float)deletionTime WithSmokeConstant:(BOOL)smokeConstant WithFireEffect:(BOOL)fireEffect WithAshesEffect:(BOOL)ashEffect CookieType:(NSString *)cookieType DelayForFire:(float)fireDelayTime DelayForAsh:(float)ashDelayTime;

- (void)createAshAnimationWithParent:(SKNode *)parent WithEmitterMultiplier:(float)emitterMultiplier WithDelayTime:(float)ashDelayTime;

@end


@interface SKEmitterNode (CDDAdditions)
+ (instancetype)cdd_emiterNodeWithEmitterNamed:(NSString *)emitterFileName;
@end

@interface SKTexture (CDDAdditions)
+ (SKTexture *)sgtextureWithImageNamed:(NSString *)imageName;
@end