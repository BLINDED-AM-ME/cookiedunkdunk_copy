//
//  GingerDeadMan.m
//  MiniGameTest
//
//  Created by Deathstroke on 11/4/13.
//  Copyright (c) 2013 Rodney Jenkins. All rights reserved.
//

#import "GingerDeadMan.h"

@implementation GingerDeadMan

-(void)setupZombie:(int)type Health:(int)health Speed:(float)speed Size:(CGSize)size AnimationFrames:(NSArray*)frames
{
 
    self.Health = health;
    self.Speed = speed;
    
    float animationSpeed = 0.1;
    
    animationSpeed = animationSpeed/speed;
    SKAction * animation = [SKAction animateWithTextures:frames timePerFrame:animationSpeed resize:YES restore:NO];
    
    self.graphics = [SKSpriteNode spriteNodeWithTexture:[frames objectAtIndex:0] size:size];
    
    [self.graphics runAction:[SKAction repeatActionForever:animation]];
    
    if(type == 2){
        self.graphics.color = [SKColor redColor];
        self.graphics.colorBlendFactor = 0.75f;
    }
    
    [self addChild:self.graphics];
    
    float halfTheTime = ((frames.count * animationSpeed)*0.5f);
    SKAction * movement = [SKAction moveByX:-(size.width * 0.25) y:0.0f duration:halfTheTime];
    SKAction * movementSequence = [SKAction sequence:@[[SKAction waitForDuration:halfTheTime],movement, [SKAction runBlock:^{
    
        if(self.position.x <= self.target)
        {
           [self.theGame GameOver];
            [self.graphics removeAllActions];
            [self removeAllActions];
        }
    }]]];
    
    [self runAction:[SKAction repeatActionForever:movementSequence]];
}
@end