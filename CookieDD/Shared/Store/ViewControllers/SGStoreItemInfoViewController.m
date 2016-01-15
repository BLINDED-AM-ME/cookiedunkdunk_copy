//
//  SGStoreItemInfoViewController.m
//  CookieDD
//
//  Created by Josh on 1/15/14.
//  Updated by Luke McDonald.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
// rate an app
// http://stackoverflow.com/questions/19585037/rate-and-review-within-an-app-possible-in-ios7

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

#import "SGStoreItemInfoViewController.h"
#import "CDIAPManager.h"
#import "SGAppDelegate.h"

@interface SGStoreItemInfoViewController ()

@property (assign, nonatomic) CGRect animationSourceFrame;
@property (assign, nonatomic) CGRect fullSizedPopupFrame;
@property (strong, nonatomic) UIColor *backgroundFadeColor;
@property (assign, nonatomic) float animationXScale;
@property (assign, nonatomic) float animationYScale;
@property (assign, nonatomic) CGPoint animationOriginalCenter;
@property (assign, nonatomic) CGPoint originCancleButtonPosition;
@property (assign, nonatomic) bool scaleFont;
@property (strong, nonatomic) UITapGestureRecognizer *tappGesture;

@end

@implementation SGStoreItemInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //self.fullSizedPopupFrame = self.itemPopupView.frame;
    self.backgroundFadeColor = self.faddedBackgroundView.backgroundColor;
    self.originCancleButtonPosition = self.cancelButton.frame.origin;
    self.scaleFont = NO;
    self.tappGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateOut)];
    [self.faddedBackgroundView addGestureRecognizer:self.tappGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setupUI];
    [self checkPurchaseType:self.storeItemPurchaseType];
    [self animateRaysImageViews];
    
    if (self.storeItemPurchaseType == StoreItemPurchaseType_AcceptGift || self.storeItemPurchaseType == StoreItemPurchaseType_InAppPurchase)
    {
        [self.giftImageView setHidden:YES];
        [self.giftButton setHidden:YES];
    }
    else
    {
        if ([SGAppDelegate appDelegate].isLoggedIntoFacebook)
        {
            [self.giftImageView setHidden:NO];
            [self.giftButton setHidden:NO];
        }
        else
        {
            [self.giftImageView setHidden:YES];
            [self.giftButton setHidden:YES];
        }
    }
    
    // Hide gift button until gifting is fixed
    //[self.giftImageView setHidden:YES];
    //[self.giftButton setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)setupUI
{
    self.gemsButtonTextLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17.0f];
    self.coinsButtonTextLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17.0f];
    self.cancelButtonTextLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17.0f];
    self.buyNowLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17.0f];
    [self.buyNowLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];

//    NSAttributedString *attributedText =
//    [[NSAttributedString alloc] initWithString:@"Cancel"
//                                    attributes:@{NSStrokeWidthAttributeName: [NSNumber numberWithInt:-2],
//                                                 NSStrokeColorAttributeName: [UIColor blackColor],
//                                                 NSForegroundColorAttributeName: [UIColor whiteColor]}];
//    [self.cancelButton setAttributedTitle:attributedText forState:UIControlStateNormal];
//    [self.cancelButton setAttributedTitle:attributedText forState:UIControlStateHighlighted];
//    [self.cancelButton setAttributedTitle:attributedText forState:UIControlStateSelected];

}

- (void)checkPurchaseType:(StoreItemPurchaseType)purchaseType
{
    switch (purchaseType)
    {
        case StoreItemPurchaseType_Default:
        {
            
        }
            break;
        
        case StoreItemPurchaseType_Coins:
        {
            self.gemsButtonTextLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17.0f];
            self.gemsButtonTextLabel.text = [NSString stringWithFormat:@"%i Gems", self.productJewelValue];
//            NSAttributedString *jewelAttributedText =
//            [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i Gems", self.productJewelValue]
//                                            attributes:@{NSStrokeWidthAttributeName: [NSNumber numberWithInt:-2],
//                                                         NSStrokeColorAttributeName: [UIColor blackColor],
//                                                         NSForegroundColorAttributeName: [UIColor whiteColor]}];
//            
//            [self.jewelButton setAttributedTitle:jewelAttributedText forState:UIControlStateNormal];
//            [self.jewelButton setAttributedTitle:jewelAttributedText forState:UIControlStateHighlighted];
//            [self.jewelButton setAttributedTitle:jewelAttributedText forState:UIControlStateSelected];
            
            self.coinsButtonTextLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17.0f];
            self.coinsButtonTextLabel.text = [NSString stringWithFormat:@"%i Coins", self.productCoinValue];
            
//            NSAttributedString *coinAttributedText =
//            [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i Coins", self.productCoinValue]
//                                            attributes:@{NSStrokeWidthAttributeName: [NSNumber numberWithInt:-2],
//                                                         NSStrokeColorAttributeName: [UIColor blackColor],
//                                                         NSForegroundColorAttributeName: [UIColor whiteColor]}];
//            
//            [self.coinButton setAttributedTitle:coinAttributedText forState:UIControlStateNormal];
//            [self.coinButton setAttributedTitle:coinAttributedText forState:UIControlStateHighlighted];
//            [self.coinButton setAttributedTitle:coinAttributedText forState:UIControlStateSelected];

            [self.coinButton setHidden:NO];
            [self.coinsButtonTextLabel setHidden:NO];
            [self.cancelButton setHidden:NO];
            [self.cancelButtonTextLabel setHidden:NO];
            
            CGRect frame = self.cancelButton.frame;
            frame.origin = self.originCancleButtonPosition;
            self.cancelButton.frame = frame;
            self.cancelButtonTextLabel.frame = frame;
        }
            break;
            
        case StoreItemPurchaseType_Jewels:
        {
            self.coinsButtonTextLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17.0f];
            self.coinsButtonTextLabel.text = [NSString stringWithFormat:@"%i Coins", self.productCoinValue];
//            NSAttributedString *coinAttributedText =
//            [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i Coins", self.productCoinValue]
//                                            attributes:@{NSStrokeWidthAttributeName: [NSNumber numberWithInt:-2],
//                                                         NSStrokeColorAttributeName: [UIColor blackColor],
//                                                         NSForegroundColorAttributeName: [UIColor whiteColor]}];
//            [self.coinButton setAttributedTitle:coinAttributedText forState:UIControlStateNormal];
//            [self.coinButton setAttributedTitle:coinAttributedText forState:UIControlStateHighlighted];
//            [self.coinButton setAttributedTitle:coinAttributedText forState:UIControlStateSelected];
            
            self.gemsButtonTextLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
            self.gemsButtonTextLabel.text = [NSString stringWithFormat:@"%i Gems", self.productJewelValue];
//            NSAttributedString *jewelAttributedText =
//            [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i Gems", self.productJewelValue]
//                                            attributes:@{NSStrokeWidthAttributeName: [NSNumber numberWithInt:-2],
//                                                         NSStrokeColorAttributeName: [UIColor blackColor],
//                                                         NSForegroundColorAttributeName: [UIColor whiteColor]}];
//            [self.jewelButton setAttributedTitle:jewelAttributedText forState:UIControlStateNormal];
//            [self.jewelButton setAttributedTitle:jewelAttributedText forState:UIControlStateHighlighted];
//            [self.jewelButton setAttributedTitle:jewelAttributedText forState:UIControlStateSelected];
            
            [self.jewelButton setHidden:NO];
            [self.gemsButtonTextLabel setHidden:NO];
            [self.cancelButton setHidden:NO];
            [self.cancelButtonTextLabel setHidden:NO];
            
            CGRect frame = self.cancelButton.frame;
            frame.origin = self.originCancleButtonPosition;
            self.cancelButton.frame = frame;
            self.cancelButtonTextLabel.frame = frame;
        }
            break;
        
        case StoreItemPurchaseType_InAppPurchase:
        {
            self.gemsButtonTextLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
            self.gemsButtonTextLabel.text = [NSString stringWithFormat:@"Purchase For %@", self.product.price];
//            NSAttributedString *attributedText =
//            [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Purchase For %@", self.product.price]
//                                            attributes:@{NSStrokeWidthAttributeName: [NSNumber numberWithInt:-2],
//                                                         NSStrokeColorAttributeName: [UIColor blackColor],
//                                                         NSForegroundColorAttributeName: [UIColor whiteColor]}];
            
//            [self.jewelButton setAttributedTitle:attributedText forState:UIControlStateNormal];
//            [self.jewelButton setAttributedTitle:attributedText forState:UIControlStateHighlighted];
//            [self.jewelButton setAttributedTitle:attributedText forState:UIControlStateSelected];
            
            [self.coinButton setHidden:YES];
            [self.coinsButtonTextLabel setHidden:YES];
            [self.cancelButton setHidden:NO];
            [self.cancelButtonTextLabel setHidden:NO];
            
            CGRect frame = self.cancelButton.frame;
            frame.origin = self.coinButton.frame.origin;
            self.cancelButton.frame = frame;
            self.cancelButtonTextLabel.frame = frame;
        }
            break;
        
        case StoreItemPurchaseType_AcceptGift:
        {
            self.gemsButtonTextLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17.0f];
            self.gemsButtonTextLabel.text = @" Accept Gift";
//            NSAttributedString *attributedText =
//            [[NSAttributedString alloc] initWithString:@" Accept Gift"
//                                            attributes:@{NSStrokeWidthAttributeName: [NSNumber numberWithInt:-2],
//                                                         NSStrokeColorAttributeName: [UIColor blackColor],
//                                                         NSForegroundColorAttributeName: [UIColor whiteColor]}];
//            
//            [self.jewelButton setAttributedTitle:attributedText forState:UIControlStateNormal];
//            [self.jewelButton setAttributedTitle:attributedText forState:UIControlStateHighlighted];
//            [self.jewelButton setAttributedTitle:attributedText forState:UIControlStateSelected];
            
            [self.coinButton setHidden:YES];
            [self.coinsButtonTextLabel setHidden:YES];
            [self.cancelButton setHidden:YES];
            [self.cancelButtonTextLabel setHidden:YES];

            CGRect frame = self.cancelButton.frame;
            frame.origin = self.coinButton.frame.origin;
            self.cancelButton.frame = frame;
            self.cancelButtonTextLabel.frame = frame;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Animations

- (void)animateIn
{
    [UIView animateWithDuration:0.3f animations:^{
        self.faddedBackgroundView.backgroundColor = self.backgroundFadeColor;
        self.itemPopupView.alpha = 1.0f;
    }];
}

- (void)animateInFromFrame:(CGRect)sourceFrame
{
    // We'll need this when we close later.
    self.animationSourceFrame = sourceFrame;
    self.animationOriginalCenter = self.itemPopupView.center;
    
    // Set the animation properties.
    
    // Initial staging for the popup view.
    self.fullSizedPopupFrame = self.itemPopupView.frame;
    self.animationXScale = sourceFrame.size.width / self.itemPopupView.frame.size.width;
    self.animationYScale = sourceFrame.size.height / self.itemPopupView.frame.size.height;
    
    // Place the itemPopupView over the source frame.
    self.itemPopupView.transform = CGAffineTransformScale(self.itemPopupView.transform, self.animationXScale, self.animationYScale);
    self.itemPopupView.center = CGPointMake(sourceFrame.origin.x + (sourceFrame.size.width / 2), sourceFrame.origin.y + (sourceFrame.size.height / 2));
    self.itemPopupView.alpha = 0.3f;
    
    // Turn off user interaction while the animation is in progress.
    self.itemPopupView.userInteractionEnabled = NO;
    
    // Get the transform that will make it full sized again.
    CGAffineTransform scaleUpTransform = CGAffineTransformMakeScale(1.0f, 1.0f);
    
    //
    self.faddedBackgroundView.backgroundColor = [UIColor clearColor];
    
    // Now the actual animation.
    [UIView animateWithDuration:0.3f animations:^{
        
        self.itemPopupView.transform = scaleUpTransform;
        self.itemPopupView.center = self.animationOriginalCenter;
        self.itemPopupView.alpha = 1.0f;
        self.faddedBackgroundView.backgroundColor = self.backgroundFadeColor;
        
        
    } completion:^(BOOL finished) {
        DebugLog(@"Item Popup has finished animating in.");
        self.itemPopupView.userInteractionEnabled = YES;
    }];
}

- (void)animateOutWithCompletionHandler:(AnimationCompletionHandler)handler
{
    if (self.storeItemPurchaseType == StoreItemPurchaseType_AcceptGift)
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.itemPopupView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            if (handler) handler(YES);
        }];
    }
    else
    {
        // Some quick math to start off.
        CGPoint sourceFrameCenter = CGPointMake(self.animationSourceFrame.origin.x + (self.animationSourceFrame.size.width / 2), self.animationSourceFrame.origin.y + (self.animationSourceFrame.size.height / 2));
        
        // Turn off user interaction while the animation is in progress.
        self.itemPopupView.userInteractionEnabled = NO;
        
        // Now animate
        [UIView animateWithDuration:0.3f animations:^{
            self.itemPopupView.transform = CGAffineTransformMakeScale(self.animationXScale, self.animationYScale);
            self.itemPopupView.center = sourceFrameCenter;
            self.itemPopupView.alpha = 0.3f;
            self.faddedBackgroundView.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            DebugLog(@"Item Popup has finished animating out.");
            self.itemPopupView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.itemPopupView.center = self.animationOriginalCenter;
            [self.view removeFromSuperview];
            if (handler) handler(YES);
        }];
    }
}

- (void)animateOut
{
    if (self.storeItemPurchaseType == StoreItemPurchaseType_AcceptGift)
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.itemPopupView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
        }];
    }
    else
    {
        // Some quick math to start off.
        CGPoint sourceFrameCenter = CGPointMake(self.animationSourceFrame.origin.x + (self.animationSourceFrame.size.width / 2), self.animationSourceFrame.origin.y + (self.animationSourceFrame.size.height / 2));
        
        // Turn off user interaction while the animation is in progress.
        self.itemPopupView.userInteractionEnabled = NO;
        
        // Now animate
        [UIView animateWithDuration:0.3f animations:^{
            self.itemPopupView.transform = CGAffineTransformMakeScale(self.animationXScale, self.animationYScale);
            self.itemPopupView.center = sourceFrameCenter;
            self.itemPopupView.alpha = 0.3f;
            self.faddedBackgroundView.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            DebugLog(@"Item Popup has finished animating out.");
            self.itemPopupView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.itemPopupView.center = self.animationOriginalCenter;
            [self.view removeFromSuperview];
        }];
    }
}

- (void)animateOutToFrame:(CGRect)targetFrame {
    
}

- (void)animateRaysImageViews
{
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.raysImageView.transform = CGAffineTransformRotate(self.raysImageView.transform, -M_PI);
                     }
                     completion:NULL];
    
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.smallRayImageView.transform = CGAffineTransformRotate(self.smallRayImageView.transform, M_PI);

                     }
                     completion:NULL];
}
#pragma mark - IBActions

- (IBAction)purchaseWithJewels:(id)sender
{
    [self animateOutWithCompletionHandler:^(BOOL finishedAnimation) {
        if (([[SGAppDelegate appDelegate].accountDict[@"gems"] intValue] >= _productJewelValue) && ([_gemsButtonTextLabel.text isEqualToString:[NSString stringWithFormat:@"%i Gems", self.productJewelValue]]))
        {
            self.storeItemPurchaseType = StoreItemPurchaseType_Jewels;
            
            if ([self.delegate respondsToSelector:@selector(storeItemInfoViewController:didPurchaseProductWithProductType:purchaseType:costValue:)])
            {
                [self.delegate storeItemInfoViewController:self didPurchaseProductWithProductType:self.storeItemProductType purchaseType:self.storeItemPurchaseType costValue:self.productJewelValue];
            }
        }
        else if (([[SGAppDelegate appDelegate].accountDict[@"gems"] intValue] < _productJewelValue) && ([_gemsButtonTextLabel.text isEqualToString:[NSString stringWithFormat:@"%i Gems", self.productJewelValue]]))
        {
            if ([self.delegate respondsToSelector:@selector(storeItemInfoViewControllerCannotMakePurchase:)])
            {
                [self.delegate storeItemInfoViewControllerCannotMakePurchase:self];
            }
        }
        else if (self.storeItemPurchaseType == StoreItemPurchaseType_AcceptGift)
        {
            if ([self.delegate respondsToSelector:@selector(storeItemInfoViewControllerDidAcceptGift:)])
            {
                [self.delegate storeItemInfoViewControllerDidAcceptGift:self];
            }
        }
        else if (self.storeItemPurchaseType == StoreItemPurchaseType_InAppPurchase)
        {
            if ([self.delegate respondsToSelector:@selector(storeItemInfoViewController:didPurchaseProduct:)])
            {
                [self.delegate storeItemInfoViewController:self didPurchaseProduct:self.product];
            }
        }
        else
        {
            [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.view.frame errorDescription:@"An error has occurred during your purchase. Please try a different method." loadingText:nil];
        }
    }];
}

- (IBAction)purchaseWithCoins:(id)sender
{
    // Start of 'The Investors' achievement.
//    float totalGoal = 50.00f;
//    if ([CDPlayerObject player].cumulativeDollarsSpent < totalGoal) {
//        [CDPlayerObject player].cumulativeDollarsSpent += 1.0f;
//    }
//    else {
//        [CDPlayerObject player].cumulativeDollarsSpent = totalGoal;
//    }
//    
//    float newPercentComplete = ([CDPlayerObject player].cumulativeDollarsSpent / totalGoal) * 100.0f;
//    [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"the_investors" percentComplete:newPercentComplete Completion:^(BOOL investorsReportSuccessful) {
//        if (investorsReportSuccessful) {
//            GKAchievement *theInvestors = [[SGGameCenterManager gcManager] getAchievementForIdentifier:@"the_investors"];
//            if (theInvestors.percentComplete >= 100.0f) {
//                [[SGGameCenterManager gcManager] displayAchievementAlertForAchievementWithIdentifier:@"the_investors" InView:self.view Completion:nil];
//            }
//        }
//    }];

    // end 'The Investors'

    
    [self animateOutWithCompletionHandler:^(BOOL finishedAnimation) {
        int currentCurrency = 0;
        if ([SGAppDelegate appDelegate].accountDict[@"coins"])
        {
            currentCurrency = [[SGAppDelegate appDelegate].accountDict[@"coins"] intValue];
        }
        
        if ([[CDIAPManager iapMananger] canPurchaeItemWithItemCosts:self.productCoinValue currentCurrency:currentCurrency])
        {
            self.storeItemPurchaseType = StoreItemPurchaseType_Coins;
            
            if ([self.delegate respondsToSelector:@selector(storeItemInfoViewController:didPurchaseProductWithProductType:purchaseType:costValue:)])
            {
                [self.delegate storeItemInfoViewController:self didPurchaseProductWithProductType:self.storeItemProductType purchaseType:self.storeItemPurchaseType costValue:self.productCoinValue];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(storeItemInfoViewControllerCannotMakePurchase:)])
            {
                [self.delegate storeItemInfoViewControllerCannotMakePurchase:self];
            }
        }
    }];
}

- (IBAction)cancelPurchase:(id)sender
{
    [self animateOutWithCompletionHandler:nil];
}

- (IBAction)showGiftFriendView:(id)sender
{
    [self animateOutWithCompletionHandler:^
     (BOOL finishedAnimation)
    {
        if (finishedAnimation)
        {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([weakSelf.delegate respondsToSelector:@selector(storeItemInfoViewController:didSelectGiftItemWithGiftValue:giftType:productCoinValue:productJewelValue:)])
                {
                    [weakSelf.delegate storeItemInfoViewController:weakSelf didSelectGiftItemWithGiftValue:1 giftType:weakSelf.giftType productCoinValue:weakSelf.productCoinValue productJewelValue:weakSelf.productJewelValue];
                }
            });
        }
    }];
}

@end
