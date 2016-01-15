//
//  GinderDeadMen_DeathNode.h
//  CookieDD
//
//  Created by BLINDED AM ME on 2/7/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GinderDeadMen_DeathNode : SKNode


@property (strong, nonatomic) SKEmitterNode* bloodCloud;
@property (assign, nonatomic) float ground;

@property (strong, nonatomic) SKSpriteNode* body;
@property (strong, nonatomic) SKSpriteNode* leftArm;
@property (strong, nonatomic) SKSpriteNode* rightArm;
@property (strong, nonatomic) SKSpriteNode* leftLeg;
@property (strong, nonatomic) SKSpriteNode* rightLeg;

-(void)SetupDeathNode;

-(void)Splode;

@end
