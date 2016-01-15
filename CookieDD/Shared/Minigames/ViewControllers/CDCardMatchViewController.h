//
//  CardMatchViewController.h
//  NewGame
//
//  Created by Josh on 7/30/13.
//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "SGAppDelegate.h"
#import "CDLoadingScreenViewController.h"


@protocol CDCardMatchViewControllerDelegate;



@interface CDCardMatchViewController : UIViewController

@property (weak, nonatomic) id<CDCardMatchViewControllerDelegate> delegate;

@property (strong, nonatomic) CDLoadingScreenViewController *loadingScreen;

@property (weak, nonatomic) IBOutlet UIView *stovetopView;
@property (weak, nonatomic) IBOutlet UIView *controlPanelView;
@property (weak, nonatomic) IBOutlet UIView *clockView;

@property (weak, nonatomic) IBOutlet UILabel *clockDarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *clockActiveLabel;

@property (weak, nonatomic) IBOutlet UIImageView *stoveKnobImageView;
@property (weak, nonatomic) IBOutlet UIButton *infiniteTimeButton;

- (IBAction)infiniteTime:(id)sender;

@end



@protocol CDCardMatchViewControllerDelegate <NSObject>

@required
- (void)replayButtonWasHitInCardMatch;
- (void)storeButtonWasHitInCardMatch;

@end