//
//  CDSateliteObject.m
//  CookieDD
//
//  Created by Luke McDonald on 4/28/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDSateliteObject.h"

@interface CDSateliteObject ()
@property (assign, nonatomic) CGRect planetoidRect;
@end

@implementation CDSateliteObject

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initSateliteWithPosition:(CDPlanetoidObject *)planetoid{
    
    self = [super initWithImageNamed:@"cdd-map-satellite" AndPosition:CGPointMake(planetoid.frame.origin.x + planetoid.frame.size.width, planetoid.frame.origin.y /*-(planetoid.frame.origin.y*0.1f)*/)];
    self.planetoidRect = planetoid.frame;
    if (self)
    {
        _isSelected = YES;
        
        // Store planet associated with satellite
        _planetID = planetoid.planetID;
        _planetDisplayName = planetoid.displayName;
        
        _friendsArray = [[NSMutableArray alloc] init];
        _friendScrollView = [[UIScrollView alloc] init];
        _pageControl = [[UIPageControl alloc] init];
        
    }
    
    return self;
}


#pragma mark - Table View Delegate

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    else{
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    cell.textLabel.text=[NSString stringWithFormat:@"Cell %d",indexPath.row+1];
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

#pragma mark - Animate Satelite around Planetoid
- (void)animateSatellite:(CDSateliteObject *)satellite
{
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
        //satellite.frame = CGRectOffset(satellite.frame, 0, -10);
        satellite.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -5);
        satellite.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.97, 0.97);
        
//        CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -10);
//        CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
//        satellite.transform = CGAffineTransformConcat(translate, scale);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Touch Events
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugLog(@"Satellite: Touches Ended");
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageHeight = scrollView.frame.size.height;
    int page = scrollView.contentOffset.y / pageHeight;
    self.pageControl.currentPage = page;
}


@end
