//
//  GingerDeadMen_ZombieSpawner.m
//  CookieDD
//
//  Created by BLINDED AM ME on 8/1/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "GingerDeadMen_ZombieSpawner.h"

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t zombieCookieCategory   =  0x1 << 1;
static const uint32_t obstacleCategory   =  0x1 << 2;

@implementation GingerDeadMen_ZombieSpawner

-(void)LoadAssets
{
    
    float baseHeight = _bigdaddy.size.height * 0.2f;
    
    _ZombieSpritesArrays = @[
                             @[
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl001@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl002@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl003@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl004@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl005@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl006@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl007@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl008@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl009@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl010@2x"]
                                 ],
                             @[
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun001@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun002@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun003@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun004@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun005@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun006@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun007@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun008@2x"]
                                 ],
                             @[
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk001@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk002@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk003@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk004@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk005@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk006@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk007@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk008@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk009@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk010@2x"]
                                 ]
                             ];
    
    _ZombieShadowArrays = @[
                             @[
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl001shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl002shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl003shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl004shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl005shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl006shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl007shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl008shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl009shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zcrawl010shadow"]
                                 ],
                             @[
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun001shadow@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun002shadow@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun003shadow@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun004shadow@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun005shadow@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun006shadow@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun007shadow@2x"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zrun008shadow@2x"]
                                 ],
                             @[
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk001shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk002shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk003shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk004shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk005shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk006shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk007shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk008shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk009shadow"],
                                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-char-zwalk010shadow"]
                                 ]
                             ];
    
    _aHundredDamnedSouls = [NSMutableArray new];
    
    for(int i=0; i<20; i++){
        
        GingerDeadMan* zombie = [GingerDeadMan spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(baseHeight, baseHeight)];
        
        SKPhysicsBody* physicBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(baseHeight, baseHeight)];
        physicBody.dynamic = YES;
        physicBody.categoryBitMask = zombieCookieCategory;
        physicBody.contactTestBitMask = projectileCategory;
        physicBody.collisionBitMask = 0;
        
        zombie.physicsBody = physicBody;
        
        [_aHundredDamnedSouls addObject:zombie];
    }
    
    _aHundredGallonsOfLifeJuice = [NSMutableArray new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Zombie_blood" ofType:@"sks"];
    for(int i=0; i<100; i++){
        SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        emitter.particleSize = CGSizeMake(baseHeight, baseHeight);
        emitter.particleZPosition = 20;
        
        [_aHundredGallonsOfLifeJuice addObject:emitter];
    }
}

-(void)UpdateMethod
{
    
    NSArray* myChildren = self.children;
    
    for(int i=0; i<myChildren.count; i++)
    {
        GingerDeadMan* walker = myChildren[i];
        
        if(walker.position.x <= -_bigdaddy.size.width)
        {
            if(!_bigdaddy.isGameOver)
                [_bigdaddy GameOver];
        }
    }
    
}

-(void)SetupZombieSpawner_Difficulty:(int)difficulty
{
 
    if(difficulty == 0){ // undefined
        
        
    }else if (difficulty == 1) {  //easy
        
        _spawnrate = 1.0f;
        
        _walkerChance = 60;
        _runnerChance = 35;
        _crawlerChance = 5;
        
        _numberOfLanes = 3;
        
    }else if(difficulty == 2){ // medium
        
        _spawnrate = 0.75f;
        
        _walkerChance = 45;
        _runnerChance = 50;
        _crawlerChance = 5;
        
        _numberOfLanes = 4;
        
    }else if(difficulty == 3){ // hard
        
        _spawnrate = 0.5f;
        
        _walkerChance = 30;
        _runnerChance = 60;
        _crawlerChance = 10;
        
        _numberOfLanes = 4;
        
    }else if(difficulty == 4){ // crazy
        
        _spawnrate = 0.5f;
        
        _walkerChance = 20;
        _runnerChance = 60;
        _crawlerChance = 20;
        
        _numberOfLanes = 5;
        
        
    }
    
    
    _zombieSpawnPoints = [NSMutableArray new];
    
    float baseHeight = _bigdaddy.size.height * 0.2f;
    
    float vertSpawnBounds = _bigdaddy.size.height - baseHeight;
    
    for(int i=0; i<_numberOfLanes; i++){
        
        CGPoint point = CGPointMake(0, 0);
        point.y = (i*(vertSpawnBounds/_numberOfLanes)) + (0.5f * baseHeight);
        
        NSValue * spawnPoint = [NSValue valueWithCGPoint:point];
        [_zombieSpawnPoints addObject:spawnPoint];
        
    }

    
}

-(void)StartSpawningTheArmyOfTheDamned
{
    [self runAction:[SKAction waitForDuration:_spawnrate] completion:^{
    
        if(_bigdaddy.isGameOver)
            return;
        
        [self SpawnZombie];
        
        [self StartSpawningTheArmyOfTheDamned];
    }];
}

-(void)SpawnZombie
{
    
    int what_type_of_Zombie = arc4random() % (_walkerChance + _runnerChance + _walkerChance);
    
    if(what_type_of_Zombie < _walkerChance){
        what_type_of_Zombie = 0;
    }else if(what_type_of_Zombie < _walkerChance + _runnerChance){
        what_type_of_Zombie = 1;
    }else{
        what_type_of_Zombie = 2;
    }
    
    
    GingerDeadMan* Zombie = _aHundredDamnedSouls[_aHundredDamnedSoulsIndex];
    Zombie.xScale = 1.0f;
    Zombie.yScale = 1.0f;
    
    _aHundredDamnedSoulsIndex++;
    if(_aHundredDamnedSoulsIndex >= _aHundredDamnedSouls.count)
        _aHundredDamnedSoulsIndex = 0;
    
    [Zombie removeAllActions];
    
    SKSpriteNode* Shadow = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:Zombie.size];
    
    if(what_type_of_Zombie == 0){ // walker
        Zombie.zombieHealth = 100.0f;
        Zombie.zombieSpeed = 1;
        
        Zombie.xScale = 1.1595f;
        
        Zombie.zombieWidth = Zombie.size.width * 1.1595f;
        
        [Zombie runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_ZombieSpritesArrays[2] timePerFrame:0.08f]]];
        [Shadow runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_ZombieShadowArrays[2] timePerFrame:0.08f]]];
    }
    else if(what_type_of_Zombie == 1){ // runner
        Zombie.zombieHealth = 200.0f;
        Zombie.zombieSpeed = 1;
        
        Zombie.yScale = 0.9681f;
        Zombie.xScale = 0.9681f * 0.9791f;
        
        Zombie.zombieWidth = Zombie.size.width * 0.9681f * 0.9791f;
        
        [Zombie runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_ZombieSpritesArrays[1] timePerFrame:0.08f]]];
        [Shadow runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_ZombieShadowArrays[1] timePerFrame:0.08f]]];
    }
    else if(what_type_of_Zombie == 2){ // crawler
        Zombie.zombieHealth = 500.0f;
        Zombie.zombieSpeed = 1;
        
        Zombie.yScale = 0.6330f;
        Zombie.xScale = 0.6330f * 1.6807f;
        
        Zombie.zombieWidth = Zombie.size.width * 1.1596f;
        
        [Zombie runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_ZombieSpritesArrays[0] timePerFrame:0.08f]]];
        [Shadow runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_ZombieShadowArrays[0] timePerFrame:0.08f]]];
    }
    
    [self addChild:Zombie];
    
    int lane = arc4random() % _numberOfLanes;
    
    Zombie.position = [_zombieSpawnPoints[lane] CGPointValue];
    Zombie.zPosition = (_numberOfLanes - lane) * 2;
    Zombie.zPosition -= 1;
    
    Shadow.zPosition = -Zombie.zPosition;
    [Zombie addChild:Shadow];
    
    Zombie.Kind_of_Zombie = what_type_of_Zombie;
    
    [Zombie MoveBitch];
    
}

-(void)Carpetbomb
{
    NSArray* myChildren = self.children;
    
    for(GingerDeadMan* walker in myChildren){
    
        [self ZombieHurt:walker];
        [walker ZombieDeath];
    }

    
}

-(void)ZombieHurt:(GingerDeadMan*)zombie
{
    
    SKEmitterNode* copy_cat = _aHundredGallonsOfLifeJuice[_aHundredGallonsOfLifeJuiceIndex];
    
    _aHundredGallonsOfLifeJuiceIndex++;
    if(_aHundredGallonsOfLifeJuiceIndex >= _aHundredGallonsOfLifeJuice.count)
        _aHundredGallonsOfLifeJuiceIndex = 0;
    
    copy_cat.position = [_bigdaddy convertPoint:zombie.position fromNode:self];
    copy_cat.numParticlesToEmit = 10;
    
    [_bigdaddy addChild:copy_cat];
    [copy_cat advanceSimulationTime:0.0f];
    [copy_cat resetSimulation];
    
    SKAction* remove = [SKAction sequence:@[[SKAction waitForDuration:2],[SKAction removeFromParent]]];
    
    [copy_cat runAction:remove];
    
}

-(void)KillTheGame{
    
    [self removeAllActions];
    [self removeAllChildren];
    
    _bigdaddy = nil;
    _aHundredDamnedSouls = nil;
    _aHundredGallonsOfLifeJuice = nil;
    _zombieSpawnPoints = nil;
    _ZombieSpritesArrays = nil;
}

@end
