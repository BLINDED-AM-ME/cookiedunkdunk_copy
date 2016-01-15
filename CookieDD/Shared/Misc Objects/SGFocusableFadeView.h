//
//  SGFocusableFadeView.h
//  CookieDD
//
//  Created by Josh on 8/11/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDTutorialDialogueViewController.h"

@protocol FocusableFadeViewDelegate;

@interface SGFocusableFadeView : UIView

@property (weak, nonatomic) id <FocusableFadeViewDelegate> delegate;


@property (strong, nonatomic, readonly) NSArray *currentlyFocusedViews;
@property (strong, nonatomic, readonly) NSMutableArray *currentlyFocusedPulses;
@property (strong, nonatomic, readonly) NSMutableArray *pages;
@property (assign, nonatomic, readonly) int currentPage;

@property (strong, nonatomic, readonly) UIImageView *assistantImageView;
@property (assign, nonatomic) float assistantScale;

@property (strong, nonatomic) CDTutorialDialogueViewController *dialogueViewController;



-(void)giveFocus:(NSArray*)views;
//-(void)removeFocus:(NSArray*)views;
-(void)clearAllViewsWithFocus;

-(void)addNewPageWithFocusedViews:(NSArray*)focusedViews
                   assistantImage:(UIImage*)assistantImage
                assistantPosition:(CGPoint)assistantPosition
                    dialogueFrame:(CGRect)dialogueFrame
                     dialogueText:(NSString*)dialogueText
           dialogueSpikeDirection:(DialogueSpikeDirection)dialogueSpikeDirection
              dialogueSpikeOffset:(float)dialogueSpikeOffset;

-(void)removePageAtIndex:(int)index;

-(void)startTutorial;
-(void)showPage:(int)pageNumber;

@end


@protocol FocusableFadeViewDelegate <NSObject>

@optional
-(void)focusableFadeView:(SGFocusableFadeView*)focusableFadeView movedToPage:(int)pageNumber pageDictionary:(NSDictionary*)pageDictionary;
-(void)focusableFadeViewFinishedPages:(SGFocusableFadeView*)focusableFadeView;

@end


