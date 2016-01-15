//
//  SGPopupLabelNode.m
//  CookieDD
//
//  Created by Josh on 4/9/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
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

#import "SGPopupNode.h"

@implementation SGPopupNode

- (id)initWithFontNamed:(NSString *)fontName {
    self = [super initWithFontNamed:fontName];
    if (self) {
        _emitter = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"RisingSparkles01"];
        _emitter.particleBirthRate = 50;
        _emitter.numParticlesToEmit = 30;
        _emitter.particleAlphaSpeed = -1.3f;
        
        [self addChild:_emitter];
    }
    
    return self;
}


#pragma mark - Animation

-(void)activate {
    [self popUp];
}

- (void)popUp {
    self.alpha = 0.0f;
    [self setScale:0.8f];
    
    SKAction *fadeInAction = [SKAction fadeAlphaTo:1.0f duration:0.3f];
    SKAction *scaleUpAction = [SKAction scaleTo:1.0f duration:0.3f];
    SKAction *moveUpAction = [SKAction moveByX:0.0f y:[self calculateAccumulatedFrame].size.height * 1.0f duration:0.3f];
    SKAction *popUpAction = [SKAction group:@[fadeInAction, scaleUpAction, moveUpAction]];
    
    [self runAction:popUpAction completion:^{
        [self performSelector:@selector(popOut) withObject:nil afterDelay:0.5f];
    }];
}

- (void)popOut {
    SKAction *fadeOutAction = [SKAction fadeAlphaTo:0.0f duration:0.2f];
    SKAction *scaleDownAction = [SKAction scaleTo:0.8f duration:0.2f];
    SKAction *moveOutAction = [SKAction moveByX:0.0f y:[self calculateAccumulatedFrame].size.height * 1.0f duration:0.2f];
    SKAction *popOutAction = [SKAction group:@[fadeOutAction, scaleDownAction, moveOutAction]];
    
    [self runAction:popOutAction completion:^{
        [self removeFromParent];
    }];
}

@end
