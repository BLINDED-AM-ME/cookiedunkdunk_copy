//
//  CDMiniGamePopupView.h
//  CookieDD
//
//  Created by gary johnston on 3/6/14.
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
#import "SGAppDelegate.h"

@protocol CDMiniGamePopupViewDelegate;


@interface CDMiniGamePopupView : UIView

@property (weak, nonatomic) id<CDMiniGamePopupViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *fadeView;

@property (strong, nonatomic) UIViewController *parentalViewController;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *bestScoreLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *facebookTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *winLoseTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *scoreLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *easyTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *mediumTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *hardTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *crazyTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *menuTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *replayTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *gameNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *mediumButton;
@property (weak, nonatomic) IBOutlet UIButton *easyButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *crazyButton;
@property (weak, nonatomic) IBOutlet UIButton *hardButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (weak, nonatomic) IBOutlet UIImageView *cookieIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *scoreDisplayImage;

@property (strong, nonatomic) NSString *minigameName;
@property (assign, nonatomic) int score;


- (IBAction)exitButtonHit:(id)sender;

- (IBAction)easyButtonHit:(id)sender;
- (IBAction)mediumButtonHit:(id)sender;
- (IBAction)hardButtonHit:(id)sender;
- (IBAction)crazyButtonHit:(id)sender;

- (IBAction)menuButtonHit:(id)sender;
- (IBAction)shopButtonHit:(id)sender;
- (IBAction)replayButtonHit:(id)sender;
- (IBAction)helpButtonHit:(id)sender;

- (IBAction)facebookButtonHit:(id)sender;

- (void)setup;
//- (void)checkAndSetTransparency:(BOOL)isTransparent;

@end



@protocol CDMiniGamePopupViewDelegate <NSObject>

@required
- (void)helpButtonWasHitOnMiniGamePopupView:(BOOL)isOpen;
- (void)exitButtonWasHitOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView;
- (void)difficultyWasSelectedOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView WithDifficulty:(int)difficulty;
- (void)shopWasSelectedOnMiniGamePopUpView;
- (void)menuWasSelectedOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView;
- (void)replayWasSelectedOnMiniGamePopupView:(CDMiniGamePopupView *)miniGamePopupView;

@end