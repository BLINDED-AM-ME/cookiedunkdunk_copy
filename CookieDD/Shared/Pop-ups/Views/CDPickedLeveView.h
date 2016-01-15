//
//  CDPickedLeveView.h
//  CookieDD
//
//  Created by Gary Johnston on 7/11/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDMapBubble.h"
#import "CDIsometricMapViewController.h"

@protocol CDPickedLeveViewDelegate;


@interface CDPickedLeveView : UIView <UIScrollViewDelegate>

@property (weak, nonatomic) id<CDPickedLeveViewDelegate> delegate;

@property (strong, nonatomic) CDMapBubble *mapBubble;
@property (strong, nonatomic) NSNumber *planetNumber;
@property (strong, nonatomic) NSArray *itemTexturesArray;
@property (strong, nonatomic) CDMainButtonViewController *mainButtonVC;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *levelNameLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *backButtonLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *playButtonLabel;
//@property (weak, nonatomic) IBOutlet SGStrokeLabel *goalLabel;
//@property (weak, nonatomic) IBOutlet SGStrokeLabel *secondGoalLabel;

@property (weak, nonatomic) IBOutlet UIView *descriptionScreenView;
@property (weak, nonatomic) IBOutlet UIImageView *goldStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *bronzeStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *silverStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondaryGoalItemImage;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIScrollView *goalAreaScrollView;

// Leaderboard
@property (weak, nonatomic) IBOutlet UIView *leaderboardView;
@property (weak, nonatomic) IBOutlet UIScrollView *leaderboardScrollView;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *facebookButtonLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *leaderboardPageControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *leaderboardBackgroundView;
@property (strong, nonatomic) NSMutableArray *friendIdArray;
@property (weak, nonatomic) IBOutlet UIButton *closeLeaderboardButton;

- (void)setupWithParentalViewController:(UIViewController *)parentalViewController WithMapBubble:(CDMapBubble *)mapBubble WithPlanetID:(NSNumber *)planetType;

- (IBAction)facebookButtonHit:(id)sender;
- (IBAction)closeLeaderboardButtonHit:(id)sender;
- (IBAction)exitButtonHit:(id)sender;
- (IBAction)playButtonHit:(id)sender;
- (IBAction)backButtonHit:(id)sender;

@end



@protocol CDPickedLeveViewDelegate <NSObject>

@required
- (void)exitButtonWasHitOnPickedLevelView:(CDPickedLeveView *)pickedLevelView;
- (void)playButtonWasHitOnPickedLevelView:(CDPickedLeveView *)pickedLevelView withMapBubble:(CDMapBubble *)mapbubble WithPlanetID:(NSNumber *)planetType;

@end