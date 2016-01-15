//
//  LMGCManager.m
//  CookieDD
//
//  Created by Luke McDonald on 2/17/14.
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

#import "SGGameCenterManager.h"

static SGGameCenterManager *gcManager = nil;

NSString* const kLeaderBoardIdentifier = @"TestLeaerBoard";

NSString* const kAchievement500Score = @"de.tum.in.www1.sgdws13.SpaceInvadersGameCenter.score500";

@interface SGGameCenterManager()


@end

@implementation SGGameCenterManager

#pragma mark - Initialization

+ (SGGameCenterManager *)gcManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gcManager = [SGGameCenterManager new];
    });
    
    return gcManager;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    if (self = [super init])
    {
        // Set up Game Center
        DebugLog(@"Checking Game Center availability.");
        _gameCenterIsAvailable = [self isGameCenterAvailable];
        if (_gameCenterIsAvailable)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
        
        _achievementsDictionary = [NSMutableDictionary new];
        _achievementDescriptions = [NSMutableDictionary new];
        
        _leaderboardsArray = [NSArray new];
        
        
    }
    
    return self;
}

#pragma mark - Game Center Authentication

- (BOOL)isGameCenterAvailable
{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    float reqSysVer = 4.1;
    
    float curSysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    BOOL osVersionSupported = curSysVer > reqSysVer;
    
    return (gcClass && osVersionSupported);
}

- (void)authenticationChanged
{
    if ([GKLocalPlayer localPlayer].isAuthenticated && !_userIsAuthenticated) {
        
        DebugLog(@"Game Center Authentication has changed: player is authenticated.");
        
        _userIsAuthenticated = YES;
        
        [self loadLeaderBoardInfo];
        
        [self loadAchievements];
        [self loadAchievementDescriptionsWithCompletion:nil];
        
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && _userIsAuthenticated)
    {
        DebugLog(@"Game Center Authentication has changed: player isn't authenticated.");
        
        _userIsAuthenticated = NO;
    }
}

- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController
                            setCallbackObject:(id)obj
                            withPauseSelector:(SEL)selector
{
    // If Game Center isn't available, we can just quit here.
    if (!_gameCenterIsAvailable) {
        DebugLog(@"Warning: Game Center isn't available.");
        return;
    }
    
    
    DebugLog(@"Authenticating local user for Game Center.");
    
    // The local player is the one who's playing on this specific device.
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    DebugLog(@"Set local player");
    
    // Check if the user is already authenticated.
    if (localPlayer.authenticated == NO) {
        DebugLog(@"Local player is not authenticated.");
        
        // Display a viewcontroller that will allow the player to log in.
        [localPlayer setAuthenticateHandler:^(UIViewController* authViewController, NSError *error) {
            DebugLog(@"Set authentication handler.");
            if (authViewController != nil) {
                DebugLog(@"authViewController is nil.");
                if (obj) {
                    DebugLog(@"Pause check.");
                    // Pause the callback object if you need to.
                    [obj performSelector:selector withObject:nil afterDelay:0];
                    DebugLog(@"Performed selector on obj.");
                }
                
                DebugLog(@"Presenting authentication view.");
                // Present the Game Center login view.
                [viewController presentViewController:authViewController animated:YES completion:^ {
                    // Anything that needs to happen when the viewcontroller is on screen can go here.
                    DebugLog(@"Authentication view presented.");
                }];
                
            }
            else if (error != nil)
            {
                // process error
                DebugLog(@"Error authenticating local user: %@", error.description);
            }
            else {
                DebugLog(@"Something weird happened while authenticating localPlayer.");
            }
        }];
    }
    else
    {
        DebugLog(@"Already authenticated to Game Center.");
    }
}

#pragma mark - Leaderboards

- (void)showLeaderboardOnViewController:(UIViewController*)viewController
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardIdentifier = kLeaderBoardIdentifier;
        
        [viewController presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)loadLeaderBoardInfo
{
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^
     (NSArray *leaderboards, NSError *error)
     {
        _leaderboardsArray = leaderboards;
    }];
}

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    
    scoreReporter.value = score;
    
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error)
    {
        if (error == nil)
        {
            DebugLog(@"Score reported successfully!");
        }
        else
        {
            DebugLog(@"Unable to report score!");
        }
    }];
}

#pragma mark - Achievements

- (void)loadAchievements
{
    if (_userIsAuthenticated) {
        DebugLog(@"Loading achievements.");
        // Reset the achievements dictionary.
        _achievementsDictionary = [[NSMutableDictionary alloc] init];
        
        [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
         {
             if (error != nil)
             {
                 // Handle the error.
                 DebugLog(@"Error while loading achievements: %@", error.description);
             }
             else
             {
                 // There's no error, so let's make sure we actually have achievements.
                 if (achievements != nil)
                 {
                     // Process the array of achievements.
                     for (GKAchievement* achievement in achievements)
                     {
                         _achievementsDictionary[achievement.identifier] = achievement;
                     }
                     DebugLog(@"Achievements have been loaded.");
                     
                     //DebugLog(@"All achievements: %@", _achievementsDictionary);
                 }
                 else {
                     DebugLog(@"Warning: No achievements were loaded.");
                 }
             }
         }];
    }
    else {
        DebugLog(@"Warning: Cannot load achievements if the user is not authenticated.");
    }
}

- (void)loadAchievementDescriptionsWithCompletion:(methodCompletion)wasSuccessful {
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray *descriptions, NSError *error) {
        if (error != nil) {
            DebugLog(@"Error loading achievement descriptions: %@", error.description);
            if (wasSuccessful) wasSuccessful(NO);
        }
        else {
            if (descriptions != nil) {
                for (GKAchievementDescription *description in descriptions) {
                    [_achievementDescriptions setObject:description forKey:description.identifier];
                }
                DebugLog(@"Achievement descriptions loaded.");
                if (wasSuccessful) wasSuccessful(YES);
            }
            else {
                DebugLog(@"Warning, no achievement descriptions were loaded.");
                if (wasSuccessful) wasSuccessful(YES);
            }
        }
    }];
}

- (GKAchievementDescription *)descriptionForAchievementWithIdentifier:(NSString *)identifier {
    GKAchievementDescription *achievementDesctiption = self.achievementDescriptions[identifier];
    
    return achievementDesctiption;
}

- (GKAchievement*)getAchievementForIdentifier:(NSString*) identifier
{
    DebugLog(@"Getting achievement with identifier '%@'.", identifier);
    
    GKAchievement *achievement = _achievementsDictionary[identifier];
    
    if (achievement == nil)
    {
        DebugLog(@"Warning: The achievement wasn't found.  Creating a fresh one.");
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        _achievementsDictionary[achievement.identifier] = achievement;
    }
    
    DebugLog(@"Percent complete of '%@' is %f", identifier, achievement.percentComplete);
    
    return achievement;
}


- (void)reportAchievementWithIdentifier: (NSString*) identifier percentComplete: (float) percent Completion:(methodCompletion)wasSuccessful
{
    if (_userIsAuthenticated) {
        GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
        
        DebugLog(@"Current achievement progress: %f", achievement.percentComplete);
        if (achievement && achievement.percentComplete < 100.0)
        {
            achievement.percentComplete = percent;
            
            achievement.showsCompletionBanner = NO;
            
            [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^
             (NSError *error)
             {
                 if (error != nil)
                 {
                     DebugLog(@"Error while reporting achievement: %@", error.description);
                     if (wasSuccessful) wasSuccessful(NO);
                 }
                 else {
                     if (wasSuccessful) wasSuccessful(YES);
                 }
                 
             }];
        }
        else {
            DebugLog(@"Warning: The achievement is already complete.");
            if (wasSuccessful) wasSuccessful(NO);
        }
    }
    else {
        DebugLog(@"Warning: Cannot report achievement if the user is not authenticated.");
        if (wasSuccessful) wasSuccessful(NO);
    }
}

- (void)resetAchievements
{
    if (_userIsAuthenticated) {

        DebugLog(@"Resetting all of your achievements.");
        
        // Clear all locally saved achievement objects.
        [_achievementsDictionary removeAllObjects];
        
        // Clear all progress saved on Game Center.
        [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
         {
             if (error != nil) {
                 // handle the error.
                 DebugLog(@"Error while reseting achievements: %@", error.description);
                 
             }
             else {
                 DebugLog(@"Achievements reset successfully.");
             }
        }];
    }
    else {
        DebugLog(@"Warning: Cannot reset achievements if the user is not authenticated.");
    }
}

- (float)progressOfAchievementWithIdentifier:(NSString *)identifier {
    if (_userIsAuthenticated) {
        GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
        DebugLog(@"Current progress is %f", achievement.percentComplete);
        return achievement.percentComplete;
    }
    else {
        DebugLog(@"Warning: Cannot get achievement progress if the user is not authenticated.");
        return -1.0f;
    }
}

- (void)completeMultipleAchievements:(NSArray*)achievements
{
    [GKAchievement reportAchievements:achievements withCompletionHandler:^
     (NSError *error)
    {
        if (error != nil)
        {
            DebugLog(@"Error while reporting achievements: %@", error.description);
        }
    }];
}

- (void)displayAchievementAlertWithMessage:(NSString *)message InView:(UIView *)view Completion:(methodCompletion)completed {
    SGAchievementAlertView *achievementAlert = [[[NSBundle mainBundle] loadNibNamed:@"SGAchievementAlertView" owner:self options:nil] objectAtIndex:0];
    [achievementAlert setupForScreenPosition:SGAchievementAlertScreenPositionTopCenter];
    [view addSubview:achievementAlert];
    [achievementAlert displayAchievementAlertWithMessage:[NSString stringWithFormat:@"Unlocked: %@", message] Completion:^(BOOL achievementDisplayCompleted) {
        [achievementAlert removeFromSuperview];
        if (completed) completed(YES);
    }];
}

- (void)displayAchievementAlertForAchievementWithIdentifier:(NSString *)identifier InView:(UIView *)view Completion:(methodCompletion)completed {
    // For now, this just uses the identifier as the message.
    GKAchievementDescription *achievementDescription = [[SGGameCenterManager gcManager] descriptionForAchievementWithIdentifier:identifier];
    [self displayAchievementAlertWithMessage:achievementDescription.title InView:view Completion:^(BOOL displayCompleted) {
        if (completed) completed(YES);
    }];
}



#pragma mark - GKLocalPlayerListener / Challenges

- (void)registerListener:(id<GKLocalPlayerListener>)listener
{
    [[GKLocalPlayer localPlayer] registerListener:listener];
}

#pragma mark - GKGameCenterControllerDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
