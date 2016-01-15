//
//  CDLivesDisplayView.m
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

#import "CDLivesDisplayView.h"

@interface CDLivesDisplayView()

@property (assign, nonatomic) CGRect openTimerRect;
@property (assign, nonatomic) CGRect openDisplayRect;
@property (assign, nonatomic) CGPoint rollLivesOriginalCenter;
@property (assign, nonatomic) CGPoint rollLivesUpperCenter;
@property (assign, nonatomic) CGPoint rollLivesLowerCenter;

@property (assign, nonatomic) int secondsUntilLifeUnlock;
@property (strong, nonatomic) NSTimer *oneSecondTimer;


@end

@implementation CDLivesDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //[self setup];
    }
    return self;
}

- (void)initialize {
    [self setup];
}

- (void)setup {
    
    // Sets up the font and stroke for the different labels.
    [self.livesCountLabel setFont:[UIFont fontWithName:@"DamnNoisyKids" size:self.livesCountLabel.font.pointSize]];
    [self.livesCountLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    [self.timerLabel setFont:[UIFont fontWithName:@"DamnNoisyKids" size:self.timerLabel.font.pointSize]];
    [self.timerLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [self setupAnimaitonReferences];
    [self setupLives];
}

- (void)setupAnimaitonReferences {
    // This is needed when animating later.
    for (UIView *view in self.subviews) {
        view.clipsToBounds = YES;
    }
    
    // True Center
    self.rollLivesOriginalCenter = self.livesCountLabel.center;
    // Upper Roll Center
    CGPoint point = self.rollLivesOriginalCenter;
    point.y -= self.frame.size.height * 0.2;
    self.rollLivesUpperCenter = point;
    // Lower Roll Center
    point = self.rollLivesOriginalCenter;
    point.y += self.frame.size.height * 0.2;
    self.rollLivesLowerCenter = point;
    
    
    self.openDisplayRect = self.frame;
    self.openTimerRect = self.timerBoxView.frame;
}

- (void)setupLives {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.nextLifeUnlockDate = [userDefaults objectForKey:LifeUnlockDateDefault];
    _numLives =  [[SGAppDelegate appDelegate].accountDict[@"lives"] intValue];
    [self updateLivesCount];
    [self checkForAccumulatedLives];
    //.[self checkForCountdown];
}


#pragma mark - Properties

- (void)setNumLives:(int)numLives {
    DebugLog(@"Setting lives to %i", numLives);
    if (numLives < 0) {
        DebugLog(@"Error: Trying to set current lives to a negative value.");
        numLives = 0;
    }
    
    //[self rollLivesTo:numLives];
    
    int deltaLives = numLives - self.numLives;
    if (deltaLives != 0) {
        if (deltaLives > 0) {
            [self rollLivesUpTo:numLives];
            [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:deltaLives] costValue:[NSNumber numberWithInt:0] costType:CostType_None completionHandler:nil];
        }
        else {
            [self rollLivesDownTo:numLives];
            [[CDIAPManager iapMananger] requestToDecreaseLivesValue:[NSNumber numberWithInt:-deltaLives] costValue:[NSNumber numberWithInt:0] costType:CostType_None completionHandler:nil];
        }
    }
    
    _numLives = numLives;
    
    [self checkForCountdown];
}

- (void)rollLivesTo:(int)lives {
    if (self.numLives > lives) {
        [self rollLivesUpTo:lives];
    }
    else {
        [self rollLivesDownTo:lives];
    }
}

- (void)rollLivesUpTo:(int)lives {
    
    // Roll the current counter to the top.
    CGAffineTransform scaleDownTransform = CGAffineTransformMakeScale(0.9, 0.9);
    
    // Roll the next counter from the bottom.
    CGAffineTransform scaleUpTransform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.livesCountLabel.transform = scaleDownTransform;
        self.livesCountLabel.center = self.rollLivesUpperCenter;
        self.livesCountLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        //[self.livesCountLabel setText:[NSString stringWithFormat:@"%i", lives]];
        [self updateLivesCount];
        self.livesCountLabel.center = self.rollLivesLowerCenter;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.livesCountLabel.transform = scaleUpTransform;
            self.livesCountLabel.center = self.rollLivesOriginalCenter;
            self.livesCountLabel.alpha = 1.0;
        }];
    }];
}

- (void)rollLivesDownTo:(int)lives {
    
    // Roll the current counter to the bottom.
    CGAffineTransform scaleDownTransform = CGAffineTransformMakeScale(0.9, 0.9);
    
    // Roll the next counter from the top.
    CGAffineTransform scaleUpTransform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.livesCountLabel.transform = scaleDownTransform;
        self.livesCountLabel.center = self.rollLivesLowerCenter;
        self.livesCountLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        //[self.livesCountLabel setText:[NSString stringWithFormat:@"%i", lives]];
        [self updateLivesCount];
        self.livesCountLabel.center = self.rollLivesUpperCenter;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.livesCountLabel.transform = scaleUpTransform;
            self.livesCountLabel.center = self.rollLivesOriginalCenter;
            self.livesCountLabel.alpha = 1.0;
        }];
    }];
    
}




#pragma mark - Whole View Animations

- (void)toggleDisplayAnimated:(BOOL)shouldAnimate {
    if (self.displayIsHidden) {
        //DebugLog(@"Toggle lives display to shown. [animated:%i]", shouldAnimate);
        [self showDisplayAnimated:shouldAnimate];
    }
    else {
        //DebugLog(@"Toggle lives display to hidden. [animated:%i]", shouldAnimate);
        [self hideDisplayAnimated:shouldAnimate];
    }
}

- (void)showDisplayAnimated:(BOOL)shouldAnimate completion:(void (^)(void))block {
    //DebugLog(@"Show lives display. [animated:%i]", shouldAnimate);
    
    self.displayIsHidden = NO;
    
    if (shouldAnimate) {
        CGRect displayRect01 = self.openDisplayRect;
        displayRect01.origin.y += displayRect01.size.height * 0.06;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = displayRect01;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.18f animations:^{
                self.frame = self.openDisplayRect;
            } completion:^(BOOL finished) {
                if (self.numLives < 5) { //self.timerIsHidden && self.nextLifeUnlockDate) {
                    DebugLog(@"ShowDisplay is showing the timer animated.");
                    [self showTimerAnimated:YES completion:^(BOOL wasSuccessful) {
                        if (block) block();
                    }];
                }
                else {
                    if (block) block();
                }
            }];
        }];
    }
    else {
        // Skip the animations, and get things done NAOW!
        self.frame = self.openDisplayRect;
        if (self.timerIsHidden && self.nextLifeUnlockDate) {
            DebugLog(@"ShowDisplay is showing the timer un-animated.");
            [self showTimerAnimated:NO completion:^(BOOL wasSuccessful) {
                if (block) block();
            }];
        }
        else {
            if (block) block();
        }
    }
}

- (void)showDisplayAnimated:(BOOL)shouldAnimate {
    [self showDisplayAnimated:shouldAnimate completion:nil];
}

- (void)hideDisplayAnimated:(BOOL)shouldAnimate {
    //DebugLog(@"Hide lives display. [animated:%i]", shouldAnimate);
    
    self.displayIsHidden = YES;
    
    CGRect displayRect = self.frame;
    displayRect.origin.y = -displayRect.size.height;
    
    if (shouldAnimate) {
        if (self.timerIsHidden) {
            [UIView animateWithDuration:0.3f animations:^{
                self.frame = displayRect;
            }];
        }
        else {
            DebugLog(@"hideDisplay is hiding timer animated.");
            [self hideTimerAnimated:YES completion:^(BOOL completed) {
                [UIView animateWithDuration:0.3f animations:^{
                    self.frame = displayRect;
                }];
            }];
        }
    }
    else {
        // Skip the animations, and get things done NAOW!
        self.frame = displayRect;
        DebugLog(@"hideDisplay is hiding timer un-animated.");
        [self hideTimerAnimated:NO completion:nil];
    }
}

#pragma mark - Timer Animations

- (void)toggleTimerAnimated:(BOOL)shouldAnimate {
    if (self.timerIsHidden) {
        DebugLog(@"Toggle timer is showing the timer.");
        [self showTimerAnimated:shouldAnimate completion:nil];
    }
    else {
        DebugLog(@"toggleTimer is hiding timer.");
        [self hideTimerAnimated:shouldAnimate completion:nil];
    }
}

- (void)showTimerAnimated:(BOOL)shouldAnimate completion:(methodCompletion)completed {
    DebugLog(@"Showing the lives timer.");
    self.timerIsHidden = NO;
    
    if (shouldAnimate) {
        [UIView animateWithDuration:0.35 animations:^{
            self.timerBoxView.frame = self.openTimerRect;
        } completion:^(BOOL finished) {
            if (completed) completed(YES);
        }];
    }
    else {
        self.timerBoxView.frame = self.openTimerRect;
        if (completed) completed(YES);
    }
}

- (void)hideTimerAnimated:(BOOL)shouldAnimate completion:(methodCompletion)completed {
    
    self.timerIsHidden = YES;
    
    CGRect timerRect03 = self.timerBoxView.frame;
    timerRect03.size.width = 0;
    
    if (shouldAnimate) {
        [UIView animateWithDuration:0.35 animations:^{
            self.timerBoxView.frame = timerRect03;
        } completion:^(BOOL finished) {
            if (completed) completed(YES);
        }];
    }
    else {
        self.timerBoxView.frame = timerRect03;
        if (completed) completed(YES);
    }
}



#pragma mark - Timer

- (void)checkForAccumulatedLives {
    if (self.numLives < 5) {
        if (self.nextLifeUnlockDate != nil) {
            NSDate *currentDate = [NSDate date];
            if ([currentDate compare:self.nextLifeUnlockDate] == NSOrderedAscending) {
                DebugLog(@"Unlock date is in the future.");
                [self countdownToDate:self.nextLifeUnlockDate];
            }
            else {
                DebugLog(@"Unlock date is in the past.");
                int numSecondsThatPassed = -[self.nextLifeUnlockDate timeIntervalSinceDate:currentDate];
                int numLivesThatPassed = numSecondsThatPassed / LifeUnlockDelay;
                // Accumulated lives are calculated from the unlockDate, which has passed, so self.numLives should be
                //    one more than when the app was quit.
                DebugLog(@"Accumulated %i lives since last session. (Already had %i.)", numLivesThatPassed, self.numLives);
                int newLifeCount = self.numLives + numLivesThatPassed;
                DebugLog(@"     Total lives is now %i.", newLifeCount);
                if (newLifeCount > 5) {
                    newLifeCount = 5;
                    DebugLog(@"          (Trimming that to 5");
                    [self clearLifeUnlockDate];
                    
                }
                else {
                    // Check for remaining time, and set the new target date.
                    int leftoverSeconds;
                    if (numLivesThatPassed > 0) {
                        leftoverSeconds = numSecondsThatPassed % numLivesThatPassed;
                    }
                    else {
                        leftoverSeconds = numSecondsThatPassed;
                    }
                    DebugLog(@"Countdown is %i seconds into the next life.", leftoverSeconds);
                    int secondsUntilUnlock = LifeUnlockDelay - leftoverSeconds;
                    NSDate *nextUnlockDate = [NSDate dateWithTimeInterval:secondsUntilUnlock sinceDate:currentDate];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:nextUnlockDate forKey:LifeUnlockDateDefault];
                    
                }
                
                self.numLives = newLifeCount;
            }
        }
        else {
            DebugLog(@"Next life unlock date is nil.");
            [self createNewCountdown];
            [self countdownToDate:self.nextLifeUnlockDate];
        }
    }
    else {
        DebugLog(@"Accumulated lives are unnecessary; There's already %i lives.", self.numLives);
        DebugLog(@"checkAccumulated is hiding timer un-animated.");
        [self clearLifeUnlockDate];
        [self hideTimerAnimated:NO completion:nil];
    }
}

- (void)checkForCountdown {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self.numLives < 5) {
        DebugLog(@"Lives are less than five.");
        self.nextLifeUnlockDate = [userDefaults objectForKey:LifeUnlockDateDefault];
        if (self.nextLifeUnlockDate == nil) {
            [self createNewCountdown];
        }
        
        [self countdownToDate:self.nextLifeUnlockDate];
    }
    else {
        // For safety.
        [self shutdownTimer];
        [self clearLifeUnlockDate];
    }
    
    
    /*
    if (self.numLives >= 5) {
        DebugLog(@"Player has full lives.");
        [userDefaults setObject:nil forKey:LifeUnlockDateDefault];
        self.nextLifeUnlockDate = nil;
        if (self.timerIsHidden == NO) {
            [self hideTimerAnimated:YES completion:nil];
        }
    }
    else {
        DebugLog(@"Needs lives.");
        self.nextLifeUnlockDate = [userDefaults objectForKey:LifeUnlockDateDefault];
        
        if (self.nextLifeUnlockDate == nil) {
            DebugLog(@"Creating a new life unlock date.");
            self.nextLifeUnlockDate = [NSDate dateWithTimeIntervalSinceNow:LifeUnlockDelay];
            [userDefaults setObject:self.nextLifeUnlockDate forKey:LifeUnlockDateDefault];
        }
        else if ([self.nextLifeUnlockDate timeIntervalSinceNow] < 0) {
            DebugLog(@"Current saved date has passed.");
            int numSecondsThatPassed = -[self.nextLifeUnlockDate timeIntervalSinceNow];
            int numLivesThatPassed = numSecondsThatPassed / LifeUnlockDelay;
            DebugLog(@"Accumulated %i lives since last session.", numLivesThatPassed);
            int newLifeCount = self.numLives + numLivesThatPassed;
            DebugLog(@"     Total lives is now %i.", numLivesThatPassed);
            if (newLifeCount > 5) {
                newLifeCount = 5;
                DebugLog(@"          (Trimming that to 5");
            }
            DebugLog(@"Seting lives to %i", newLifeCount);
            self.numLives = newLifeCount;
            
            // check for leftover time, and start a new countdown.
        }
        
        [self countdownToDate:self.nextLifeUnlockDate];
    }
    */
    
    
    
    //<><><><><><><><><><><><><><><><><><><><><><><><><><>\\
    
    
    
//    DebugLog(@"Checking date.");
//    if (self.numLives < 5) {
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSMutableArray *datesArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:LifeUnlockDateDefault]];
//        DebugLog(@"dateArray Pre = %@", datesArray);
//        NSDate *finalLifeDate = [[NSDate alloc] init];
//
//        for (int count = self.numLives; count > 0; count--) {
//            DebugLog(@"Need a life.");
//            finalLifeDate = [datesArray lastObject];
//            NSDate *lifeDate = [[NSDate alloc] init];
//            
//            if (finalLifeDate == nil) {
//                lifeDate = [NSDate dateWithTimeIntervalSinceNow:15 /*1200*/];
//            }
//            else {
//                lifeDate = [NSDate dateWithTimeInterval:15 /*1200*/ sinceDate:finalLifeDate];
//            }
//            [datesArray addObject:lifeDate];
//        }
//        
//        DebugLog(@"datesArray Post = %@", datesArray);
//        [userDefaults setObject:datesArray forKey:LifeUnlockDateDefault];
//        
//        [self countdownToDate:[datesArray firstObject]];
//    }
    
        
        
        
        
        
        
//        if ([SGAppDelegate appDelegate].accountDict[@"lifeDate"]) {
//            lifeDate = [SGAppDelegate appDelegate].accountDict[@"lifeDate"];
//        }
//        else {
//            lifeDate = [NSDate dateWithTimeIntervalSinceNow:15 /*1200*/];
//            [[SGAppDelegate appDelegate].accountDict setObject:lifeDate forKey:@"lifeDate"];
//        }
//        [self countdownToDate:lifeDate];
//    }
//    else {
//        [self shutdownTimer];
//    }
}

- (void)createNewCountdown {
    DebugLog(@"Creating a new life unlock date.");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.nextLifeUnlockDate = [NSDate dateWithTimeIntervalSinceNow:LifeUnlockDelay];
    [userDefaults setObject:self.nextLifeUnlockDate forKey:LifeUnlockDateDefault];
}

- (void)shutdownTimer {
    [self.oneSecondTimer invalidate];
    self.oneSecondTimer = nil;
    
    DebugLog(@"shutdownTimer is hiding timer animated.");
    [self hideTimerAnimated:YES completion:nil];
}



- (void)countdownToDate:(NSDate *)targetDate {
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:targetDate] == NSOrderedAscending) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:targetDate forKey:LifeUnlockDateDefault];
        self.nextLifeUnlockDate = targetDate;
        
        if (self.timerIsHidden) {
            DebugLog(@"Countdown is showing the timer animated.");
            [self showTimerAnimated:YES completion:nil];
        }
        
        self.secondsUntilLifeUnlock = [targetDate timeIntervalSinceDate:currentDate];
        
        DebugLog(@"_secondsUntilLifeUnlock: %i", _secondsUntilLifeUnlock);
        
        // Call this once, to get things started.
        [self updateTimerLabel];
        
        // Kill the NSTimer, just in case;
        [self.oneSecondTimer invalidate];
        self.oneSecondTimer = nil;
        
        // Create the NSTimer.
        self.oneSecondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.oneSecondTimer forMode:UITrackingRunLoopMode];
    }
    else {
        DebugLog(@"Error: Trying to count down to target date that isn't in the future.");
    }
}



#pragma mark - Other

- (void)updateLivesCount {
    DebugLog(@"Updating lives label.");
    
    NSString *lifeCountString;
    if (self.numLives > 99) {
        lifeCountString = @"99+";
    }
    else {
        lifeCountString = [NSString stringWithFormat:@"%i", self.numLives];
    }
    
    [self.livesCountLabel setText:lifeCountString];
}



- (void)updateTimerLabel {
    [_timerLabel setText:[NSString stringWithFormat:@" %02i:%02i", _secondsUntilLifeUnlock / 60, _secondsUntilLifeUnlock % 60]];
    _secondsUntilLifeUnlock -= 1;
    
    if (_secondsUntilLifeUnlock < 0) {
        DebugLog(@"Time's up.");
        
        // Kill the NSTimer.
        [self.oneSecondTimer invalidate];
        self.oneSecondTimer = nil;
        
        // Clean out the date.
        [self clearLifeUnlockDate];
        
        // Update profile lives.
        DebugLog(@"Add a life.");
        self.numLives = self.numLives + 1;
        
        // Send the message to our delegates.
        [self timerDidExpire];
    }
}

- (void)clearLifeUnlockDate {
    self.nextLifeUnlockDate = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:LifeUnlockDateDefault];
}



#pragma mark - Delegate Methods

- (void)timerDidExpire {
    if ([self.delegate respondsToSelector:@selector(livesDisplayView:DidReachLifeUnlockDate:)]) {
        [self.delegate livesDisplayView:self DidReachLifeUnlockDate:self.nextLifeUnlockDate];
    }
}

@end