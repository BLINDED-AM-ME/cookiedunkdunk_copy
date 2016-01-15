//
//  CDStandardPopupView.m
//  CookieDD
//
//  Created by gary johnston on 3/20/14.
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

#import "CDStandardPopupView.h"

@interface CDStandardPopupView()

@property (assign, nonatomic) int helpScreenOpen;
@property (assign, nonatomic) BOOL dontKillAnimation;

@property (strong, nonatomic) NSArray *handAnimationArray;

@end




@implementation CDStandardPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)setup
{
    if ([_whatAmILoading isEqualToString:@"leaderboard"])
    {
        _leaderboardView.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        _mainGameHelpScreen1View.hidden = YES;
        _mainGameHelpScreen2View.hidden = YES;
        _mainGameHelpScreen3View.hidden = YES;
        
        _cookieCookerHelpScreen1View.hidden = YES;
        _cookieCookerHelpScreen2View.hidden = YES;
        _cookieCookerHelpScreen3View.hidden = YES;
        
        _cookieDropHelpScreen1View.hidden = YES;
        
        _abductionMinigameHelpScreenView.hidden = YES;
        
        _leaderboardView.hidden = NO;
        
        _nextTextLabel.hidden = YES;
        _nextButton.hidden = YES;
        _backTextLabel.hidden = YES;
        _backButton.hidden = YES;
    }
    else if ([_whatAmILoading isEqualToString:@"mainGameHelp"])
    {
        _helpScreenOpen = 1;
        _dontKillAnimation = YES;
        _handAnimationArray = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"cdd-hud-insthand01"],
                               [UIImage imageNamed:@"cdd-hud-insthand02"],
                               [UIImage imageNamed:@"cdd-hud-insthand03"],
                               [UIImage imageNamed:@"cdd-hud-insthand04"],
                               [UIImage imageNamed:@"cdd-hud-insthand05"],
                               [UIImage imageNamed:@"cdd-hud-insthand06"],
                               [UIImage imageNamed:@"cdd-hud-insthand07"],
                               [UIImage imageNamed:@"cdd-hud-insthand08"],
                               [UIImage imageNamed:@"cdd-hud-insthand09"],
                               [UIImage imageNamed:@"cdd-hud-insthand10"],
                               [UIImage imageNamed:@"cdd-hud-insthand11"],
                               [UIImage imageNamed:@"cdd-hud-insthand12"],
                               [UIImage imageNamed:@"cdd-hud-insthand13"],
                               [UIImage imageNamed:@"cdd-hud-insthand14"],
                               [UIImage imageNamed:@"cdd-hud-insthand15"],
                               [UIImage imageNamed:@"cdd-hud-insthand16"],
                               [UIImage imageNamed:@"cdd-hud-insthand17"],
                               [UIImage imageNamed:@"cdd-hud-insthand17"],
                               [UIImage imageNamed:@"cdd-hud-insthand18"],
                               [UIImage imageNamed:@"cdd-hud-insthand18"],
                               [UIImage imageNamed:@"cdd-hud-insthand18"],
                               [UIImage imageNamed:@"cdd-hud-insthand18"],
                               [UIImage imageNamed:@"cdd-hud-insthand19"],
                               [UIImage imageNamed:@"cdd-hud-insthand20"],
                               [UIImage imageNamed:@"cdd-hud-insthand21"],
                               [UIImage imageNamed:@"cdd-hud-insthand01"], nil];
        
        
        [_nextTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
        [_nextTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_backTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
        [_backTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_howToPlayLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
        [_howToPlayLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
        
        [_howToPlayText2 setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
        [_howToPlayText2 setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
        
        [_howToPlay3 setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
        [_howToPlay3 setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
        
        _mainGameHelpScreen1View.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        _mainGameHelpScreen2View.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        _mainGameHelpScreen3View.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        _mainGameHelpScreen1View.hidden = NO;
        _mainGameHelpScreen2View.hidden = YES;
        _mainGameHelpScreen3View.hidden = YES;
        
        _cookieCookerHelpScreen1View.hidden = YES;
        _cookieCookerHelpScreen2View.hidden = YES;
        _cookieCookerHelpScreen3View.hidden = YES;
        
        _cookieDropHelpScreen1View.hidden = YES;
        
        _abductionMinigameHelpScreenView.hidden = YES;
        
        _leaderboardView.hidden = YES;
        
        [self handAnimation];
    }
    else if ([_whatAmILoading isEqualToString:@"cookieCookerHelp"])
    {
        _helpScreenOpen = 1;
        
        [_nextTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
        [_nextTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_backTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
        [_backTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_cookieCookerHelpScreen1HowToPlay setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
        [_cookieCookerHelpScreen1HowToPlay setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
        
        [_cookieCookerHelpScreen2HowToPlay setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
        [_cookieCookerHelpScreen2HowToPlay setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
        
        [_cookieCookerHelpScreen3HowToPlay setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
        [_cookieCookerHelpScreen3HowToPlay setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
        
        _cookieCookerHelpScreen1View.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        _cookieCookerHelpScreen2View.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        _cookieCookerHelpScreen3View.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        _mainGameHelpScreen1View.hidden = YES;
        _mainGameHelpScreen2View.hidden = YES;
        _mainGameHelpScreen3View.hidden = YES;
        
        _cookieCookerHelpScreen1View.hidden = NO;
        _cookieCookerHelpScreen2View.hidden = YES;
        _cookieCookerHelpScreen3View.hidden = YES;
        
        _cookieDropHelpScreen1View.hidden = YES;
        
        _abductionMinigameHelpScreenView.hidden = YES;
        
        _leaderboardView.hidden = YES;
        
//        [self handAnimation];
    }
    else if ([_whatAmILoading isEqualToString:@"cookieDropHelp"])
    {
        _helpScreenOpen = 1;
        
        [_nextTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
        [_nextTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_backTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
        [_backTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_cookieDropHelpScreen1HowToPlay setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
        [_cookieDropHelpScreen1HowToPlay setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
        
        _cookieDropHelpScreen1View.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        _mainGameHelpScreen1View.hidden = YES;
        _mainGameHelpScreen2View.hidden = YES;
        _mainGameHelpScreen3View.hidden = YES;
        
        _cookieCookerHelpScreen1View.hidden = YES;
        _cookieCookerHelpScreen2View.hidden = YES;
        _cookieCookerHelpScreen3View.hidden = YES;
        
        _cookieDropHelpScreen1View.hidden = NO;
        
        _abductionMinigameHelpScreenView.hidden = YES;
        
        _leaderboardView.hidden = YES;
        
        _nextTextLabel.text = @"OK";
        [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-default"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateHighlighted];
        [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateSelected];
        
//        [self handAnimation];
    }
    else if ([_whatAmILoading isEqualToString:@"cowAbductionHelp"])
    {
        _helpScreenOpen = 1;
        
        [_nextTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
        [_nextTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_backTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:15]];
        [_backTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_abductionMinigameSceenHowToPlay setFont:[UIFont fontWithName:kFontDamnNoisyKids size:30]];
        [_abductionMinigameSceenHowToPlay setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
        
        _abductionMinigameHelpScreenView.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        _mainGameHelpScreen1View.hidden = YES;
        _mainGameHelpScreen2View.hidden = YES;
        _mainGameHelpScreen3View.hidden = YES;
        
        _cookieCookerHelpScreen1View.hidden = YES;
        _cookieCookerHelpScreen2View.hidden = YES;
        _cookieCookerHelpScreen3View.hidden = YES;
        
        _cookieDropHelpScreen1View.hidden = YES;
        
        _abductionMinigameHelpScreenView.hidden = NO;
        
        _leaderboardView.hidden = YES;
        
        _nextTextLabel.text = @"OK";
        [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-default"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateHighlighted];
        [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateSelected];
    }
}

- (void)handAnimation
{
    _handPointerImage.animationImages = [NSArray arrayWithArray:_handAnimationArray];
    _handPointerImage.animationDuration = 1.5;
    _handPointerImage.animationRepeatCount = 0;
    [_handPointerImage startAnimating];
}

- (void)setFadeViewToTransparent:(BOOL)isTransparent
{
    if (isTransparent)
    {
        _fadeView.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    else
    {
        _fadeView.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:.7];
    }
}

- (void)exitHelp
{
    _dontKillAnimation = NO;
    [_handPointerImage.layer removeAllAnimations];
    if ([self.delegate respondsToSelector:@selector(exitButtonWasHitOnStandardPopupView:)])
    {
        [self.delegate exitButtonWasHitOnStandardPopupView:self];
    }
}

- (IBAction)nextButtonHit:(id)sender
{
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click 2" FileType:@"caf"];
    
    if ([_whatAmILoading isEqualToString:@"mainGameHelp"])
    {
        if (_helpScreenOpen == 1)
        {
            _mainGameHelpScreen1View.hidden = YES;
            _mainGameHelpScreen2View.hidden = NO;
            _mainGameHelpScreen3View.hidden = YES;
            
            _backTextLabel.text = @"BACK";
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarorange-default"] forState:UIControlStateNormal];
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarorange-active"] forState:UIControlStateHighlighted];
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarorange-active"] forState:UIControlStateSelected];
            
            _helpScreenOpen++;
        }
        else if (_helpScreenOpen == 2)
        {
            _mainGameHelpScreen1View.hidden = YES;
            _mainGameHelpScreen2View.hidden = YES;
            _mainGameHelpScreen3View.hidden = NO;
            
            _nextTextLabel.text = @"OK";
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-default"] forState:UIControlStateNormal];
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateHighlighted];
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateSelected];
            
            _helpScreenOpen++;
        }
        else if (_helpScreenOpen == 3)
        {
            [self exitHelp];
        }
    }
    else if ([_whatAmILoading isEqualToString:@"cookieCookerHelp"])
    {
        if (_helpScreenOpen == 1)
        {
            _cookieCookerHelpScreen1View.hidden = YES;
            _cookieCookerHelpScreen2View.hidden = NO;
            _cookieCookerHelpScreen3View.hidden = YES;
            
            _backTextLabel.text = @"BACK";
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarorange-default"] forState:UIControlStateNormal];
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarorange-active"] forState:UIControlStateHighlighted];
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarorange-active"] forState:UIControlStateSelected];
            
            _helpScreenOpen++;
        }
        else if (_helpScreenOpen == 2)
        {
            _cookieCookerHelpScreen1View.hidden = YES;
            _cookieCookerHelpScreen2View.hidden = YES;
            _cookieCookerHelpScreen3View.hidden = NO;
            
            _nextTextLabel.text = @"OK";
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-default"] forState:UIControlStateNormal];
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateHighlighted];
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateSelected];
            
            _helpScreenOpen++;
        }
        else if (_helpScreenOpen == 3)
        {
            [self exitHelp];
        }
    }
    else if ([_whatAmILoading isEqualToString:@"cookieDropHelp"])
    {
        [self exitHelp];
    }
    else if ([_whatAmILoading isEqualToString:@"cowAbductionHelp"])
    {
        [self exitHelp];
    }
    else
    {
        DebugLog(@"There is a missing check for next button in standard popup");
    }
}

- (IBAction)backButtonHit:(id)sender
{
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"];
    
    if ([_whatAmILoading isEqualToString:@"mainGameHelp"])
    {
        if (_helpScreenOpen == 1)
        {
            [self exitHelp];
        }
        else if (_helpScreenOpen == 2)
        {
            _backTextLabel.text = @"CLOSE";
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarred-default"] forState:UIControlStateNormal];
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarred-active"] forState:UIControlStateHighlighted];
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarred-active"] forState:UIControlStateSelected];
            
            _mainGameHelpScreen1View.hidden = NO;
            _mainGameHelpScreen2View.hidden = YES;
            _mainGameHelpScreen3View.hidden = YES;
            
            _helpScreenOpen--;
        }
        else if (_helpScreenOpen == 3)
        {
            _mainGameHelpScreen1View.hidden = YES;
            _mainGameHelpScreen2View.hidden = NO;
            _mainGameHelpScreen3View.hidden = YES;
            
            _nextTextLabel.text = @"NEXT";
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-default"] forState:UIControlStateNormal];
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateHighlighted];
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateSelected];
            
            _helpScreenOpen--;
        }
    }
    else if ([_whatAmILoading isEqualToString:@"cookieCookerHelp"])
    {
        if (_helpScreenOpen == 1)
        {
            [self exitHelp];
        }
        else if (_helpScreenOpen == 2)
        {
            _backTextLabel.text = @"CLOSE";
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarred-default"] forState:UIControlStateNormal];
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarred-active"] forState:UIControlStateHighlighted];
            [_backButton setImage:[UIImage imageNamed:@"cdd-hud-sbarred-active"] forState:UIControlStateSelected];
            
            _cookieCookerHelpScreen1View.hidden = NO;
            _cookieCookerHelpScreen2View.hidden = YES;
            _cookieCookerHelpScreen3View.hidden = YES;
            
            _helpScreenOpen--;
        }
        else if (_helpScreenOpen == 3)
        {
            _cookieCookerHelpScreen1View.hidden = YES;
            _cookieCookerHelpScreen2View.hidden = NO;
            _cookieCookerHelpScreen3View.hidden = YES;
            
            _nextTextLabel.text = @"NEXT";
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-default"] forState:UIControlStateNormal];
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateHighlighted];
            [_nextButton setImage:[UIImage imageNamed:@"cdd-hud-sbargreen-active"] forState:UIControlStateSelected];
            
            _helpScreenOpen--;
        }
    }
    else if ([_whatAmILoading isEqualToString:@"cookieDropHelp"])
    {
        [self exitHelp];
    }
    else if ([_whatAmILoading isEqualToString:@"cowAbductionHelp"])
    {
        [self exitHelp];
    }
    else
    {
        DebugLog(@"There is a missing check for back button in standard popup");
    }
}

- (IBAction)exitButtonHit:(id)sender
{
    [self exitHelp];
}

- (IBAction)gameCenterButtonHit:(id)sender
{
    DebugLog(@"I am not quite sure what this does yet.... I'll deal with it later");
}

@end
