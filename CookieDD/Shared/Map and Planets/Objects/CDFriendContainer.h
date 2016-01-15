//
//  CDFriendContainer.h
//  CookieDD
//
//  Created by Nate on 8/14/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "MapTriggerObject.h"

typedef NS_ENUM(int, Location)
{
    Location_Left,
    Location_Right,
    Location_Above
};

@protocol CDFriendContainerDelegate;

@interface CDFriendContainer : MapTriggerObject

@property (assign, nonatomic) Location displayLocation;

//@property (assign, nonatomic) CGPoint originPosition;
//@property (assign, nonatomic) CGSize originalSize;
@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) BOOL openRight;

@property (strong, nonatomic) NSMutableArray *friendImages;
//@property (strong, nonatomic) NSMutableArray *originalPositionsArray;

- (void)animateOut:(CDFriendContainer *)friendContainer;
- (void)animateIn:(CDFriendContainer *)friendContainer;

@end

@protocol CDFriendContainerDelegate <NSObject>

@optional

- (void)friendContainerDidTrigger:(CDFriendContainer *)friendContainer;

@end

