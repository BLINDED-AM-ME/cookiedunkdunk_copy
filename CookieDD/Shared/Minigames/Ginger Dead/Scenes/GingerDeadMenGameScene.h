//
//  MyScene.h
//  MiniGameTest
//

//  Copyright (c) 2013 Rodney Jenkins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#include "GingerDeadMenViewController.h"

typedef enum Difficulty
{
    Undefined,
    Easy,
    Medium,
    Hard,
    Crazy
    
}   Difficulty;

@protocol GingerDeadMenGameSceneDelegate;

@interface GingerDeadMenGameScene : SKScene <UIAccelerometerDelegate>

@property (weak, nonatomic) id<GingerDeadMenGameSceneDelegate> delegate;
@property (strong, atomic) GingerDeadMenViewController* BigDaddy;
@property (assign, nonatomic) Difficulty difficulty;
@property (assign, nonatomic) bool isGameOver;
@property (assign, nonatomic) bool isTakingPlayerInput;

-(void)GameOver;
-(void)SceneSetup:(Difficulty)difficulty;
-(void)Start_this_Bitch;
-(void)RESET;

-(void)EraseThisGameScene;

@end



@protocol GingerDeadMenGameSceneDelegate <NSObject>

@optional
- (void)gingerDeadSceneDidEnd:(GingerDeadMenGameScene *)scene DidWin:(BOOL)didWin WithScore:(int)score;
- (void)gingerDeadWillPresentDifficultyScreen:(GingerDeadMenGameScene *)scene;

@end