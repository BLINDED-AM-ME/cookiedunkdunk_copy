//
//  CDPickedLeveView.m
//  CookieDD
//
//  Created by Gary Johnston on 7/11/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDPickedLeveView.h"

@interface CDPickedLeveView()

@property (strong, nonatomic) UIViewController *parentalViewController;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSDate *birthDate;
@property (strong, nonatomic) NSURL *imageUrl;

@property (assign, nonatomic) CGFloat leaderboardCellWidth;
@property (assign, nonatomic) CGFloat leaderboardCellHeight;

@end

@implementation CDPickedLeveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)setupWithParentalViewController:(UIViewController *)parentalViewController WithMapBubble:(CDMapBubble *)mapBubble WithPlanetID:(NSNumber *)planetType
{
    _mapBubble = mapBubble;
    _planetNumber = planetType;
    _parentalViewController = parentalViewController;
    
    _levelNameLabel.text = [NSString stringWithFormat:@"Level: %i", mapBubble.levelNumber];
    [_levelNameLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    [_levelNameLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_backButtonLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_backButtonLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_playButtonLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_playButtonLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
//    [_secondGoalLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
//    [_secondGoalLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_highScoreLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    [_highScoreLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];

    if (IS_IPHONE_5)
    {
        CGRect newFrame = self.descriptionScreenView.frame;
        newFrame.origin = CGPointMake(newFrame.origin.x, (self.leaderboardView.frame.origin.y - newFrame.size.height));
        self.descriptionScreenView.frame = newFrame;
    }
    
    _activityIndicator.hidesWhenStopped = YES;
    
    [self handleStars];
    [self handleGoals];
    [self loadLeaderboard];
}

- (void)handleStars
{
    int starCount = 0;
    NSDictionary *planetLevelDictionary = [NSDictionary new];
    
    for (NSDictionary *dictionary in [[SGAppDelegate appDelegate].accountDict objectForKey:@"worlds"])
    {
        if ([[dictionary objectForKey:@"type"] intValue] == [_planetNumber intValue] + 1)
        {
            planetLevelDictionary = [dictionary objectForKey:@"levels"];
            break;
        }
    }
    
    for (NSDictionary *subDictionary in planetLevelDictionary)
    {
        if ([[subDictionary objectForKey:@"type"] intValue] == _mapBubble.levelNumber)
        {
            DebugLog(@"Found it!!!!");
            starCount = [[subDictionary objectForKey:@"starCount"] intValue];
            break;
        }
    }
    
    if (starCount == 1)
    {
        [_bronzeStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starbronze"]];
        [_silverStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starsilverempty"]];
        [_goldStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-stargoldempty"]];
    }
    else if (starCount == 2)
    {
        [_bronzeStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starbronze"]];
        [_silverStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starsilver"]];
        [_goldStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-stargoldempty"]];
    }
    else if (starCount == 3)
    {
        [_bronzeStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starbronze"]];
        [_silverStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starsilver"]];
        [_goldStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-stargold"]];
    }
    else
    {
        [_bronzeStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starbronzeempty"]];
        [_silverStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starsilverempty"]];
        [_goldStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-stargoldempty"]];
    }
}

- (void)handleGoals
{
    _itemTexturesArray = [NSArray new];
    float height = 20.0f;
    NSArray* previous_goals = [NSArray arrayWithArray:_goalAreaScrollView.subviews];
    
    NSString *planetName = [[SGFileManager fileManager] stringFromIndex:[_planetNumber intValue] inFile:@"planetoids-master-list"];
//    NSDictionary *planetDict = [[SGFileManager fileManager] loadDictionaryWithFileName:planetName OfType:@"plist"];

    //    int levelNumber = ([planetType intValue] * 30) + mapBubble.tag;
    
    NSString *levelName = [NSString stringWithFormat:@"cdd_level_%03d", ([_planetNumber intValue] * 30) + (int)_mapBubble.levelNumber];
    DebugLog(@"Create level %i for planet %@.", (int)_mapBubble.levelNumber, planetName);

    
    NSDictionary *levelDict = [[SGFileManager fileManager] loadDictionaryWithFileName:levelName OfType:@"plist"];
    
//    _goalLabel.text = [NSString stringWithFormat:@"SCORE: %i", [[levelDict objectForKey:@"goalValue"] intValue]];
//    [_goalLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
//    [_goalLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
//    
//    if ([levelDict objectForKey:@"goalType"] != [levelDict objectForKey:@"secondarygoalType"])
//    {
//        if ([[levelDict objectForKey:@"secondarygoalType"] isEqualToString:@"TOTAL_SCORE"])
//        {
//            _secondGoalLabel.text = [NSString stringWithFormat:@"SECONDARY GOAL: %i", [[levelDict objectForKey:@"secondarygoalValue"] intValue]];
//        }
//        if ([[levelDict objectForKey:@"secondarygoalType"] isEqualToString:@"CLEAR_TYPE"])
//        {
//            //            if
//            //            _secondGoalLabel.text = [NSString stringWithFormat:@"REMOVE: %i X", _];
//        }
//    }
//    else
//    {
//        [_secondGoalLabel removeFromSuperview];
//    }
    
    NSString *deviceModel = @"@2x";
    
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        deviceModel = @"@2x";
    }
    else if (IS_IPAD)
    {
        deviceModel = @"@2x~ipad";
    }
    
    _itemTexturesArray = @[
                           
                           [UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj1%@",deviceModel]],//0
                           [UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald1%@",deviceModel]],//1
                           [UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke1%@",deviceModel]],//2
                           [UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin1%@",deviceModel]],//3
                           [UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey1%@",deviceModel]],//4
                           [UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry1%@",deviceModel]],//5
                           [UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip1%@",deviceModel]],//6
                           
                           [UIImage imageNamed:[NSString stringWithFormat:@"cdd-main-board-item-egg%@",deviceModel]],//7
                           [UIImage imageNamed:[NSString stringWithFormat:@"cdd-main-board-item-chocchip%@",deviceModel]],//8
                           
                           [UIImage imageNamed:[NSString stringWithFormat:@"cdd-boardpiece-glasscase%@",deviceModel]]//9
                           
                           ];
    
    
    for (SGStrokeLabel *child in previous_goals)
    {
        [child removeFromSuperview];
    }
    
    float additiveY = 0;
    
    if ([[levelDict objectForKey:@"goalType"] isEqualToString:@"TOTAL_SCORE"])
    {
        
        SGStrokeLabel* goal = [SGStrokeLabel new];
        
        goal.text = [NSString stringWithFormat:@" SCORE: %i ", [[levelDict objectForKey:@"goalValue"] intValue]];
        
        goal.textColor = [UIColor whiteColor];
        goal.frame = CGRectMake(0, additiveY, _goalAreaScrollView.frame.size.width, height);
        [goal setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
        [goal setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_goalAreaScrollView addSubview:goal];
        
        additiveY += height;
    }
    else if ([[levelDict objectForKey:@"goalType"] isEqualToString:@"CLEAR_TYPE"]){
        
        NSArray *goals = [NSArray arrayWithArray:[levelDict objectForKey:@"goalItems"]];
        
        for(int count = 0; count < goals.count; count += 2){
            
            SGStrokeLabel* goal = [SGStrokeLabel new];
            
            additiveY += (height*0.25) ;
            
            goal.text = [NSString stringWithFormat:@" Remove:  %i X ", [goals[count+1] intValue]];
            
            goal.textColor = [UIColor whiteColor];
            goal.frame = CGRectMake(0, additiveY, _goalAreaScrollView.frame.size.width, height);
            [goal setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
            [goal setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
            
            [_goalAreaScrollView addSubview:goal];
            
            // image
            
            
            UIImage *iconImage = _itemTexturesArray[0];
            
            if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_RED"])
            {
                iconImage = _itemTexturesArray[0];
            }
            else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_ORANGE"])
            {
                iconImage = _itemTexturesArray[1];
            }
            else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_YELLOW"])
            {
                iconImage = _itemTexturesArray[2];
            }
            else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_GREEN"])
            {
                iconImage = _itemTexturesArray[3];
            }
            else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_BLUE"])
            {
                iconImage = _itemTexturesArray[4];
            }
            else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_PURPLE"])
            {
                iconImage = _itemTexturesArray[5];
            }
            else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_CHIP"])
            {
                iconImage = _itemTexturesArray[6];
            }
            else if ([[goals objectAtIndex:count] isEqualToString:@"INGREDIENT_EGG"])
            {
                iconImage = _itemTexturesArray[7];
            }
            else if ([[goals objectAtIndex:count] isEqualToString:@"INGREDIENT_CHIPS"])
            {
                iconImage = _itemTexturesArray[8];
            }
            else if ([[goals objectAtIndex:count] isEqualToString:@"PLATES"])
            {
                iconImage = _itemTexturesArray[9];
            }
            
            UIImageView *icon = [UIImageView new];
            
            float imageSize = height * 1.5;
            float digit = 1;
            
            if([goals[count+1] intValue] >= 10)
            {
                digit = 2;
            }
            
            if([goals[count+1] intValue] >= 100)
            {
                digit = 3;
            }
            
            icon.frame = CGRectMake(_goalAreaScrollView.frame.size.width * 0.5 + (digit * imageSize),
                                    additiveY+ (imageSize * 0.5) - height,
                                    imageSize,
                                    imageSize);
            
            icon.image = iconImage;
            
            [_goalAreaScrollView addSubview:icon];
            additiveY += height;
            
        }
    }
    
    if ([levelDict objectForKey:@"goalType"] != [levelDict objectForKey:@"secondarygoalType"])
    {
        if ([[levelDict objectForKey:@"secondarygoalType"] isEqualToString:@"TOTAL_SCORE"])
        {
            
            SGStrokeLabel* goal = [SGStrokeLabel new];
            
            goal.text = [NSString stringWithFormat:@" SCORE: %i ", [[levelDict objectForKey:@"secondarygoalValue"] intValue]];
            
            goal.textColor = [UIColor whiteColor];
            goal.frame = CGRectMake(0, additiveY, _goalAreaScrollView.frame.size.width, height);
            [goal setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
            [goal setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
            
            [_goalAreaScrollView addSubview:goal];
            
            additiveY += height;
            
        }
        else if ([[levelDict objectForKey:@"secondarygoalType"] isEqualToString:@"CLEAR_TYPE"])
        {
            
            NSArray *goals = [NSArray arrayWithArray:[levelDict objectForKey:@"secondarygoalItems"]];
            
            for (int count = 0; count < goals.count; count += 2)
            {
                SGStrokeLabel *goal = [SGStrokeLabel new];
                
                additiveY += (height*0.25) ;
                
                goal.text = [NSString stringWithFormat:@" Remove:  %i X ", [goals[count+1] intValue]];
                
                goal.textColor = [UIColor whiteColor];
                goal.frame = CGRectMake(0, additiveY, _goalAreaScrollView.frame.size.width, height);
                [goal setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
                [goal setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
                
                [_goalAreaScrollView addSubview:goal];
                
                // image
                
                UIImage *iconImage = _itemTexturesArray[0];
                
                if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_RED"])
                {
                    iconImage = _itemTexturesArray[0];
                }
                else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_ORANGE"])
                {
                    iconImage = _itemTexturesArray[1];
                }
                else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_YELLOW"])
                {
                    iconImage = _itemTexturesArray[2];
                }
                else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_GREEN"])
                {
                    iconImage = _itemTexturesArray[3];
                }
                else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_BLUE"])
                {
                    iconImage = _itemTexturesArray[4];
                }
                else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_PURPLE"])
                {
                    iconImage = _itemTexturesArray[5];
                }
                else if ([[goals objectAtIndex:count] isEqualToString:@"COOKIE_CHIP"])
                {
                    iconImage = _itemTexturesArray[6];
                }
                else if ([[goals objectAtIndex:count] isEqualToString:@"INGREDIENT_EGG"])
                {
                    iconImage = _itemTexturesArray[7];
                }
                else if ([[goals objectAtIndex:count] isEqualToString:@"INGREDIENT_CHIPS"])
                {
                    iconImage = _itemTexturesArray[8];
                }
                else if ([[goals objectAtIndex:count] isEqualToString:@"PLATES"])
                {
                    iconImage = _itemTexturesArray[9];
                }
                
                
                UIImageView *icon = [UIImageView new];
                
                float imageSize = height * 1.5;
                float digit = 1;
                
                if ([goals[count+1] intValue] >= 10)
                {
                    digit = 2;
                }
                
                if ([goals[count+1] intValue] >= 100)
                {
                    digit = 3;
                }
                
                icon.frame = CGRectMake(_goalAreaScrollView.frame.size.width * 0.5 + (digit * imageSize),
                                        additiveY+ (imageSize * 0.5) - height,
                                        imageSize,
                                        imageSize);
                
                icon.image = iconImage;
                
                [_goalAreaScrollView addSubview:icon];
                additiveY += height;
                
            }
            
        }
    }
    
    _goalAreaScrollView.contentSize = CGSizeMake(_goalAreaScrollView.frame.size.width, additiveY);
}

#pragma mark - Leaderboard

- (void)loadLeaderboard
{
    DebugLog(@"FriendIdArray: %@", self.friendIdArray);
    
    NSString *userFacebookId = [[SGAppDelegate appDelegate] fetchPlayerFacebookID];
    NSNumber *currentWorld = [NSNumber numberWithInt:[self.planetNumber intValue] + 1];
    NSNumber *currentLevel = [NSNumber numberWithInt:self.mapBubble.levelNumber];
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    //-----------------
    // Scroll view setup
    //-----------------
    self.leaderboardCellWidth = self.leaderboardScrollView.frame.size.width / 4;
    self.leaderboardCellHeight = self.leaderboardScrollView.frame.size.height;
    self.leaderboardScrollView.delegate = self;
    
    self.leaderboardPageControl.transform = CGAffineTransformScale(CGAffineTransformIdentity, .75, .75);
    
    // Retrieve leaderboard for current level
    [[WebserviceManager sharedManager] requestLevelLeaderboardWithFacebookId:userFacebookId friendsIdArray:self.friendIdArray world:currentWorld level:currentLevel completionHandler:^(NSError *error, NSDictionary *dictionary) {
        DebugLog(@"Leaderboard completion: %@", dictionary);
        
        if (!error && dictionary)
        {
            if (dictionary[@"error"])
            {
                DebugLog(@"Error retrieving leaderboard: '%@'", dictionary[@"error"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.activityIndicator stopAnimating];
                    
                    [self.facebookButton setHidden:NO];
                    [self.facebookButtonLabel setHidden:NO];
                    self.facebookButtonLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:10.0f];
                });
            }
            else if (![SGAppDelegate appDelegate].loggedInThroughFacebook)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.activityIndicator stopAnimating];
                    
                    [self.facebookButton setHidden:NO];
                    [self.facebookButtonLabel setHidden:NO];
                    self.facebookButtonLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:10.0f];
                    
                    self.facebookButton.frame = CGRectMake(self.facebookButton.frame.origin.x + ((self.leaderboardScrollView.frame.size.width - self.leaderboardCellWidth) - self.facebookButton.frame.size.width) / 2, self.facebookButton.frame.origin.y, self.facebookButton.frame.size.width, self.facebookButton.frame.size.height);
                    
                    self.facebookButtonLabel.frame = CGRectMake(self.facebookButton.frame.origin.x + self.facebookButton.frame.size.width - self.facebookButtonLabel.frame.size.width, self.facebookButtonLabel.frame.origin.y, self.facebookButtonLabel.frame.size.width, self.facebookButtonLabel.frame.size.height);
                });
            }
            
            int numberOfFriends = 0;
            
            for (NSDictionary *leaderInfoDict in [dictionary objectForKey:@"leaderboard"])
            {
                //if(numberOfFriends < 3)
                //{
                // Create view to hold leader stats to add to scroll view
                UIView *leaderboardView = [[UIView alloc] init];
                CGRect frame = leaderboardView.frame;
                frame.size = CGSizeMake(self.leaderboardCellWidth, self.leaderboardCellHeight);
                frame.origin = CGPointMake(frame.size.width * numberOfFriends, frame.origin.y);
                leaderboardView.frame = frame;
                //[leaderboardView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                //[leaderboardView.layer setBorderWidth:1.0f];
                
                numberOfFriends++;
                
                if ([leaderInfoDict isKindOfClass:[NSDictionary class]])
                {
                    if (leaderInfoDict[@"profileAvatar"])
                    {
                        // Choose what size picture we want to request
                        NSString *stringURL = leaderInfoDict[@"profileAvatar"];
                        NSRange range = [stringURL rangeOfString:@"?" options:NSBackwardsSearch];
                        NSString *modifiedStringURL = [stringURL substringToIndex:range.location];
                        NSString *pictureSize = [NSString stringWithFormat:@"?width=120&height=120"];
                        modifiedStringURL = [modifiedStringURL stringByAppendingString:pictureSize];
                        
                        NSURL *url = [NSURL URLWithString:modifiedStringURL];
                        
                        [[WebserviceManager sharedManager] requestImageAtURL:url completionHandler:^
                         (NSError *error, NSIndexPath *indexPath, UIImage *image)
                         {
                             if (!error && image)
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     // Load background underlay for current users ranking
                                     if ([leaderInfoDict[@"facebookID"] isEqualToString:userFacebookId])
                                     {
                                         UIImage *backgroundImage = [UIImage imageNamed:@"cdd-hud-panel-leader-vunderlay"];
                                         UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
                                         
                                         [leaderboardView addSubview:backgroundImageView];
                                         
                                         CGRect newFrame = backgroundImageView.frame;
                                         newFrame.size = CGSizeMake(leaderboardView.frame.size.width, leaderboardView.frame.size.height);
                                         backgroundImageView.frame = newFrame;
                                     }
                                     
                                     // Player avatar image
                                     UIImageView *friendImageView = [[UIImageView alloc] initWithImage:image];
                                     UIImage *croppedImage = [[WebserviceManager sharedManager] cropPhoto:friendImageView withMaskedImage:[UIImage imageNamed:@"Profile-88x88"]];
                                     friendImageView.image = croppedImage;
                                     [friendImageView setContentMode:UIViewContentModeScaleAspectFit];
                                     //[friendImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                                     //[friendImageView.layer setBorderWidth:1.0f];
                                     
                                     // Cookie border image
                                     UIImage *borderImage = [UIImage imageNamed:@"cdd-hud-ico-playerphoto"];
                                     UIImageView *borderImageView = [[UIImageView alloc] initWithImage:borderImage];
                                     
                                     [leaderboardView addSubview:friendImageView];
                                     [leaderboardView addSubview:borderImageView];
                                     
                                     // Position friend image
                                     CGFloat imageSize = 35;
                                     CGRect frame = friendImageView.frame;
                                     frame.size = CGSizeMake(imageSize, imageSize);
                                     frame.origin = CGPointMake(frame.origin.x + ((leaderboardView.frame.size.width - frame.size.width) / 2), 15);
                                     friendImageView.frame = frame;
                                     
                                     // Position cookie hud image over friend image
                                     CGFloat ratio = imageSize / 120;
                                     CGFloat borderSize =  166 * ratio; //54.0f;
                                     CGFloat offSet = borderSize * 0.1385;
                                     frame.size = CGSizeMake(borderSize, borderSize);
                                     frame.origin.x = frame.origin.x - offSet; //(frame.size.width * 0.13f);
                                     frame.origin.y = frame.origin.y - offSet; //(frame.size.height * 0.13f);
                                     borderImageView.frame = frame;
                                     
                                     // Ranking in leaderboard
                                     if (leaderInfoDict[@"rank"])
                                     {
                                         NSString *rank = leaderInfoDict[@"rank"];
                                         
                                         SGStrokeLabel *rankingLabel = [[SGStrokeLabel alloc] init];
                                         rankingLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
                                         rankingLabel.text = [NSString stringWithFormat:@"%@", rank];
                                         rankingLabel.textColor = [UIColor whiteColor];
                                         [rankingLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
                                         [rankingLabel sizeToFit];
                                         
                                         CGRect newFrame = rankingLabel.frame;
                                         newFrame.origin = CGPointMake(newFrame.origin.x + 5, newFrame.origin.y + 5);
                                         rankingLabel.frame = newFrame;
                                         
                                         [leaderboardView addSubview:rankingLabel];
                                     }
                                     
                                     // High score
                                     if (leaderInfoDict[@"highScore"])
                                     {
                                         NSString *highScore = leaderInfoDict[@"highScore"];
                                         
                                         UILabel *highScoreLabel = [[UILabel alloc] init];
                                         highScoreLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
                                         highScoreLabel.text = [NSString stringWithFormat:@"%@", highScore];
                                         highScoreLabel.textColor = [UIColor whiteColor];
                                         [highScoreLabel sizeToFit];
                                         
                                         [leaderboardView addSubview:highScoreLabel];
                                         
                                         CGRect newFrame = highScoreLabel.frame;
                                         newFrame.origin = CGPointMake(newFrame.origin.x + 10, newFrame.origin.y + (leaderboardView.frame.size.height / 2) - 5);
                                         highScoreLabel.frame = newFrame;
                                     }
                                     
                                     // Friend name
                                     if (leaderInfoDict[@"firstName"])
                                     {
                                         NSString *firstName = leaderInfoDict[@"firstName"];
                                         
                                         UILabel *nameLabel = [[UILabel alloc] init];
                                         nameLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
                                         nameLabel.text = [NSString stringWithFormat:@"%@", firstName];
                                         nameLabel.textColor = [UIColor blackColor];
                                         nameLabel.textAlignment = NSTextAlignmentCenter;
                                         [nameLabel sizeToFit];
                                         
                                         [leaderboardView addSubview:nameLabel];
                                         
                                         CGRect newFrame = nameLabel.frame;
                                         newFrame.origin = CGPointMake(friendImageView.frame.origin.x - ((newFrame.size.width - friendImageView.frame.size.width) / 2),
                                                                       leaderboardView.frame.origin.y + (leaderboardView.frame.size.height / 2) + 8);
                                         nameLabel.frame = newFrame;
                                     }
                                     
                                     // Do not display the gift button if the current leader is the player
                                     if (![[SGAppDelegate appDelegate].accountDict[@"facebookID"] isEqualToString:leaderInfoDict[@"facebookID"]])
                                     {
                                         // Gift image button
                                         UIImage *giftBtnDefault = [UIImage imageNamed:@"store-giftbtn-default"];
                                         UIImage *giftBtnActive = [UIImage imageNamed:@"store-giftbtn-active"];
                                         CGRect giftFrame = CGRectMake(0, 0, giftBtnDefault.size.width, giftBtnDefault.size.height);
                                         giftFrame.origin = CGPointMake(giftFrame.origin.x + ((leaderboardView.frame.size.width - giftFrame.size.width) / 2),
                                                                        leaderboardView.frame.size.height - (giftFrame.size.height + 5));
                                         
                                         UIButton *giftButton = [[UIButton alloc] initWithFrame:giftFrame];
                                         [giftButton setBackgroundImage:giftBtnDefault forState:UIControlStateNormal];
                                         [giftButton setBackgroundImage:giftBtnActive forState:UIControlStateHighlighted];
                                         
                                         [leaderboardView addSubview:giftButton];
                                     }
                                     
                                     // Add leaderboard ranking to scrollView
                                     [self.leaderboardScrollView addSubview:leaderboardView];
                                     
                                     // Add seperator after top 3
                                     //if (numberOfFriends > 1)
                                     if (numberOfFriends == 4)
                                     {
                                         UIImageView *seperatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cdd-hud-panel-leader-vunderlay"]];
                                         
                                         [leaderboardView addSubview:seperatorImageView];
                                         
                                         seperatorImageView.frame = CGRectMake(0, 0, 2, leaderboardView.frame.size.height);
                                     }
                                     
                                     [self.activityIndicator stopAnimating];
                                 }); // dispatch_async
                             }
                         }]; // requestImageAtURL
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (numberOfFriends > 3)
                    {
                        self.leaderboardPageControl.numberOfPages = numberOfFriends;
                    }
                });
            //} // Limit number of views displayed
            } // for in leaderInfoDict
            
            self.leaderboardScrollView.contentSize = CGSizeMake(self.leaderboardCellWidth * numberOfFriends, self.leaderboardScrollView.frame.size.height);
        }
        else if (error)
        {
            // No internet connection
            DebugLog(@"%@", error.description);
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                NSString *errorMsg = @"Unable to connect";
                
                SGStrokeLabel *errorMsgLabel = [[SGStrokeLabel alloc] init];
                errorMsgLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:10.0f];
                errorMsgLabel.text = [NSString stringWithFormat:@"%@", errorMsg];
                errorMsgLabel.textColor = [UIColor whiteColor];
                [errorMsgLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 3 : 1];
                [errorMsgLabel sizeToFit];
                
                CGRect newFrame = errorMsgLabel.frame;
                newFrame.origin = CGPointMake((self.leaderboardBackgroundView.frame.size.width - newFrame.size.width) / 2, (self.leaderboardBackgroundView.frame.size.height - newFrame.size.height) / 2);
                errorMsgLabel.frame = newFrame;
                
                [self.activityIndicator stopAnimating];
                [self.leaderboardBackgroundView addSubview:errorMsgLabel];
                
            });
        }
        else
        {
            DebugLog(@"Error retrieving leaderboard");
        }
        
    }]; // requestLevelLeaderboardWithFacebookId

}

- (IBAction)facebookButtonHit:(id)sender
{
    DebugLog(@"Leaderboard Facebook button hit");
    
    // Clear scroll view of content before updating leaderboard
    for (UIView *subView in [self.leaderboardScrollView subviews])
    {
        [subView removeFromSuperview];
    }
    
    [self.facebookButton setHidden:YES];
    [self.facebookButtonLabel setHidden:YES];
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    __weak typeof(self) weakSelf = self;
    
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
                                  
//                                  [[WebserviceManager sharedManager] requestToCreateAccountWithEmail:weakSelf.emailAddress
//                                                                                            deviceId:[SGAppDelegate appDelegate].currentDeviceID
//                                                                                           firstName:weakSelf.firstName
//                                                                                            lastName:weakSelf.lastName
//                                                                                              gender:weakSelf.gender
//                                                                                           birthdate:weakSelf.birthDate
//                                                                                          facebookID:facebookId
//                                                                                         deviceToken:[SGAppDelegate appDelegate].currentDeviceTokenId
//                                                                               profileImageStringURL:stringURL
//                                                                                   completionHandler:^
//                                   (NSDictionary *playerDict, NSError *error)
//                                   {
                                  [[WebserviceManager sharedManager] requestToUpdateAccountWithEmail:weakSelf.emailAddress
                                                                                            deviceId:[SGAppDelegate appDelegate].currentDeviceID
                                                                                           firstName:weakSelf.firstName
                                                                                            lastName:weakSelf.lastName
                                                                                              gender:weakSelf.gender
                                                                                           birthdate:weakSelf.birthDate
                                                                                          facebookID:facebookId
                                                                                      didRecieveGift:nil
                                                                                   completionHandler:^
                                   (NSDictionary *playerDict, NSError *error)
                                   {
                                       if (playerDict)
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               if (playerDict[@"account"] && [playerDict[@"account"] isKindOfClass:[NSDictionary class]])
                                               {
                                                   [SGAppDelegate appDelegate].accountDict = [playerDict[@"account"] mutableCopy];
                                                   
                                                   // Set friendsIdArray before displaying leaderboard
                                                   [[SGSocialManager socialManager] requestFacebookFriendsWithQueryType:FacebookTypeQueryFriendsHaveApp
                                                                                                      CompletionHandler:^
                                                    (FBRequestConnection *connection, NSArray *friendArray, NSError *error)
                                                    {
                                                        if (!error && friendArray)
                                                        {
                                                            for (NSDictionary *friendDict in friendArray)
                                                            {
                                                                if (friendDict[@"uid"])
                                                                {
                                                                    NSString *facebookUID = [friendDict[@"uid"] stringValue];
                                                                    [weakSelf.friendIdArray addObject:facebookUID];
                                                                }
                                                            }
                                                            [weakSelf.activityIndicator setHidden:YES];
                                                            [weakSelf loadLeaderboard];

                                                            // Update the isometricMap after logging into Facebook
                                                            CDIsometricMapViewController *isometricMapViewController = (CDIsometricMapViewController *)weakSelf.parentalViewController;
                                                            [isometricMapViewController loadPlayerInfo];
                                                            [isometricMapViewController updateLevelBubbles];
                                                            [isometricMapViewController updateMinigameBubble];
                                                            [isometricMapViewController fetchFriends];
                                                            //[isometricMapViewController updateFriends];
                                                            [isometricMapViewController.view setNeedsDisplay];
                                                            isometricMapViewController = nil;
                                                        }
                                                    }];
                                               }
                                               else
                                               {
                                                   [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf.parentalViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:weakSelf.frame errorDescription:@"An error has occurred" loadingText:nil];
                                               }
                                           });
                                       }
                                       else if (error)
                                       {
                                           DebugLog(@"");
                                           [[SGAppDelegate appDelegate] dismissConditionalView];
                                           [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf.parentalViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:weakSelf.parentalViewController.view.frame errorDescription: [NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
                                       }
                                       else
                                       {

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
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[SGAppDelegate appDelegate] dismissConditionalView];
                 [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf.parentalViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:weakSelf.parentalViewController.view.frame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
             });
             
             return;
         }
    }];

}

- (IBAction)closeLeaderboardButtonHit:(id)sender
{
    self.leaderboardView.hidden = YES;
    //[self.parentalViewController.view bringSubviewToFront:self.mainButtonVC.view];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //DebugLog(@"scrollViewDidScroll");
    //DebugLog(@"Dragging: %hhd", self.leaderboardScrollView.dragging);
    //DebugLog(@"ContentOffset: %f", self.leaderboardScrollView.contentOffset.x);

    CGFloat pageWidth = self.leaderboardCellWidth;
    int page = self.leaderboardScrollView.contentOffset.x / pageWidth;
    
    if (self.leaderboardScrollView.contentSize.width  < self.leaderboardScrollView.frame.size.width)
    {
        self.leaderboardPageControl.currentPage = page;
    }
    else
    {
        self.leaderboardPageControl.currentPage = page + 2;
    }
}

#pragma mark - Actions

- (IBAction)exitButtonHit:(id)sender
{
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if ([self.delegate respondsToSelector:@selector(exitButtonWasHitOnPickedLevelView:)])
    {
        [self.delegate exitButtonWasHitOnPickedLevelView:self];
    }
}

- (IBAction)playButtonHit:(id)sender
{
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click 2" FileType:@"caf"]; //@"m4a"];
    
    if ([self.delegate respondsToSelector:@selector(playButtonWasHitOnPickedLevelView:withMapBubble:WithPlanetID:)])
    {
        [self.delegate playButtonWasHitOnPickedLevelView:self withMapBubble:_mapBubble WithPlanetID:_planetNumber];
    }
}

- (IBAction)backButtonHit:(id)sender
{
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if ([self.delegate respondsToSelector:@selector(exitButtonWasHitOnPickedLevelView:)])
    {
        [self.delegate exitButtonWasHitOnPickedLevelView:self];
    }
}

@end
