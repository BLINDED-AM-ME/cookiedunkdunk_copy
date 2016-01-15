//
//  CDAccountPopupView.h
//  CookieDD
//
//  Created by gary johnston on 3/13/14.
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
#import "SGGameCenterManager.h"


typedef enum AccountPresentationType{
    AccountPresentationType_Default,
    AccountPresentationType_Player,
    AccountPresentationType_Friend
}   AccountPresentationType;

@protocol CDAccountPopupViewDelegate;



@interface CDAccountPopupView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<CDAccountPopupViewDelegate> delegate;

@property (assign, nonatomic) BOOL leaderboardIsUp;
@property (assign, nonatomic) BOOL cancelLeaderboardButtonHit;
@property (assign, nonatomic) BOOL leaderBoardIsGlobal;
@property (assign, nonatomic) BOOL isPowerupItem;

@property (assign, nonatomic) int buttonIsOpenForRotation;
@property (assign, nonatomic) int numberOfCellsInCollectionView;

@property (assign, nonatomic) BOOL isMainGame;

// Universal
@property (weak, nonatomic) IBOutlet UIView *fadeView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *splashLeft;
@property (weak, nonatomic) IBOutlet UIImageView *splashRight;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *playerTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *inventoryTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *statsTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *accountButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *accountButtonTwo;
@property (weak, nonatomic) IBOutlet UIButton *accountButtonThree;

// Player Account Screen
@property (weak, nonatomic) IBOutlet UIView *playerAccountView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *planetAndLevelLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *googleLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *facebookLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *twitterLabel;

@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

// Inventory Screen
@property (weak, nonatomic) IBOutlet UIView *inventoryView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *coinsTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *coinCountLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *gemTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *gemCountLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *costumeTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *powerupTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *coinAddButton;
@property (weak, nonatomic) IBOutlet UIButton *gemAddButton;
@property (weak, nonatomic) IBOutlet UIButton *costumePreviousButton;
@property (weak, nonatomic) IBOutlet UIButton *powerupPreviousButton;
@property (weak, nonatomic) IBOutlet UIButton *costumeNextButton;
@property (weak, nonatomic) IBOutlet UIButton *powerupNextButton;

// Stats Screen
@property (weak, nonatomic) IBOutlet UIView *statsView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *trophyTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *friendLeaderboardTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *globalLeaderboardTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *friendLeaderboardButton;
@property (weak, nonatomic) IBOutlet UIButton *globalLeaderBoardButton;
@property (weak, nonatomic) IBOutlet UIButton *trophyPreviousButton;
@property (weak, nonatomic) IBOutlet UIButton *trophyNextButton;

@property (weak, nonatomic) IBOutlet UICollectionView *trophiesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *costumesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *powerupCollectionView;

@property (strong, nonatomic) NSArray *achievementsArray;
@property (strong, nonatomic) NSArray *achievementKeys;

// Cookie Costume Detail View...
//@property (weak, nonatomic) IBOutlet UIView *cookieCostumeDetailView;

//@property (weak, nonatomic) IBOutlet UICollectionView *cookieCostumeDetailCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *profileBackGroundImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *cookieImageView;

//@property (weak, nonatomic) IBOutlet UIButton *cookieCostumeDetailBackButton;

//@property (weak, nonatomic) IBOutlet SGStrokeLabel *cookieNameLabel;
//@property (weak, nonatomic) IBOutlet SGStrokeLabel *selectCookieTitleLabel;
//@property (weak, nonatomic) IBOutlet SGStrokeLabel *costumeDetailBackLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *backButtonTextLabel;

@property (assign, nonatomic) AccountPresentationType accountPresentationType;

// Show cookie costume selection view
@property (assign, nonatomic) BOOL showCookieCostumeSelection;

//- (IBAction)exitCookieCostumeDetailView:(id)sender;


// Universal
- (void)presentAccountScreenWithAccountInfo:(NSDictionary *)accountInfoDict
                    accountPresentationType:(AccountPresentationType)type;

- (void)setupWithParentalViewController:(UIViewController *)parentViewController;
- (void)displayLeaderboard;

- (IBAction)exitButtonHit:(id)sender;
- (IBAction)accountButtonThreeHit:(id)sender;
- (IBAction)accountButtonTwoHit:(id)sender;
- (IBAction)accountButtonOneHit:(id)sender;

// Player Account Screen
- (IBAction)googleButtonHit:(id)sender;
- (IBAction)facebookButtonHit:(id)sender;
- (IBAction)twitterButtonHit:(id)sender;

// Inventory Screen
- (IBAction)coinsAddButtonHit:(id)sender;
- (IBAction)gemAddButtonHit:(id)sender;
- (IBAction)costumeNextButtonHit:(id)sender;
- (IBAction)costumePreviousButtonHit:(id)sender;
- (IBAction)powerupNextButtonHit:(id)sender;
- (IBAction)powerupPreviousButtonHit:(id)sender;

// Stats Screen
- (IBAction)friendLeaderboardButtonHit:(id)sender;
- (IBAction)globalLeaderBoardButtonHit:(id)sender;
- (IBAction)trophyPreviousButtonHit:(id)sender;
- (IBAction)trophyNextButtonHit:(id)sender;

// Cookie Costume Detail Screen
//- (IBAction)costumeDetailScrollLeft:(id)sender;
//- (IBAction)costumeDetailScrollRight:(id)sender;

@end



@protocol CDAccountPopupViewDelegate <NSObject>

@required
- (void)exitButtonWasHitOnAccountPopup:(CDAccountPopupView *)accountView;

@optional
- (void)addCoinsButtonWasHitOnAccountPopup:(CDAccountPopupView *)accountView;

@end