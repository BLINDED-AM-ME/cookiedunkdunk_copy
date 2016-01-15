//
//  SGAchievementAlertView.m
//  CookieDD
//
//  Created by Josh on 3/17/14.
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

#import "SGAchievementAlertView.h"

@interface SGAchievementAlertView();

@property (assign, nonatomic) SGAchievementAlertScreenPosition screenPosition;

@property (assign, nonatomic) CGPoint displayedPosition;
@property (assign, nonatomic) CGPoint hiddenPosition;
@property (assign, nonatomic) CGRect openMessageFrame;

@end

@implementation SGAchievementAlertView

- (void)setupForScreenPosition:(SGAchievementAlertScreenPosition)screenPosition {
    _screenPosition = screenPosition;
    DebugLog(@"Creating achievement alert at screen position:");
    [self setFramesForScreenPostion:screenPosition];
    self.center = _hiddenPosition;
    
    _openMessageFrame = _messageBar.frame;
    [self hideMessageBarAnimated:NO completion:nil];
    
    [_messageLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    [_messageLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:3.0f];
}

- (void)setFramesForScreenPostion:(SGAchievementAlertScreenPosition)screenPosition  {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float positionOffset = 60;
    
    switch (screenPosition) {
        case SGAchievementAlertScreenPositionTopCenter:
            DebugLog(@"    -Top-Center");
            _displayedPosition = CGPointMake(screenBounds.size.width / 2, positionOffset);
            _hiddenPosition = CGPointMake(screenBounds.size.width / 2, -self.frame.size.height);
            break;
            
        case SGAchievementAlertScreenPositionBottomCenter:
            DebugLog(@"    -Bottom-Center");
            _displayedPosition = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height - positionOffset);
            _hiddenPosition = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height + self.frame.size.height);
            break;
            
        default:
            break;
    }
}

- (void)displayAchievementAlertWithMessage:(NSString *)message Completion:(methodCompletion)completed {
    DebugLog(@"Display achievement with message \"%@\"", message);
    
    [_messageLabel setText:message];
    
    // Display the alert.
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.center = _displayedPosition;
    } completion:^(BOOL finished) {
        [self displayMessageBarAnimated:YES completion:^(BOOL completedDisplay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self hideMessageBarAnimated:YES completion:^(BOOL completedHide) {
                    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.center = _hiddenPosition;
                    } completion:^(BOOL finished) {
                        if (completed) completed(YES);
                    }];
                }];
            });
        }];
    }];
}

- (void)hideMessageBarAnimated:(BOOL)shouldAnimate completion:(methodCompletion)completed {
    CGRect destRect = _messageBar.frame;
    destRect.size.width = 0;
    float duration = shouldAnimate? 0.3f : 0.0f;
    
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _messageBar.frame = destRect;
    } completion:^(BOOL finished) {
        if (completed) completed(YES);
    }];
}

- (void)displayMessageBarAnimated:(BOOL)shouldAnimate completion:(methodCompletion)completed {
    float duration = shouldAnimate? 0.3f : 0.0f;
    
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        _messageBar.frame = _openMessageFrame;
    } completion:^(BOOL finished) {
        if (completed) completed(YES);
    }];
}

@end
