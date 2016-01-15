//
//  CDBombSpriteNode.h
//  CookieDD
//
//  Created by BLINDED AM ME on 7/21/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDCookieSpriteNode.h"

@interface CDBombSpriteNode : CDCookieSpriteNode

@property(assign,nonatomic) int turnsLeft;
@property(assign,nonatomic) BOOL justDropped;

@property(strong, nonatomic) SKSpriteNode* spark;
@property(strong, nonatomic) SKLabelNode* countdown;

-(BOOL)Tick;

@end
