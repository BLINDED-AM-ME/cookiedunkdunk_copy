

#import <SpriteKit/SpriteKit.h>
#import "CDAbductionCowObject.h"

@interface CDAbductionUFOObject : SKNode

@property (strong, nonatomic) CDAbductionCowObject *targetedCow;
@property (strong, nonatomic) SKSpriteNode *ufo;
@property (strong, nonatomic) SKSpriteNode *ship;
@property (strong, nonatomic) SKSpriteNode *abductionBeam;
@property (strong, nonatomic) SKSpriteNode *beamRing;

@property (strong, nonatomic) NSMutableArray *ufoMovementPointArray;

@property (assign, nonatomic) BOOL willMove;
@property (assign, nonatomic) BOOL abductionInProgress;
@property (assign, nonatomic) BOOL isDisoriented;

@property (assign, nonatomic) int ufoSpeed;
@property (assign, nonatomic) int ufoSpeedOrigin;
@property (assign, nonatomic) float closestCowPoint;

- (id)initForUFOWithScene:(SKScene *)scene;
- (void)checkDistanceToCow:(CDAbductionCowObject *)cow;
- (void)createBeam;
- (void)moveUFO:(NSNumber *)time;
- (void)disorient;
- (void)resetUFO;

@end
