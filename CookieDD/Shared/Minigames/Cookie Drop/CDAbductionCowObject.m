
#import "CDAbductionCowObject.h"
#import "CDAbductionScene.h"


@interface CDAbductionCowObject()

@property (strong, nonatomic) CDAbductionScene *theScene;

@property (strong, nonatomic) SKSpriteNode *shadowObject;
@property (strong, nonatomic) SKSpriteNode *fartBubbleObject;

@property (assign, nonatomic) int moveTextureCount;
@property (assign, nonatomic) int textureNumber;
@property (assign, nonatomic) int velocityCheckCount;
@property (assign, nonatomic) int maxVelocityCheckCount;
@property (assign, nonatomic) int cowSpeed;
@property (assign, nonatomic) int soundDelayCount;
@property (assign, nonatomic) int soundDelayCountMax;

@property (assign, nonatomic) float dotProductUpRight;
@property (assign, nonatomic) float dotProductUpLeft;
@property (assign, nonatomic) float dotProductDownRight;
@property (assign, nonatomic) float dotProductDownLeft;

@property (assign, nonatomic) BOOL willPlayWalkSound1;
@property (assign, nonatomic) BOOL willPlaySound;

@property (strong, nonatomic) NSArray *rightArray;
@property (strong, nonatomic) NSArray *leftArray;
@property (strong, nonatomic) NSArray *forwardLeftArray;
@property (strong, nonatomic) NSArray *forwardRightArray;
@property (strong, nonatomic) NSArray *backLeftArray;
@property (strong, nonatomic) NSArray *backRightArray;

@property (strong, nonatomic) NSArray *rightShadowArray;
@property (strong, nonatomic) NSArray *leftShadowArray;
@property (strong, nonatomic) NSArray *forwardLeftShadowArray;
@property (strong, nonatomic) NSArray *forwardRightShadowArray;
@property (strong, nonatomic) NSArray *backLeftShadowArray;
@property (strong, nonatomic) NSArray *backRightShadowArray;

@property (strong, nonatomic) NSArray *fartArray;

@property (strong, nonatomic) NSArray *abductionArray;

@property (assign, nonatomic) CGPoint velocity;
@property (assign, nonatomic) CGPoint direction;

@end



@implementation CDAbductionCowObject

- (id)initWithCowNumber:(int)cowNumber withScene:(SKScene *)scene
{
    CDAbductionCowObject *cowNode = [CDAbductionCowObject new];
    
    cowNode.name = @"cowObject";//[NSString stringWithFormat:@"cow%i", cowNumber];
    
    cowNode.theScene = (CDAbductionScene *)scene;
    
    cowNode.textureNumber = 0; //arc4random() % 4;
    cowNode.moveTextureCount = 0;
    cowNode.velocityCheckCount = 0;
    cowNode.maxVelocityCheckCount = 3;
    cowNode.cowSpeed = 80;
    cowNode.fartCounterMax = 30;
    cowNode.fartCounter = cowNode.fartCounterMax;
    cowNode.soundDelayCountMax = 2;
    cowNode.soundDelayCount = cowNode.soundDelayCountMax;
    
//    cowNode.cycleArrayMax = 5;
//    cowNode.cycleArray = cowNode.cycleArrayMax;
    
    cowNode.dotProductUpRight = 60;
    cowNode.dotProductUpLeft = 60;
    cowNode.dotProductDownRight = 60;
    cowNode.dotProductDownLeft = 60;
    
    cowNode.moveToPositionArray = [NSMutableArray new];
    cowNode.followingCowsArray = [NSMutableArray new];
    
    cowNode.allowMovement = YES;
    cowNode.isMoving = NO;
    cowNode.stampeding = NO;
    cowNode.isTouchedDown = NO;
    cowNode.startFartTimer = NO;
    cowNode.runFartAnimation = NO;
    cowNode.allowFart = YES;
    cowNode.willPlayWalkSound1 = YES;
    cowNode.willPlaySound = YES;
    
    cowNode.cowToFollow = nil;
    
    cowNode.directionTextureAppendage = Abduction_Direction_Left;
    
    // Set directional texture arrays
    cowNode.forwardLeftArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowS001", @"cdd_alienmini_cowS002", @"cdd_alienmini_cowS003", @"cdd_alienmini_cowS004", @"cdd_alienmini_cowS005", @"cdd_alienmini_cowS006", @"cdd_alienmini_cowS007", nil];
    cowNode.forwardRightArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowS001", @"cdd_alienmini_cowS002", @"cdd_alienmini_cowS003", @"cdd_alienmini_cowS004", @"cdd_alienmini_cowS005", @"cdd_alienmini_cowS006", @"cdd_alienmini_cowS007", nil];
    
    cowNode.backLeftArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowN001", @"cdd_alienmini_cowN002", @"cdd_alienmini_cowN003", @"cdd_alienmini_cowN004", @"cdd_alienmini_cowN005", @"cdd_alienmini_cowN006", @"cdd_alienmini_cowN007", nil];
    cowNode.backRightArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowN001", @"cdd_alienmini_cowN002", @"cdd_alienmini_cowN003", @"cdd_alienmini_cowN004", @"cdd_alienmini_cowN005", @"cdd_alienmini_cowN006", @"cdd_alienmini_cowN007", nil];
    
    cowNode.rightArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowEW001", @"cdd_alienmini_cowEW002", @"cdd_alienmini_cowEW003", @"cdd_alienmini_cowEW004", @"cdd_alienmini_cowEW005", @"cdd_alienmini_cowEW006", @"cdd_alienmini_cowEW007", nil];
    cowNode.leftArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowEW001", @"cdd_alienmini_cowEW002", @"cdd_alienmini_cowEW003", @"cdd_alienmini_cowEW004", @"cdd_alienmini_cowEW005", @"cdd_alienmini_cowEW006", @"cdd_alienmini_cowEW007", nil];
    
    // Set shadow texture arrays
    cowNode.forwardLeftShadowArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowSshad001", @"cdd_alienmini_cowSshad002", @"cdd_alienmini_cowSshad003", @"cdd_alienmini_cowSshad004", @"cdd_alienmini_cowSshad005", @"cdd_alienmini_cowSshad006", @"cdd_alienmini_cowSshad007", nil];
    cowNode.forwardRightShadowArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowNshad001", @"cdd_alienmini_cowNshad002", @"cdd_alienmini_cowNshad003", @"cdd_alienmini_cowNshad004", @"cdd_alienmini_cowNshad005", @"cdd_alienmini_cowNshad006", @"cdd_alienmini_cowNshad007", nil];
    
    cowNode.backLeftShadowArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowNshad001", @"cdd_alienmini_cowNshad002", @"cdd_alienmini_cowNshad003", @"cdd_alienmini_cowNshad004", @"cdd_alienmini_cowNshad005", @"cdd_alienmini_cowNshad006", @"cdd_alienmini_cowNshad007", nil];
    cowNode.backRightShadowArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowSshad001", @"cdd_alienmini_cowSshad002", @"cdd_alienmini_cowSshad003", @"cdd_alienmini_cowSshad004", @"cdd_alienmini_cowSshad005", @"cdd_alienmini_cowSshad006", @"cdd_alienmini_cowSshad007", nil];
    
    
    cowNode.rightShadowArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowEWshad001", @"cdd_alienmini_cowEWshad002", @"cdd_alienmini_cowEWshad003", @"cdd_alienmini_cowEWshad004", @"cdd_alienmini_cowEWshad005", @"cdd_alienmini_cowEWshad006", @"cdd_alienmini_cowEWshad007", nil];
    cowNode.leftShadowArray = [[NSArray alloc] initWithObjects:@"cdd_alienmini_cowEWshad001", @"cdd_alienmini_cowEWshad002", @"cdd_alienmini_cowEWshad003", @"cdd_alienmini_cowEWshad004", @"cdd_alienmini_cowEWshad005", @"cdd_alienmini_cowEWshad006", @"cdd_alienmini_cowEWshad007", nil];
    
    // Abduction Array
    cowNode.abductionArray = [[NSArray alloc] initWithObjects:[SKTexture textureWithImageNamed:@"cdd_alienmini_cowABD001"], [SKTexture textureWithImageNamed:@"cdd_alienmini_cowABD002"], [SKTexture textureWithImageNamed:@"cdd_alienmini_cowABD003"], [SKTexture textureWithImageNamed:@"cdd_alienmini_cowABD002"], nil];
    
    // Fart Array
    cowNode.fartArray = [[NSArray alloc] initWithObjects:[SKTexture textureWithImageNamed:@"cdd_alienmini_cowEWFart001"], [SKTexture textureWithImageNamed:@"cdd_alienmini_cowEWFart002"], nil];
    
    cowNode.shadowObject = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"cdd_alienmini_cowEWshad001"]];
    cowNode.shadowObject.name = @"shadowObject";
//    cowNode.shadowObject.zPosition = 500;
    cowNode.shadowObject.position = CGPointMake(0, 0);
    [cowNode addChild:cowNode.shadowObject];
    
    cowNode.cow = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"cdd_alienmini_cowEW001"]];
    cowNode.cow.name = @"theCow";
//    cowNode.cow.zPosition = 500;
    cowNode.cow.position = CGPointMake(0, 0);
    [cowNode addChild:cowNode.cow];
    
    cowNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(cowNode.cow.frame.size.width * .5, cowNode.cow.frame.size.height * .5)];
    cowNode.physicsBody.dynamic = YES;
    cowNode.physicsBody.categoryBitMask = cowCollisionCategory;
    cowNode.physicsBody.contactTestBitMask = abductionBeamCollisionCategory | cowCollisionCategory | blockerCollisionCategory;
    cowNode.physicsBody.collisionBitMask = abductionDefaultCollissionCategory | blockerCollisionCategory;
    cowNode.physicsBody.allowsRotation = NO;
    
//    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:1 alpha:1] size:CGSizeMake(cowNode.cow.frame.size.width * .5, cowNode.cow.frame.size.height * .5)];
//    sprite.position = CGPointMake(0, 0);
//    [cowNode addChild:sprite];
    
    int randX = arc4random() % (int)cowNode.theScene.fieldObject.frame.size.width;
    int randY = arc4random() % (int)cowNode.theScene.fieldObject.frame.size.height;
    
    if (randX - cowNode.cow.frame.size.width < CGRectGetMinX(cowNode.theScene.fieldObject.frame))
    {
        randX += cowNode.cow.frame.size.width;
    }
    else if (randX + cowNode.cow.frame.size.width > CGRectGetWidth(cowNode.theScene.fieldObject.frame))
    {
        randX -= cowNode.cow.frame.size.width;
    }
    randX -= cowNode.theScene.fieldObject.frame.size.width * .5;
    
    if (randY - cowNode.cow.frame.size.height < CGRectGetMinY(cowNode.theScene.fieldObject.frame))
    {
        randY += cowNode.cow.frame.size.height;
    }
    else if (randY + cowNode.cow.frame.size.height > CGRectGetHeight(cowNode.theScene.fieldObject.frame))
    {
        randY -= cowNode.cow.frame.size.height;
    }
    randY -= cowNode.theScene.fieldObject.frame.size.height * .5;
    
    cowNode.position = CGPointMake((CGFloat)randX, (CGFloat)randY);
    cowNode.zPosition = -1 * cowNode.position.y;
    
    return cowNode;
}

- (void)wasSelectedWithPoint:(CGPoint)point
{
//    DebugLog(@"Cow was selected");
    _isTouchedDown = YES;
    
    [_moveToPositionArray removeAllObjects];
    [_moveToPositionArray addObject:[NSValue valueWithCGPoint:point]];
}

- (void)wasUnselected
{
//    DebugLog(@"Cow has stopped!!!!");
    _isMoving = NO;
    
    [_moveToPositionArray removeAllObjects];
    [_followingCowsArray removeAllObjects];
}

- (void)moveCow:(NSNumber *)time
{
    CGPoint currentPos = self.position;
    CGPoint newPos;
    
//    if (_startFartTimer)
//    {
//        if (_fartCounter != 0)
//        {
//            _fartCounter--;
//        }
//        else
//        {
//            DebugLog(@"Fart");
//            _startFartTimer = NO;
//            _fartCounter = _fartCounterMax;
//            [_cow runAction:[SKAction animateWithTextures:_fartArray timePerFrame:0.3]];
//        }
//    }
    
    if (_runFartAnimation)
    {
        _startFartTimer = NO;
        _runFartAnimation = NO;
        [_cow runAction:[SKAction animateWithTextures:_fartArray timePerFrame:0.15]];
        
        [self createFart];
    }
    
    if ([_moveToPositionArray count] > 0)
    {
        CGPoint targetPoint = [[_moveToPositionArray firstObject] CGPointValue];
        CGPoint offset = CGPointMake(targetPoint.x - currentPos.x, targetPoint.y - currentPos.y);
        CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
        
        _direction = CGPointMake(offset.x / length, offset.y / length);
        _velocity = CGPointMake(_direction.x * _cowSpeed, _direction.y * _cowSpeed);
        
        _isMoving = YES;
        
        newPos = CGPointMake(currentPos.x + _velocity.x * [time doubleValue],
                                  currentPos.y + _velocity.y * [time doubleValue]);
        
        if (CGRectContainsPoint([self calculateAccumulatedFrame], targetPoint))
        {
            [_moveToPositionArray removeObjectAtIndex:0];
            
            if ([_moveToPositionArray count] == 0)
            {
                if (!_isTouchedDown)
                {
                    _isMoving = NO;
                
                    [self wasUnselected];
                }
            }
        }
        
        [self useVelocityForDirection:newPos];
        self.position = newPos;
        self.zPosition = -1 * self.position.y;
    }
    else
    {
        [self resetImage];
    }
    
//    self.zRotation = atan2f(_velocity.y, _velocity.x) + M_PI_2;
}

- (void)createFart
{
//    SKTexture *tempTexture = [SKTexture textureWithImageNamed:@"cdd_alienmini_particle_fart"];
    SKSpriteNode *fartBubble = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_particle_fart"];//[SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:tempTexture.size];
    fartBubble.name = @"fartBubbleObject";
    [fartBubble setScale:.5];
    fartBubble.zPosition = 15000;
    
    CGPoint moveToPoint;
    if ([_directionTextureAppendage isEqualToString:Abduction_Direction_Right])
    {
        DebugLog(@"Right");
        fartBubble.position = [self convertPoint:CGPointMake(_cow.frame.size.width * -.5, 0) toNode:_theScene];
        moveToPoint = CGPointMake(fartBubble.position.x - (fartBubble.frame.size.width * 2), fartBubble.position.y + (fartBubble.frame.size.height * 2));
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_FrontRight])
    {
        DebugLog(@"Front Right");
        fartBubble.position = [self convertPoint:CGPointMake(_cow.frame.size.width * -.5, 0) toNode:_theScene];
        moveToPoint = CGPointMake(fartBubble.position.x - (fartBubble.frame.size.width * 2), fartBubble.position.y + (fartBubble.frame.size.height * 2));
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_BackRight])
    {
        DebugLog(@"Back Right");
        fartBubble.position = [self convertPoint:CGPointMake(_cow.frame.size.width * -.5, 0) toNode:_theScene];
        moveToPoint = CGPointMake(fartBubble.position.x - (fartBubble.frame.size.width * 2), fartBubble.position.y + (fartBubble.frame.size.height * 2));
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_Left])
    {
        DebugLog(@"Left");
        fartBubble.position = [self convertPoint:CGPointMake(_cow.frame.size.width * .5, 0) toNode:_theScene];
        moveToPoint = CGPointMake(fartBubble.position.x + (fartBubble.frame.size.width * 2), fartBubble.position.y + (fartBubble.frame.size.height * 2));
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_FrontLeft])
    {
        DebugLog(@"Front Left");
        fartBubble.position = [self convertPoint:CGPointMake(_cow.frame.size.width * .5, 0) toNode:_theScene];
        moveToPoint = CGPointMake(fartBubble.position.x + (fartBubble.frame.size.width * 2), fartBubble.position.y + (fartBubble.frame.size.height * 2));
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_BackLeft])
    {
        DebugLog(@"Back Left");
        fartBubble.position = [self convertPoint:CGPointMake(_cow.frame.size.width * .5, 0) toNode:_theScene];
        moveToPoint = CGPointMake(fartBubble.position.x + (fartBubble.frame.size.width * 2), fartBubble.position.y + (fartBubble.frame.size.height * 2));
    }
    else
    {
        moveToPoint = CGPointMake(0, 0);
    }
    
    
    int randNum = arc4random() % 3;
    if (randNum == 1)
    {
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Fart1" FileType:@"caf" volume:0.3f];
    }
    else if (randNum == 2)
    {
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Fart2" FileType:@"caf" volume:0.3f];
    }
    else
    {
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Fart3" FileType:@"m4a" volume:0.3f];
    }
    
    fartBubble.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:fartBubble.frame.size.height * .5];
    fartBubble.physicsBody.categoryBitMask = fartCollisionCategory;
    fartBubble.physicsBody.contactTestBitMask = ufoObjectCollisionCategory;
    fartBubble.physicsBody.collisionBitMask = abductionDefaultCollissionCategory;
    
    _allowFart = NO;
    [_theScene addChild:fartBubble];
    
    [fartBubble runAction:[SKAction moveTo:moveToPoint duration:.3]];
    [fartBubble runAction:[SKAction fadeAlphaTo:.7 duration:.3]];
    
    [fartBubble runAction:[SKAction runBlock:^{
        
        fartBubble.zRotation = atan2f(5, 5) + M_PI_2;
    }]];
    
    [fartBubble runAction:[SKAction scaleTo:2 duration:.3] completion:^{
        [fartBubble runAction:[SKAction waitForDuration:.3] completion:^{
            
            [fartBubble removeFromParent];
            
            [self runAction:[SKAction waitForDuration:2] completion:^{
                _allowFart = YES;
            }];
        }];
    }];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"fartBubbleParticle" ofType:@"sks"];
//    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//    emitter.position = [_theScene convertPoint:moveToPoint fromNode:self];
//    [_theScene addChild:emitter];

}

- (void)resetImage
{
    _moveTextureCount = 0;
    _soundDelayCount = _soundDelayCountMax;
    
    if ([_directionTextureAppendage isEqualToString:Abduction_Direction_Right])
    {
        [_cow setTexture:[SKTexture textureWithImageNamed:[_rightArray objectAtIndex:0]]];
        [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_rightShadowArray objectAtIndex:0]]];
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_Left])
    {
        [_cow setTexture:[SKTexture textureWithImageNamed:[_leftArray objectAtIndex:0]]];
        [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_leftShadowArray objectAtIndex:0]]];
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_FrontRight])
    {
        [_cow setTexture:[SKTexture textureWithImageNamed:[_rightArray objectAtIndex:0]]];
        [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_rightShadowArray objectAtIndex:0]]];
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_BackRight])
    {
        [_cow setTexture:[SKTexture textureWithImageNamed:[_rightArray objectAtIndex:0]]];
        [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_rightShadowArray objectAtIndex:0]]];
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_FrontLeft])
    {
        [_cow setTexture:[SKTexture textureWithImageNamed:[_leftArray objectAtIndex:0]]];
        [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_leftShadowArray objectAtIndex:0]]];
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_BackLeft])
    {
        [_cow setTexture:[SKTexture textureWithImageNamed:[_leftArray objectAtIndex:0]]];
        [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_leftShadowArray objectAtIndex:0]]];
    }
}

- (void)useVelocityForDirection:(CGPoint)newPoint
{
    if (_velocityCheckCount == 0)
    {
        float velocityX = _velocity.x;
        float dot = (_direction.x * 0) + (_direction.y * 1);
        
        // UP
        if (dot > .5)
        {
            // Up Right
            if (velocityX > 0)
            {
//                DebugLog(@"Up Right");
                _directionTextureAppendage = Abduction_Direction_BackRight;
                self.cow.xScale = -1;
            }
            else
            {
//                DebugLog(@"Up Left");
                _directionTextureAppendage = Abduction_Direction_BackLeft;
                self.cow.xScale = 1;
            }
        }
        // Down
        else if (dot < -.5)
        {
            if (velocityX > 0)
            {
//                DebugLog(@"Down Right");
                _directionTextureAppendage = Abduction_Direction_FrontRight;
                self.cow.xScale = -1;
            }
            else
            {
//                DebugLog(@"Down Left");
                _directionTextureAppendage = Abduction_Direction_FrontLeft;
                self.cow.xScale = 1;
            }
        }
        // Left/Right
        else if ((dot < .5) && (dot > -.5))
        {
            if (velocityX > 0)
            {
//                DebugLog(@"Right");
                _directionTextureAppendage = Abduction_Direction_Right;
                self.cow.xScale = -1;
            }
            else
            {
//                DebugLog(@"Left");
                _directionTextureAppendage = Abduction_Direction_Left;
                self.cow.xScale = 1;
            }
        }
        
        [self updateTextureImage];
        
        _velocityCheckCount = _maxVelocityCheckCount;
    }
    else
    {
        _velocityCheckCount--;
    }
}

- (void)playRunSound
{
    if (_soundDelayCount == 0)
    {
//        _willPlaySound = NO;
        if (_willPlayWalkSound1)
        {
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"CowRun 1" FileType:@"caf" volume:0.3f];
            _willPlayWalkSound1 = NO;
        }
        else
        {
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"CowRun 2" FileType:@"caf" volume:0.3f];
            _willPlayWalkSound1 = YES;
        }
        
        _soundDelayCount = _soundDelayCountMax;
    }
    else
    {
//        _willPlaySound = YES;
        
        _soundDelayCount--;
    }
}

- (void)updateTextureImage
{
    //////////////////////////
    //// Setting textures ////
    //////////////////////////
    
    if ([_directionTextureAppendage isEqualToString:Abduction_Direction_FrontRight])
    {
        if (_moveTextureCount < [_forwardRightArray count])
        {
            [_cow setTexture:[SKTexture textureWithImageNamed:[_forwardRightArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_forwardRightShadowArray objectAtIndex:_moveTextureCount]]];
            
            _moveTextureCount++;
            [self playRunSound];
        }
        else
        {
            _moveTextureCount = 0;
            [_cow setTexture:[SKTexture textureWithImageNamed:[_forwardRightArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_forwardRightShadowArray objectAtIndex:_moveTextureCount]]];
        }
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_FrontLeft])
    {
        if (_moveTextureCount < [_forwardLeftArray count])
        {
            [_cow setTexture:[SKTexture textureWithImageNamed:[_forwardLeftArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_forwardLeftShadowArray objectAtIndex:_moveTextureCount]]];
            
            _moveTextureCount++;
            [self playRunSound];
        }
        else
        {
            _moveTextureCount = 0;
            [_cow setTexture:[SKTexture textureWithImageNamed:[_forwardLeftArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_forwardLeftShadowArray objectAtIndex:_moveTextureCount]]];
        }
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_BackRight])
    {
        if (_moveTextureCount < [_backRightArray count])
        {
            [_cow setTexture:[SKTexture textureWithImageNamed:[_backRightArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_backRightShadowArray objectAtIndex:_moveTextureCount]]];
            
            _moveTextureCount++;
            [self playRunSound];
        }
        else
        {
            _moveTextureCount = 0;
            [_cow setTexture:[SKTexture textureWithImageNamed:[_backRightArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_backRightShadowArray objectAtIndex:_moveTextureCount]]];
        }
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_BackLeft])
    {
        if (_moveTextureCount < [_backLeftArray count])
        {
            [_cow setTexture:[SKTexture textureWithImageNamed:[_backLeftArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_backLeftShadowArray objectAtIndex:_moveTextureCount]]];
            
            _moveTextureCount++;
            [self playRunSound];
        }
        else
        {
            _moveTextureCount = 0;
            [_cow setTexture:[SKTexture textureWithImageNamed:[_backLeftArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_backLeftShadowArray objectAtIndex:_moveTextureCount]]];
        }
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_Right])
    {
        if (_moveTextureCount < [_rightArray count])
        {
            [_cow setTexture:[SKTexture textureWithImageNamed:[_rightArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_rightShadowArray objectAtIndex:_moveTextureCount]]];
            
            _moveTextureCount++;
            [self playRunSound];
        }
        else
        {
            _moveTextureCount = 0;
            [_cow setTexture:[SKTexture textureWithImageNamed:[_rightArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_rightShadowArray objectAtIndex:_moveTextureCount]]];
        }
    }
    else if ([_directionTextureAppendage isEqualToString:Abduction_Direction_Left])
    {
        if (_moveTextureCount < [_leftArray count])
        {
            [_cow setTexture:[SKTexture textureWithImageNamed:[_leftArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_leftShadowArray objectAtIndex:_moveTextureCount]]];
            
            _moveTextureCount++;
            [self playRunSound];
        }
        else
        {
            _moveTextureCount = 0;
            [_cow setTexture:[SKTexture textureWithImageNamed:[_leftArray objectAtIndex:_moveTextureCount]]];
            [_shadowObject setTexture:[SKTexture textureWithImageNamed:[_leftShadowArray objectAtIndex:_moveTextureCount]]];
        }
    }
}

- (void)runAbductionAnimation
{
    int randNum = arc4random() % 2;
    if (randNum == 1)
    {
        //[[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"Moo 1" FileType:@"caf" volume:0.3f numberOfLoopes:0];
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Moo 1" FileType:@"caf" volume:0.3f];
    }
    else
    {
        //[[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"Moo 2" FileType:@"caf" volume:0.3f numberOfLoopes:0];
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Moo 2" FileType:@"caf" volume:0.3f];
    }
    
    self.physicsBody = nil;
    _shadowObject.hidden = YES;
    [self.cow runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_abductionArray timePerFrame:.1 resize:YES restore:NO]] completion:^{
        
    }];
}

- (void)cowWasDroppedFromUFO:(SKNode *)ufo
{
    _isMoving = NO;
    _allowMovement = YES;
    [_moveToPositionArray removeAllObjects];
    
    [self removeAllActions];
    [self.cow removeAllActions];
    
    _shadowObject.hidden = NO;

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_cow.frame.size.width * .5, _cow.frame.size.height * .5)];
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask = cowCollisionCategory;
    self.physicsBody.contactTestBitMask = abductionBeamCollisionCategory | cowCollisionCategory | blockerCollisionCategory;
    self.physicsBody.collisionBitMask = abductionDefaultCollissionCategory | blockerCollisionCategory;
    self.physicsBody.allowsRotation = NO;

    [self runAction:[SKAction moveTo:CGPointMake(ufo.position.x, ufo.position.y) duration:0]];
}

- (void)dealloc
{
    DebugLog(@"Did dealloc cow!");
}

@end
