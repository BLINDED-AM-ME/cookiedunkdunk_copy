//
//  SGGalaxyObject.m
//  CookieDD
//
//  Created by Josh on 11/22/13.
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

#import "SGGalaxyObject.h"

@implementation SGGalaxyObject

#pragma mark - Init

- (id)initWithImageNamed:(NSString *)backgroundImageString {
    self = [super initWithImageNamed:backgroundImageString];
    if (self) {
        [self createSpinAnimation];
    }
    return self;
}

- (id)initWithImageNamed:(NSString *)backgroundImageString AndPosition:(CGPoint)position {
    self = [super initWithImageNamed:backgroundImageString AndPosition:position];
    if (self) {
        [self createSpinAnimation];
    }
    return self;
}

- (void)createSpinAnimation {
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 50.0f;
    animation.repeatCount = HUGE_VAL;
    [self.layer addAnimation:animation forKey:@"BaseRotateAnimation"];
}

@end
