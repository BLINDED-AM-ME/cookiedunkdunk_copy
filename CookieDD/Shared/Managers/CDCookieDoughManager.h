//
//  CDCookieDoughManager.h
//  CookieDD
//
//  Created by BLINDED AM ME on 6/18/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDCookieDoughManager : NSObject

@property (assign, nonatomic) BOOL isHurt;

@property (strong, nonatomic) SKTexture* doughTexture;
@property (strong, nonatomic) SKAction* milkFill;
@property (strong, nonatomic) SKAction* milkRipple;
@property (strong, nonatomic) NSMutableArray* myDoughyChildren;


-(void)DoughSetup;

-(void)Reset;

-(void)MyTurn;

-(void)Ripple:(SKSpriteNode*)milkBlock;

@end
