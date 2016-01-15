//
//  CDAwardPopupViewController.h
//  CookieDD
//
//  Created by gary johnston on 3/14/14.
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
#import "SGStrokeLabel.h"

@protocol CDAwardPopupViewControllerDelegate;


@interface CDAwardPopupViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<CDAwardPopupViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *lowerGlimmerImage;
@property (weak, nonatomic) IBOutlet UIImageView *upperGlimmerImage;
@property (weak, nonatomic) IBOutlet UIImageView *awardImage;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *youWinLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *awardTextLabel;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapper;

@property (assign, nonatomic) int coinsToAward;
@property (assign, nonatomic) int difficulty;

@property (assign, nonatomic) BOOL awardGem;
@property (assign, nonatomic) BOOL awardForMainGame;
@property (assign, nonatomic) BOOL awardFreeCostume;

- (IBAction)handleTapper:(id)sender;

-(void)AnimateThisBitch;

@end


@protocol CDAwardPopupViewControllerDelegate <NSObject>

@required
- (void)didTapScreenToDismissAwardsPopupViewController:(CDAwardPopupViewController *) awardsPopupViewController;

@end
