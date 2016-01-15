//
//  GingerDeadMan.m
//  MiniGameTest
//
//  Created by Deathstroke on 11/4/13.
//  Copyright (c) 2013 Rodney Jenkins. All rights reserved.
//

#import "GingerDeadMan.h"

@implementation GingerDeadMan


-(void)MoveBitch{
    
    
    if(_Kind_of_Zombie == 0){ // walker
        
        [self runAction:
         [SKAction repeatActionForever:
                               [SKAction moveByX:-_zombieWidth*0.5f y:0 duration:1.0f/_zombieSpeed]]];
        
    }else if(_Kind_of_Zombie == 1){ // runner
        
        [self runAction:
         [SKAction repeatActionForever:
                               [SKAction moveByX:-_zombieWidth*2.0f y:0 duration:1.0f/_zombieSpeed]]];
        
    }else if(_Kind_of_Zombie == 2){ // crawler
        
        [self runAction:
         [SKAction repeatActionForever:
          [SKAction sequence:@[
                               [SKAction waitForDuration:0.4f/_zombieSpeed],
                               [SKAction moveByX:-_zombieWidth*0.5f y:0 duration:0.24f/_zombieSpeed],
                               [SKAction waitForDuration:0.16f/_zombieSpeed]
                               ]]]];
    }
    
}

-(void)ZombieDeath{
    
    [self removeAllActions];
    [self removeFromParent];
    
}

@end