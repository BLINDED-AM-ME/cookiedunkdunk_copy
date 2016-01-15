//
//  CDCookieCookerCookieJarObject.m
//  CookieDD
//
//  Created by gary johnston on 9/26/13.
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

#import "CDCookieCookerCookieJarObject.h"

@interface CDCookieCookerCookieJarObject()

@property (strong, nonatomic) SKTexture *theTexture;

@property (assign, nonatomic) int moveDist;
@property (assign, nonatomic) int bufferTwoCheck;

@property (assign, nonatomic) BOOL isGoingDown;
@property (assign, nonatomic) BOOL isIphone;

@property (assign, nonatomic) float frameHeight;
@property (assign, nonatomic) float textureHeight;
@property (assign, nonatomic) float preBuffer;
@property (assign, nonatomic) float preBufferTwo;

@end



@implementation CDCookieCookerCookieJarObject

- (id)initWithScene:(SKScene *)scene
{
    SKTextureAtlas *atlas;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        atlas = [SKTextureAtlas atlasNamed:@"cookieCooker_accessories_iphone5"];
        self.isIphone = YES;
        self.bufferTwoCheck = 50;
    }
    else
    {
        atlas = [SKTextureAtlas atlasNamed:@"cookieCooker_accessories_ipad"];
        self.isIphone = NO;
        self.bufferTwoCheck = 140;
    }
    
    self.theTexture = [atlas textureNamed:@"cookieCooker_cookieJar_full"];
    self = [super initWithTexture:self.theTexture];
    
    if (self)
    {
        self.textureHeight = self.theTexture.size.height*.5;
        
        self.frameHeight = scene.size.height;
        
        self.preBuffer = self.textureHeight + self.moveDist;
        self.preBufferTwo = self.textureHeight - self.moveDist;
        
        self.moveDist = 1;
        self.isGoingDown = YES;
    }
    
    return self;
}

- (float)moveTheJar:(float)position
{
    float buffer = position + _preBuffer;
    float bufferTwo = position - _preBufferTwo;
    
    if (!_isGoingDown)
    {
        if (((buffer > _frameHeight-60) && _isIphone) || ((buffer > _frameHeight-200) && !_isIphone))
        {
            _isGoingDown = YES;
        }
        else
        {
            position += _moveDist;
        }
    }
    else
    {
        if (bufferTwo < _bufferTwoCheck)
        {
            _isGoingDown = NO;
        }
        else
        {
            position -= _moveDist;
        }
    }
    return position;
}

@end