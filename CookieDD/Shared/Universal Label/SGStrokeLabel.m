//
//  SGBorderLabel.m
//  TextStrokeTest
//
//  Created by Josh on 1/24/14.
//  Copyright (c) 2014 Josh. All rights reserved.
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

#import "SGStrokeLabel.h"

@implementation SGStrokeLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        // Default values.
        self.strokeColor = [UIColor blackColor];
        self.strokeWidth = 3;
    }
    return self;
}


#pragma mark - Custom

- (void)setStrokeColor:(UIColor *)strokeColor AndStrokeWidth:(int)strokeWidth {
    self.strokeColor = strokeColor;
    self.strokeWidth = strokeWidth;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (void)setStrokeWidth:(int)strokeWidth {
    _strokeWidth = strokeWidth;
    [self setNeedsDisplay];
}


#pragma mark - Draw

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    // Get a shrinkwrapped rect around the label's text.
//    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
//    CGRect textRect = CGRectMake((rect.size.width - size.width)/2,(rect.size.height - size.height)/2, size.width, size.height);
//
//    // Create the attributes dictionary we'll use when drawing.
//    NSDictionary *textAttributes = @{ NSFontAttributeName: self.font,
//                                      NSStrokeColorAttributeName: self.borderColor,
//                                      NSStrokeWidthAttributeName: self.borderWidth
//                                      };
//    
//    // Draw the text outline.
//    [self.text drawInRect:textRect withAttributes:textAttributes];
//}




- (void)drawTextInRect:(CGRect)rect {
    
    // Don't draw anything if there's no text.
    if (!self.text || [self.text isEqualToString:@""]) {
        return;
    }
    
    // We'll be needing these.
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw the base text so we get the shadow
    [super drawTextInRect:rect];
    
    // Now hide the shadow, so we don't stroke around it as well.
    self.shadowOffset = CGSizeMake(0, 0);
    
    // Outline width.
    CGContextSetLineWidth(context, self.strokeWidth);
    
    // Set and draw the stroke.
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    self.textColor = self.strokeColor;
    [super drawTextInRect:rect];
    
    // Redraw the text over the stroke to create a 'stroke outside' effect.
    CGContextSetTextDrawingMode(context, kCGTextFill);
    self.textColor = textColor;
    //[[UIColor clearColor] setStroke]; // Fixes off-center stroke. // No it doesn't.
    [super drawTextInRect:rect];
    
    // Reset the shadow values.
    self.shadowOffset = shadowOffset;
    
}


// This is good stuff to keep.
/*
- (void)drawTextInRect:(CGRect)rect {
    CGSize shadowOffset = self.shadowOffset;
    self.shadowOffset = CGSizeMake(0, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextRef originalContext = context;
    
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    // Draw the text without an outline
    [super drawTextInRect:rect];
    
    CGImageRef alphaMask = NULL;
    
    // I'm gonna hang on to this in case we want to use it.
    // Draw the gradient.
    if (false) {
        
        // Create a mask from the text
        alphaMask = CGBitmapContextCreateImage(context);
        
        // clear the image
        CGContextClearRect(context, rect);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, rect.size.height);
        
        // invert everything because CoreGraphics works with an inverted coordinate system
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // Clip the current context to our alphaMask
        CGContextClipToMask(context, rect, alphaMask);
        
        // Create the gradient with these colors
        CGFloat colors [] = {
            255.0f/255.0f, 255.0f/255.0f, 0.0f/255.0f, 1.0,
            255.0f/255.0f, 0.0f/255.0f, 230.0f/255.0f, 1.0
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        // Draw the gradient
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
        
        // Clean up because ARC doesnt handle CG
        CGImageRelease(alphaMask);
    }
    
    // Draw the stroke.
    if (self.strokeWidth > 0) {
        
        // Create a mask from the text (with the gradient)
        alphaMask = CGBitmapContextCreateImage(context);
        
        // Draw everything real quick to get the shadow.
        self.shadowOffset = shadowOffset;
        [super drawTextInRect:rect];
        self.shadowOffset = CGSizeMake(0, 0);
        
        // Outline width
        CGContextSetLineWidth(context, self.strokeWidth);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        // Set the drawing method to stroke
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        
        // Outline color
        self.textColor = self.strokeColor;
        
        // notice the +1 for the y-coordinate. this is to account for the face that the outline appears to be thicker on top
        [super drawTextInRect:rect];
        
        // Draw the saved image over the outline
        // and invert everything because CoreGraphics works with an inverted coordinate system
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, rect, alphaMask);
        
        // Clean up because ARC doesnt handle CG
        CGImageRelease(alphaMask);
    }
    
    self.shadowOffset = shadowOffset;
}
*/


@end
