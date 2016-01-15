//
//  LMGCManager.h
//  CookieDD
//
//  Created by Luke McDonald on 2/17/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
// Reference
// http://www1.in.tum.de/lehrstuhl_1/people/98-teaching/tutorials/513-sgd-ws13-tutorial-game-center

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

/*
 
 Examples to update leaderboard and achievements, login game center and show leaderboard
 
 [[LMGCManager gcManager] authenticateLocalUserOnViewController:self setCallbackObject:self withPauseSelector:@selector(selector)];
 
 [[LMGCManager gcManager] showLeaderboardOnViewController:controller]; controller would be self if in taht controller.

 
 [[GCHelper defaultHelper] reportScore:score forLeaderboardID:kLeaderBoardIdentifier];
 
 [[GCHelper defaultHelper] reportAchievementIdentifier:kAchievement1000Score percentComplete:100.0];
 
 */

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "SGAchievementAlertView.h"

typedef void(^methodCompletion)(BOOL);

extern NSString* const kLeaderBoardIdentifier;

extern NSString* const kAchievement500Score;


@interface SGGameCenterManager : NSObject <GKGameCenterControllerDelegate, GKChallengeListener>

@property (assign, nonatomic) BOOL gameCenterIsAvailable;
@property (assign, nonatomic) BOOL userIsAuthenticated;
@property (strong, nonatomic) NSArray *leaderboardsArray;
@property (strong, nonatomic) NSMutableDictionary *achievementsDictionary;
@property (strong, nonatomic) NSMutableDictionary *achievementDescriptions;

#pragma mark - Initialization

+ (SGGameCenterManager *)gcManager;

#pragma mark - Game Center Authentication

- (BOOL)isGameCenterAvailable;

- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController
                            setCallbackObject:(id)obj
                            withPauseSelector:(SEL)selector;

#pragma mark - Leaderboard

- (void)showLeaderboardOnViewController:(UIViewController *)viewController;

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString *)identifier;

#pragma mark - Achievements

- (void)loadAchievementDescriptionsWithCompletion:(methodCompletion)wasSuccessful;

- (void)reportAchievementWithIdentifier:(NSString *)identifier
                        percentComplete:(float)percent
                             Completion:(methodCompletion)wasSuccessful;

- (GKAchievement*)getAchievementForIdentifier:(NSString *)identifier;

- (GKAchievementDescription*)descriptionForAchievementWithIdentifier:(NSString*)identifier;

- (void)resetAchievements;

- (float)progressOfAchievementWithIdentifier:(NSString*)identifier;

- (void)completeMultipleAchievements:(NSArray *)achievements;

- (void)displayAchievementAlertWithMessage:(NSString*)message InView:(UIView *)view Completion:(methodCompletion)completed;

- (void)displayAchievementAlertForAchievementWithIdentifier:(NSString*)identifier InView:(UIView *)view Completion:(methodCompletion)completed;

#pragma mark - GKLocalPlayerListener / Challenges

- (void)registerListener:(id<GKLocalPlayerListener>)listener;

@end
