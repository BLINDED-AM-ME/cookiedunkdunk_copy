//
//  CDViewController.h
//  PushTheButtonTest
//

//  Copyright (c) 2014 gary johnston. All rights reserved.
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
#import <SpriteKit/SpriteKit.h>
#import "SGAppDelegate.h"

@protocol CDMainButtonViewControllerDelegate;



@interface CDMainButtonViewController : UIViewController

@property (weak, nonatomic) id<CDMainButtonViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIView *mainButtonSpinnerView;
@property (weak, nonatomic) IBOutlet UIView *settingsSliderView;
@property (weak, nonatomic) IBOutlet UIView *accountSliderView;
@property (weak, nonatomic) IBOutlet UIView *restoreButtonView;
@property (weak, nonatomic) IBOutlet UIView *faderView;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *volumeButton;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *gameCenterButton;
@property (weak, nonatomic) IBOutlet UIButton *achievementButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *restoreTextLabel;

@property (weak, nonatomic) IBOutlet UIImageView *settingsSliderImage;
@property (weak, nonatomic) IBOutlet UIImageView *accountSliderImage;

@property (assign, nonatomic) CGRect parentViewFrame;
@property (assign, nonatomic) CGRect conditionalViewFrame;

@property (assign, nonatomic) BOOL popupIsUp;
@property (assign, nonatomic) BOOL mainButtonIsDown;

+ (CDMainButtonViewController *)mainButton;
- (CDMainButtonViewController *)didCreateMainButtonViewWithParentalViewController:(UIViewController *)parentViewController;

- (void)orientationHasChanged:(UIInterfaceOrientation)toInterfaceOrientation WithDuration:(NSTimeInterval)duration;
- (void)enableButtons:(BOOL)isEnabled;

- (IBAction)gameCenterButtonHit:(id)sender;

- (IBAction)achievementButtonHit:(id)sender;
- (IBAction)shopButtonHit:(id)sender;
- (IBAction)accountButtonHit:(id)sender;
- (IBAction)mainButtonHit:(id)sender;
- (IBAction)facebookButtonHit:(id)sender;
- (IBAction)volumeButtonHit:(id)sender;
- (IBAction)soundButtonHit:(id)sender;
- (IBAction)settingsButtonHit:(id)sender;
- (IBAction)helpButtonHit:(id)sender;
- (IBAction)twitterButtonHit:(id)sender;
- (IBAction)googleButtonHit:(id)sender;
- (IBAction)backButtonHit:(id)sender;
- (IBAction)restoreButtonHit:(id)sender;

@end



@protocol CDMainButtonViewControllerDelegate <NSObject>

@optional
- (void)mainButtonIsGoingDown;

@required
- (void)mainButtonIsAnimatingAndWillDisableInteraction:(BOOL)willDisableInteraction;
- (void)mainButtonSubButtonWasHitWithIndex:(int)buttonIndex;

@end