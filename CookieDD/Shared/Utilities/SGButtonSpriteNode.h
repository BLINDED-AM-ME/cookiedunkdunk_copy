//
//  SGButtonSpriteNode.h
//  CookieDD
//
//  Created by Josh on 8/5/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol SGButtonSpriteNodeDelegate;

@interface SGButtonSpriteNode : SKSpriteNode

@property (weak, nonatomic) id <SGButtonSpriteNodeDelegate> delegate;
@property (assign, nonatomic) NSNumber *tag;
@property (strong, nonatomic) SKLabelNode *textLabel;


@end





@protocol SGButtonSpriteNodeDelegate <NSObject>

@optional
-(void)buttonSpriteNodeWasSelected:(SGButtonSpriteNode*)button;

@end
