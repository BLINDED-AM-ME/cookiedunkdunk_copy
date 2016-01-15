//
//  CDPlanetoidObject.h
//  CookieDD
//
//  Created by Josh on 10/24/13.
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

#import "MapTriggerObject.h"

@interface CDPlanetoidObject : MapTriggerObject

// This is a dictionary of all the levels in this specific area.
//@property (strong, nonatomic) NSArray *levelsArray;

@property (strong, nonatomic) NSDictionary *propertiesDict;

@property (strong, nonatomic) NSArray *bubbleCoords;
@property (strong, nonatomic) NSArray *bubbleScales;
@property (strong, nonatomic) NSArray *friendImageOrientations;

@property (strong, nonatomic) NSString *minigameName;
@property (strong, nonatomic) NSNumber *minigameStartPoint;

@property (strong, nonatomic) UIImageView *planetImageView;
@property (strong, nonatomic) UIImageView *lockImageView;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSNumber *planetID;
@property (assign, nonatomic) BOOL isUnlocked;

@property (assign, nonatomic) CGPoint atmosphereOffset;

// Morph variables.
@property (assign, nonatomic) float morphScaleMin;
@property (assign, nonatomic) float morphScaleMax;
@property (assign, nonatomic) float morphScaleLimit;
@property (assign, nonatomic) float morphMargin;
@property (assign, nonatomic) float morphSpeed;
@property (assign, nonatomic) BOOL willMorphBubble;

- (void)setPropertiesFromDictionary:(NSDictionary*)propertiesDict;
- (void)setActive;
- (void)setInactive;
- (void)morphBubble:(CALayer *)layer;
- (void)startMorphBubble;
- (void)endMorphBubble;

@end