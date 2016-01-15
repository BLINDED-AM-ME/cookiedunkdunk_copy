//
//  CDAbductionBlockerObject.m
//  cowTest
//
//  Created by Gary Johnston on 7/19/14.
//  Copyright (c) 2014 Seven Gun Games Productions. All rights reserved.
//

// Used for collision body paths: http://dazchong.com/spritekit/

#import "CDAbductionBlockerObject.h"
#import "CDAbductionScene.h"

@interface CDAbductionBlockerObject()

@property (assign, nonatomic) int attemptToAddCount;

@end


@implementation CDAbductionBlockerObject

- (id)initWithBlockerType:(NSString *)blockerType WithScene:(SKScene *)scene
{
    CDAbductionBlockerObject *blockerNode = [CDAbductionBlockerObject new];
    blockerNode.name = @"blockerNode";
    blockerNode.attemptToAddCount = 0;
    
    CDAbductionScene *cdScene = (CDAbductionScene *)scene;
    
    
    
    SKSpriteNode *shadow;
    
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    if ([blockerType isEqualToString:Blocker_BarnLeft])
    {
        int randNum = arc4random() % [cdScene.leftBarnPositionArray count];
        
        blockerNode.blockerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_barn01"];
        blockerNode.blockerObject.name = Blocker_BarnLeft;
        
        CGPoint point = [[cdScene.leftBarnPositionArray objectAtIndex:randNum] CGPointValue];
        blockerNode.position = [cdScene convertPoint:point toNode:cdScene.fieldObject];
        
        // Kill all overlapping
        if ((point.x == 121) && (point.y == 106))
        {
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(128, 93)]];
            [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(112, 141)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(113, 119)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(143, 67)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(102, 171)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(194, 126)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(161, 65)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(187, 112)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(129, 192)]];
        }
        else if ((point.x == 168) && (point.y == 154))
        {
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(226, 171)]];
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(128, 93)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(113, 119)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(143, 67)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(102, 171)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(194, 126)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(161, 65)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(187, 112)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(129, 192)]];
        }
        else if ((point.x == 121) && (point.y == 243))
        {
            [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(102, 227)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(102, 171)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(129, 192)]];
        }
        else if ((point.x == 242) && (point.y == 99))
        {
            [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(340, 100)]];
            [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(351, 159)]];
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(315, 87)]];
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(226, 171)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(282, 66)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(283, 139)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(194, 126)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(187, 112)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(161, 65)]];
        }
        else if ((point.x == 227) && (point.y == 243))
        {
            [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(338, 244)]];
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(266, 234)]];
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(226, 171)]];
            [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(267, 204)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(301, 219)]];
        }
        
        // Physics body collision path
        offsetX = blockerNode.blockerObject.frame.size.width * blockerNode.blockerObject.anchorPoint.x;
        offsetY = blockerNode.blockerObject.frame.size.height * blockerNode.blockerObject.anchorPoint.y;
        
        CGPathMoveToPoint(path, NULL, 29 - offsetX, 148 - offsetY);
        CGPathAddLineToPoint(path, NULL, 7 - offsetX, 120 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 87 - offsetY);
        CGPathAddLineToPoint(path, NULL, 10 - offsetX, 30 - offsetY);
        CGPathAddLineToPoint(path, NULL, 65 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 116 - offsetX, 30 - offsetY);
        CGPathAddLineToPoint(path, NULL, 121 - offsetX, 88 - offsetY);
        CGPathAddLineToPoint(path, NULL, 108 - offsetX, 107 - offsetY);
        CGPathAddLineToPoint(path, NULL, 55 - offsetX, 137 - offsetY);
        
        
        shadow = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_barn01shad"];
        shadow.position = [cdScene.fieldObject convertPoint:CGPointMake(blockerNode.position.x - (blockerNode.blockerObject.frame.size.width * .20), blockerNode.position.y - (blockerNode.blockerObject.frame.size.height * .47)) toNode:cdScene];
        shadow.zPosition = -1000;
        [cdScene addChild:shadow];
    }
    else if ([blockerType isEqualToString:Blocker_BarnRight])
    {
        int randNum = arc4random() % [cdScene.rightBarnPositionArray count];
        
        blockerNode.blockerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_barn02"];
        blockerNode.blockerObject.name = Blocker_BarnRight;
        
        
        CGPoint point = [[cdScene.rightBarnPositionArray objectAtIndex:randNum] CGPointValue];
        blockerNode.position = [cdScene convertPoint:point toNode:cdScene.fieldObject];
        
        if ((point.x == 340) && (point.y == 100))
        {
            [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(242, 99)]];
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(315, 87)]];
            [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(350, 144)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(282, 66)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(283, 139)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(392, 100)]];
        }
        else if ((point.x == 436) && (point.y == 100))
        {
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(429, 154)]];
            [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(441, 74)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(463, 173)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(443, 68)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(392, 100)]];
        }
        else if ((point.x == 351) && (point.y == 159))
        {
            [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(242, 99)]];
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(429, 154)]];
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(266, 234)]];
            [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(350, 144)]];
            [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(267, 204)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(283, 139)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(301, 219)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(347, 213)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(392, 100)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(297, 183)]];
        }
        else if ((point.x == 338) && (point.y == 244))
        {
            [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(227, 243)]];
            [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(266, 234)]];
            [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(350, 144)]];
            [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(267, 204)]];
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(301, 219)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(347, 213)]];
            [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(297, 183)]];
        }
        else if ((point.x == 438) && (point.y == 244))
        {
            [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(463, 173)]];
            [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(347, 213)]];
        }
        
        // Physics body collision path
        offsetX = blockerNode.blockerObject.frame.size.width * blockerNode.blockerObject.anchorPoint.x;
        offsetY = blockerNode.blockerObject.frame.size.height * blockerNode.blockerObject.anchorPoint.y;
        
        CGPathMoveToPoint(path, NULL, 86 - offsetX, 150 - offsetY);
        CGPathAddLineToPoint(path, NULL, 61 - offsetX, 138 - offsetY);
        CGPathAddLineToPoint(path, NULL, 12 - offsetX, 107 - offsetY);
        CGPathAddLineToPoint(path, NULL, -1 - offsetX, 90 - offsetY);
        CGPathAddLineToPoint(path, NULL, 7 - offsetX, 30 - offsetY);
        CGPathAddLineToPoint(path, NULL, 59 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 112 - offsetX, 30 - offsetY);
        CGPathAddLineToPoint(path, NULL, 118 - offsetX, 87 - offsetY);
        CGPathAddLineToPoint(path, NULL, 110 - offsetX, 123 - offsetY);
        
        
        shadow = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_barn02shad"];
        shadow.position = [cdScene.fieldObject convertPoint:CGPointMake(blockerNode.position.x - (blockerNode.blockerObject.frame.size.width * .17), blockerNode.position.y - (blockerNode.blockerObject.frame.size.height * .54)) toNode:cdScene];
        shadow.zPosition = -1000;
        [cdScene addChild:shadow];
    }
    else if ([blockerType isEqualToString:Blocker_HayLeft])
    {
        if ([cdScene.leftHayPositionArray count] > 0)
        {
            int randNum = arc4random() % [cdScene.leftHayPositionArray count];
            
            blockerNode.blockerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_haystack01"];
            blockerNode.blockerObject.name = Blocker_HayLeft;
            
            CGPoint point = [[cdScene.leftHayPositionArray objectAtIndex:randNum] CGPointValue];
            blockerNode.position = [cdScene convertPoint:point toNode:cdScene.fieldObject];
            
            if ((point.x == 113) && (point.y == 119))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(121, 106)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(168, 154)]];
                [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(128, 93)]];
                [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(112, 141)]];
                [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(143, 67)]];
                [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(102, 171)]];
            }
            else if ((point.x == 282) && (point.y == 66))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(242, 99)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(340, 100)]];
                [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(315, 87)]];
            }
            else if ((point.x == 283) && (point.y == 139))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(242, 99)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(351, 159)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(340, 100)]];
                [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(226, 171)]];
                [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(315, 83)]];
                [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(297, 183)]];
            }
            else if ((point.x == 301) && (point.y == 219))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(227, 243)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(338, 244)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(351, 159)]];
                [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(266, 234)]];
                [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(267, 204)]];
                [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(347, 213)]];
                [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(297, 183)]];
            }
            else if ((point.x == 463) && (point.y == 173))
            {
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(436, 100)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(438, 244)]];
                [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(429, 154)]];
            }
            
            
            // Physics body collision path
            offsetX = blockerNode.blockerObject.frame.size.width * blockerNode.blockerObject.anchorPoint.x;
            offsetY = blockerNode.blockerObject.frame.size.height * blockerNode.blockerObject.anchorPoint.y;
            
            CGPathMoveToPoint(path, NULL, 31 - offsetX, 63 - offsetY);
            CGPathAddLineToPoint(path, NULL, 49 - offsetX, 54 - offsetY);
            CGPathAddLineToPoint(path, NULL, 61 - offsetX, 15 - offsetY);
            CGPathAddLineToPoint(path, NULL, 36 - offsetX, 1 - offsetY);
            CGPathAddLineToPoint(path, NULL, 11 - offsetX, 5 - offsetY);
            CGPathAddLineToPoint(path, NULL, 0 - offsetX, 21 - offsetY);
            CGPathAddLineToPoint(path, NULL, 11 - offsetX, 53 - offsetY);
            
            
            shadow = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_haystack01shad"];
            shadow.position = [cdScene.fieldObject convertPoint:CGPointMake(blockerNode.position.x - (blockerNode.blockerObject.frame.size.width * .17), blockerNode.position.y - (blockerNode.blockerObject.frame.size.height * .47)) toNode:cdScene];
            shadow.zPosition = -1000;
            [cdScene addChild:shadow];
        }
    }
    else if ([blockerType isEqualToString:Blocker_HayRight])
    {
        if ([cdScene.rightHayPositionArray count] > 0)
        {
            int randNum = arc4random() % [cdScene.rightHayPositionArray count];
            
            blockerNode.blockerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_haystack02"];
            blockerNode.blockerObject.name = Blocker_HayRight;
            
            
            CGPoint point = [[cdScene.rightHayPositionArray objectAtIndex:randNum] CGPointValue];
            blockerNode.position = [cdScene convertPoint:point toNode:cdScene.fieldObject];
            
            if ((point.x == 143) && (point.y == 67))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(121, 106)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(168, 154)]];
                [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(128, 93)]];
                [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(113, 119)]];
                [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(161, 65)]];
            }
            else if ((point.x == 102) && (point.y == 171))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(121, 106)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(168, 154)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(121, 243)]];
                [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(112, 141)]];
                [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(113, 119)]];
                [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(129, 192)]];
            }
            else if ((point.x == 194) && (point.y == 126))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(168, 154)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(121, 106)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(242, 99)]];
                [cdScene.rockPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(187, 112)]];
            }
            else if ((point.x == 347) && (point.y == 213))
            {
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(338, 244)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(351, 159)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(438, 244)]];
                [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(301, 219)]];
            }
            else if ((point.x == 443) && (point.y == 68))
            {
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(436, 100)]];
                [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(441, 74)]];
            }
            
            
            // Physics body collision path
            offsetX = blockerNode.blockerObject.frame.size.width * blockerNode.blockerObject.anchorPoint.x;
            offsetY = blockerNode.blockerObject.frame.size.height * blockerNode.blockerObject.anchorPoint.y;
            
            CGPathMoveToPoint(path, NULL, 34 - offsetX, 64 - offsetY);
            CGPathAddLineToPoint(path, NULL, 60 - offsetX, 39 - offsetY);
            CGPathAddLineToPoint(path, NULL, 61 - offsetX, 18 - offsetY);
            CGPathAddLineToPoint(path, NULL, 53 - offsetX, 6 - offsetY);
            CGPathAddLineToPoint(path, NULL, 35 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, NULL, 15 - offsetX, 6 - offsetY);
            CGPathAddLineToPoint(path, NULL, 3 - offsetX, 16 - offsetY);
            CGPathAddLineToPoint(path, NULL, 8 - offsetX, 44 - offsetY);
            CGPathAddLineToPoint(path, NULL, 12 - offsetX, 59 - offsetY);
            
            
            shadow = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_haystack02shad"];
            shadow.position = [cdScene.fieldObject convertPoint:CGPointMake(blockerNode.position.x - (blockerNode.blockerObject.frame.size.width * .17), blockerNode.position.y - (blockerNode.blockerObject.frame.size.height * .47)) toNode:cdScene];
            shadow.zPosition = -1000;
            [cdScene addChild:shadow];
        }
    }
    else if ([blockerType isEqualToString:Blocker_Rock])
    {
        if ([cdScene.rockPositionArray count] > 0)
        {
            int randNum = arc4random() % [cdScene.rockPositionArray count];
            
            blockerNode.blockerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_rock01"];
            blockerNode.blockerObject.name = Blocker_Rock;
            
            CGPoint point = [[cdScene.rockPositionArray objectAtIndex:randNum] CGPointValue];
            blockerNode.position = [cdScene convertPoint:point toNode:cdScene.fieldObject];
            
            if ((point.x == 161) && (point.y == 65))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(121, 106)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(242, 99)]];
                
                [cdScene.leftFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(128, 93)]];
                
                [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(143, 67)]];
            }
            else if ((point.x == 187) && (point.y == 112))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(121, 106)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(168, 154)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(242, 99)]];
                
                [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(194, 126)]];
            }
            else if ((point.x == 129) && (point.y == 192))
            {
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(121, 243)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(121, 106)]];
                [cdScene.leftBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(168, 154)]];
                
                [cdScene.leftHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(102, 171)]];
            }
            else if ((point.x == 297) && (point.y == 183))
            {
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(351, 159)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(338, 244)]];
                
                [cdScene.rightFencePositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(267, 204)]];
                
                [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(283, 139)]];
                [cdScene.rightHayPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(301, 219)]];
            }
            else if ((point.x == 392) && (point.y == 100))
            {
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(240, 100)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(436, 100)]];
                [cdScene.rightBarnPositionArray removeObject:[NSValue valueWithCGPoint:CGPointMake(351, 159)]];
            }
            
            // Physics body collision path
            offsetX = blockerNode.blockerObject.frame.size.width * blockerNode.blockerObject.anchorPoint.x;
            offsetY = blockerNode.blockerObject.frame.size.height * blockerNode.blockerObject.anchorPoint.y;
            
            CGPathMoveToPoint(path, NULL, 27 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, NULL, 63 - offsetX, 18 - offsetY);
            CGPathAddLineToPoint(path, NULL, 67 - offsetX, 9 - offsetY);
            CGPathAddLineToPoint(path, NULL, 45 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, NULL, 33 - offsetX, 2 - offsetY);
            CGPathAddLineToPoint(path, NULL, 18 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, NULL, 8 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, NULL, 1 - offsetX, 5 - offsetY);
            CGPathAddLineToPoint(path, NULL, 1 - offsetX, 12 - offsetY);
            
            
            shadow = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_rock01shad"];
            shadow.position = [cdScene.fieldObject convertPoint:CGPointMake(blockerNode.position.x - (blockerNode.blockerObject.frame.size.width * .5), blockerNode.position.y - (blockerNode.blockerObject.frame.size.height * .5)) toNode:cdScene];
            shadow.zPosition = -1000;
            [cdScene addChild:shadow];
        }
    }
    else if ([blockerType isEqualToString:Blocker_FenceLeft])
    {
        if ([cdScene.leftHayPositionArray count] > 0)
        {
            int randNum = arc4random() % [cdScene.leftHayPositionArray count];
            
            blockerNode.blockerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_fence01"];
            blockerNode.blockerObject.name = Blocker_FenceLeft;
            
            CGPoint point = [[cdScene.leftFencePositionArray objectAtIndex:randNum] CGPointValue];
            blockerNode.position = [cdScene convertPoint:point toNode:cdScene.fieldObject];
            
        
            // Physics body collision path
            offsetX = blockerNode.blockerObject.frame.size.width * blockerNode.blockerObject.anchorPoint.x;
            offsetY = blockerNode.blockerObject.frame.size.height * blockerNode.blockerObject.anchorPoint.y;
            
            CGPathMoveToPoint(path, NULL, 0 - offsetX, 29 - offsetY);
            CGPathAddLineToPoint(path, NULL, 66 - offsetX, 61 - offsetY);
            CGPathAddLineToPoint(path, NULL, 64 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, NULL, 5 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, NULL, 1 - offsetX, 1 - offsetY);
            
            
            shadow = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_fence01shad"];
            shadow.position = [cdScene.fieldObject convertPoint:CGPointMake(blockerNode.position.x - (blockerNode.blockerObject.frame.size.width * .12), blockerNode.position.y - (blockerNode.blockerObject.frame.size.height * .35)) toNode:cdScene];
            shadow.zPosition = -1000;
            [cdScene addChild:shadow];
        }
    }
    else if ([blockerType isEqualToString:Blocker_FenceRight])
    {
        if ([cdScene.rightHayPositionArray count] > 0)
        {
            int randNum = arc4random() % [cdScene.rightHayPositionArray count];
            
            blockerNode.blockerObject = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_fence02"];
            blockerNode.blockerObject.name = Blocker_FenceRight;
            
            CGPoint point = [[cdScene.rightFencePositionArray objectAtIndex:randNum] CGPointValue];
            blockerNode.position = [cdScene convertPoint:point toNode:cdScene.fieldObject];
            
        
            // Physics body collision path
            offsetX = blockerNode.blockerObject.frame.size.width * blockerNode.blockerObject.anchorPoint.x;
            offsetY = blockerNode.blockerObject.frame.size.height * blockerNode.blockerObject.anchorPoint.y;
            
            CGPathMoveToPoint(path, NULL, 7 - offsetX, 61 - offsetY);
            CGPathAddLineToPoint(path, NULL, 67 - offsetX, 28 - offsetY);
            CGPathAddLineToPoint(path, NULL, 65 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, NULL, 57 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, NULL, 0 - offsetX, 31 - offsetY);
            CGPathAddLineToPoint(path, NULL, 1 - offsetX, 57 - offsetY);
            
            
            shadow = [SKSpriteNode spriteNodeWithImageNamed:@"cdd_alienmini_block_fence02shad"];
            shadow.position = [cdScene.fieldObject convertPoint:CGPointMake(blockerNode.position.x - (blockerNode.blockerObject.frame.size.width * .12), blockerNode.position.y - (blockerNode.blockerObject.frame.size.height * .35)) toNode:cdScene];
            shadow.zPosition = -1000;
            [cdScene addChild:shadow];
        }
    }
    else
    {
        // Physics body collision path
        offsetX = 0;
        offsetY = 0;
        
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, 0, 0);
    }
    
    CGPathCloseSubpath(path);
    
    if (blockerNode.blockerObject)
    {
        blockerNode.blockerObject.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        blockerNode.blockerObject.physicsBody.categoryBitMask = blockerCollisionCategory;
        blockerNode.blockerObject.physicsBody.contactTestBitMask = cowCollisionCategory;
        blockerNode.blockerObject.physicsBody.collisionBitMask = cowCollisionCategory;
        blockerNode.blockerObject.physicsBody.dynamic = NO;
        blockerNode.blockerObject.physicsBody.allowsRotation = NO;
        
        blockerNode.zPosition = - 1 * blockerNode.position.y;
        [blockerNode addChild:blockerNode.blockerObject];
    }
    return blockerNode;
}

@end
