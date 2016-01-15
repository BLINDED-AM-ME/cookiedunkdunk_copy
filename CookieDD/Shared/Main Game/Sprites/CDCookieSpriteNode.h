//
//  CDCookieSpriteNode.h
//  CookieDD
//
//  Created by Luke McDonald on 11/12/13.
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
#import "CDGameBoardSpriteNode.h"
#import "CDCookieFaceSpriteNode.h"
#import "CDBlockerSpriteNode.h"

typedef enum ParticleDeletionType
{
    ParticleDeletionType_MILK,
    ParticleDeletionType_ASH
    
}   ParticleDeletionType;

@interface CDCookieSpriteNode : CDGameBoardSpriteNode


-(id)initCookie;

@property (strong, nonatomic) CDCookieFaceSpriteNode* faceSprite;

@end