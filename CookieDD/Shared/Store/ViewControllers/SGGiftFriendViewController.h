//
//  SGGiftFriendViewController.h
//  CookieDD
//
//  Created by Luke McDonald on 3/29/14.
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
#import "SGGiftFriendsCell.h"

typedef enum GiftType
{
    GiftType_Default,
    GiftType_Coins,
    GiftType_Gems,
    GiftType_Lives,
    GiftType_Moves,
    GiftType_PowerGlove,
    GiftType_WrappedCookie,
    GiftType_Bomb,
    GiftType_Smore,
    GiftType_RadioactiveSprinkle,
    GiftType_Spatula,
    GiftType_SlotMachine,
    GiftType_Thunderbolt
    
}   GiftType;

typedef enum GiftPurchaseType
{
    GiftPurchaseType_Default,
    GiftPurchaseType_Gems,
    GiftPurchaseType_Coins
} GiftPurchaseType;

@protocol SGGiftFriendViewControllerDelegate;

@interface SGGiftFriendViewController : UIViewController
<
UITableViewDataSource, UITableViewDelegate,
UIAlertViewDelegate
>

@property (weak, nonatomic) IBOutlet UIImageView *exitImageView;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (weak, nonatomic) IBOutlet UILabel *giftTitlelabel;
@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (strong, nonatomic) NSMutableArray *wrappersArray;
@property (strong, nonatomic) NSString *giftTypeString;
@property (assign, nonatomic) GiftType giftType;
@property (assign, nonatomic) int productCoinValue;
@property (assign, nonatomic) int productJewelValue;
@property (weak, nonatomic) id <SGGiftFriendViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *uhOhMessageLabel;

- (void)presentGiftPopOverViewWithPresentingViewController:(UIViewController *)parentViewController
                                                  giftType:(GiftType)giftType
                                          productCoinValue:(int)productCoinValue
                                         productJewelValue:(int)productJewelValue
                                                 giftValue:(int)giftValue;

- (void)dismissGiftPopOverViewWithPresentingViewController:(UIViewController *)parentViewController;

- (IBAction)exitGiftView:(id)sender;
@end

@protocol SGGiftFriendViewControllerDelegate <NSObject>

@optional
- (void)giftFriendViewControllerCanNotMakePurchase:(SGGiftFriendViewController *)controller;
- (void)giftFriendViewController:(SGGiftFriendViewController *)controller madePurchaseWithGiftPurchaseType:(GiftPurchaseType)giftPurchaseType;
@end
