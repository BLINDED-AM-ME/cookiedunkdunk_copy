
#import "CDAbductionUFOObject.h"
#import "CDAbductionScene.h"


@interface CDAbductionUFOObject()

@property (strong, nonatomic) CDAbductionScene *theScene;

@property (assign, nonatomic) int velocityCheckCount;
@property (assign, nonatomic) int maxVelocityCheckCount;

@property (assign, nonatomic) BOOL isMoving;

@property (assign, nonatomic) CGPoint velocity;

@end



@implementation CDAbductionUFOObject

- (id)initForUFOWithScene:(SKScene *)scene
{
//    int randX = arc4random() % (int)scene.frame.size.width;
//    int randY = arc4random() % (int)scene.frame.size.height;
    
    
    CDAbductionUFOObject *UFONode = [CDAbductionUFOObject new];
    UFONode.name = @"ufo";
    UFONode.position = CGPointMake(0, CGRectGetMaxY(_theScene.fieldObject.frame) - _theScene.fieldObject.frame.size.height * .5);
    UFONode.zPosition = 10000;
    
    UFONode.theScene = (CDAbductionScene *)scene;
    
    UFONode.ufo = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"cdd_alienmini_ufo_shadow"]];
    UFONode.ufo.name = @"ufoObject";
    UFONode.ufoSpeedOrigin = 20; // Up for faster | Down for slower
    UFONode.ufoSpeed = UFONode.ufoSpeedOrigin;
    UFONode.willMove = YES;
    UFONode.isDisoriented = NO;
    UFONode.abductionInProgress = NO;
    UFONode.closestCowPoint = 0;
    
    UFONode.ufoMovementPointArray = [NSMutableArray new];
    
    UFONode.abductionBeam = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_ufo_beam"];
    UFONode.abductionBeam.name = @"abductionBeamObject";
    UFONode.abductionBeam.position = CGPointMake(CGRectGetMidX(UFONode.abductionBeam.frame), UFONode.abductionBeam.frame.size.height * .5);
    UFONode.abductionBeam.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(UFONode.abductionBeam.frame.size.width, UFONode.abductionBeam.frame.size.height)];
    UFONode.abductionBeam.physicsBody.dynamic = NO;
    UFONode.abductionBeam.physicsBody.categoryBitMask = abductionBeamCollisionCategory;
    UFONode.abductionBeam.physicsBody.contactTestBitMask = cowCollisionCategory;
    UFONode.abductionBeam.physicsBody.collisionBitMask = abductionDefaultCollissionCategory;
    UFONode.abductionBeam.hidden = YES;
    [UFONode addChild:UFONode.abductionBeam];
    
    UFONode.beamRing = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_ufo_beamrings"];
    UFONode.beamRing.name = @"abductionBeamRingObject";
    UFONode.beamRing.position = CGPointMake(CGRectGetMidX(UFONode.abductionBeam.frame), UFONode.abductionBeam.frame.size.height);//CGPointMake(CGRectGetMidX(UFONode.abductionBeam.frame), CGRectGetMaxY(UFONode.beamRing.frame));
    UFONode.beamRing.hidden = YES;
    [UFONode addChild:UFONode.beamRing];
    
    
    UFONode.ship = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_ufo_ship01"];
    UFONode.ship.name = @"ufoShipObject";
    UFONode.ship.position = CGPointMake(CGRectGetMidX(UFONode.ship.frame), UFONode.abductionBeam.frame.size.height);//(CGRectGetMidX(_abductionBeam.frame), _abductionBeam.frame.size.height);
    
    NSArray *animationArray = [NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"cdd_alienmini_ufo_ship01"], [SKTexture textureWithImageNamed:@"cdd_alienmini_ufo_ship02"], [SKTexture textureWithImageNamed:@"cdd_alienmini_ufo_ship03"], nil];
    [UFONode.ship runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:animationArray timePerFrame:.07 resize:YES restore:NO]]];
    [UFONode addChild:UFONode.ship];
    
    
    UFONode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(UFONode.ufo.frame.size.width * .1, UFONode.ufo.frame.size.height * .1)];
    UFONode.physicsBody.dynamic = YES;
    UFONode.physicsBody.categoryBitMask = UFOCollisionCategory;
    UFONode.physicsBody.contactTestBitMask = cowCollisionCategory;
    UFONode.physicsBody.collisionBitMask = abductionDefaultCollissionCategory;
    UFONode.physicsBody.allowsRotation = NO;
    
    
    UFONode.ship.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:UFONode.ship.frame.size];
    UFONode.ship.physicsBody.dynamic = YES;
    UFONode.ship.physicsBody.categoryBitMask = ufoObjectCollisionCategory;
    UFONode.ship.physicsBody.contactTestBitMask = fartCollisionCategory;
    UFONode.ship.physicsBody.collisionBitMask = abductionDefaultCollissionCategory;
    
    [UFONode addChild:UFONode.ufo];
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Space2" FileType:@"caf" volume:0.3f numberOfLoopes:-1];
    
    return UFONode;
}

- (void)checkDistanceToCow:(CDAbductionCowObject *)cow
{
    float check1 = hypotf(self.position.x - cow.position.x, self.position.y - cow.position.y);
    float check2 = hypotf(self.position.x - _targetedCow.position.x, self.position.y - _targetedCow.position.y);
    
    if (!_targetedCow)
    {
        _targetedCow = cow;
        _closestCowPoint = check1;
    }
    else if (check1 < check2)
    {
        _targetedCow = cow;
        _closestCowPoint = check1;
    }
    
    if (_closestCowPoint < (.5 * _targetedCow.cow.frame.size.width) && !_abductionInProgress)
    {
        DebugLog(@"Abduct the cow anyway");
        [_theScene cowWasAbducted:_targetedCow WithUFO:self];
    }
    else
    {
        CGPoint point = _targetedCow.position; //[_theScene.fieldObject convertPoint:_targetedCow.position fromNode:_theScene];
    //    CGPoint point = [[_targetedCow.moveToPositionArray objectAtIndex:0] CGPointValue];
        [_ufoMovementPointArray removeAllObjects];
        if (![_ufoMovementPointArray containsObject:[NSValue valueWithCGPoint:point]])
        {
            [_ufoMovementPointArray addObject:[NSValue valueWithCGPoint:point]];
        }
    }
}

- (void)createBeam
{
    _abductionBeam.hidden = NO;
    _beamRing.hidden = NO;
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ShootBeam" FileType:@"caf" volume:0.3f];
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"BeamUp" FileType:@"caf" volume:0.3f];
    
    [self animateRing];
}

- (void)animateRing
{
    _beamRing.position = CGPointMake(CGRectGetMidX(_abductionBeam.frame), _abductionBeam.frame.size.height);
    _beamRing.alpha = 1;
    
    [_beamRing runAction:[SKAction fadeAlphaTo:0 duration:.5]];
    [_beamRing runAction:[SKAction moveTo:CGPointMake(CGRectGetMidX(_abductionBeam.frame), _ufo.frame.origin.y) duration:.5] completion:^{
        [self animateRing];
    }];
}

- (void)moveUFO:(NSNumber *)time
{
    CGPoint currentPos = self.position;
    CGPoint newPos;
    
    if (_willMove)
    {
        if ([_ufoMovementPointArray count] > 0)
        {
            CGPoint targetPoint = [[_ufoMovementPointArray firstObject] CGPointValue];
            CGPoint offset = CGPointMake(targetPoint.x - currentPos.x, targetPoint.y - currentPos.y);
            CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
            CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
            
            if (length == 0)
            {
                DebugLog(@"Not a direction");
                return;
            }
            
            _velocity = CGPointMake(direction.x * _ufoSpeed, direction.y * _ufoSpeed);
            
            _isMoving = YES;
            
            newPos = CGPointMake(currentPos.x + _velocity.x * [time doubleValue],
                                 currentPos.y + _velocity.y * [time doubleValue]);
            
            if (CGRectContainsPoint([self calculateAccumulatedFrame], targetPoint))
            {
                [_ufoMovementPointArray removeObjectAtIndex:0];
            }
            
            self.position = newPos;
            
            float distCheck = hypotf(self.position.x - _targetedCow.position.x, self.position.y - _targetedCow.position.y);
            if (distCheck < 20)
            {
            
            }
        }
    }
}

- (void)disorient
{
    if (!_isDisoriented)
    {
        DebugLog(@"disorient");
        _isDisoriented = YES;
        
        [_ufoMovementPointArray removeAllObjects];
        _ufoSpeed = _ufoSpeedOrigin / 2;
        
        [_ship runAction:[SKAction rotateToAngle:M_PI_4 duration:.3] completion:^{
            [_ship runAction:[SKAction rotateToAngle:-M_PI_4 duration:.3] completion:^{
                
                [_ship runAction:[SKAction rotateToAngle:0 duration:.3] completion:^{
                    
                    _isDisoriented = NO;
                    _ufoSpeed = _ufoSpeedOrigin;
                }];
            }];
        }];
        
        if (_targetedCow && _abductionInProgress)
        {
            [_targetedCow cowWasDroppedFromUFO:self];
            
            _abductionBeam.hidden = YES;
            _beamRing.hidden = YES;
            [_beamRing removeAllActions];
            
            [self runAction:[SKAction waitForDuration:2] completion:^{
                
                [self resetUFO];
            }];
        }
    }
}

// This is being used elsewhere! DO NOT DELETE ANYTHING OUT OF HERE!
- (void)resetUFO
{
    _targetedCow = nil;
    _willMove = YES;
    _abductionBeam.hidden = YES;
    _beamRing.hidden = YES;
    
    [_beamRing removeAllActions];
    
    _abductionInProgress = NO;
}

@end
