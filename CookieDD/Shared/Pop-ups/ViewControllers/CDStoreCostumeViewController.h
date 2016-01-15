//
//  CDStoreCostumeViewController.h
//  CookieDD
//
//  Created by Gary Johnston on 6/20/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGStrokeLabel.h"
#import "SGAppDelegate.h"

@protocol CDStoreCostumeViewControllerDelegate;



@interface CDStoreCostumeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id <CDStoreCostumeViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *buyCostumeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UICollectionView *costumeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *cookieCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *cookiePageDots;

@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *costumeNameLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *cookieNameLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *buyButtonLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *cancelButtonLabel;

- (void)updatePageDots;

- (IBAction)exitButtonHit:(id)sender;
- (IBAction)buyCostumeButtonHit:(id)sender;
- (IBAction)cancelButtonHit:(id)sender;

@end



@protocol CDStoreCostumeViewControllerDelegate <NSObject>

@required
- (void)storeCostumeViewControllerDidExit:(CDStoreCostumeViewController *)storeCostumeViewController;
- (void)buyButtonHitInStoreCostumeViewController:(CDStoreCostumeViewController *)costumePopup WithCookieName:(NSString *)name WithCostumeTheme:(NSString *)theme;

@end