//
//  CDLivesDisplayView.h
//  CookieDD
//
//  Created by Josh on 2/10/14.
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

typedef void(^methodCompletion)(BOOL);

@protocol CDLivesDisplayViewDelegate;

@interface CDLivesDisplayView : UIView

@property (strong, nonatomic) IBOutlet UIView *timerBoxView;
@property (strong, nonatomic) IBOutlet SGStrokeLabel *timerLabel;
@property (strong, nonatomic) IBOutlet SGStrokeLabel *livesCountLabel;

@property (weak, nonatomic) id<CDLivesDisplayViewDelegate> delegate;
@property (assign, nonatomic) int numLives;
@property (strong, nonatomic) NSDate *nextLifeUnlockDate;

@property (assign, nonatomic) BOOL displayIsHidden;
@property (assign, nonatomic) BOOL timerIsHidden;

-(void)initialize;

-(void)toggleDisplayAnimated:(BOOL)shouldAnimate;
-(void)showDisplayAnimated:(BOOL)shouldAnimate;
-(void)showDisplayAnimated:(BOOL)shouldAnimate completion:(void(^)(void))block;
-(void)hideDisplayAnimated:(BOOL)shouldAnimate;
-(void)hideDisplayAnimated:(BOOL)shouldAnimate completion:(void(^)(BOOL))block;;

-(void)toggleTimerAnimated:(BOOL)shouldAnimate;
-(void)showTimerAnimated:(BOOL)shouldAnimate completion:(methodCompletion)completed;
-(void)hideTimerAnimated:(BOOL)shouldAnimate completion:(methodCompletion)completed;

//-(void)setNumLivesTo:(int)lives;
//-(void)countdownToDate:(NSDate*)targetDate;
-(void)setupLives;
-(void)checkForAccumulatedLives;

@end

@protocol CDLivesDisplayViewDelegate <NSObject>

@optional
-(void)livesDisplayView:(CDLivesDisplayView*)livesDisplayView DidReachLifeUnlockDate:(NSDate*)lifeUnlockDate;


@end