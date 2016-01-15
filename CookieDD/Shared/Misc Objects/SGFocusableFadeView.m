//
//  SGFocusableFadeView.m
//  CookieDD
//
//  Created by Josh on 8/11/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "SGFocusableFadeView.h"

@implementation SGFocusableFadeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}



- (void)setup {
    
      //////////////////////
     //  Default Values  //
    //////////////////////
    
    _currentlyFocusedViews = [NSArray new];
    _currentlyFocusedPulses = [NSMutableArray new];
    _pages = [NSMutableArray new];
    _currentPage = 0;
    
    _assistantScale = 1.0f;
    _assistantImageView = [UIImageView new];
    [self addSubview:_assistantImageView];
    
    _dialogueViewController = [CDTutorialDialogueViewController new];
    [self addSubview:_dialogueViewController.view];
    
    
    
      /////////////////////
     //  Setup Methods  //
    /////////////////////
    
    [self setupFade];
    [self setupTouchDetection];
}


- (void)setupFade {
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.backgroundColor = [UIColor colorWithRed:0.069 green:0.060 blue:0.127 alpha:0.850];
}



#pragma mark - Setters

- (void)setAssistantScale:(float)assistantScale {
    _assistantScale = assistantScale;
    
    _assistantImageView.frame = CGRectMake(_assistantImageView.frame.origin.x,
                                           _assistantImageView.frame.origin.y,
                                           _assistantImageView.frame.size.width * assistantScale,
                                           _assistantImageView.frame.size.height * assistantScale);
}



#pragma mark - Interaction

// Create the tap gesture recognizer which controls
// when the next page is displayed.
- (void)setupTouchDetection {
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleFingerTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    DebugLog(@"Tapped!!!");
    
    [self moveToNextPage];
}



#pragma mark - Focus Views

- (void)giveFocus:(NSArray *)views {
    
    // Wipe away all the currently focused views.
    [self clearAllViewsWithFocus];
    
    // Loop through each object in the array.
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSObject *object in views) {
        // Make sure this object is a UIView.
        if ([object isKindOfClass:[UIView class]]) {
            // Get a copy of the original view.
            UIView *view = (UIView *)object;
            id copyOfView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:view]];
            UIView *newView = (UIView *)copyOfView;
            
            // The view gets supersized if it's not a direct family member.
            if (![self.superview.subviews containsObject:view]) {
                DebugLog(@"Resizing view: %@", [newView class]);
                
                newView.frame = CGRectMake(newView.frame.origin.x / 2,
                                           newView.frame.origin.y / 2,
                                           newView.frame.size.width / 2,
                                           newView.frame.size.height / 2);
            }
            
            // Create the pulse that goes behind the view.
            // Problem: Some views have pulses that are off center.
            //[self createPulseForView:newView];
            
            // Place the new copy above the fade.
            [self addSubview:newView];
            
            // Hide the original
            view.hidden = YES;
            
            // Log references to both views.
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:view, @"originalView", newView, @"copiedView", nil];
            [tempArray addObject:dict];
        }
        else {
            DebugLog(@"Warning: Trying to give focus to incompatable object type: %@", [object class]);
        }
    }
    
    _currentlyFocusedViews = [NSArray arrayWithArray:tempArray];
}


- (void)createPulseForView:(UIView *)view {
    id copyOfView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:view]];
    UIView *pulseView = (UIView *)copyOfView;
    
    pulseView.autoresizingMask = UIViewAutoresizingNone;
    //pulseView.layer.anchorPoint = pulseView.center;
    pulseView.alpha = 0.75f;
//    pulseView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.3f];
    [UIView setAnimationRepeatCount:INFINITY];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    pulseView.alpha = 0.0f;
    pulseView.transform = CGAffineTransformMakeScale(1.4f, 1.4f); //CGAffineTransformScale(pulseView.transform, 1.4f, 1.4f);
    [UIView commitAnimations];
    
    [self addSubview:pulseView];
    
    
    
    
    [_currentlyFocusedPulses addObject:pulseView];
}


- (void)removeFocus:(NSArray *)views {
    // Hmm...
}


- (void)clearAllViewsWithFocus {
    
    // Clear the focused views.
    for (NSDictionary *dict in self.currentlyFocusedViews) {
        
        // Return the original view.
        UIView *originalView = dict[@"originalView"];
        originalView.hidden = NO;
        
        // Get rid of the local version.
        UIView *copiedView = dict[@"copiedView"];
        [copiedView removeFromSuperview];
    }
    
    // Clear the array.
    _currentlyFocusedViews = [NSArray new];
    
    
    // Clear the pulses.
    for (UIView *pulseView in _currentlyFocusedPulses) {
        [pulseView removeFromSuperview];
    }
    _currentlyFocusedPulses = [NSMutableArray new];
}



#pragma mark - Pages

- (void)addNewPageWithFocusedViews:(NSArray *)focusedViews
                    assistantImage:(UIImage *)assistantImage
                 assistantPosition:(CGPoint)assistantPosition
                     dialogueFrame:(CGRect)dialogueFrame
                      dialogueText:(NSString *)dialogueText
            dialogueSpikeDirection:(DialogueSpikeDirection)dialogueSpikeDirection
               dialogueSpikeOffset:(float)dialogueSpikeOffset {
    
    // This is the dictionary we'll save all the values in.
    NSMutableDictionary *pageDict = [NSMutableDictionary new];
    
    // Fill in the dictonary's values.
    if (focusedViews) {
        [pageDict setObject:focusedViews forKey:@"focusedViews"];
    }
    
    if (assistantImage) {
        [pageDict setObject:assistantImage forKey:@"assistantImage"];
    }
    
    if (dialogueText) {
        [pageDict setObject:dialogueText forKey:@"dialogueText"];
    }
    
    // These can't be nil, so no if's are necessary.
    [pageDict setObject:[NSValue valueWithCGPoint:assistantPosition] forKey:@"assistantPosition"];
    [pageDict setObject:[NSValue valueWithCGRect:dialogueFrame] forKey:@"dialogueFrame"];
    [pageDict setObject:[NSNumber numberWithInt:dialogueSpikeDirection] forKey:@"dialogueSpikeDirection"];
    [pageDict setObject:[NSNumber numberWithFloat:dialogueSpikeOffset] forKey:@"dialogueSpikeOffset"];
    
    // Add it to the list of pages.
    [_pages addObject:pageDict];
}


- (void)removePageAtIndex:(int)index {
    [_pages removeObjectAtIndex:index];
}



#pragma mark - Navigation

- (void)showPage:(int)pageNumber {
    NSDictionary *pageDict = _pages[pageNumber];
    
    // Show the desired views.
    [self clearAllViewsWithFocus];
    [self giveFocus:pageDict[@"focusedViews"]];
    
    // Show or hide the assistant.
    if (pageDict[@"assistantImage"]) {
        _assistantImageView.hidden = NO;
        [_assistantImageView setImage:pageDict[@"assistantImage"]];
        
        self.dialogueViewController.spikeIsHidden = NO;
    }
    else {
        _assistantImageView.hidden = YES;
        self.dialogueViewController.spikeIsHidden = YES;
    }
    
    // Move the assistant into position.
    CGPoint assistantPosition = [pageDict[@"assistantPosition"] CGPointValue];
    _assistantImageView.frame = CGRectMake(assistantPosition.x,
                                           assistantPosition.y,
                                           _assistantImageView.image.size.width * _assistantScale,
                                           _assistantImageView.image.size.height * _assistantScale);
    
    // Move and size the dialogue box.
    CGRect dialogueFrame = [pageDict[@"dialogueFrame"] CGRectValue];
    _dialogueViewController.view.frame = dialogueFrame;
    
    // Set the dialogue text.
    NSString *dialogueText = pageDict[@"dialogueText"];
    if (dialogueText && ![dialogueText isEqualToString:@""]) {
        _dialogueViewController.dialogueTextLabel.text = dialogueText;
        
        // Make sure the dialogue box is visible.
        _dialogueViewController.view.hidden = NO;
    }
    else {
        // If there's no text, then hide the dialogue box.
        _dialogueViewController.view.hidden = YES;
    }
    
    _dialogueViewController.spikeDirection = [pageDict[@"dialogueSpikeDirection"] intValue];
    _dialogueViewController.spikeOffset = [pageDict[@"dialogueSpikeOffset"] floatValue];
    
    // Update our delegate.
    if ([self.delegate respondsToSelector:@selector(focusableFadeView:movedToPage:pageDictionary:)]) {
        [self.delegate focusableFadeView:self movedToPage:pageNumber pageDictionary:pageDict];
    }
}


- (void)moveToNextPage {
    _currentPage += 1;
    
    if (self.currentPage < [self.pages count]) {
        DebugLog(@"Next Page");
        [self showPage:self.currentPage];
    }
    else {
        // Close the tutorial.
        DebugLog(@"Closing the tutorial.");
        _currentPage = 0;
        [self clearAllViewsWithFocus];
        
        // Update our delegate.
        if ([self.delegate respondsToSelector:@selector(focusableFadeViewFinishedPages:)]) {
            [self.delegate focusableFadeViewFinishedPages:self];
        }
    }
}


- (void)startTutorial {
    // Do whatever you need to, to get things rolling.
    [self showPage:0];
}


@end
