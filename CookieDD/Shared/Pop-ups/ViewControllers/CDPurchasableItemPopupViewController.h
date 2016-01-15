//
//  CDPurchasableItemPopupViewController.h
//  CookieDD
//
//  Created by Gary Johnston on 5/9/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDButtonSpriteNode.h"

@protocol CDPurchasableItemPopupViewControllerDelegate;



@interface CDPurchasableItemPopupViewController : UIViewController

@property (weak, nonatomic) id<CDPurchasableItemPopupViewControllerDelegate> delegate;

@property (strong, nonatomic) CDButtonSpriteNode *buttonSprite;

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIImageView *largeGlareImage;
@property (weak, nonatomic) IBOutlet UIImageView *smallGlareImage;

@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *gemsButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *coinsButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *cancelButtonTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *coinsButton;
@property (weak, nonatomic) IBOutlet UIButton *gemsButton;

@property (assign, nonatomic) ItemType itemType;

- (void)setupUI;

- (IBAction)cancelButtonHit:(id)sender;
- (IBAction)coinsButtonHit:(id)sender;
- (IBAction)gemsButtonHit:(id)sender;

@end



@protocol CDPurchasableItemPopupViewControllerDelegate <NSObject>

@required
- (void)cancelButtonWasHitOnPurchasableItemPopup:(CDPurchasableItemPopupViewController *) purchasableItemViewController;
- (void)boughtSomethingInPurchaseableItemPopup:(CDPurchasableItemPopupViewController *) purchasableItemViewController WithItemCount:(int)itemAddedCount;

@end