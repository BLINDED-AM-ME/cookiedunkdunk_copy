//
//  GingerDeadMan.h
//  MiniGameTest
//
//  Created by Deathstroke on 11/4/13.
//  Copyright (c) 2013 Rodney Jenkins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GingerDeadMenGameScene.h"

@interface GingerDeadMan : SKSpriteNode

@property (assign, nonatomic) int Kind_of_Zombie;
@property (assign, nonatomic) float zombieHealth;
@property (assign, nonatomic) float zombieSpeed;

@property (assign, nonatomic) float zombieWidth;

-(void)MoveBitch;

-(void)ZombieDeath;

@end
