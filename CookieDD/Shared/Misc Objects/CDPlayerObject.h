//
//  CDPlayerObject.h
//  CookieDD
//
//  Created by Josh on 1/8/14.
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

#import <Foundation/Foundation.h>

@interface CDPlayerObject : NSObject

@property (strong, nonatomic) NSString *playerID;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSDate *birthdate;
@property (strong, nonatomic) NSString *facebookID;


// # of lives.
@property (strong, nonatomic) NSNumber *lives;
// Minimum # of lives the player can have.  If they ever drop below this
// number, lives will recharge until they're above it again.
@property (strong, nonatomic) NSNumber *minLives;
// # of jewels.
@property (strong, nonatomic) NSNumber *jewels;
// # of coins.
@property (strong, nonatomic) NSNumber *coins;


// Array of worlds, where the index is tied to the order they're unlocked.
// Each world has it's own array of levels.  Each level is a dictionary
// with the player's total score and star count.
@property (strong, nonatomic) NSArray *worlds;


// # of various booster types.
@property (strong, nonatomic) NSDictionary *boosters;
// # of various powerup types.
@property (strong, nonatomic) NSDictionary *powerups;
// # of extra moves that can be used in game.
@property (strong, nonatomic) NSNumber *moves;
// # of various time packs that can be added to the game timer.
@property (strong, nonatomic) NSDictionary *timePacks;
// Holds multiple arrays of costume sets that have been unlocked.
@property (strong, nonatomic) NSArray *superCostumeSets;


// Array of dates that the player's lives will recharge at.
@property (strong, nonatomic) NSArray *LifeRechargeDates;


// Date the account was created.
@property (strong, nonatomic) NSDate *createdAt;
// Date the account was last updated.
@property (strong, nonatomic) NSDate *updatedAt;  // Is this server side, or device side?


//////////////////////
// Achievement Info //
//////////////////////

// Bucket o' Water
@property (assign, nonatomic) BOOL hasUsedSuperGlove;
@property (assign, nonatomic) BOOL hasUsedRadSprinkle;
@property (assign, nonatomic) BOOL hasUsedSmoreUpgrade;
@property (assign, nonatomic) BOOL hasUsedWrapperUpgrade;

// Cookie Boost
@property (assign, nonatomic) BOOL hasUsedBomb;
@property (assign, nonatomic) BOOL hasUsedLightning;
@property (assign, nonatomic) BOOL hasUsedSlotMachine;
@property (assign, nonatomic) BOOL hasUsedSpatula;

// The Investors
@property (assign, nonatomic) float cumulativeDollarsSpent;

// The Bakers
@property (assign, nonatomic) int cumulativeScore;



+ (CDPlayerObject*)player;

// Creates a new player with default settings.
+ (CDPlayerObject*)createNewPlayerWithEmail:(NSString *)email
                                  firstName:(NSString *)firstName
                                   lastName:(NSString *)lastName
                                     gender:(NSString *)gender
                                  birthdate:(NSDate *)birthdate
                                 facebookID:(NSString *)facebookID;

// Grab a player from the server with a given ID.
+ (CDPlayerObject*)loadPlayerWithID:(NSString*)playerID;

// Grab a player from the server with a given ID.
+ (CDPlayerObject*)loadPlayerWithEmail:(NSString*)playerEmail;

// Check the server for a player with a given email.
+ (NSString *)getPlayerIDForEmail:(NSString *)email;

// Connects this player object to it's counterpart on the server.
- (void)loginToServerWithEmail:(NSString*)userEmail AndPassword:(NSString*)userPassword;

// Overrides the server's attributes with what's on this player.
- (void)uploadPlayerToServer;

// Gives the player access to every level/planet up to the given level.
// Alternatively, removes access down to the given level.
- (void)setProgressOfPlayerWithID:(NSNumber *)playerID ToLevel:(int)level OfPlanet:(int)planet;

// Simply unlocks the next level for the player.  This includes a level on
// the same planet, a minigame on the same planet, or the first level of
// the next planet.
- (void)unlockNextLevel;

// 
- (void)setCookieTypes:(NSArray*)cookieTypesArray;

- (void)setCookieThemes:(NSArray*)cookieThemesArray;

- (void)resetAchievmentProperties;


@end
