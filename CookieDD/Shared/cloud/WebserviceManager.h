//
//  WebserviceManager.h
//  CookieDD
//
//  Created by Josh Pagley on 11/18/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.
// [[UIDevice currentDevice].identifierForVendor UUIDString]

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
#import "SocketIO.h"

extern NSString *const kUpdatedAccountNotification;

typedef void (^ImageRequestCompletionHandler)(NSError *error, NSIndexPath *indexPath, UIImage *image);

typedef void (^ImageRequestWithIndexCompletionHandler)(UIImage *image, NSIndexPath *indexPath, NSError *error);

typedef void (^ImageMaskRequestSocialCompletionHandler)(NSError *error, NSIndexPath *indexPath, UIImage *image);

typedef void (^AccountsCreateCompletionHandler)(NSDictionary *dictionary, NSError *error);

typedef void (^GenericCompletionHandler)(NSDictionary *dictionary, NSError *error);

typedef void (^UpdatedAccountCompletionHandler)(NSError *error, NSDictionary *accountDict);

typedef void (^FriendsCompletionHandler)(NSError *error, NSDictionary *friends);

#pragma mark - Cookie Costumes Handlers

typedef void (^CookieCostumesCompletionHandler)(NSError *error, NSDictionary *cookieCostumesInfo);

#pragma mark - AcceptGift Handler

typedef void (^AcceptGiftCompletionHandler)(NSError *error, NSDictionary *acceptedGiftInfo);

#pragma mark - Time Handlers

typedef void (^TimeCompletionHandler)(NSError *error, NSDictionary *timeInfo);

#pragma mark - World Handlers

typedef void (^WorldCompletionHandler)(NSError *error, NSDictionary *worldInfo);

#pragma mark - Level Handlers

typedef void (^LevelCompletionHandler)(NSError *error, NSDictionary *levelInfo);

#pragma mark - Cookie Settings Handler

typedef void (^CookieSettingsCompletionHandler)(NSError *error, NSDictionary *cookieSettingsInfo);

#pragma mark - Multipliers Handler

typedef void (^MultipliersCompletionHandler)(NSError *error, NSDictionary *multiplierInfoDict);

#pragma mark - Cookie Packs Handler

typedef void (^CookiePacksCompletionHandler)(NSError *error, NSDictionary *cookiePackDict);

#pragma mark - Gifts Handler

typedef void (^GiftsCompletionHandler)(NSError *error, NSDictionary *giftInfo);

#pragma mark - Update Game Parameters Handler

typedef void (^GameParametersCompletionHandler)(NSError *error, NSDictionary *gameParametersInfoDict);

#pragma mark - Notification Handler

typedef void (^NotificationsCompletionHandler)(NSError *error, NSDictionary *notificationsInfoDict);

#pragma mark - Leaderboard Handler
typedef void (^LeaderboardCompletionHandler)(NSError *error, NSDictionary *dictionary);

@interface WebserviceManager : NSObject <SocketIODelegate>

+ (WebserviceManager *)sharedManager;

@property (strong, nonatomic) SocketIO *socketIO;

#pragma mark - Error Handler

//  - (void)showPopUpWithError:(NSError *)error;

#pragma mark - Cookie Costumes

- (void)requestToUpdateCookieCostumesWithEmail:(NSString *)email
                                      deviceId:(NSString *)deviceId
                                cookieCostumes:(NSMutableArray *)cookieCostumes
                             completionHandler:(CookieCostumesCompletionHandler)handler;

#pragma mark - AcceptGift

- (void)requestAcceptGiftWithEmail:(NSString *)email
                          deviceId:(NSString *)deviceId
                        parameters:(NSMutableDictionary *)parameters
                 completionHandler:(AcceptGiftCompletionHandler)handler;

#pragma mark - Time

- (void)requestServerTimeWithMinutes:(NSNumber *)minutes
                   completionHandler:(TimeCompletionHandler)handler;

- (void)requestLivesRegenerationTimeWithAccountId:(NSString *)accountId
                                completionhandler:(TimeCompletionHandler)handler;

- (void)requestToUpdateLivesRegenerationTimeWithAccountId:(NSString *)accountId
                                                  minutes:(NSNumber *)minutes
                                        completionhandler:(TimeCompletionHandler)handler;

-(void)requestAwardRegenerationTimeWithAccountId:(NSString *)accountId
                               completionhandler:(TimeCompletionHandler)handler;

- (void)requestToUpdateAwardRegenerationTimeWithAccountId:(NSString *)accountId
                                                  minutes:(NSNumber *)minutes
                                        completionhandler:(TimeCompletionHandler)handler;


#pragma mark - Images

- (void)requestImageAtURL:(NSURL *)url completionHandler:(ImageRequestCompletionHandler)handler;

- (void)requestImageAtURL:(NSURL *)url indexPath:(NSIndexPath *)indexPath
        completionHandler:(ImageRequestWithIndexCompletionHandler)handler;

- (void)requestMaskImageAtIndexPath:(NSIndexPath *)indexPath imageData:(NSData *)imageData imageToMask:(UIImageView *)imageToMask maskImage:(UIImage *)maskImage completionHandler:(ImageMaskRequestSocialCompletionHandler)handler;

- (UIImage *)cropPhoto:(UIImageView *)imageToCrop withMaskedImage:(UIImage *)maskedImage;

#pragma mark - Accounts

- (void)requestToCreateAccountWithEmail:(NSString *)email
                               deviceId:(NSString *)deviceId
                              firstName:(NSString *)firstName
                               lastName:(NSString *)lastName
                                 gender:(NSString *)gender
                              birthdate:(NSDate *)birthdate
                             facebookID:(NSString *)facebookID
                            deviceToken:(NSString *)deviceToken
                  profileImageStringURL:(NSString *)profileImageStringURL
                      completionHandler:(AccountsCreateCompletionHandler)handler;

- (void)requestToUpdateAccountWithEmail:(NSString *)email
                               deviceId:(NSString *)deviceId
                              firstName:(NSString *)firstName
                               lastName:(NSString *)lastName
                                 gender:(NSString *)gender
                              birthdate:(NSDate *)birthdate
                             facebookID:(NSString *)facebookID
                         didRecieveGift:(NSNumber *)didRecieveGift
                      completionHandler:(AccountsCreateCompletionHandler)handler;

- (void)requestToUpdateAccountWithParams:(NSMutableDictionary *)params completionHandler:(AccountsCreateCompletionHandler)handler;

- (void)requestToFetchAccountWithAccountId:(NSString *)accountId completionHandler:(UpdatedAccountCompletionHandler)handler;

- (void)requestToDeleteAccountWithEmail:(NSString *)email
                               deviceId:(NSString *)deviceId;

//- (void)updateGameParametersWithEmail:(NSString *)email
//                                 type:(NSString *)type
//                                value:(NSNumber *)value;

//- (void)connectToSocketIOServer;

#pragma mark - WORLD

- (void)updateWorldParametersWithEmail:(NSString *)email
                              deviceId:(NSString *)deviceId
                             worldType:(NSNumber *)worldType
                             worldName:(NSString *)worldName
                     completionHandler:(WorldCompletionHandler)handler;

#pragma mark - Levels

- (void)updateLevelParametersWithEmail:(NSString *)email
                              deviceId:(NSString *)deviceId
                             worldType:(NSNumber *)worldType
                             worldName:(NSString *)worldName
                             levelType:(NSNumber *)levelType
                             starCount:(NSNumber *)starCount
                             highScore:(NSNumber *)highScore
                     completionHandler:(LevelCompletionHandler)handler;

#pragma mark - Cookie Settings

// type, theme, cookieIndex, _id
- (void)requestToUpdateCokieSettingsWithEmail:(NSString *)email
                                     deviceId:(NSString *)deviceId
                               cookieSettings:(NSMutableArray *)cookieSettings
                            completionHandler:(CookieSettingsCompletionHandler)handler;

#pragma mark - Multipliers 

- (void)requestToCreateMultiplierWithEmail:(NSString *)email
                                  deviceId:(NSString *)deviceId
                            multiplierType:(NSString *)multiplierType
                                 startTime:(NSString *)startTime
                                   endTime:(NSString *)endTime
                                    levels:(NSString *)levels
                                  gemCosts:(NSNumber *)gemCosts
                                 coinCosts:(NSNumber *)coinCosts
                         completionHandler:(MultipliersCompletionHandler)handler;

- (void)requestToRemoveMultiplierWithEmail:(NSString *)email
                                  deviceId:(NSString *)deviceId
                              multiplierId:(NSString *)multiplierId
                         completionHandler:(MultipliersCompletionHandler)handler;


#pragma mark - Minigames

- (void)updateMiniGameParametersWithEmail:(NSString *)email
                                 deviceId:(NSString *)deviceId
                                     name:(NSString *)name
                                     type:(NSNumber *)type
                                    world:(NSString *)world
                                starCount:(NSNumber *)starCount
                                highScore:(NSNumber *)highScore;

#pragma mark - Update Game Parameters

- (void)requestToUpdateGameParametersWithEmail:(NSString *)accountEmail
                                      deviceId:(NSString *)deviceId
                                gameParamsDict:(NSMutableDictionary *)gameParams
                             completionHandler:(GameParametersCompletionHandler)handler;

#pragma mark - Powerups

- (void)requestToUpdateAccountPowerUpsWithAccountEmail:(NSString *)email
                                              deviceId:(NSString *)deviceId
                                          powerupsDict:(NSMutableDictionary *)powerupsDict
                                     completionHandler:(UpdatedAccountCompletionHandler)handler;

#pragma mark - Boosters

- (void)requestToUpdateAccountBoostersWithAccountEmail:(NSString *)email
                                              deviceId:(NSString *)deviceId
                                          boostersDict:(NSMutableDictionary *)boostersDict
                                     completionHandler:(UpdatedAccountCompletionHandler)handler;

#pragma mark - Friends

- (void)requestFriends:(NSMutableArray *)friendsIdArray completionHandler:(FriendsCompletionHandler)handler;

#pragma mark - Leaderboard

- (void)requestLevelLeaderboardWithFacebookId:(NSString *)playerId
                               friendsIdArray:(NSMutableArray *)friendsIdArray
                                      world:(NSNumber *)world
                                      level:(NSNumber *)level
                          completionHandler:(LeaderboardCompletionHandler)handler;

#pragma mark - Gifts

- (void)requestToGiftFriendWithAccountEmail:(NSString *)sender
                                friendEmail:(NSString *)recipient
                                   giftType:(NSString *)command
                                 giftAmount:(NSString *)value
                               giftCostType:(NSString *)giftCostType
                              giftCostValue:(NSNumber *)giftCostValue
                             giftingMessage:(NSString *)message
                          completionHandler:(GiftsCompletionHandler)handler;

#pragma mark - Notifications

- (void)requestToShowNotificationsWithAccountId:(NSString *)accountId
                              completionHandler:(NotificationsCompletionHandler)handler;

- (void)requestToRemoveNotificationsWithAccountId:(NSString *)accountId
                                  notificationIds:(NSMutableArray *)notificationIds
                                completionHandler:(NotificationsCompletionHandler)handler;
@end
