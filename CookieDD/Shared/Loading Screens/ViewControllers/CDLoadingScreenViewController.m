//
//  CDLoadingScreenViewController.m
//  CookieDD
//
//  Created by gary johnston on 1/6/14.
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

#import "CDLoadingScreenViewController.h"

@interface CDLoadingScreenViewController ()

@end

@implementation CDLoadingScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)createLoadingScreenWithImageName:(NSString *)imageName
{
    self.loadingScreenImage.image = [UIImage imageNamed:imageName];
}

//- (void)startMapMusic
//{
//    NSUserDefaults *musicButtonStateDefault = [NSUserDefaults standardUserDefaults];
//    NSString *musicButtonState = [musicButtonStateDefault objectForKey:MusicButtonStateDefault];
//    
//    //[[SGAudioManager audioManager] playSoundWithName:@"CCDDD_THEME_MIX_Map" withFileType:@"m4a" volume:0.3f numberOfLoops:-1];
//    //[[SGAudioManager audioManager] playBackgroundMusicWithFilename:@"CCDDD_THEME_MIX_Map" FileType:@"m4a" volume:0.3f numberOfLoopes:-1]; // <<< Map Music
//    
//    
////    if ([musicButtonState isEqualToString:@"play"])
////    {
////        [SGAudioManager audioManager].player.volume = [SGAppDelegate appDelegate].masterVolume;
////    }
////    else if ([musicButtonState isEqualToString:@"mute"])
////    {
////        [[SGAudioManager audioManager] muteTheAudioPlayer:YES];
////    }
//}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
