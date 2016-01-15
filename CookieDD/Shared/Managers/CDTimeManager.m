//
//  CDTimeManager.m
//  CookieDD
//
//  Created by Rodney Jenkins on 8/6/13.
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

#import "CDTimeManager.h"

static CDTimeManager *timeManager = nil;


@interface CDTimeManager ()
@property (strong, nonatomic) NSCalendar *calender;
@property (strong, nonatomic) NSDate *timerStartDate;
@property (assign, nonatomic) BOOL didTranistion;

@end

@implementation CDTimeManager


+ (CDTimeManager *)sharedManager
{
    if (!timeManager) {
        timeManager = [CDTimeManager new];
        timeManager.didTranistion = NO;
        timeManager.calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        double starttime = [[NSDate date] timeIntervalSince1970];
        timeManager.timerStartDate = [NSDate dateWithTimeIntervalSince1970:starttime];
    }
    
    return timeManager;
}

- (NSString *)returnCurrenTimeWithSceneToTransitionTo:(SKScene *)scene
                                           parentView:(SKView *)parentView
                                              maxTime:(NSInteger)maxTime
                                               action:(SKAction *)action
                                               sprite:(SKSpriteNode *)sprite
                                            labelNode:(SKLabelNode *)labelNode;




{
    NSDate *dateNow = [NSDate date];
    NSDateComponents *components = [self.calender components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                                    fromDate:self.timerStartDate
                                                      toDate:dateNow
                                                     options:0];
    //NSString *hours = [NSString stringWithFormat:@"&.2d", components.hour];
    NSString *minutes = [NSString stringWithFormat:@"%.2ld", (long)components.minute];
    NSString *seconds = [NSString stringWithFormat:@"%.2ld", (long)components.second];
    
    NSString *convertedTime = [NSString stringWithFormat:@"%@:%@", minutes, seconds];
    if (self.didTranistion) {
        return nil;
    }
    if ([seconds integerValue] > 30)
    {
        if (sprite && action) {
            labelNode.alpha = 1.0f;
            
            [parentView.scene addChild:sprite];
            SKAction *exAction = [SKAction runBlock:^{
                // TODO:
                // Here you'll wnat to make it easier to do different transitions think accessibility.
                DebugLog(@"we have winner");
                SKTransition *doors = [SKTransition
                                       doorsOpenVerticalWithDuration:0.5];
                [parentView presentScene:scene transition:doors];
              
            
            
            }];
            
            
            
            
            
            SKAction *sequence = [SKAction sequence:@[action, [SKAction waitForDuration:0.5f], exAction]];
            [sprite runAction:sequence];
        }
        else
        {
            // TODO:
            // Here you'll wnat to make it easier to do different transitions think accessibility.
            DebugLog(@"we have winner");
            SKTransition *doors = [SKTransition
                                   doorsOpenVerticalWithDuration:0.5];
            [parentView presentScene:scene transition:doors];
        }
        self.didTranistion = YES;
    }
    
    return convertedTime;
}

@end
