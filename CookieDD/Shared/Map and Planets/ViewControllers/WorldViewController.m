//
//  WorldViewController.m
//  Map_Plist
//
//  Created by Josh on 9/24/13.
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

#import "WorldViewController.h"
#import "ZoomInSegue.h"

#import "SGFocusableFadeView.h"

@interface WorldViewController ()

@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (strong, nonatomic) NSString *currentFriendImageURL;
@property (strong, nonatomic) UIImageView *currentFriendImage;
@property (strong, nonatomic) UILabel *currentFriendNameLabel;
@property (strong, nonatomic) UILabel *currentFriendStatsLabel;
@property (assign, nonatomic) int currentFriendIndex;
@property (strong, nonatomic) UIButton *facebookButton;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

@property (strong, nonatomic) NSDictionary *worldPropertiesDict;

// Facebook Values
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSDate *birthDate;
@property (strong, nonatomic) NSURL *imageUrl;

@end

@implementation WorldViewController

#pragma mark - Init

- (void)setup
{
    _friendsArray = [NSMutableArray new];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // Init variables
        [self setup];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updatePlanetoids];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _friendsArray = [[NSMutableArray alloc] init];
    
    DebugLog(@"World Loaded.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This is the ringleader method that builds the entire world from the provided properties.
- (void)buildWorldFromProperties:(NSDictionary *)worldProperties {
    //DebugLog(@"worldProperties = %@", worldProperties);
    
//    NSArray *worldsArray = [[NSArray alloc]initWithArray:worldProperties[@"planetoids"]];
//    
//    for (NSDictionary *dictionary in worldsArray)
//    {
//        if (([[dictionary objectForKey:@"isUnlocked"] intValue] == 1) && ([[dictionary objectForKey:@"id"] intValue] != 0))
//        {
//            DebugLog(@"FOUND IT!!!!");
//            [self performSelector:@selector(buildTravelDotsFromPropertiesArray:) withObject:worldProperties[@"travelDots"] afterDelay:0.1f];
//        }
//    }
    [self performSelector:@selector(buildTravelDots) withObject:nil afterDelay:0.1f];
    
    [self buildPlanetoidsFromPropertiesArray:worldProperties[@"planetoids"]];
    [self buildDetailObjectsFromPropertiesArray:worldProperties[@"detailObjects"]];
    [self.backgroundImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"map_background_stars"]]]; // This is what you see if there is no BG image.
    
    // Create the store ship.
    [self createStoreShip];
    
    self.regionsArray = worldProperties[@"regions"];
    
    [self updatePlanetoids];
}

- (void)buildTravelDots {
    
    // - for each world in the accountDict.
    //    - If the ID is > 1; create travel dots to it.
    //       - Grab the array of travel dots from the plist.
    //       - Use the planet's ID - 1 as the index to use.
    //       - Loop through, and place, the travel dots.
    
    NSArray *accountWorldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
    NSArray *travelDotsSetsArray = [[SGFileManager fileManager] loadArrayWithFileName:@"traveldots" OfType:@"plist"];
    
    int index = 0;
    for (NSDictionary *accountWorldDict in accountWorldsArray)
    {
        index++;
        NSDictionary *nextWorldDict;
        
        if (index < [accountWorldsArray count])
        {
            nextWorldDict = [NSDictionary dictionaryWithDictionary:[accountWorldsArray objectAtIndex:index]];
        }
        
        if ([accountWorldDict[@"type"] intValue] > 0)
        {
            if ([nextWorldDict objectForKey:@"isUnlocked"] == [NSNumber numberWithInt:1])
            {
                int dotIndex = [accountWorldDict[@"type"] intValue] - 1;
                DebugLog(@"Place travelDot set from index %i", dotIndex);
                NSArray *travelDots = travelDotsSetsArray[dotIndex];
                
                float strobeDelay = 0.0f;
                for (NSString *pointString in travelDots)
                {
                    CGPoint dotPosition = CGPointFromString(pointString);
                    CDTravelDot *dot = [[CDTravelDot alloc] initWithDefaultImageNamed:@"cdd-map-traveldots-disabled" activeImageNamed:@"cdd-map-traveldots-active" position:dotPosition strobeDuration:1.0f];
                    
                    strobeDelay += (1.0f / 10.0f);
                    dot.strobeDelay = strobeDelay;
                    
                    [self.view insertSubview:dot atIndex:0];
                    
                    dot.isEnabled = YES;
                }
            }
            else
            {
                DebugLog(@"This planet is still locked");
            }
        }
    }
    
    
    
    
    
    
//    //DebugLog(@"Traveldots properteisArray: %@", propertiesArray);
//    CGPoint milkyPosition = CGPointMake(245, 275);
//    CGPoint dunkPosition = CGPointMake(600, 750);
//    int numDots = 30;
//    float xStep = (dunkPosition.x - milkyPosition.x) / numDots;
//    float yStep = (dunkPosition.y - milkyPosition.y) / numDots;
//    
//    float strobeDelay = 0.0f;
//    for (int count = 0; count < numDots; count++) {
//        CGPoint dotPosition = CGPointMake(milkyPosition.x + (xStep * count), milkyPosition.y + (yStep * count));
//        CDTravelDot *dot = [[CDTravelDot alloc] initWithDefaultImageNamed:@"cdd-map-traveldots-disabled" activeImageNamed:@"cdd-map-traveldots-active" position:dotPosition strobeDuration:1.0f];
//
//            strobeDelay += (1.0f / 10.0f);
//            dot.strobeDelay = strobeDelay;
//        
//            [self.view insertSubview:dot atIndex:0];
//
//            dot.isEnabled = YES;
//
//    }
    
    
    // OLD
    
//    for (NSArray *dotsCluster in propertiesArray) {
//        
//        float strobeDelay = 2.0f;
//        for (NSString *dotPositionString in dotsCluster) {
//            CGPoint dotPosition = CGPointFromString(dotPositionString);
//            CDTravelDot *dot = [[CDTravelDot alloc] initWithDefaultImageNamed:@"cdd-map-traveldots-disabled" activeImageNamed:@"cdd-map-traveldots-active" position:dotPosition strobeDuration:1.0f];
//            
//            strobeDelay += 0.1667f;
//            dot.strobeDelay = strobeDelay;
//            
//            dot.isEnabled = YES;
//            
//            [self.view addSubview:dot];
//        }
//    }
}

// This creates the planetoids you can zoom in on, and adds them to a local
// array for later use.
// add satelite around planets
- (void)buildPlanetoidsFromPropertiesArray:(NSArray *)propertiesArray {
    if (propertiesArray) {
        
        NSMutableArray *tempPlanetoidsArray = [[NSMutableArray alloc] init];
        
        int planetCount = 0;
        
        for (NSDictionary *propertiesDict in propertiesArray) {
            CGPoint position = CGPointFromString(propertiesDict[@"position"]);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                position = CGPointMake(position.x * 2.5f, position.y * 2.5f);
            }
            CDPlanetoidObject *planetoid = [[CDPlanetoidObject alloc] initWithImageNamed:propertiesDict[@"imageName"] AndPosition:position];
            [planetoid setPropertiesFromDictionary:propertiesDict];
            planetoid.triggerId = [(NSNumber *)propertiesDict[@"id"] intValue];
            planetoid.delegate = self;
            planetoid.morphScaleLimit = 0.93f;
            planetoid.morphSpeed = 0.6f;
            [planetoid startMorphBubble];
            [planetoid morphBubble:planetoid.backgroundImageView.layer];
            [self.view addSubview:planetoid];
            
            // Only create a satellite for planets that are unlockable
            if (planetCount < numUnlockablePlanets)
            {
                [self createSateliteForPlanetoid:planetoid];
            }
            planetCount++;
            
            [tempPlanetoidsArray addObject:planetoid];
        }
        _regionIconsArray = [NSArray arrayWithArray:tempPlanetoidsArray];
    }
    else {
        DebugLog(@"Error: Trying to build planetoids from nothing.");
    }
}

- (void)createSateliteForPlanetoid:(CDPlanetoidObject *)planetoid
{
    CDSateliteObject *satelite = [[CDSateliteObject alloc] initSateliteWithPosition:planetoid];
    satelite.delegate = self;
    [self.view addSubview:satelite];
    satelite.originPosition = satelite.frame.origin;
    [satelite animateSatellite:satelite];
}

// This creates the detail objects for the map, and adds them to a local array for later use.
- (void)buildDetailObjectsFromPropertiesArray:(NSArray *)propertiesArray {
    if (propertiesArray) {
        NSMutableArray *tempDetailObjectsArray = [[NSMutableArray alloc] init];
//        for (NSDictionary *objectProperties in propertiesArray) {
//            MapObject *detailObject = [[MapObject alloc] initWithImage:[UIImage imageNamed:objectProperties[@"imageName"]] AndPosition:[(NSValue *)objectProperties[@"position"] CGPointValue]];
//            [self.view addSubview:detailObject];
//            [tempDetailObjectsArray addObject:detailObject];
//        }
        
        self.detailObjectsArray = [NSArray arrayWithArray:tempDetailObjectsArray];
    }
    else {
        DebugLog(@"Error: Trying to build detail objects from nothing.");
    }
}

- (void)createStoreShip {
    //TODO: Make the ship's placement dynamic, so it appears on screen, but not behind any planets.
    
    self.storeShip = [[CDStoreObject alloc] initWithImageNamed:@"storeship-mapicon" AndPosition:CGPointMake(250.0f, 500.0f)];
    self.storeShip.delegate = self;
    [self.view addSubview:self.storeShip];
    [self.storeShip animateStore];
}

- (void)updatePlanetoids {
    DebugLog(@"Updating Planetoids.");
    NSArray *worldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
    if (worldsArray) {
        int numUnlockedWorlds = (int)[worldsArray count];
        
        for (CDPlanetoidObject *planetoid in _regionIconsArray) {
            if ([planetoid.planetID intValue] < numUnlockedWorlds) {
                planetoid.isUnlocked = YES;
            }
            else {
                planetoid.isUnlocked = NO;
            }
        }
    }
}

#pragma mark - Satellites

- (void)addHologramWithSatelite:(CDSateliteObject *)sateliteObject
{
    UIImageView *hologramImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cdd-map-satelliteholo"]];
    [self.view addSubview:hologramImageview];
    //[self.view insertSubview:hologramImageview belowSubview:sateliteObject];
    hologramImageview.userInteractionEnabled = YES;
    //[hologramImageview.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    //[hologramImageview.layer setBorderWidth:1.0f];
    CGRect frame = hologramImageview.frame;
    frame.origin = sateliteObject.frame.origin;
    frame.origin.x = frame.origin.x - frame.size.width + 44;
    frame.origin.y = frame.origin.y + 32;
    hologramImageview.frame = frame;
    sateliteObject.hologramImageView = hologramImageview;
    [self fetchFriendsWithHologramImageView:sateliteObject];
}

- (void)fetchFriendsWithHologramImageView:(CDSateliteObject *)satellite
{
    //--------------------
    // Activity Indicator
    //--------------------
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect newFrame =  self.loadingIndicator.frame;
    newFrame.size = CGSizeMake(80.0f, 80.0f);
    newFrame.origin = CGPointMake(satellite.hologramImageView.frame.size.width * 0.3f, satellite.hologramImageView.frame.size.height * 0.3f);
    self.loadingIndicator.frame = newFrame;
    [self.loadingIndicator setHidesWhenStopped:YES];
    [satellite.hologramImageView addSubview:self.loadingIndicator];
    [self.loadingIndicator startAnimating];
    
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
                          
                          // Copy friends array to satellite
                          satellite.friendsArray = [self.friendsArray mutableCopy];

                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self showFriendsWithHologramImageView:satellite];
                          });
                      }
                  }
              }];
         }
         
         else if (!friendArray)
         {
             // Display facebook button
             DebugLog(@"Satellite: No friendsArray");
             
             UIImage *facebookBtnDefault = [UIImage imageNamed:@"cdd-hud-btnfacebook-default"];
             UIImage *facebookBtnActive = [UIImage imageNamed:@"cdd-hud-btnfacebook-active"];
             
             self.facebookButton = [[UIButton alloc] init];
             CGRect fbFrame = self.facebookButton.frame;
             fbFrame.size = CGSizeMake(65, 65);
             fbFrame.origin = CGPointMake((satellite.hologramImageView.frame.size.width - fbFrame.size.width) / 2,
                                          (satellite.hologramImageView.frame.size.height - fbFrame.size.height) / 2);
             self.facebookButton.frame = fbFrame;
             [self.facebookButton setBackgroundImage:facebookBtnDefault forState:UIControlStateNormal];
             [self.facebookButton setBackgroundImage:facebookBtnActive forState:UIControlStateHighlighted];
             [self.facebookButton addTarget:self action:@selector(facebookButtonHit) forControlEvents:UIControlEventTouchUpInside];
             
             [satellite.hologramImageView addSubview:self.facebookButton];
             [self.loadingIndicator stopAnimating];
         }
         else //if (error)
         {
             DebugLog(@"Error fetching friends");
             
             NSString *errorMsg = @"Satellite\noffline";
             
             UILabel *errorMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(satellite.hologramImageView.frame.size.width * 0.4f, satellite.hologramImageView.frame.size.height * 0.25f, satellite.hologramImageView.frame.size.width, satellite.hologramImageView.frame.size.height)];
             errorMsgLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:18.0f];
             errorMsgLabel.text = [NSString stringWithFormat:@"%@", errorMsg];
             errorMsgLabel.textColor = [UIColor whiteColor];
             errorMsgLabel.numberOfLines = 0;
             [errorMsgLabel sizeToFit];
             
             [satellite.hologramImageView addSubview:errorMsgLabel];
             [self.loadingIndicator stopAnimating];
         }
     }];
}

- (void)showFriendsWithHologramImageView:(CDSateliteObject *)satellite
{
    // Create a temporary array to hold all friends that are on the current planet
    NSMutableArray *currentWorldFriendsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *friend in self.friendsArray)
    {
         //NSDictionary *friendInfoDict = friend;
        if ([friend[@"currentGameProgress"][@"worldType"] intValue] == [satellite.planetID intValue] + 1)
        {
            [currentWorldFriendsArray addObject:[friend mutableCopy]];
        }
    }
    
    if ([currentWorldFriendsArray count] > 0)
    {
        
        // Grab a random friend from those currently playing on this planet to be displayed
        int randomIndex = arc4random() % [currentWorldFriendsArray count];
        
        // Grab a new random friend to display
//        if (randomIndex == _currentFriendIndex && [currentWorldFriendsArray count] > 1)
//        {
//            if ((randomIndex+1) < ([currentWorldFriendsArray count]-1))
//            {
//                randomIndex += 1;
//            }
//            else if(randomIndex > 0)
//            {
//                randomIndex -= 1;
//            }
//        }
//
//        if (_currentFriendImage) [_currentFriendImage removeFromSuperview];
//        if (_currentFriendNameLabel) [_currentFriendNameLabel removeFromSuperview];
//        if (_currentFriendStatsLabel) [_currentFriendStatsLabel removeFromSuperview];
        
        _currentFriendIndex = randomIndex;
        
//        //--------------------
//        // Activity Indicator
//        //--------------------
//        UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        CGRect newFrame =  loadingIndicator.frame;
//        newFrame.size = CGSizeMake(80.0f, 80.0f);
//        newFrame.origin = CGPointMake(satellite.hologramImageView.frame.size.width * 0.3f, satellite.hologramImageView.frame.size.height * 0.3f);
//        loadingIndicator.frame = newFrame;
//        [loadingIndicator setHidesWhenStopped:YES];
//        [satellite.hologramImageView addSubview:loadingIndicator];
//        [loadingIndicator startAnimating];
        
        //--------------------
        // Scroll View
        //--------------------
        CGFloat scrollWidth = 120.0f;
        CGFloat scrollHeight = 180.0f;
        CGRect frame = satellite.hologramImageView.frame;
        frame.size = CGSizeMake(scrollWidth, scrollHeight);
        frame.origin = CGPointMake(satellite.hologramImageView.frame.size.width * 0.25f, satellite.hologramImageView.frame.size.height * 0.15f);
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        //scrollView.backgroundColor = [UIColor blueColor];
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollHeight * [currentWorldFriendsArray count]);
        satellite.friendScrollView = scrollView;
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = satellite;
        
//        [UIView animateWithDuration:3.0 delay:3.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
//            [UIView animateWithDuration:0.1 animations:^{
//                scrollView.alpha = 0.4;
//            }];
//        } completion:^(BOOL finished) {
//   
//        }];
        
        //-----------------
        // Page control
        //-----------------
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.transform = CGAffineTransformMakeRotation(M_PI / 2);
        CGRect pageFrame = pageControl.frame;
        pageControl.frame = CGRectMake(scrollView.frame.origin.x + scrollView.frame.size.width + 8,
                                       scrollView.frame.origin.y + ((scrollView.frame.size.height - pageFrame.size.height) / 2) - 16,
                                       pageFrame.size.width,
                                       pageFrame.size.height);
        
        // Only display pages if there are more than one
        if ([currentWorldFriendsArray count] > 1)
        {
            pageControl.numberOfPages = [currentWorldFriendsArray count];
        }
        else
        {
            pageControl.numberOfPages = 0;
        }
        
        satellite.pageControl = pageControl;
        [satellite.hologramImageView addSubview:pageControl];
        
        
        //-----------------
        // Limit number of friends to be displayed in the satellite
        //-----------------
        int index = 0;
        if (index <= 6)
        {
            for (NSDictionary *currentFriend in currentWorldFriendsArray)
            {
                // Create a friendView to hold friend information
                frame.size = CGSizeMake(scrollWidth, scrollHeight);
                frame.origin = CGPointMake(0, frame.size.height * index);
                
                //------------------
                // Friend View
                //------------------
                UIView *friendView = [[UIView alloc] initWithFrame:frame];
                //[friendView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                //[friendView.layer setBorderWidth:1.0f];
                
                index++;
                
                // Store the info for selected friend to display
                //NSDictionary *friendInfoDict = currentWorldFriendsArray[randomIndex];
                NSDictionary *friendInfoDict = currentFriend;
                
                if ([friendInfoDict isKindOfClass:[NSDictionary class]])
                {
                    if (friendInfoDict[@"profileAvatar"])
                    {
                        // Remove the image size width and height from request url
                        // Takes out everything after and including the '?'
                        // This way we only request the small profile picture
                        NSString *stringURL = friendInfoDict[@"profileAvatar"];
                        NSRange range = [stringURL rangeOfString:@"?" options:NSBackwardsSearch];
                        NSString *modifiedStringURL = [stringURL substringToIndex:range.location];
                        NSString *pictureSize = [NSString stringWithFormat:@"?width=120&height=120"];
                        modifiedStringURL = [modifiedStringURL stringByAppendingString:pictureSize];
                        
                        //NSString *stringURL = friendInfoDict[@"profileAvatar"];
                        NSURL *url = [NSURL URLWithString:modifiedStringURL];
                        
                        [[WebserviceManager sharedManager] requestImageAtURL:url completionHandler:^
                         (NSError *error, NSIndexPath *indexPath, UIImage *image)
                         {
                             if (image && !error)
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                     UIImage *croppedImage = [[WebserviceManager sharedManager] cropPhoto:imageView withMaskedImage:[UIImage imageNamed:@"Profile-88x88"]];
                                     imageView.image = croppedImage;
                                     [imageView setContentMode:UIViewContentModeScaleAspectFit];
                                     //[imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                                     //[imageView.layer setBorderWidth:1.0f];
                                     _currentFriendImage = imageView;
                                     
                                     UIImage *borderImage = [UIImage imageNamed:@"cdd-hud-ico-playerphoto"];
                                     UIImageView *borderImageView = [[UIImageView alloc] initWithImage:borderImage];
                                     
                                     [friendView addSubview:imageView];
                                     [friendView addSubview:borderImageView];
                                     
                                     CGRect frame = imageView.frame;
                                     frame.size = CGSizeMake(80.0f, 80.0f);
                                     frame.origin = CGPointMake(frame.origin.x + ((friendView.frame.size.width - frame.size.width) / 2), frame.origin.y + ((friendView.frame.size.height - frame.size.height) / 2));
                                     imageView.frame = frame;
                                     
                                     // Position cookie hud image
                                     frame.size = CGSizeMake(100.0f, 100.0f);
                                     frame.origin.x = frame.origin.x - 10;
                                     frame.origin.y = frame.origin.y - 10;
                                     borderImageView.frame = frame;
                                     
                                     
                                     
                                     if (friendInfoDict[@"firstName"] && friendInfoDict[@"lastName"])
                                     {
                                         NSString *firstName = friendInfoDict[@"firstName"];
                                         NSString *lastName = friendInfoDict[@"lastName"];
                                         
                                         UILabel *friendNameLabel = [[UILabel alloc] init];
                                         friendNameLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
                                         friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                                         friendNameLabel.textColor = [UIColor whiteColor];
                                         [friendNameLabel sizeToFit];
                                         
                                         CGRect newFrame = friendNameLabel.frame;
                                         newFrame.origin = CGPointMake(imageView.frame.origin.x - ((newFrame.size.width - imageView.frame.size.width) / 2), imageView.frame.origin.y - newFrame.size.height * 2);
                                         friendNameLabel.frame = newFrame;
                                         _currentFriendNameLabel = friendNameLabel;
                                         
                                         [friendView addSubview:friendNameLabel];
                                     }
                                     
                                     if (friendInfoDict[@"currentGameProgress"][@"levelType"] && friendInfoDict[@"currentGameProgress"][@"worldType"])
                                     {
                                         NSString *currentLevel = friendInfoDict[@"currentGameProgress"][@"levelType"];
                                         //NSString *currentWorld = friendInfoDict[@"currentGameProgress"][@"worldType"];
                                         NSString *currentWorld = satellite.planetDisplayName;
                                         
                                         UILabel *currentStatsLabel = [[UILabel alloc] init];
                                         currentStatsLabel.numberOfLines = 0;
                                         currentStatsLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
                                         currentStatsLabel.text = [NSString stringWithFormat:@"%@ \n Level: %@", currentWorld, currentLevel];
                                         currentStatsLabel.textColor = [UIColor whiteColor];
                                         currentStatsLabel.textAlignment = NSTextAlignmentCenter;
                                         [currentStatsLabel sizeToFit];
                                         
                                         CGRect newFrame = currentStatsLabel.frame;
                                         newFrame.origin = CGPointMake(imageView.frame.origin.x - ((newFrame.size.width - imageView.frame.size.width) / 2), imageView.frame.origin.y + imageView.frame.size.height + 8);
                                         currentStatsLabel.frame = newFrame;
                                         _currentFriendStatsLabel = currentStatsLabel;
                                         
                                         [friendView addSubview:currentStatsLabel];
                                     }
                                     
                                     // Add friend to scroll view
                                     [scrollView addSubview:friendView];
                                     
                                     // Display a different image on a time interval
                                     //                             double delayInSeconds = 8.0;
                                     //                             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                     //                             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                     //                                 [self showFriendsWithHologramImageView:hologramImageview satellitePlanetID:planetID];
                                     //                             });
                                     
                                 }); // dispath_async
                                 
                                 // Stop loading indicator from animation once facebook image is displayed
                                 [self.loadingIndicator stopAnimating];
                             }
                         }];
                    }
                }
            }
        }
        [satellite.hologramImageView addSubview:scrollView];
    }
    else
    {
        // No friends on current world
        UILabel *friendNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(satellite.hologramImageView.frame.size.width * 0.4f, satellite.hologramImageView.frame.size.height * 0.25f, satellite.hologramImageView.frame.size.width, satellite.hologramImageView.frame.size.height)];
        friendNameLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:18.0f];
        friendNameLabel.numberOfLines = 0;
        friendNameLabel.text = [NSString stringWithFormat:@"No friends \n available"];
        friendNameLabel.textColor = [UIColor whiteColor];
        [friendNameLabel sizeToFit];
        [satellite.hologramImageView addSubview:friendNameLabel];
        
        [self.loadingIndicator stopAnimating];
        
        DebugLog(@"No friends currently on this world.");
    }
}

- (void)facebookButtonHit
{
    DebugLog(@"Satellite FacebookButtonHit");
    [self.facebookButton setHidden:YES];
    [self.loadingIndicator startAnimating];
    
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
                                  
                                  [[WebserviceManager sharedManager] requestToUpdateAccountWithEmail:weakSelf.emailAddress
                                                                                            deviceId:[SGAppDelegate appDelegate].currentDeviceID
                                                                                           firstName:weakSelf.firstName
                                                                                            lastName:weakSelf.lastName
                                                                                              gender:weakSelf.gender
                                                                                           birthdate:weakSelf.birthDate
                                                                                          facebookID:facebookId
                                                                                      didRecieveGift:nil
                                                                                   completionHandler:^
                                   (NSDictionary *dictionary, NSError *error)
                                   {
                                       if (dictionary)
                                       {
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [SGAppDelegate appDelegate].loggedInThroughFacebook = YES;
                                               
                                               if (dictionary[@"account"] && [dictionary[@"account"] isKindOfClass:[NSDictionary class]])
                                               {
                                                   [SGAppDelegate appDelegate].accountDict = [dictionary[@"account"] mutableCopy];
                                                   
                                                   [self updatePlanetoids];
                                                   [self.loadingIndicator stopAnimating];
                                                   
                                                   for (UIView *view in weakSelf.view.subviews)
                                                   {
                                                       if ([view isMemberOfClass:[CDSateliteObject class]])
                                                       {
                                                           [weakSelf fetchFriendsWithHologramImageView:(CDSateliteObject *)view];
                                                       }
                                                   }
                                                   
                                                }
                                               else
                                               {
                                                   [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf.parentViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:weakSelf.view.frame errorDescription:@"An error has occurred" loadingText:nil];
                                               }
                                           });
                                       }
                                       else if (error)
                                       {
                                           DebugLog(@"");
                                           [[SGAppDelegate appDelegate] dismissConditionalView];
                                           [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf.parentViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:weakSelf.parentViewController.view.frame errorDescription: [NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
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
                 [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf.parentViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:weakSelf.parentViewController.view.frame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
             });
             
             return;
         }
         [self.loadingIndicator stopAnimating];
     }];

}


#pragma mark - Store Object Delegate

- (void)didActivateStoreObject:(CDStoreObject *)storeObject {
    DebugLog(@"Store Selected.");
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"StoreHorn" FileType:@"caf" volume:0.3f]; //@"m4a" volume:0.3f];
    if ([self.delegate respondsToSelector:@selector(userSelectedStore:)]) {
        [self.delegate userSelectedStore:storeObject];
    }
}


#pragma mark - Map Trigger Object Delegate

// This simply listens for when the user taps a region's icon, and reacts accordingly.
- (void)mapTriggerObjectDidTrigger:(MapTriggerObject *)triggerObject {
    DebugLog(@"Selected a Trigger Object.");
    if ([triggerObject isKindOfClass:[CDPlanetoidObject class]]) {
        CDPlanetoidObject *planetoid = (CDPlanetoidObject *)triggerObject;
        if (planetoid.isUnlocked) {
            if ([self.delegate respondsToSelector:@selector(userSelectedPlanetoid:)]) {
                [self.delegate userSelectedPlanetoid:planetoid];
            }
        } else {
            DebugLog(@"Sorry, that planet is currently locked.");
        }
        
//        // TODO: Set the details of the level info VC.
//        [self.levelInfoViewController.planetNameLabel setText:planetoid.name];
//        [self.view addSubview:self.levelInfoViewController.view];
//        [self.levelInfoViewController animateIn];
    }
    
    else if ([triggerObject isKindOfClass:[CDSateliteObject class]])
    {
        CDSateliteObject *satelite = (CDSateliteObject *)triggerObject;
        if ([self.delegate respondsToSelector:@selector(worldViewController:didSelectPlanetoidSatelite:)])
        {
            [self.delegate worldViewController:self didSelectPlanetoidSatelite:satelite];
        }
    }
}


@end
