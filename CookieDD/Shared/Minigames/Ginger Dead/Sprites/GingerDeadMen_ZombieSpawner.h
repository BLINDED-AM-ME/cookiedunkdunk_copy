//
//  GingerDeadMen_ZombieSpawner.h
//  CookieDD
//
//  Created by BLINDED AM ME on 8/1/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GingerDeadMenGameScene.h"
#import "GingerDeadMan.h"

@interface GingerDeadMen_ZombieSpawner : SKNode

@property (strong, nonatomic) GingerDeadMenGameScene* bigdaddy;


@property (assign, nonatomic) float spawnrate;

@property (assign, nonatomic) int numberOfLanes;
@property (assign, nonatomic) int walkerChance;
@property (assign, nonatomic) int runnerChance;
@property (assign, nonatomic) int crawlerChance;

@property (strong, nonatomic) NSMutableArray* zombieSpawnPoints;

// minion stuff
@property (strong, nonatomic) NSMutableArray* aHundredDamnedSouls;
@property (assign, nonatomic) int aHundredDamnedSoulsIndex;
@property (strong, nonatomic) NSMutableArray* aHundredGallonsOfLifeJuice;
@property (assign, nonatomic) int aHundredGallonsOfLifeJuiceIndex;

@property (strong, nonatomic) NSArray * ZombieSpritesArrays;
@property (strong, nonatomic) NSArray * ZombieShadowArrays;

-(void)LoadAssets;

-(void)UpdateMethod;

-(void)SetupZombieSpawner_Difficulty:(int)difficulty;

-(void)StartSpawningTheArmyOfTheDamned;

-(void)Carpetbomb;

-(void)ZombieHurt:(GingerDeadMan*)zombie;

-(void)KillTheGame;

@end
