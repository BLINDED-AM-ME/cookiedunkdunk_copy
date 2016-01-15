//
//  CDMainMenuScene.h
//  CookieDD
//
//  Created by gary johnston on 10/29/13.
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

@protocol CDMainMenuSceneDelegate;


@interface CDMainMenuScene : SKScene <SKPhysicsContactDelegate>

@property (weak, nonatomic) id<CDMainMenuSceneDelegate> delegate;
@property (strong, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) SKNode *allFather; // this will always be in the center of the screen

@property (assign, nonatomic) int whichCookie; // 1 = play, 2 = social

- (void)Rotate_to_Landscape:(float)duration;
- (void)Rotate_to_Portrait:(float)duration;
- (void)putTheCookiesInTheWrappers;
- (void)removeCookies;

@end


@protocol CDMainMenuSceneDelegate <NSObject>

@optional
- (void)didDunkACookie:(BOOL)hitPlayButton;

@end