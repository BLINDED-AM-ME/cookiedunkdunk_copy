//
//  CDMapBubble.h
//  CookieDD
//
//  Created by Josh on 6/17/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "MapTriggerObject.h"
#import "SGLabelNode.h"

typedef NS_ENUM(int, LevelType)
{
    LevelType_Locked,
    LevelType_Minigame,
    LevelType_ClearObjects,
    LevelType_Timed,
    LevelType_Score,
    LevelType_Ingredients
};

@protocol CDMapBubbleDelegate;

@interface CDMapBubble : MapTriggerObject

@property (assign, nonatomic) LevelType levelType;

@property (strong, nonatomic) NSArray *starImageViewsArray;

@property (assign, nonatomic) BOOL isUnlocked;
@property (assign, nonatomic) int starCount;
@property (assign, nonatomic) int highScore;

@property (assign, nonatomic) int levelNumber;
@property (assign, nonatomic) SGLabelNode *levelNumberLabel;

@property (weak, nonatomic) UIImageView *overlayImage;
@property (strong, nonatomic) UIImageView *friendImageView;
@property (strong, nonatomic) NSString *friendImageOrientation;

@end

@protocol CDMapBubbleDelegate <NSObject>

@optional
-(void)mapBubbleDidTrigger:(CDMapBubble*)mapBubble;

@end
