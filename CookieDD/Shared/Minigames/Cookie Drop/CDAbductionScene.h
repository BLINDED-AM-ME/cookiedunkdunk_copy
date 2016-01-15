//
//  CDAbductionScene.h
//  cowTest
//
//  Created by Gary Johnston on 5/3/14.
//  Copyright (c) 2014 Seven Gun Games Productions. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CDAbductionCowObject.h"
#import "CDAbductionUFOObject.h"
#import "CDAbductionBlockerObject.h"

@protocol CDAbductionSceneDelegate;



@interface CDAbductionScene : SKScene <SKPhysicsContactDelegate>

@property (weak, nonatomic) id<CDAbductionSceneDelegate> delegate;

@property (strong, nonatomic) CDAbductionCowObject *cowToMoveObject;
@property (strong, nonatomic) SKSpriteNode *fieldObject;
//@property (strong, nonatomic) SKLabelNode *cowCountLabel;
@property (strong, nonatomic) SKLabelNode *timerLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;

@property (strong, nonatomic) NSMutableArray *cowArray;

@property (strong, nonatomic) NSMutableArray *rightBarnPositionArray;
@property (strong, nonatomic) NSMutableArray *leftBarnPositionArray;

@property (strong, nonatomic) NSMutableArray *leftHayPositionArray;
@property (strong, nonatomic) NSMutableArray *rightHayPositionArray;

@property (strong, nonatomic) NSMutableArray *leftFencePositionArray;
@property (strong, nonatomic) NSMutableArray *rightFencePositionArray;

@property (strong, nonatomic) NSMutableArray *rockPositionArray;

@property (assign, nonatomic) int ufoCount;
@property (assign, nonatomic) int cowCount;
@property (assign, nonatomic) int maxCowsInGame;
@property (assign, nonatomic) int difficulty;

@property (assign, nonatomic) int maxSeconds;
@property (assign, nonatomic) int currentSeconds;

- (void)setup;
- (void)startMiniGame;
- (void)cowWasAbducted:(CDAbductionCowObject *)cow WithUFO:(CDAbductionUFOObject *)ufo;

@end



@protocol CDAbductionSceneDelegate <NSObject>

@required
- (void)abductionMinigameSceneDidEnd:(CDAbductionScene *)scene WithScore:(int)score WithGoalScore:(int)goalScore WithWin:(BOOL)didWin;
- (void)abductionMinigameWillPresentDifficultyScreen:(CDAbductionScene *)scene;

@end