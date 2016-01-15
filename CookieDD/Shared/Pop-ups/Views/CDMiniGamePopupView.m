//
//  CDMiniGamePopupView.m
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

#import "CDMiniGamePopupView.h"
#import "CDStandardPopupView.h"

@interface CDMiniGamePopupView() <CDStandardPopupViewDelegate>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *gender;

@property (strong, nonatomic) NSDate *birthDate;
@property (strong, nonatomic) NSURL *imageUrl;

@property (assign, nonatomic) BOOL popupIsOpen;

@end


@implementation CDMiniGamePopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [_gameNameLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_gameNameLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 6 : 3];
    
    [_easyTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_easyTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_mediumTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_mediumTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_hardTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_hardTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_crazyTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_crazyTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];

    [_replayTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_replayTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_menuTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
    [_menuTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_facebookTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:10]];
    [_facebookTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_scoreLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_scoreLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_bestScoreLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_bestScoreLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_winLoseTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
    [_winLoseTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
}

#pragma mark - EXIT BUTTON

- (IBAction)exitButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(exitButtonWasHitOnMiniGamePopupView:)])
    {
        [self.delegate exitButtonWasHitOnMiniGamePopupView:self];
    }
}

#pragma mark - DIFFICULTY BUTTONS
- (IBAction)easyButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(difficultyWasSelectedOnMiniGamePopupView:WithDifficulty:)])
    {
        [self.delegate difficultyWasSelectedOnMiniGamePopupView:self WithDifficulty:gameDifficultyLevelEasy];
    }
}

- (IBAction)mediumButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(difficultyWasSelectedOnMiniGamePopupView:WithDifficulty:)])
    {
        [self.delegate difficultyWasSelectedOnMiniGamePopupView:self WithDifficulty:gameDifficultyLevelMedium];
    }
}

- (IBAction)hardButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(difficultyWasSelectedOnMiniGamePopupView:WithDifficulty:)])
    {
        [self.delegate difficultyWasSelectedOnMiniGamePopupView:self WithDifficulty:gameDifficultyLevelHard];
    }
}

- (IBAction)crazyButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(difficultyWasSelectedOnMiniGamePopupView:WithDifficulty:)])
    {
        [self.delegate difficultyWasSelectedOnMiniGamePopupView:self WithDifficulty:gameDifficultyLevelCrazy];
    }
}

#pragma mark - OTHER BUTTONS

- (IBAction)menuButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(menuWasSelectedOnMiniGamePopupView:)])
    {
        [self.delegate menuWasSelectedOnMiniGamePopupView:self];
    }
}

- (IBAction)shopButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(shopWasSelectedOnMiniGamePopUpView)])
    {
        [self.delegate shopWasSelectedOnMiniGamePopUpView];
    }
}

- (IBAction)replayButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(replayWasSelectedOnMiniGamePopupView:)])
    {
        [self.delegate replayWasSelectedOnMiniGamePopupView:self];
    }
}

- (IBAction)helpButtonHit:(id)sender
{
    _popupIsOpen = YES;
    
    if ([self.delegate respondsToSelector:@selector(helpButtonWasHitOnMiniGamePopupView:)])
    {
        [self.delegate helpButtonWasHitOnMiniGamePopupView:YES];
    }
    
    _fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

- (IBAction)facebookButtonHit:(id)sender
{
    NSString *facebookMessage = [NSString stringWithFormat:@"I just scored %i in %@", _score, _minigameName];
    NSString *facebookTitle = @"Cookie Dunk Dunk";
    
    if ([SGAppDelegate appDelegate].loggedInThroughFacebook)
    {
        [[SGSocialManager socialManager] SGSocialManagerDidShareFacebbokWithTitle:facebookTitle withMessage:facebookMessage withImage:nil withViewController:_parentalViewController completionHandler:^(BOOL didFinishSharing) {
            
        }];
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:_parentalViewController withConditionType:ConditionalType_Default presentationType:PresentationType_Loading withFrame:self.frame errorDescription:nil loadingText:nil];
        
        [[SGSocialManager socialManager] openSessionFacebookWithCompletionHandler:^(FBSession *session, FBSessionState state, NSError *error)
         {
             if (!error)
             {
                 if (state != FBSessionStateOpen)
                 {
                     
                 }
                 switch (state)
                 {
                     case FBSessionStateOpen:
                     {
                         DebugLog(@"FBSessionStateOpen");
                         [[SGSocialManager socialManager] requestUserInfoFromFacebookWithCompletionHandler:^(NSError *error, NSDictionary *userInfo)
                          {
                              __weak typeof(self) weakSelf = self;
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  if (!error && userInfo)
                                  {
                                      if (userInfo[@"email"])
                                      {
                                          weakSelf.emailAddress = userInfo[@"email"];
                                      }
                                      
                                      if (userInfo[@"first_name"])
                                      {
                                          weakSelf.firstName = userInfo[@"first_name"];
                                      }
                                      
                                      if (userInfo[@"last_name"])
                                      {
                                          weakSelf.lastName = userInfo[@"last_name"];
                                      }
                                      
                                      if (userInfo[@"birthday"])
                                      {
                                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                          [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                                          weakSelf.birthDate = [dateFormatter dateFromString:userInfo[@"birthday"]];
                                      }
                                      
                                      if (userInfo[@"gender"])
                                      {
                                          weakSelf.gender = userInfo[@"gender"];
                                      }
                                      
                                      NSString *facebookId = nil;
                                      
                                      NSString *stringURL = nil;
                                      if (userInfo[@"id"])
                                      {
                                          facebookId = userInfo[@"id"];
                                          
                                          [[NSUserDefaults standardUserDefaults] setObject:facebookId forKey:@"facebookId"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          stringURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=600&height=600", facebookId];
                                          weakSelf.imageUrl = [NSURL URLWithString:stringURL];
                                      }
                                      
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                      
                                      
                                      [SGAppDelegate appDelegate].loggedInThroughFacebook = YES;
                                      [[WebserviceManager sharedManager] requestToUpdateAccountWithEmail:weakSelf.emailAddress deviceId:[SGAppDelegate appDelegate].currentDeviceID firstName:weakSelf.firstName lastName:weakSelf.lastName gender:weakSelf.gender birthdate:weakSelf.birthDate facebookID:facebookId didRecieveGift:nil completionHandler:^(NSDictionary *dictionary, NSError *error) {
                                          
                                          if (dictionary)
                                          {
                                              if (dictionary[@"account"] && [dictionary[@"account"] isKindOfClass:[NSDictionary class]])
                                              {
                                                  [SGAppDelegate appDelegate].accountDict = [dictionary[@"account"] mutableCopy];
                                              }
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [[SGAppDelegate appDelegate] dismissConditionalView];
                                                  [[SGSocialManager socialManager] SGSocialManagerDidShareFacebbokWithTitle:facebookTitle withMessage:facebookMessage withImage:nil withViewController:_parentalViewController completionHandler:^(BOOL didFinishSharing) {
                                                      
                                                  }];
                                              });
                                          }
                                          else if (error)
                                          {
                                              [[SGAppDelegate appDelegate] dismissConditionalView];
                                              [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:_parentalViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:weakSelf.parentalViewController.view.frame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  weakSelf.parentalViewController.view.userInteractionEnabled = YES;
                                              });
                                          }
                                          else
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  weakSelf.parentalViewController.view.userInteractionEnabled = YES;
                                              });
                                          }
                                      }];
                                      
                                      
                                      [[SGSocialManager socialManager] socialClassRequestAccessFriendsFromFacebook];
                                  }
                              });
                          }];
                     }
                         break;
                     case FBSessionStateClosed:
                     {
                         DebugLog(@"FBSessionStateClosed");
                     }
                         break;
                     case FBSessionStateClosedLoginFailed:
                     {
                         DebugLog(@"FBSessionStateClosedLoginFailed");
                     }
                         break;
                     case FBSessionStateCreated:
                     {
                         DebugLog(@"FBSessionStateCreated");
                     }
                         break;
                     case FBSessionStateCreatedOpening:
                     {
                         DebugLog(@"FBSessionStateCreatedOpening");
                     }
                         break;
                     case FBSessionStateCreatedTokenLoaded:
                     {
                         DebugLog(@"FBSessionStateCreatedTokenLoaded");
                     }
                         break;
                     case FBSessionStateOpenTokenExtended:
                     {
                         DebugLog(@"FBSessionStateOpenTokenExtended");
                     }
                         break;
                     default:
                         break;
                 }
             }
             else
             {
                 [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:_parentalViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.frame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
             }
             
         }];
        
    }
}

#pragma mark - Standard Popup Delegate
- (void)exitButtonWasHitOnStandardPopupView:(CDStandardPopupView *)standardPopup
{
    if ([self.delegate respondsToSelector:@selector(helpButtonWasHitOnMiniGamePopupView:)])
    {
        [self.delegate helpButtonWasHitOnMiniGamePopupView:NO];
    }
    _fadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
   
    _popupIsOpen = NO;
}

@end
