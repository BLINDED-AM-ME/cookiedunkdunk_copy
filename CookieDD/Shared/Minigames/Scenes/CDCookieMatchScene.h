//
//  MyScene.h
//  NewGame
//

//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CDCardSpriteNode.h"
#import "SGFileManager.h"

@protocol CDCookieMatchSceneDelegate;


@interface CDCookieMatchScene : SKScene <CardSpriteNodeDelegate>

@property (weak, nonatomic) id<CDCookieMatchSceneDelegate> delegate;

@property (strong, nonatomic) SKLabelNode *timerLabel;

@property (assign, nonatomic) bool enabled;
@property (assign, nonatomic) bool hasStarted;

@property (assign, nonatomic) int difficulty;

-(void)test:(int)value;
- (void)startMiniGame;
- (void)setup;

@end


@protocol CDCookieMatchSceneDelegate <NSObject>

@optional
- (void)cookieMatchDidEndScene:(CDCookieMatchScene *)scene WithScore:(int)score WithGoalScore:(int)goalScore WithWin:(BOOL)didWin;
- (void)timeDidPass:(CDCookieMatchScene *)scene WithScore:(int)score WithGoalScore:(int)goalScore WithWin:(BOOL)didWin;;
- (void)cookieMatchDifficultyWasSelected:(CDCookieMatchScene *)scene;

@end