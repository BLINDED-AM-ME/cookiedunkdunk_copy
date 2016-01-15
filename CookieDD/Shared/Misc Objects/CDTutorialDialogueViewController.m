//
//  CDTutorialDialogueViewController.m
//  CookieDD
//
//  Created by Josh on 7/29/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDTutorialDialogueViewController.h"

@interface CDTutorialDialogueViewController ()

@end

@implementation CDTutorialDialogueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setup {

    // Default Values
    _spikeOffset = 52.0f;
    self.spikeDirection = DialogueSpikeDirectionDownLeft;
}


#pragma mark = Paramater Setters

- (void)setSpikeDirection:(DialogueSpikeDirection)spikeDirection {
    DebugLog(@"Setting spike direction.");
    CGAffineTransform spikeReflection;
    CGAffineTransform spikeRotation;
    CGRect frame = CGRectZero;
    
    switch (spikeDirection) {
        case DialogueSpikeDirectionUpLeft:
            
            // Set the transforms.
            spikeReflection = CGAffineTransformMakeScale(1.0f, -1.0f);
            spikeRotation = CGAffineTransformMakeRotation(DegreesToRadians(0.0f));
            
            // Move the spike to the correct edge.
            frame = CGRectMake(self.spikeOffset,
                               0.0f,
                               self.dialogueSpikeImageView.frame.size.width,
                               self.dialogueSpikeImageView.frame.size.height);
            self.dialogueSpikeImageView.frame = frame;
            
            // Lock the spike to that position.
            self.dialogueSpikeImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
            break;
            
            // >--------------------------------------------------------------------------------------------------
            
        case DialogueSpikeDirectionUpRight:
            
            // Set the transforms.
            spikeReflection = CGAffineTransformMakeScale(-1.0f, -1.0f);
            spikeRotation = CGAffineTransformMakeRotation(DegreesToRadians(0.0f));
            
            // Move the spike to the correct edge.
            frame = CGRectMake(self.spikeOffset,
                               0.0f,
                               self.dialogueSpikeImageView.frame.size.width,
                               self.dialogueSpikeImageView.frame.size.height);
            self.dialogueSpikeImageView.frame = frame;
            
            // Lock the spike to that position.
            self.dialogueSpikeImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
            break;
            
            // >--------------------------------------------------------------------------------------------------
            
        case DialogueSpikeDirectionDownLeft:
            
            // Set the transforms.
            spikeReflection = CGAffineTransformMakeScale(1.0f, 1.0f);
            spikeRotation = CGAffineTransformMakeRotation(DegreesToRadians(0.0f));
            
            // Move the spike to the correct edge.
            frame = CGRectMake(self.spikeOffset,
                               self.view.frame.size.height - self.dialogueSpikeImageView.frame.size.height,
                               self.dialogueSpikeImageView.frame.size.width,
                               self.dialogueSpikeImageView.frame.size.height);
            self.dialogueSpikeImageView.frame = frame;
            
            // Lock the spike to that position.
            self.dialogueSpikeImageView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin);
            break;
            
            // >--------------------------------------------------------------------------------------------------
            
        case DialogueSpikeDirectionDownRight:
            
            // Set the transforms.
            spikeReflection = CGAffineTransformMakeScale(-1.0f, 1.0f);
            spikeRotation = CGAffineTransformMakeRotation(DegreesToRadians(0.0f));
            
            // Move the spike to the correct edge.
            frame = CGRectMake(self.spikeOffset,
                               self.view.frame.size.height - self.dialogueSpikeImageView.frame.size.height,
                               self.dialogueSpikeImageView.frame.size.width,
                               self.dialogueSpikeImageView.frame.size.height);
            self.dialogueSpikeImageView.frame = frame;
            
            // Lock the spike to that position.
            self.dialogueSpikeImageView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin);
            break;
            
            // >--------------------------------------------------------------------------------------------------
            
        case DialogueSpikeDirectionLeftUp:
            
            // Set the transforms.
            spikeReflection = CGAffineTransformMakeScale(1.0f, 1.0f);
            spikeRotation = CGAffineTransformMakeRotation(DegreesToRadians(90.0f));
            
            // Move the spike to the correct edge.
            frame = CGRectMake(0.0f,
                               self.spikeOffset,
                               self.dialogueSpikeImageView.frame.size.width,
                               self.dialogueSpikeImageView.frame.size.height);
            self.dialogueSpikeImageView.frame = frame;
            
            // Lock the spike to that position.
            self.dialogueSpikeImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
            break;
            
            // >--------------------------------------------------------------------------------------------------
            
        case DialogueSpikeDirectionLeftDown:
            
            // Set the transforms.
            spikeReflection = CGAffineTransformMakeScale(-1.0f, 1.0f);
            spikeRotation = CGAffineTransformMakeRotation(DegreesToRadians(90.0f));
            
            // Move the spike to the correct edge.
            frame = CGRectMake(0.0f,
                               self.spikeOffset,
                               self.dialogueSpikeImageView.frame.size.width,
                               self.dialogueSpikeImageView.frame.size.height);
            self.dialogueSpikeImageView.frame = frame;
            
            // Lock the spike to that position.
            self.dialogueSpikeImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
            break;
            
            // >--------------------------------------------------------------------------------------------------
            
        case DialogueSpikeDirectionRightUp:
            
            // Set the transforms.
            spikeReflection = CGAffineTransformMakeScale(-1.0f, 1.0f);
            spikeRotation = CGAffineTransformMakeRotation(DegreesToRadians(270.0f));
            
            // Move the spike to the correct edge.
            frame = CGRectMake(self.view.frame.size.width - self.dialogueSpikeImageView.frame.size.width,
                               self.spikeOffset,
                               self.dialogueSpikeImageView.frame.size.width,
                               self.dialogueSpikeImageView.frame.size.height);
            self.dialogueSpikeImageView.frame = frame;
            
            // Lock the spike to that position.
            self.dialogueSpikeImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin);
            break;
            
            // >--------------------------------------------------------------------------------------------------
            
        case DialogueSpikeDirectionRightDown:
            
            // Set the transforms.
            spikeReflection = CGAffineTransformMakeScale(1.0f, 1.0f);
            spikeRotation = CGAffineTransformMakeRotation(DegreesToRadians(270.0f));
            
            // Move the spike to the correct edge.
            frame = CGRectMake(self.view.frame.size.width - self.dialogueSpikeImageView.frame.size.width,
                               self.spikeOffset,
                               self.dialogueSpikeImageView.frame.size.width,
                               self.dialogueSpikeImageView.frame.size.height);
            self.dialogueSpikeImageView.frame = frame;
            
            // Lock the spike to that position.
            self.dialogueSpikeImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin);
            break;
            
            // >--------------------------------------------------------------------------------------------------
            
        default:
            // Down-Left
            
            // Set the transforms.
            spikeReflection = CGAffineTransformMakeScale(1.0f, 1.0f);
            spikeRotation = CGAffineTransformMakeRotation(DegreesToRadians(0.0f));
            
            // Move the spike to the correct edge.
            frame = CGRectMake(self.spikeOffset,
                               self.view.frame.size.height - self.dialogueSpikeImageView.frame.size.height,
                               self.dialogueSpikeImageView.frame.size.width,
                               self.dialogueSpikeImageView.frame.size.height);
            self.dialogueSpikeImageView.frame = frame;
            
            // Lock the spike to that position.
            self.dialogueSpikeImageView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin);
            break;
    }
    
    CGAffineTransform spikeTransform = CGAffineTransformConcat(spikeReflection, spikeRotation);
    self.dialogueSpikeImageView.transform = spikeTransform;
    _spikeDirection = spikeDirection;
}


- (void)setSpikeOffset:(float)spikeOffset {
    _spikeOffset = spikeOffset;
    
    // Redraw the spike.
    [self setSpikeDirection:self.spikeDirection];
}

- (void)setSpikeIsHidden:(BOOL)spikeIsHidden {
    _spikeIsHidden = spikeIsHidden;
    
    self.dialogueSpikeImageView.hidden = spikeIsHidden;
}

- (void)setPosition:(CGPoint)position {
    _position = position;
    
    CGRect newFrame = self.view.frame;
    newFrame.origin = position;
    self.view.frame = newFrame;
}

- (void)setWidth:(float)width {
    _width = width;
    
    CGRect newFrame = self.view.frame;
    newFrame.size.width = width;
    self.view.frame = newFrame;
}

- (void)setHeight:(float)height {
    _height = height;
    
    CGRect newFrame = self.view.frame;
    newFrame.size.height = height;
    self.view.frame = newFrame;
}



@end
