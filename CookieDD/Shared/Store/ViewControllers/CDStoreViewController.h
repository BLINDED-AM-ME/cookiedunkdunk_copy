//
//  CDStoreViewController.h
//  CookieDD
//
//  Created by Josh on 1/14/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

/*
 
 Credits:
 
 President/CEO - Duane Schor
 
 Art Director - Neisha Bergman
 Artists - Ecieño Carmona
 Eric Eining
 Mike Swarts
 Erik Aamland
 Duane Schor
 
 Lead Programmer - Luke McDonald
 Programmers - Josh McGee
 Gary Johnston
 Dustin Whirle
 Jeremy Pagley
 Rodney Jenkins
 
 Server Programmer - Josh Pagley
 
 Lead Sound Designer - Ramsees Mechan
 Sound Designers - Richard Würth
 D’Andre Amos
 
 Voice Actors - Adrian Knapp
 Duane Schor
 Luke McDonald
 Neisha Bergman
 
 Lead Web Designer - Brittany Steed
 Web Designers - Yannik Bloscheck
 Lisa Menerick
 Andrew Gianikas
 
 Graphic Designer - Freddy Garcia
 
 Tech Support - Jonathan Marr-Cox
 
 Story - Audra Hudson
 Duane Schor
 
 Marketing Director - Rodney Jenkins
 Marketer - CJ Anderson
 
 Business Development Manager - Adam Hunt
 
 Quality Assurance - Vinny Spaulding
 
 Level Editing - Abner Velez
 
 
 Special Thanks - Jon Kurtz
 Benjamin Stahlhood II
 Andrew Nunley
 Steven Edsall
 And to all our friends and family that have supported us along the way!
 
 */

#import <UIKit/UIKit.h>
#import "CDStoreItemCell.h"
#import "SGStoreItemInfoViewController.h"
#import "SGStoreLoadScreenViewController.h"
#import "SGGiftFriendViewController.h"
#import "PRTween.h"
#import "PRTweenTimingFunctions.h"

typedef enum ScrollDirection
{
    ScrollDirection_Default,
    ScrollDirection_Right,
    ScrollDirection_Left

}   ScrollDirection;

@interface CDStoreViewController : UIViewController
<
UICollectionViewDataSource, UICollectionViewDelegate,
UIAlertViewDelegate,
LMInAppPurchaseManagerDelegate,
SGStoreItemInfoViewControllerDelegate,
SGGiftFriendViewControllerDelegate
>


@property (weak, nonatomic) IBOutlet UIView *leftCropView;
@property (weak, nonatomic) IBOutlet UIView *rightCropView;
@property (weak, nonatomic) IBOutlet UIView *conveyerContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *storeBlurredImageView;

@property (weak, nonatomic) IBOutlet UIImageView *rightConveyerCoverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftConveyerCoverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *conveyerLockImageView;
@property (weak, nonatomic) IBOutlet UIImageView *conveyerLockBaseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftSpeakerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightSpeakerImageview;
@property (weak, nonatomic) IBOutlet UIImageView *rightDoorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftDoorImageView;
@property (weak, nonatomic) IBOutlet UIView *cropUIView;

@property (weak, nonatomic) IBOutlet UIImageView *leftTopSpeakerLightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftBottomSpeakerLightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopSpeakerLightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomSpeakerLightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shopKeeperImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starScrollImageview;
@property (weak, nonatomic) IBOutlet UIImageView *supportUsBowlImageView;


@property (weak, nonatomic) IBOutlet UIView *topControlView;
@property (weak, nonatomic) IBOutlet UIView *salesView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *powerupsLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *costumesLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *currencyLabel;

@property (weak, nonatomic) IBOutlet UIButton *currencyTabButton;
@property (weak, nonatomic) IBOutlet UIButton *powerupTabButton;
@property (weak, nonatomic) IBOutlet UIButton *costumesTabButton;

@property (weak, nonatomic) IBOutlet UIButton *gameSectionButton;
@property (weak, nonatomic) IBOutlet UIButton *playerSectionButton;
@property (weak, nonatomic) IBOutlet UIButton *planetsSectionButton;

@property (weak, nonatomic) IBOutlet UICollectionView *storeItemsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *scrollItemsLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *scrollItemsRightButton;

@property (weak, nonatomic) IBOutlet UICollectionView *saleItemsCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *cookieImageView;
@property (weak, nonatomic) IBOutlet UILabel *gemCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
@property (weak, nonatomic) IBOutlet UIButton *tesupdateUserAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;
@property (weak, nonatomic) IBOutlet UIButton *exitStoreSignButton;

@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (assign, nonatomic) ScrollDirection scrollDirection;

@property (strong, nonatomic) NSMutableArray *inGameitemsArray;
@property (strong, nonatomic) NSMutableArray *playerItemsArray;
@property (strong, nonatomic) NSMutableArray *worldItemsArray;
@property (strong, nonatomic) NSMutableArray *shopKeeperAnimationsArray;
@property (strong, nonatomic) NSMutableArray *touchShopKeeperAnimationsArray;

@property (weak, nonatomic) IBOutlet UIView *tableCounterView;
@property (strong, nonatomic) UIImage *shopKeeperIdleImage;
@property (weak, nonatomic) IBOutlet UIImageView *coinParticleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gemParticleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *grandOpeningGiftImageView;
@property (weak, nonatomic) IBOutlet UIView *blackView;

@property (assign, nonatomic) BOOL presentRight;

- (IBAction)currencyTabButtonHit:(id)sender;
- (IBAction)costumesTabButtonHit:(id)sender;
- (IBAction)powerupsTabButtonHit:(id)sender;

- (IBAction)didSelectGameSection:(id)sender;
- (IBAction)didSelectPlayerSection:(id)sender;
- (IBAction)didSelectPlanetsSection:(id)sender;

- (IBAction)scrollItemsLeft:(id)sender;
- (IBAction)touchDownScrollItemsLeft:(id)sender;
- (IBAction)touchupOutSideScrollItemsLeft:(id)sender;



- (IBAction)scrollItemsRight:(id)sender;
- (IBAction)touchDownScrollItemsRight:(id)sender;
- (IBAction)touchupOutSideScrollItemsRight:(id)sender;

- (IBAction)testUpdateUserAccount:(id)sender;
- (IBAction)exitStore:(id)sender;
- (IBAction)restoreUserTransactions:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *addCoinsCheatButton;
- (IBAction)addCoinsCheat:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addGemsCheatButton;
- (IBAction)addGemsCheat:(id)sender;

@end
