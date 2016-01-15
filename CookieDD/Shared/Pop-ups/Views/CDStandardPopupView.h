//
//  CDStandardPopupView.h
//  CookieDD
//
//  Created by gary johnston on 3/20/14.
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

@protocol CDStandardPopupViewDelegate;



@interface CDStandardPopupView : UIView

@property (weak, nonatomic) id<CDStandardPopupViewDelegate> delegate;

//TODO: Rename the "HOW TO PLAY" labelss during cleanup so that they match....
// Universal
@property (weak, nonatomic) IBOutlet UIView *fadeView;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *backTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *nextTextLabel;

@property (strong, nonatomic) NSString *whatAmILoading;


// Leaderboards
@property (weak, nonatomic) IBOutlet UIView *leaderboardView;
@property (weak, nonatomic) IBOutlet UIButton *gameCenterButton;

// Help Screens

// Main Game Help Screen 1

@property (weak, nonatomic) IBOutlet UIView *mainGameHelpScreen1View;

@property (weak, nonatomic) IBOutlet UIImageView *handPointerImage;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *howToPlayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainGameHelpScreen1DescriptionLabel;

// Main Game Help Screen 2
@property (weak, nonatomic) IBOutlet UIView *mainGameHelpScreen2View;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *howToPlayText2;
@property (weak, nonatomic) IBOutlet UILabel *mainGameHelpScreen2DescriptionLabel;

// Main Game Help Screen 3
@property (weak, nonatomic) IBOutlet UIView *mainGameHelpScreen3View;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *howToPlay3;
@property (weak, nonatomic) IBOutlet UILabel *mainGameHelpScreen3DescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tryItOutTextLabel;

// Cookie Cooker Help Screen 1
@property (weak, nonatomic) IBOutlet UIView *cookieCookerHelpScreen1View;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *cookieCookerHelpScreen1HowToPlay;
@property (weak, nonatomic) IBOutlet UILabel *cookieCookerHelpScreen1Description;
@property (weak, nonatomic) IBOutlet UIImageView *cookieCookerHelpScreen1Image;

// Cookie Cooker Help Screen 2
@property (weak, nonatomic) IBOutlet UIView *cookieCookerHelpScreen2View;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *cookieCookerHelpScreen2HowToPlay;
@property (weak, nonatomic) IBOutlet UILabel *cookieCookerHelpScreen2Description;
@property (weak, nonatomic) IBOutlet UIImageView *cookieCookerHelpScreen2Image;

// Cookie Cooker Help Screen 3
@property (weak, nonatomic) IBOutlet UIView *cookieCookerHelpScreen3View;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *cookieCookerHelpScreen3HowToPlay;
@property (weak, nonatomic) IBOutlet UILabel *cookieCookerHelpScreen3Description;
@property (weak, nonatomic) IBOutlet UIImageView *cookieCookerHelpScreen3Image;

// Cookie Drop Help Screen 1
@property (weak, nonatomic) IBOutlet UIView *cookieDropHelpScreen1View;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *cookieDropHelpScreen1HowToPlay;
@property (weak, nonatomic) IBOutlet UILabel *cookieDropHelpScreen1Description;
@property (weak, nonatomic) IBOutlet UIImageView *cookieDropHelpScreen1Image;

// Cow Abduction
@property (weak, nonatomic) IBOutlet UIView *abductionMinigameHelpScreenView;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *abductionMinigameSceenHowToPlay;
@property (weak, nonatomic) IBOutlet UIImageView *abductionMinigameImage;
@property (weak, nonatomic) IBOutlet UILabel *abductionMinigameDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *abductionMinigameDescription2Label;

- (void)setup;
- (void)setFadeViewToTransparent:(BOOL)isTransparent;

- (IBAction)nextButtonHit:(id)sender;
- (IBAction)backButtonHit:(id)sender;

- (IBAction)exitButtonHit:(id)sender;
- (IBAction)gameCenterButtonHit:(id)sender;

@end



@protocol CDStandardPopupViewDelegate <NSObject>

@required
- (void)exitButtonWasHitOnStandardPopupView:(CDStandardPopupView *)standardPopup;

@end