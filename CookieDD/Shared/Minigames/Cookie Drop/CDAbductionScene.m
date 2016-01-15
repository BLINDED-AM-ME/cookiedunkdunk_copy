//
//  CDAbductionScene.m
//  cowTest
//
//  Created by Gary Johnston on 5/3/14.
//  Copyright (c) 2014 Seven Gun Games Productions. All rights reserved.
//

#import "CDAbductionScene.h"

@interface CDAbductionScene()

@property (strong, nonatomic) CDAbductionCowObject *targetedCow;

@property (assign, nonatomic) BOOL didStartTimer;
@property (assign, nonatomic) BOOL contentCreated;
@property (assign, nonatomic) BOOL hasStarted;
@property (assign, nonatomic) BOOL didWin;
@property (assign, nonatomic) BOOL didCreatePopup;

@property (assign, nonatomic) int score;
@property (assign, nonatomic) int goalScore;

@property (assign, nonatomic) float previousTime;
@property (assign, nonatomic) float startTime;

@property (strong, nonatomic) NSMutableArray *ufoArray;
@property (strong, nonatomic) NSMutableArray *blockerArray;

@property (assign, nonatomic) CGPoint lastPointChecked;

@property (strong, nonatomic) NSMutableArray *stampedingCowsArray;

@property (assign, nonatomic) NSTimeInterval lastUpdateTime;
@property (assign, nonatomic) NSTimeInterval deltaTime;

@end



@implementation CDAbductionScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        [self load];
    }
    return self;
}

- (void)load
{
    self.physicsWorld.contactDelegate = self;
    self.name = @"scene";
    self.physicsWorld.gravity = CGVectorMake(0, 0);
//    [self setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    
    _currentSeconds = 500;
    _previousTime = 0.0f;

    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.zPosition = -1000;
    [self addChild:background];
    
    _cowArray = [NSMutableArray new];
    _ufoArray = [NSMutableArray new];
    
//    _cowCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    _cowCountLabel.text = [NSString stringWithFormat:@"%i/%i", _cowCount, _maxCowsInGame];
//    _cowCountLabel.fontColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
//    _cowCountLabel.fontSize = 12;
//    _cowCountLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - _cowCountLabel.frame.size.width, CGRectGetMaxY(self.frame) - _cowCountLabel.frame.size.height * 2);
//    [self addChild:_cowCountLabel];
    
//    _cowCountLabel.hidden = YES;
    
    _fieldObject = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(415, 235)];
    _fieldObject.name = @"fieldObject";
//    [_fieldObject setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:_fieldObject.frame]];
    _fieldObject.position = CGPointMake(CGRectGetMidX(self.frame), _fieldObject.size.height * .5);
    _fieldObject.zPosition = -200;
    [self addChild:_fieldObject];
    
    SKSpriteNode *backFenceObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_backfence"];
    backFenceObject.name = @"backFenceObject";
    backFenceObject.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    backFenceObject.zPosition = -500;
    [self addChild:backFenceObject];
    
    SKSpriteNode *frontFenceObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_frontfence"];
    frontFenceObject.position = CGPointMake(CGRectGetMidX(self.frame), frontFenceObject.size.height * .5);
    frontFenceObject.zPosition = 1000;
    [self addChild:frontFenceObject];
    
    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"Abduction_Theme" FileType:@"caf" volume:0.3f numberOfLoopes:-1];
    [self createTimer];
}

- (void)setup
{
    _hasStarted = NO;
    self.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(abductionMinigameWillPresentDifficultyScreen:)])
    {
        [self.delegate abductionMinigameWillPresentDifficultyScreen:self];
    }
}

- (void)startMiniGame
{
    switch (self.difficulty)
    {
        case gameDifficultyLevelEasy:
            _maxCowsInGame = 5;
            _cowCount = _maxCowsInGame;
            _ufoCount = 1;
            
            _score = _maxCowsInGame;
            _maxSeconds = 60;
            _goalScore = 2;
            break;
            
        case gameDifficultyLevelMedium:
            _maxCowsInGame = 5;
            _cowCount = _maxCowsInGame;
            _ufoCount = 1;
            
            _score = _maxCowsInGame;
            _maxSeconds = 60;
            _goalScore = 3;
            break;
            
        case gameDifficultyLevelHard:
            _maxCowsInGame = 5;
            _cowCount = _maxCowsInGame;
            _ufoCount = 1;
            
            _score = _maxCowsInGame;
            _maxSeconds = 60;
            _goalScore = 4;
            break;
            
        case gameDifficultyLevelCrazy:
            _maxCowsInGame = 5;
            _cowCount = _maxCowsInGame;
            _ufoCount = 1;
            
            _score = _maxCowsInGame;
            _maxSeconds = 60;
            _goalScore = 5;
            break;
            
        default:
            break;
    }
    
    self.previousTime = 0.0f;
    self.currentSeconds = self.maxSeconds;
    
    self.userInteractionEnabled = YES;
    self.hasStarted = YES;
    
    int minutes = _currentSeconds/60;
    int seconds = _currentSeconds%60;
    
    [_timerLabel setText:[NSString stringWithFormat:@"%02i:%02i", minutes, seconds]];
    _timerLabel.hidden = NO;
    
    _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
    _scoreLabel.hidden = NO;
    
    _didWin = NO;
    
    [self loadCows];
    [self loadSomeUFOs];
    [self loadBlockers];
}

- (void)update:(NSTimeInterval)currentTime
{
    ////////////////////////////
    //// UFO Distance Check ////
    ////////////////////////////
    
    if (!_didStartTimer)
    {
        _lastUpdateTime = currentTime;
        _didStartTimer = YES;
    }
    
    _deltaTime = currentTime - _lastUpdateTime;
    _lastUpdateTime = currentTime;
    
    [_fieldObject enumerateChildNodesWithName:@"ufo" usingBlock:^(SKNode *ufo, BOOL *stop) {
        CDAbductionUFOObject * cdUFO = (CDAbductionUFOObject *)ufo;
        for (CDAbductionCowObject *cow in _cowArray)
        {
            [cdUFO checkDistanceToCow:cow];
        }
        
        if (_targetedCow != cdUFO.targetedCow)
        {
//            DebugLog(@"new cow");
            _targetedCow = cdUFO.targetedCow;
        }
        [cdUFO moveUFO:@(_deltaTime)];
    }];
    
    ///////////////////////
    //// Move the cows ////
    ///////////////////////
    
    [_fieldObject enumerateChildNodesWithName:@"cowObject" usingBlock:^(SKNode *cow, BOOL *stop) {
        [(CDAbductionCowObject *)cow moveCow:@(_deltaTime)];
    }];
    
    ///////////////
    //// Timer ////
    ///////////////
    if (currentTime > _previousTime+1)
    {
        _previousTime = currentTime;
        [self updateTimer];
    }
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive)
	{
		self.view.paused = YES;
		self.paused = YES;
		
		[[SGAudioManager audioManager] pauseAllAudio];
	}
}

/////////////////////////
//// Create Children ////
/////////////////////////

- (void)createTimer
{
    SKSpriteNode *timerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-mini-timer"];
    timerObject.position = CGPointMake(timerObject.frame.size.width * .5, self.frame.size.height - (.5 * timerObject.frame.size.height));
    [self addChild:timerObject];
    
    SKSpriteNode *scoreObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-hud-mini-score"];
    scoreObject.position = CGPointMake(self.frame.size.width - (scoreObject.frame.size.width * .5), self.frame.size.height - (.5 * timerObject.frame.size.height));
    [self addChild:scoreObject];
    
    _timerLabel = [SKLabelNode labelNodeWithFontNamed:kFontDamnNoisyKids];
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:kFontDamnNoisyKids];
    
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        _timerLabel.fontSize = 15;
        _scoreLabel.fontSize = 15;
    }
    else if (IS_IPAD)
    {
        _timerLabel.fontSize = 50;
        _scoreLabel.fontSize = 50;
    }
    
    _timerLabel.position = CGPointMake((timerObject.frame.size.width * .20), 0 - (timerObject.frame.size.height * .17));
    _timerLabel.hidden = YES;
    [timerObject addChild:_timerLabel];
    
    _scoreLabel.text = [NSString stringWithFormat:@"%i", _score];
    _scoreLabel.position = CGPointMake(0, 0 - (scoreObject.frame.size.height * .26));
    _scoreLabel.hidden = YES;
    [scoreObject addChild:_scoreLabel];
}

- (void)loadCows
{
    for (int count = 0; count < _cowCount; count++)
    {
        CDAbductionCowObject *cow = [[CDAbductionCowObject alloc] initWithCowNumber:count withScene:self];
        [_cowArray addObject:cow];
        [_fieldObject addChild:cow];
    }
}

- (void)loadSomeUFOs
{
    for (int count = 0; count < _ufoCount; count++)
    {
        CDAbductionUFOObject *ufo = [[CDAbductionUFOObject alloc] initForUFOWithScene:self];
        [_ufoArray addObject:ufo];
        [_fieldObject addChild:ufo];
    }
}

- (void)loadBlockers
{
    _rightBarnPositionArray = [[NSMutableArray alloc] initWithObjects:
                              [NSValue valueWithCGPoint:CGPointMake(438, 244)],
                              [NSValue valueWithCGPoint:CGPointMake(338, 244)],
                              [NSValue valueWithCGPoint:CGPointMake(340, 100)],
                              [NSValue valueWithCGPoint:CGPointMake(436, 100)],
                              [NSValue valueWithCGPoint:CGPointMake(351, 159)],
                              nil];
    
    _leftBarnPositionArray = [[NSMutableArray alloc] initWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(121, 243)],
                               [NSValue valueWithCGPoint:CGPointMake(121, 106)],
                               [NSValue valueWithCGPoint:CGPointMake(227, 243)],
                               [NSValue valueWithCGPoint:CGPointMake(242, 99)],
                               [NSValue valueWithCGPoint:CGPointMake(168, 154)],
                               nil];
    
    _leftFencePositionArray = [[NSMutableArray alloc] initWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(128, 93)],
                               [NSValue valueWithCGPoint:CGPointMake(226, 171)],
                               [NSValue valueWithCGPoint:CGPointMake(315, 87)],
                               [NSValue valueWithCGPoint:CGPointMake(429, 154)],
                               [NSValue valueWithCGPoint:CGPointMake(266, 234)],
                               nil];
    
    _rightFencePositionArray = [[NSMutableArray alloc] initWithObjects:
                                [NSValue valueWithCGPoint:CGPointMake(112, 141)],
                                [NSValue valueWithCGPoint:CGPointMake(350, 144)],
                                [NSValue valueWithCGPoint:CGPointMake(102, 227)],
                                [NSValue valueWithCGPoint:CGPointMake(441, 74)],
                                [NSValue valueWithCGPoint:CGPointMake(267, 204)],
                                nil];
    
    _leftHayPositionArray = [[NSMutableArray alloc] initWithObjects:
                             [NSValue valueWithCGPoint:CGPointMake(463, 173)],
                             [NSValue valueWithCGPoint:CGPointMake(301, 219)],
                             [NSValue valueWithCGPoint:CGPointMake(283, 139)],
                             [NSValue valueWithCGPoint:CGPointMake(113, 119)],
                             [NSValue valueWithCGPoint:CGPointMake(282, 66)],
                             nil];
    
    _rightHayPositionArray = [[NSMutableArray alloc] initWithObjects:
                              [NSValue valueWithCGPoint:CGPointMake(102, 171)],
                              [NSValue valueWithCGPoint:CGPointMake(443, 68)],
                              [NSValue valueWithCGPoint:CGPointMake(347, 213)],
                              [NSValue valueWithCGPoint:CGPointMake(194, 126)],
                              [NSValue valueWithCGPoint:CGPointMake(143, 67)],
                              nil];
    
    _rockPositionArray = [[NSMutableArray alloc] initWithObjects:
                          [NSValue valueWithCGPoint:CGPointMake(187, 112)],
                          [NSValue valueWithCGPoint:CGPointMake(297, 183)],
                          [NSValue valueWithCGPoint:CGPointMake(392, 100)],
                          [NSValue valueWithCGPoint:CGPointMake(161, 65)],
                          [NSValue valueWithCGPoint:CGPointMake(129, 192)],
                          nil];
    
    // NOTE TO SELF: If all objects of the same side (left/right) are on the board, a crash may occur.
    NSArray *blockerArray;
    if (_difficulty == gameDifficultyLevelEasy)
    {
        NSArray *tempArray = [NSArray arrayWithObjects:Blocker_HayLeft, Blocker_HayRight, Blocker_Rock, nil];
        int randNum = arc4random() % [tempArray count];
        NSString *blocker = [tempArray objectAtIndex:randNum];
        
        blockerArray = [[NSArray alloc] initWithObjects:blocker, nil];
    }
    else if (_difficulty == gameDifficultyLevelMedium)
    {
        NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:Blocker_Rock, Blocker_HayRight, Blocker_HayLeft, nil];
        int randNum = arc4random() % [tempArray count];
        NSString *blocker = [tempArray objectAtIndex:randNum];
        [tempArray removeObject:blocker];
        
        int randNum2 = arc4random() % [tempArray count];
        NSString *blocker2 = [tempArray objectAtIndex:randNum2];
        
        
        NSArray *tempBarnArray = [NSArray arrayWithObjects:Blocker_BarnLeft, Blocker_BarnRight, nil];
        int randBarnNum = arc4random() % [tempBarnArray count];
        NSString *barnBlocker = [tempBarnArray objectAtIndex:randBarnNum];
        
        blockerArray = [[NSArray alloc] initWithObjects:blocker, blocker2, barnBlocker, nil];
    }
    else if (_difficulty == gameDifficultyLevelHard)
    {
        NSArray *tempHayArray = [NSArray arrayWithObjects:Blocker_HayLeft, Blocker_HayRight, nil];
        int randHayNum = arc4random() % [tempHayArray count];
        NSString *hayBlocker = [tempHayArray objectAtIndex:randHayNum];
        
        NSArray *tempFenceArray = [NSArray arrayWithObjects:Blocker_FenceRight, Blocker_FenceLeft, nil];
        int randFenceNum = arc4random() % [tempFenceArray count];
        NSString *fenceBlocker = [tempFenceArray objectAtIndex:randFenceNum];
        
        NSArray *tempBarnArray = [NSArray arrayWithObjects:Blocker_BarnLeft, Blocker_BarnRight, nil];
        int randBarnNum = arc4random() % [tempBarnArray count];
        NSString *barnBlocker = [tempBarnArray objectAtIndex:randBarnNum];
        
        blockerArray = [[NSArray alloc] initWithObjects:hayBlocker, Blocker_Rock, fenceBlocker, barnBlocker, nil];
    }
    else if (_difficulty == gameDifficultyLevelCrazy)
    {
        NSArray *tempHayArray = [NSArray arrayWithObjects:Blocker_HayLeft, Blocker_HayRight, nil];
        int randHayNum = arc4random() % [tempHayArray count];
        NSString *hayBlocker = [tempHayArray objectAtIndex:randHayNum];
        
        blockerArray = [[NSArray alloc] initWithObjects:Blocker_BarnRight, Blocker_BarnLeft, hayBlocker, Blocker_FenceLeft, Blocker_FenceRight, Blocker_Rock, nil];
    }
    
    for (NSString *blockerType in blockerArray)
    {
        CDAbductionBlockerObject *blocker = [[CDAbductionBlockerObject alloc] initWithBlockerType:blockerType WithScene:self];
        blocker.zPosition = -1 * blocker.frame.origin.y;
        [_fieldObject addChild:blocker];
    }
}

#pragma mark - Timer Methods
///////////////
//// Timer ////
///////////////

- (void)updateTimer
{
    if (self.currentSeconds >= 0)
    {
        int minutes = _currentSeconds/60;
        int seconds = _currentSeconds%60;
        
        if (!_timerLabel.hidden)
        {
            [_timerLabel setText:[NSString stringWithFormat:@"%02i:%02i", minutes, seconds]];
        }
        
        if (_hasStarted)
        {
            _currentSeconds -= 1;
        }
    }
    else
    {
		[self removeAllActions];
		
        _didCreatePopup = YES;
        
        self.paused = YES;
        self.userInteractionEnabled = NO;
        
        if (_score >= _goalScore)
        {
            _didWin = YES;
        }
        
        if ([self.delegate respondsToSelector:@selector(abductionMinigameSceneDidEnd:WithScore:WithGoalScore:WithWin:)])
        {
            [self.delegate abductionMinigameSceneDidEnd:self WithScore:_score WithGoalScore:_goalScore WithWin:_didWin];
        }
    }
}

/////////////////
//// Touches ////
/////////////////
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _cowToMoveObject = nil;
    
    for (UITouch *touch in touches)
    {
        CGPoint touchPoint = [touch locationInNode:_fieldObject];
        NSArray *nodes = [_fieldObject nodesAtPoint:touchPoint];
        
        if ([nodes count])
        {
            for (SKNode *node in nodes)
            {
                if ([node.name isEqualToString:@"theCow"])
                {
                    _cowToMoveObject = (CDAbductionCowObject *)node.parent;
                    
                    if (_cowToMoveObject.allowMovement)
                    {
                        DebugLog(@"picked a cow");
                        [_cowToMoveObject wasSelectedWithPoint:touchPoint];
                        _cowToMoveObject.startFartTimer = YES;
                        return;
                    }
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint movePoint = [[touches anyObject] locationInNode:_fieldObject];
    BOOL canMove = YES;
    
    for (UITouch *touch in touches)
    {
        CGPoint touchPoint = [touch locationInNode:_fieldObject];
        NSArray *nodes = [_fieldObject nodesAtPoint:touchPoint];
        
        if ([nodes count])
        {
            for (SKNode *node in nodes)
            {
                DebugLog(@"Name: %@", node.name);
                if ([node.name isEqualToString:Blocker_BarnLeft])
                {
                    canMove = NO;
                }
                if ([node.name isEqualToString:Blocker_BarnRight])
                {
                    canMove = NO;
                }
                if ([node.name isEqualToString:Blocker_FenceLeft])
                {
                    canMove = NO;
                }
                if ([node.name isEqualToString:Blocker_FenceRight])
                {
                    canMove = NO;
                }
                if ([node.name isEqualToString:Blocker_HayLeft])
                {
                    canMove = NO;
                }
                if ([node.name isEqualToString:Blocker_HayRight])
                {
                    canMove = NO;
                }
                if ([node.name isEqualToString:Blocker_Rock])
                {
                    canMove = NO;
                }
            }
        }
    }
    
    if (_cowToMoveObject && canMove)
    {
        if ((movePoint.x + ([_cowToMoveObject calculateAccumulatedFrame].size.width * .5) < _fieldObject.frame.size.width * .5) &&
            (movePoint.x - ([_cowToMoveObject calculateAccumulatedFrame].size.width * .5) > 0 - (_fieldObject.frame.size.width * .5)) &&
            (movePoint.y + ([_cowToMoveObject calculateAccumulatedFrame].size.height * .5) < _fieldObject.frame.size.height * .5) &&
            (movePoint.y - ([_cowToMoveObject calculateAccumulatedFrame].size.height * .5) > 0 - (_fieldObject.frame.size.height * .5)))
        {
            DebugLog(@"Moved");
            _cowToMoveObject.startFartTimer = NO;
            _cowToMoveObject.fartCounter = _cowToMoveObject.fartCounterMax;
            
            [_cowToMoveObject.moveToPositionArray addObject:[NSValue valueWithCGPoint:movePoint]];
            
            for (CDAbductionCowObject *cowFollower in _cowToMoveObject.followingCowsArray)
            {
                DebugLog(@"COW");
                [cowFollower.moveToPositionArray addObject:[NSValue valueWithCGPoint:movePoint]];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _cowToMoveObject.isTouchedDown = NO;
    if (_cowToMoveObject.startFartTimer && _cowToMoveObject.allowFart)
    {
        _cowToMoveObject.runFartAnimation = YES;
    }
    
    _cowToMoveObject.fartCounter = _cowToMoveObject.fartCounterMax;
}

#pragma mark - Collision Detection
/////////////////////////////
//// Collision Detection ////
/////////////////////////////
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if ([contact.bodyA.node.name isEqualToString:@"cowObject"] && [contact.bodyB.node.name isEqualToString:@"cowObject"])
    {
        CDAbductionCowObject *cowA = (CDAbductionCowObject *)contact.bodyA.node;
        CDAbductionCowObject *cowB = (CDAbductionCowObject *)contact.bodyB.node;
        
        if (cowA.isMoving && cowB.allowMovement)
        {
//            DebugLog(@"Follow cowA");
            [cowB.moveToPositionArray removeAllObjects];
            [cowB.moveToPositionArray setArray:cowA.moveToPositionArray];
            [cowB.moveToPositionArray removeLastObject];
            
            [cowA.followingCowsArray addObject:cowB];
        }
        else if (cowB.isMoving && cowA.allowMovement)
        {
//            DebugLog(@"Follow cowB");
            [cowA.moveToPositionArray removeAllObjects];
            [cowA.moveToPositionArray setArray:cowB.moveToPositionArray];
            [cowA.moveToPositionArray removeLastObject];
            
            [cowB.followingCowsArray addObject:cowA];
        }
    }
    else if (([contact.bodyA.node.name isEqualToString:@"ufo"] && [contact.bodyB.node.name isEqualToString:@"cowObject"]) ||
             ([contact.bodyB.node.name isEqualToString:@"ufo"] && [contact.bodyA.node.name isEqualToString:@"cowObject"]))
    {
        if ([contact.bodyA.node.name isEqualToString:@"cowObject"])
        {
            CDAbductionUFOObject *ufo = (CDAbductionUFOObject *)contact.bodyB.node;
            CDAbductionCowObject *cow = (CDAbductionCowObject *)contact.bodyA.node;
            
            [self cowWasAbducted:cow WithUFO:ufo];
        }
        else
        {
            CDAbductionUFOObject *ufo = (CDAbductionUFOObject *)contact.bodyA.node;
            CDAbductionCowObject *cow = (CDAbductionCowObject *)contact.bodyB.node;
            
            [self cowWasAbducted:cow WithUFO:ufo];
        }
    }
    else if (([contact.bodyA.node.name isEqualToString:@"fartBubbleObject"] && [contact.bodyB.node.name isEqualToString:@"ufoShipObject"]) ||
             ([contact.bodyA.node.name isEqualToString:@"ufoShipObject"] && [contact.bodyB.node.name isEqualToString:@"fartBubbleObject"]))
    {
        DebugLog(@"Collision with fart");
        if ([contact.bodyA.node.name isEqualToString:@"ufoShipObject"])
        {
            CDAbductionUFOObject *ufo = (CDAbductionUFOObject *)contact.bodyA.node.parent;
            
            [ufo disorient];
        }
        else
        {
            CDAbductionUFOObject *ufo = (CDAbductionUFOObject *)contact.bodyB.node.parent;
            
            [ufo disorient];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    
}

- (void)cowWasAbducted:(CDAbductionCowObject *)cow WithUFO:(CDAbductionUFOObject *)ufo
{
    if (!ufo.abductionInProgress)
    {
        ufo.abductionInProgress = YES;
        ufo.willMove = NO;
        cow.allowMovement = NO;
        cow.cowToFollow = nil;
        
        [cow.followingCowsArray removeAllObjects];
        [cow.moveToPositionArray removeAllObjects];
        
        [ufo createBeam];
        [cow runAbductionAnimation];
        
        //[cow runAction:[SKAction scaleTo:.01 duration:2] completion:^{
        [cow runAction:[SKAction moveTo:CGPointMake(CGRectGetMidX(ufo.frame), CGRectGetMinY(ufo.frame) + 100) duration:2] completion:^{
            
            DebugLog(@"Cow has been abducted");
            
            
            [_cowArray removeObject:cow];
            [cow removeFromParent];
            
            [ufo resetUFO];
            
            _cowCount--;
            _score = _cowCount;
            _scoreLabel.text = [NSString stringWithFormat:@"%i/%i", _score, _goalScore];
            
            if (_cowCount <= 0)
            {
                if ([self.delegate respondsToSelector:@selector(abductionMinigameSceneDidEnd:WithScore:WithGoalScore:WithWin:)])
                {
                    [self.delegate abductionMinigameSceneDidEnd:self WithScore:_score WithGoalScore:_goalScore WithWin:_didWin];
                }
            }
            //                    _cowCountLabel.text = [NSString stringWithFormat:@"%i/%i", _cowCount, _maxCowsInGame];
        }];
    }
}

#pragma mark - Cleanup
- (void)dealloc
{
    DebugLog(@"Did dealloc scene!");
}

@end
