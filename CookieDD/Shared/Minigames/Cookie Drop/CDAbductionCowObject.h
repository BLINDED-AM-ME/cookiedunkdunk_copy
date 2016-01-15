

#import <SpriteKit/SpriteKit.h>

@interface CDAbductionCowObject : SKNode

@property (strong, nonatomic) SKSpriteNode *cow;
@property (strong, nonatomic) SKSpriteNode *activeMark;
@property (strong, nonatomic) CDAbductionCowObject *cowToFollow;

@property (strong, nonatomic) NSMutableArray *moveToPositionArray;
@property (strong, nonatomic) NSMutableArray *followingCowsArray;

@property (strong, nonatomic) NSString *directionTextureAppendage;

@property (assign, nonatomic) BOOL allowMovement;
@property (assign, nonatomic) BOOL isMoving;
@property (assign, nonatomic) BOOL stampeding;
@property (assign, nonatomic) BOOL isTouchedDown;
@property (assign, nonatomic) BOOL startFartTimer;
@property (assign, nonatomic) BOOL runFartAnimation;
@property (assign, nonatomic) BOOL allowFart;

@property (assign, nonatomic) int fartCounter;
@property (assign, nonatomic) int fartCounterMax;

@property (assign, nonatomic) int bufferX;
@property (assign, nonatomic) int bufferY;

- (id)initWithCowNumber:(int)cowNumber withScene:(SKScene *)scene;
- (void)wasSelectedWithPoint:(CGPoint)point;
- (void)moveCow:(NSNumber *)time;
- (void)wasUnselected;
- (void)runAbductionAnimation;
- (void)cowWasDroppedFromUFO:(SKNode *)ufo;

@end
