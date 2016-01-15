//
//  CDSateliteObject.h
//  CookieDD
//
//  Created by Luke McDonald on 4/28/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "MapTriggerObject.h"
#import "CDPlanetoidObject.h"

@interface CDSateliteObject : MapTriggerObject <UIScrollViewDelegate>

@property (assign, nonatomic) CGPoint originPosition;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *hologramImageView;
@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (strong, nonatomic) UIScrollView *friendScrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) NSNumber *planetID;
@property (assign, nonatomic) NSString *planetDisplayName;

- (id)initSateliteWithPosition:(CDPlanetoidObject *)planetoid;
- (void)animateSatellite:(CDSateliteObject *)satellite;

@end
