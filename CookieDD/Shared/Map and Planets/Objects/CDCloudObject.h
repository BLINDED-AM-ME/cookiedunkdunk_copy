//
//  CDCloudObject.h
//  CookieDD
//
//  Created by Nate on 7/15/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "MapObject.h"

@interface CDCloudObject : MapObject

@property (assign, nonatomic) CGPoint startPosition;
@property (assign, nonatomic) CGPoint endPosition;

- (id)initWithImageNamed:(NSString *)image startPosition:(CGPoint)startPoint endPosition:(CGPoint)endPoint;
- (void)animateCloud;
- (void)removeFromView;

@end
