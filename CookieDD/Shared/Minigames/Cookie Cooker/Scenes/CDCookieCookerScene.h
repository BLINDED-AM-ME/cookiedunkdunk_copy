//
//  CDCookieJarOperationScene.h
//  CookieDD
//
//  Created by gary johnston on 9/12/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.
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

#import <SpriteKit/SpriteKit.h>
#import "SGAppDelegate.h"

@protocol CDCookieCookerSceneDelegate;


@interface CDCookieCookerScene : SKScene

@property (weak, nonatomic) id <CDCookieCookerSceneDelegate> delegate;

@property (assign, nonatomic) int maxSeconds;
@property (assign, nonatomic) int currentSeconds;
@property (assign, nonatomic) int difficulty;
@property (assign, nonatomic) int cookieCount;

@property (assign, nonatomic) BOOL didClickCookie;

@property (strong, nonatomic) NSMutableArray *cookieArray;
@property (strong, nonatomic) NSMutableArray *respawnPointArray;

//- (void)stopBackGroundMusic;
- (void)startMiniGame;
- (void)setup;
- (void)PlayTheBurningSound;
- (void)ScreamForMe;
- (void)deathPoof;
- (void)volumeWasTurnedOn;
- (void)volumeWasTurnedOff;

@end


@protocol CDCookieCookerSceneDelegate <NSObject>

@optional
- (void)cookieCookerSceneDidEndScene:(CDCookieCookerScene *)scene WithScore:(int)score WithGoalScore:(int)goalScore WithWin:(BOOL)didWin;
- (void)cookieCookerWillPresentDifficultyScreen:(CDCookieCookerScene *)scene;

@end
