//
//  SGLevelSelectCell.m
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

#import "SGLevelSelectCell.h"

@implementation SGLevelSelectCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setStarLevel:(int)starLevel {
    _starLevel = starLevel;
    
    if (starLevel >= 1) {
        self.star1ImageView.hidden = NO;
    } else {
        self.star1ImageView.hidden = YES;
    }
    
    if (starLevel >= 2) {
        self.star2ImageView.hidden = NO;
    } else {
        self.star2ImageView.hidden = YES;
    }
    
    if (starLevel >= 3) {
        self.star3ImageView.hidden = NO;
    } else {
        self.star3ImageView.hidden = YES;
    }
}

- (void)setIsUnlocked:(BOOL)isUnlocked {
    _isUnlocked = isUnlocked;
    
    if (isUnlocked) {
        [self setUnlocked];
    } else {
        [self setLocked];
    }
}

- (void)setLocked {
    self.lockImageView.hidden = NO;
    [self.backgroundImageView setImage:[UIImage imageNamed:@"cdd-hud-lvl-level-locked"]];
}

- (void)setUnlocked {
    self.lockImageView.hidden = YES;
    [self.backgroundImageView setImage:[UIImage imageNamed:@"cdd-hud-lvl-level-unlocked"]];
}

- (void)changeLockedTo:(BOOL)isUnlocked {
    if (isUnlocked) {
        [self setUnlocked];
    } else {
        [self setLocked];
    }
}

- (void)setLevelNumber:(int)levelNumber {
    self.levelID = levelNumber-1; // (Programmers count from zero.)
    NSString *levelNumberString = [NSString stringWithFormat:@"%i", levelNumber];
    [self.levelNumberLabel setText:levelNumberString];
}





@end
