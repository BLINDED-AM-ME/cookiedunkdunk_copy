//
//  CDMainGameLabelNode.h
//  CookieDD
//
//  Created by Luke McDonald on 2/8/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//
// NOTE
// USEFULL SITES ON SKLABEL NODE
// http://stackoverflow.com/questions/19719367/colorizewithcolor-and-sklabelnode

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

typedef enum MainGameLabelType
{
    MainGameLabelType_Default,
    
    MainGameLabelType_Score,
    
    MainGameLabelType_Time,
    
    MainGameLabelType_Moves,
    
    MainGameLabelType_TargetGoal,
    
    MainGameLabelType_ComboEasyBake,
    
    MainGameLabelType_ComboHalfBaked,
    
    MainGameLabelType_ComboFullyBaked,
    
    MainGameLabelType_ComboSuperUltraCookieComboBreaker
    
} MainGameLabelType;

@interface CDMainGameLabelNode : SKLabelNode

#pragma mark - Initialization

- (id)initLabelWithFontName:(NSString *)fontName
                  fontColor:(UIColor *)fontColor
                strokeColor:(UIColor *)strokeColor
                   fontSize:(CGFloat)fontSize
                      scene:(SKScene *)scene
                   position:(CGPoint)position
                  labelType:(MainGameLabelType)labelType;

@end
