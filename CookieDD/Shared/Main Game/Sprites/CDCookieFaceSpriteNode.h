//
//  CDCookieFaceSpriteNode.h
//  CookieDD
//
//  Created by BLINDED AM ME on 1/31/14.
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

@interface CDCookieFaceSpriteNode : SKSpriteNode

// cookies faces
@property (strong, nonatomic) SKTexture* default_face;

// facial animations

@property (strong, nonatomic) NSArray* Face_crashing;

// neutral

@property (strong, nonatomic) NSArray* Face_lickItself;
@property (strong, nonatomic) NSArray* Face_neutral;
@property (strong, nonatomic) NSArray* Face_relax;
@property (strong, nonatomic) NSArray* Face_tired;
@property (strong, nonatomic) NSArray* Face_breathing;

// positive

@property (strong, nonatomic) NSArray* Face_smile;
@property (strong, nonatomic) NSArray* Face_blushed;
@property (strong, nonatomic) NSArray* Face_goofy;
@property (strong, nonatomic) NSArray* Face_grin;
@property (strong, nonatomic) NSArray* Face_laughing;

// negative

@property (strong, nonatomic) NSArray* Face_angry;
@property (strong, nonatomic) NSArray* Face_worried;
@property (strong, nonatomic) NSArray* Face_crying;
@property (strong, nonatomic) NSArray* Face_scared;

- (void)FallingAnimation;

- (void)RandomAnimation;

- (void)RandomPostiveAnimation;

- (void)RandomNegativeAnimation;

@end
