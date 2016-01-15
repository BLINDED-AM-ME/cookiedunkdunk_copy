//
//  CDViewController.m
//  PushTheButtonTest
//
//  Created by gary johnston on 1/23/14.
//  Copyright (c) 2014 gary johnston. All rights reserved.
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

#import "CDMainButtonViewController.h"

@interface CDMainButtonViewController()

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *gender;

@property (strong, nonatomic) NSDate *birthDate;
@property (strong, nonatomic) NSURL *imageUrl;

@property (strong, nonatomic) NSString *volumeButtonState;
@property (strong, nonatomic) NSString *musicButtonState;
@property (strong, nonatomic) NSUserDefaults *volumeButtonStateDefault;
@property (strong, nonatomic) NSUserDefaults *musicButtonStateDefault;

@property (assign, nonatomic) CGRect originFrame;
@property (assign, nonatomic) CGRect mainViewStartFrame;
@property (assign, nonatomic) CGRect mainButtonRect;

@property (assign, nonatomic) CGSize settingsSliderImageOriginSize;

@property (assign, nonatomic) CGPoint buttonOriginPoint;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGPoint startVolumePoint;
@property (assign, nonatomic) CGPoint startSettingsPoint;
@property (assign, nonatomic) CGPoint startHelpPoint;
@property (assign, nonatomic) CGPoint startSoundPoint;
@property (assign, nonatomic) CGPoint centerPoint;
@property (assign, nonatomic) CGPoint subViewCenterPoint;

@property (strong, nonatomic) NSArray *subButtonArray;

@property (assign, nonatomic) UIInterfaceOrientation currentOrientation;

@property (assign, nonatomic) BOOL resize;
@property (assign, nonatomic) BOOL settingsSliderIsOut;
@property (assign, nonatomic) BOOL accountSliderIsOut;

@property (assign, nonatomic) int viewSize;

@end


@implementation CDMainButtonViewController

+ (CDMainButtonViewController *)mainButton
{
    static CDMainButtonViewController *mainButton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainButton = [CDMainButtonViewController new];
    });
    
    return mainButton;
}

- (CDMainButtonViewController *)didCreateMainButtonViewWithParentalViewController:(UIViewController *)parentViewController
{
    CDMainButtonViewController *buttonViewController = [parentViewController.storyboard instantiateViewControllerWithIdentifier:@"CDMainButtonViewController"];
    buttonViewController.viewSize = 68;
    buttonViewController.view.frame = CGRectMake(0, CGRectGetMaxY(parentViewController.view.frame) - buttonViewController.viewSize, buttonViewController.viewSize, buttonViewController.viewSize);
    buttonViewController.parentViewFrame = _parentViewFrame;
    
    [parentViewController.view addSubview:buttonViewController.view];
    
    return buttonViewController;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.clipsToBounds = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.multipleTouchEnabled = NO;
    _subView.multipleTouchEnabled = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _subView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    _subView.transform = CGAffineTransformMakeRotation(M_PI);
    _resize = YES;
    _popupIsUp = NO;
    _mainButtonIsDown = YES;
    
    _originFrame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMaxY(self.view.frame) - _viewSize, _viewSize, _viewSize);
    
    
    [_restoreTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:13]];
    [_restoreTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    _subButtonArray = [NSArray arrayWithObjects:_backButton, _settingsButton, _shopButton, _accountButton, _helpButton, nil];
    
    _settingsSliderImage.transform = CGAffineTransformMakeScale(1, .1);
    _settingsSliderView.transform = CGAffineTransformMakeScale(1, .1);
    _settingsSliderIsOut = NO;
    
    _accountSliderImage.transform = CGAffineTransformMakeScale(1, .1);
    _accountSliderView.transform = CGAffineTransformMakeScale(1, .1);
    _accountSliderIsOut = NO;
    
    _settingsSliderImageOriginSize = _settingsSliderImage.frame.size;
    
    _settingsSliderView.hidden = YES;
    _accountSliderView.hidden = YES;
    
    _restoreButtonView.hidden = YES;
    _restoreButton.hidden = YES;
    _restoreTextLabel.hidden = YES;
    
    
    _helpButton.hidden = YES;
    _shopButton.hidden = YES;
    _backButton.hidden = YES;
    
    _settingsButton.hidden = YES;
    _volumeButton.hidden = YES;
    _soundButton.hidden = YES;
    
    _accountButton.hidden = YES;
    _achievementButton.hidden = YES;
    _gameCenterButton.hidden = YES;
    
    _facebookButton.hidden = YES;
    _googleButton.hidden = YES;
    _twitterButton.hidden = YES;
    
    [self checkAndSetTheDefaults];
    
    self.mainButtonRect = _mainButton.frame;
    
    
    UIImage *flippedImage = [UIImage imageWithCGImage:_mainButton.imageView.image.CGImage scale:_mainButton.imageView.image.scale orientation:UIImageOrientationUp];
    [_mainButton setImage:flippedImage forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Double check for reasons....
    [self checkAndSetTheDefaults];
    [self enableButtons:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

- (void)enableButtons:(BOOL)isEnabled
{
    _settingsButton.enabled = isEnabled;
    _accountButton.enabled = isEnabled;
    _helpButton.enabled = isEnabled;
    _settingsButton.enabled = isEnabled;
    _shopButton.enabled = isEnabled;
}

- (void)checkAndSetTheDefaults
{
    _volumeButtonStateDefault = [NSUserDefaults standardUserDefaults];
    _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
    
    if ([_volumeButtonState isEqualToString:@"high"])
    {
        [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume2-default"] forState:UIControlStateNormal];
        [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume2-active"] forState:UIControlStateHighlighted];
        [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume2-active"] forState:UIControlStateSelected];
    }
    else if ([_volumeButtonState isEqualToString:@"low"])
    {
        [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume1-default"] forState:UIControlStateNormal];
        [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume1-active"] forState:UIControlStateHighlighted];
        [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume1-active"] forState:UIControlStateSelected];
    }
    else if ([_volumeButtonState isEqualToString:@"mute"])
    {
        [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume0-default"] forState:UIControlStateNormal];
        [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume0-default"] forState:UIControlStateHighlighted];
        [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume0-default"] forState:UIControlStateSelected];
    }
    else
    {
        DebugLog(@"Missing volumeButtonState: %@", _volumeButtonState);
    }
    
    _musicButtonStateDefault = [NSUserDefaults standardUserDefaults];
    _musicButtonState = [_volumeButtonStateDefault objectForKey:MusicButtonStateDefault];
    
    if ([_musicButtonState isEqualToString:@"play"])
    {
        [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicon-default"] forState:UIControlStateNormal];
        [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicon-active"] forState:UIControlStateHighlighted];
        [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicon-active"] forState:UIControlStateSelected];
    }
    else if ([_musicButtonState isEqualToString:@"mute"])
    {
        [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicoff-default"] forState:UIControlStateNormal];
        [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicoff-default"] forState:UIControlStateHighlighted];
        [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicoff-default"] forState:UIControlStateSelected];
    }
    else
    {
        DebugLog(@"Missing musicButtonState: %@", _musicButtonState);
    }
}

- (void)hideButtons:(BOOL)hide
{
//    _restoreButtonView.hidden = hide;
    _accountButton.hidden = hide;
    _settingsButton.hidden = hide;
    _backButton.hidden = hide;
    _helpButton.hidden = hide;
    _shopButton.hidden = hide;
}

- (void)moveSubButtonsToCenter
{
    _shopButton.center = _mainButtonSpinnerView.center;
    _settingsButton.center = _mainButtonSpinnerView.center;
    _accountButton.center = _mainButtonSpinnerView.center;
    _helpButton.center = _mainButtonSpinnerView.center;
    _backButton.center = _mainButtonSpinnerView.center;
    
    _achievementButton.center = _mainButtonSpinnerView.center;
    _gameCenterButton.center = _mainButtonSpinnerView.center;
    _accountSliderView.center = _mainButtonSpinnerView.center;
    
    _soundButton.center = _mainButtonSpinnerView.center;
    _volumeButton.center = _mainButtonSpinnerView.center;
    _settingsSliderView.center = _mainButtonSpinnerView.center;
}

- (IBAction)mainButtonHit:(id)sender
{
    DebugLog(@"MainButtonHit");
    // If I am going up....
    if (_resize)
    {
        self.parentViewController.view.userInteractionEnabled = NO;
        self.view.userInteractionEnabled = NO;
        
        DebugLog(@"Resizing");
        _restoreButtonView.hidden = YES;
        _restoreButton.hidden = YES;
        _restoreTextLabel.hidden = YES;
        
        
        [self enableButtons:YES];
        _mainButtonIsDown = NO;
        _faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        
        _currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
        _mainViewStartFrame = self.view.frame;
        
        
        // Disable interaction so that the player can not spam the button or tap the background
        self.view.userInteractionEnabled = NO;
        self.parentViewController.view.userInteractionEnabled = NO;
        
        if ([self.delegate respondsToSelector:@selector(mainButtonIsAnimatingAndWillDisableInteraction:)])
        {
            [self.delegate mainButtonIsAnimatingAndWillDisableInteraction:YES];
        }
        
        // Set the origin point so that we can move back to our little corner
        _buttonOriginPoint = _subView.center;
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click 2" FileType:@"caf"]; //@"m4a"];
        
        // Move to center and scale main button
        [UIView animateWithDuration:0 animations:^{
            
            if (_currentOrientation == UIInterfaceOrientationPortrait)
            {
                _centerPoint = CGPointMake(CGRectGetMidX(_parentViewFrame), CGRectGetMidY(_parentViewFrame));
                self.view.frame = CGRectMake(_parentViewFrame.origin.x, _parentViewFrame.origin.y, _parentViewFrame.size.width, _parentViewFrame.size.height);
                self.view.center = _centerPoint;
                _subViewCenterPoint = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
            }
            else if (_currentOrientation == UIInterfaceOrientationLandscapeLeft)
            {
                _centerPoint = CGPointMake(CGRectGetMidY(_parentViewFrame), CGRectGetMidX(_parentViewFrame));
                self.view.frame = CGRectMake(_parentViewFrame.origin.y, _parentViewFrame.origin.x, _parentViewFrame.size.height, _parentViewFrame.size.width);
                self.view.center = _centerPoint;
                _subViewCenterPoint = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
            }
            else if (_currentOrientation == UIInterfaceOrientationLandscapeRight)
            {
                _centerPoint = CGPointMake(CGRectGetMidY(_parentViewFrame), CGRectGetMidX(_parentViewFrame));
                self.view.frame = CGRectMake(_parentViewFrame.origin.y, _parentViewFrame.origin.x, _parentViewFrame.size.height, _parentViewFrame.size.width);
                self.view.center = _centerPoint;
                _subViewCenterPoint = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
            }
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:.3 animations:^{
                
                _subView.frame = self.view.frame;
                _subView.center = _subViewCenterPoint;
                
                _mainButtonSpinnerView.transform = CGAffineTransformScale(_mainButtonSpinnerView.transform, .6, .6);

            } completion:^(BOOL finished) {
                
                [self moveSubButtonsToCenter];
                
                // Unhide the buttons
                [self hideButtons:NO];
                
                // Set where the buttons need to return to for later
                _startPoint = _subView.center;
                
                // Move the buttons to their new spots
                [self spinTheButtons];
                
                _resize = NO;
                
                self.view.userInteractionEnabled = YES;
                self.parentViewController.view.userInteractionEnabled = YES;
            }];
        }];
    }
    else // If I am going down....
    {
        DebugLog(@"Closing");
        if ([self.delegate respondsToSelector:@selector(mainButtonIsGoingDown)])
        {
            [self.delegate mainButtonIsGoingDown];
        }
        _mainButtonIsDown = YES;
        _faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        // Disable interaction so that the player can not spam the button
        self.view.userInteractionEnabled = NO;
        
        // Move the rest of the buttons back to the center
        [self spinTheButtons];
        
        _resize = YES;
    }
}

- (IBAction)backButtonHit:(id)sender
{
    DebugLog(@"Back");
    
    //[[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"m4a"];
    
    if (!_mainButtonIsDown)
    {
        if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
        {
            [self enableButtons:NO];
            
            [self.delegate mainButtonSubButtonWasHitWithIndex:backButtonIndex];
        }
//        [self mainButtonHit:_mainButton];
    }
}

- (IBAction)restoreButtonHit:(id)sender
{
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Restore InApp Purchases?"
                                                        message:@"Restore all prior non-consumable purchases to your player account."
                                                       delegate:self
                                              cancelButtonTitle:@"NO THANKS"
                                              otherButtonTitles:@"YES", nil];
    
    [alertView setTag:5];
    
    [alertView show];
}

- (IBAction)gameCenterButtonHit:(id)sender
{
    DebugLog(@"Game Center");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
    {
        [self.delegate mainButtonSubButtonWasHitWithIndex:gameCenterButtonIndex];
    }
}

- (IBAction)achievementButtonHit:(id)sender
{
    DebugLog(@"Achievements");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
    {
        [self.delegate mainButtonSubButtonWasHitWithIndex:achievementButtonIndex];
    }
}

- (IBAction)shopButtonHit:(id)sender
{
    DebugLog(@"Shop");
    
    //[[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"m4a"];
    
    if (!_mainButtonIsDown && !_popupIsUp)
    {
        [self mainButtonHit:_mainButton];
        
        if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
        {
            [self enableButtons:NO];
            
            [self.delegate mainButtonSubButtonWasHitWithIndex:shopButtonIndex];
        }
    }
}

// No Josh, just no. Don't do it.

- (IBAction)accountButtonHit:(id)sender
{
    DebugLog(@"Account");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if (!_mainButtonIsDown && !_popupIsUp)
    {
        _popupIsUp = YES;
        
        [self enableButtons:NO];
        
        if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
        {
            [self.delegate mainButtonSubButtonWasHitWithIndex:accountButtonIndex];
        }
    }
}

- (IBAction)facebookButtonHit:(id)sender
{
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    NSString *facebookMessage = @"Come join me in the Cookieverse!";
    NSString *facebookTitle = @"Cookie Dunk Dunk";
    
    if ([SGAppDelegate appDelegate].loggedInThroughFacebook)
    {
        [[SGSocialManager socialManager] SGSocialManagerDidShareFacebbokWithTitle:facebookTitle withMessage:facebookMessage withImage:nil withViewController:self completionHandler:^(BOOL didFinishSharing) {
            
        }];
    }
    else
    {
        [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Default presentationType:PresentationType_Loading withFrame:_conditionalViewFrame errorDescription:nil loadingText:nil];
        
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
                                                  
                                                  [[SGSocialManager socialManager] SGSocialManagerDidShareFacebbokWithTitle:facebookTitle withMessage:facebookMessage withImage:nil withViewController:weakSelf completionHandler:^(BOOL didFinishSharing) {
                                                      
                                                  }];
                                              });
                                          }
                                          else if (error)
                                          {
                                              [[SGAppDelegate appDelegate] dismissConditionalView];
                                              [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:weakSelf withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:weakSelf.conditionalViewFrame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  weakSelf.view.userInteractionEnabled = YES;
                                              });
                                          }
                                          else
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  weakSelf.view.userInteractionEnabled = YES;
                                              });
                                          }
                                      }];
                                      
                                      
                                      [[SGSocialManager socialManager] socialClassRequestAccessFriendsFromFacebook];
                                  }
                                  else if (error)
                                  {
                                      DebugLog(@"FACEBOOK ERROR => %@", [error localizedDescription]);
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [[SGAppDelegate appDelegate] dismissConditionalView];
                                      });
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
                 [[SGAppDelegate appDelegate] presentConditionalViewControllerWithParentController:self withConditionType:ConditionalType_Error presentationType:PresentationType_Error withFrame:_conditionalViewFrame errorDescription:[NSString stringWithFormat:@"An error has occurred: %@", error] loadingText:nil];
             }
    
         }];
    
     }
    
    
    if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
    {
        [self.delegate mainButtonSubButtonWasHitWithIndex:facebookButtonIndex];
    }
}

- (IBAction)googleButtonHit:(id)sender
{
    DebugLog(@"Google Plus");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
    {
        [self.delegate mainButtonSubButtonWasHitWithIndex:googleButtonIndex];
    }
}

- (IBAction)twitterButtonHit:(id)sender
{
    DebugLog(@"Twitter Button Hit");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    [[SGSocialManager socialManager] SGSocialManagerDidSendTweet:[SGSocialManager socialManager] UIViewController:self titleMessage:@"Cookie Dunk Dunk" bodyMessageOne:@"Come join me in the Cookieverse!" bodyMessagetwo:@"Join me in Cookie Dunk Dunk!" picture:nil completionHandler:^(BOOL didFinishSharing) {
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
    {
        [self.delegate mainButtonSubButtonWasHitWithIndex:twitterButtonIndex];
    }
}

- (IBAction)volumeButtonHit:(id)sender
{
    DebugLog(@"Volume");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if (!_mainButtonIsDown)
    {
        if ([_volumeButtonState isEqualToString:@"high"])
        {
            [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume1-default"] forState:UIControlStateNormal];
            [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume1-default"] forState:UIControlStateHighlighted];
            [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume1-default"] forState:UIControlStateSelected];
            
            [_volumeButtonStateDefault setObject:@"low" forKey:VolumeButtonStateDefault];
            [[SGAudioManager audioManager] updateAudioVolume];
        }
        else if ([_volumeButtonState isEqualToString:@"low"])
        {
            [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume0-default"] forState:UIControlStateNormal];
            [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume0-default"] forState:UIControlStateHighlighted];
            [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume0-default"] forState:UIControlStateSelected];
            
            [_volumeButtonStateDefault setObject:@"mute" forKey:VolumeButtonStateDefault];
            [[SGAudioManager audioManager] updateAudioVolume];
        }
        else if ([_volumeButtonState isEqualToString:@"mute"])
        {
            [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume2-default"] forState:UIControlStateNormal];
            [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume2-default"] forState:UIControlStateHighlighted];
            [_volumeButton setImage:[UIImage imageNamed:@"cdd-hud-btnvolume2-default"] forState:UIControlStateSelected];
            
            [_volumeButtonStateDefault setObject:@"high" forKey:VolumeButtonStateDefault];
            [[SGAudioManager audioManager] updateAudioVolume];
        }
        else
        {
            DebugLog(@"Missing volumeButtonState: %@", _volumeButtonState);
        }
        
        _volumeButtonState = [_volumeButtonStateDefault objectForKey:VolumeButtonStateDefault];
        
        if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
        {
            [self.delegate mainButtonSubButtonWasHitWithIndex:volumeButtonIndex];
        }
    }
}

- (IBAction)soundButtonHit:(id)sender
{
    DebugLog(@"Sound");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if (!_mainButtonIsDown)
    {
        if ([_musicButtonState isEqualToString:@"play"])
        {
            [_musicButtonStateDefault setObject:@"mute" forKey:MusicButtonStateDefault];
            [[SGAudioManager audioManager] updateMusicVolume];
            [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicoff-default"] forState:UIControlStateNormal];
            [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicoff-default"] forState:UIControlStateHighlighted];
            [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicoff-default"] forState:UIControlStateSelected];
        }
        else if ([_musicButtonState isEqualToString:@"mute"])
        {
            [_musicButtonStateDefault setObject:@"play" forKey:MusicButtonStateDefault];
            [[SGAudioManager audioManager] updateMusicVolume];
            [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicon-default"] forState:UIControlStateNormal];
            [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicon-active"] forState:UIControlStateHighlighted];
            [_soundButton setImage:[UIImage imageNamed:@"cdd-hud-btnmusicon-active"] forState:UIControlStateSelected];
        }
        else
        {
            DebugLog(@"Missing musicButtonState: %@", _musicButtonState);
        }

        _musicButtonState = [_musicButtonStateDefault objectForKey:MusicButtonStateDefault];
        
        if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
        {
            [self.delegate mainButtonSubButtonWasHitWithIndex:soundButtonIndex];
        }
    }
}

- (IBAction)settingsButtonHit:(id)sender
{
    DebugLog(@"Settings");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if (!_mainButtonIsDown && !_popupIsUp)
    {
        if (!_settingsSliderIsOut)
        {
            _settingsSliderView.hidden = NO;
            _volumeButton.hidden = NO;
            _soundButton.hidden = NO;
            
            _settingsSliderView.transform = CGAffineTransformMakeScale(1, 1);

            [UIView animateWithDuration:.2 animations:^{
                
                _settingsSliderView.frame = CGRectMake(_settingsSliderView.frame.origin.x, _settingsButton.center.y, _settingsSliderView.frame.size.width, _settingsSliderView.frame.size.height);
                _settingsSliderImage.transform = CGAffineTransformMakeScale(1, 1);
                _settingsSliderImage.image = [_settingsSliderImage.image resizableImageWithCapInsets:UIEdgeInsetsMake(17, 26, 17, 26)];

                _settingsSliderImage.frame = CGRectMake(0, 0, _settingsSliderImage.frame.size.width, 90);//CGRectMake(_settingsSliderImage.frame.origin.x, _settingsSliderImage.frame.origin.y, _settingsSliderImage.frame.size.width, 103);
                
                
                _volumeButton.center = CGPointMake(_settingsSliderView.center.x, _settingsSliderView.center.y);
                _soundButton.center = CGPointMake(_settingsSliderView.center.x, _settingsSliderView.center.y + (_settingsSliderView.frame.size.height * .5));
                
            } completion:^(BOOL finished) {
                
                
            }];
            _settingsSliderIsOut = YES;
        }
        else
        {
            [UIView animateWithDuration:.3 animations:^{
                
                _settingsSliderImage.transform = CGAffineTransformMakeScale(1, .1);
//                _settingsSliderImage.image = [_settingsSliderImage.image resizableImageWithCapInsets:UIEdgeInsetsMake(17, 26, 17, 26)];
                
//                _settingsSliderImage.frame = CGRectMake(_settingsSliderImage.frame.origin.x, _settingsSliderImage.frame.origin.y, _settingsSliderImage.frame.size.width, 73);
                
                _settingsSliderView.transform = CGAffineTransformMakeScale(1, .1);
                
                _settingsSliderView.center = CGPointMake(_settingsButton.center.x, _settingsButton.center.y + (_settingsSliderView.frame.size.height * .5));
                _volumeButton.center = CGPointMake(_settingsButton.center.x, _settingsButton.center.y);
                _soundButton.center = CGPointMake(_settingsButton.center.x, _settingsButton.center.y);
                
            } completion:^(BOOL finished) {
                
                _settingsSliderView.hidden = YES;
                _volumeButton.hidden = YES;
                _soundButton.hidden = YES;
                
            }];
            _settingsSliderIsOut = NO;
        }
        
        
        if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
        {
            [self.delegate mainButtonSubButtonWasHitWithIndex:settingsButtonIndex];
        }
    }
}

- (IBAction)helpButtonHit:(id)sender
{
    DebugLog(@"Help");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    if (!_popupIsUp && !_mainButtonIsDown)
    {
        _popupIsUp = YES;
        if ([self.delegate respondsToSelector:@selector(mainButtonSubButtonWasHitWithIndex:)])
        {
            [self.delegate mainButtonSubButtonWasHitWithIndex:helpButtonIndex];
        }
    }
    else
    {
        [self mainButtonHit:_mainButton];
    }
}

- (void)spinTheButtons
{
    DebugLog(@"SpinTheButtons");
    if (_resize)
    {
        DebugLog(@"Spin - Resize");
        _restoreButtonView.hidden = YES;
        _restoreButton.hidden = YES;
        _restoreTextLabel.hidden = YES;
        
        //                _googleButton.hidden = YES;
        _twitterButton.hidden = YES;
        _facebookButton.hidden = YES;
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Swoosh 4" FileType:@"caf"]; //@"m4a"];
        
        [UIView animateWithDuration:.3 animations:^{ // Display upper buttons
            
            _subView.transform = CGAffineTransformMakeRotation(M_PI*2);
            // WTF????
//            _mainButton.transform = CGAffineTransformMakeRotation(M_PI);
            
            NSUInteger buttonCount = [_subButtonArray count];
            
            for (int count = 0; count < buttonCount; count++)
            {
                [self plotThePathsForButton:[_subButtonArray objectAtIndex:count] atIndex:count];
            }
            
            _restoreButtonView.hidden = YES;
            _restoreButton.hidden = YES;
            _restoreTextLabel.hidden = YES;
            
            //                _googleButton.hidden = YES;
            _twitterButton.hidden = YES;
            _facebookButton.hidden = YES;
            
            _achievementButton.center = _accountButton.center;
            _gameCenterButton.center = _accountButton.center;
            _accountSliderView.center = _accountButton.center;
            
            _soundButton.center = _settingsButton.center;
            _volumeButton.center = _settingsButton.center;
            _settingsSliderView.center = _settingsButton.center;
            
            _twitterButton.center = CGPointMake(self.view.frame.size.width + (_twitterButton.frame.size.width * 1.2), self.view.frame.size.height - (_twitterButton.frame.size.height));
//            _googleButton.center = CGPointMake(_twitterButton.center.x + (_googleButton.frame.size.width * 1.2), self.view.frame.size.height - (_googleButton.frame.size.height ));
            _facebookButton.center = CGPointMake(_twitterButton.center.x + (_facebookButton.frame.size.width * 1.2), self.view.frame.size.height - (_facebookButton.frame.size.height ));//CGPointMake(_googleButton.center.x + (_facebookButton.frame.size.width * 1.2), self.view.frame.size.height - (_facebookButton.frame.size.height));
            _restoreButtonView.center = CGPointMake(self.view.frame.size.width + (_restoreButtonView.frame.size.width * 1.2), _twitterButton.center.y);
    
        } completion:^(BOOL finished) {
            
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Swoosh 3" FileType:@"caf"]; //@"m4a"];
            
            [UIView animateWithDuration:.3 animations:^{  // Display lower buttons.
               
                //_restoreButtonView.hidden = NO;
                //_restoreButton.hidden = NO;
                //_restoreTextLabel.hidden = NO;
                
//                _googleButton.hidden = NO;
                _twitterButton.hidden = NO;
                _facebookButton.hidden = NO;
                
                _twitterButton.center = CGPointMake(self.view.frame.size.width - (_twitterButton.frame.size.width * 1.2), self.view.frame.size.height - (_twitterButton.frame.size.height));
//                _googleButton.center = CGPointMake(_twitterButton.center.x - (_googleButton.frame.size.width * 1.2), self.view.frame.size.height - (_googleButton.frame.size.height));
                _facebookButton.center = CGPointMake(_twitterButton.center.x - (_facebookButton.frame.size.width * 1.2), self.view.frame.size.height - (_facebookButton.frame.size.height)); //CGPointMake(_googleButton.center.x - (_facebookButton.frame.size.width * 1.2), self.view.frame.size.height - (_googleButton.frame.size.height));
                _restoreButtonView.center = CGPointMake(0 + (_restoreButtonView.frame.size.width * 1.05), _twitterButton.center.y);
                
            } completion:^(BOOL finished) {
                
                self.view.userInteractionEnabled = YES;
                
            }];
        }];
    }
    else
    {
        DebugLog(@"Spin - closing");
        _faderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click 2" FileType:@"caf"]; //@"m4a"];
        
        [UIView animateWithDuration:.3 animations:^{
            
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Swoosh 3" FileType:@"caf"]; //@"m4a"];
            
            _twitterButton.center = CGPointMake(self.view.frame.size.width + (_twitterButton.frame.size.width * 1.2), self.view.frame.size.height - (_twitterButton.frame.size.height));
//            _googleButton.center = CGPointMake(_twitterButton.center.x + (_googleButton.frame.size.width * 1.2), self.view.frame.size.height - (_googleButton.frame.size.height));
            _facebookButton.center = CGPointMake(_twitterButton.center.x + (_facebookButton.frame.size.width * 1.2), self.view.frame.size.height - (_facebookButton.frame.size.height ));//CGPointMake(_googleButton.center.x + (_facebookButton.frame.size.width * 1.2), self.view.frame.size.height - (_facebookButton.frame.size.height));
            _restoreButtonView.center = CGPointMake(self.view.frame.size.width + (_restoreButtonView.frame.size.width * 1.2), _twitterButton.center.y);
            
        } completion:^(BOOL finished) {
            
            _restoreButtonView.hidden = YES;
            _restoreButton.hidden = YES;
            _restoreTextLabel.hidden = YES;
            
            _facebookButton.hidden = YES;
//            _googleButton.hidden = YES;
            _twitterButton.hidden = YES;
            
            self.view.frame = _mainViewStartFrame;
            [UIView animateWithDuration:.3 animations:^{
                
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Swoosh 3" FileType:@"caf"]; //@"m4a"];
                
                _subView.transform = CGAffineTransformMakeRotation(M_PI);
                // I hate rotations....
    //            _mainButton.transform = CGAffineTransformMakeRotation(M_PI*2);
                
                [self moveSubButtonsToCenter];
                
                
                if (_settingsSliderIsOut)
                {
                    [UIView animateWithDuration:.3 animations:^{
                        
                        _settingsSliderImage.transform = CGAffineTransformMakeScale(1, .1);
                        _settingsSliderView.transform = CGAffineTransformMakeScale(1, .1);
                        
                        _settingsSliderView.center = CGPointMake(_settingsButton.center.x, _settingsButton.center.y + (_settingsSliderView.frame.size.height * .5));
                        _volumeButton.center = CGPointMake(_settingsButton.center.x, _settingsButton.center.y);
                        _soundButton.center = CGPointMake(_settingsButton.center.x, _settingsButton.center.y);
                        
                    } completion:^(BOOL finished) {
                        
                        _settingsSliderView.hidden = YES;
                        _volumeButton.hidden = YES;
                        _soundButton.hidden = YES;
                        
                    }];
                    _settingsSliderIsOut = NO;
                }
                
                if (_accountSliderIsOut)
                {
                    [UIView animateWithDuration:.3 animations:^{
                        
                        _accountSliderImage.transform = CGAffineTransformMakeScale(1, .1);
                        _accountSliderView.transform = CGAffineTransformMakeScale(1, .1);
                        
                        _accountSliderView.center = CGPointMake(_accountButton.center.x, _accountButton.center.y - (_accountSliderView.frame.size.height * .5));
                        _achievementButton.center = CGPointMake(_accountButton.center.x, _accountButton.center.y);
                        _gameCenterButton.center = CGPointMake(_accountButton.center.x, _accountButton.center.y);
                        
                    } completion:^(BOOL finished) {
                        
                        _accountSliderView.hidden = YES;
                        _gameCenterButton.hidden = YES;
                        _achievementButton.hidden = YES;
                        
                    }];
                    _accountSliderIsOut = NO;
                }
                
            } completion:^(BOOL finished) {
                
                // Hide Buttons
                [self hideButtons:YES];
                
                [UIView animateWithDuration:.3 animations:^{
                    
                    // Move the subview back to the center
                    _subView.center = _buttonOriginPoint;
                    _mainButtonSpinnerView.transform = CGAffineTransformScale(_mainButtonSpinnerView.transform, 1/.6, 1/.6);
                    
                } completion:^(BOOL finished) {
                    
                    self.view.userInteractionEnabled = YES;
                    
                    if ([self.delegate respondsToSelector:@selector(mainButtonIsAnimatingAndWillDisableInteraction:)])
                    {
                        [self.delegate mainButtonIsAnimatingAndWillDisableInteraction:NO];
                    }
                }];
            }];
        }];
    }
}

- (void)plotThePathsForButton:(UIButton *)button atIndex:(int)index
{
    int radius = _mainButtonSpinnerView.frame.size.width * 1.2;
    float angle = 2 * M_PI / [_subButtonArray count];
    float tweakAngle = 1.25 / [_subButtonArray count];
    
    CGPoint point = CGPointMake(_mainButtonSpinnerView.center.x + radius * cos((index*angle) - (angle*tweakAngle)), _mainButtonSpinnerView.center.y + radius * sin((index*angle) - (angle*tweakAngle)));
    
    button.center = point;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 1)
        {
            [[CDIAPManager iapMananger] restoreInAppPurchases];
        }
    }
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)orientationHasChanged:(UIInterfaceOrientation)toInterfaceOrientation WithDuration:(NSTimeInterval)duration
{
    _currentOrientation = toInterfaceOrientation;
    
    [UIView animateWithDuration:duration animations:^{
        
        if (_currentOrientation == UIInterfaceOrientationPortrait)
        {
            if (!_resize)
            {
                _centerPoint = CGPointMake(CGRectGetMidX(_parentViewFrame), CGRectGetMidY(_parentViewFrame));
                self.view.frame = CGRectMake(_parentViewFrame.origin.x, _parentViewFrame.origin.y, _parentViewFrame.size.width, _parentViewFrame.size.height);
                self.view.center = _centerPoint;
                _subViewCenterPoint = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
                
                [self flipViewToOrientation];
            }
            
            _mainViewStartFrame = CGRectMake(0, _parentViewFrame.size.height - _viewSize, _viewSize, _viewSize);
        }
        else if (_currentOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            if (!_resize)
            {
                _centerPoint = CGPointMake(CGRectGetMidY(_parentViewFrame), CGRectGetMidX(_parentViewFrame));
                self.view.frame = CGRectMake(_parentViewFrame.origin.y, _parentViewFrame.origin.x, _parentViewFrame.size.height, _parentViewFrame.size.width);
                self.view.center = _centerPoint;
                _subViewCenterPoint = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
                
                [self flipViewToOrientation];
            }
            
            _mainViewStartFrame = CGRectMake(0, _parentViewFrame.size.width - _viewSize, _viewSize, _viewSize);
        }
        else if (_currentOrientation == UIInterfaceOrientationLandscapeRight)
        {
            if (!_resize)
            {
                _centerPoint = CGPointMake(CGRectGetMidY(_parentViewFrame), CGRectGetMidX(_parentViewFrame));
                self.view.frame = CGRectMake(_parentViewFrame.origin.y, _parentViewFrame.origin.x, _parentViewFrame.size.height, _parentViewFrame.size.width);
                self.view.center = _centerPoint;
                _subViewCenterPoint = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
                
                [self flipViewToOrientation];
            }
            
            _mainViewStartFrame = CGRectMake(0, _parentViewFrame.size.width - _viewSize, _viewSize, _viewSize);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)flipViewToOrientation
{
    _subView.frame = self.view.frame;
    _subView.center = _subViewCenterPoint;
    
    _twitterButton.center = CGPointMake(self.view.frame.size.width - (_twitterButton.frame.size.width * 1.2), self.view.frame.size.height - (_twitterButton.frame.size.height));
//    _googleButton.center = CGPointMake(_twitterButton.center.x - (_googleButton.frame.size.width * 1.2), self.view.frame.size.height - (_googleButton.frame.size.height));
    _facebookButton.center = CGPointMake(_twitterButton.center.x - (_facebookButton.frame.size.width * 1.2), self.view.frame.size.height - (_facebookButton.frame.size.height));//CGPointMake(_googleButton.center.x - (_facebookButton.frame.size.width * 1.2), self.view.frame.size.height - (_googleButton.frame.size.height));
    _restoreButtonView.center = CGPointMake(0 + (_restoreButtonView.frame.size.width * 1.05), _twitterButton.center.y);
    
    NSUInteger buttonCount = [_subButtonArray count];
    
    for (int count = 0; count < buttonCount; count++)
    {
        [self plotThePathsForButton:[_subButtonArray objectAtIndex:count] atIndex:count];
    }
    if (_settingsSliderIsOut)
    {
        _settingsSliderView.center = CGPointMake(_settingsButton.center.x, _settingsButton.center.y + (_settingsSliderView.frame.size.height * .5));
        _volumeButton.center = CGPointMake(_settingsSliderView.center.x, _settingsSliderView.center.y);
        _soundButton.center = CGPointMake(_settingsSliderView.center.x, _settingsSliderView.center.y + (_settingsSliderView.frame.size.height * .5));
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
