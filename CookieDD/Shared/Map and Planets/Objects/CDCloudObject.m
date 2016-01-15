//
//  CDCloudObject.m
//  CookieDD
//
//  Created by Nate on 7/15/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDCloudObject.h"

@implementation CDCloudObject

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initAtPosition:(CGPoint)position {
    self = [super initAtPosition:position];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithImageNamed:(NSString *)backgroundImageString {
    self = [self initWithImageNamed:backgroundImageString AndPosition:CGPointZero];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithImageNamed:(NSString *)backgroundImageString AndPosition:(CGPoint)position {
    self = [super initWithImageNamed:backgroundImageString AndPosition:position];
    if (self) {
        self.startPosition = position;
    }
    
    return self;
}

//------------------------------------------------------------------------------
// Name:    initWithImageNamed: startPosition: endPosition
// Desc:    Initializes cloud object with a starting and ending animation position
//------------------------------------------------------------------------------
- (id)initWithImageNamed:(NSString *)image startPosition:(CGPoint)startPoint endPosition:(CGPoint)endPoint
{
    self = [super initWithImageNamed:image AndPosition:startPoint];
    if (self) {
        self.startPosition = startPoint;
        self.endPosition = endPoint;
    }
    return self;
}

//------------------------------------------------------------------------------
// Name:    animateCloud
// Desc:    Animates cloud along the x-axis from startPosition to endPosition
//------------------------------------------------------------------------------
- (void)animateCloud
{
    CAKeyframeAnimation *transformTranslateX = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    NSMutableArray *valuesX = [[NSMutableArray alloc] init];

    //DebugLog(@"AnimatePositions: %f, %f", self.startPosition.x, self.endPosition.x);
    [valuesX addObject:[NSNumber numberWithFloat:self.startPosition.x]];
    [valuesX addObject:[NSNumber numberWithFloat:self.endPosition.x]];
    //[valuesX addObject:[NSNumber numberWithFloat:self.frame.origin.x]];
    //[valuesX addObject:[NSNumber numberWithFloat:self.frame.origin.x + 300 ]];
    transformTranslateX.values = valuesX;
    transformTranslateX.duration = 3.0f;
    transformTranslateX.repeatCount = HUGE_VAL;
    //transformTranslateX.repeatCount = 1;
    transformTranslateX.autoreverses = YES;
    transformTranslateX.removedOnCompletion = NO;
    transformTranslateX.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:transformTranslateX forKey:@"transform"];
    
    // Create animation group to scale along with translation to create
    // zooming effect
    
}

- (void)removeFromView
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
