//
//  SGStoreLoadScreenViewController.m
//  CookieDD
//
//  Created by Luke McDonald on 3/12/14.
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

#import "SGStoreLoadScreenViewController.h"

@interface SGStoreLoadScreenViewController ()

@end

@implementation SGStoreLoadScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self placeDoors];
    
    // Play the store theme music.
    //[[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"ElevatorThemeCDD2" FileType:@"m4a" volume:1.0f numberOfLoopes:-1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Orientation


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        return UIInterfaceOrientationLandscapeRight;
    }
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)placeDoors {
    CGPoint masterMidpoint = CGPointMake(CGRectGetMidY(self.view.frame), CGRectGetMidX(self.view.frame));
    CGRect doorRect;
    
    doorRect = self.rightDoorImageView.frame;
    doorRect.origin = CGPointMake(IS_IPHONE_5? 36.0f : 80.0f, 0.0f);  // 560: 36.0f ; 480: 80.0f
    self.rightDoorImageView.frame = doorRect;
    
    doorRect = self.leftDoorImageView.frame;
    doorRect.origin = CGPointMake(masterMidpoint.x - doorRect.size.width, 0.0f);
    self.leftDoorImageView.frame = doorRect;
    
    DebugLog(@"Done.");
}


@end
