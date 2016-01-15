//
//  CDTravelDot.m
//  CookieDD
//
//  Created by Josh on 4/4/14.
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

#import "CDTravelDot.h"

@interface CDTravelDot()

@property (strong, nonatomic) NSArray *framesArray;

@end

@implementation CDTravelDot

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithDefaultImageNamed:(NSString *)defaultImageName activeImageNamed:(NSString *)activeImageName position:(CGPoint)position strobeDuration:(float)strobeDuration {
    self = [super initWithImageNamed:defaultImageName AndPosition:position];
    if (self) {
        
        self.backgroundImageView.contentMode = UIViewContentModeCenter;
        
        _activeImage = [UIImage imageNamed:activeImageName];
        _inactiveImage = [UIImage imageNamed:defaultImageName];
        
        _strobeDuration = strobeDuration;
        
        [self createStrobeFrames];
        
        _isEnabled = NO;
    }
    return self;
}

- (void)createStrobeFrames {
    _framesArray = [NSArray arrayWithObjects:_activeImage, _activeImage, _inactiveImage, _inactiveImage, _inactiveImage, _inactiveImage, _inactiveImage, nil];
}


#pragma mark - Custom Updates

- (void)setIsEnabled:(BOOL)isEnabled {
    _isEnabled = isEnabled;
    
    if (isEnabled) {
        [self activateStrobe];
    }
    else {
        [self deactivateStrobe];
    }
}

- (void)setStrobeImageView:(UIImageView *)strobeImageView {
    self.strobeImageView = strobeImageView;
    [self createStrobeFrames];
}


#pragma mark - Lights On/Off

- (void)activateStrobe {
    _isEnabled = YES;
    
    [self performSelector:@selector(beginAnimation) withObject:nil afterDelay:fmod(_strobeDelay, (float)_framesArray.count) inModes:@[NSRunLoopCommonModes]];
    
}

// Pulled this out to get the delay from performSelector.
- (void)beginAnimation {
    self.backgroundImageView.animationImages = _framesArray;
    self.backgroundImageView.animationDuration = _strobeDuration;
    self.backgroundImageView.animationRepeatCount = INFINITY;
    [self.backgroundImageView startAnimating];
}

- (void)deactivateStrobe {
    _isEnabled = NO;
    [self.backgroundImageView stopAnimating];
}


@end
