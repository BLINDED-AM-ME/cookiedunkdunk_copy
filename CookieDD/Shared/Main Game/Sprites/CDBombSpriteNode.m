//
//  CDBombSpriteNode.m
//  CookieDD
//
//  Created by BLINDED AM ME on 7/21/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDBombSpriteNode.h"
#import "SGGameManager.h"
#import "CDCookieAnimationManager.h"

@implementation CDBombSpriteNode

-(BOOL)Tick{
    
    if(_justDropped){
        _justDropped = NO;
        return NO;
    }
    
    _turnsLeft--;
    
    if(_turnsLeft <= 0){
        return YES;
    }else{
        [_countdown setText:[NSString stringWithFormat:@"%i",_turnsLeft]];
    }
    
    return NO;
}

@end
