//
//  CDAbductionViewController.h
//  cowTest
//

//  Copyright (c) 2014 Seven Gun Games Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CDLoadingScreenViewController.h"
#import "CDAbductionScene.h"

@protocol CDAbductionViewControllerDelegate;



@interface CDAbductionViewController : UIViewController <CDAbductionSceneDelegate>

@property (weak, nonatomic) id<CDAbductionViewControllerDelegate> delegate;
@property (strong, nonatomic) CDLoadingScreenViewController *loadingScreen;

@property (assign, nonatomic) BOOL presentRight;

@end



@protocol CDAbductionViewControllerDelegate <NSObject>

- (void)replayButtonWasHitInAbductionMinigame;
- (void)storeButtonHitInAbductionMinigame;

@end