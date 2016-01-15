//
//  CDAchievementDisplayPopupViewController.m
//  CookieDD
//
//  Created by gary johnston on 4/18/14.
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

#import "CDAchievementDisplayPopupViewController.h"

@interface CDAchievementDisplayPopupViewController ()

@end

@implementation CDAchievementDisplayPopupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_okTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_okTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    
    [_achievementNameLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
    [_achievementNameLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
    
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         _upperGlimmerImage.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:NULL];
    
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         _lowerGlimmerImage.transform = CGAffineTransformMakeRotation(M_PI_2);
                     }
                     completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DebugLog(@"Memory Warning Has Occurred!!!!");
}


- (IBAction)okButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(okButtonWasHitOnAchievementViewController:)])
    {
        [self.delegate okButtonWasHitOnAchievementViewController:self];
    }
}

@end
