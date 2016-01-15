//
//  SGLabelNode.m
//  CookieDD
//
//  Created by Josh on 4/18/14.
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

#import "SGLabelNode.h"

@implementation SGLabelNode

-(id)initWithFontNamed:(NSString *)fontName {
    self = [super init];
    if (self) {
        
        
        _shadowLabel = [[SKLabelNode alloc] initWithFontNamed:fontName];
        _shadowOffset = CGPointMake(1.0f, -2.0f);
        _shadowLabel.position = _shadowOffset;
        _shadowLabel.fontColor = [UIColor colorWithRed:0.003 green:0.040 blue:0.056 alpha:0.870];
        [self addChild:_shadowLabel];
        
        _textLabel = [[SKLabelNode alloc] initWithFontNamed:fontName];
        [self addChild:_textLabel];
    }
    return self;
}

- (void)setFontSize:(float)fontSize {
    _fontSize = fontSize;
    
    _textLabel.fontSize = fontSize;
    _shadowLabel.fontSize = fontSize;
}

- (void)setFontColor:(UIColor *)fontColor {
    _fontColor = fontColor;
    
    _textLabel.fontColor = fontColor;
    // Leave the shadow color alone.
}

- (void)setText:(NSString *)text {
    _text = text;
    
    _textLabel.text = text;
    _shadowLabel.text = text;
}

- (void)setHorizontalAlignment:(SKLabelHorizontalAlignmentMode)horizontalAlignment {
    _horizontalAlignment = horizontalAlignment;
    
    _textLabel.horizontalAlignmentMode = horizontalAlignment;
    _shadowLabel.horizontalAlignmentMode = horizontalAlignment;
}

- (void)setShadowOffset:(CGPoint)shadowOffset {
    _shadowOffset = shadowOffset;
    
    _shadowLabel.position = _shadowOffset;
}

@end
