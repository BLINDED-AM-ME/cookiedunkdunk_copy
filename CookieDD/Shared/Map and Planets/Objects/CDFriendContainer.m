//
//  CDFriendContainer.m
//  CookieDD
//
//  Created by Nate on 8/14/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDFriendContainer.h"

@implementation CDFriendContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //_originPosition = self.frame.origin;
        //_originalSize = self.frame.size;
        
        self.friendImages = [[NSMutableArray alloc] init];
        //self.originalImagePositions = [[NSMutableArray alloc] init];
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
#pragma mark - Animations

- (void)animateOut:(CDFriendContainer *)friendContainer
{
    //DebugLog(@"Friend animateOut");
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf" volume:1.0f];
    
    [friendContainer setUserInteractionEnabled:NO];
    [friendContainer.superview bringSubviewToFront:friendContainer];
    
    if (friendContainer.openRight)
    {
        //DebugLog(@"Open Right");
        
        [UIView animateWithDuration:0.7 animations:^{
            
            CGPoint result = CGPointMake(0, 0);
            int angleOffSet = 20 * friendContainer.scale;
            double angle = DegreesToRadians(180 + (angleOffSet * ([friendContainer.friendImages count] - 1)));
            //double angle = DegreesToRadians(270);
            int radius = 70;
            //CGPoint centerPoint = CGPointMake(0, 0);
            CGPoint centerPoint = CGPointMake(radius, friendContainer.frame.size.height);
            //CGPoint centerPoint = CGPointMake(friendContainer.frame.origin.x + radius, friendContainer.frame.origin.y + friendContainer.frame.size.height);
//            UIView *center = [[UIView alloc] initWithFrame:CGRectMake(centerPoint.x, centerPoint.y, 2, 2)];
//            [center.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
//            [self addSubview:center];
            
            for (UIView *friend in friendContainer.friendImages)
            {
                CGRect newFrame = friend.frame;
                
                //CGPoint coords = CGPointMake(friend.frame.origin.x, friend.frame.origin.y);
                //[friendContainer.friendImagePositions addObject:[NSValue valueWithCGPoint:coords]];
                
                //newFrame.size = CGSizeMake(friend.frame.size.width, friend.frame.size.height);
                
                result.x = centerPoint.x + (radius * cos(angle));
                result.y = (radius * sin(angle));
                
//                UIView *point = [[UIView alloc] initWithFrame:CGRectMake(result.x, result.y, 2, 2)];
//                [point.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
//                [self addSubview:point];
//                
//                UILabel *angleLabel = [[UILabel alloc] initWithFrame:CGRectMake(result.x - 30, result.y - 10, 10, 10)];
//                angleLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
//                angleLabel.text = [NSString stringWithFormat:@"%.f", RadiansToDegrees(angle)];
//                angleLabel.textColor = [UIColor redColor];
//                [angleLabel sizeToFit];
//                [self addSubview:angleLabel];
                
                //newFrame.origin = CGPointMake(centerPoint.x + result.x, centerPoint.y + result.y);
                newFrame.origin = result;
                friend.frame = newFrame;
                
                //DebugLog(@"Angle: %f Result: %f %f CenterPoint: %f %f", angle, result.x, result.y, centerPoint.x, centerPoint.y);
                
                angle = angle - DegreesToRadians(angleOffSet);// * friendContainer.scale);
            }
        } completion:^(BOOL finished) {
            [self animateIn:friendContainer];
        }];
    }
    else
    {
        //DebugLog(@"Open Left");
        
        [UIView animateWithDuration:0.7 animations:^{
            
            CGPoint result = CGPointMake(0, 0);
            int angleOffSet = 20 * friendContainer.scale;
            double angle = DegreesToRadians(0);// (angleOffSet * ([friendContainer.friendImages count] - 1)));
            int radius = 70;
            //CGPoint centerPoint = CGPointMake(0, 0);
            CGPoint centerPoint = CGPointMake(-radius, friendContainer.frame.size.height);
//            UIView *center = [[UIView alloc] initWithFrame:CGRectMake(centerPoint.x, centerPoint.y, 2, 2)];
//            [center.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
//            [self addSubview:center];
            
            for (UIView *friend in [friendContainer.friendImages reverseObjectEnumerator])
            {
                CGRect newFrame = friend.frame;
                
                //CGPoint coords = CGPointMake(friend.frame.origin.x, friend.frame.origin.y);
                //[friendContainer.friendImagePositions addObject:[NSValue valueWithCGPoint:coords]];
                
                result.x = centerPoint.x + (radius * cos(angle));
                result.y = (radius * sin(angle));
                
//                UIView *point = [[UIView alloc] initWithFrame:CGRectMake(result.x, result.y, 2, 2)];
//                [point.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
//                [self addSubview:point];
//                
//                UILabel *angleLabel = [[UILabel alloc] initWithFrame:CGRectMake(result.x - 30, result.y, 10, 10)];
//                angleLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
//                angleLabel.text = [NSString stringWithFormat:@"%.f", RadiansToDegrees(angle)];
//                angleLabel.textColor = [UIColor redColor];
//                [angleLabel sizeToFit];
//                [self addSubview:angleLabel];
                
                newFrame.origin = result;
                friend.frame = newFrame;
                
                //DebugLog(@"Angle: %f Result: %f %f CenterPoint: %f %f", angle, result.x, result.y, centerPoint.x, centerPoint.y);
                
                angle = angle - DegreesToRadians(angleOffSet);
            }
        } completion:^(BOOL finished) {
            [self animateIn:friendContainer];
        }];
    }
}

- (void)animateIn:(CDFriendContainer *)friendContainer
{
    //DebugLog(@"Friend animateIn");
    [UIView animateWithDuration:0.7 delay:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        for (UIView *friend in friendContainer.friendImages)
        {
            CGRect newFrame = friend.frame;
            newFrame.origin = CGPointMake(0, 0);
            friend.frame = newFrame;
        }
    } completion:^(BOOL finished) {
        [friendContainer setUserInteractionEnabled:YES];
    }];
    
}

#pragma mark - Delegate

- (void)activateButton {
    if ([self.delegate respondsToSelector:@selector(friendContainerDidTrigger:)])
    {
        [self.delegate friendContainerDidTrigger:self];
    }
}


@end
