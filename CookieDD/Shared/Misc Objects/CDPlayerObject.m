//
//  CDPlayerObject.m
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

#import "CDPlayerObject.h"

static CDPlayerObject *player = nil;

@implementation CDPlayerObject

#pragma mark - Player Creation

+ (CDPlayerObject *)player
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        player = [CDPlayerObject new];
    });
    
    return player;
}

+ (CDPlayerObject *)createNewPlayerWithEmail:(NSString *)email
                                   firstName:(NSString *)firstName
                                    lastName:(NSString *)lastName
                                      gender:(NSString *)gender
                                   birthdate:(NSDate *)birthdate
                                  facebookID:(NSString *)facebookID {
    CDPlayerObject *player;
    
//    player.email = email? email : @"No_Email";
//    player.firstName = firstName? firstName : @"No_FirstName";
//    player.lastName = lastName? lastName : @"No_LastName";
//    player.gender = gender? gender : @"No_Gender";
//    player.birthdate = birthdate? birthdate : nil;
//    player.facebookID = facebookID? facebookID : @"No_FacebookID";
    
    player.email = email;
    player.firstName = firstName;
    player.lastName = lastName;
    player.gender = gender;
    player.birthdate = birthdate;
    player.facebookID = facebookID;
    
    player.minLives = [NSNumber numberWithInt:5];
    player.jewels = [NSNumber numberWithInt:0];
    player.coins = [NSNumber numberWithInt:0];
    player.moves = [NSNumber numberWithInt:0];
    
    player.lives = [NSNumber numberWithInt:0];
    
    player.hasUsedSuperGlove = NO;
    player.hasUsedRadSprinkle = NO;
    player.hasUsedSmoreUpgrade = NO;
    player.hasUsedWrapperUpgrade = NO;
    
    player.hasUsedBomb = NO;
    player.hasUsedLightning = NO;
    player.hasUsedSlotMachine = NO;
    player.hasUsedSpatula = NO;
    
    player.cumulativeScore = 0;
    player.cumulativeDollarsSpent = 0.0f;
    
    //TODO: Unlock default super costumes.
    
    player.createdAt = [NSDate date];
    [player uploadPlayerToServer];
    
    return player;
}


#pragma mark - Server Stuff

+ (NSString *)getPlayerIDForEmail:(NSString *)email {
    NSString *playerID;
    //TODO: Get the player ID.
    if (/* playerID exists for this email? */ true) {
        // playerID = ID from server.
        return playerID;
    } else {
        return nil;
    }
}

+ (CDPlayerObject *)loadPlayerWithID:(NSString *)playerID {
    CDPlayerObject *player;
    //TODO: Load the player from the server.
    if (/* player exists for playerID */ true) {
        //player = player from server.
        return player;
    } else {
        return nil;
    }
}

+ (CDPlayerObject *)loadPlayerWithEmail:(NSString *)playerEmail {
    NSString *playerID = [CDPlayerObject getPlayerIDForEmail:playerEmail];
    return [CDPlayerObject loadPlayerWithID:playerID];
}

- (void)loginToServerWithEmail:(NSString *)userEmail AndPassword:(NSString *)userPassword {
    
}

- (void)uploadPlayerToServer {
    //TODO: Update the server with this player.
}


#pragma mark - Game Progression

- (void)unlockNextLevel {
    // TODO: unlock the next level/minigame/planet.
}

// <<< Untested
- (void)setProgressOfPlayerWithID:(NSNumber *)playerID ToLevel:(int)targetLevel OfPlanet:(int)targetPlanet {
    NSMutableArray *tempWorldsArray = [[NSMutableArray alloc] init];
    
    if ([self.worlds count] > targetPlanet) {
        // Add new worlds.
        
        NSDictionary *newLevelDict = [NSDictionary dictionaryWithObjectsAndKeys:@"highScore", [NSNumber numberWithInt:1], @"starCount", [NSNumber numberWithInt:0], nil];
        
        for (int worldIndex = 0; worldIndex < targetPlanet; worldIndex++) {
            NSMutableArray *tempLevelsArray = [[NSMutableArray alloc] init];
            if ([self.worlds objectAtIndex:worldIndex]) {
                // The player has unlocked this world.
                NSArray *levelsArray = [self.worlds objectAtIndex:worldIndex];
                for (int levelIndex = 0; levelIndex < 20; levelIndex++) {
                    if ([levelsArray objectAtIndex:levelIndex]) {
                        // The player has beaten this level.
                        [tempLevelsArray addObject:[levelsArray objectAtIndex:levelIndex]];
                    } else {
                        // Create a new, blank level.
                        [tempLevelsArray addObject:newLevelDict];
                    }
                }
            } else {
                // Create a new world, filled with blank levels.
                for (int levelIndex = 0; levelIndex < 20; levelIndex++) {
                    // Create a new, blank level.
                    [tempLevelsArray addObject:newLevelDict];
                }
            }
            // Add this world to the list.
            [tempWorldsArray addObject:tempLevelsArray];
        }
        
        // We're now one planet short.  Time to add it.
        NSMutableArray *tempLevelsArray = [[NSMutableArray alloc] init];
        for (int levelIndex = 0; levelIndex < targetLevel; levelIndex++) {
            // Because of our original check, it's guaranteed that the player
            // has not reached this planet.
            [tempLevelsArray addObject:newLevelDict];
        }
        [tempWorldsArray addObject:tempLevelsArray];
        
    } else {
        // Remove excess worlds.
        
        for (NSArray *levelsArray in self.worlds) {
            if ([self.worlds indexOfObject:levelsArray] < targetPlanet) {
                // We're safe to grab all the levels from this planet.
                [tempWorldsArray addObject:levelsArray];
            } else if ([self.worlds indexOfObject:levelsArray] == targetPlanet) {
                // Only grab levels up to our target.
                NSMutableArray *tempLevelsArray = [[NSMutableArray alloc] init];
                for (int levelIndex = 0; levelIndex < targetLevel; levelIndex++) {
                    if ([levelsArray objectAtIndex:levelIndex]) {
                        [tempLevelsArray addObject:[levelsArray objectAtIndex:levelIndex]];
                    }
                }
                [tempWorldsArray addObject:tempLevelsArray];
            } else {
                // We're done here.
                break;
            }
        }
    }
    
    // Commit the changes.
    self.worlds = tempWorldsArray;
    [self uploadPlayerToServer];
}

#pragma mark - Player Customization

- (void)setCookieTypes:(NSArray *)cookieTypesArray {
    
}

- (void)setCookieThemes:(NSArray *)cookieThemesArray {
    
}

#pragma mark - Achievements

- (void)resetAchievmentProperties {
    DebugLog(@"Resetting achievement properties.");
    
    _hasUsedSuperGlove = NO;
    _hasUsedRadSprinkle = NO;
    _hasUsedSmoreUpgrade = NO;
    _hasUsedWrapperUpgrade = NO;
    
    _hasUsedBomb = NO;
    _hasUsedLightning = NO;
    _hasUsedSlotMachine = NO;
    _hasUsedSpatula = NO;
    
    _cumulativeScore = 0;
    _cumulativeDollarsSpent = 0;
    
    //TODO: Update the account server side.
}

@end
