//
//  CDPurchasableItemPopupViewController.m
//  CookieDD
//
//  Created by Gary Johnston on 5/9/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDPurchasableItemPopupViewController.h"

@interface CDPurchasableItemPopupViewController() <LMInAppPurchaseManagerDelegate>

@property (strong, nonatomic) LMInAppPurchaseManager *iapManager;
@property (assign, nonatomic) int itemAmount;
@property (assign, nonatomic) int coinPrice;
@property (assign, nonatomic) int gemPrice;
@property (assign, nonatomic) float dollarPrice;
@property (strong, nonatomic) NSMutableArray *productsArray;
@end


@implementation CDPurchasableItemPopupViewController


#pragma mark - Initialization

- (void)setup
{
    _productsArray = [NSMutableArray new];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // init variables
        [self setup];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CDIAPManager iapMananger].delegate = self;
    
    NSSet *productIdentifiers = [NSSet setWithObjects:IAPIdentifier_NukeBooster, nil];
    
    [[CDIAPManager iapMananger] requestSpecificProductsWithProductIdentifiers:productIdentifiers];
}

- (void)setupUI
{
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         _largeGlareImage.transform = CGAffineTransformRotate(_largeGlareImage.transform, -M_PI);
                     }
                     completion:NULL];
    
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         _smallGlareImage.transform = CGAffineTransformRotate(_smallGlareImage.transform, M_PI);
                         
                     }
                     completion:NULL];
    
    [self setupPurchase];
}

- (void)setupPurchase
{
    // MAKE THIS SO IT IS NOT HARDCODED LATER!!!!
    [_itemTitleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    [_cancelButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    switch (_itemType)
    {
        case POWERUP_WRAPPER:
            _coinPrice = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_WrapperPowerup];
            _gemPrice = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_WrapperPowerup];
            _dollarPrice = 0.0f;
            _itemAmount = 5;
            
            [_itemImage setImage:[UIImage imageNamed:@"cdd-store-icon-wrapped"]];
            [_itemTitleLabel setText:[NSString stringWithFormat:@"WRAPPER (%i)", _itemAmount]];
            break;
            
        case POWERUP_SMORE:
            _coinPrice = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SmorePowerup];
            _gemPrice = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SmorePowerup];
            _dollarPrice = 0.0f;
            _itemAmount = 5;
            
            [_itemImage setImage:[UIImage imageNamed:@"cdd-store-icon-smores"]];
            [_itemTitleLabel setText:[NSString stringWithFormat:@"S'MORE (%i)", _itemAmount]];
            break;
            
        case POWERUP_SUPERGLOVE:
            _coinPrice = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            _gemPrice = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            _dollarPrice = 0.0f;
            _itemAmount = 5;
            
            [_itemImage setImage:[UIImage imageNamed:@"cdd-store-icon-super"]];
            [_itemTitleLabel setText:[NSString stringWithFormat:@"POWER PUNCH (%i)", _itemAmount]];
            break;
            
        case BOOSTER_NUKE:
            _coinPrice = 0;
            _gemPrice = 0;
            _dollarPrice = 2.99f;
            _itemAmount = 3;
            
            [_itemImage setImage:[UIImage imageNamed:@"cdd-store-icon-bomb"]];
            [_itemTitleLabel setText:[NSString stringWithFormat:@"THE NUKE (%i)", _itemAmount]];
            break;
            
        case BOOSTER_LIGHTNING:
            _coinPrice = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_LightningBooster];
            _gemPrice = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_LightningBooster];
            _dollarPrice = 0.0f;
            _itemAmount = 3;
            
            [_itemImage setImage:[UIImage imageNamed:@"cdd-store-icon-lightning"]];
            [_itemTitleLabel setText:[NSString stringWithFormat:@"LIGHTNING STRIKER (%i)", _itemAmount]];
            break;
            
        case BOOSTER_SLOTMACHINE:
            _coinPrice = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SlotMachineBooster];
            _gemPrice = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SlotMachineBooster];
            _dollarPrice = 0.0f;
            _itemAmount = 3;
            
            [_itemImage setImage:[UIImage imageNamed:@"cdd-store-icon-slots"]];
            [_itemTitleLabel setText:[NSString stringWithFormat:@"SLOT MACHINE (%i)", _itemAmount]];
            break;
            
        case BOOSTER_RADSPRINKLE:
            _coinPrice = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_RadioactiveSprinklePowerup];
            _gemPrice = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_RadioactiveSprinklePowerup];
            _dollarPrice = 0.0f;
            _itemAmount = 3;
            
            [_itemImage setImage:[UIImage imageNamed:@"item-nuke-sprinkles"]];
            [_itemTitleLabel setText:[NSString stringWithFormat:@"RADIOACTIVE SPRINKLES (%i)", _itemAmount]];
            break;
            
        case BOOSTER_SPATULA:
            _coinPrice = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SpatulaBooster];
            _gemPrice = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SpatulaBooster];
            _dollarPrice = 0.0f;
            _itemAmount = 3;
            
            [_itemImage setImage:[UIImage imageNamed:@"cdd-store-icon-spatula"]];
            [_itemTitleLabel setText:[NSString stringWithFormat:@"SPATULA SWITCH (%i)", _itemAmount]];
            break;
            
        default:
            break;
    }
    
    if (_coinPrice > 0)
    {
        [_coinsButtonTextLabel setText:[NSString stringWithFormat:@"%i COINS", _coinPrice]];
        [_coinsButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    }
    else
    {
        _coinsButton.hidden = YES;
        _coinsButtonTextLabel.hidden = YES;
    }
    
    if (_gemPrice > 0)
    {
        [_gemsButtonTextLabel setText:[NSString stringWithFormat:@"%i GEMS", _gemPrice]];
        [_gemsButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    }
    else if (_dollarPrice > 0.0f)
    {
        [_gemsButtonTextLabel setText:@"PURCHASE FOR 2.99"];
        [_gemsButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:13]];

        _cancelButton.frame = _coinsButton.frame;
        _cancelButtonTextLabel.frame = _coinsButtonTextLabel.frame;
        
        _gemsButton.frame = _gemsButton.frame;
        _gemsButtonTextLabel.frame = _gemsButtonTextLabel.frame;
        
        _coinsButton.hidden = YES;
        _coinsButtonTextLabel.hidden = YES;
    }
}

- (IBAction)cancelButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cancelButtonWasHitOnPurchasableItemPopup:)])
    {
        [self.delegate cancelButtonWasHitOnPurchasableItemPopup:self];
    }
}

- (IBAction)coinsButtonHit:(id)sender
{
    if ([[[SGAppDelegate appDelegate].accountDict objectForKey:@"coins"] intValue] >= _coinPrice)
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self.parentViewController withConditionType:ConditionalType_Default presentationType:PresentationType_Loading withFrame:self.view.frame errorDescription:nil loadingText:@"Loading..."];
        
        if (_itemType == POWERUP_WRAPPER)
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:[NSNumber numberWithInt:_itemAmount] bombValue:nil smoreValue:nil costValue:[NSNumber numberWithInt:_coinPrice] costType:CostType_Coins completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == POWERUP_SMORE)
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:nil bombValue:nil smoreValue:[NSNumber numberWithInt:_itemAmount] costValue:[NSNumber numberWithInt:_coinPrice] costType:CostType_Coins completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == POWERUP_SUPERGLOVE)
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:[NSNumber numberWithInt:_itemAmount] wrappedCookieValue:nil bombValue:nil smoreValue:nil costValue:[NSNumber numberWithInt:_coinPrice] costType:CostType_Coins completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == BOOSTER_NUKE)
        {
            DebugLog(@"Cannot buy for coins!!!!");
        }
        else if (_itemType == BOOSTER_LIGHTNING)
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:nil thunderboltValue:[NSNumber numberWithInt:_itemAmount] nukeValue:nil costValue:[NSNumber numberWithInt:_coinPrice] costType:CostType_Coins completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
              
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == BOOSTER_SLOTMACHINE)
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:[NSNumber numberWithInt:_itemAmount] thunderboltValue:nil nukeValue:nil costValue:[NSNumber numberWithInt:_coinPrice] costType:CostType_Coins completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == BOOSTER_RADSPRINKLE)
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:[NSNumber numberWithInt:_itemAmount] spatulaValue:nil slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:[NSNumber numberWithInt:_coinPrice] costType:CostType_Coins completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == BOOSTER_SPATULA)
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:[NSNumber numberWithInt:_itemAmount] slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:[NSNumber numberWithInt:_coinPrice] costType:CostType_Coins completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self
                                                                        withConditionType:ConditionalType_InsufficentFunds
                                                                         presentationType:PresentationType_Error
                                                                                withFrame:self.view.frame
                                                                         errorDescription:nil loadingText:nil];
    }
}

- (IBAction)gemsButtonHit:(id)sender
{
    if ([[[SGAppDelegate appDelegate].accountDict objectForKey:@"gems"] intValue] >= _gemPrice)
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self.parentViewController withConditionType:ConditionalType_Default presentationType:PresentationType_Loading withFrame:self.view.frame errorDescription:nil loadingText:@"Loading..."];
        
        if (_itemType == POWERUP_WRAPPER)
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:[NSNumber numberWithInt:_itemAmount] bombValue:nil smoreValue:nil costValue:[NSNumber numberWithInt:_gemPrice] costType:CostType_Gems completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == POWERUP_SMORE)
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:nil bombValue:nil smoreValue:[NSNumber numberWithInt:_itemAmount] costValue:[NSNumber numberWithInt:_gemPrice] costType:CostType_Gems completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == POWERUP_SUPERGLOVE)
        {
            [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:[NSNumber numberWithInt:_itemAmount] wrappedCookieValue:nil bombValue:nil smoreValue:nil costValue:[NSNumber numberWithInt:_gemPrice] costType:CostType_Gems completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == BOOSTER_NUKE)
        {
//            [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.view.frame errorDescription:@"Must figure out how to get IAP in main game!" loadingText:nil];

//            _iapManager.delegate = self;
//            
//            
//            [[CDIAPManager iapMananger] requestProducts];
//            
//            NSMutableArray *productsArray = [CDIAPManager iapMananger].validProductsInStore;
////            SKProduct *product = 
//            
////            [[CDIAPManager iapMananger] purchaseProduct:product];
            
            NSPredicate *filterProductPredicate = [NSPredicate predicateWithFormat:@"productIdentifier MATCHES[cd] %@", IAPIdentifier_NukeBooster];
            
            NSArray *filteredArray = [_productsArray filteredArrayUsingPredicate:filterProductPredicate];
            
            if ([filteredArray count] > 0)
            {
                SKProduct *nukeProduct = (SKProduct *)filteredArray[0];
                
                if ([nukeProduct isKindOfClass:[SKProduct class]])
                {
                    DebugLog(@"product title: %@", nukeProduct.localizedTitle);
                    
                    [[CDIAPManager iapMananger] purchaseProduct:nukeProduct];
                }
            }
        }
        else if (_itemType == BOOSTER_LIGHTNING)
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:nil thunderboltValue:[NSNumber numberWithInt:_itemAmount] nukeValue:nil costValue:[NSNumber numberWithInt:_gemPrice] costType:CostType_Gems completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == BOOSTER_SLOTMACHINE)
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:[NSNumber numberWithInt:_itemAmount] thunderboltValue:nil nukeValue:nil costValue:[NSNumber numberWithInt:_gemPrice] costType:CostType_Gems completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == BOOSTER_RADSPRINKLE)
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:[NSNumber numberWithInt:_itemAmount] spatulaValue:nil slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:[NSNumber numberWithInt:_gemPrice] costType:CostType_Gems completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
        else if (_itemType == BOOSTER_SPATULA)
        {
            [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:[NSNumber numberWithInt:_itemAmount] slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:[NSNumber numberWithInt:_gemPrice] costType:CostType_Gems completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                    {
                        [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                    }
                    
                    [[SGAppDelegate appDelegate] dismissConditionalView];
                });
            }];
        }
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self
                                                                        withConditionType:ConditionalType_InsufficentFunds
                                                                         presentationType:PresentationType_Error
                                                                                withFrame:self.view.frame
                                                                         errorDescription:nil loadingText:nil];
    }
}

#pragma mark - LMInAppPurchaseManagerDelegate

- (void)iapManager:(LMInAppPurchaseManager *)iapManager didLoadStoreProducts:(NSArray *)products
{

    // NOTE
    // Grab our in app purchases here....
    _productsArray = [products mutableCopy];
    
}

- (void)iapManager:(LMInAppPurchaseManager *)iapManager isProcessingTransAction:(SKPaymentTransaction *)transAction
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [weakSelf.itemInfoViewController animateOut];
        
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SGAppDelegate appDelegate] dismissConditionalView];
    });
    
    if ([productIdentifier isEqualToString:IAPIdentifier_NukeBooster])
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
             __weak typeof(self) weakSelf = self;
             dispatch_async(dispatch_get_main_queue(), ^{
                 if ([weakSelf.delegate respondsToSelector:@selector(boughtSomethingInPurchaseableItemPopup:WithItemCount:)])
                 {
                     [weakSelf.delegate boughtSomethingInPurchaseableItemPopup:weakSelf WithItemCount:weakSelf.itemAmount];
                 }
                 
                 [[SGAppDelegate appDelegate] dismissConditionalView];
             });
         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
