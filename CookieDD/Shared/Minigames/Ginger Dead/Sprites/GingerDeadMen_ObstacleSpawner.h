//
//  GingerDeadMen_ObstacleSpawner.h
//  CookieDD
//
//  Created by BLINDED AM ME on 8/4/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GingerDeadMenGameScene.h"

@interface GingerDeadMen_ObstacleSpawner : SKNode

@property (strong, nonatomic) GingerDeadMenGameScene* bigdaddy;

@property (strong, nonatomic) NSMutableArray* spawnPoints;

@property (strong, nonatomic) NSArray* objects;
@property (strong, nonatomic) NSArray* colliderPoints;
@property (strong, nonatomic) NSArray* shadows;

-(void)LoadAssets;

-(void)Spawn:(int)difficulty;

-(void)ClearTheArea;

-(void)KillTheGame;

@end
