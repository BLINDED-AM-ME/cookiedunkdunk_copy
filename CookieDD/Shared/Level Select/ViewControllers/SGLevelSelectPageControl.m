//
//  SGLevelSelectPageControl.m
//  CookieDD
//
//  Created by Josh on 10/28/13.
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

#import "SGLevelSelectPageControl.h"

@interface SGLevelSelectPageControl()

@property (strong, nonatomic) UIImage *activePageImage;
@property (strong, nonatomic) UIImage *inactivePageImage;

@end

@implementation SGLevelSelectPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup {
    self.activePageImage = [UIImage imageNamed:@"cdd-hud-lvl-page-active"];
    self.inactivePageImage = [UIImage imageNamed:@"cdd-hud-lvl-page-base"];
}

- (void)updateDots {
    for (int count = 0; count < [self.subviews count]; count++) {
        //DebugLog(@"currentPage: %i", self.currentPage);
        UIImageView *dot = [self imageViewForSubview:[self.subviews objectAtIndex:count]];
        if (count == self.currentPage) {
            [dot setImage:self.activePageImage];
        } else {
            [dot setImage:self.inactivePageImage];
        }
    }
}

// iOS 7 and iOS 6 have different structures to their views, meaning we have to search for the dot imageviews.
//   -In iOS6, the dots are direct subviews of the page control view.
//   -In iOS7, the dots are subviews of subviews (that's two layers deep) of the page control view.
- (UIImageView *)imageViewForSubview:(UIView *)view {
    UIImageView *dot = nil;
    
    // Check if we're dealing with iOS 6 or 7.
    // (It's iOS7 if the subview here is just a UIView, otherwise it's iOS6.)
    if ([view isKindOfClass:[UIView class]]) {
        // Try to find an existing UIImageView.
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                //DebugLog(@"Found One!");
                dot = (UIImageView *)subview;
                break;
            }
        }
        // If no image views were found, then we'll make our own.
        if (dot == nil) {
            //DebugLog(@"Making a new dot.");
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else {
        //DebugLog(@"Sweet!  iOS 6!");
        dot = (UIImageView *)view;
    }
    
    return dot;
}

#pragma mark - Page Control Methods

- (void)setCurrentPage:(NSInteger)currentPage {
    //DebugLog(@"Current Page: %i", currentPage);
    [super setCurrentPage:currentPage];
    [self updateDots];
}



@end
