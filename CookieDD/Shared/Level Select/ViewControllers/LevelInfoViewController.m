//
//  SelectedLevelInfoViewController.m
//  Map_Plist
//
//  Created by Josh on 10/1/13.
//  Copyright (c) 2013 Josh. All rights reserved.
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

#import "LevelInfoViewController.h"
#import "SGLevelSelectCell.h"
#import "SGFileManager.h"

@interface LevelInfoViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic) int numLevels;
@property (assign, nonatomic) BOOL willMoveToNextLevel;
@property (strong, nonatomic) NSNumber *planetID;
@property (assign, nonatomic) CGPoint mainInfoDisplayCenter;

// Dev Cheats
@property (assign, nonatomic) BOOL isProcessingNextLevel;

@end

@implementation LevelInfoViewController

#pragma mark - Init

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.frame = self.view.superview.bounds;
    self.backgroundFadeAlpha = 0.85f;
    
    _mainInfoDisplayCenter = self.mainInfoView.center;
    
    _willUpdateLevel = NO;
    //self.levelsPageControl.numberOfPages = ceil(self.numLevels / 10.0);
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(didSwipeLeft)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipeLeft.delegate = self;
    [_levelsCollectionView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(didSwipeRight)];
    swipeRight.delegate = self;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [_levelsCollectionView addGestureRecognizer:swipeRight];
    
    self.levelsPageControl.numberOfPages = 3;
    
    // Dev Cheats
    self.isProcessingNextLevel = NO;
    
#if DevModeActivated
        _unlockNextLevelButton.hidden = NO;
#else
        _unlockNextLevelButton.hidden = YES;
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSwipeLeft
{
    //DebugLog(@"LEFT");
    [self pageRight:nil];
}

- (void)didSwipeRight
{
    //DebugLog(@"RIGHT");
    [self pageLeft:nil];
}

- (void)loadPlayerInfo {
    self.levelsArray = [[NSArray alloc] init];
    NSArray *worldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
    if (worldsArray != nil && [_planetID intValue] < [worldsArray count]) {
        NSDictionary *thisWorldDict = worldsArray[[_planetID intValue]];
        _worldType = thisWorldDict[@"type"];
        NSArray *levelsArray = thisWorldDict[@"levels"];
        if (levelsArray != nil) {
            self.levelsArray = levelsArray;
        }
        else {
            DebugLog(@"Warning: Levels array for player account is nil.");
        }
        
        // Check if there needs to be a costume unlock.
        NSDictionary *accountdict = [SGAppDelegate appDelegate].accountDict;
        if (accountdict) {
            NSArray *worldsArray = accountdict[@"worlds"];
            if (worldsArray) {
                NSArray *worldsList = [[SGFileManager fileManager] loadArrayWithFileName:@"planetoids-master-list" OfType:@"plist"];
                NSString *worldName;
                for (NSDictionary *worldDict in worldsArray) {
                    int worldID = [worldDict[@"type"] intValue];
                    worldID -= 1; // Programmers count weird.
                    worldName = worldsList[worldID];
                    [self checkAndUnlockFreeCostumeForWorld:worldName];
                }
            }
        }
    }
    else {
        DebugLog(@"Warning: Worlds array for player account is nil or locked.");
    }
}

- (void)loadPlanetoid:(CDPlanetoidObject *)planetoid {
    [self.planetNameLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:self.planetNameLabel.font.pointSize]];
    [self.planetNameLabel setText:planetoid.name];
    self.planetID = planetoid.planetID;
    //self.levelsArray = planetoid.levelsArray;
    
    [self.minigameButtonLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:self.minigameButtonLabel.font.pointSize]];
    [self.minigameButtonLabel setText:[NSString stringWithFormat:@" Play %@", planetoid.minigameName]];
    [self.minigameButtonLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:2.0f];
}

- (void)scrollCollectionViewToShowLatestLevel {
    
    int targetPage = (((int)[self.levelsArray count] - 1) / 10);
    
    if (_willUpdateLevel && [self.levelsArray count] > 0) {
        _willUpdateLevel = NO;
        int levelNumber = (int) [self.levelsArray count];
        int levelIndex = [self calculateIndexFromLevelNumber:levelNumber];
        
        _willMoveToNextLevel = YES;
        NSIndexPath *path = [NSIndexPath indexPathForItem:levelIndex inSection:0];
        [self collectionView:_levelsCollectionView didSelectItemAtIndexPath:path];
    }
    
    // Scroll to the correct page.
    self.levelsPageControl.currentPage = targetPage;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.levelsPageControl.currentPage * 10 inSection:0];
    [self.levelsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


#pragma mark - Animations

// Intro animations.
- (void)animateIn {
    [self loadPlayerInfo];
    [self.levelsCollectionView reloadData];
    
    [self scrollCollectionViewToShowLatestLevel];
    
    self.view.hidden = NO;
    
    // Fade in the background shadow.
    UIColor *shadowColor = [UIColor colorWithRed:52.0f/256.0f green:81.0f/256.0f blue:107.0f/256.0f alpha:0.0f];
    self.view.backgroundColor = shadowColor;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:52.0f/256.0f green:81.0f/256.0f blue:107.0f/256.0f alpha:self.backgroundFadeAlpha];
    }];
    
    // Slide the top view in.
    self.mainInfoView.center = CGPointMake(self.mainInfoView.frame.size.width * -1, self.mainInfoView.center.y);
    //[UIView animateWithDuration:0.9f delay:0.1f usingSpringWithDamping:(0.8f) initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mainInfoView.center = _mainInfoDisplayCenter;
    } completion:^(BOOL finished) {
        //DebugLog(@"Level info done animating in.");
    }];
}

// Outro animaions + removeFromSuperview.
- (void)animateOut {
    
    // Fade out the background shadow.
    [UIView animateWithDuration:0.5f delay:0.2f options:UIViewAnimationOptionTransitionNone animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:52.0f/256.0f green:81.0f/256.0f blue:107.0f/256.0f alpha:0.0f];
    } completion:^(BOOL finished) {
        //[self.view removeFromSuperview];
        self.view.hidden = YES;
    }];
    
    // Slide the views out.
    [UIView animateWithDuration:0.9f delay:0.0f usingSpringWithDamping:(0.9f) initialSpringVelocity:-1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mainInfoView.center = CGPointMake(self.mainInfoView.frame.size.width * -1, self.mainInfoView.center.y);
        //self.controlsView.center = CGPointMake(self.controlsView.frame.size.width + self.view.frame.size.width, self.controlsView.center.y);
    } completion:^(BOOL finished) {
        self.mainInfoView.center = _mainInfoDisplayCenter;
    }];
}

#pragma mark - Controls

- (IBAction)startLevel:(id)sender {
    DebugLog(@"Start level.");
    
}

- (IBAction)cancel:(id)sender {
    [self.delegate levelInfoViewControllerDidCancel:self];
    [self animateOut];
}

- (IBAction)pageLeft:(id)sender {
    //DebugLog(@"Page Left.");
    self.levelsPageControl.currentPage -= 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.levelsPageControl.currentPage * 10 inSection:0];
    [self.levelsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (IBAction)pageRight:(id)sender {
    //DebugLog(@"Page Right.");
    self.levelsPageControl.currentPage += 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.levelsPageControl.currentPage * 10 inSection:0];
    [self.levelsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    DebugLog(@"HELLO");
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    DebugLog(@"BYE");
}


#pragma mark - Loading Info


#pragma mark - UI Collection View

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    [collectionView.collectionViewLayout invalidateLayout];
//    
//    return 1;
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SGLevelSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LevelSelectCell" forIndexPath:indexPath];
    
    // The indexPath.row of each cell does not match it's actual level number, so that
    // needs to be recalculated.

    int levelNumber = [self calculateLevelNumberForRow:(int) indexPath.row];
    cell.levelNumber = levelNumber;
    [cell setLevelNumber:levelNumber];
    
    //NSDictionary *levelDict = self.levelsArray[(int)levelNumber-1];
//    NSArray *worldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
//    NSDictionary *thisWorldDict = [NSDictionary new];
//    if ([_planetID intValue] < [worldsArray count]) {
//        thisWorldDict = worldsArray[[_planetID intValue]];
//    }
//    
//    
//    NSArray *levelsArray = thisWorldDict[@"levels"];
    if (self.levelsArray != nil && levelNumber <= [self.levelsArray count]) {
        NSDictionary *levelDict = self.levelsArray[levelNumber - 1];
        cell.isUnlocked = [levelDict[@"isUnlocked"] boolValue];
        cell.starLevel = [(NSNumber *)levelDict[@"starCount"] intValue];
    }
    else {
        cell.isUnlocked = NO;
        cell.starLevel = 0;
    }
    
    return cell;
}

- (double)calculateLevelNumberForRow:(int)row {
    // This chunk calculates what number this icon should use.
    // Note that this will not match the indexPath.row of the cell.
    
    double levelNumber = ceil(((double)row + 1.0) / 2.0);
    
    if (row % 2 == 1.0) {
        // Odd numbers are offset by five.
        levelNumber += 5;
    }
    // Every tens group needs to be offset by another factor of five.
    levelNumber += 5 * floor(row / 10);
    
    return levelNumber;
}

- (double)calculateIndexFromLevelNumber:(int)levelNumber
{
    double index = levelNumber;
    
//    if (levelNumber % 2 == 1)
//    {
//        index = levelNumber - 5;
//    }
//    index *= 2;
//    index -= 1;
//    
//    if (index < 0)
//    {
//        index *= -1;
//    }
    
    int currentPage = (int) self.levelsPageControl.currentPage;
    
    if (levelNumber <= (currentPage * 10) + 5) {
        index = ((levelNumber - 1) * 2) + (currentPage * 10);
    }
    else {
        index = levelNumber - (((currentPage + 1) * 11) - levelNumber);
    }
    
    DebugLog(@"Converted level %i to index %f.", levelNumber, index);
    
    return index;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SGLevelSelectCell *cell = (SGLevelSelectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.isUnlocked)
    {
        if ([[SGAppDelegate appDelegate].accountDict[@"lives"] intValue] > 0) {
            if ([self.delegate respondsToSelector:@selector(levelInfoViewController:DidSelectLevel:OnPlanet:)])
            {
                _willMoveToNextLevel = NO;
                
                [SGGameManager gameManager].what_level_am_I_at = [cell.levelNumberLabel.text intValue];
                
                // This got moved into CDCookieDunkDunkViewController, inside 'createLevelWithID:forPlanet:'.
                //int levelNumber = ([_planetID intValue] * 30) + [cell.levelNumberLabel.text intValue];
                //[SGGameManager gameManager].what_level_am_I_at = levelNumber;
                //NSString *levelName = [NSString stringWithFormat:@"cdd_level_%03d", levelNumber]; //@"dev_ingredient_02"];
                
                DebugLog(@"Opening Level %@", cell.levelNumberLabel.text);
                [self.delegate levelInfoViewController:self DidSelectLevel:[NSNumber numberWithInt:[cell.levelNumberLabel.text intValue]] OnPlanet:self.worldType];
                
                [self animateOut];
            }
        }
        else {
            DebugLog(@"Sorry, you're out of lives.");
        }
    }
    else {
        DebugLog(@"Sorry, that level is locked.");
    }
}

// Temporary!
- (IBAction)playMinigame:(id)sender {
    DebugLog(@"Play Minigame.");
    if ([self.delegate respondsToSelector:@selector(levelInfoViewController:DidSelectMinigameForPlanetWithID:)]) {
        [self.delegate levelInfoViewController:self DidSelectMinigameForPlanetWithID:self.planetID];
    }
    DebugLog(@"test");
}

#pragma mark - Orientation

- (void)orientationChanged:(NSNotification *)notification
{
    self.view.frame = self.view.superview.bounds;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return 0;
}


#pragma mark - Dev Cheats

- (IBAction)unlockNextLevel:(id)sender {
    if (!_isProcessingNextLevel) {
        DebugLog(@"Unlock!");
        self.isProcessingNextLevel = YES;
        
        NSString *email = [[SGAppDelegate appDelegate] fetchPlayerEmail];
        NSString *deviceID = [[SGAppDelegate appDelegate] fetchPlayerDeviceID];
        
        NSNumber *nextLevelType;
        NSNumber *nextworldType;
        if ([_levelsArray count] < numLevelsPerPlanet) {
            // Unlock the next level of the current world.
            nextLevelType = [NSNumber numberWithInt:[[_levelsArray lastObject][@"type"] intValue] + 1];
            nextworldType = _worldType;
            
            NSString *worldName = [[SGFileManager fileManager] stringFromIndex:([nextworldType intValue] - 1) inFile:@"planetoids-master-list"];
            
            [[WebserviceManager sharedManager] updateLevelParametersWithEmail:email
                                                                     deviceId:deviceID
                                                                    worldType:nextworldType
                                                                    worldName:worldName
                                                                    levelType:nextLevelType
                                                                    starCount:[NSNumber numberWithInt:0]
                                                                    highScore:[NSNumber numberWithInt:0]
                                                            completionHandler:^(NSError *error, NSDictionary *levelInfo) {
                                                                DebugLog(@"Unlocked level %@ - %@", nextworldType, nextLevelType);
                                                                
                                                                [self loadPlayerInfo];
                                                                
                                                                // Force this on the main thread for visual updating.
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [self.levelsCollectionView.collectionViewLayout invalidateLayout];
                                                                    [self.levelsCollectionView reloadData];
                                                                    [self scrollCollectionViewToShowLatestLevel];
                                                                    self.isProcessingNextLevel = NO;
                                                                });
                                                                
            }];
        }
        else if ([_worldType intValue] < numUnlockablePlanets) {
            // If the next world is already unlocked, stop right here.
            for (NSDictionary *worldDict in [SGAppDelegate appDelegate].accountDict[@"worlds"]) {
                DebugLog(@"Checking world %@", worldDict[@"type"]);
                if ([worldDict[@"type"] isEqualToNumber:[NSNumber numberWithInt:[_worldType intValue] + 1]]) {
                    DebugLog(@"Warning: That world is already unlocked.");
                    self.isProcessingNextLevel = NO;
                    return;
                }
            }
            
            nextworldType = [NSNumber numberWithInt:[_worldType intValue] + 1];
            
            NSString *worldName = [[SGFileManager fileManager] stringFromIndex:([nextworldType intValue] - 1) inFile:@"planetoids-master-list"];
            
            [[WebserviceManager sharedManager] updateWorldParametersWithEmail:email
                                                                     deviceId:deviceID
                                                                    worldType:nextworldType
                                                                    worldName:worldName
                                                            completionHandler:^(NSError *error, NSDictionary *worldInfo) {
                                                                
                self.isProcessingNextLevel = NO;
            }];
            
            
            // Unlock the free costume.
            [self checkAndUnlockFreeCostumeForWorld:worldName];
            // End unlock.
        }
    }
    else {
        DebugLog(@"Hold On: The next level is still processing.");
    }
}


- (void)checkAndUnlockFreeCostumeForWorld:(NSString *)worldName {
    NSString *email = [[SGAppDelegate appDelegate] fetchPlayerEmail];
    NSString *deviceID = [[SGAppDelegate appDelegate] fetchPlayerDeviceID];
    
    NSDictionary *worldDict = [[SGFileManager fileManager] loadDictionaryWithFileName:worldName OfType:@"plist"];
    if (worldDict[@"freeCostume"]) {
        NSDictionary *freeCostumeDict = worldDict[@"freeCostume"];
        //BOOL shouldBother = YES;
        
        
        NSDictionary *accountDict = [SGAppDelegate appDelegate].accountDict;
        NSArray *cookieCostumesArray = [accountDict objectForKey:@"cookieCostumes"];
        for (NSDictionary *dict in cookieCostumesArray) {
            // Check name and theme.
            if ([dict[@"name"] isEqualToString:freeCostumeDict[@"keyName"]] &&
                [dict[@"theme"] isEqualToString:freeCostumeDict[@"keyTheme"]]) {
                //DebugLog(@"Found %@ costume for %@", freeCostumeDict[@"keyTheme"], freeCostumeDict[@"keyName"]);
                if (![dict[@"isUnlocked"] boolValue]) {
                    DebugLog(@"Now unlocking the %@ costume for %@.", dict[@"theme"], dict[@"name"]);
                    NSMutableDictionary *tempDict = [dict mutableCopy];
                    [tempDict setValue:[NSNumber numberWithBool:YES] forKey:@"isUnlocked"];
                    //[tempCookieCostumesArray addObject:tempDict];
                    NSMutableArray *freeCostumeArray = [NSMutableArray arrayWithArray:@[tempDict]];
                    [[WebserviceManager sharedManager] requestToUpdateCookieCostumesWithEmail:email
                                                                                     deviceId:deviceID
                                                                               cookieCostumes:freeCostumeArray
                                                                            completionHandler:^(NSError *error, NSDictionary *returnDict) {
                        if (error) {
                            DebugLog(@"Error updating cookie costumes: %@", error.localizedDescription);
                            return;
                        }
                        if (returnDict) {
                            if (returnDict[@"account"]) {
                                if (returnDict[@"account"][@"cookieCostumes"]) {
                                    [[SGAppDelegate appDelegate].accountDict setObject:returnDict[@"account"][@"cookieCostumes"] forKey:@"cookieCostumes"];
                                    NSString *identifierName = [NSString stringWithFormat:@"IAPIdentifiers_%@%@",
                                                                freeCostumeDict[@"keyTheme"],
                                                                freeCostumeDict[@"keyName"]];
                                    //NSString *iapIdentifier = [[CDIAPManager iapMananger] valueForKey:identifierName]; // <<< Use this in the 'forKey' value below.
                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:identifierName];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                                else {
                                    DebugLog(@"Error: No cookie costumes found in returned account when updating cookie costumes.");
                                }
                            }
                            else {
                                DebugLog(@"Error: No account returned when updating cookie costumes.");
                            }
                        }
                        else {
                            DebugLog(@"Error: No return dict when updating cookie costumes.");
                        }
                    }];
                    break;
                }
                else {
                    DebugLog(@"The %@ costume for %@ has already been unlocked.", dict[@"theme"], dict[@"name"]);
                    break;
                }
            }
        }
    }
}


@end
