//
//  CDIsometricMapViewController.h
//  CookieDD
//
//  Created by Josh on 6/17/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDMapBubble.h"
#import "CDFriendContainer.h"

#import "SGGameManager.h"
#import "CDCookieDunkDunKViewController.h"
#import "CDLoadingScreenViewController.h"
#import "CDStoreViewController.h"
#import "CDLivesDisplayView.h"


@protocol CDIsometricMapViewControllerDelegate;

@interface CDIsometricMapViewController : UIViewController <UIScrollViewDelegate, CDCookieDunkDunKViewControllerDelegate, CDMapBubbleDelegate, CDMainButtonViewControllerDelegate, CDLivesDisplayViewDelegate, CDFriendContainerDelegate>

@property (weak, nonatomic) id <CDIsometricMapViewControllerDelegate> delegate;

//@property (strong, nonatomic) UIView *transitionCoverView;

@property (weak, nonatomic) IBOutlet CDLivesDisplayView *livesDisplayView;
@property (strong, nonatomic) CDMainButtonViewController *mainButtonVC;
//@property (strong, nonatomic) CDCookieDunkDunKViewController *cddViewController;
//@property (strong, nonatomic) CDStoreViewController *storeVC;

@property (weak, nonatomic) IBOutlet UIButton *nextLevelButton;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *nextLevelButtonLabel;
- (IBAction)unlockNextLevel:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) NSString *planetName; // This is for internal files.
@property (strong, nonatomic) NSString *planetDisplayName; // This is what the player sees.

@property (assign, nonatomic) BOOL isProcessingNextLevel;

@property (strong, nonatomic) NSArray *bubbleCoords;
@property (strong, nonatomic) NSArray *bubbleScales;
@property (strong, nonatomic) NSArray *friendImageOrientations;
@property (strong, nonatomic) NSArray *levelProperties;
@property (strong, nonatomic) NSNumber *planetID;
@property (strong, nonatomic) NSNumber *minigameStartPoint;

@property (strong, nonatomic) NSArray *levelBubblesArray;
@property (strong, nonatomic) CDMapBubble *minigameBubble;

@property (strong, nonatomic) NSMutableArray *friendsArray; // Facebook friends
@property (strong, nonatomic) NSMutableArray *friendIdArray;

- (void)loadPlayerInfo;
- (void)updateLevelBubbles;
- (void)updateMinigameBubble;
- (void)fetchFriends;
- (void)updateFriends;

@end





@protocol CDIsometricMapViewControllerDelegate <NSObject>

@optional
-(void)isometricMap:(CDIsometricMapViewController*)isoMap didSelectLevel:(NSNumber*)levelID planet:(NSNumber*)planetID;
-(void)isometricMap:(CDIsometricMapViewController *)isoMap didSelectMinigameForPlanetWithID:(NSNumber*)planetID;
-(void)shopWasSelectedInTheIsoMap;
-(void)isometricMapWillExit:(CDIsometricMapViewController *)isoMap withVideoName:(NSString *)videoName;
-(void)isometricMapWillExit:(CDIsometricMapViewController *)isoMap WithAnimation:(BOOL)willAnimate ToStore:(BOOL)toTheStore;

@end
