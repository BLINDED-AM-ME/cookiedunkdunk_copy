//
//  CDMainGamePopupView.h
//  CookieDD
//
//  Created by gary johnston on 4/1/14.
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

typedef void(^methodCompletion)(BOOL);

@protocol CDMainGamePopupViewDelegate;

@interface CDMainGamePopupView : UIView

@property (weak, nonatomic) id<CDMainGamePopupViewDelegate> delegate;

@property (strong, nonatomic) UIViewController *parentalViewController;

@property (weak, nonatomic) IBOutlet UIView *loseScreenView;
@property (weak, nonatomic) IBOutlet UIView *winScreenView;
@property (weak, nonatomic) IBOutlet UIView *openingScreenView;
@property (weak, nonatomic) IBOutlet UIView *blackOut;
@property (weak, nonatomic) IBOutlet UIView *theVisibleGroup;

@property (weak, nonatomic) IBOutlet UIImageView *sadFaceImage;
@property (weak, nonatomic) IBOutlet UIImageView *goldStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *bronzeStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *silverStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *openingScreenBronzeStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *openingScreenSilverStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *openingScreenGoldStarImage;
@property (weak, nonatomic) IBOutlet UIImageView *addPowerUp1Image;
@property (weak, nonatomic) IBOutlet UIImageView *addPowerUp2Image;
@property (weak, nonatomic) IBOutlet UIImageView *addPowerUp3Image;
@property (weak, nonatomic) IBOutlet UIImageView *targetStar;
@property (weak, nonatomic) IBOutlet UIImageView *extraPlusImage;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *youreOutOfLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *mapButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *retryButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *ohNoLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *scoreLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *bestScoreLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *facebookButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *nextButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *replayButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *playButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *targetLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *openingScreenOhNoLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *labelLabel;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *buyExtraButton;
@property (weak, nonatomic) IBOutlet UIButton *smallMapButton;
@property (weak, nonatomic) IBOutlet UIButton *largeMapButton;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *powerup1Button;
@property (weak, nonatomic) IBOutlet UIButton *powerup2Button;
@property (weak, nonatomic) IBOutlet UIButton *powerup3Button;
@property (weak, nonatomic) IBOutlet UIView *faderView;

@property (assign, nonatomic) int score;
@property (assign, nonatomic) int level;

@property (assign, nonatomic) BOOL didWin;

@property (strong, nonatomic) NSString *levelName;

- (void)setupLoseScreenWithCondition:(BOOL)isOutOfLives WithLossCondition:(NSString *)lossCondition;
- (void)setupWinScreenWithStarType:(StarType)starType Score:(int)score;
- (void)setupOpeningScreenWithTargetMessage:(NSString *)targetMessage WithCurrentStarType:(StarType)starType;

- (void)displayPopupAnimated:(BOOL)shouldAnimate Completion:(methodCompletion)completed;
- (void)hidePopupAnimated:(BOOL)shouldAnimate Completion:(methodCompletion)completed;

- (IBAction)exitButtonHit:(id)sender;
- (IBAction)retryButtonHit:(id)sender;
- (IBAction)mapButtonHit:(id)sender;
- (IBAction)buyExtraButtonHit:(id)sender;
- (IBAction)facebookButtonHit:(id)sender;
- (IBAction)nextButtonHit:(id)sender;
- (IBAction)playButtonHit:(id)sender;
- (IBAction)powerup1ButtonHit:(id)sender;
- (IBAction)powerup2ButtonHit:(id)sender;
- (IBAction)powerup3ButtonHit:(id)sender;

@end

@protocol CDMainGamePopupViewDelegate <NSObject>

@optional
-(void)mainGamePopupViewExited:(CDMainGamePopupView*)popupView Stars:(StarType)starType Score:(int)score ShouldContinue:(BOOL)shouldContinue;

@end












