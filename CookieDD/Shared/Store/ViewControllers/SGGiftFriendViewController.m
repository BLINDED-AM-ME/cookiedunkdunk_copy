//
//  SGGiftFriendViewController.m
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

#import "SGGiftFriendViewController.h"

@interface SGGiftFriendViewController ()
@property (strong, nonatomic) UIViewController *parentPresentingViewController;
@property (strong, nonatomic) NSDictionary *friendInfoDict;
@end

@implementation SGGiftFriendViewController

#pragma mark - Initialization

- (void)setup
{
    _friendInfoDict = [NSDictionary new];
    
    _friendsArray = [NSMutableArray new];
    
    _wrappersArray = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"cdd-player-wrapper-blue"],
                                                      [UIImage imageNamed:@"cdd-player-wrapper-brown"],
                                                      [UIImage imageNamed:@"cdd-player-wrapper-green"],
                                                      [UIImage imageNamed:@"cdd-player-wrapper-orange"],
                                                      [UIImage imageNamed:@"cdd-player-wrapper-purple"],
                                                      [UIImage imageNamed:@"cdd-player-wrapper-red"],
                                                      [UIImage imageNamed:@"cdd-player-wrapper-yellow"]]];
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
	// Do any additional setup after loading the view.
    self.giftTitlelabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:25.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_uhOhMessageLabel setHidden:YES];
    
    [self fetchFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SGGiftFriendsCell";
    SGGiftFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(SGGiftFriendsCell *)cell indexPath:(NSIndexPath *)indexPath
{
    int randomWrapperIndex = arc4random() % [_wrappersArray count];
    UIImage *image = (UIImage *)_wrappersArray[randomWrapperIndex];
    
    cell.friendName.numberOfLines = 1;
    cell.friendName.font = [UIFont fontWithName:kFontDamnNoisyKids size:24.0f];
    cell.friendName.adjustsFontSizeToFitWidth = YES;
    cell.descriptionLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:14.0f];
    [cell.friendName setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
    if (!cell.wrapperImageView.image)
    {
        cell.wrapperImageView.image = image;
    }
    
    if ([_friendsArray count] > 0)
    {
        NSDictionary *friendInfoDict = _friendsArray[indexPath.row];
        
        if (friendInfoDict[@"firstName"] && friendInfoDict[@"lastName"])
        {
            NSString *firstName = friendInfoDict[@"firstName"];
            NSString *lastName = friendInfoDict[@"lastName"];
            cell.friendName.text = [NSString stringWithFormat:@" %@ %@", firstName, lastName];
        }
        
        if (friendInfoDict[@"profileAvatar"])
        {
            NSString *stringURL = friendInfoDict[@"profileAvatar"];
            NSURL *url = [NSURL URLWithString:stringURL];
            [[WebserviceManager sharedManager] requestImageAtURL:url indexPath:indexPath
                                               completionHandler:^
             (UIImage *image, NSIndexPath *indexPath, NSError *error)
            {
                if (image && !error)
                {
                    SGGiftFriendsCell *lastCell = (SGGiftFriendsCell *)[self.friendsTableView cellForRowAtIndexPath:indexPath];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                        UIImage *croppedImage = [[WebserviceManager sharedManager] cropPhoto:imageView withMaskedImage:[UIImage imageNamed:@"Profile-570x570"]];
                        lastCell.profileImageView.image = croppedImage;
                    });
                }
            }];
        }
        
        if (friendInfoDict[@"currentGameProgress"][@"levelType"] && friendInfoDict[@"currentGameProgress"][@"worldType"])
        {
            //NSString *currentWorld = friendInfoDict[@"currentGameProgress"][@"worldType"];
            int worldIndex = [friendInfoDict[@"currentGameProgress"][@"worldType"] intValue] - 1;
            NSString *currentWorld = [[SGFileManager fileManager] stringFromIndex:worldIndex
                                                                           inFile:@"planetoids-master-list"];
            NSString *currentLevel = friendInfoDict[@"currentGameProgress"][@"levelType"];
            
            cell.descriptionLabel.text = [NSString stringWithFormat:@" %@ - Level: %@", currentWorld, currentLevel];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_friendsArray count] > 0)
    {
        _friendInfoDict = _friendsArray[indexPath.row];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Gift Friend"
                                                            message:[NSString stringWithFormat:@"Are you sure you wish send gift to %@ %@", _friendInfoDict[@"firstName"], _friendInfoDict[@"lastName"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:[NSString stringWithFormat:@"Coins %i", self.productCoinValue],[NSString stringWithFormat:@"Gems %i", self.productJewelValue], nil];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            DebugLog(@"clicked no");
        }
            break;
        
        case 1:
        {
            DebugLog(@"clicked coins");
            
            int currentCurrencyOfCoins = [[SGAppDelegate appDelegate].accountDict[@"coins"] intValue];
            NSNumber *productCoinCost = [NSNumber numberWithInt:self.productCoinValue];
            
            DebugLog(@"currentCurrencyOfCoins %i", currentCurrencyOfCoins);
            
            if ([[CDIAPManager iapMananger] canPurchaeItemWithItemCosts:self.productCoinValue currentCurrency:currentCurrencyOfCoins])
            {
                [self giftFriend:_friendInfoDict giftCostType:@"coins" giftCostValue:productCoinCost giftPurchaseType:GiftPurchaseType_Coins];
            }
            else
            {
                [self dismissGiftPopOverViewWithPresentingViewController:nil];

                if ([self.delegate respondsToSelector:@selector(giftFriendViewControllerCanNotMakePurchase:)])
                {
                    [self.delegate giftFriendViewControllerCanNotMakePurchase:self];
                }
            }
        }
            break;
            
        case 2:
        {
            DebugLog(@"cliked gems");
            
            if ([[CDIAPManager iapMananger] canPurchaeItemWithItemCosts:self.productJewelValue currentCurrency:[[SGAppDelegate appDelegate].accountDict[@"gems"] intValue]])
            {
                [self giftFriend:_friendInfoDict giftCostType:@"gems" giftCostValue:[NSNumber numberWithInt:self.productJewelValue] giftPurchaseType:GiftPurchaseType_Gems];
            }
            else
            {
                [self dismissGiftPopOverViewWithPresentingViewController:nil];

                if ([self.delegate respondsToSelector:@selector(giftFriendViewControllerCanNotMakePurchase:)])
                {
                    [self.delegate giftFriendViewControllerCanNotMakePurchase:self];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Custom Methods

- (void)presentGiftPopOverViewWithPresentingViewController:(UIViewController *)parentViewController
                                                  giftType:(GiftType)giftType
                                          productCoinValue:(int)productCoinValue
                                         productJewelValue:(int)productJewelValue
                                                 giftValue:(int)giftValue
{
    self.productCoinValue = productCoinValue;
    
    self.productJewelValue = productJewelValue;
    
    [self checkGiftType:giftType];
    
    self.parentPresentingViewController = parentViewController;
   
    [parentViewController addChildViewController:self];
    
    [parentViewController.view addSubview:self.view];
    
    self.view.frame = CGRectMake(0, 0, parentViewController.view.frame.size.width, parentViewController.view.frame.size.height);

    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissGiftPopOverViewWithPresentingViewController:(UIViewController *)parentViewController
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


- (void)checkGiftType:(GiftType)type
{
    switch (type)
    {
        case GiftType_Default:
        {
            self.giftTypeString = @"";
        }
            break;
        
        case GiftType_Coins:
        {
            self.giftTypeString = @"coins";
        }
            break;
            
        case GiftType_Gems:
        {
            self.giftTypeString = @"gems";
        }
            break;
            
        case GiftType_Lives:
        {
            self.giftTypeString = @"lives";
        }
            break;
            
        case GiftType_Moves:
        {
            self.giftTypeString = @"moves";
        }
            break;
            
        case GiftType_Bomb:
        {
            self.giftTypeString = @"bomb";
        }
            break;
            
        case GiftType_PowerGlove:
        {
            self.giftTypeString = @"powerGlove";
        }
            break;
            
        case GiftType_RadioactiveSprinkle:
        {
            self.giftTypeString = @"radioactiveSprinkle";
        }
            break;
            
        case GiftType_SlotMachine:
        {
            self.giftTypeString = @"slotMachine";
        }
            break;
            
        case GiftType_Smore:
        {
            self.giftTypeString = @"smore";
        }
            break;
            
        case GiftType_Spatula:
        {
            self.giftTypeString = @"spatula";
        }
            break;
            
        case GiftType_Thunderbolt:
        {
            self.giftTypeString = @"thunderbolt";
        }
            break;
            
        case GiftType_WrappedCookie:
        {
            self.giftTypeString = @"wrappedCookie";
        }
            break;
            
        default:
            break;
    }
}

- (void)giftFriend:(NSDictionary *)friendInfoDict giftCostType:(NSString *)giftCostType giftCostValue:(NSNumber *)giftCostValue giftPurchaseType:(GiftPurchaseType)giftPurchaseType
{
    DebugLog(@"productJewelValue: %i  productCoinValue: %i", self.productJewelValue, self.productCoinValue);
    
    
    [[WebserviceManager sharedManager] requestToGiftFriendWithAccountEmail:[SGAppDelegate appDelegate].accountDict[@"email"]
                                                               friendEmail:friendInfoDict[@"email"]
                                                                  giftType:self.giftTypeString
                                                                giftAmount:@"1"
                                                              giftCostType:giftCostType
                                                             giftCostValue:giftCostValue
                                                            giftingMessage:[NSString stringWithFormat:@"%@ %@ sent you a gift!", [SGAppDelegate appDelegate].accountDict[@"firstName"], [SGAppDelegate appDelegate].accountDict[@"lastName"]]
                                                         completionHandler:^
     (NSError *error, NSDictionary *giftInfo)
    {
        if (!error && giftInfo)
        {
            //[SGAppDelegate appDelegate].accountDict = [giftInfo mutableCopy];
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissGiftPopOverViewWithPresentingViewController:self.parentPresentingViewController];
                
                if ([weakSelf.delegate respondsToSelector:@selector(giftFriendViewController:madePurchaseWithGiftPurchaseType:)])
                {
                    [weakSelf.delegate giftFriendViewController:weakSelf madePurchaseWithGiftPurchaseType:giftPurchaseType];
                }
            });
        }
        else if (error)
        {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissGiftPopOverViewWithPresentingViewController:weakSelf.parentPresentingViewController];
            });
        }

    }];
}

- (void)fetchFriends
{
    [[SGSocialManager socialManager] requestFacebookFriendsWithQueryType:FacebookTypeQueryFriendsHaveApp
                                                       CompletionHandler:^
     (FBRequestConnection *connection, NSArray *friendArray, NSError *error)
     {
         if (!error && friendArray)
         {
             // DebugLog(@"friends have app! %@", friendArray);
             
             NSMutableArray *friendIdArray = [NSMutableArray new];
             for (NSDictionary *friendDict in friendArray)
             {
                 if (friendDict[@"uid"])
                 {
                     NSString *facebookUID = [friendDict[@"uid"] stringValue];
                     [friendIdArray addObject:facebookUID];
                 }
             }
             
             [[WebserviceManager sharedManager] requestFriends:friendIdArray completionHandler:^
              (NSError *error, NSDictionary *friends)
              {
                  if (!error && friends)
                  {
                      if (friends[@"accounts"])
                      {
                          _friendsArray = [friends[@"accounts"] mutableCopy];
                          
                      }
                      
                      if ([_friendsArray count] <= 0 || ![_friendsArray count])
                      {
                          __weak typeof(self) weakSelf = self;
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [weakSelf.uhOhMessageLabel setHidden:NO];
                          });
                      }
                      else
                      {
                          __weak typeof(self) weakSelf = self;
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [weakSelf.friendsTableView reloadData];
                          });
                      }
                  }
              }];
         }
     }];
}

#pragma mark - IBActions

- (IBAction)exitGiftView:(id)sender
{
    [self dismissGiftPopOverViewWithPresentingViewController:self.parentPresentingViewController];
}

@end
