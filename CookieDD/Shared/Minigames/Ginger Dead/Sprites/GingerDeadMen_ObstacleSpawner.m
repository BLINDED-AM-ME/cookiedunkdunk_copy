//
//  GingerDeadMen_ObstacleSpawner.m
//  CookieDD
//
//  Created by BLINDED AM ME on 8/4/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "GingerDeadMen_ObstacleSpawner.h"

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t zombieCookieCategory   =  0x1 << 1;
static const uint32_t obstacleCategory   =  0x1 << 2;

@implementation GingerDeadMen_ObstacleSpawner

-(void)LoadAssets
{
    _objects = @[
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker01@2x"],
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker02@2x"],
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker03@2x"],
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker04@2x"],
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker05@2x"]
                 ];
    
    _shadows = @[
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker01shadow@2x"],
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker02shadow@2x"],
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker03shadow@2x"],
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker04shadow@2x"],
                 [SKTexture textureWithImageNamed:@"cdd-zombiemini-blocker05shadow@2x"]
                 ];
    
    _colliderPoints = @[
                        @[
                            [NSValue valueWithCGPoint:CGPointMake(0.5545f, 0.336f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.5545f, 0.692f)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(0.7062f, 0.692f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.7062f, 0.336f)]
                            ],
                        @[
                            [NSValue valueWithCGPoint:CGPointMake(0.5239f, 0.3025f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.5239f, 0.6849f)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(0.665f, 0.6849f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.665f, 0.3025f)]
                            ],
                        @[
                            [NSValue valueWithCGPoint:CGPointMake(0.5418f, 0.2925f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.5418f, 0.7517f)],

                            [NSValue valueWithCGPoint:CGPointMake(0.7093f, 0.7517f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.7093f, 0.2925f)]
                            ],
                        @[
                            [NSValue valueWithCGPoint:CGPointMake(0.0746f, 0.3484f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.0746f, 0.4323f)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(0.8433f, 1.0f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.8433f, 0.3484f)]
                            ],
                        @[
                            [NSValue valueWithCGPoint:CGPointMake(0.225f, 0.4074f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.225f, 0.76f)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(0.55f, 1.0f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.75f, 1.0f)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(1.0f, 0.76f)],
                            [NSValue valueWithCGPoint:CGPointMake(0.75f, 0.4074f)]
                            ]
                        ];
    
}

-(void)Spawn:(int)difficulty
{
    
    int number = 0;
    
    if(difficulty == 0)// undefined
    {
        
    }else if(difficulty == 1){ // easy
        number = 0;
    }else if (difficulty == 2){ // medium
        number = 1;
    }else if (difficulty == 3){ // hard
        number = 2;
    }else if (difficulty == 4){ // crazy
        number = 3;
    }
    
    float maxHeight = _bigdaddy.size.height * 0.75f;
    
    for (int i=0; i<number; i++) {
        
        int which_obj = arc4random() % _objects.count;
        
        SKTexture* obstacleTexture = _objects[which_obj];
        
        float baseHeight = obstacleTexture.size.height/588.0f * maxHeight;
        
        CGSize obstacleSize = CGSizeMake((obstacleTexture.size.width/obstacleTexture.size.height) * baseHeight,
                                         baseHeight);
        
        SKSpriteNode* obstacle = [SKSpriteNode spriteNodeWithTexture:_objects[which_obj] size:obstacleSize];
        SKSpriteNode* shadow = [SKSpriteNode spriteNodeWithTexture:_shadows[which_obj] size:obstacleSize];
        
        
        CGFloat offsetX = obstacle.size.width * 0.5f;
        CGFloat offsetY = obstacle.size.height * 0.5f;
        
        NSArray* points = _colliderPoints[which_obj];
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL,
                          ([points[0] CGPointValue].x * obstacleSize.width) - offsetX,
                          ([points[0] CGPointValue].y * obstacleSize.height) - offsetY);
        
        for (int i=1; i<points.count; i++) {
         
            CGPoint point = [points[i] CGPointValue];
            CGPathAddLineToPoint(path, NULL,
                                (point.x * obstacleSize.width) - offsetX,
                                (point.y * obstacleSize.height) - offsetY);
            
        }
    
        SKPhysicsBody* physicBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        CGPathCloseSubpath(path);
        
        physicBody.dynamic = NO;
        physicBody.categoryBitMask = obstacleCategory;
        physicBody.contactTestBitMask = projectileCategory;
        physicBody.collisionBitMask = 0;

        obstacle.physicsBody = physicBody;
        
        
        int lane = arc4random() % _spawnPoints.count;
        
        obstacle.zPosition = (_spawnPoints.count - lane) * 2;
        
        int xRange = _bigdaddy.size.width * 0.35f;
        float xPoint = arc4random() % xRange;
        
        switch (which_obj) {
            case 0: obstacle.position = CGPointMake(-xPoint, [_spawnPoints[lane] CGPointValue].y);
                break;
                
            case 1: obstacle.position = CGPointMake(-xPoint, [_spawnPoints[lane] CGPointValue].y);
                break;
                
            case 2: obstacle.position = CGPointMake(-xPoint, [_spawnPoints[lane] CGPointValue].y);
                break;
        
            case 3: obstacle.position = CGPointMake(-xPoint, [_spawnPoints[lane] CGPointValue].y - (obstacleSize.height * 0.25f));
                break;
                
            case 4: obstacle.position = CGPointMake(-xPoint, [_spawnPoints[lane] CGPointValue].y - (obstacleSize.height * 1.1f));
                break;
                
            default:
                obstacle.position = CGPointMake(-xPoint, [_spawnPoints[lane] CGPointValue].y);
                break;
        }
        
        shadow.position = obstacle.position;
        
        [self addChild:obstacle];
        [self addChild:shadow];
    
    }
    
}
-(void)ClearTheArea{
    
    [self removeAllChildren];
    
}

-(void)KillTheGame{
    
    [self removeAllActions];
    [self removeAllChildren];
    
    _bigdaddy = nil;
    _spawnPoints = nil;
    _objects = nil;
    _shadows = nil;
}

@end
