//
//  SGAppDelegate.h
//  CookieDD
//
//  Created by Benjamin Stahlhood on 7/20/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.

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
#import "CDCommonHelpers.h"
#import "SGConditionalViewController.h"

// all enums have moved to the CDCommonHelper.h

typedef enum NavControllerTransitionEndType
{
    NavControllerTransitionEndType_Default,
    NavControllerTransitionEndType_Dismiss,
    NavControllerTransitionEndType_Pop
    
}   NavControllerTransitionEndType;

typedef enum NavControllerTransitionType
{
    NavControllerTransitionType_Default,
    NavControllerTransitionType_Present,
    NavControllerTransitionType_Push
}   NavControllerTransitionType;

@interface SGAppDelegate : UIResponder <UIApplicationDelegate, SGConditionalViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary *accountDict;
@property (strong, nonatomic) NSString *currentDeviceTokenId;
@property (strong, nonatomic) NSString *currentDeviceID;

@property (assign, nonatomic) float masterVolume;
@property (assign, nonatomic) int loadingScreenTimeDelay;
@property (assign, nonatomic) int dailyAwardsAllowed;
@property (assign, nonatomic) int purchasesAllowedBeforeRemovingPack;
@property (assign, nonatomic) BOOL unlockCookieCooker;
@property (assign, nonatomic) BOOL unlockCookieDrop;
@property (assign, nonatomic) BOOL unlockLeft4Bread;
@property (assign, nonatomic) BOOL unlockCowAbduction;
@property (assign, nonatomic) BOOL loggedInThroughFacebook;
@property (assign, nonatomic) BOOL isLoggedIntoFacebook;

+ (SGAppDelegate *)appDelegate;
//- (void)playThemeMusic;
- (void)stopThemeMusic;

#pragma mark - Return Player Account Email/Device ID

- (NSString *)fetchPlayerEmail;

- (NSString *)fetchPlayerDeviceID;

#pragma mark - Return Player Facebook ID

- (NSString *)fetchPlayerFacebookID;

#pragma mark - Present Conditional View Controller

- (void)dismissConditionalView;

- (void)presentConditionalViewControllerWithParentController:(UIViewController *)parentController
                                           withConditionType:(ConditionalType)conditionType
                                            presentationType:(PresentationType)presentationType
                                                   withFrame:(CGRect)frame
                                            errorDescription:(NSString *)errorDescription loadingText:(NSString *)loadingText;

#pragma mark - Custom Transitions between ViewControllers

- (void)transitionFadeWithParentViewController:(UIViewController *)parentViewController
                   endTransitionViewController:(UIViewController *)endTransitionViewController
                                 withImageName:(NSString *)imageName
                                 navController:(NavControllerTransitionType)transitionType
                         willAnimateTransition:(BOOL)animated;

- (void)transitionEndFadeWithParentViewController:(UIViewController *)parentViewController
         navControllerTransitionType:(NavControllerTransitionEndType)transitionType
                                    withImageName:(NSString *)imageName
                            willAnimateTransition:(BOOL)animated;

#pragma mark - Give Me The Proper Name Of A Cookie....
- (NSString *)retrieveProperCookieName:(NSString *)unFormattedName withTheme:(NSString *)theme;

#pragma mark - Give Me The Proper IAPIdentifier Of A Cookie....
- (NSString *)retrieveProperIAPIdentifierWithCookieName:(NSString *)unFormattedName withTheme:(NSString *)theme;

#pragma mark - Convert Points from UI to SK
- (CGPoint)convertPoint:(CGPoint)oldPoint WithSprite:(SKSpriteNode *)sprite WithScene:(SKScene *)scene;
@end
