//
//  CDGameBoardSpriteNode.h
//  CookieDD
//
//  Created by Luke McDonald on 1/27/14.
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

#import <SpriteKit/SpriteKit.h>
#import "SGAudioPlayer.h"
#import "CDCommonHelpers.h"

@interface CDGameBoardSpriteNode : SKSpriteNode

#pragma mark - Properties
@property (assign, nonatomic) ItemType typeID;
@property (strong, nonatomic) SKTexture *mainTexture;
@property (assign, nonatomic) BOOL isVulnerable; // for things like the portal to not grab
@property (assign, nonatomic) BOOL isLocked;
@property (assign, nonatomic) BOOL shouldMilkSplash;
@property (assign, nonatomic) int scoreMultiplier;

@property (strong, nonatomic) NSMutableArray* steps;

// Spatula stuff
@property (assign, nonatomic) CGPoint finalTarget;

@property (assign, nonatomic) CGVector fakePhysics;

#pragma mark - index of Object

@property (assign, nonatomic) int column;
@property (assign, nonatomic) int row;


-(void)ShuffleMovement:(int)target_row TargetColumn:(int)target_column;

@end
