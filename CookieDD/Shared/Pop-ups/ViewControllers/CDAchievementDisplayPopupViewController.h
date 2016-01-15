//
//  CDAchievementDisplayPopupViewController.h
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

#import <UIKit/UIKit.h>

@protocol CDAchievementDisplayPopupViewControllerDelegate;



@interface CDAchievementDisplayPopupViewController : UIViewController

@property (weak, nonatomic) id<CDAchievementDisplayPopupViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *faderView;

@property (weak, nonatomic) IBOutlet UIImageView *achievementImage;
@property (weak, nonatomic) IBOutlet UIImageView *upperGlimmerImage;
@property (weak, nonatomic) IBOutlet UIImageView *lowerGlimmerImage;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *achievementNameLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *okTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *achievementDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

- (IBAction)okButtonHit:(id)sender;

@end



@protocol CDAchievementDisplayPopupViewControllerDelegate <NSObject>

@required
- (void)okButtonWasHitOnAchievementViewController:(CDAchievementDisplayPopupViewController *)achievementViewController;

@end