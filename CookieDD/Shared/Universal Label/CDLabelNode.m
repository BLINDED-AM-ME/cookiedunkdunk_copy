//
//  CDLabelNode.m
//  CookieDD
//
//  Created by Josh on 2/12/14.
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

#import "CDLabelNode.h"

@implementation CDLabelNode

#pragma mark - Init Methods
// Because Luke and Gary love these things.

- (id)initWithFontNamed:(NSString *)fontName
               fontSize:(CGFloat)fontSize {
    
    self = [super initWithFontNamed:fontName];
    if (self) {
        [self setFontSize:fontSize];
    }
    return self;
}

- (id)initWithFontNamed:(NSString *)fontName
               fontSize:(CGFloat)fontSize
               position:(CGPoint)position {
    
    self = [self initWithFontNamed:fontName fontSize:fontSize];
    if (self) {
        [self setPosition:position];
    }
    return self;
}

- (id)initWithFontNamed:(NSString *)fontName
               fontSize:(CGFloat)fontSize
               position:(CGPoint)position
    horizontalAlignment:(SKLabelHorizontalAlignmentMode)horizontalAlignmentMode {
    
    self = [self initWithFontNamed:fontName fontSize:fontSize position:position];
    if (self) {
        [self setHorizontalAlignmentMode:horizontalAlignmentMode];
    }
    return self;
}

- (id)initWithFontNamed:(NSString *)fontName
               fontSize:(CGFloat)fontSize
               position:(CGPoint)position
            strokeColor:(UIColor *)strokeColor
            strokeWidth:(CGFloat)strokeWidth {
    
    self = [self initWithFontNamed:fontName fontSize:fontSize position:position];
    if (self) {
        [self setStrokeColor:strokeColor];
        [self setStrokeWidth:strokeWidth];
    }
    return self;
}

- (id)initWithFontNamed:(NSString *)fontName
               fontSize:(CGFloat)fontSize
               position:(CGPoint)position
            strokeColor:(UIColor *)strokeColor
            strokeWidth:(CGFloat)strokeWidth
    horizontalAlignment:(SKLabelHorizontalAlignmentMode)horizontalAlignmentMode {
    
    self = [self initWithFontNamed:fontName fontSize:fontSize position:position strokeColor:strokeColor strokeWidth:strokeWidth];
    if (self) {
        [self setHorizontalAlignmentMode:horizontalAlignmentMode];
    }
    return self;
}





@end
