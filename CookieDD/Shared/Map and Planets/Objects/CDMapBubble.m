//
//  CDMapBubble.m
//  CookieDD
//
//  Created by Josh on 6/17/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDMapBubble.h"

@implementation CDMapBubble

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (id)initAtPosition:(CGPoint)position {
    self = [super initAtPosition:position];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithImageNamed:(NSString *)backgroundImageString AndPosition:(CGPoint)position {
    self = [super initWithImageNamed:backgroundImageString AndPosition:position];
    if (self) {
        //blah

    }
    
    return self;
}

- (void)setup {
    [super setup];
    self.levelType = LevelType_Locked;
    self.isUnlocked = NO;
    self.starCount = 0;
    self.highScore = 0;
    self.friendImageOrientation = @"";
}

- (void)createStarImageViews {
    
    for (int i = 0; i  < [self.starImageViewsArray count]; ++i) {
        [[self.starImageViewsArray objectAtIndex:i] removeFromSuperview];
    }
    
    UIImageView *star1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cdd-iso-leveldot-star01"]];
    //star1.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIImageView *star2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cdd-iso-leveldot-star02"]];
    //star2.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIImageView *star3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cdd-iso-leveldot-star03"]];
    //star3.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [star1 setFrame:self.subviewFrame];
    [star2 setFrame:self.subviewFrame];
    [star3 setFrame:self.subviewFrame];
    
    self.starImageViewsArray = [[NSArray alloc] initWithObjects:star1, star2, star3, nil];
    
    for (UIImageView *star in self.starImageViewsArray) {
        [self addSubview:star];
        [star setHidden:YES];
    }
}

#pragma mark - Custom Setters

- (void)setStarCount:(int)starCount {
    _starCount = starCount;

    for (int index = 0; index < [self.starImageViewsArray count]; index++) {
        UIImageView *star = self.starImageViewsArray[index];
        if (index < starCount) {
            [star setHidden:NO];
        }
        else {
            [star setHidden:YES];
        }
    }
}

//- (void)setIsUnlocked:(BOOL)isUnlocked {
//    _isUnlocked = isUnlocked;
//    
//}

- (void)setLevelType:(LevelType)levelType {
    _levelType = levelType;
    
    NSString *imageString = [NSString stringWithFormat:@"cdd-iso-leveldot-emptydot%02d", levelType];
    UIImage *newImage = [UIImage imageNamed:imageString];
    [self.backgroundImageView setImage:newImage];
    CGRect newFrame = CGRectMake(self.backgroundImageView.frame.origin.x,
                                 self.backgroundImageView.frame.origin.y,
                                 newImage.size.width * self.scale,
                                 newImage.size.height * self.scale);
    self.subviewFrame = newFrame;
    [self.backgroundImageView setFrame:newFrame];
    
    [self createStarImageViews];
    
    self.starCount = self.starCount;
}

//------------------------------------------------------------------------------
// Name:    setLevelNumber
// Desc:    Creates and SGStrokeLabel to display the level number on the bubble.
//------------------------------------------------------------------------------
- (void)setLevelNumber:(int)levelNumber
{
    _levelNumber = levelNumber;
    
    // SGStrokeLabel
    SGStrokeLabel *numberLabel = [SGStrokeLabel new];
    
    numberLabel.text = [NSString stringWithFormat:@"%i", levelNumber];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    //numberLabel.backgroundColor = [UIColor blueColor];
    
    // Set font and scale to bubble size
    [numberLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12 * self.scale]];
    [numberLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    // Position label in center of bubble
    numberLabel.frame = CGRectMake(self.position.x,
                                   self.position.y + 4,
                                   self.frame.size.width,
                                   self.frame.size.height);
    [self addSubview:numberLabel];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Show bubble overlay when bubble is touched
    [self.overlayImage setHidden:NO];
    [self.overlayImage setFrame:self.subviewFrame];
    [self addSubview:self.overlayImage];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Remove bubble overlay after touch
    [self.overlayImage setHidden:YES];
    [self.overlayImage removeFromSuperview];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Remove bubble overlay when touch is canceled
    [self.overlayImage setHidden:YES];
    [self.overlayImage removeFromSuperview];
}

#pragma mark - Delegate Calls

- (void)activateButton {
    if ([self.delegate respondsToSelector:@selector(mapBubbleDidTrigger:)]) {
        [self.delegate mapBubbleDidTrigger:self];
    }
}

@end
