//
//  CDHowtoPopup.m
//  CookieDD
//
//  Created by BLINDED AM ME on 4/20/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDHowtoPopup.h"

@implementation CDHowtoPopup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)setup:(NSString *)piece
{
    [_backbuttonText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
    [_backbuttonText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_nextbuttonText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
    [_nextbuttonText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];

    
    [_SuperText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_SuperText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    

    [_wrapText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_wrapText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_ingredientText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_ingredientText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];

    [_glassText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_glassText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_icecreamText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_icecreamText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_lightningText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_lightningText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_nukeText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_nukeText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];

    [_smorerText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_smorerText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_spatulaText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_spatulaText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
  
    [_powerText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_powerText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_slotText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:23]];
    [_slotText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];

    [_sprinkleText setFont:[UIFont fontWithName:kFontDamnNoisyKids size:18]];
    [_sprinkleText setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    
    
    _currentFrame = 0;
    _lastFrame = 0;
    
    if([piece isEqualToString:@"Match"]){
        
        _basicFrames = @[
                         _supersView,
                         _wrappersView,
                         _smoresView,
                         _theNukeView,
                         _lightningView,
                         _powerPunchView
                         ];
        
        UIView* firstframe = _basicFrames[0];
        firstframe.hidden = NO;
        
        _lastFrame = (int)_basicFrames.count-1;
        
        _backbutton.hidden = YES;
        _backbuttonText.hidden = YES;
        
    }else
    if([piece isEqualToString:@"Glass"]){
        
        _basicFrames = @[
                         _glasscasesView,
                         _spatulaView
                         ];
        
        UIView* firstframe = _basicFrames[0];
        firstframe.hidden = NO;
        
        _lastFrame = (int)_basicFrames.count-1;
        
        _backbutton.hidden = YES;
        _backbuttonText.hidden = YES;
        
    }else
    if([piece isEqualToString:@"Ice Cream"]){
        
        _icreamView.hidden = NO;
        _backbutton.hidden = YES;
        _backbuttonText.hidden = YES;
        
        _nextbuttonText.text = @"Done";
        
    }else
    if([piece isEqualToString:@"Ing. Drop"]){
        
        _ingredientsView.hidden = NO;
        _backbutton.hidden = YES;
        _backbuttonText.hidden = YES;
        
        _nextbuttonText.text = @"Done";
        
    }else
    if([piece isEqualToString:@"RAD"]){
        
        _sprinklesView.hidden = NO;
        _backbutton.hidden = YES;
        _backbuttonText.hidden = YES;
        
        _nextbuttonText.text = @"Done";
    }else
    if([piece isEqualToString:@"SLOT"]){
        
        _slotMachineView.hidden = NO;
        _backbutton.hidden = YES;
        _backbuttonText.hidden = YES;
        
        _nextbuttonText.text = @"Done";
    }else
    if([piece isEqualToString:@"WRAP"]){
        
        _wrappersView.hidden = NO;
        _backbutton.hidden = YES;
        _backbuttonText.hidden = YES;
        
        _nextbuttonText.text = @"Done";
    }

    
}

-(IBAction)Next:(id)sender{
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click 2" FileType:@"caf"]; //@"m4a"];
    
    if(_currentFrame == _lastFrame){
        [self removeFromSuperview];
        return;
    }
    
    UIView* previous = _basicFrames[_currentFrame];
    previous.hidden = YES;
    _currentFrame++;
    UIView* next = _basicFrames[_currentFrame];
    next.hidden = NO;
    
    _backbutton.hidden = NO;
    _backbuttonText.hidden = NO;
    
    if(_currentFrame == _lastFrame){
        _nextbuttonText.text = @"Done";
    }
    
}

-(IBAction)Back:(id)sender{
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"]; //@"m4a"];
    
    UIView* previous = _basicFrames[_currentFrame];
    previous.hidden = YES;
    _currentFrame--;
    UIView* next = _basicFrames[_currentFrame];
    next.hidden = NO;
    
    
    if(_currentFrame == 0){
        
        _backbutton.hidden = YES;
        _backbuttonText.hidden = YES;
    }

    _nextbuttonText.text = @"Next";
    
}

@end
