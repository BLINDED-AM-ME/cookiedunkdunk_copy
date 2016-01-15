//
//  CDFillableCupNode.m
//  MilkCupTesting
//
//  Created by Josh on 2/20/14.
//  Copyright (c) 2014 Josh. All rights reserved.
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

#import "CDFillableCupNode.h"

@interface CDFillableCupNode()

@property (assign, nonatomic) float fullLiquidHeight;

@property (assign, nonatomic) SKSpriteNode *milkMaskDebug;

@end

@implementation CDFillableCupNode

- (id)initWithLiquid:(NSArray *)liquidSpritesArray
          MaskOffset:(CGPoint)maskOffset
                 Cup:(NSArray *)cupSpritesArray
           CupOffset:(float)cupOffset
               Straw:(SKSpriteNode *)strawSprite
         StrawOffset:(CGPoint)strawOffset
          StarLevels:(SGVector3*)starLevels
         StarMarkers:(NSArray *)starmarkerSpritesArray {
    
    
    self = [CDFillableCupNode node];
    
    
    // Back of the cup.
    if (cupSpritesArray.count > 0) {
        _cupBack = cupSpritesArray[0];
        _cupBack.position = CGPointMake(_cupBack.position.x, _cupBack.position.y + cupOffset);
        [self addChild:_cupBack];
    }
    
    // Inner liquid.
    if (liquidSpritesArray) {
        if (liquidSpritesArray.count > 0) {
            _liquidSprite = liquidSpritesArray[0];
            _fullLiquidHeight = _liquidSprite.size.height * 0.8f;
            _liquidSprite.position = CGPointMake(0.0f, -_fullLiquidHeight);
        }
        
        // Check if a mask was given for the liquid.
        if (liquidSpritesArray.count > 1) {
            _liquidMaskSprite = liquidSpritesArray[1];
            _liquidMaskSprite.position = maskOffset;
            _croppedLiquid = [SKCropNode node];
            [_croppedLiquid addChild:_liquidSprite];
            [_croppedLiquid setMaskNode:_liquidMaskSprite];
            //[self addChild:_croppedLiquid];
            [self insertChild:_croppedLiquid atIndex:0];
            
            _milkMaskDebug = [SKSpriteNode spriteNodeWithTexture:_liquidMaskSprite.texture];
            //_milkMaskDebug.position = maskOffset;
            //[self addChild:_milkMaskDebug];
        }
        else { // If there's no mask, just add the liquid.
            [self insertChild:_liquidSprite atIndex:0];
        }
    }
    else {
        DebugLog(@"Warning: Creating the milk cup without liquid means it's star markers won't position correctly.");
    }
    
    if (strawSprite) {
        _strawOffset = strawOffset;
        // Visible Straw.
        _strawSprite = strawSprite;
        _strawSprite.position = _strawOffset;
        
        // Straw Mask.
        _strawMaskSprite = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:_strawSprite.size];
        _strawMaskSprite.position = _strawOffset;
        _croppedStraw = [SKCropNode node];
        [_croppedStraw addChild:_strawSprite];
        [_croppedStraw setMaskNode:_strawMaskSprite];
        
        [self addChild:_croppedStraw];
    }
    
    // Front of the cup.
    if (cupSpritesArray.count > 1) {
        _cupFront = cupSpritesArray[1];
        _cupFront.position = CGPointMake(_cupFront.position.x, _cupFront.position.y + cupOffset);
        [self addChild:_cupFront];
    }
    
    
    
    
    // Star Levels.
    if (starLevels) {
        _starLevel = NO_STAR;
        
        
        _goldLevel = starLevels.z;
        
        
        if (starLevels.y < _goldLevel) {
            _silverLevel = starLevels.y;
        } else {
            _silverLevel = _goldLevel;
        }
        
        
        if (starLevels.x < _silverLevel) {
            _bronzeLevel = starLevels.x;
        } else {
            _bronzeLevel = _silverLevel;
        }
        
    }
    
    // Star sprites
    if (starmarkerSpritesArray) {
        if (starmarkerSpritesArray.count > 2) {
            _goldStarSprite = starmarkerSpritesArray[2];
            [self addChild:_goldStarSprite];
            _goldStarSprite.position = CGPointMake(0.0f, (_liquidSprite.size.height / 2) - (_goldStarSprite.size.height * 0.875));
        }
        
        if (starmarkerSpritesArray.count > 1) {
            _silverStarSprite = starmarkerSpritesArray[1];
            float silverOffset = _fullLiquidHeight - (_fullLiquidHeight * (_silverLevel / _goldLevel));
            _silverStarSprite.position = CGPointMake(0.0f, _goldStarSprite.position.y - silverOffset);
            [self addChild:_silverStarSprite];
        }
        
        if (starmarkerSpritesArray.count > 0) {
            _bronzeStarSprite = starmarkerSpritesArray[0];
            float bronzeOffset = _fullLiquidHeight - (_fullLiquidHeight * (_bronzeLevel / _goldLevel));
            _bronzeStarSprite.position = CGPointMake(0.0f, _goldStarSprite.position.y - bronzeOffset);
            [self addChild:_bronzeStarSprite];
        }
    }
    
    return self;
}

- (void)setLiquidLevelTo:(float)liquidLevel {
    if (liquidLevel > _goldLevel) {
        liquidLevel = _goldLevel;
    }
    _liquidLevel = liquidLevel;
    
    float previousLiquidY = _liquidSprite.position.y;
    
    float liquidOffset = -(_fullLiquidHeight - (_fullLiquidHeight * (_liquidLevel / _goldLevel)));
    _liquidSprite.position = CGPointMake(0.0f, liquidOffset);
    
    float liquidDeltaY = _liquidSprite.position.y - previousLiquidY;
    
    _croppedStraw.position = CGPointMake(_croppedStraw.position.x, _croppedStraw.position.y + liquidDeltaY);
    _strawSprite.position = CGPointMake(_strawSprite.position.x, _strawSprite.position.y - liquidDeltaY);
    
    [self calculateStarLevel];
}

- (void)calculateStarLevel {
    if (_liquidLevel >= _goldLevel) {
        _starLevel = GOLD_STAR;
    }
    else if (_liquidLevel >= _silverLevel) {
        _starLevel = SILVER_STAR;
    }
    else if (_liquidLevel >= _bronzeLevel) {
        _starLevel = BRONZE_STAR;
    }
}

- (NSString *)description {
    NSString *nameInfo = [NSString stringWithFormat:@"name:'%@'", self.name];
    NSString *positionInfo = [NSString stringWithFormat:@"position:{%f, %f}", self.position.x, self.position.y];
    NSString *liquidInfo = [NSString stringWithFormat:@"liquidLevel:%f", _liquidLevel];
    NSString *starInfo = [NSString stringWithFormat:@"bronzeLevel:%f  silverLevel:%f  goldLevel:%f", _bronzeLevel, _silverLevel, _goldLevel];
    
    NSString *fullDescription = [NSString stringWithFormat:@"<SKNode> %@ %@ %@ %@", nameInfo, liquidInfo, positionInfo, starInfo];
    return fullDescription;
}

@end
