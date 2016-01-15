//
//  CDMainGameLabelNode.m
//  CookieDD
//
//  Created by Luke McDonald on 2/8/14.
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

#import "CDMainGameLabelNode.h"

@implementation CDMainGameLabelNode

#pragma mark - Initialization

- (id)initLabelWithFontName:(NSString *)fontName
                  fontColor:(UIColor *)fontColor
                strokeColor:(UIColor *)strokeColor
                   fontSize:(CGFloat)fontSize
                      scene:(SKScene *)scene
                   position:(CGPoint)position
                  labelType:(MainGameLabelType)labelType
{
    self = [super initWithFontNamed:fontName];
    
    if (self)
    {
        [scene addChild:self];
        
        self.position = position;
        
        self.fontColor = fontColor;
        
        self.fontSize = fontSize;
        
        self.zPosition = 90000;
        
        [self checkLabelType:labelType strokeColor:strokeColor];
    }
    
    
    return self;
}

- (void)checkLabelType:(MainGameLabelType)labelType strokeColor:(UIColor *)strokecolor
{
    switch (labelType)
    {
        case MainGameLabelType_Time:
        {
            self.text = @"Time";
        }
            break;
            
        case MainGameLabelType_Score:
        {
            self.text = @"Score: 0";
        }
            break;
            
        case MainGameLabelType_Moves:
        {
            self.text = @"Moves";
        }
            break;
            
        case MainGameLabelType_ComboEasyBake:
        {
            self.text = @"Easy Bake";
                        
//            self.alpha = 0.0f;
//            
//            self.xScale = 0.2;
//            
//            self.yScale = 0.2;
//            
//            [self runAction:[self comboAnimationAction]];
        }
            break;
            
        case MainGameLabelType_ComboHalfBaked:
        {
            self.text = @"Half Baked";
            
            self.alpha = 0.0f;
            
            self.xScale = 0.2;
            
            self.yScale = 0.2;
            
            [self runAction:[self comboAnimationAction]];
        }
            break;
            
        case MainGameLabelType_ComboFullyBaked:
        {
            self.text = @"Fully Baked";
            
            self.alpha = 0.0f;
            
            self.xScale = 0.2;
            
            self.yScale = 0.2;
            
            [self runAction:[self comboAnimationAction]];
        }
            break;
            
        case MainGameLabelType_ComboSuperUltraCookieComboBreaker:
        {
            self.text = @"Super Ultra Cookie Combo Breaker";
            
//            self.alpha = 0.0f;
//            
//            self.xScale = 0.2;
//            
//            self.yScale = 0.2;
//            
//            [self runAction:[self comboAnimationAction]];

        }
            break;
        
        case MainGameLabelType_TargetGoal:
        {
            self.text = @"Score 200 points";
        }
            break;
            
        default:
            break;
    }
}

- (void)addInnerTextFromStrokeWithFontColor:(UIColor *)fontColor
{
    SKLabelNode *innerLabel = [[SKLabelNode alloc] initWithFontNamed:self.fontName];
    innerLabel.text = self.text;
    innerLabel.fontColor = fontColor;
    innerLabel.fontSize = self.fontSize;
    innerLabel.xScale = 0.8f;
    innerLabel.yScale = 0.8f;
    [self addChild:innerLabel];
}

#pragma mark - Animations & Actions

- (SKAction *)comboAnimationAction
{
    SKAction *comboAnimationAction = nil;
    
    return comboAnimationAction;
}

@end
