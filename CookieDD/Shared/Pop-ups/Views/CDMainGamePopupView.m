//
//  CDMainGamePopupView.m
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

#import "CDMainGamePopupView.h"
#import "SGGameManager.h"

@interface CDMainGamePopupView()

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *gender;

@property (strong, nonatomic) NSDate *birthDate;
@property (strong, nonatomic) NSURL *imageUrl;

@property (assign, nonatomic) StarType starType;

@end

@implementation CDMainGamePopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}


#pragma mark - Changing State

- (void)setupOpeningScreenWithTargetMessage:(NSString *)targetMessage WithCurrentStarType:(StarType)starType
{
    _winScreenView.hidden = YES;
    _loseScreenView.hidden = YES;
    _openingScreenView.hidden = NO;
    
    [_targetLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_targetLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_playButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_playButtonTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_openingScreenOhNoLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
    [_openingScreenOhNoLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
    
    [self setStarType:starType];
}

- (void)setupLoseScreenWithCondition:(BOOL)isOutOfLives WithLossCondition:(NSString *)lossCondition
{
    _winScreenView.hidden = YES;
    _openingScreenView.hidden = YES;
    _loseScreenView.hidden = NO;
    
    _extraPlusImage.hidden = YES;
    _buyExtraButton.hidden = YES;
    
    
    [_labelLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    [_labelLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_retryButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_retryButtonTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_mapButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_mapButtonTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_ohNoLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
    [_ohNoLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
    
    [_youreOutOfLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_youreOutOfLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    if (!isOutOfLives)
    {
        _youreOutOfLabel.text = lossCondition;//@"YOU'RE OUT OF MOVES!";
        _smallMapButton.hidden = NO;
        _largeMapButton.hidden = YES;
        _retryButton.hidden = NO;
        _retryButtonTextLabel.hidden = NO;
        _mapButtonTextLabel.frame = _smallMapButton.frame;
        [_sadFaceImage setImage:[UIImage imageNamed:@"cdd-hud-ico-sadcookie"]];
        [_buyExtraButton setImage:[UIImage imageNamed:@"cdd-store-icon-xtramoves"] forState:UIControlStateNormal];
        
//        _extraPlusImage.hidden = NO;
    }
    else
    {
        _youreOutOfLabel.text = lossCondition;//@"YOU'RE OUT OF LIVES!";
        _smallMapButton.hidden = YES;
        _largeMapButton.hidden = NO;
        _retryButton.hidden = YES;
        _retryButtonTextLabel.hidden = YES;
        _mapButtonTextLabel.frame = _largeMapButton.frame;
        [_sadFaceImage setImage:[UIImage imageNamed:@"cdd-hud-ico-nolives"]];
        [_buyExtraButton setImage:[UIImage imageNamed:@"cdd-store-icon-xtralives"] forState:UIControlStateNormal];
        
        if ([[SGAppDelegate appDelegate].accountDict[@"moves"] boolValue]) {
//            _extraPlusImage.hidden = NO;
        }
        else {
            _extraPlusImage.hidden = YES;
        }
    }
}

- (void)setupWinScreenWithStarType:(StarType)starType Score:(int)score
{
    _loseScreenView.hidden = YES;
    _openingScreenView.hidden = YES;
    _winScreenView.hidden = NO;
    
    [_replayButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_replayButtonTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_nextButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_nextButtonTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_youreOutOfLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_youreOutOfLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_facebookButtonTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:10]];
    [_facebookButtonTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_scoreLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_scoreLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    _score = score;
    [_scoreLabel setText:[NSString stringWithFormat:@"SCORE: %i", score]];
    
    [_bestScoreLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_bestScoreLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_labelLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:14]];
    [_labelLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    self.starType = starType;
}

-(void)setStarType:(StarType)starType {
    _starType = starType;
    
    if (starType == BRONZE_STAR)
    {
        [_bronzeStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starbronze"]];
        [_silverStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starsilverempty"]];
        [_goldStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-stargoldempty"]];
    }
    else if (starType == SILVER_STAR)
    {
        [_bronzeStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starbronze"]];
        [_silverStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starsilver"]];
        [_goldStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-stargoldempty"]];
    }
    else if (starType == GOLD_STAR)
    {
        [_bronzeStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starbronze"]];
        [_silverStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-starsilver"]];
        [_goldStarImage setImage:[UIImage imageNamed:@"cdd-hud-ico-stargold"]];
    }
}

#pragma mark - Animations

- (void)displayPopupAnimated:(BOOL)shouldAnimate Completion:(methodCompletion)completed {
    //TODO: Actual animation.
    
    
    if(shouldAnimate){
        
        _blackOut.alpha = 0;
        
        CGPoint center = CGPointMake((self.frame.size.width/2)-(_theVisibleGroup.frame.size.width/2),
                                     (self.frame.size.height/2) - (_theVisibleGroup.frame.size.width/2));
        float OffScreen = self.frame.size.height;
        CGRect beginningRect = CGRectMake(center.x, OffScreen, _theVisibleGroup.frame.size.width, _theVisibleGroup.frame.size.height);
        CGRect targetRect = CGRectMake(center.x, center.y, beginningRect.size.width, beginningRect.size.height);
        
        _theVisibleGroup.frame = beginningRect;
        
        [self prepareStarsForAnimation];
        
        [UIView animateWithDuration:0.4 delay:0.0
                            options:UIViewAnimationOptionLayoutSubviews//UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             _blackOut.alpha = 0.7f;
                             _theVisibleGroup.frame = targetRect;
                         }
                         completion:^(BOOL fin) {
                             [self animateStarsCompletion:^(BOOL finished) {
                                 if (completed) completed(YES);
                             }];
                         }];
    }
    else {
        
        // not animating
        
        CGPoint center = CGPointMake((self.frame.size.width/2)-(_theVisibleGroup.frame.size.width/2),
                                     (self.frame.size.height/2) - (_theVisibleGroup.frame.size.width/2));
        _theVisibleGroup.frame = CGRectMake(center.x, center.y, _theVisibleGroup.frame.size.width, _theVisibleGroup.frame.size.height);

        _blackOut.alpha = 0.7f;
        
        if (completed) completed(YES);
        
    }
    
    
}

- (void)prepareStarsForAnimation {
    _bronzeStarImage.alpha = 0.0f;
    _silverStarImage.alpha = 0.0f;
    _goldStarImage.alpha = 0.0f;
}

- (void)hidePopupAnimated:(BOOL)shouldAnimate Completion:(methodCompletion)completed {
    //TODO: Actual animation.
    if (completed) completed(YES);
}


- (void)animateStarsCompletion:(methodCompletion)completed {
    self.bronzeStarImage.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
    self.silverStarImage.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
    self.goldStarImage.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
    
    [UIView animateWithDuration:0.15f delay:0.15f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_victory_star_bronze" FileType:@"m4a"];
        self.bronzeStarImage.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.bronzeStarImage.alpha = 1.0f;
    } completion:^(BOOL finished) {
        // Place landing sound here.
        
        [UIView animateWithDuration:0.15f delay:0.15f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_victory_star_silver" FileType:@"m4a"];
            self.silverStarImage.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.silverStarImage.alpha = 1.0f;
            // Place landing sound here.
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15f delay:0.15f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_victory_star_gold" FileType:@"m4a"];
                self.goldStarImage.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                self.goldStarImage.alpha = 1.0f;
                // Place landing sound here.
                
            } completion:^(BOOL finished) {
                if (completed) completed(YES);
            }];
        }];
    }];
}


#pragma mark - Buttons

- (IBAction)exitButtonHit:(id)sender
{
    DebugLog(@"Endgame Popup: Exit");
    self.faderView.frame = self.frame;
    
    if (_didWin && (_level == 30))
    {
        if ([self.delegate respondsToSelector:@selector(mainGamePopupViewExited:Stars:Score:ShouldContinue:)]) {
            [self.delegate mainGamePopupViewExited:self Stars:_starType Score:_score ShouldContinue:YES];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(mainGamePopupViewExited:Stars:Score:ShouldContinue:)]) {
            [self.delegate mainGamePopupViewExited:self Stars:_starType Score:_score ShouldContinue:NO];
        }
    }
}

- (IBAction)retryButtonHit:(id)sender
{
    DebugLog(@"Endgame Popup: Retry");
    
    [[SGGameManager gameManager] Retry];
}

- (IBAction)mapButtonHit:(id)sender
{
    DebugLog(@"Endgame Popup: Return to Map");
    self.faderView.frame = self.frame;
    if ([self.delegate respondsToSelector:@selector(mainGamePopupViewExited:Stars:Score:ShouldContinue:)]) {
        [self.delegate mainGamePopupViewExited:self Stars:_starType Score:_score ShouldContinue:NO];
    }
}

- (IBAction)buyExtraButtonHit:(id)sender
{
    DebugLog(@"Endgame Popup: Buy Extra");
    
    int lives = [[[SGAppDelegate appDelegate].accountDict objectForKey:@"lives"] intValue];
   if(lives == 0)
   {
       // Buy lives.
       
       [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:3]
                                                     costValue:[NSNumber numberWithInt:1000]
                                                      costType:CostType_Coins
                                             completionHandler:^
        (NSError *error, NSDictionary *updatedGameParametersDict)
        {
            if (!error && updatedGameParametersDict)
            {

            }
        }];
       
   }
   else if([SGGameManager gameManager].goalLimiter == GoalLimiters_TIME_LIMIT){
       
       [[SGGameManager gameManager] UseExtra_amount:60];
   }
   else {
       // NOTE
       // >>>>> KIETH
       
       //if([SGGameManager gameManager].goalLimiter == GoalLimiters_MOVE_LIMIT){
       // Buy Moves.
       
       int extraMoves = [[SGAppDelegate appDelegate].accountDict[@"moves"] intValue];
       DebugLog(@"Player currently has %i moves", extraMoves);
//       if (extraMoves > 0) {
//           // Use the player's moves.
//           [[SGGameManager gameManager] UseExtra_amount:extraMoves > 5? extraMoves : 5];
//           [[CDIAPManager iapMananger] requestToDecreaseMovesValue:[NSNumber numberWithInt:5] costValue:nil costType:CostType_None completionHandler:nil];
//       }
//       else {
           // Buy more.
           DebugLog(@"Bought moves, and waiting to get back.");
       
       int coins = [[[SGAppDelegate appDelegate].accountDict objectForKey:@"coins"] intValue];
       
       if (coins >= 1000)
       {
           [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:5] costValue:[NSNumber numberWithInt:1000] costType:CostType_Coins completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
               [[SGGameManager gameManager] UseExtra_amount:5];
           }];
       }
       else
       {
           [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self.parentalViewController
                                                                           withConditionType:ConditionalType_InsufficentFunds
                                                                            presentationType:PresentationType_Error
                                                                                   withFrame:self.frame
                                                                            errorDescription:nil loadingText:nil];
       }
//       }
       
   }


}

- (IBAction)facebookButtonHit:(id)sender
{
    NSString *facebookMessage = [NSString stringWithFormat:@"I just beat level %i on %@ with a score of %i!", _level, _levelName, _score];
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
                                              [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:_parentalViewController withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:self.frame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
                                              
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

- (IBAction)nextButtonHit:(id)sender
{
    DebugLog(@"Endgame Popup: Next");
    self.faderView.frame = self.frame;
    if ([self.delegate respondsToSelector:@selector(mainGamePopupViewExited:Stars:Score:ShouldContinue:)]) {
        [self.delegate mainGamePopupViewExited:self Stars:_starType Score:_score ShouldContinue:YES];
    }
}

- (IBAction)playButtonHit:(id)sender
{
    DebugLog(@"Endgame Popup: Play");
}

- (IBAction)powerup1ButtonHit:(id)sender
{
    DebugLog(@"Endgame Popup: Powerup 1");
}

- (IBAction)powerup2ButtonHit:(id)sender
{
    DebugLog(@"Endgame Popup: Powerup 2");
}

- (IBAction)powerup3ButtonHit:(id)sender
{
    DebugLog(@"Endgame Popup: Powerup 3");
}

@end
