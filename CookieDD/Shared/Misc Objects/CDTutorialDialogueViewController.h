//
//  CDTutorialDialogueViewController.h
//  CookieDD
//
//  Created by Josh on 7/29/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"


typedef NS_ENUM(NSInteger, DialogueSpikeDirection) {
    DialogueSpikeDirectionUpLeft = 0,
    DialogueSpikeDirectionUpRight,
    DialogueSpikeDirectionDownLeft,
    DialogueSpikeDirectionDownRight,
    DialogueSpikeDirectionLeftUp,
    DialogueSpikeDirectionLeftDown,
    DialogueSpikeDirectionRightUp,
    DialogueSpikeDirectionRightDown,
};


@interface CDTutorialDialogueViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *dialogueBoxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *dialogueSpikeImageView;
@property (weak, nonatomic) IBOutlet THLabel *dialogueTextLabel;

@property (assign, nonatomic) DialogueSpikeDirection spikeDirection;
@property (assign, nonatomic) float spikeOffset;
@property (assign, nonatomic) BOOL spikeIsHidden;

@property (assign, nonatomic) CGPoint position;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float height;

@end
