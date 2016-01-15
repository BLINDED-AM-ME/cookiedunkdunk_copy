//
//  CDDifficultySelectScreenViewController.h
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

#import <UIKit/UIKit.h>
#import "CDLoadingScreenViewController.h"

@protocol CDDifficultySelectScreenViewControllerDelegate;


@interface CDDifficultySelectScreenViewController : UIViewController

@property (weak, nonatomic) id<CDDifficultySelectScreenViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *miniGameNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *easyButton;
@property (weak, nonatomic) IBOutlet UIButton *mediumButton;
@property (weak, nonatomic) IBOutlet UIButton *hardButton;
@property (weak, nonatomic) IBOutlet UIView *portraitView;
@property (weak, nonatomic) IBOutlet UIView *landscapeView;
@property (weak, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *crazyButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UILabel *bestScoreLabelLandscape;
@property (weak, nonatomic) IBOutlet UIButton *exitButtonLandscape;
@property (weak, nonatomic) IBOutlet UIButton *shopButtonLandscape;
@property (weak, nonatomic) IBOutlet UIButton *menuButtonLandscape;
@property (weak, nonatomic) IBOutlet UIButton *mediumButtonLandscape;
@property (weak, nonatomic) IBOutlet UIButton *easyButtonLandscape;
@property (weak, nonatomic) IBOutlet UIButton *hardButtonLandscape;
@property (weak, nonatomic) IBOutlet UIButton *crazyButtonLandscape;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UIButton *easyButtonLandscapeIphone5;
@property (weak, nonatomic) IBOutlet UIButton *hardButtonLandscapeIphone5;
@property (weak, nonatomic) IBOutlet UIButton *crazyButtonLandscapeIphone5;
@property (weak, nonatomic) IBOutlet UIButton *mediumButtonLandscapeIphone5;
@property (weak, nonatomic) IBOutlet UIButton *shopButtonLandscapeIphone5;
@property (weak, nonatomic) IBOutlet UIButton *menuButtonLandscapeIphone5;

- (IBAction)easyButtonHit:(id)sender;
- (IBAction)mediumButtonHit:(id)sender;
- (IBAction)hardButtonHit:(id)sender;
- (IBAction)menuButtonHit:(id)sender;
- (IBAction)shopButtonHit:(id)sender;
- (IBAction)crazyButtonHit:(id)sender;
- (IBAction)exitButtonHit:(id)sender;

@end

@protocol CDDifficultySelectScreenViewControllerDelegate <NSObject>

@required
- (void)difficultyHasBeenSelectedWithDifficulty:(int)difficulty;
- (void)exitButtonWasHit;

@end