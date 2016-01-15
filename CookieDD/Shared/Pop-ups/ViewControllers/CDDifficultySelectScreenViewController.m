//
//  CDDifficultySelectScreenViewController.m
//  CookieDD
//
//  Created by gary johnston on 12/16/13.
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

#import "CDDifficultySelectScreenViewController.h"

@interface CDDifficultySelectScreenViewController ()


@end

@implementation CDDifficultySelectScreenViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_bestScoreLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_bestScoreLabelLandscape setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    
    [_easyButton.titleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_easyButtonLandscape.titleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_mediumButton.titleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_mediumButtonLandscape.titleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_hardButton.titleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_hardButtonLandscape.titleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_crazyButton.titleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_crazyButtonLandscape.titleLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
}
- (IBAction)easyButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(difficultyHasBeenSelectedWithDifficulty:)])
    {
        [self.delegate difficultyHasBeenSelectedWithDifficulty:1];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)mediumButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(difficultyHasBeenSelectedWithDifficulty:)])
    {
        [self.delegate difficultyHasBeenSelectedWithDifficulty:2];
    }
    [self.view removeFromSuperview];
}

- (IBAction)hardButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(difficultyHasBeenSelectedWithDifficulty:)])
    {
        [self.delegate difficultyHasBeenSelectedWithDifficulty:3];
    }
    [self.view removeFromSuperview];
}

- (IBAction)crazyButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(difficultyHasBeenSelectedWithDifficulty:)])
    {
        [self.delegate difficultyHasBeenSelectedWithDifficulty:4];
    }
    [self.view removeFromSuperview];
}

- (IBAction)menuButtonHit:(id)sender
{
    
}

- (IBAction)shopButtonHit:(id)sender
{
    
}

- (IBAction)exitButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(exitButtonWasHit)])
    {
        [self.delegate exitButtonWasHit];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
