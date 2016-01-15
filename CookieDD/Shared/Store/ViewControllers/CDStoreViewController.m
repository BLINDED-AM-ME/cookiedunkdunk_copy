//
//  CDStoreViewController.m
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

#import "CDStoreViewController.h"
#import "SGAppDelegate.h"
#import "CDStandardPopupView.h"
#import "CDAccountPopupView.h"
#import "CDStoreCostumeViewController.h"
#import "CDAccountCollectionCell.h"
#import <StoreKit/StoreKit.h>

@interface CDStoreViewController () <CDMainButtonViewControllerDelegate, CDAccountPopupViewDelegate, CDStandardPopupViewDelegate, UIGestureRecognizerDelegate, SGAudioManagerDelegate, CDStoreCostumeViewControllerDelegate, LMInAppPurchaseManagerDelegate>

@property (strong, nonatomic) SGStoreItemInfoViewController *itemInfoViewController;
@property (strong, nonatomic) CDMainButtonViewController *mainButtonViewController;

@property (strong, nonatomic) PRTweenOperation *coinTweenOperation;
@property (strong, nonatomic) PRTweenOperation *gemTweenOperation;

@property (strong, nonatomic) CDStoreCostumeViewController *costumeViewController;

//@property (nonatomic, weak) CAShapeLayer *maskLayer;

@property (strong, nonatomic) NSTimer *rightScrollButtonTimer;
@property (strong, nonatomic) NSTimer *leftScrollButtonTimer;
@property (strong, nonatomic) NSTimer *animationTimer;

@property (assign, nonatomic) int scrollAmount;
@property (assign, nonatomic) int numberOfChefsBought;
@property (assign, nonatomic) int numberOfSupersBought;
@property (assign, nonatomic) int numberOfFarmersBought;
@property (assign, nonatomic) int numberOfZombiesBought;

@property (assign, nonatomic) BOOL willKeepScrollingLeft;
@property (assign, nonatomic) BOOL willKeepScrollingRight;
@property (assign, nonatomic) BOOL didEndScrolling;
@property (assign, nonatomic) BOOL didAnimateConveyerBeltOut;
@property (assign, nonatomic) BOOL didAnimateStoreDoorOut;
@property (assign, nonatomic) BOOL didAnimateStoreDoorIn;
@property (assign, nonatomic) BOOL didTouchShopKeeper;
@property (assign, nonatomic) BOOL willAnimateCurrency;
@property (assign, nonatomic) BOOL didExitStore;
@property (assign, nonatomic) BOOL accountWasOpenedByMainButton;

@property (assign, nonatomic) CGRect leftConveyerOriginRect;
@property (assign, nonatomic) CGRect rightConveyerOriginRect;
@property (assign, nonatomic) CGRect lockBaseOriginRect;
@property (assign, nonatomic) CGRect lockOriginRect;
@property (assign, nonatomic) CGRect leftSpeakerOriginRect;
@property (assign, nonatomic) CGRect leftCropViewOriginRect;

@property (strong, nonatomic) NSMutableArray *leftSpeakerLightAnimations;
@property (strong, nonatomic) NSMutableArray *rightSpeakerLightAnimations;

@property (strong, nonatomic) NSMutableArray *identifersRemovedForPowerupsArray;
@property (strong, nonatomic) NSMutableArray *identifersRemovedForCostumesArray;
@property (strong, nonatomic) NSMutableArray *identifersRemovedForCurrencyArray;
@property (strong, nonatomic) NSMutableArray *masterItemsArray;

@property (strong, nonatomic) UILongPressGestureRecognizer *tapGesture;

@property (strong, nonatomic) UIImage *rightSelectedErrorImage;
@property (strong, nonatomic) UIImage *rightSelectedImage;
@property (strong, nonatomic) UIImage *leftSelectedErrorImage;
@property (strong, nonatomic) UIImage *leftSelectedImage;

@property (strong, nonatomic) SKProduct *giftProduct;

//@property (strong, nonatomic) AVAudioPlayer *coinSoundEffect;
//@property (strong, nonatomic) AVAudioPlayer *chChingSoundEffect;
//@property (strong, nonatomic) AVAudioPlayer *beepLongSoundEffect;
//@property (strong, nonatomic) AVAudioPlayer *storeBellSoundEffect;
//@property (strong, nonatomic) AVAudioPlayer *slidingDoorOpenSoundEffect;
//@property (strong, nonatomic) AVAudioPlayer *slidingDoorCloseSoundEffect;
//@property (strong, nonatomic) AVAudioPlayer *electricDoorOpenSoundEffect;
//@property (strong, nonatomic) AVAudioPlayer *electricDoorCloseSoundEffect;
//@property (strong, nonatomic) AVAudioPlayer *errorBeepSoundEffect;
//@property (strong, nonatomic) AVAudioPlayer *click2SoundEffect;

@end

@implementation CDStoreViewController

#pragma mark - Initialization

- (void)setup
{
    _coinTweenOperation = [PRTweenOperation new];

    _gemTweenOperation = [PRTweenOperation new];
    
    _inGameitemsArray = [NSMutableArray new];
    _masterItemsArray = [NSMutableArray new];
    
    NSArray *currencyArray = [NSArray arrayWithObjects:IAPIdentifier_CoinPack1000, IAPIdentifier_CoinPack10000, IAPIdentifier_CoinPack2000, IAPIdentifier_CoinPack5000, IAPIdentifier_ExtraLives5, nil];
    NSArray *costumesArray = [NSArray arrayWithObjects:
                              IAPIdentifiers_ChefCookiePack, IAPIdentifiers_ChefDustinDoubleMint, IAPIdentifiers_ChefGerry, IAPIdentifiers_ChefJJJams, IAPIdentifiers_ChefLukeLocoLemon, IAPIdentifiers_ChefMikeMcSprinkles, IAPIdentifiers_ChefReginald,
                              IAPIdentifiers_SuperCookiePack, IAPIdentifiers_SuperChip, IAPIdentifiers_SuperDustinDoubleMint, IAPIdentifiers_SuperGerry, IAPIdentifiers_SuperHeroJJJams, IAPIdentifiers_SuperLukeLocoLemon, IAPIdentifiers_SuperMikeMcSprinkles, IAPIdentifiers_SuperReginald,
                              IAPIdentifiers_FarmerCookiePack, IAPIdentifiers_FarmerGerryJ, IAPIdentifiers_FarmerJJJams, IAPIdentifiers_FarmerLukeLocoLemon, IAPIdentifiers_FarmerMikeyMcSprinkles, IAPIdentifiers_FarmerReginald,
                              IAPIdentifiers_ZombieCookiePack, IAPIdentifiers_ZombieChip, IAPIdentifiers_ZombieDustinMartianMint, IAPIdentifiers_ZombieJJJams, IAPIdentifiers_ZombieLukeLocoLemon, IAPIdentifiers_ZombieMikeyMcSprinkles, IAPIdentifiers_ZombieReginald, nil];
    NSArray *powerupsArray = [NSArray arrayWithObjects:
                              IAPIdentifier_BombPowerup, IAPIdentifier_ExtraCoinsForTimePeriod, IAPIdentifier_ExtraCoinsForWorld, IAPIdentifier_ExtraMoves, IAPIdentifier_ExtraTime, IAPIdentifier_FortuneCookiePowerup, IAPIdentifier_LightningBooster, IAPIdentifier_NukeBooster, IAPIdentifier_RadioactiveSprinklePowerup, IAPIdentifier_SlotMachineBooster, IAPIdentifier_SmorePowerup, IAPIdentifier_SpatulaBooster, IAPIdentifier_SuperPowerup, IAPIdentifier_WrapperPowerup, nil];
    
    
    _identifersRemovedForCostumesArray = [NSMutableArray new];
    _identifersRemovedForCurrencyArray = [NSMutableArray new];
    _identifersRemovedForPowerupsArray = [NSMutableArray new];
    
    for (NSString *identifier in currencyArray)
    {
        [_identifersRemovedForPowerupsArray addObject:identifier];
        [_identifersRemovedForCostumesArray addObject:identifier];
    }
    for (NSString *identifier in costumesArray)
    {
        [_identifersRemovedForCurrencyArray addObject:identifier];
        [_identifersRemovedForPowerupsArray addObject:identifier];
    }
    for (NSString *identifier in powerupsArray)
    {
        [_identifersRemovedForCurrencyArray addObject:identifier];
        [_identifersRemovedForCostumesArray addObject:identifier];
    }
    
    _playerItemsArray = [NSMutableArray new];
    
    _worldItemsArray = [NSMutableArray new];
    
    _shopKeeperAnimationsArray = [NSMutableArray new];
    
    _touchShopKeeperAnimationsArray = [NSMutableArray new];
    
    UIImage *greenLightImage = [UIImage imageNamed:@"cdd-store-radio-active-green"];
    
    UIImage *redLightImage = [UIImage imageNamed:@"cdd-store-radio-active-red"];
    
    UIImage *disabledlightImage = [UIImage imageNamed:@"cdd-store-radio-disabled"];
    
    _leftSpeakerLightAnimations = [NSMutableArray arrayWithArray:@[redLightImage, greenLightImage, disabledlightImage, redLightImage, redLightImage, disabledlightImage]];
    
    _rightSpeakerLightAnimations = [NSMutableArray arrayWithArray:@[greenLightImage,redLightImage, greenLightImage, greenLightImage, redLightImage, redLightImage, greenLightImage, redLightImage]];
    
    _willKeepScrollingLeft = NO;
    _willKeepScrollingRight = NO;
    _didAnimateConveyerBeltOut = NO;
    _didAnimateStoreDoorOut = NO;
    _didTouchShopKeeper = NO;
    _didEndScrolling = YES;
    _willAnimateCurrency = YES;
    _didExitStore = NO;
    _accountWasOpenedByMainButton = NO;
    
    [LMInAppPurchaseManager inappPurchaseManager].delegate = self;
}


- (void)loadShopKeeperAnimations
{
    // set Sigh Animations
    
    NSMutableArray *sighAnimations = [NSMutableArray new];
    
    for (int i = 1; i < 19; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"store-reggie-sigh-%i", i]];
        [sighAnimations addObject:image];
    }
    
    [_shopKeeperAnimationsArray addObject:sighAnimations];
    
    // set Jump Animations
    
    NSMutableArray *jumpAnimations = [NSMutableArray new];
    
    for (int i = 1; i < 16; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"store-reggie-jump-%i", i]];
        [jumpAnimations addObject:image];
    }
    
    [_shopKeeperAnimationsArray addObject:jumpAnimations];
    
    // set Roll Eyes Animations
    
    NSMutableArray *rollEyeAnimations = [NSMutableArray new];
    
    for (int i = 1; i < 2; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"store-reggie-eyeroll-%i", i]];
        [rollEyeAnimations addObject:image];
    }
    
    // [_shopKeeperAnimationsArray addObject:rollEyeAnimations];
  
    // set Sneer Animations
    
    NSMutableArray *sneerAnimations = [NSMutableArray new];
    
    for (int i = 1; i < 11; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"store-reggie-sneer-%i", i]];
        [sneerAnimations addObject:image];
    }
    
    [_touchShopKeeperAnimationsArray addObject:sneerAnimations];
    
    // set Wide Eyes Animations
    
    NSMutableArray *wideEyesAnimations = [NSMutableArray new];
    
    for (int i = 1; i < 2; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"store-reggie-wide-%i", i]];
        [wideEyesAnimations addObject:image];
    }
    
    [_touchShopKeeperAnimationsArray addObject:wideEyesAnimations];
    
    self.shopKeeperImageView.animationRepeatCount = 1;
    
    self.shopKeeperImageView.animationDuration = 1.2f;
}

- (void)dealloc
{
    if (_rightScrollButtonTimer)
    {
        [_rightScrollButtonTimer invalidate];
        _rightScrollButtonTimer = nil;
    }
    
    if (_leftScrollButtonTimer)
    {
        [_leftScrollButtonTimer invalidate];
        _leftScrollButtonTimer = nil;
    }
    
    self.itemInfoViewController = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.blackView.alpha = 0;
    
    // Setup the button
    _mainButtonViewController = [[CDMainButtonViewController mainButton] didCreateMainButtonViewWithParentalViewController:self];
    _mainButtonViewController.delegate = self;
    [_mainButtonViewController.view setAlpha:0.0f];
    
    
    if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        _mainButtonViewController.parentViewFrame = self.view.frame;
        _mainButtonViewController.conditionalViewFrame = self.view.frame;
    }
    else
    {
        _mainButtonViewController.parentViewFrame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        _mainButtonViewController.conditionalViewFrame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }
    
    UIViewController *disposableViewController = [UIViewController new];
    [self presentViewController:disposableViewController animated:NO completion:^{
        
    }];
    
    __weak typeof(self) weakSelf = self;
    
    double delayInSeconds = .5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                
                [weakSelf makeThingsRight];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.blackView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [weakSelf.blackView removeFromSuperview];
                    }];
                });
            }];
        });
    });
}

- (void)makeThingsRight
{
    _didExitStore = NO;
    
    [self placeDoors];
    
    [self.exitStoreSignButton setEnabled:YES];
    
    _shopKeeperIdleImage = [UIImage imageNamed:@"store-reggie"];
    
    [self loadShopKeeperAnimations];
    
    if (IS_IPHONE_5)
    {
        CGRect leftConveyerRect = self.leftConveyerCoverImageView.frame;
        CGRect rightConveyerRect = self.rightConveyerCoverImageView.frame;
        //        if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        //        {
        leftConveyerRect.origin.x = self.leftConveyerCoverImageView.frame.origin.x+45.0f;
        rightConveyerRect.origin.x = self.rightConveyerCoverImageView.frame.origin.x-45.0f;
        //        }
        //        else
        //        {
        //
        //        }
        
        self.leftConveyerCoverImageView.frame = leftConveyerRect;
        self.rightConveyerCoverImageView.frame = rightConveyerRect;
    }
    else if (IS_IPHONE_4)
    {
        DebugLog(@"iPhone 4");
    }
    else if (IS_IPAD)
    {
        DebugLog(@"iPad");
    }
    else
    {
        CGRect leftConveyerRect = self.leftConveyerCoverImageView.frame;
        CGRect rightConveyerRect = self.rightConveyerCoverImageView.frame;
        //        if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        //        {
        leftConveyerRect.origin.x = self.leftConveyerCoverImageView.frame.origin.x+45.0f;
        rightConveyerRect.origin.x = self.rightConveyerCoverImageView.frame.origin.x-45.0f;
        //        }
        //        else
        //        {
        //            leftConveyerRect.origin.x = self.leftConveyerCoverImageView.frame.origin.x+45.0f;
        //            rightConveyerRect.origin.x = self.rightConveyerCoverImageView.frame.origin.x-45.0f;
        //        }
        
        self.leftConveyerCoverImageView.frame = leftConveyerRect;
        self.rightConveyerCoverImageView.frame = rightConveyerRect;
    }
    
    self.navigationController.navigationBarHidden = YES;
    
    //[[SGAudioManager audioManager].player stop];
    [[SGAudioManager audioManager] stopTheMusic];
    // Mask blurred image
    
    //    CGRect leftFrame = self.leftCropView.frame;
    //    leftFrame.origin.y = self.leftCropView.frame.origin.y-10.0f;
    //    self.leftCropView.frame = leftFrame;
    //
    //    CGRect rightFrame = self.rightCropView.frame;
    //    rightFrame.origin.y = self.rightCropView.frame.origin.y-10.0f;
    //    self.rightCropView.frame = rightFrame;
    
    
    self.leftCropView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.rightCropView.frame = CGRectMake(self.view.frame.size.width, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    self.leftCropViewOriginRect = self.leftCropView.frame;
    self.leftSpeakerOriginRect = self.leftSpeakerImageView.frame;
    
    //    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    //
    //    self.storeBlurredImageView.layer.mask = maskLayer;
    //
    //    self.maskLayer = maskLayer;
    
    //    [self updateCirclePathWithRectOne:self.leftCropView.frame rectTwo:self.rightCropView.frame];
    
    _quitButton.hidden = YES;
    
    // Preload as necessary.
    self.itemInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SGStoreItemInfoViewController"];
    self.itemInfoViewController.delegate = self;
    
    
    
    [[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"ElevatorThemeCDD2" FileType:@"caf" volume:1.0f numberOfLoopes:-1];
    [SGAudioManager audioManager].delegate = self;
    [self animateStoreDoorsOut];
    
    
    [self didSelectGameSection:self.gameSectionButton];
    
    [CDIAPManager iapMananger].delegate = self;
    
    [[CDIAPManager iapMananger] requestProducts];
    
    [self setupStoreConveyerBelt];
    //[self animateRightSpeaker];
    
    self.leftSelectedErrorImage = [UIImage imageNamed:@"store-redarrow-left"];
    self.leftSelectedImage = [UIImage imageNamed:@"scrollarrow-left-active"];
    
    self.rightSelectedErrorImage = [UIImage imageNamed:@"store-redarrow-right"];
    self.rightSelectedImage = [UIImage imageNamed:@"scrollarrow-right-active"];
    
    self.tapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(animateTouchShopKeeper)];
    self.tapGesture.minimumPressDuration = 0.1;
    
    [self.shopKeeperImageView addGestureRecognizer:self.tapGesture];
    
    // Initialize our timers
    
    _rightScrollButtonTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(keepScrollingRight) userInfo:nil repeats:YES];
    
    _leftScrollButtonTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(keepScrollingLeft) userInfo:nil repeats:YES];
    
    self.registerLabel.font = [UIFont fontWithName:@"PhonepadTwo" size:5.0f];
    
    NSAttributedString *restoreAttributedText =
    [[NSAttributedString alloc] initWithString:@"Restore"
                                    attributes:@{NSStrokeWidthAttributeName: [NSNumber numberWithInt:-6],
                                                 NSStrokeColorAttributeName: [UIColor blackColor],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    //self.restoreButton.hidden = YES;
    [self.restoreButton setAttributedTitle:restoreAttributedText forState:UIControlStateNormal];
    self.restoreButton.titleLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:16.0f];
    
    //    [_statsLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    //    [_playerLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    //    [_inventoryLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    
    [_costumesLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:13]];
    [_powerupsLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:13]];
    [_currencyLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:13]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitApp) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterApp) name:UIApplicationDidBecomeActiveNotification object:nil];
    
#if DevModeActivated
    self.addCoinsCheatButton.hidden = NO;
    self.addGemsCheatButton.hidden = NO;
#else
    self.addCoinsCheatButton.hidden = YES;
    self.addGemsCheatButton.hidden = YES;
#endif
    
    
    _numberOfChefsBought = 0;
    _numberOfSupersBought = 0;
    _numberOfFarmersBought = 0;
    _numberOfZombiesBought = 0;
    
    
    _currencyTabButton.userInteractionEnabled = NO;
    _costumesTabButton.userInteractionEnabled = NO;
    _powerupTabButton.userInteractionEnabled = NO;
}


-(void)viewDidAppear:(BOOL)animated
{
    [self animateRightSpeaker];
    [self animateStarScrollImageview];
}


- (void)placeDoors
{
    CGRect doorRect;
    
    doorRect = self.rightDoorImageView.frame;
    doorRect = self.leftDoorImageView.frame;
    
    CGPoint masterMidpoint;
    if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        masterMidpoint = CGPointMake(CGRectGetMidY(self.view.frame), CGRectGetMidX(self.view.frame));
        doorRect.origin = CGPointMake(IS_IPHONE_5? 36.0f : 80.0f, 0.0f);  // 560: 36.0f ; 480: 80.0f
    }
    else
    {
        masterMidpoint = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
        doorRect.origin = CGPointMake(masterMidpoint.x, 0.0f);
    }
    
    self.rightDoorImageView.frame = doorRect;
    
    doorRect.origin = CGPointMake(masterMidpoint.x - doorRect.size.width, 0.0f);
    self.leftDoorImageView.frame = doorRect;
    
    DebugLog(@"Done.");
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([SGAppDelegate appDelegate].accountDict[@"didRecieveGift"] && !_didExitStore)
    {
        BOOL didRecieveGift = [[SGAppDelegate appDelegate].accountDict[@"didRecieveGift"] boolValue];
        
        if (didRecieveGift)
        {
            [self.supportUsBowlImageView setHidden:NO];
            [self.grandOpeningGiftImageView setHidden:YES];
        }
        else
        {
            [self.supportUsBowlImageView setHidden:YES];
            [self.grandOpeningGiftImageView setHidden:NO];
            
            UITapGestureRecognizer *giftTapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showItemViewWithGift)];
            [self.grandOpeningGiftImageView addGestureRecognizer:giftTapper];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Invalidate and remove timers
    [self.animationTimer invalidate];
    self.animationTimer = nil;
    
    [self.leftScrollButtonTimer invalidate];
    self.leftScrollButtonTimer = nil;
    
    [self.rightScrollButtonTimer invalidate];
    self.rightScrollButtonTimer = nil;
    
    // Remove Tween operations
    [[PRTween sharedInstance] removeTweenOperation:_coinTweenOperation];
    [[PRTween sharedInstance] removeTweenOperation:_gemTweenOperation];
    self.coinTweenOperation = nil;
    self.gemTweenOperation = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)exitApp
{
    DebugLog(@"Exiting App from Store");
}

- (void)enterApp
{
    DebugLog(@"Entering App from Store");
    [self animateRightSpeaker];
    [self animateStarScrollImageview];
}

#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    if (_didExitStore)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (_presentRight)
    {
        return UIInterfaceOrientationLandscapeRight;
    }
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (_mainButtonViewController)
    {
        [_mainButtonViewController orientationHasChanged:toInterfaceOrientation WithDuration:duration];
    }
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_inGameitemsArray count];
}

#pragma mark - UICollectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CDStoreItemCell";
    CDStoreItemCell *cell = (CDStoreItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([_inGameitemsArray count] > 0)
    {
        SKProduct *product = (SKProduct *)_inGameitemsArray[indexPath.row];
        
        [self configureCell:cell product:product];
    }
    
    return cell;
}

- (void)configureCell:(CDStoreItemCell *)cell product:(SKProduct *)product
{
    cell.productPriceLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:16.0f];
    
    cell.product = product;
    
    cell.productTitle = product.localizedTitle;
    
    cell.productDescription = product.localizedDescription;
    
    cell.productPrice = [NSString stringWithFormat:@"%@",product.price];
    
    cell.productPriceLabel.text = cell.productPrice;
    
    DebugLog(@"productTitle: %@ /n productDescription: %@  /n productPrice: %@", cell.productTitle, cell.productDescription, cell.productPrice);
    
    if ([product.productIdentifier isEqualToString:IAPIdentifier_BombPowerup])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-bomb"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_BombPowerup;
        
        self.giftProduct = product;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_CoinPack1000])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_CoinPack1000;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_CoinPack2000])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_CoinPack2000;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_CoinPack5000])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_CoinPack5000;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_CoinPack10000])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_CoinPack10000;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_ExtraCoinsForTimePeriod])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-gemstime"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_ExtraCoinsForTimePeriod;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_ExtraCoinsForWorld])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-gemslevel"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_ExtraCoinsForWorld;
    }
//    else if ([product.productIdentifier isEqualToString:IAPIdentifier_ExtraLives3])
//    {
//        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-xtralives"];
//        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
//        
//        cell.purchaseType = StoreItemCellPurchaseType_Coins;
//        cell.productType = StoreItemCellProductType_ExtraLives3;
//    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_ExtraLives5])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-xtralives-5"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ExtraLives5;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_ExtraMoves])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_ExtraMoves;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_ExtraTime])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-xtratime"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_ExtraTime;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_FortuneCookiePowerup])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-fortune"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        
        // note fortune cookie not yet added into main game.
        // must see what is going on with fortune cookie related to the main game..
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_LightningBooster])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-lightning"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_LighteningBooster;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_NukeBooster])
    {
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-bomb"];
        
        cell.productType = StoreItemCellProductType_NukeBooster;
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;

        // NOTE
        // Unfinished product needs finishing!!!
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_RadioactiveSprinklePowerup])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"item-nuke-sprinkles"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_RadioActiveSprinklePowerup;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_SlotMachineBooster])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-slots"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_SlotMachineBooster;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_SmorePowerup])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-smores"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_SmorePowerup;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_SpatulaBooster])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-spatula"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_SpatulaBooster;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_SuperPowerup])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-super"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_SuperPowerup;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifier_WrapperPowerup])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-wrapped"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-coins"];
        
        cell.purchaseType = StoreItemCellPurchaseType_Coins;
        cell.productType = StoreItemCellProductType_WrapperPowerup;
    }
    
    // cookie packs....
    ///////////////
    //// Chefs ////
    ///////////////
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ChefCookiePack])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-shopicon-milky-costumepack"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ChefCookiePack;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ChefDustinDoubleMint])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-chefdustin"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ChefDustinDoubleMint;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ChefGerry])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-chefgerry"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ChefGerry;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ChefJJJams])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-chefjj"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ChefJJJams;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ChefLukeLocoLemon])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-chefluke"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ChefLukeLocoLemon;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ChefMikeMcSprinkles])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-chefmikey"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ChefMikeMcSprinkles;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ChefReginald])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-chefreggie"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ChefReginald;
    }
    
    ////////////////
    //// Supers ////
    ////////////////
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_SuperChip])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-superchip"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_SuperChip;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_SuperReginald])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-superreggie"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_SuperReginald;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_SuperLukeLocoLemon])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-superluke"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_SuperLukeLocoLemon;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_SuperDustinDoubleMint])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-superdustin"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_SuperDustinDoubleMint;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_SuperGerry])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-supergerry"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_SuperGerry;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_SuperHeroJJJams])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-superjj"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_SuperSuperJJJams;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_SuperMikeMcSprinkles])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-supermikey"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_SuperMikeMcSprinkles;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_SuperCookiePack])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-shopicon-dunk-costumepack"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_SuperCookiePack;
    }
    
    /////////////////
    //// Farmers ////
    /////////////////
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_FarmerChip])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-farmerchip"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_FarmerChip;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_FarmerGerryJ])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-farmergerry"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_FarmerGerryJ;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_FarmerJJJams])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-farmerjj"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_FarmerJJJamz;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_FarmerLukeLocoLemon])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-farmerluke"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_FarmerLukeLocoLemon;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_FarmerMikeyMcSprinkles])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-farmermikey"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_FarmerMikeyMcSprinkles;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_FarmerReginald])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-farmerreggie"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_FarmerReginald;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_FarmerCookiePack])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-allfarmers"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_FarmerCookiePack;
    }
    
    /////////////////
    //// Zombies ////
    /////////////////
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ZombieChip])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-zombieschip"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ZombieChip;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ZombieDustinMartianMint])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-zombiesdustin"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];

        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ZombieDustinDoubleMint;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ZombieJJJams])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-zombiesjj"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ZombieJJJamz;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ZombieLukeLocoLemon])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-zombiesluke"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ZombieLukeLocoLemon;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ZombieMikeyMcSprinkles])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-zombiesmikey"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ZombieMikeyMcSprinkles;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ZombieReginald])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-zombiesreggie"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ZombieReginald;
    }
    else if ([product.productIdentifier isEqualToString:IAPIdentifiers_ZombieCookiePack])
    {
        cell.itemImageView.image = [UIImage imageNamed:@"cdd-store-icon-allzombies"];
        cell.priceTagImageView.image = [UIImage imageNamed:@"cdd-store-price-cash"];
        
        cell.purchaseType = StoreItemCellPurchaseType_InAppPurchase;
        cell.productType = StoreItemCellProductType_ZombieCookiePack;
    }
    
    [cell configureInGameCurrensySystem];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DebugLog(@"Tapped an item.");
    
    self.itemInfoViewController.view.frame = self.view.frame;
    
    CDStoreItemCell *cell = (CDStoreItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    CGRect targetFrame = [cell convertRect:cell.bounds toView:self.view];
    
    [self.itemInfoViewController animateInFromFrame:targetFrame];
    
    self.itemInfoViewController.itemInfoLabel.text = cell.productDescription;
    
    self.itemInfoViewController.itemIconImageView.image = cell.itemImageView.image;
    
    self.itemInfoViewController.buyNowLabel.text = cell.productTitle;
    
    self.itemInfoViewController.itemPriceLabel.text = cell.productPrice;
    
    self.itemInfoViewController.product = cell.product;
    
    self.itemInfoViewController.storeItemPurchaseType = (StoreItemPurchaseType)cell.purchaseType;
    
    self.itemInfoViewController.storeItemProductType = (StoreItemProductType)cell.productType;
    
    self.itemInfoViewController.productCoinValue = cell.productCoinValue;
    
    self.itemInfoViewController.productJewelValue = cell.productJewelValue;
    
    //self.itemInfoViewController.parentPresentingViewController = self;
    
    self.itemInfoViewController.giftType = [self setItemGiftType:cell];
    
    [self.view addSubview:self.itemInfoViewController.view];
}


- (GiftType)setItemGiftType:(CDStoreItemCell *)cell
{
    GiftType giftType = GiftType_Default;
    
    switch (cell.productType)
    {
        case StoreItemCellProductType_Default:
        {
            
        }
            break;
        
        case StoreItemCellProductType_BombPowerup:
        {
            giftType = GiftType_Bomb;
        }
            break;
            
        case StoreItemCellProductType_CoinPack1000:
        {
            giftType = GiftType_Coins;
        }
            break;
            
        case StoreItemCellProductType_CoinPack2000:
        {
            giftType = GiftType_Coins;
        }
            break;
            
        case StoreItemCellProductType_CoinPack5000:
        {
            giftType = GiftType_Coins;
        }
            break;
            
        case StoreItemCellProductType_CoinPack10000:
        {
            giftType = GiftType_Coins;
        }
            break;
            
        case StoreItemCellProductType_ExtraCoinsForTimePeriod:
        {
            
        }
            break;
        
        case StoreItemCellProductType_ExtraCoinsForWorld:
        {
            
        }
            break;
            
        case StoreItemCellProductType_ExtraLives3:
        {
            giftType = GiftType_Lives;
        }
            break;
            
        case StoreItemCellProductType_ExtraLives5:
        {
            giftType = GiftType_Lives;
        }
            break;
            
        case StoreItemCellProductType_ExtraMoves:
        {
            giftType = GiftType_Moves;
        }
            break;
            
        case StoreItemCellProductType_ExtraTime:
        {
            
        }
            break;
            
        case StoreItemCellProductType_LighteningBooster:
        {
            giftType = GiftType_Thunderbolt;
        }
            break;
            
        case StoreItemCellProductType_NukeBooster:
        {

        }
            break;
            
        case StoreItemCellProductType_RadioActiveSprinklePowerup:
        {
            giftType = GiftType_RadioactiveSprinkle;
        }
            break;
            
        case StoreItemCellProductType_SlotMachineBooster:
        {
            giftType = GiftType_SlotMachine;
        }
            break;
            
        case StoreItemCellProductType_SmorePowerup:
        {
            giftType = GiftType_Smore;
        }
            break;
            
        case StoreItemCellProductType_SpatulaBooster:
        {
            giftType = GiftType_Spatula;
        }
            break;
            
        case StoreItemCellProductType_SuperPowerup:
        {
            giftType = GiftType_PowerGlove;
        }
            break;
            
        case StoreItemCellProductType_WrapperPowerup:
        {
            giftType = GiftType_WrappedCookie;
        }
            break;
            
        default:
            break;
    }
    
    return giftType;
}


#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[_beepLongSoundEffect play];
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Item-Beep-Long" FileType:@"wav"];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.storeItemsCollectionView)
    {
        //[_beepLongSoundEffect play];
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Item-Beep-Long" FileType:@"wav"];
        
        switch (self.scrollDirection)
        {
            case ScrollDirection_Default:
            {
                
            }
                break;
                
            case ScrollDirection_Left:
            {
                self.scrollAmount -= 150.0f;
            }
                break;
                
            case ScrollDirection_Right:
            {
                self.scrollAmount += 150.0f;
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 1)
        {
            [[CDIAPManager iapMananger] restoreInAppPurchases];
        }
    }
}

//#pragma mark - SGAudioManagerDelegate
//
//- (void)audioManager:(SGAudioManager *)audioManager didFinishPlayingSoundWithAudioPLayer:(AVAudioPlayer *)player
//{
//    if (player == _coinSoundEffect)
//    {
//        //[_chChingSoundEffect play];
//        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cha-Ching-2!" FileType:@"m4a"];
//    }
//}

#pragma mark - SGStoreItemInfoViewControllerDelegate

- (void)storeItemInfoViewController:(SGStoreItemInfoViewController *)controller didPurchaseProduct:(SKProduct *)product
{
    [[CDIAPManager iapMananger] purchaseProduct:product];
}

// NOTE
// Minus the cost value from either jewel or coin
// and send that value though webservices to update the account info...

- (void)storeItemInfoViewController:(SGStoreItemInfoViewController *)controller
  didPurchaseProductWithProductType:(StoreItemProductType)productType
                       purchaseType:(StoreItemPurchaseType)purchaseType
                          costValue:(int)costValue
{
    CostType costType = CostType_Default;
    
    BOOL isPurchaseCoin = NO;
    
    BOOL isPurchaseGem = NO;
    
    switch (purchaseType)
    {
        case StoreItemPurchaseType_Default:
        {
            
        }
            break;
        
        case StoreItemPurchaseType_Coins:
        {
            costType = CostType_Coins;
            isPurchaseCoin = YES;
        }
            break;
            
        case StoreItemPurchaseType_InAppPurchase:
        {
            
        }
            break;
            
        case StoreItemPurchaseType_Jewels:
        {
           costType = CostType_Gems;
           isPurchaseGem = YES;
        }
            break;
            
        default:
            break;
    }
    
    switch (productType)
    {
        case StoreItemProductType_Default:
        {
            
        }
            break;
        
        case StoreItemProductType_BombPowerup:
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil
                                                                        wrappedCookieValue:nil
                                                                                 bombValue:[NSNumber numberWithInt:3]
                                                                                smoreValue:nil
                                                                                 costValue:[NSNumber numberWithInt:costValue]
                                                                                  costType:costType
                                                                         completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
             {
                 if (!error && updatedGameParametersDict)
                 {
                     __weak typeof(self) weakSelf = self;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self animateCoinPurchaseType:isPurchaseCoin
                                       gemPurchaseType:isPurchaseGem
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                     });
                 }
            }];
            
        }
            break;
        
        case StoreItemProductType_CoinPack1000:
        {
            
        }
            break;
            
        case StoreItemProductType_CoinPack2500:
        {
            
        }
            break;
            
        case StoreItemProductType_CoinPack5000:
        {
            
        }
            break;
            
        case StoreItemProductType_CoinPack10000:
        {
            
        }
            break;
            
        case StoreItemProductType_ExtraCoinsForTimePeriod:
        {
            [[CDIAPManager iapMananger] requestToAddTimeMultiplierWithMultiplierType:MultipliersType_Gems
                                                                           costValue:[NSNumber numberWithInt:costValue]
                                                                            costType:costType
                                                                   completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
            {
                if (!error)
                {
//                    _inGameitemsArray = [[CDIAPManager iapMananger] filteredProducts:_inGameitemsArray];
                    
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.storeItemsCollectionView reloadData];

                        [self animateCoinPurchaseType:isPurchaseCoin
                                      gemPurchaseType:isPurchaseGem
                                       coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                         coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                        gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                          gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                    animationDuration:1.0f
                              willAnimateCoinsAndGems:YES];
                    });
                }
            }];

        }
            break;
            
        case StoreItemProductType_ExtraCoinsForWorld:
        {
            
            [[CDIAPManager iapMananger] requestToAddLevelMultiplierWithMultiplierType:MultipliersType_Gems
                                                                            costValue:[NSNumber numberWithInt:costValue]
                                                                             costType:costType
                                                                    completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
            {
                if (!error)
                {
//                    _inGameitemsArray = [[CDIAPManager iapMananger] filteredProducts:_inGameitemsArray];
                    
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.storeItemsCollectionView reloadData];
                        
                        [weakSelf animateCoinPurchaseType:isPurchaseCoin
                                      gemPurchaseType:isPurchaseGem
                                       coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                         coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                        gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                          gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                    animationDuration:1.0f
                              willAnimateCoinsAndGems:YES];
                    });
                }
            }];
        }
            break;
//            
//        case StoreItemProductType_ExtraLives3:
//        {
//            [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:3]
//                                                          costValue:[NSNumber numberWithInt:costValue]
//                                                           costType:costType
//                                                  completionHandler:^
//             (NSError *error, NSDictionary *updatedGameParametersDict)
//             {
//                 if (!error && updatedGameParametersDict)
//                 {
//                     __weak typeof(self) weakSelf = self;
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         [weakSelf animateCoinPurchaseType:isPurchaseCoin
//                                       gemPurchaseType:isPurchaseGem
//                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
//                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
//                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
//                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
//                                     animationDuration:1.0f
//                               willAnimateCoinsAndGems:YES];
//                     });
//                 }
//            }];
//        }
//            break;
            
//        case StoreItemProductType_ExtraLives5:
//        {
//            [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:5]
//                                                          costValue:[NSNumber numberWithInt:costValue]
//                                                           costType:costType
//                                                  completionHandler:^
//             (NSError *error, NSDictionary *updatedGameParametersDict)
//             {
//                 if (!error && updatedGameParametersDict)
//                 {
//                     __weak typeof(self) weakSelf = self;
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         [weakSelf animateCoinPurchaseType:isPurchaseCoin
//                                           gemPurchaseType:isPurchaseGem
//                                            coinStartValue:[weakSelf.coinCountLabel.text intValue]
//                                              coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
//                                             gemStartValue:[weakSelf.gemCountLabel.text intValue]
//                                               gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
//                                         animationDuration:1.0f
//                                   willAnimateCoinsAndGems:YES];
//                     });
//                 }
//             }];
//        }
//            break;
            
        case StoreItemProductType_ExtraMoves:
        {
            [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:5]
                                                          costValue:[NSNumber numberWithInt:costValue]
                                                           costType:costType
                                                  completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
            {
                if (!error && updatedGameParametersDict)
                {
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf animateCoinPurchaseType:isPurchaseCoin
                                      gemPurchaseType:isPurchaseGem
                                       coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                         coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                        gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                          gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                    animationDuration:1.0f
                              willAnimateCoinsAndGems:YES];
                    });
                }
            }];
        }
            break;
            
        case StoreItemProductType_ExtraTime:
        {
            
        }
            break;
            
        case StoreItemProductType_LighteningBooster:
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil
                                                                                       spatulaValue:nil
                                                                                   slotMachineValue:nil
                                                                                   thunderboltValue:[NSNumber numberWithInt:3]
                                                                                          nukeValue:nil
                                                                                          costValue:[NSNumber numberWithInt:costValue]
                                                                                           costType:costType
                                                                                  completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
            {
                if (!error && updatedGameParametersDict)
                {
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf animateCoinPurchaseType:isPurchaseCoin
                                      gemPurchaseType:isPurchaseGem
                                       coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                         coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                        gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                          gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                    animationDuration:1.0f
                              willAnimateCoinsAndGems:YES];
                    });
                }
            }];
        }
            break;
            
        case StoreItemProductType_NukeBooster:
        {
            
        }
            break;
            
        case StoreItemProductType_RadioActiveSprinklePowerup:
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:[NSNumber numberWithInt:3]
                                                                                       spatulaValue:nil
                                                                                   slotMachineValue:nil
                                                                                   thunderboltValue:nil
                                                                                          nukeValue:nil
                                                                                          costValue:[NSNumber numberWithInt:costValue]
                                                                                           costType:costType
                                                                                  completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
             {
                 if (!error && updatedGameParametersDict)
                 {
                     __weak typeof(self) weakSelf = self;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [weakSelf animateCoinPurchaseType:isPurchaseCoin
                                       gemPurchaseType:isPurchaseGem
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                     });
                 }
             }];
        }
            break;
            
        case StoreItemProductType_SlotMachineBooster:
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil
                                                                                       spatulaValue:nil
                                                                                   slotMachineValue:[NSNumber numberWithInt:3]
                                                                                   thunderboltValue:nil
                                                                                          nukeValue:nil
                                                                                          costValue:[NSNumber numberWithInt:costValue]
                                                                                           costType:costType
                                                                                  completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
             {
                 if (!error && updatedGameParametersDict)
                 {
                     __weak typeof(self) weakSelf = self;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [weakSelf animateCoinPurchaseType:isPurchaseCoin
                                       gemPurchaseType:isPurchaseGem
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                     });
                 }
             }];
        }
            break;
            
        case StoreItemProductType_SmorePowerup:
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil
                                                                        wrappedCookieValue:nil
                                                                                 bombValue:nil
                                                                                smoreValue:[NSNumber numberWithInt:5]
                                                                                 costValue:[NSNumber numberWithInt:costValue]
                                                                                  costType:costType
                                                                         completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
             {
                 if (!error && updatedGameParametersDict)
                 {
                     __weak typeof(self) weakSelf = self;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [weakSelf animateCoinPurchaseType:isPurchaseCoin
                                       gemPurchaseType:isPurchaseGem
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                     });
                 }
             }];
        }
            break;
            
        case StoreItemProductType_SpatulaBooster:
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil
                                                                                       spatulaValue:[NSNumber numberWithInt:3]
                                                                                   slotMachineValue:nil
                                                                                   thunderboltValue:nil
                                                                                          nukeValue:nil
                                                                                          costValue:[NSNumber numberWithInt:costValue]
                                                                                           costType:costType
                                                                                  completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
             {
                 if (!error && updatedGameParametersDict)
                 {
                     __weak typeof(self) weakSelf = self;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [weakSelf animateCoinPurchaseType:isPurchaseCoin
                                       gemPurchaseType:isPurchaseGem
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                     });
                 }
             }];
        }
            break;
            
        case StoreItemProductType_SuperPowerup:
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:[NSNumber numberWithInt:5]
                                                                        wrappedCookieValue:nil
                                                                                 bombValue:nil
                                                                                smoreValue:nil
                                                                                 costValue:[NSNumber numberWithInt:costValue]
                                                                                  costType:costType
                                                                         completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
             {
                 if (!error && updatedGameParametersDict)
                 {
                     __weak typeof(self) weakSelf = self;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [weakSelf animateCoinPurchaseType:isPurchaseCoin
                                       gemPurchaseType:isPurchaseGem
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                     });
                 }
             }];
        }
            break;
            
        case StoreItemProductType_WrapperPowerup:
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil
                                                                        wrappedCookieValue:[NSNumber numberWithInt:5]
                                                                                 bombValue:nil
                                                                                smoreValue:nil
                                                                                 costValue:[NSNumber numberWithInt:costValue]
                                                                                  costType:costType
                                                                         completionHandler:^
             (NSError *error, NSDictionary *updatedGameParametersDict)
             {
                 if (!error && updatedGameParametersDict)
                 {
                     __weak typeof(self) weakSelf = self;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [weakSelf animateCoinPurchaseType:isPurchaseCoin
                                       gemPurchaseType:isPurchaseGem
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                     });
                 }
             }];
        }
            break;
            
        default:
            break;
    }
}

- (void)storeItemInfoViewControllerCannotMakePurchase:(SGStoreItemInfoViewController *)controller
{
    [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self
                                                                    withConditionType:ConditionalType_InsufficentFunds
                                                                     presentationType:PresentationType_Error
                                                                            withFrame:self.view.frame
                                                                     errorDescription:nil loadingText:nil];
}

- (void)storeItemInfoViewController:(SGStoreItemInfoViewController *)controller didSelectGiftItemWithGiftValue:(int)giftValue
                           giftType:(GiftType)giftType
                   productCoinValue:(int)productCoinValue
                  productJewelValue:(int)productJewelValue
{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SGGiftFriendViewController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"SGGiftFriendViewController"];
        
        controller.delegate = weakSelf;
        
        [controller presentGiftPopOverViewWithPresentingViewController:weakSelf
                                                              giftType:giftType
                                                      productCoinValue:productCoinValue
                                                     productJewelValue:productJewelValue
                                                             giftValue:giftValue];
    });
}

- (void)storeItemInfoViewControllerDidAcceptGift:(SGStoreItemInfoViewController *)controller
{
    DebugLog(@"storeItemInfoViewControllerDidAcceptGift:");
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary new];
    
    parametersDict[@"nuke"] = [NSNumber numberWithInt:1];
    
    [[WebserviceManager sharedManager] requestAcceptGiftWithEmail:[[SGAppDelegate appDelegate]
                                                                   fetchPlayerEmail] deviceId:[[SGAppDelegate appDelegate]
                                                                                               fetchPlayerDeviceID]
                                                       parameters:parametersDict completionHandler:^
     (NSError *error, NSDictionary *acceptedGiftInfo)
    {
        if (!error && acceptedGiftInfo)
        {
            if ([SGAppDelegate appDelegate].accountDict[@"didRecieveGift"])
            {
                BOOL didRecieveGift = [[SGAppDelegate appDelegate].accountDict[@"didRecieveGift"] boolValue];
                
                if (didRecieveGift)
                {
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.supportUsBowlImageView setHidden:NO];
                        [weakSelf.grandOpeningGiftImageView setHidden:YES];
                    });
                }
            }
        }
    }];
}

#pragma mark - SGGiftFriendViewControllerDelegate

- (void)giftFriendViewControllerCanNotMakePurchase:(SGGiftFriendViewController *)controller
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf withConditionType:ConditionalType_InsufficentFunds presentationType:PresentationType_Error withFrame:weakSelf.view.frame errorDescription:nil loadingText:nil];
    });
}

- (void)giftFriendViewController:(SGGiftFriendViewController *)controller madePurchaseWithGiftPurchaseType:(GiftPurchaseType)giftPurchaseType;
{
    NSDictionary *accountDict = [SGAppDelegate appDelegate].accountDict;
    
    BOOL isPurchaseCoin = NO;
    
    BOOL isPurchaseGem = NO;
    
    switch (giftPurchaseType)
    {
        case GiftPurchaseType_Default:
        {
            
        }
            break;
        
        case GiftPurchaseType_Coins:
        {
            isPurchaseCoin = YES;
        }
            break;
            
        case GiftPurchaseType_Gems:
        {
            isPurchaseGem = YES;
        }
            break;
            
        default:
            break;
    }
    
    [self animateCoinPurchaseType:isPurchaseCoin
                  gemPurchaseType:isPurchaseGem
                   coinStartValue:[self.coinCountLabel.text intValue]
                     coinEndValue:[accountDict[@"coins"] intValue]
                    gemStartValue:[self.gemCountLabel.text intValue]
                      gemEndValue:[accountDict[@"gems"] intValue]
                animationDuration:1.0f
          willAnimateCoinsAndGems:YES];
}

#pragma mark - LMInAppPurchaseManagerDelegate

- (void)iapManager:(LMInAppPurchaseManager *)iapManager didLoadStoreProducts:(NSArray *)products
{
    // Grab Origin Frames
    
    self.leftConveyerOriginRect = self.leftConveyerCoverImageView.frame;
    self.rightConveyerOriginRect = self.rightConveyerCoverImageView.frame;
    self.lockBaseOriginRect = self.conveyerLockBaseImageView.frame;
    self.lockOriginRect = self.conveyerLockImageView.frame;
    
    [_masterItemsArray setArray:[products mutableCopy]];
    
    NSArray *costumesArray = [[NSArray alloc] initWithArray:[SGAppDelegate appDelegate].accountDict[@"cookieCostumes"]];
    NSMutableArray *ownedCostumesArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in costumesArray)
    {
        if ([[dict objectForKey:@"isUnlocked"] intValue] == 1)
        {
            if (![[dict objectForKey:@"name"] isEqualToString:KeyNameCheri] && ![[dict objectForKey:@"name"] isEqualToString:@"Moorie"] && ![[dict objectForKey:@"name"] isEqualToString:@"Star"])
            {
                NSDictionary *unlockedCostumeDict = [NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"name"], @"name", [dict objectForKey:@"theme"], @"theme", nil];
                [ownedCostumesArray addObject:unlockedCostumeDict];
            }
        }
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:PurchasedCostumesArrayDefault];
    NSMutableArray *purchaseCostumesArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    for (NSDictionary *dict in ownedCostumesArray)
    {
        if (![purchaseCostumesArray containsObject:[[SGAppDelegate appDelegate] retrieveProperIAPIdentifierWithCookieName:[dict objectForKey:@"name"] withTheme:[dict objectForKey:@"theme"]]])
        {
            if (([[dict objectForKey:@"theme"] isEqualToString:KeyThemeFarmer] && [[dict objectForKey:@"name"] isEqualToString:KeyNameDustinMartianMint]) ||
                ([[dict objectForKey:@"theme"] isEqualToString:KeyThemeChef] && [[dict objectForKey:@"name"] isEqualToString:KeyNameChip]) ||
                ([[dict objectForKey:@"theme"] isEqualToString:KeyThemeSuperHero] && [[dict objectForKey:@"name"] isEqualToString:KeyNameJJJams]) ||
                ([[dict objectForKey:@"theme"] isEqualToString:KeyThemeZombie] && [[dict objectForKey:@"name"] isEqualToString:KeyNameGerryJ]) ||
                [[dict objectForKey:@"theme"] isEqualToString:KeyThemeDefault])
            {
                DebugLog(@"Do not add the freebie!!!!");
            }
            else
            {
                if ([[SGAppDelegate appDelegate] retrieveProperIAPIdentifierWithCookieName:[dict objectForKey:@"name"] withTheme:[dict objectForKey:@"theme"]])
                {
                    [purchaseCostumesArray addObject:[[SGAppDelegate appDelegate] retrieveProperIAPIdentifierWithCookieName:[dict objectForKey:@"name"] withTheme:[dict objectForKey:@"theme"]]];
                }
                
                if ([[dict objectForKey:@"theme"] isEqualToString:KeyThemeChef])
                {
                    _numberOfChefsBought += 1;
                    
                    if ((_numberOfChefsBought >= [SGAppDelegate appDelegate].purchasesAllowedBeforeRemovingPack) && (![purchaseCostumesArray containsObject:IAPIdentifiers_ChefCookiePack]))
                    {
                        [purchaseCostumesArray addObject:IAPIdentifiers_ChefCookiePack];
                    }
                }
                else if ([[dict objectForKey:@"theme"] isEqualToString:KeyThemeSuperHero])
                {
                    _numberOfSupersBought += 1;
                    
                    if ((_numberOfSupersBought >= [SGAppDelegate appDelegate].purchasesAllowedBeforeRemovingPack) && (![purchaseCostumesArray containsObject:IAPIdentifiers_SuperCookiePack]))
                    {
                        [purchaseCostumesArray addObject:IAPIdentifiers_SuperCookiePack];
                    }
                }
                else if ([[dict objectForKey:@"theme"] isEqualToString:KeyThemeFarmer])
                {
                    _numberOfFarmersBought += 1;
                    
                    if ((_numberOfFarmersBought >= [SGAppDelegate appDelegate].purchasesAllowedBeforeRemovingPack) && (![purchaseCostumesArray containsObject:IAPIdentifiers_FarmerCookiePack]))
                    {
                        [purchaseCostumesArray addObject:IAPIdentifiers_FarmerCookiePack];
                    }
                }
                else if ([[dict objectForKey:@"theme"] isEqualToString:KeyThemeZombie])
                {
                    _numberOfZombiesBought += 1;
                    
                    if ((_numberOfZombiesBought >= [SGAppDelegate appDelegate].purchasesAllowedBeforeRemovingPack) && (![purchaseCostumesArray containsObject:IAPIdentifiers_ZombieCookiePack]))
                    {
                        [purchaseCostumesArray addObject:IAPIdentifiers_ZombieCookiePack];
                    }
                }
            }
        }
    }
    
    NSArray *tempArray = [[NSArray alloc] initWithArray:_masterItemsArray];
    
    if ([purchaseCostumesArray count] > 0)
    {
        for (SKProduct *product in tempArray)
        {
            for (NSString *productName in purchaseCostumesArray)
            {
//                DebugLog(@"Identifier: %@", productName);
                if ([product.productIdentifier isEqualToString:productName])
                {
//                    DebugLog(@"Removed");
                    [_masterItemsArray removeObject:product];
                }
            }
        }
    }
    
    [_inGameitemsArray setArray:_masterItemsArray];
    
    [self resetItemsArrayWithArray:_identifersRemovedForCurrencyArray];
    
    [self.storeItemsCollectionView reloadData];
    
    [self performSelector:@selector(animateStoreConveyerBeltOut) withObject:nil afterDelay:0.8f];
}

- (void)iapManager:(LMInAppPurchaseManager *)iapManager isProcessingTransAction:(SKPaymentTransaction *)transAction
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.itemInfoViewController animateOut];
        
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf
                                                                        withConditionType:ConditionalType_Default
                                                                         presentationType:PresentationType_Loading
                                                                                withFrame:weakSelf.view.frame
                                                                         errorDescription:nil loadingText:@"Processing transaction, this may take a few minutes..."];

    });
}

- (void)iapManagerDidPresentInAppPurchaseAlert:(LMInAppPurchaseManager *)iapManager
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[SGAppDelegate appDelegate] dismissConditionalView];
//    });
}

- (void)iapManager:(LMInAppPurchaseManager *)iapManager failedPurchaseProductWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SGAppDelegate appDelegate] dismissConditionalView];
    });
    
    if (error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf
                                                                                withConditionType:ConditionalType_Error
                                                                                 presentationType:PresentationType_Error
                                                                                 withFrame:weakSelf.view.frame
                                                                                 errorDescription:error.localizedDescription loadingText:nil];
            });
        });
    }
}

- (void)iapManager:(LMInAppPurchaseManager *)iapManager didPurchaseProductWithProductIdentifier:(NSString *)productIdentifier
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SGAppDelegate appDelegate] dismissConditionalView];
    });
    
    if ([productIdentifier isEqualToString:IAPIdentifier_CoinPack1000])
    {
        [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:1000]
                                                      costValue:nil
                                                       costType:CostType_None completionHandler:^
         (NSError *error, NSDictionary *updatedGameParametersDict)
        {
            if (!error && updatedGameParametersDict)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf animateCoinPurchaseType:YES
                                  gemPurchaseType:NO
                                   coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                     coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                    gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                      gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                animationDuration:1.0f
                          willAnimateCoinsAndGems:YES];
                });
            }
        }];
    }
    else if ([productIdentifier isEqualToString:IAPIdentifier_CoinPack2000])
    {
        [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:2000]
                                                      costValue:nil
                                                       costType:CostType_None completionHandler:^
         (NSError *error, NSDictionary *updatedGameParametersDict)
         {
             if (!error && updatedGameParametersDict)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf animateCoinPurchaseType:YES
                                       gemPurchaseType:NO
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                 });
             }
         }];
    }
    else if ([productIdentifier isEqualToString:IAPIdentifier_CoinPack10000])
    {
        [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:10000]
                                                      costValue:nil
                                                       costType:CostType_None completionHandler:^
         (NSError *error, NSDictionary *updatedGameParametersDict)
         {
             if (!error && updatedGameParametersDict)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf animateCoinPurchaseType:YES
                                       gemPurchaseType:NO
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                 });
             }
         }];
    }
    else if ([productIdentifier isEqualToString:IAPIdentifier_CoinPack5000])
    {
        [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:5000]
                                                      costValue:nil
                                                       costType:CostType_None completionHandler:^
         (NSError *error, NSDictionary *updatedGameParametersDict)
         {
             if (!error && updatedGameParametersDict)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf animateCoinPurchaseType:YES
                                       gemPurchaseType:NO
                                        coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                          coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                         gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                           gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                     animationDuration:1.0f
                               willAnimateCoinsAndGems:YES];
                 });
             }
         }];
    }
    else if ([productIdentifier isEqualToString:IAPIdentifier_NukeBooster])
    {
        [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil
                                                                                   spatulaValue:nil
                                                                               slotMachineValue:nil
                                                                               thunderboltValue:nil
                                                                                      nukeValue:[NSNumber numberWithInt:3]
                                                                                      costValue:nil
                                                                                       costType:CostType_None
                                                                              completionHandler:^
         (NSError *error, NSDictionary *updatedGameParametersDict)
         {
             if (!error && updatedGameParametersDict)
             {
                 __weak typeof(self) weakSelf = self;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf animateCoinPurchaseType:YES
                                   gemPurchaseType:NO
                                    coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                      coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                     gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                       gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                 animationDuration:1.0f
                           willAnimateCoinsAndGems:NO];
                 });
             }
         }];
    }
    else if ([productIdentifier isEqualToString:IAPIdentifier_ExtraLives5])
    {
        [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:5]
                                                      costValue:nil
                                                       costType:CostType_None
                                              completionHandler:^
         (NSError *error, NSDictionary *updatedGameParametersDict)
         {
             if (!error && updatedGameParametersDict)
             {
                 
             }
         }];
    }
    
    [self processCostumeWithIdentifier:productIdentifier];
}

- (void)unlockTheCookieCostumesWithCostumeType:(CookieCostumeType)costumeType WithReginald:(BOOL)unlockReginald WithChip:(BOOL)unlockChip WithDustin:(BOOL)unlockDustin WithLuke:(BOOL)unlockLuke WithMikey:(BOOL)unlockMikey WithJJ:(BOOL)unlockJJ WithGerry:(BOOL)unlockGerry
{
    [[CDIAPManager iapMananger] requestToUpdateCookiePacksWithCookiePackType:costumeType
                                                          willUnlockReginald:unlockReginald
                                                              willUnlockChip:unlockChip
                                                 willUnlockDustinMartianMint:unlockDustin
                                                     willUnlockLukeLocoLemon:unlockLuke
                                                  willUnlockMikeyMcSprinkles:unlockMikey
                                                            willUnlockJJJams:unlockJJ
                                                            willUnlockGerryJ:unlockGerry
                                                           completionHandler:^
     (NSError *error, NSDictionary *updatedGameParametersDict)
     {
         if (!error && updatedGameParametersDict)
         {
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IAPIdentifiers_ChefReginald];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
//             _masterItemsArray = [[CDIAPManager iapMananger] filteredProducts:_inGameitemsArray];
             
             __weak typeof(self) weakSelf = self;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.storeItemsCollectionView reloadData];
             });
         }
     }];
}

- (void)processCostumeWithIdentifier:(NSString *)productIdentifier
{
    NSString *packName = @"individual cookie";
    
    ////////////////
    //// Supers ////
    ////////////////
    NSString *theme = @"none";
    
    if ([productIdentifier isEqualToString:IAPIdentifiers_SuperCookiePack])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Super WithReginald:YES WithChip:YES WithDustin:YES WithLuke:YES WithMikey:YES WithJJ:YES WithGerry:YES];
        
        packName = @"super pack";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_SuperGerry])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Super WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:YES];
        theme = @"super";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_SuperMikeMcSprinkles])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Super WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:YES WithJJ:NO WithGerry:NO];
        theme = @"super";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_SuperLukeLocoLemon])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Super WithReginald:NO WithChip:NO WithDustin:NO WithLuke:YES WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"super";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_SuperDustinDoubleMint])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Super WithReginald:NO WithChip:NO WithDustin:YES WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"super";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_SuperChip])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Super WithReginald:NO WithChip:YES WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"super";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_SuperReginald])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Super WithReginald:YES WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"super";
    }
    
    ///////////////
    //// Chefs ////
    ///////////////
    
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ChefCookiePack])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Chef WithReginald:YES WithChip:YES WithDustin:YES WithLuke:YES WithMikey:YES WithJJ:YES WithGerry:YES];
        
        packName = @"chef pack";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ChefGerry])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Chef WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:YES];
        theme = @"chef";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ChefJJJams])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Chef WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:YES WithGerry:NO];
        theme = @"chef";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ChefMikeMcSprinkles])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Chef WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:YES WithJJ:NO WithGerry:NO];
        theme = @"chef";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ChefLukeLocoLemon])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Chef WithReginald:NO WithChip:NO WithDustin:NO WithLuke:YES WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"chef";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ChefDustinDoubleMint])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Chef WithReginald:NO WithChip:NO WithDustin:YES WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"chef";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ChefReginald])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Chef WithReginald:YES WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"chef";
    }
    
    /////////////////
    //// Farmers ////
    /////////////////
    
    else if ([productIdentifier isEqualToString:IAPIdentifiers_FarmerCookiePack])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Alien WithReginald:YES WithChip:YES WithDustin:YES WithLuke:YES WithMikey:YES WithJJ:YES WithGerry:YES];
        
        packName = @"farmer pack";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_FarmerGerryJ])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Alien WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:YES];
        theme = @"farmer";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_FarmerJJJams])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Alien WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:YES WithGerry:NO];
        theme = @"farmer";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_FarmerMikeyMcSprinkles])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Alien WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:YES WithJJ:NO WithGerry:NO];
        theme = @"farmer";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_FarmerLukeLocoLemon])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Alien WithReginald:NO WithChip:NO WithDustin:NO WithLuke:YES WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"farmer";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_FarmerChip])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Alien WithReginald:NO WithChip:YES WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"farmer";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_FarmerReginald])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Alien WithReginald:YES WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"farmer";
    }
    
    /////////////////
    //// Zombies ////
    /////////////////
    
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ZombieCookiePack])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Zombie WithReginald:YES WithChip:YES WithDustin:YES WithLuke:YES WithMikey:YES WithJJ:YES WithGerry:YES];
        
        packName = @"zombie pack";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ZombieDustinMartianMint])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Zombie WithReginald:NO WithChip:NO WithDustin:YES WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"undead";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ZombieJJJams])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Zombie WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:YES WithGerry:NO];
        theme = @"undead";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ZombieMikeyMcSprinkles])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Zombie WithReginald:NO WithChip:NO WithDustin:NO WithLuke:NO WithMikey:YES WithJJ:NO WithGerry:NO];
        theme = @"undead";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ZombieLukeLocoLemon])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Zombie WithReginald:NO WithChip:NO WithDustin:NO WithLuke:YES WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"undead";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ZombieChip])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Zombie WithReginald:NO WithChip:YES WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"undead";
    }
    else if ([productIdentifier isEqualToString:IAPIdentifiers_ZombieReginald])
    {
        [self unlockTheCookieCostumesWithCostumeType:CookieCostumeType_Zombie WithReginald:YES WithChip:NO WithDustin:NO WithLuke:NO WithMikey:NO WithJJ:NO WithGerry:NO];
        theme = @"undead";
    }
    
    NSMutableArray *purchaseCostumesArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:PurchasedCostumesArrayDefault]];
    
    if ([packName isEqualToString:@"individual cookie"])
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_inGameitemsArray];
        for (SKProduct *product in tempArray)
        {
            if ([product.productIdentifier isEqualToString:productIdentifier])
            {
                [_inGameitemsArray removeObject:product];
                [_masterItemsArray removeObject:product];
                [purchaseCostumesArray addObject:product.productIdentifier];
            }
        }
    }
    else if ([packName isEqualToString:@"chef pack"])
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_inGameitemsArray];
        for (SKProduct *product in tempArray)
        {
            if ([product.productIdentifier isEqualToString:IAPIdentifiers_ChefCookiePack] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ChefDustinDoubleMint] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ChefGerry] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ChefJJJams] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ChefLukeLocoLemon] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ChefMikeMcSprinkles] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ChefReginald])
            {
                [_inGameitemsArray removeObject:product];
                [_masterItemsArray removeObject:product];
                [purchaseCostumesArray addObject:product.productIdentifier];
            }
        }
    }
    else if ([packName isEqualToString:@"super pack"])
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_inGameitemsArray];
        for (SKProduct *product in tempArray)
        {
            if ([product.productIdentifier isEqualToString:IAPIdentifiers_SuperCookiePack] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_SuperChip] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_SuperDustinDoubleMint] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_SuperGerry] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_SuperLukeLocoLemon] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_SuperMikeMcSprinkles] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_SuperReginald])
            {
                [_inGameitemsArray removeObject:product];
                [_masterItemsArray removeObject:product];
                [purchaseCostumesArray addObject:product.productIdentifier];
            }
        }
    }
    else if ([packName isEqualToString:@"farmer pack"])
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_inGameitemsArray];
        for (SKProduct *product in tempArray)
        {
            if ([product.productIdentifier isEqualToString:IAPIdentifiers_FarmerCookiePack] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_FarmerChip] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_FarmerGerryJ] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_FarmerJJJams] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_FarmerLukeLocoLemon] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_FarmerMikeyMcSprinkles] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_FarmerReginald])
            {
                [_inGameitemsArray removeObject:product];
                [_masterItemsArray removeObject:product];
                [purchaseCostumesArray addObject:product.productIdentifier];
            }
        }
    }
    else if ([packName isEqualToString:@"zombie pack"])
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_inGameitemsArray];
        for (SKProduct *product in tempArray)
        {
            if ([product.productIdentifier isEqualToString:IAPIdentifiers_ZombieCookiePack] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ZombieChip] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ZombieDustinMartianMint] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ZombieJJJams] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ZombieLukeLocoLemon] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ZombieMikeyMcSprinkles] ||
                [product.productIdentifier isEqualToString:IAPIdentifiers_ZombieReginald])
            {
                [_inGameitemsArray removeObject:product];
                [_masterItemsArray removeObject:product];
                [purchaseCostumesArray addObject:product.productIdentifier];
            }
        }
    }

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:purchaseCostumesArray];
    [userDefault setObject:data forKey:PurchasedCostumesArrayDefault];
}

- (void)iapManager:(LMInAppPurchaseManager *)iapManager didRestoreProductWithProductIdentifier:(NSString *)productIdentifier
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SGAppDelegate appDelegate] dismissConditionalView];
    });
    
    [self processCostumeWithIdentifier:productIdentifier];
}

#pragma mark - Present Account View
- (void)presentAccountViewWithPlayerScreen:(BOOL)withPlayerScreen
{
    if ([SGAppDelegate appDelegate].accountDict)
    {
        CDAccountPopupView *popup = [[[NSBundle mainBundle] loadNibNamed:@"CDAccountPopupIphone5View" owner:self options:nil] objectAtIndex:0];
        [popup.backgroundImage setImage:[UIImage imageNamed:@"cdd-main-board-hud-minigamepanel-v-568h"]];
        
        popup.delegate = self;
        popup.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view insertSubview:popup aboveSubview:_mainButtonViewController.view];
        
        [popup setupWithParentalViewController:self];
        
        if (!_accountWasOpenedByMainButton)
        {
            if (withPlayerScreen)
            {
                [popup.statsView setHidden:YES];
                [popup.playerAccountView setHidden:NO];
                [popup.inventoryView setHidden:YES];
                
                [popup.accountButtonOne setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab1-v-active"] forState:UIControlStateNormal];
                [popup.accountButtonTwo setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab2-v-inactive"] forState:UIControlStateNormal];
                [popup.accountButtonThree setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab3-v-inactive"] forState:UIControlStateNormal];
            }
            else
            {
                [popup.statsView setHidden:NO];
                [popup.playerAccountView setHidden:YES];
                [popup.inventoryView setHidden:YES];
                [popup.accountButtonOne setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab1-v-inactive"] forState:UIControlStateNormal];
                [popup.accountButtonTwo setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab2-v-inactive"] forState:UIControlStateNormal];
                [popup.accountButtonThree setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab3-v-active"] forState:UIControlStateNormal];
            }
        }
        
        
        _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.view.frame errorDescription:@"You are not currently logged in. Please Login to view your account." loadingText:nil];
        
        _mainButtonViewController.popupIsUp = NO;
        [_mainButtonViewController enableButtons:YES];
    }
}

#pragma mark - Main Button Delegates

- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction
{
    // self.view.userInteractionEnabled = !willDisableInteraction;
}

- (void)mainButtonSubButtonWasHitWithIndex:(int)buttonIndex
{
    if (buttonIndex == soundButtonIndex)
    {
        DebugLog(@"THE SOUND BUTTON WAS HIT");
        //[[SGAudioManager audioManager] updateSoundLevels];
    }
    else if (buttonIndex == backButtonIndex)
    {
        _mainButtonViewController.view.clipsToBounds = YES;
        
        [self animateExitStore];
    }
    else if (buttonIndex == helpButtonIndex)
    {
        DebugLog(@"THE HELP BUTTON WAS HIT");
        CDStandardPopupView *standardPopup;
        
//        if (IS_IPHONE_4 || IS_IPAD)
//        {
            standardPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
//        }
//        else if (IS_IPHONE_5)
//        {
//            standardPopup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
//        }
        
        standardPopup.delegate = self;
        standardPopup.whatAmILoading = @"mainGameHelp";
        
        standardPopup.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view insertSubview:standardPopup aboveSubview:_mainButtonViewController.view];
        [standardPopup setup];
        
        _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else if (buttonIndex == volumeButtonIndex)
    {
        DebugLog(@"THE VOLUME BUTTON WAS HIT");
    }
    else if (buttonIndex == shopButtonIndex)
    {
        DebugLog(@"THE SHOP BUTTON WAS HIT");
    }
    else if (buttonIndex == accountButtonIndex)
    {
        DebugLog(@"THE ACCOUNT BUTTON WAS HIT");
        [self presentAccountViewWithPlayerScreen:YES];
        _accountWasOpenedByMainButton = YES;
    }
    else if (buttonIndex == settingsButtonIndex)
    {
        DebugLog(@"THE SETTINGS BUTTON WAS HIT");
    }
    else if (buttonIndex == facebookButtonIndex)
    {
        DebugLog(@"THE FACEBOOK BUTTON WAS HIT");
    }
    else if (buttonIndex == twitterButtonIndex)
    {
        DebugLog(@"THE TWITTER BUTTON WAS HIT");
    }
    else if (buttonIndex == googleButtonIndex)
    {
        DebugLog(@"THE GOOGLE BUTTON WAS HIT");
    }
}

#pragma mark - Account Screen Delegate

- (void)exitButtonWasHitOnAccountPopup:(CDAccountPopupView *)accountView
{
    [accountView removeFromSuperview];
    
    if (_accountWasOpenedByMainButton)
    {
        _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        _mainButtonViewController.popupIsUp = NO;

        [_mainButtonViewController enableButtons:YES];
    }
}

#pragma mark - Standard Popup Delegate

- (void)exitButtonWasHitOnStandardPopupView:(CDStandardPopupView *)standardPopup
{
    [standardPopup removeFromSuperview];
    _mainButtonViewController.faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _mainButtonViewController.popupIsUp = NO;
}

#pragma mark - Custom Methods

#pragma mark - Animations

- (void)animateExitStore
{
    self.view.userInteractionEnabled = NO;
    
    //[_coinSoundEffect stop];
    //[_chChingSoundEffect stop];
    //[_beepLongSoundEffect stop];
    //[_storeBellSoundEffect stop];
    //[_slidingDoorOpenSoundEffect stop];
    //[_electricDoorOpenSoundEffect stop];
    //[_electricDoorCloseSoundEffect stop];
    //[_errorBeepSoundEffect stop];
    //[_click2SoundEffect stop];

    [[SGAudioManager audioManager] stopAllAudio];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_mainButtonViewController.view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        
        [self animateStoreConveyerBeltIn];
    }];
}

- (void)fadeInAudio:(NSNumber *)delay  // <<< Get back to this.
{
//    if ([SGAudioManager audioManager].player.volume < 1.0f)
//    {
//        [SGAudioManager audioManager].player.volume += 0.1f;
//        float lastDelay = [delay floatValue] + 0.3f;
//        float newDelay = [delay floatValue] + 0.1f;
//        NSNumber *numDelay = [NSNumber numberWithFloat:newDelay];
//        [self performSelector:@selector(fadeInAudio:) withObject:numDelay afterDelay:lastDelay];
//    }
}

//- (void)updateCirclePathWithRectOne:(CGRect)rectOne rectTwo:(CGRect)rectTwo
//{
//    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:rectOne];
// 
//    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:rectTwo];
//    
//    UIBezierPath *combinePaths = [UIBezierPath bezierPath];
//    
//    [combinePaths appendPath:path1];
//    
//    [combinePaths appendPath:path2];
//    
//    self.maskLayer.path = [combinePaths CGPath];
//}


- (void)animateStoreDoorsOut
{
    if (!_didAnimateStoreDoorOut)
    {
        _didAnimateStoreDoorOut = YES;
        
        [self.storeBlurredImageView setHidden:YES];
        
        //[_storeBellSoundEffect play];
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"StoreBell" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
        
        //[_slidingDoorOpenSoundEffect play];
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"SlidingDoor-Open" FileType:@"caf" volume:1.0f]; //@"m4a" volume:1.0f];
    }
    
    [UIView animateWithDuration:2.0f animations:^{
        
        CGRect leftDoorFrame = self.leftDoorImageView.frame;
        leftDoorFrame.origin.x = self.leftDoorImageView.frame.origin.x - leftDoorFrame.size.width;
        self.leftDoorImageView.frame = leftDoorFrame;
        self.leftCropView.frame = leftDoorFrame;
        
        CGRect rightDoorFrame = self.rightDoorImageView.frame;
        rightDoorFrame.origin.x = self.rightDoorImageView.frame.origin.x + rightDoorFrame.size.width;
        self.rightDoorImageView.frame = rightDoorFrame;
        self.rightCropView.frame = rightDoorFrame;
        
//        [self updateCirclePathWithRectOne:self.leftCropView.frame rectTwo:self.rightCropView.frame];
        
        
    } completion:^(BOOL finished) {
        
        [self setUserTotalGemsAndCoins];
        
        [self.leftCropView setHidden:YES];
        [self.rightCropView setHidden:YES];
        [self.storeBlurredImageView setHidden:YES];
        
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(animateShopKeeper) userInfo:nil repeats:YES];
        
        [UIView animateWithDuration:0.3f animations:^{
            [_mainButtonViewController.view setAlpha:1.0f];
        } completion:nil];
        
        self.leftTopSpeakerLightImageView.animationImages = _leftSpeakerLightAnimations;
        self.leftTopSpeakerLightImageView.animationDuration = 2.0f;
        [self.leftTopSpeakerLightImageView startAnimating];
        
        self.leftBottomSpeakerLightImageView.animationImages = [[_leftSpeakerLightAnimations reverseObjectEnumerator] allObjects];
        self.leftBottomSpeakerLightImageView.animationDuration = 2.0f;
        [self.leftBottomSpeakerLightImageView startAnimating];
        
        self.rightTopSpeakerLightImageView.animationImages = _rightSpeakerLightAnimations;
        self.rightTopSpeakerLightImageView.animationDuration = 2.0f;
        [self.rightTopSpeakerLightImageView startAnimating];
        
        self.rightBottomSpeakerLightImageView.animationImages = [[_rightSpeakerLightAnimations reverseObjectEnumerator] allObjects];
        self.rightBottomSpeakerLightImageView.animationDuration = 2.0f;
        [self.rightBottomSpeakerLightImageView startAnimating];
        
    }];
    
//    [UIView animateWithDuration:0.05f animations:^{
//
//        CGRect leftDoorFrame = self.leftDoorImageView.frame;
//        leftDoorFrame.origin.x = self.leftDoorImageView.frame.origin.x - 22.0f;
//        
//        self.leftDoorImageView.frame = leftDoorFrame;
//        
//        leftDoorFrame.origin.x = leftDoorFrame.origin.x + 2.0f;
//        
//        self.leftCropView.frame = leftDoorFrame;
//        
//        CGRect rightDoorFrame = self.rightDoorImageView.frame;
//        rightDoorFrame.origin.x = self.rightDoorImageView.frame.origin.x + 22.0f;
//        
//        self.rightDoorImageView.frame = rightDoorFrame;
//        
//        //rightDoorFrame.origin.x = rightDoorFrame.origin.x + 0.0f;
//        
//        self.rightCropView.frame = rightDoorFrame;
//        
//        [self updateCirclePathWithRectOne:self.leftCropView.frame rectTwo:self.rightCropView.frame];
//        
//        
//    } completion:^(BOOL finished) {
//        
//        if ((self.leftCropView.frame.origin.x + self.leftCropView.frame.size.width) >= 0)
//        {
//            [self performSelector:@selector(fadeInAudio:) withObject:[NSNumber numberWithFloat:0.1f] afterDelay:0.3f];
//            
//            [self animateStoreDoorsOut];
//        }
//        else
//        {
//            [self setUserTotalGemsAndCoins];
//
//            [self.leftCropView setHidden:YES];
//            [self.rightCropView setHidden:YES];
//            [self.storeBlurredImageView setHidden:YES];
//            _animationTimer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(animateShopKeeper) userInfo:nil repeats:YES];
//            
//            [UIView animateWithDuration:0.3f animations:^{
//                [_mainButtonViewController.view setAlpha:1.0f];
//            } completion:nil];
//            
//            self.leftTopSpeakerLightImageView.animationImages = _leftSpeakerLightAnimations;
//            self.leftTopSpeakerLightImageView.animationDuration = 2.0f;
//            [self.leftTopSpeakerLightImageView startAnimating];
//            
//            self.leftBottomSpeakerLightImageView.animationImages = [[_leftSpeakerLightAnimations reverseObjectEnumerator] allObjects];
//            self.leftBottomSpeakerLightImageView.animationDuration = 2.0f;
//            [self.leftBottomSpeakerLightImageView startAnimating];
//            
//            self.rightTopSpeakerLightImageView.animationImages = _rightSpeakerLightAnimations;
//            self.rightTopSpeakerLightImageView.animationDuration = 2.0f;
//            [self.rightTopSpeakerLightImageView startAnimating];
//            
//            self.rightBottomSpeakerLightImageView.animationImages = [[_rightSpeakerLightAnimations reverseObjectEnumerator] allObjects];
//            self.rightBottomSpeakerLightImageView.animationDuration = 2.0f;
//            [self.rightBottomSpeakerLightImageView startAnimating];
//        }
//        
//    }];

}

- (void)animateStoreDoorsIn
{
    //float leftDoorFrameDifference = 22.0f;
    //float leftDoorSecondaryFrameDifference = 2.0f;
    
    
    _currencyTabButton.userInteractionEnabled = NO;
    _costumesTabButton.userInteractionEnabled = NO;
    _powerupTabButton.userInteractionEnabled = NO;
    
    if (!_didAnimateStoreDoorIn)
    {
        _didAnimateStoreDoorIn = YES;
        
        //[_slidingDoorCloseSoundEffect play];
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"SlidingDoor-Close" FileType:@"caf" volume:1.0f];
    }
    
    if (self.leftCropView.isHidden)
    {
        [self.leftCropView setHidden:NO];
        [self.rightCropView setHidden:NO];
        //[self.storeBlurredImageView setHidden:NO];
    }
    
    [UIView animateWithDuration:2.0f animations:^{
        
        CGRect leftDoorFrame = self.leftDoorImageView.frame;
        leftDoorFrame.origin.x = self.leftDoorImageView.frame.origin.x + leftDoorFrame.size.width;
        self.leftDoorImageView.frame = leftDoorFrame;
        self.leftCropView.frame = leftDoorFrame;
        
        CGRect rightDoorFrame = self.rightDoorImageView.frame;
        rightDoorFrame.origin.x = self.rightDoorImageView.frame.origin.x - rightDoorFrame.size.width;
        self.rightDoorImageView.frame = rightDoorFrame;
        self.rightCropView.frame = rightDoorFrame;
        
//        [self updateCirclePathWithRectOne:self.leftCropView.frame rectTwo:self.rightCropView.frame];
        
    } completion:^(BOOL finished) {
        if (IS_IPHONE_5)
        {
            if (!_didExitStore)
            {
                _didExitStore = YES;
                
                [[SGAppDelegate appDelegate] transitionEndFadeWithParentViewController:self navControllerTransitionType:NavControllerTransitionEndType_Pop withImageName:nil willAnimateTransition:NO];
            }
        }
        else
        {
            [[SGAppDelegate appDelegate] transitionEndFadeWithParentViewController:self navControllerTransitionType:NavControllerTransitionEndType_Pop withImageName:nil willAnimateTransition:NO];
        }
    }];

//    [UIView animateWithDuration:0.05f animations:^{
//        
//        CGRect leftDoorFrame = self.leftDoorImageView.frame;
//        
//        leftDoorFrame.origin.x = self.leftDoorImageView.frame.origin.x + leftDoorFrameDifference;
//        
//        self.leftDoorImageView.frame = leftDoorFrame;
//        
//        leftDoorFrame.origin.x = leftDoorFrame.origin.x - leftDoorSecondaryFrameDifference;
//        
//        self.leftCropView.frame = leftDoorFrame;
//        
//        CGRect rightDoorFrame = self.rightDoorImageView.frame;
//        
//        rightDoorFrame.origin.x = self.rightDoorImageView.frame.origin.x - leftDoorFrameDifference;
//        
//        self.rightDoorImageView.frame = rightDoorFrame;
//        
//        // rightDoorFrame.origin.x = rightDoorFrame.origin.x + 0.0f;
//        
//        self.rightCropView.frame = rightDoorFrame;
//        
//        [self updateCirclePathWithRectOne:self.leftCropView.frame rectTwo:self.rightCropView.frame];
//        
//    } completion:^(BOOL finished) {
//        if (IS_IPHONE_5)
//        {
////            if (((self.leftCropView.frame.origin.x - leftDoorFrameDifference) + self.leftCropView.frame.size.width) <=
////                (self.leftCropViewOriginRect.origin.x + self.leftCropViewOriginRect.size.width))
////            {
//            if ((self.leftCropView.frame.origin.x + 2) <
//                self.leftCropViewOriginRect.origin.x)
//            {
//                [self animateStoreDoorsIn];
//            }
//            else
//            {
//                if (!_didExitStore)
//                {
//                    _didExitStore = YES;
//                    
//                    [[SGAppDelegate appDelegate] transitionEndFadeWithParentViewController:self navControllerTransitionType:NavControllerTransitionEndType_Pop withImageName:nil willAnimateTransition:NO];
//                }
//            }
//        }
//        else
//        {
////            if (((self.leftCropView.frame.origin.x + leftDoorFrameDifference) + self.leftCropView.frame.size.width) < (self.leftCropViewOriginRect.origin.x + self.leftCropViewOriginRect.size.width))
////            {
//            
//            if ((self.leftCropView.frame.origin.x + 46) <
//                self.leftCropViewOriginRect.origin.x)
//            {
//                [self animateStoreDoorsIn];
//            }
//            else
//            {
//                [[SGAppDelegate appDelegate] transitionEndFadeWithParentViewController:self navControllerTransitionType:NavControllerTransitionEndType_Pop withImageName:nil willAnimateTransition:NO];
//            }
//        }
//    }];
    
}

- (void)setupStoreConveyerBelt
{
    self.conveyerLockImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
}

- (void)animateStoreConveyerBeltOut
{
    //[_electricDoorOpenSoundEffect play];
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ElectricDoor-Open" FileType:@"caf"]; //@"m4a"];
    
    _didAnimateConveyerBeltOut = YES;
    
    [UIView animateWithDuration:0.3f animations:^
    {
    
        self.conveyerLockImageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.2f animations:^{
            
            CGRect rightConveyerFrame = self.rightConveyerCoverImageView.frame;
            rightConveyerFrame.origin.x = kScreenWidth+self.rightConveyerCoverImageView.frame.origin.x;
            self.rightConveyerCoverImageView.frame = rightConveyerFrame;
            
            CGRect lockedBaseConveyerFrame = self.conveyerLockBaseImageView.frame;
            lockedBaseConveyerFrame.origin.x = kScreenWidth+self.conveyerLockBaseImageView.frame.origin.x;
            self.conveyerLockBaseImageView.frame = lockedBaseConveyerFrame;
            
            CGRect lockConveyerFrame = self.conveyerLockImageView.frame;
            lockConveyerFrame.origin.x = kScreenWidth+self.conveyerLockImageView.frame.origin.x;
            self.conveyerLockImageView.frame = lockConveyerFrame;
            
            
            CGRect leftConveyerFrame = self.leftConveyerCoverImageView.frame;
            leftConveyerFrame.origin.x = - (kScreenWidth + self.leftConveyerCoverImageView.frame.origin.x);
            self.leftConveyerCoverImageView.frame = leftConveyerFrame;
            
        } completion:^(BOOL finished) {
            
            _currencyTabButton.userInteractionEnabled = YES;
            _costumesTabButton.userInteractionEnabled = YES;
            _powerupTabButton.userInteractionEnabled = YES;
        }];
    }];
}


- (void)animateStoreConveyerBeltIn
{
    //[_electricDoorCloseSoundEffect play];
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ElectricDoor-Close" FileType:@"caf"]; //@"m4a"];
    
    if (_didAnimateConveyerBeltOut)
    {
        [UIView animateWithDuration:1.2f animations:^
         {
             self.rightConveyerCoverImageView.frame = self.rightConveyerOriginRect;
             
             self.conveyerLockBaseImageView.frame = self.lockBaseOriginRect;
             
             self.conveyerLockImageView.frame = self.lockOriginRect;
             
             self.leftConveyerCoverImageView.frame = self.leftConveyerOriginRect;
             
         } completion:^(BOOL finished) {
             
             [UIView animateWithDuration:0.3f animations:^{
                 
                 self.conveyerLockImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
                 
             } completion:^(BOOL finished) {
                 
                 [self animateStoreDoorsIn];
             }];
         }];
    }
    else
    {
        [self animateStoreDoorsIn];
    }
}


- (void)animateRightSpeaker
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.rightSpeakerImageview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
    } completion:^(BOOL finished) {
        
    }];
    
//    NSString *keyPathScale = @"transform.scale";
//    CAKeyframeAnimation *transformScale = [CAKeyframeAnimation animationWithKeyPath:keyPathScale];
//    
//    NSMutableArray *values = [[NSMutableArray alloc] init];
//    [values addObject:[NSNumber numberWithFloat:1.05f]];
//    [values addObject:[NSNumber numberWithFloat:1.0f]];
//    
//    transformScale.values = values;
//    transformScale.duration = 0.5;
//    transformScale.repeatCount = HUGE_VAL;
//    transformScale.autoreverses = YES;
//    
//    [self.rightSpeakerImageview.layer addAnimation:transformScale forKey:keyPathScale];
    
}

//- (void)animateLeftSpeaker
//{
//    [UIView animateWithDuration:0.4f animations:^{
//        CGRect frame = self.leftSpeakerImageView.frame;
//        frame.origin.y = self.leftSpeakerImageView.frame.origin.y-3.0f;
//        self.leftSpeakerImageView.frame = frame;
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.3f animations:^{
//            self.leftSpeakerImageView.frame = self.leftSpeakerOriginRect;
//        } completion:^(BOOL finished) {
//            [self performSelector:@selector(animateLeftSpeaker) withObject:nil afterDelay:0.4f];
//        }];
//        
//    }];
//}

- (void)setUserTotalGemsAndCoins
{
    int totalGems = 0;
    
    int totalCoins = 0;

    if ([SGAppDelegate appDelegate].accountDict[@"gems"])
    {
        totalGems = [[SGAppDelegate appDelegate].accountDict[@"gems"] intValue];
    }
    
    if ([SGAppDelegate appDelegate].accountDict[@"coins"])
    {
        totalCoins = [[SGAppDelegate appDelegate].accountDict[@"coins"] intValue];
    }
    
    [self animateCoinPurchaseType:YES
                  gemPurchaseType:YES
                   coinStartValue:0.0f
                     coinEndValue:totalCoins
                    gemStartValue:0.0f
                      gemEndValue:totalGems
                animationDuration:1.0f
          willAnimateCoinsAndGems:NO];
    
//    self.gemCountLabel.text = [NSString stringWithFormat:@"%i", totalGems];
//    self.coinCountLabel.text = [NSString stringWithFormat:@"%i", totalCoins];
}

- (void)animateCoinParticle
{
    UIImageView *coinImage = [[UIImageView alloc] initWithFrame:self.coinParticleImageView.frame];
    coinImage.image = self.coinParticleImageView.image;
    [self.view addSubview:coinImage];

    CGRect rectOne = CGRectMake(coinImage.frame.origin.x, coinImage.frame.origin.y - (coinImage.frame.size.height * 3), coinImage.frame.size.width, coinImage.frame.size.height);
    CGRect rectTwo = CGRectMake(coinImage.frame.origin.x - (coinImage.frame.size.width * 3), coinImage.frame.origin.y - (coinImage.frame.size.height * 3), coinImage.frame.size.width, coinImage.frame.size.height);
    CGRect rectThree = CGRectMake(coinImage.frame.origin.x + (coinImage.frame.size.width * 3), coinImage.frame.origin.y - (coinImage.frame.size.height * 3), coinImage.frame.size.width, coinImage.frame.size.height);

    NSMutableArray *rectArray = [NSMutableArray new];
    [rectArray addObject:[NSValue valueWithCGRect:rectOne]];
    [rectArray addObject:[NSValue valueWithCGRect:rectTwo]];
    [rectArray addObject:[NSValue valueWithCGRect:rectThree]];

    [UIView animateWithDuration:0.3 animations:^{
        
        int randomIndex = arc4random() % [rectArray count];
        
        NSValue *rectValue = rectArray[randomIndex];
        
        CGRect frame = [rectValue CGRectValue];
        
        coinImage.frame = frame;
        
        coinImage.alpha = 0.0f;

    } completion:^(BOOL finished) {
        [coinImage removeFromSuperview];
    }];
}

- (void)animateGemParticle
{
    UIImageView *gemImage = [[UIImageView alloc] initWithFrame:self.gemParticleImageView.frame];
    gemImage.image = self.gemParticleImageView.image;
    [self.view addSubview:gemImage];
    
    CGRect rectOne = CGRectMake(gemImage.frame.origin.x, gemImage.frame.origin.y - (gemImage.frame.size.height * 3), gemImage.frame.size.width, gemImage.frame.size.height);
    CGRect rectTwo = CGRectMake(gemImage.frame.origin.x - (gemImage.frame.size.width * 3), gemImage.frame.origin.y - (gemImage.frame.size.height * 3), gemImage.frame.size.width, gemImage.frame.size.height);
    CGRect rectThree = CGRectMake(gemImage.frame.origin.x + (gemImage.frame.size.width * 3), gemImage.frame.origin.y - (gemImage.frame.size.height * 3), gemImage.frame.size.width, gemImage.frame.size.height);
    
    NSMutableArray *rectArray = [NSMutableArray new];
    [rectArray addObject:[NSValue valueWithCGRect:rectOne]];
    [rectArray addObject:[NSValue valueWithCGRect:rectTwo]];
    [rectArray addObject:[NSValue valueWithCGRect:rectThree]];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        int randomIndex = arc4random() % [rectArray count];
        
        NSValue *rectValue = rectArray[randomIndex];
        
        CGRect frame = [rectValue CGRectValue];
        
        gemImage.frame = frame;
        
        gemImage.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [gemImage removeFromSuperview];
    }];
}

- (void)animateStarScrollImageview
{
    // Star bobbing animation
    
//    UIImageView *starScapeImageView = [[UIImageView alloc] initWithImage:self.starScrollImageview.image];
//    [self.conveyerContainerView insertSubview:starScapeImageView belowSubview:self.storeItemsCollectionView];
//    starScapeImageView.frame = self.starScrollImageview.frame;
//    starScapeImageView.frame = CGRectMake(self.storeItemsCollectionView.frame.origin.x,
//                                          starScapeImageView.frame.origin.y,
//                                          starScapeImageView.frame.size.width,
//                                          starScapeImageView.frame.size.height);
//    
//    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
//        starScapeImageView.frame = CGRectOffset(starScapeImageView.frame, 10, -10);
//    } completion:^(BOOL finished) {
//        
//    }];
    
    // Scrolling star background animation
    
    UIImageView *starScapeImageView1 = [[UIImageView alloc] initWithImage:self.starScrollImageview.image];
    [self.conveyerContainerView insertSubview:starScapeImageView1 belowSubview:self.storeItemsCollectionView];
    //[starScapeImageView1 setBackgroundColor:[UIColor greenColor]];
    //[starScapeImageView1 setAlpha:0.5f];
    starScapeImageView1.frame = self.starScrollImageview.frame;
    starScapeImageView1.frame = CGRectMake(self.storeItemsCollectionView.frame.origin.x + starScapeImageView1.frame.size.width,
                                           starScapeImageView1.frame.origin.y,
                                           starScapeImageView1.frame.size.width,
                                           starScapeImageView1.frame.size.height);
    
    UIImageView *starScapeImageView2 = [[UIImageView alloc] initWithImage:self.starScrollImageview.image];
    [self.conveyerContainerView insertSubview:starScapeImageView2 belowSubview:self.storeItemsCollectionView];
    //[starScapeImageView2 setBackgroundColor:[UIColor redColor]];
    //[starScapeImageView2 setAlpha:0.5f];
    starScapeImageView2.frame = self.starScrollImageview.frame;
    starScapeImageView2.frame = CGRectMake(starScapeImageView1.frame.origin.x,
                                           starScapeImageView2.frame.origin.y,
                                           starScapeImageView2.frame.size.width,
                                           starScapeImageView2.frame.size.height);
    
    [UIView animateWithDuration:10.0 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        starScapeImageView1.frame = CGRectOffset(starScapeImageView1.frame,
                                                 -starScapeImageView1.frame.size.width * 2,
                                                 0);
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:10.0 delay:5.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        starScapeImageView2.frame = CGRectOffset(starScapeImageView2.frame,
                                                 -starScapeImageView2.frame.size.width * 2,
                                                 0);
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - Shop Keeper Animations

- (void)animateShopKeeper
{
    if (!_didTouchShopKeeper)
    {
        int randomIndex = arc4random() % [_shopKeeperAnimationsArray count];
        
        NSMutableArray *selectedAnimationArray = _shopKeeperAnimationsArray[randomIndex];
        
        self.shopKeeperImageView.animationImages = selectedAnimationArray;
        
        [self.shopKeeperImageView startAnimating];
    }
}

- (void)animateTouchShopKeeper
{
    if (self.tapGesture.state == UIGestureRecognizerStateBegan)
    {
        _didTouchShopKeeper = YES;
        
        int randomIndex = arc4random() % [_touchShopKeeperAnimationsArray count];
        
        NSMutableArray *selectedAnimationArray = _touchShopKeeperAnimationsArray[randomIndex];
        
        self.shopKeeperImageView.animationImages = selectedAnimationArray;
        
        [self.shopKeeperImageView startAnimating];
    }
    else if (self.tapGesture.state == UIGestureRecognizerStateEnded)
    {
        _didTouchShopKeeper = NO;
    }
}

#pragma mark - Left Button Keep Scroll

- (void)keepScrollingLeft
{
    if (_willKeepScrollingLeft)
    {
        [self scrollLeft];
    }
}

- (void)scrollLeft
{
    NSArray *visibleItems = [self.storeItemsCollectionView visibleCells];
    
    CDStoreItemCell *cell = (CDStoreItemCell *)[visibleItems lastObject];
    
    [UIScrollView animateWithDuration:0.3f animations:^{
        if (_didEndScrolling)
        {
            _didEndScrolling = NO;
            
            if((self.storeItemsCollectionView.contentOffset.x) > 0.0f)
            {
                [self.scrollItemsRightButton setImage:_rightSelectedImage forState:UIControlStateHighlighted];
                [self.scrollItemsLeftButton setImage:_leftSelectedImage forState:UIControlStateHighlighted];
                
                if (cell.frame.size.width + 29.0f < self.storeItemsCollectionView.contentOffset.x)
                {
                    self.scrollAmount = (cell.frame.size.width + 29.0f);
                }
                else
                {
                    self.scrollAmount = self.storeItemsCollectionView.contentOffset.x;
                }
                
                //self.scrollAmount = (cell.frame.size.width + 29.0f);
                
                [self.storeItemsCollectionView setContentOffset:CGPointMake(self.storeItemsCollectionView.contentOffset.x - self.scrollAmount, 0.0f)];
                //[_beepLongSoundEffect play];
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Item-Beep-Long" FileType:@"wav"];
            }
            else
            {
                [self.scrollItemsLeftButton setImage:_leftSelectedErrorImage forState:UIControlStateHighlighted];
                //[_errorBeepSoundEffect play];
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ErrorBeep" FileType:@"caf"]; //@"m4a"];
            }
        }
    } completion:^(BOOL finished) {
        _didEndScrolling = YES;
        //[_click2SoundEffect play];
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click-2" FileType:@"wav"];
    }];
}

#pragma mark - Right Button Keep Scroll

- (void)keepScrollingRight
{
    if (_willKeepScrollingRight)
    {
        [self scrollRight];
    }
}

- (void)scrollRight
{
    NSArray *visibleItems = [self.storeItemsCollectionView visibleCells];
    
    CDStoreItemCell *cell = (CDStoreItemCell *)[visibleItems lastObject];
    
    
    [UIScrollView animateWithDuration:0.3f animations:^{
        if (_didEndScrolling)
        {
            _didEndScrolling = NO;
          
            
            float scrollDifference = 270.0f;
            
            if (IS_IPHONE_5)
            {
                scrollDifference = 360.0f;
            }
            
            if ((self.storeItemsCollectionView.contentOffset.x + (cell.frame.size.width + 29.0f)) < self.storeItemsCollectionView.contentSize.width-scrollDifference)
            {
                [self.scrollItemsLeftButton setImage:_leftSelectedImage forState:UIControlStateHighlighted];
                [self.scrollItemsRightButton setImage:_rightSelectedImage forState:UIControlStateHighlighted];
                self.scrollAmount = (cell.frame.size.width + 29.0f);
                
                [self.storeItemsCollectionView setContentOffset:CGPointMake(self.storeItemsCollectionView.contentOffset.x + self.scrollAmount, 0.0f)];
                //[_beepLongSoundEffect play];
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Item-Beep-Long" FileType:@"wav"];
            }
            else
            {
                [self.scrollItemsRightButton setImage:_rightSelectedErrorImage forState:UIControlStateHighlighted];
                //[_errorBeepSoundEffect play];
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ErrorBeep" FileType:@"caf"]; //@"m4a"];
            }
        }
    } completion:^(BOOL finished) {
        _didEndScrolling = YES;
        //[_click2SoundEffect play];
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click-2" FileType:@"wav"];
    }];
}

#pragma mark - Tween Numbers

- (void)animateCoinPurchaseType:(BOOL)isPurchaseCoin
                gemPurchaseType:(BOOL)isPurchaseGem
              coinStartValue:(float)coinStartValue
                coinEndValue:(float)coinEndValue
          gemStartValue:(float)gemStartValue
            gemEndValue:(float)gemEndValue
              animationDuration:(float)duration
        willAnimateCoinsAndGems:(BOOL)willAnimate
{
    _willAnimateCurrency = willAnimate;
    
    // Audio Completion.
    
    //[_coinSoundEffect play];
    
    //[[SGAudioManager audioManager] playSoundEffectWithFilename:@"Money-Roll-Medium" FileType:@"m4a" volume:1.0f completion:^(BOOL finishedSuccessfully) {
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Money-Roll-Medium" FileType:@"caf" volume:1.0f completion:^{
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cha-Ching-2!" FileType:@"caf"]; //@"m4a"];
    }];
    
    if (isPurchaseCoin && isPurchaseGem)
    {
        
        [[PRTween sharedInstance] removeTweenOperation:_coinTweenOperation];
        
        PRTweenPeriod *coinPeriod = [PRTweenPeriod periodWithStartValue:coinStartValue endValue:coinEndValue duration:duration];
        
        _coinTweenOperation = [[PRTween sharedInstance] addTweenPeriod:coinPeriod
                                                                target:self
                                                              selector:@selector(coinUpdate:)
                                                        timingFunction:&PRTweenTimingFunctionCircOut];
        
        [[PRTween sharedInstance] removeTweenOperation:_gemTweenOperation];
        
        PRTweenPeriod *gemPeriod = [PRTweenPeriod periodWithStartValue:gemStartValue endValue:gemEndValue duration:duration];
        
        _gemTweenOperation = [[PRTween sharedInstance] addTweenPeriod:gemPeriod
                                                               target:self
                                                             selector:@selector(gemUpdate:)
                                                       timingFunction:&PRTweenTimingFunctionCircOut];
    }
    else if (isPurchaseCoin)
    {
        [[PRTween sharedInstance] removeTweenOperation:_coinTweenOperation];
        
        PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:coinStartValue endValue:coinEndValue duration:duration];
        
        _coinTweenOperation = [[PRTween sharedInstance] addTweenPeriod:period
                                                               target:self
                                                             selector:@selector(coinUpdate:)
                                                       timingFunction:&PRTweenTimingFunctionCircOut];
    }
    else if (isPurchaseGem)
    {
        [[PRTween sharedInstance] removeTweenOperation:_gemTweenOperation];
        
        PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:gemStartValue endValue:gemEndValue duration:duration];
        
        _gemTweenOperation = [[PRTween sharedInstance] addTweenPeriod:period
                                                            target:self
                                                          selector:@selector(gemUpdate:)
                                                    timingFunction:&PRTweenTimingFunctionCircOut];
    }
}

- (void)coinUpdate:(PRTweenPeriod *)period
{
    if (_willAnimateCurrency) [self animateCoinParticle];

    self.coinCountLabel.text = [NSString stringWithFormat:@"%.2f", period.tweenedValue];
}

- (void)gemUpdate:(PRTweenPeriod *)period
{
    if (_willAnimateCurrency) [self animateGemParticle];
    
    self.gemCountLabel.text = [NSString stringWithFormat:@"%.2f", period.tweenedValue];
}

#pragma mark - Accept Gift

- (void)showItemViewWithGift
{
    CGRect frame = self.itemInfoViewController.view.frame;
    
    self.itemInfoViewController.view.frame = CGRectMake(frame.origin.x, frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.itemInfoViewController.storeItemPurchaseType = StoreItemPurchaseType_AcceptGift;
    
    [self.itemInfoViewController animateIn];
    
    self.itemInfoViewController.itemInfoLabel.text = self.giftProduct.localizedDescription;
    
    self.itemInfoViewController.buyNowLabel.text = self.giftProduct.localizedTitle;
    
    self.itemInfoViewController.itemIconImageView.image = self.grandOpeningGiftImageView.image;
    
    [self.view addSubview:self.itemInfoViewController.view];
}

#pragma mark - IBActions

//- (IBAction)costumesButtonHit:(id)sender
//{
//    self.costumeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CDStoreCostumeViewController"];
//    self.costumeViewController.view.frame = self.view.frame;
//    self.costumeViewController.delegate = self;
//    
//    [self.view addSubview:_costumeViewController.view];
//    [_costumeViewController updatePageDots];
//}
//
//- (IBAction)playerButtonHit:(id)sender
//{
//    [self presentAccountViewWithPlayerScreen:YES];
//    _accountWasOpenedByMainButton = NO;
//}
//
//- (IBAction)statsButtonHit:(id)sender
//{
//    [self presentAccountViewWithPlayerScreen:NO];
//    _accountWasOpenedByMainButton = NO;
//}

- (IBAction)currencyTabButtonHit:(id)sender
{
    [self resetItemsArrayWithArray:_identifersRemovedForCurrencyArray];
    
    [_costumesTabButton setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab3-v-inactive"] forState:UIControlStateNormal];
    [_powerupTabButton setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab2-v-inactive"] forState:UIControlStateNormal];
    [_currencyTabButton setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab1-v-active"] forState:UIControlStateNormal];
}

- (IBAction)costumesTabButtonHit:(id)sender
{
    [self resetItemsArrayWithArray:_identifersRemovedForCostumesArray];
    
    [_costumesTabButton setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab3-v-active"] forState:UIControlStateNormal];
    [_powerupTabButton setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab2-v-inactive"] forState:UIControlStateNormal];
    [_currencyTabButton setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab1-v-inactive"] forState:UIControlStateNormal];
}

- (IBAction)powerupsTabButtonHit:(id)sender
{
    [self resetItemsArrayWithArray:_identifersRemovedForPowerupsArray];
    
    [_costumesTabButton setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab3-v-inactive"] forState:UIControlStateNormal];
    [_powerupTabButton setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab2-v-active"] forState:UIControlStateNormal];
    [_currencyTabButton setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab1-v-inactive"] forState:UIControlStateNormal];
}


- (void)resetItemsArrayWithArray:(NSMutableArray *)cleanOutArray
{
    [_inGameitemsArray removeAllObjects];
    [_inGameitemsArray setArray:_masterItemsArray];
    
    NSArray *tempArray = [[NSArray alloc] initWithArray:_inGameitemsArray];
    
    for (SKProduct *product in tempArray)
    {
        for (NSString *productName in cleanOutArray)
        {
            if ([product.productIdentifier isEqualToString:productName])
            {
                [_inGameitemsArray removeObject:product];
            }
        }
    }
    
    
    _currencyTabButton.userInteractionEnabled = NO;
    _costumesTabButton.userInteractionEnabled = NO;
    _powerupTabButton.userInteractionEnabled = NO;
    

    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ElectricDoor-Close" FileType:@"caf"]; //@"m4a"];
    
    if (_didAnimateConveyerBeltOut)
    {
        _didAnimateConveyerBeltOut = NO;
        
        [UIView animateWithDuration:1.2f animations:^
         {
             self.rightConveyerCoverImageView.frame = self.rightConveyerOriginRect;
             
             self.conveyerLockBaseImageView.frame = self.lockBaseOriginRect;
             
             self.conveyerLockImageView.frame = self.lockOriginRect;
             
             self.leftConveyerCoverImageView.frame = self.leftConveyerOriginRect;
             
         } completion:^(BOOL finished) {
             
             [UIView animateWithDuration:0.3f animations:^{
                 
                 self.conveyerLockImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
                 
             } completion:^(BOOL finished) {
                 
                 [self.storeItemsCollectionView reloadData];
                 
                 [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ElectricDoor-Open" FileType:@"caf"]; //@"m4a"];
                 
                 [UIView animateWithDuration:0.3f animations:^
                  {
                      self.conveyerLockImageView.transform = CGAffineTransformMakeRotation(M_PI);
                      
                  } completion:^(BOOL finished) {
                      
                      [UIView animateWithDuration:1.2f animations:^{
                          
                          CGRect rightConveyerFrame = self.rightConveyerCoverImageView.frame;
                          rightConveyerFrame.origin.x = kScreenWidth+self.rightConveyerCoverImageView.frame.origin.x;
                          self.rightConveyerCoverImageView.frame = rightConveyerFrame;
                          
                          CGRect lockedBaseConveyerFrame = self.conveyerLockBaseImageView.frame;
                          lockedBaseConveyerFrame.origin.x = kScreenWidth+self.conveyerLockBaseImageView.frame.origin.x;
                          self.conveyerLockBaseImageView.frame = lockedBaseConveyerFrame;
                          
                          CGRect lockConveyerFrame = self.conveyerLockImageView.frame;
                          lockConveyerFrame.origin.x = kScreenWidth+self.conveyerLockImageView.frame.origin.x;
                          self.conveyerLockImageView.frame = lockConveyerFrame;
                          
                          
                          CGRect leftConveyerFrame = self.leftConveyerCoverImageView.frame;
                          leftConveyerFrame.origin.x = - (kScreenWidth + self.leftConveyerCoverImageView.frame.origin.x);
                          self.leftConveyerCoverImageView.frame = leftConveyerFrame;
                          
                      } completion:^(BOOL finished) {
                          
                          _didAnimateConveyerBeltOut = YES;
                          
                          _currencyTabButton.userInteractionEnabled = YES;
                          _costumesTabButton.userInteractionEnabled = YES;
                          _powerupTabButton.userInteractionEnabled = YES;
                      }];
                  }];
             }];
         }];
    }
    else
    {
        
    }
}



- (IBAction)didSelectGameSection:(id)sender
{
    DebugLog(@"Selected Store Section: Game");
    self.gameSectionButton.selected = YES;
    self.playerSectionButton.selected = NO;
    self.planetsSectionButton.selected = NO;
}

- (IBAction)didSelectPlayerSection:(id)sender
{
    DebugLog(@"Selected Store Section: Player");
    self.gameSectionButton.selected = NO;
    self.playerSectionButton.selected = YES;
    self.planetsSectionButton.selected = NO;
}

- (IBAction)didSelectPlanetsSection:(id)sender
{
    DebugLog(@"Selected Store Section: Planets");
    self.gameSectionButton.selected = NO;
    self.playerSectionButton.selected = NO;
    self.planetsSectionButton.selected = YES;
}

- (IBAction)scrollItemsLeft:(id)sender
{
    _willKeepScrollingLeft = NO;
    
    self.scrollDirection = ScrollDirection_Left;
    
    DebugLog(@"Scroll store items left.");
    
    [self scrollLeft];
}

- (IBAction)touchDownScrollItemsLeft:(id)sender
{
    _willKeepScrollingLeft = YES;
}

- (IBAction)touchupOutSideScrollItemsLeft:(id)sender
{
    _willKeepScrollingLeft = YES;
}

- (IBAction)scrollItemsRight:(id)sender
{
    _willKeepScrollingRight = NO;
    
    self.scrollDirection = ScrollDirection_Right;
    
    DebugLog(@"Scroll store items right.");

    [self scrollRight];
}

- (IBAction)touchDownScrollItemsRight:(id)sender
{
    _willKeepScrollingRight = YES;
}

- (IBAction)touchupOutSideScrollItemsRight:(id)sender
{
    _willKeepScrollingRight = YES;
}

- (IBAction)testUpdateUserAccount:(id)sender
{
  
}

- (IBAction)exitStore:(id)sender
{
    [self.exitStoreSignButton setEnabled:NO];
    [self animateExitStore];
}

- (IBAction)restoreUserTransactions:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Restore InApp Purchases?"
                                                        message:@"Restore all prior non-consumable purchases to your player account."
                                                       delegate:self
                                              cancelButtonTitle:@"NO THANKS"
                                              otherButtonTitles:@"YES", nil];
    
    [alertView setTag:5];
    
    [alertView show];
}

- (IBAction)addCoinsCheat:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:10000]
                                                  costValue:nil
                                                   costType:CostType_None completionHandler:^
     (NSError *error, NSDictionary *updatedGameParametersDict)
     {
         if (!error && updatedGameParametersDict)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf animateCoinPurchaseType:YES
                                   gemPurchaseType:NO
                                    coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                      coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                     gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                       gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                 animationDuration:1.0f
                           willAnimateCoinsAndGems:YES];
             });
         }
     }];
}

- (IBAction)addGemsCheat:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [[CDIAPManager iapMananger] requestToIncreaseGemsValue:[NSNumber numberWithInt:50]
                                                 costValue:nil
                                                   costType:CostType_None completionHandler:^
     (NSError *error, NSDictionary *updatedGameParametersDict)
     {
         if (!error && updatedGameParametersDict)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf animateCoinPurchaseType:NO
                                   gemPurchaseType:YES
                                    coinStartValue:[weakSelf.coinCountLabel.text intValue]
                                      coinEndValue:[[SGAppDelegate appDelegate].accountDict[@"coins"] intValue]
                                     gemStartValue:[weakSelf.gemCountLabel.text intValue]
                                       gemEndValue:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]
                                 animationDuration:1.0f
                           willAnimateCoinsAndGems:YES];
             });
         }
     }];
}

#pragma mark - storeCostumeViewController Delegate

- (void)storeCostumeViewControllerDidExit:(CDStoreCostumeViewController *)storeCostumeViewController
{
    [storeCostumeViewController.view removeFromSuperview];
    [storeCostumeViewController removeFromParentViewController];
    storeCostumeViewController.delegate = nil;
    storeCostumeViewController = nil;
}


- (void)purchaseCostumeWithIAPIdentifier:(NSString *)identifier
{
    for (SKProduct *product in _inGameitemsArray)
    {
        if ([product.productIdentifier isEqualToString:identifier])
        {
            [[CDIAPManager iapMananger] purchaseProduct:product];
        }
    }
}

- (void)buyButtonHitInStoreCostumeViewController:(CDStoreCostumeViewController *)costumePopup WithCookieName:(NSString *)name WithCostumeTheme:(NSString *)theme
{
    [costumePopup.view removeFromSuperview];
    
    if ([name isEqualToString:KeyNameChip])
    {
        if ([theme isEqualToString:KeyThemeSuperHero])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_SuperChip];
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_FarmerChip];
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ZombieChip];
        }
    }
    else if ([name isEqualToString:KeyNameDustinMartianMint])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ChefDustinDoubleMint];
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_SuperDustinDoubleMint];
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ZombieDustinMartianMint];
        }
    }
    else if ([name isEqualToString:KeyNameGerryJ])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ChefGerry];
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_SuperGerry];
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_FarmerGerryJ];
        }
    }
    else if ([name isEqualToString:KeyNameJJJams])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ChefJJJams];
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_SuperHeroJJJams];
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_FarmerJJJams];
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ZombieJJJams];
        }
    }
    else if ([name isEqualToString:KeyNameLukeLocoLemon])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ChefLukeLocoLemon];
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_SuperLukeLocoLemon];
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_FarmerLukeLocoLemon];
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ZombieLukeLocoLemon];
        }
    }
    else if ([name isEqualToString:KeyNameMikeyMcSprinkles])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ChefMikeMcSprinkles];
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_SuperMikeMcSprinkles];
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_FarmerMikeyMcSprinkles];
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ZombieMikeyMcSprinkles];
        }
    }
    else if ([name isEqualToString:KeyNameReginald])
    {
        if ([theme isEqualToString:KeyThemeChef])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ChefReginald];
        }
        else if ([theme isEqualToString:KeyThemeSuperHero])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_SuperReginald];
        }
        else if ([theme isEqualToString:KeyThemeFarmer])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_FarmerReginald];
        }
        else if ([theme isEqualToString:KeyThemeZombie])
        {
            [self purchaseCostumeWithIAPIdentifier:IAPIdentifiers_ZombieReginald];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
