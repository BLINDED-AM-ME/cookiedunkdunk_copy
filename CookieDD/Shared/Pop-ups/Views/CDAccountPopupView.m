//
//  CDAccountPopupView.m
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

#import "CDAccountPopupView.h"
#import "CDStandardPopupView.h"
#import "CDAccountCollectionCell.h"
#import "SGAppDelegate.h"
#import "WebserviceManager.h"
#import "CDAchievementDisplayPopupViewController.h"
#import "CDStoreViewController.h"

#import "CDCookieCostumeSelectionView.h"

@interface CDAccountPopupView() <CDStandardPopupViewDelegate, CDAchievementDisplayPopupViewControllerDelegate, CDCookieCostumeSelectionViewDelegate>

@property (strong, nonatomic) CDAchievementDisplayPopupViewController *popup;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *gender;

@property (strong, nonatomic) NSDate *birthDate;
@property (strong, nonatomic) NSURL *imageUrl;

@property (strong, nonatomic) NSDictionary *accountDictionary;
@property (strong, nonatomic) NSMutableDictionary *selectedCookieInfoDict;
@property (strong, nonatomic) NSMutableArray *boosterKeysArray;
@property (strong, nonatomic) NSMutableArray *selectedCookieCostumeArray;
@property (strong, nonatomic) NSMutableArray *cookieCostumeArray;
@property (strong, nonatomic) NSMutableArray *cookieCostumeDetailsArray;
@property (strong, nonatomic) UIViewController *parentalViewController;

@property (strong, nonatomic) NSArray *cookieNakedCostumesArray;
@property (strong, nonatomic) NSArray *cookieChefCostumesArray;
@property (strong, nonatomic) NSArray *cookieSuperCostumesArray;

@property (assign, nonatomic) BOOL achievementPopupIsUp;
@property (strong, nonatomic) NSMutableDictionary *account;

@property (strong, nonatomic) NSMutableArray *cookieArray;

@property (strong, nonatomic) CDCookieCostumeSelectionView *cookieCostumeSelectionView;

@end


@implementation CDAccountPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        [self setup];
    }
    return self;
}

#pragma mark - Check Account Type
// TODO: Fix this popup to present either player data or friend data...
- (void)presentAccountScreenWithAccountInfo:(NSDictionary *)accountInfoDict
                    accountPresentationType:(AccountPresentationType)type
{
    
}

// Note
// show player account info....

- (void)setupWithParentalViewController:(UIViewController *)parentViewController
{
    _cookieCostumeArray = [NSMutableArray new];
    _cookieCostumeDetailsArray = [NSMutableArray new];
    _selectedCookieCostumeArray = [NSMutableArray new];
    _selectedCookieInfoDict = [NSMutableDictionary new];
    _cookieArray = [NSMutableArray new];
    
    _showCookieCostumeSelection = YES;
    
//    if ([SGAppDelegate appDelegate].accountDict[@"cookieCostumes"])
//    {
//        _cookieCostumeArray = [SGAppDelegate appDelegate].accountDict[@"cookieCostumes"];
//    }
    
//    NSPredicate *selectedCostumesPredicate = [NSPredicate predicateWithFormat:@"isSelected == 1"];
//    NSArray *filterSelectedCostumes = [_cookieCostumeArray filteredArrayUsingPredicate:selectedCostumesPredicate];
//    _selectedCookieCostumeArray = [filterSelectedCostumes mutableCopy];
    
//    NSDictionary *chipDictionary = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameChip, @"cookieName",
//                                    @"cdd-store-icon-cookie-chip", @"cookieImageName",
//                                    @"cdd-store-icon-chip", @"plainSuperImageName",
//                                    @"cdd-store-icon-superchip", @"dunkopolisSuperImageName", nil];
//    
//    NSDictionary *dustinDictionary = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameDustinMartianMint, @"cookieName",
//                                    @"cdd-store-icon-cookie-dustin", @"cookieImageName",
//                                    @"cdd-store-icon-dustin", @"plainSuperImageName",
//                                    @"cdd-store-icon-supergreen", @"dunkopolisSuperImageName", nil];
//    
//    NSDictionary *mikeyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameMikeyMcSprinkles, @"cookieName",
//                                    @"cdd-store-icon-cookie-mikey", @"cookieImageName",
//                                    @"cdd-store-icon-mikey", @"plainSuperImageName",
//                                    @"cdd-store-icon-superblue", @"dunkopolisSuperImageName", nil];
//    
//    NSDictionary *lukeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameLukeLocoLemon, @"cookieName",
//                                    @"cdd-store-icon-cookie-luke", @"cookieImageName",
//                                    @"cdd-store-icon-luke", @"plainSuperImageName",
//                                    @"cdd-store-icon-superyellow", @"dunkopolisSuperImageName", nil];
//    
//    NSDictionary *gerryDictionary = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameGerryJ, @"cookieName",
//                                    @"cdd-store-icon-cookie-gerry", @"cookieImageName",
//                                    @"cdd-store-icon-gerry", @"plainSuperImageName",
//                                    @"cdd-store-icon-superpurple", @"dunkopolisSuperImageName", nil];
//    
//    NSDictionary *reginaldDictionary = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameReginald, @"cookieName",
//                                    @"cdd-store-icon-cookie-reggie", @"cookieImageName",
//                                    @"cdd-store-icon-reginald", @"plainSuperImageName",
//                                    @"cdd-store-icon-superorange", @"dunkopolisSuperImageName", nil];
//    
//    NSDictionary *jjDictionary = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameJJJams, @"cookieName",
//                                    @"cdd-store-icon-cookie-jj", @"cookieImageName",
//                                    @"cdd-store-icon-jj", @"plainSuperImageName",
//                                    @"cdd-store-icon-superred", @"dunkopolisSuperImageName", nil];
    
    NSUserDefaults *cookieCostumesArrayDefault = [NSUserDefaults standardUserDefaults];
    NSArray *tempArray = [NSArray arrayWithArray:[cookieCostumesArrayDefault objectForKey:CookieCostumeArrayDefault]];
    
    for (NSDictionary *dictionary in tempArray)
    {
        NSMutableDictionary *mutableDict = [dictionary mutableCopy];
        
        if (![_cookieArray containsObject:mutableDict])
        {
            [_cookieArray addObject:mutableDict];
        }
        else
        {
            DebugLog(@"How did this get in here????");
        }
    }
    
    [cookieCostumesArrayDefault setObject:_cookieArray forKey:CookieCostumeArrayDefault];
    
    [self.costumesCollectionView reloadData];
    
    
    _playerAccountView.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
    _statsView.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
    _inventoryView.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [_globalLeaderboardTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:11]];
    [_globalLeaderboardTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _globalLeaderboardTextLabel.adjustsFontSizeToFitWidth = YES;
    
    [_friendLeaderboardTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:11]];
    [_friendLeaderboardTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _friendLeaderboardTextLabel.adjustsFontSizeToFitWidth = YES;
    
    [_playerTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    [_playerTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _playerTextLabel.adjustsFontSizeToFitWidth = YES;
    
    [_inventoryTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    [_inventoryTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _inventoryTextLabel.adjustsFontSizeToFitWidth = YES;
    
    [_statsTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    [_statsTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _statsTextLabel.adjustsFontSizeToFitWidth = YES;
    
    [_planetAndLevelLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_planetAndLevelLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _planetAndLevelLabel.adjustsFontSizeToFitWidth = YES;
    
    [_playerNameLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_playerNameLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _playerNameLabel.adjustsFontSizeToFitWidth = YES;
    
    [_facebookLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:10]];
    [_facebookLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _facebookLabel.adjustsFontSizeToFitWidth = YES;
    
    [_googleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:10]];
    [_googleLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _googleLabel.adjustsFontSizeToFitWidth = YES;
    
    [_twitterLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:10]];
    [_twitterLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _twitterLabel.adjustsFontSizeToFitWidth = YES;
    
    [_trophyTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_trophyTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _trophyTextLabel.adjustsFontSizeToFitWidth = YES;
    
    [_gemTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_gemTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _gemTextLabel.adjustsFontSizeToFitWidth = YES;
    
    [_gemCountLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_gemCountLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _gemCountLabel.adjustsFontSizeToFitWidth = YES;
    
    [_coinsTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_coinsTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _coinsTextLabel.adjustsFontSizeToFitWidth = YES;
    
    [_coinCountLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_coinCountLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _coinCountLabel.adjustsFontSizeToFitWidth = YES;
    
    [_powerupTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_powerupTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _powerupTextLabel.adjustsFontSizeToFitWidth = YES;
    
    [_costumeTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_costumeTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _costumeTextLabel.adjustsFontSizeToFitWidth = YES;
    
//    [_cookieNameLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:26.0f]];
//    [_cookieNameLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
//
//    [_selectCookieTitleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12.0f]];
//    [_selectCookieTitleLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    // cookie Costume Detail view
    [_backButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17.0f]];
    [_backButtonTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
//    [_cookieNameLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12.0f]];
//    [_cookieNameLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];

    _accountDictionary = [SGAppDelegate appDelegate].accountDict;
    
    NSString *stringURL = _accountDictionary[@"profileAvatar"];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[WebserviceManager sharedManager] requestImageAtURL:url completionHandler:^(NSError *error, NSIndexPath *indexPath, UIImage *image) {
        if (image && !error)
        {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                UIImage *croppedImage = [[WebserviceManager sharedManager] cropPhoto:imageView withMaskedImage:[UIImage imageNamed:@"Profile-300x300"]];
                weakSelf.profileImage.image = croppedImage;
            });
        }
        else
        {
            _profileImage.image = [UIImage imageNamed:@"mainmenu-cookie-select-chip-frame01"];
        }
    }];
//    DebugLog(@"Dictionary: %@", _accountDictionary);
    
    NSString *nameString = @"";
    if (_accountDictionary[@"firstName"] && ![_accountDictionary[@"firstName"] isEqualToString:@""]) {
        nameString = _accountDictionary[@"firstName"];
    }
    if (_accountDictionary[@"lastName"] && ![_accountDictionary[@"lastName"] isEqualToString:@""]) {
        nameString = [NSString stringWithFormat:@"%@ %@", nameString, _accountDictionary[@"lastName"]];
    }
    if ([nameString isEqualToString:@""]) {
        nameString = @"Chip";
    }
    _playerNameLabel.text = nameString;
    
    _coinCountLabel.text = [NSString stringWithFormat:@"%i", [_accountDictionary[@"coins"] intValue]];
    _gemCountLabel.text = [NSString stringWithFormat:@"%i", [_accountDictionary[@"gems"] intValue]];
    
    [_trophiesCollectionView registerNib:[UINib nibWithNibName:@"CDAccountCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CDAccountCollectionCell"];
    [_costumesCollectionView registerNib:[UINib nibWithNibName:@"CDAccountCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CDAccountCollectionCell"];
    [_powerupCollectionView registerNib:[UINib nibWithNibName:@"CDAccountCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CDAccountCollectionCell"];
//    [_cookieCostumeDetailCollectionView registerNib:[UINib nibWithNibName:@"CDAccountCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CDAccountCollectionCell"];

    
    _parentalViewController = parentViewController;
    
    _numberOfCellsInCollectionView = 10;
    
    _boosterKeysArray = [NSMutableArray arrayWithArray:[_accountDictionary[@"boosters"] allKeys]];
    [_boosterKeysArray removeObject:@"__v"];
    [_boosterKeysArray removeObject:@"_id"];
    
    [_boosterKeysArray addObjectsFromArray:[_accountDictionary[@"powerups"] allKeys]];
    [_boosterKeysArray removeObject:@"__v"];
    [_boosterKeysArray removeObject:@"_id"];
    
    _cancelLeaderboardButtonHit = NO;
    
    _inventoryView.hidden = YES;
    _statsView.hidden = YES;
    _googleButton.hidden = YES;
    _googleLabel.hidden = YES;
    _gemAddButton.hidden = YES;
    
    _globalLeaderBoardButton.enabled = NO;
    _globalLeaderboardTextLabel.enabled = NO;
    
    _friendLeaderboardButton.enabled = NO;
    _friendLeaderboardTextLabel.enabled = NO;

    NSArray *worldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
    NSDictionary *currentWorldDict = [worldsArray lastObject];
    int worldIndex = [currentWorldDict[@"type"] intValue] - 1;
    NSString *worldReference = [[SGFileManager fileManager] stringFromIndex:worldIndex inFile:@"planetoids-master-list"];
    NSDictionary *worldInfo = [[SGFileManager fileManager] loadDictionaryWithFileName:worldReference OfType:@"plist"];
    NSString *worldName = worldInfo[@"displayName"];
    
    NSArray *levelsArray = currentWorldDict[@"levels"];
    NSDictionary *currentLevelDict = [levelsArray lastObject];
    int levelNumber = [currentLevelDict[@"type"] intValue];
    
    _planetAndLevelLabel.text = [NSString stringWithFormat:@"%@ / %i", worldName, levelNumber];
    
    if (_buttonIsOpenForRotation == 1)
    {
        [self accountButtonOneHit:_accountButtonOne];
    }
    else if (_buttonIsOpenForRotation == 2)
    {
        [self accountButtonTwoHit:_accountButtonTwo];
    }
    else if (_buttonIsOpenForRotation == 3)
    {
        [self accountButtonThreeHit:_accountButtonThree];
    }
    else
    {
        [self accountButtonOneHit:_accountButtonOne];
    }
    
    if (_leaderboardIsUp)
    {
        [self displayLeaderboard];
    }
    
//    [self.cookieCostumeDetailView setHidden:YES];
    
    UIImage *flippedImage = [UIImage imageWithCGImage:_splashRight.image.CGImage scale:_splashRight.image.scale orientation:UIImageOrientationUpMirrored];
    _splashRight.image = flippedImage;
    
    
    
    //////////////////////////////////////
    //// Loading costumes into arrays ////
    //////////////////////////////////////
    
//    // Nakeds
//    NSDictionary *chipNakedDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameChip, @"name", KeyThemeDefault, @"theme", @"cdd-store-icon-chip", nil];
//    NSDictionary *dustinNakedDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameDustinMartianMint, @"name", KeyThemeDefault, @"theme", @"cdd-store-icon-dustin", nil];
//    NSDictionary *lukeNakedDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameLukeLocoLemon, @"name", KeyThemeDefault, @"theme", @"cdd-store-icon-luke", nil];
//    NSDictionary *mikeyNakedDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameMikeyMcSprinkles, @"name", KeyThemeDefault, @"theme", @"cdd-store-icon-mikey", nil];
//    NSDictionary *reggieNakedDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameReginald, @"name", KeyThemeDefault, @"theme", @"cdd-store-icon-reginald", nil];
//    NSDictionary *jjNakedDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameJJJams, @"name", KeyThemeDefault, @"theme", @"cdd-store-icon-jj", nil];
//    NSDictionary *gerryNakedDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameGerryJ, @"name", KeyThemeDefault, @"theme", @"cdd-store-icon-gerry", nil];
//
//    _cookieNakedCostumesArray = [NSArray arrayWithObjects:chipNakedDict, dustinNakedDict, gerryNakedDict, jjNakedDict, lukeNakedDict, mikeyNakedDict, reggieNakedDict, nil];
//    
//    // Chefs
//    NSDictionary *chipChefDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameChip, @"name", KeyThemeChef, @"theme", @"cdd-store-icon-chefchip", nil];
//    NSDictionary *dustinChefDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameDustinMartianMint, @"name", KeyThemeChef, @"theme", @"cdd-store-icon-chefdustin", nil];
//    NSDictionary *lukeChefDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameLukeLocoLemon, @"name", KeyThemeChef, @"theme", @"cdd-store-icon-chefluke", nil];
//    NSDictionary *mikeyChefDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameMikeyMcSprinkles, @"name", KeyThemeChef, @"theme", @"cdd-store-icon-chefmikey", nil];
//    NSDictionary *reggieChefDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameReginald, @"name", KeyThemeChef, @"theme", @"cdd-store-icon-chefreggie", nil];
//    NSDictionary *jjChefDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameJJJams, @"name", KeyThemeChef, @"theme", @"cdd-store-icon-chefjj", nil];
//    NSDictionary *gerryChefDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameGerryJ, @"name", KeyThemeChef, @"theme", @"cdd-store-icon-chefgerry", nil];
//    
//    _cookieChefCostumesArray = [NSArray arrayWithObjects:chipChefDict, dustinChefDict, gerryChefDict, jjChefDict, lukeChefDict, mikeyChefDict, reggieChefDict, nil];
//    
//    // Supers
//    NSDictionary *chipSuperDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameChip, @"name", KeyThemeSuperHero, @"theme", @"cdd-store-icon-superchip", nil];
//    NSDictionary *dustinSuperDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameDustinMartianMint, @"name", KeyThemeSuperHero, @"theme", @"cdd-store-icon-superdustin", nil];
//    NSDictionary *lukeSuperDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameLukeLocoLemon, @"name", KeyThemeSuperHero, @"theme", @"cdd-store-icon-superluke", nil];
//    NSDictionary *mikeySuperDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameMikeyMcSprinkles, @"name", KeyThemeSuperHero, @"theme", @"cdd-store-icon-supermikey", nil];
//    NSDictionary *reggieSuperDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameReginald, @"name", KeyThemeSuperHero, @"theme", @"cdd-store-icon-superreggie", nil];
//    NSDictionary *jjSuperDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameJJJams, @"name", KeyThemeSuperHero, @"theme", @"cdd-store-icon-superjj", nil];
//    NSDictionary *gerrySuperDict = [NSDictionary dictionaryWithObjectsAndKeys:KeyNameGerryJ, @"name", KeyThemeSuperHero, @"theme", @"cdd-store-icon-supergerry", nil];
//    
//    _cookieSuperCostumesArray = [NSArray arrayWithObjects:chipSuperDict, dustinSuperDict, gerrySuperDict, jjSuperDict, lukeSuperDict, mikeySuperDict, reggieSuperDict, nil];
    
    
    [self loadAchievements];
}

- (IBAction)accountButtonOneHit:(id)sender
{
    DebugLog(@"Account button one.");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"];
    
    if (!_leaderboardIsUp)
    {
        _cancelLeaderboardButtonHit = YES;
        _buttonIsOpenForRotation = 1;
    
        [_accountButtonOne setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab1-v-active"] forState:UIControlStateNormal];
        [_accountButtonTwo setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab2-v-inactive"] forState:UIControlStateNormal];
        [_accountButtonThree setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab3-v-inactive"] forState:UIControlStateNormal];

        _playerAccountView.hidden = NO;
        _inventoryView.hidden = YES;
        _statsView.hidden = YES;
    }
}

- (IBAction)accountButtonTwoHit:(id)sender
{
    DebugLog(@"Account button two.");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"];
    
    if (!_leaderboardIsUp)
    {
        _cancelLeaderboardButtonHit = YES;
        _buttonIsOpenForRotation = 2;
    
        [_accountButtonOne setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab1-v-inactive"] forState:UIControlStateNormal];
        [_accountButtonTwo setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab2-v-active"] forState:UIControlStateNormal];
        [_accountButtonThree setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab3-v-inactive"] forState:UIControlStateNormal];
    
        _playerAccountView.hidden = YES;
        _inventoryView.hidden = NO;
        _statsView.hidden = YES;
    }
}

- (IBAction)accountButtonThreeHit:(id)sender
{
    DebugLog(@"Account button three.");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"];
    
    if (!_leaderboardIsUp)
    {
        _cancelLeaderboardButtonHit = NO;
        _buttonIsOpenForRotation = 3;
        
        [_accountButtonOne setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab1-v-inactive"] forState:UIControlStateNormal];
        [_accountButtonTwo setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab2-v-inactive"] forState:UIControlStateNormal];
        [_accountButtonThree setBackgroundImage:[UIImage imageNamed:@"cdd-hud-panel-acctab3-v-active"] forState:UIControlStateNormal];
        
        _playerAccountView.hidden = YES;
        _inventoryView.hidden = YES;
        _statsView.hidden = NO;
    }
}

- (IBAction)exitButtonHit:(id)sender
{
    [_cookieCostumeSelectionView removeFromSuperview];
    _cookieCostumeSelectionView = nil;
    if ([self.delegate respondsToSelector:@selector(exitButtonWasHitOnAccountPopup:)])
    {
        [self.delegate exitButtonWasHitOnAccountPopup:self];
    }
}

///////////////////////////////
//// Player Account Screen ////
///////////////////////////////

- (IBAction)googleButtonHit:(id)sender
{
    DebugLog(@"Google Button Hit");
}

- (IBAction)facebookButtonHit:(id)sender
{
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click 2" FileType:@"caf"];
    
    NSString *facebookMessage = @"Come join me in the Cookieverse!";
    NSString *facebookTitle = @"Cookie Dunk Dunk";
    
    if ([SGAppDelegate appDelegate].loggedInThroughFacebook)
    {
        [[SGSocialManager socialManager] SGSocialManagerDidShareFacebbokWithTitle:facebookTitle withMessage:facebookMessage withImage:nil withViewController:_parentalViewController completionHandler:^(BOOL didFinishSharing) {
            
        }];
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:_parentalViewController withConditionType:ConditionalType_Default presentationType:PresentationType_Loading withFrame:self.frame errorDescription:nil loadingText:nil];
        
        [[SGSocialManager socialManager] openSessionFacebookWithCompletionHandler:^(FBSession *session, FBSessionState state, NSError *error)
         {
             if (!error)
             {
                 if (state != FBSessionStateOpen)
                 {
                     
                 }
                 switch (state)
                 {
                     case FBSessionStateOpen:
                     {
                         DebugLog(@"FBSessionStateOpen");
                         [[SGSocialManager socialManager] requestUserInfoFromFacebookWithCompletionHandler:^(NSError *error, NSDictionary *userInfo)
                          {
                              __weak typeof(self) weakSelf = self;
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  if (!error && userInfo)
                                  {
                                      if (userInfo[@"email"])
                                      {
                                          weakSelf.emailAddress = userInfo[@"email"];
                                      }
                                      
                                      if (userInfo[@"first_name"])
                                      {
                                          weakSelf.firstName = userInfo[@"first_name"];
                                      }
                                      
                                      if (userInfo[@"last_name"])
                                      {
                                          weakSelf.lastName = userInfo[@"last_name"];
                                      }
                                      
                                      if (userInfo[@"birthday"])
                                      {
                                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                          [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                                          weakSelf.birthDate = [dateFormatter dateFromString:userInfo[@"birthday"]];
                                      }
                                      
                                      if (userInfo[@"gender"])
                                      {
                                          weakSelf.gender = userInfo[@"gender"];
                                      }
                                      
                                      NSString *facebookId = nil;
                                      
                                      NSString *stringURL = nil;
                                      if (userInfo[@"id"])
                                      {
                                          facebookId = userInfo[@"id"];
                                          
                                          [[NSUserDefaults standardUserDefaults] setObject:facebookId forKey:@"facebookId"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          stringURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=600&height=600", facebookId];
                                          weakSelf.imageUrl = [NSURL URLWithString:stringURL];
                                      }
                                      
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                      
                                      
                                      [SGAppDelegate appDelegate].loggedInThroughFacebook = YES;
                                      [[WebserviceManager sharedManager] requestToUpdateAccountWithEmail:weakSelf.emailAddress deviceId:[SGAppDelegate appDelegate].currentDeviceID firstName:weakSelf.firstName lastName:weakSelf.lastName gender:weakSelf.gender birthdate:weakSelf.birthDate facebookID:facebookId didRecieveGift:nil completionHandler:^(NSDictionary *dictionary, NSError *error) {
                                          
                                          if (dictionary)
                                          {
                                              if (dictionary[@"account"] && [dictionary[@"account"] isKindOfClass:[NSDictionary class]])
                                              {
                                                  [SGAppDelegate appDelegate].accountDict = [dictionary[@"account"] mutableCopy];
                                              }
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [[SGAppDelegate appDelegate] dismissConditionalView];
                                                  [[SGSocialManager socialManager] SGSocialManagerDidShareFacebbokWithTitle:facebookTitle withMessage:facebookMessage withImage:nil withViewController:_parentalViewController completionHandler:^(BOOL didFinishSharing) {
                                                      
                                                  }];
                                              });
                                          }
                                          else if (error)
                                          {
                                              [[SGAppDelegate appDelegate] dismissConditionalView];
                                              [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:_parentalViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.frame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
                                              
                                              __weak typeof(self) weakSelf = self;
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  weakSelf.parentalViewController.view.userInteractionEnabled = YES;
                                              });
                                          }
                                          else
                                          {
                                              __weak typeof(self) weakSelf = self;
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  weakSelf.parentalViewController.view.userInteractionEnabled = YES;
                                              });
                                          }
                                      }];
                                      
                                      
                                      [[SGSocialManager socialManager] socialClassRequestAccessFriendsFromFacebook];
                                  }
                              });
                          }];
                     }
                         break;
                     case FBSessionStateClosed:
                     {
                         DebugLog(@"FBSessionStateClosed");
                     }
                         break;
                     case FBSessionStateClosedLoginFailed:
                     {
                         DebugLog(@"FBSessionStateClosedLoginFailed");
                     }
                         break;
                     case FBSessionStateCreated:
                     {
                         DebugLog(@"FBSessionStateCreated");
                     }
                         break;
                     case FBSessionStateCreatedOpening:
                     {
                         DebugLog(@"FBSessionStateCreatedOpening");
                     }
                         break;
                     case FBSessionStateCreatedTokenLoaded:
                     {
                         DebugLog(@"FBSessionStateCreatedTokenLoaded");
                     }
                         break;
                     case FBSessionStateOpenTokenExtended:
                     {
                         DebugLog(@"FBSessionStateOpenTokenExtended");
                     }
                         break;
                     default:
                         break;
                 }
             }
             else
             {
                 [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:_parentalViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.frame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
             }
             
         }];
    }
}

- (IBAction)twitterButtonHit:(id)sender
{
    DebugLog(@"Twitter Button Hit");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"];
    
    [[SGSocialManager socialManager] SGSocialManagerDidSendTweet:[SGSocialManager socialManager] UIViewController:_parentalViewController titleMessage:@"Cookie Dunk Dunk" bodyMessageOne:@"Come join me in the Cookieverse!" bodyMessagetwo:@"Join me in Cookie Dunk Dunk!" picture:nil completionHandler:^(BOOL didFinishSharing) {
        
    }];
}

//////////////////////////
//// Inventory Screen ////
//////////////////////////
- (IBAction)costumeNextButtonHit:(id)sender
{
    DebugLog(@"Next Costume Button Hit");
    [self nextButtonWasHitForCollectionView:_costumesCollectionView];
}

- (IBAction)costumePreviousButtonHit:(id)sender
{
    DebugLog(@"Previous Costume Button Hit");
    [self previousButtonWasHitForCollectionView:_costumesCollectionView];
}

- (IBAction)powerupPreviousButtonHit:(id)sender
{
    DebugLog(@"Previous Powerup Button Hit");
    [self previousButtonWasHitForCollectionView:_powerupCollectionView];
}

- (IBAction)powerupNextButtonHit:(id)sender
{
    DebugLog(@"Next Powerup Button Hit");
    [self nextButtonWasHitForCollectionView:_powerupCollectionView];
}

- (IBAction)coinsAddButtonHit:(id)sender
{
    DebugLog(@"Added Coins!");
    if ([self.delegate respondsToSelector:@selector(addCoinsButtonWasHitOnAccountPopup:)])
    {
        [self.delegate addCoinsButtonWasHitOnAccountPopup:self];
    }
}

- (IBAction)gemAddButtonHit:(id)sender
{
    DebugLog(@"Added Gems!");
}


#pragma mark - cookie costume table view

- (void)showCostumeTableViewWithCookieInfo:(NSDictionary *)cookieInfo cellFrame:(CGRect)cellFrame
{
    
    //DebugLog(@"showCostumeTableViewWithCookieInfo");
        
    if (_showCookieCostumeSelection)
    {
        _showCookieCostumeSelection = NO;
    
        _cookieCostumeSelectionView = [[[NSBundle mainBundle] loadNibNamed:@"CDCookieCostumeSelectionView" owner:self options:nil] objectAtIndex:0];
        _cookieCostumeSelectionView.delegate = self;
        
        _accountButtonOne.userInteractionEnabled = NO;
        _accountButtonTwo.userInteractionEnabled = NO;
        _accountButtonThree.userInteractionEnabled = NO;
        
        _coinAddButton.userInteractionEnabled = NO;
        
        if ([SGAppDelegate appDelegate].accountDict[@"cookieCostumes"])
        {
            _cookieCostumeArray = [SGAppDelegate appDelegate].accountDict[@"cookieCostumes"];
        }
        NSPredicate *selectedCostumesPredicate = [NSPredicate predicateWithFormat:@"isSelected == 1"];
        NSArray *filterSelectedCostumes = [_cookieCostumeArray filteredArrayUsingPredicate:selectedCostumesPredicate];
        _selectedCookieCostumeArray = [filterSelectedCostumes mutableCopy];
        [self.costumesCollectionView reloadData];
        
        NSString *cookieName = nil;
        
        if (cookieInfo[@"cookieName"])
        {
            cookieName = cookieInfo[@"cookieName"];
        }
        
        NSPredicate *cookieNamePredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", cookieName];
        [_cookieCostumeSelectionView setupWithArray:[[_cookieCostumeArray filteredArrayUsingPredicate:cookieNamePredicate] mutableCopy]];
        
        float yOffset = (cellFrame.origin.y - _cookieCostumeSelectionView.frame.size.height) - 2;
        CGRect targetFrame = CGRectMake(cellFrame.origin.x, yOffset, cellFrame.size.width, _cookieCostumeSelectionView.frame.size.height);
        _cookieCostumeSelectionView.frame = targetFrame;
        
        [self addSubview:_cookieCostumeSelectionView];
    }
    else
    {
        // Allow cookie costume selection view to be shown
        _showCookieCostumeSelection = YES;
        [self enableUserInteraction];
    }
    
}


#pragma mark - cookie Costume DetailView

- (IBAction)exitCookieCostumeDetailView:(id)sender
{
//    [self.cookieCostumeDetailView setHidden:YES];
    
    //DebugLog(@"exitCookieCostumeDetailView");
    _playerAccountView.hidden = YES;
    _inventoryView.hidden = NO;
    _statsView.hidden = YES;
    
    [self.profileBackGroundImageView setHidden:NO];
    [self.splashLeft setHidden:NO];
    [self.splashRight setHidden:NO];
    [self.profileImage setHidden:NO];
    
    [self.accountButtonOne setHidden:NO];
    [self.accountButtonTwo setHidden:NO];
    [self.accountButtonThree setHidden:NO];
    [self.playerTextLabel setHidden:NO];
    [self.inventoryTextLabel setHidden:NO];
    [self.statsTextLabel setHidden:NO];
    
}

- (void)showCookieCostumeDetailViewWithCookieDetails:(NSDictionary *)cookieInfo
{
//    [self.cookieCostumeDetailView setHidden:NO];

    //DebugLog(@"showCookieCostumeDetailViewWithCookieDetails");
    
    _playerAccountView.hidden = YES;
    _inventoryView.hidden = YES;
    _statsView.hidden = YES;

    [self.profileBackGroundImageView setHidden:YES];
    [self.splashLeft setHidden:YES];
    [self.splashRight setHidden:YES];
    [self.profileImage setHidden:YES];

    [self.accountButtonOne setHidden:YES];
    [self.accountButtonTwo setHidden:YES];
    [self.accountButtonThree setHidden:YES];

    [self.playerTextLabel setHidden:YES];
    [self.inventoryTextLabel setHidden:YES];
    [self.statsTextLabel setHidden:YES];

    [self refreshCookieCostumeDetail:cookieInfo];
}

- (void)refreshCookieCostumeDetail:(NSDictionary *)cookieInfo
{
    //DebugLog(@"refresh");
    
    if ([SGAppDelegate appDelegate].accountDict[@"cookieCostumes"])
    {
        _cookieCostumeArray = [SGAppDelegate appDelegate].accountDict[@"cookieCostumes"];
    }

    NSPredicate *selectedCostumesPredicate = [NSPredicate predicateWithFormat:@"isSelected == 1"];
    NSArray *filterSelectedCostumes = [_cookieCostumeArray filteredArrayUsingPredicate:selectedCostumesPredicate];
    _selectedCookieCostumeArray = [filterSelectedCostumes mutableCopy];
    [self.costumesCollectionView reloadData];
    
    NSString *cookieName = nil;
    
    if (cookieInfo[@"cookieName"])
    {
        cookieName = cookieInfo[@"cookieName"];
    }
    
    NSPredicate *cookieNamePredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", cookieName];
    
//    if ([cookieName isEqualToString:KeyNameChip])
//    {
//        _cookieNameLabel.text = @"Chip";
//    }
//    else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
//    {
//        _cookieNameLabel.text = @"Dustin Double Mint";
//    }
//    else if ([cookieName isEqualToString:KeyNameGerryJ])
//    {
//        _cookieNameLabel.text = @"Gerry J.";
//    }
//    else if ([cookieName isEqualToString:KeyNameJJJams])
//    {
//        _cookieNameLabel.text = @"JJ Jamz";
//    }
//    else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
//    {
//        _cookieNameLabel.text = @"Luke Loco Lemon";
//    }
//    else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
//    {
//        _cookieNameLabel.text = @"Mikey McSprinkles";
//    }
//    else if ([cookieName isEqualToString:KeyNameReginald])
//    {
//        _cookieNameLabel.text = @"Reginald";
//    }
//    
//    [_cookieImageView setImage:[UIImage imageWithData:[cookieInfo objectForKey:@"currentSuperImage"]]];//= [self setCookieIconImageWithCookieName:cookieName];
    
    _cookieCostumeDetailsArray = [[_cookieCostumeArray filteredArrayUsingPredicate:cookieNamePredicate] mutableCopy];
    
//    if ([_cookieCostumeDetailsArray count] > 0)
//    {
//        [_cookieCostumeDetailCollectionView reloadData];
//    }
}

//- (UIImage *)setCookieIconImageWithCookieName:(NSString *)cookieName
//{
//    UIImage *cookieImage = nil;
//    
//    if ([cookieName isEqualToString:KeyNameChip])
//    {
//        cookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-chip"];
//    }
//    else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
//    {
//        cookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-dustin"];
//    }
//    else if ([cookieName isEqualToString:KeyNameGerryJ])
//    {
//        cookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-gerry"];
//    }
//    else if ([cookieName isEqualToString:KeyNameJJJams])
//    {
//        cookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-jj"];
//    }
//    else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
//    {
//        cookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-luke"];
//    }
//    else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
//    {
//        cookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mikey"];
//    }
//    else if ([cookieName isEqualToString:KeyNameReginald])
//    {
//        cookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-reggie"];
//    }
//    
//    return cookieImage;
//}

//- (IBAction)costumeDetailScrollLeft:(id)sender {
//    [self previousButtonWasHitForCollectionView:_cookieCostumeDetailCollectionView];
//}
//
//- (IBAction)costumeDetailScrollRight:(id)sender {
//    [self nextButtonWasHitForCollectionView:_cookieCostumeDetailCollectionView];
//}

#pragma mark - Stats

//////////////////////
//// Stats Screen ////
//////////////////////
- (IBAction)friendLeaderboardButtonHit:(id)sender
{
    DebugLog(@"Friend Leaderboard Button Hit");
    _leaderBoardIsGlobal = NO;
    [self displayLeaderboard];
}

- (IBAction)globalLeaderBoardButtonHit:(id)sender
{
    DebugLog(@"Global Leaderboard Button Hit");
    _leaderBoardIsGlobal = YES;
    [self displayLeaderboard];
}

- (IBAction)trophyPreviousButtonHit:(id)sender
{
//    DebugLog(@"Trophy Previous Button Hit");
    [self previousButtonWasHitForCollectionView:_trophiesCollectionView];
}

- (IBAction)trophyNextButtonHit:(id)sender
{
//    DebugLog(@"Trophy Next Button Hit");
    [self nextButtonWasHitForCollectionView:_trophiesCollectionView];
}

- (void)displayLeaderboard
{
    if ((_buttonIsOpenForRotation == 3) && (!_cancelLeaderboardButtonHit))
    {
        _fadeView.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        CDStandardPopupView *popup = [[[NSBundle mainBundle] loadNibNamed:@"CDStandardPopupView" owner:self options:nil] objectAtIndex:0];
       
        popup.whatAmILoading = @"leaderboard";
        popup.delegate = self;
        
        popup.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:popup];
        [popup setup];
        
        _leaderboardIsUp = YES;
        
        _cancelLeaderboardButtonHit = YES;
    }
}

#pragma mark - Standard Popup View Delegate
- (void)exitButtonWasHitOnStandardPopupView:(CDStandardPopupView *)standardPopup
{
    _fadeView.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:.7];
    
    _leaderboardIsUp = NO;
    _leaderBoardIsGlobal = NO;
    _cancelLeaderboardButtonHit = NO;
    
    [standardPopup removeFromSuperview];
}

#pragma mark - Collection View
/////////////////////////
//// Collection View ////
/////////////////////////

- (void)nextButtonWasHitForCollectionView:(UICollectionView *)collectionView
{
    if ((collectionView.contentOffset.x) < collectionView.contentSize.width-170)
    {
        [collectionView setContentOffset:CGPointMake(collectionView.contentOffset.x + 35, 0.0f)];
    }
    else
    {
        DebugLog(@"At end");
    }
}

- (void)previousButtonWasHitForCollectionView:(UICollectionView *)collectionView
{
    if ((collectionView.contentOffset.x + 5) > 0)
    {
        [collectionView setContentOffset:CGPointMake(collectionView.contentOffset.x - 35, 0.0f)];
    }
    else
    {
        DebugLog(@"At end");
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cookieCostumeSelectionView != nil)
    {
        [_cookieCostumeSelectionView removeFromSuperview];
        _cookieCostumeSelectionView = nil;
        //_showCookieCostumeSelection = YES;
    }
    
    if (collectionView == _trophiesCollectionView)
    {
        _popup = [_parentalViewController.storyboard instantiateViewControllerWithIdentifier:@"CDAchievementDisplayPopupViewController"];
        
        if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            _popup.view.frame = _parentalViewController.view.frame;
        }
        else
        {
            _popup.view.frame = CGRectMake(0, 0, _parentalViewController.view.frame.size.width, _parentalViewController.view.frame.size.height);
        }
        
        [_popup.achievementImage setImage:[UIImage imageNamed:@"cdd-hud-ico-trophy-locked"]];
        
        NSString *achievementKey = _achievementKeys[indexPath.row];
        
        if ([SGGameCenterManager gcManager].achievementsDictionary[achievementKey] != nil)
        {
            GKAchievementDescription *achievement = [SGGameCenterManager gcManager].achievementDescriptions[achievementKey];
            [achievement loadImageWithCompletionHandler:^(UIImage *image, NSError *error) {
                if (error != nil)
                {
                    DebugLog(@"Error loading achievement image: %@", error.description);
                }
                else
                {
                    if (image != nil)
                    {
                        [self addSubview:_popup.view];
                        [_popup.achievementImage setImage:image];
                        _popup.achievementNameLabel.text = achievement.title;
                        _popup.achievementDescriptionLabel.text = achievement.achievedDescription;
                        _popup.delegate = self;
                    }
                    else
                    {
                        DebugLog(@"Warning: Achievement image is nil.");
                        [_popup.achievementImage setImage:[UIImage imageNamed:@"cdd-main-board-hud-icon-erron"]];
                    }
                }
            }];
        }
        else
        {
            GKAchievementDescription *achievement = [SGGameCenterManager gcManager].achievementDescriptions[achievementKey];
            [achievement loadImageWithCompletionHandler:^(UIImage *image, NSError *error) {
                if (error != nil)
                {
                    DebugLog(@"Error loading achievement image: %@", error.description);
                }
                else
                {
                    if (image != nil)
                    {
                        [self addSubview:_popup.view];
                        [_popup.achievementImage setImage:[UIImage imageNamed:@"cdd-hud-ico-trophy-locked"]];
                        _popup.achievementNameLabel.text = achievement.title;
                        _popup.achievementDescriptionLabel.text = @"Uh oh! This achievement is currently locked!";//achievement.achievedDescription;
                        _popup.delegate = self;
                    }
                    else
                    {
                        DebugLog(@"Warning: Achievement image is nil.");
                        [_popup.achievementImage setImage:[UIImage imageNamed:@"cdd-main-board-hud-icon-erron"]];
                    }
                }
            }];
        }
    }
    else if (collectionView == _costumesCollectionView)
    {
        if (!_isMainGame)
        {
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"];
            if ([_cookieArray count] > 0)
            {
                NSMutableDictionary *cookieDictionary = _cookieArray[indexPath.row];
                NSString *cookieName = nil;
                
                if (cookieDictionary[@"cookieName"])
                {
                    cookieName = cookieDictionary[@"cookieName"];
                }
                
                if (![cookieName isEqualToString:KeyNameMoorie] && ![cookieName isEqualToString:KeyNameCheri] && ![cookieName isEqualToString:KeyNameStar])
                {
                    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
                    CGRect cellRect = [cell convertRect:cell.bounds toView:self];
                    [self showCostumeTableViewWithCookieInfo:cookieDictionary cellFrame:cellRect];
    //                [self showCookieCostumeDetailViewWithCookieDetails:cookieDictionary];
                }
            }
            else
            {
                DebugLog(@"No cookies in the array....");
            }
        }
    }
//    else if (collectionView == _cookieCostumeDetailCollectionView)
//    {
//        /*
//         // Key Values currentSelectedCookieID, isSelected, isUnlocked, newlySelectedCookieId
//         
//         [updateCookieCostumes addObject:@{
//         @"currentSelectedCookieId": @"53534b30d43fe94d134f5abb",
//         @"isSelected": [NSNumber numberWithBool:YES],
//         @"isUnlocked": [NSNumber numberWithBool:YES],
//         @"newlySelectedCookieId": @"53534b30d43fe94d134f5ac2"}];
//         */
//        if ([_cookieCostumeDetailsArray count] > 0)
//        {
//            NSDictionary *selectedCookieInfo = _cookieCostumeDetailsArray[indexPath.row];
//            
//            BOOL isUnlocked = NO;
//            
//            if (selectedCookieInfo[@"isUnlocked"])
//            {
//                isUnlocked = [selectedCookieInfo[@"isUnlocked"] boolValue];
//            }
//            
//            
//            if (isUnlocked)
//            {
//                UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//                
//                cell = (CDAccountCollectionCell *)cell;
//                
//                [_selectedCookieInfoDict removeAllObjects];
//                
//                NSString *newlySelectedCookieId = nil;
//                
//                if (selectedCookieInfo[@"_id"])
//                {
//                    newlySelectedCookieId = selectedCookieInfo[@"_id"];
//                }
//                
//                if (newlySelectedCookieId)
//                {
//                    _selectedCookieInfoDict[@"newlySelectedCookieId"] = newlySelectedCookieId;
//                }
//                
//                // NOTE
//                // filter for the currently selected cookie so we can unselect it and make the new cookie selected.
//                NSPredicate *filterSelectedCookie = [NSPredicate predicateWithFormat:@"isSelected == 1"];
//                
//                NSArray *currentSelectedCookie = [_cookieCostumeDetailsArray filteredArrayUsingPredicate:filterSelectedCookie];
//                
//                if ([currentSelectedCookie count] > 0)
//                {
//                    __block NSDictionary *currentSelectedCookieInfo = currentSelectedCookie[0];
//                 
//                    NSInteger lastIndex = [_cookieCostumeDetailsArray indexOfObject:currentSelectedCookieInfo];
//                    
//                    NSIndexPath *lastSelectedIndexPath = [NSIndexPath indexPathForItem:lastIndex inSection:0];
//                    CDAccountCollectionCell *lastSelectedCell = (CDAccountCollectionCell *)[collectionView cellForItemAtIndexPath:lastSelectedIndexPath];
//                    [lastSelectedCell.lockedView setHidden:NO];
//                    
//                    CDAccountCollectionCell *cell = (CDAccountCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//                    [cell.lockedView setHidden:YES];
//                    NSString *currentSelectedCookieId = nil;
//                    
//                    if (currentSelectedCookieInfo[@"_id"])
//                    {
//                        currentSelectedCookieId = currentSelectedCookieInfo[@"_id"];
//                        _selectedCookieInfoDict[@"currentSelectedCookieId"] = currentSelectedCookieId;
//                    }
//                    
//                    _selectedCookieInfoDict[@"isSelected"] = [NSNumber numberWithBool:YES];
//                    
//                    NSMutableArray *cookiesArray = [NSMutableArray new];
//                    
//                    [cookiesArray addObject:_selectedCookieInfoDict];
//                    
//                    [_cookieImageView setImage:cell.icon.image];
//                    
//                    for (NSMutableDictionary *dictionary in _cookieArray)
//                    {
//                        if ([[dictionary objectForKey:@"cookieName"] isEqualToString:cell.cellCookieName])
//                        {
////                            DebugLog(@"cookie name: %@", cell.cellCookieName);
//                            
////                            NSMutableDictionary *jjCostumeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:KeyNameJJJams, @"cookieName", UIImagePNGRepresentation([UIImage imageNamed:@"cdd-store-icon-jj"]), @"currentSuperImage", CookieThemeStandard, @"imageTheme", nil];
//                            
//                            [dictionary setObject:UIImagePNGRepresentation(cell.icon.image) forKey:@"currentSuperImage"];
//                            [dictionary setObject:cell.cellTheme forKey:@"cookieTheme"];
//                            
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:_cookieArray forKey:CookieCostumeArrayDefault];
//                        }
//                    }
////
////                    [[WebserviceManager sharedManager] requestToUpdateCookieCostumesWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
////                                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
////                                                                               cookieCostumes:cookiesArray completionHandler:^
////                     (NSError *error, NSDictionary *cookieCostumesInfo)
////                     {
////                         if (!error && cookieCostumesInfo)
////                         {
////                             __weak typeof(self) weakSelf = self;
////                             dispatch_async(dispatch_get_main_queue(), ^{
////                                 
////                                 [weakSelf refreshCookieCostumeDetail:currentSelectedCookieInfo];
////                             });
////                         }
////                     }];
//                }
//            }
//        }
//    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _trophiesCollectionView)
    {
        return [[SGGameCenterManager gcManager].achievementDescriptions count];
    }
    else if (collectionView == _powerupCollectionView)
    {
        return [_boosterKeysArray count];
    }
    else if (collectionView == _costumesCollectionView)
    {
        return [_cookieArray count];
    }
//    else if (collectionView == _cookieCostumeDetailCollectionView)
//    {
//        return [_cookieCostumeDetailsArray count];
//    }
    
    return _numberOfCellsInCollectionView;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDAccountCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDAccountCollectionCell" forIndexPath:indexPath];
    [cell.lockedView setHidden:YES];
    
    if (collectionView == _trophiesCollectionView)
    {
        [cell.icon setImage:[UIImage imageNamed:@"cdd-hud-ico-trophy-locked"]];
        
        NSString *achievementKey = _achievementKeys[indexPath.row];
        
        //DebugLog(@"achievementsDictionary = %@", [SGGameCenterManager gcManager].achievementsDictionary);
        if ([SGGameCenterManager gcManager].achievementsDictionary[achievementKey] != nil) {
            GKAchievementDescription *achievement = [SGGameCenterManager gcManager].achievementDescriptions[achievementKey];
            [achievement loadImageWithCompletionHandler:^(UIImage *image, NSError *error) {
                if (error != nil) {
                    DebugLog(@"Error loading achievement image: %@", error.description);
                }
                else {
                    if (image != nil) {
                        [cell.icon setImage:image];
                    }
                    else {
                        DebugLog(@"Warning: Achievement image is nil.");
                        [cell.icon setImage:[UIImage imageNamed:@"cdd-main-board-hud-icon-erron"]];
                    }
                }
            }];
        }
        
        return cell;
    }
    else if (collectionView == _costumesCollectionView)
    {
        NSDictionary *cookieDictionary = [_cookieArray objectAtIndex:indexPath.row];
        [self configureCell:cell collectionView:collectionView indexPath:indexPath];
        [cell.icon setImage:[UIImage imageWithData:[cookieDictionary objectForKey:@"currentSuperImage"]]];
        
        return cell;
    }
//    else if (collectionView == _cookieCostumeDetailCollectionView)
//    {
//        [self configureCell:cell collectionView:collectionView indexPath:indexPath];
//        
//        return cell;
//    }
    else if (collectionView == _powerupCollectionView)
    {
        cell.powerupCountLabel.hidden = NO;
        [cell.powerupCountLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:18]];
        [cell.powerupCountLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        cell.powerupCountLabel.adjustsFontSizeToFitWidth = YES;
        cell.powerupCountLabel.minimumScaleFactor = 1;
        
        cell.icon.contentMode = UIViewContentModeScaleToFill;
        
        if ([[_boosterKeysArray objectAtIndex:indexPath.row] isEqualToString:@"nuke"])
        {
            [cell.icon setImage:[UIImage imageNamed:@"cdd-store-icon-bomb"]];
            if ([[_accountDictionary[@"boosters"] objectForKey:@"nuke"] intValue] > 0)
            {
                if ([[_accountDictionary[@"boosters"] objectForKey:@"nuke"] intValue] <= 99)
                {
                    cell.powerupCountLabel.text = [NSString stringWithFormat:@"%i", [[_accountDictionary[@"boosters"] objectForKey:@"nuke"] intValue]];
                }
                else
                {
                    cell.powerupCountLabel.text = @"99+";
                }
            }
            else
            {
                cell.powerupCountLabel.text = @"0";
            }
        }
        else if ([[_boosterKeysArray objectAtIndex:indexPath.row] isEqualToString:@"radioactiveSprinkle"])
        {
            [cell.icon setImage:[UIImage imageNamed:@"cdd-store-icon-sprinkles"]];
            if ([[_accountDictionary[@"boosters"] objectForKey:@"radioactiveSprinkle"] intValue] > 0)
            {
                if ([[_accountDictionary[@"boosters"] objectForKey:@"radioactiveSprinkle"] intValue] <= 99)
                {
                    cell.powerupCountLabel.text = [NSString stringWithFormat:@"%i", [[_accountDictionary[@"boosters"] objectForKey:@"radioactiveSprinkle"] intValue]];
                }
                else
                {
                    cell.powerupCountLabel.text = @"99+";
                }
            }
            else
            {
                cell.powerupCountLabel.text = @"0";
            }
        }
        else if ([[_boosterKeysArray objectAtIndex:indexPath.row] isEqualToString:@"slotMachine"])
        {
            [cell.icon setImage:[UIImage imageNamed:@"cdd-store-icon-slots"]];
            if ([[_accountDictionary[@"boosters"] objectForKey:@"slotMachine"] intValue] > 0)
            {
                if ([[_accountDictionary[@"boosters"] objectForKey:@"slotMachine"] intValue] <= 99)
                {
                    cell.powerupCountLabel.text = [NSString stringWithFormat:@"%i", [[_accountDictionary[@"boosters"] objectForKey:@"slotMachine"] intValue]];
                }
                else
                {
                    cell.powerupCountLabel.text = @"99+";
                }
            }
            else
            {
                cell.powerupCountLabel.text = @"0";
            }
        }
        else if ([[_boosterKeysArray objectAtIndex:indexPath.row] isEqualToString:@"spatula"])
        {
            [cell.icon setImage:[UIImage imageNamed:@"cdd-store-icon-spatula"]];
            if ([[_accountDictionary[@"boosters"] objectForKey:@"spatula"] intValue] > 0)
            {
                if ([[_accountDictionary[@"boosters"] objectForKey:@"spatula"] intValue] <= 99)
                {
                    cell.powerupCountLabel.text = [NSString stringWithFormat:@"%i", [[_accountDictionary[@"boosters"] objectForKey:@"spatula"] intValue]];
                }
                else
                {
                    cell.powerupCountLabel.text = @"99+";
                }
            }
            else
            {
                cell.powerupCountLabel.text = @"0";
            }
        }
        else if ([[_boosterKeysArray objectAtIndex:indexPath.row] isEqualToString:@"thunderbolt"])
        {
            [cell.icon setImage:[UIImage imageNamed:@"cdd-store-icon-lightning"]];
            if ([[_accountDictionary[@"boosters"] objectForKey:@"thunderbolt"] intValue] > 0)
            {
                if ([[_accountDictionary[@"boosters"] objectForKey:@"thunderbolt"] intValue] <= 99)
                {
                    cell.powerupCountLabel.text = [NSString stringWithFormat:@"%i", [[_accountDictionary[@"boosters"] objectForKey:@"thunderbolt"] intValue]];
                }
                else
                {
                    cell.powerupCountLabel.text = @"99+";
                }
            }
            else
            {
                cell.powerupCountLabel.text = @"0";
            }
        }
        else if ([[_boosterKeysArray objectAtIndex:indexPath.row] isEqualToString:@"wrappedCookie"])
        {
            [cell.icon setImage:[UIImage imageNamed:@"cdd-store-icon-wrapped"]];
            if ([[_accountDictionary[@"powerups"] objectForKey:@"wrappedCookie"] intValue] > 0)
            {
                if ([[_accountDictionary[@"powerups"] objectForKey:@"wrappedCookie"] intValue] <= 99)
                {
                    cell.powerupCountLabel.text = [NSString stringWithFormat:@"%i", [[_accountDictionary[@"powerups"] objectForKey:@"wrappedCookie"] intValue]];
                }
                else
                {
                    cell.powerupCountLabel.text = @"99+";
                }
            }
            else
            {
                cell.powerupCountLabel.text = @"0";
            }
        }
        else if ([[_boosterKeysArray objectAtIndex:indexPath.row] isEqualToString:@"powerGlove"])
        {
            [cell.icon setImage:[UIImage imageNamed:@"cdd-store-icon-super"]];
            if ([[_accountDictionary[@"powerups"] objectForKey:@"powerGlove"] intValue] > 0)
            {
                if ([[_accountDictionary[@"powerups"] objectForKey:@"powerGlove"] intValue] <= 99)
                {
                    cell.powerupCountLabel.text = [NSString stringWithFormat:@"%i", [[_accountDictionary[@"powerups"] objectForKey:@"powerGlove"] intValue]];
                }
                else
                {
                    cell.powerupCountLabel.text = @"99+";
                }
            }
            else
            {
                cell.powerupCountLabel.text = @"0";
            }
        }
        else if ([[_boosterKeysArray objectAtIndex:indexPath.row] isEqualToString:@"smore"])
        {
            [cell.icon setImage:[UIImage imageNamed:@"cdd-store-icon-smores"]];
            if ([[_accountDictionary[@"powerups"] objectForKey:@"smore"] intValue] > 0)
            {
                if ([[_accountDictionary[@"powerups"] objectForKey:@"smore"] intValue] <= 99)
                {
                    cell.powerupCountLabel.text = [NSString stringWithFormat:@"%i", [[_accountDictionary[@"powerups"] objectForKey:@"smore"] intValue]];
                }
                else
                {
                    cell.powerupCountLabel.text = @"99+";
                }
            }
            else
            {
                cell.powerupCountLabel.text = @"0";
            }
        }
        else
        {
            cell.powerupCountLabel.hidden = YES;
            [cell.icon setImage:[UIImage imageNamed:@"cdd-main-board-hud-icon-erron"]];
        }
        
        return cell;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(35, 35);
}

- (void)configureCell:(CDAccountCollectionCell *)cell collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    //DebugLog(@"configureCell");
    if (collectionView == _costumesCollectionView)
    {
        if ([_selectedCookieCostumeArray count] > 0)
        {
            NSDictionary *cookieCostumeInfoDict = _selectedCookieCostumeArray[indexPath.row];
            
            NSString *theme = nil;
            
            NSString *cookieName = nil;
            
            if (cookieCostumeInfoDict[@"theme"])
            {
                theme = cookieCostumeInfoDict[@"theme"];
            }
            
            if (cookieCostumeInfoDict[@"name"])
            {
                cookieName = cookieCostumeInfoDict[@"name"];
            }
            
            cell.icon.image = [self themedCookieImage:theme cookieName:cookieName];
        }
    }
//    else if (collectionView == _cookieCostumeDetailCollectionView)
//    {
//        if ([_cookieCostumeDetailsArray count] > 0)
//        {
//            NSDictionary *cookieCostumeInfoDict = _cookieCostumeDetailsArray[indexPath.row];
//            
//            NSString *theme = nil;
//            
//            NSString *cookieName = nil;
//            
//            BOOL isUnlocked = NO;
//            BOOL isSelected = NO;
//            
//            [cell.lockedView setHidden:YES];
//
//            
//            if (cookieCostumeInfoDict[@"theme"])
//            {
//                theme = cookieCostumeInfoDict[@"theme"];
//                cell.cellTheme = theme;
//            }
//            
//            if (cookieCostumeInfoDict[@"name"])
//            {
//                cookieName = cookieCostumeInfoDict[@"name"];
//                cell.cellCookieName = cookieName;
//            }
//            
//            if (cookieCostumeInfoDict[@"isUnlocked"])
//            {
//                isUnlocked = [cookieCostumeInfoDict[@"isUnlocked"] boolValue];
//            }
//            
//            if (cookieCostumeInfoDict[@"isSelected"])
//            {
//                isSelected = [cookieCostumeInfoDict[@"isSelected"] boolValue];
//            }
//            
//            
//            if (isUnlocked)
//            {
//                cell.icon.image = [self themedCookieImage:theme cookieName:cookieName];
//                
//                if (!isSelected)
//                {
//                    [cell.lockedView setHidden:NO];
//                }
//            }
//            else
//            {
//                [cell.lockedView setHidden:YES];
//                cell.icon.image = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
//            }
//        }
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _costumesCollectionView)
    {
        if (_cookieCostumeSelectionView)
        {
            [_cookieCostumeSelectionView removeFromSuperview];
            _cookieCostumeSelectionView = nil;
            _showCookieCostumeSelection = YES;
            
            // Re-enable user interaction after scrolling
            [self enableUserInteraction];
        }
    }
}

- (UIImage *)themedCookieImage:(NSString *)theme cookieName:(NSString *)cookieName
{
    UIImage *themedCookieImage = nil;
    
    if ([theme isEqualToString:KeyThemeChef])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefchip"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefdustin"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefgerry"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefjj"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefluke"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefmikey"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefreggie"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeSuperHero])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superchip"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superdustin"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-supergerry"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superjj"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superluke"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-supermikey"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superreggie"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeFarmer])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerchip"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerdustin"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmergerry"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerjj"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerluke"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmermikey"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerreggie"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeZombie])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombieschip"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesdustin"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesgerry"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesjj"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesluke"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesmikey"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesreggie"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeWestern])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeEgypt])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeMedieval])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeOriental])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemePirate])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeSoldier])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    
    return themedCookieImage;
}

#pragma mark - Costume Selection Delegate
- (void)costumeSelectionViewDidSelectCostumeWithCell:(CDCookieCostumeSelectionTableViewCell *)cell
{
    //DebugLog(@"costumeSelectionViewDidSelectCostumeWithCell");
    _showCookieCostumeSelection = YES;
    
    [_cookieCostumeSelectionView removeFromSuperview];
    _cookieCostumeSelectionView = nil;
    
//    _costumesCollectionView.userInteractionEnabled = YES;
//    _powerupCollectionView.userInteractionEnabled = YES;
    
    _accountButtonOne.userInteractionEnabled = YES;
    _accountButtonTwo.userInteractionEnabled = YES;
    _accountButtonThree.userInteractionEnabled = YES;
    
    _coinAddButton.userInteractionEnabled = YES;
    
    for (NSMutableDictionary *dictionary in _cookieArray)
    {
        if ([[dictionary objectForKey:@"cookieName"] isEqualToString:cell.cellCookieName])
        {
            [dictionary setObject:UIImagePNGRepresentation(cell.cookieCostumeImage.image) forKey:@"currentSuperImage"];
            [dictionary setObject:cell.cellTheme forKey:@"imageTheme"];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:(NSMutableArray *)_cookieArray forKey:CookieCostumeArrayDefault];
            [_costumesCollectionView  reloadData];
        }
    }
}

#pragma mark - Achievements

- (void)loadAchievements
{
    [[SGGameCenterManager gcManager] loadAchievementDescriptionsWithCompletion:^(BOOL loadedSuccessfully) {
        _achievementKeys = [NSArray arrayWithArray:[[SGGameCenterManager gcManager].achievementDescriptions allKeys]];
        [_trophiesCollectionView reloadData];
    }];
}

#pragma mark - Achievements popup delegate
- (void)okButtonWasHitOnAchievementViewController:(CDAchievementDisplayPopupViewController *)achievementViewController
{
    [achievementViewController.view removeFromSuperview];
}

#pragma mark - User Interaction
- (void)enableUserInteraction
{
    _accountButtonOne.userInteractionEnabled = YES;
    _accountButtonTwo.userInteractionEnabled = YES;
    _accountButtonThree.userInteractionEnabled = YES;
    
    _coinAddButton.userInteractionEnabled = YES;
}

@end