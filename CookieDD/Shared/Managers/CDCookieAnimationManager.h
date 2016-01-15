//
//  CDCookieAnimationManager.h
//  CookieDD
//
//  Created by BLINDED AM ME on 5/19/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CDGameBoardSpriteNode.h"

@interface CDCookieAnimationManager : SKNode

@property (strong, nonatomic) NSMutableArray *superCookieTextures;

+ (CDCookieAnimationManager *)animationManager;

-(void)loadCookieAnimations;

-(void)SetupSuperLooks;

-(void)CleanOutSuperStuff;

#pragma mark - Sprite animations

-(void)PlayCharacterAnimation:(CDGameBoardSpriteNode*)cookie;

-(void)PlayIdleAnimation:(CDGameBoardSpriteNode*)cookie;

-(void)PlaySwitchAnimation:(CDGameBoardSpriteNode*)cookie;

-(void)PlaySwitchBackAnimation:(CDGameBoardSpriteNode*)cookie;

-(void)PlayDeleteAnimation:(CDGameBoardSpriteNode*)cookie;

-(void)PlayFallingAnimation:(CDGameBoardSpriteNode*)cookie;

-(void)PlayPickMeAnimation:(CDGameBoardSpriteNode*)cookie;

-(void)PlayShockerAnimation:(CDGameBoardSpriteNode*)cookie;

#pragma mark - Movement animations

-(void)SuperHorizontal:(CDGameBoardSpriteNode*)theSuper;

-(void)SuperVertical:(CDGameBoardSpriteNode*)theSuper;

#pragma mark - Radioactive Sprinkle methods

-(void)Radiate_up:(CDGameBoardSpriteNode*)sprinkle OtherPiece:(CDGameBoardSpriteNode*)piece;

-(void)Radiate_down:(CDGameBoardSpriteNode*)sprinkle OtherPiece:(CDGameBoardSpriteNode*)piece;

-(void)Radiate_left:(CDGameBoardSpriteNode*)sprinkle OtherPiece:(CDGameBoardSpriteNode*)piece;

-(void)Radiate_right:(CDGameBoardSpriteNode*)sprinkle OtherPiece:(CDGameBoardSpriteNode*)piece;

#pragma mark - othe methods

- (void)SuperSizing:(CDGameBoardSpriteNode*)theSuper;

@end
