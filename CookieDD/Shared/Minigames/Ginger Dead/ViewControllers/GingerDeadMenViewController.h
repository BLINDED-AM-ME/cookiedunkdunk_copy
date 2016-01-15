//
//  ViewController.h
//  MiniGameTest
//

//  Copyright (c) 2013 Rodney Jenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CDLoadingScreenViewController.h"

@protocol GingerDeadMenViewControllerDelegate;


@interface GingerDeadMenViewController : UIViewController

@property (weak, nonatomic) id<GingerDeadMenViewControllerDelegate> delegate;
@property(strong, nonatomic) CDLoadingScreenViewController *loadingScreen;
@property (assign, nonatomic) BOOL presentRight;

-(void)CreatGameScene;
-(void)Quit;


@end



@protocol GingerDeadMenViewControllerDelegate <NSObject>

@required
- (void)storeButtonHitInGingerDeadViewController;
- (void)replayButtonWasHitInGingerDeadViewController;

@end