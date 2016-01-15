//
//  CDAbductionBlockerObject.h
//  cowTest
//
//  Created by Gary Johnston on 7/19/14.
//  Copyright (c) 2014 Seven Gun Games Productions. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CDAbductionBlockerObject : SKNode

@property (strong, nonatomic) SKSpriteNode *blockerObject;

- (id)initWithBlockerType:(NSString *)blockerType WithScene:(SKScene *)scene;

@end
