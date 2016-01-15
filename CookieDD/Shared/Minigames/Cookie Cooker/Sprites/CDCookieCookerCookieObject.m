//
//  CDCookieOperationCookieObject.m
//  CookieDD
//
//  Created by gary johnston on 9/12/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.
//

/*
 
 Credits:
 
 President/CEO - Duane Schor
 
 Art Director - Neisha Bergman
 Artists - Ecieño Carmona
 Eric Eining
 Mike Swarts
 Erik Aamland
 Duane Schor
 
 Lead Programmer - Luke McDonald
 Programmers - Josh McGee
 Gary Johnston
 Dustin Whirle
 Jeremy Pagley
 Rodney Jenkins
 
 Server Programmer - Josh Pagley
 
 Lead Sound Designer - Ramsees Mechan
 Sound Designers - Richard Würth
 D’Andre Amos
 
 Voice Actors - Adrian Knapp
 Duane Schor
 Luke McDonald
 Neisha Bergman
 
 Lead Web Designer - Brittany Steed
 Web Designers - Yannik Bloscheck
 Lisa Menerick
 Andrew Gianikas
 
 Graphic Designer - Freddy Garcia
 
 Tech Support - Jonathan Marr-Cox
 
 Story - Audra Hudson
 Duane Schor
 
 Marketing Director - Rodney Jenkins
 Marketer - CJ Anderson
 
 Business Development Manager - Adam Hunt
 
 Quality Assurance - Vinny Spaulding
 
 Level Editing - Abner Velez
 
 
 Special Thanks - Jon Kurtz
 Benjamin Stahlhood II
 Andrew Nunley
 Steven Edsall
 And to all our friends and family that have supported us along the way!
 
 */

#import "CDCookieCookerCookieObject.h"
#import "CDParticleEmitter.h"

@interface CDCookieCookerCookieObject()

@property (strong, nonatomic) SKScene *theScene;
@property (strong, nonatomic) SGAudioPlayer *fryingSound;

@end


@implementation CDCookieCookerCookieObject

- (id)initWithScene:(SKScene *)scene{
    
    SKTextureAtlas *atlas;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        atlas = [SKTextureAtlas atlasNamed:@"cookieCookerCookie_iphone"];
    }
    else
    {
        atlas = [SKTextureAtlas atlasNamed:@"cookieCookerCookie_ipad"];
    }
    
    SKTexture *faceOne = [atlas textureNamed:@"cookieFace00"];
    SKTexture *faceTwo = [atlas textureNamed:@"cookieFace01"];
    SKTexture *faceThree = [atlas textureNamed:@"cookieFace02"];
    SKTexture *faceFour = [atlas textureNamed:@"cookieFace03"];
    SKTexture *faceFive = [atlas textureNamed:@"cookieFace04"];
    
    self.cookieTextureArray = @[faceOne,faceTwo,faceThree, faceFour, faceFive];
    
    self = [super initWithTexture:faceOne];
    
    if (self)
    {
        self.theScene = scene;
        
        self.timeForAnimation = arc4random()%10+3;
        self.timeForAnimation *= 25;
        
        self.timeOrigin = self.timeForAnimation;
        
        self.cooking = YES;
        self.burnt = NO;
        self.raw = YES;
        self.name = @"CookieObject";
    }
        
    return self;
}




#pragma mark - Remove

- (void)createFloatingPoint
{
    SKSpriteNode *pointPopup;
    
    if (_didScoreIncrease)
    {
        pointPopup = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-particle-scoreplus"];
    }
    else
    {
        pointPopup = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-particle-scoreminus"];
    }
    
    pointPopup.position = self.position;
    
    [pointPopup runAction:[SKAction moveByX:0 y:50 duration:.5]];
    [pointPopup runAction:[SKAction fadeOutWithDuration:.5] completion:^{
        [pointPopup removeFromParent];
    }];
    
    [self.parent addChild:pointPopup];
}

- (void)removeCookieWillAnimateForMaxTime:(BOOL)willAnimateForMaxTime
{
    float animationDuration= 0.0f;
    if (willAnimateForMaxTime)
    {
        animationDuration = .2f;
    }
    else
    {
        animationDuration = .1f;
    }
//    _scale = [SKAction customActionWithDuration:animationDuration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
//        self.xScale = self.xScale/1.1f;
//        self.yScale = self.yScale/1.1f;
//    }];
    
    [self runAction:[SKAction customActionWithDuration:animationDuration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        self.xScale = self.xScale/1.1f;
        self.yScale = self.yScale/1.1f;
    }] completion:^{
        if (_willDisplayPopUpScore)
        {
            [self createFloatingPoint];
        }
        [self removeFromParent];
        [self destroy];
    }];
}

- (void)updateCookie
{
    if (self.cooking)
    {
        if (self.timeForAnimation > 0)
        {
            self.timeForAnimation -= 1;
        }
        else
        {
            self.timeForAnimation = self.timeOrigin;
           
            
            if (self.spotInCookieArray < [self.cookieTextureArray count])
            {
                if (self.spotInCookieArray == 0)
                {
                    self.raw = YES;
                }
                else
                {
                    self.raw = NO;
                }
                
                if (self.spotInCookieArray == 3)
                {
                    [[[CDParticleEmitter alloc] init] burnAnimation:self TargetNode:self.theScene Position:CGPointMake(0, 0) ObjectSize:self.size DeletionTime:0 WithSmokeConstant:YES WithFireEffect:NO WithAshesEffect:NO CookieType:@"" DelayForFire:0 DelayForAsh:0];
                    
                    if(self.burnt == NO){
                        CDCookieCookerScene* cooker = (CDCookieCookerScene*) self.theScene;
                        //[cooker PlayTheBurningSound];
                        
                        //self.fryingSound = [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Frying" FileType:@"m4a" volume:1.0f numberOfLoopes:-1];
                        self.fryingSound = [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Cookie_Cooker_Frying" FileType:@"caf" volume:1.0f numberOfLoopes:-1];
                        
                        [cooker ScreamForMe];
                    }
                    
                    self.burnt = YES;
                }
                else if (self.spotInCookieArray == 4)
                {
                    [[[CDParticleEmitter alloc] init] burnAnimation:self TargetNode:self.theScene Position:CGPointMake(0, 0) ObjectSize:self.size DeletionTime:0 WithSmokeConstant:NO WithFireEffect:YES WithAshesEffect:NO CookieType:@"" DelayForFire:0 DelayForAsh:1];
                    
                    if(self.cooking){
                     
                        CDCookieCookerScene* cooker = (CDCookieCookerScene*) self.theScene;
                        [cooker deathPoof];
                        
                    }
                    
                    self.burnt = YES;
                    self.cooking = NO;
                    
                }
                self.texture = self.cookieTextureArray[self.spotInCookieArray];
                
                self.spotInCookieArray += 1;
            }
        }
    }
}

- (void)destroy {
    [self.fryingSound stop];
}

@end
