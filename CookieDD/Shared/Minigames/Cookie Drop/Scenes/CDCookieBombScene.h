//
//  CDCookieBombScene.h
//  CookieDD
//
//  Created by Gary Johnston on 7/20/13.
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


@protocol CDCookieBombSceneDelegate;


@interface CDCookieBombScene : SKScene

@property (strong, nonatomic) SKSpriteNode *towerObject;
@property (strong, nonatomic) SKSpriteNode *cupFrontObject;
@property (strong, nonatomic) SKSpriteNode *cupMiddleObject;
@property (strong, nonatomic) SKSpriteNode *cupBackObject;
@property (strong, nonatomic) SKSpriteNode *cupSideRightObject;
@property (strong, nonatomic) SKSpriteNode *cupSideLeftObject;

@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (weak, nonatomic) id<CDCookieBombSceneDelegate> delegate;

@property (assign, nonatomic) int maxSeconds;
@property (assign, nonatomic) int currentSeconds;
@property (assign, nonatomic) int difficulty;

@property (assign, nonatomic) BOOL canMoveCup;

- (void)stopBackgroundMusic;
- (void)startMiniGame;
- (void)setup;
- (void)playThrowSound:(SKSpriteNode*)cookie;
- (void)Shut_The_Cookies_up;

@end


@protocol CDCookieBombSceneDelegate <NSObject>

@optional
- (void)cookieBombSceneDidEnd:(CDCookieBombScene *)scene WithScore:(int)score WithGoalScore:(int)goalScore WithWin:(BOOL)didWin;
- (void)cookieBombDifficultySelect:(CDCookieBombScene *)scene;

@end