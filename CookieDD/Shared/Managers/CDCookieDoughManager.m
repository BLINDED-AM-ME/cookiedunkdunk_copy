//
//  CDCookieDoughManager.m
//  CookieDD
//
//  Created by BLINDED AM ME on 6/18/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDCookieDoughManager.h"
#import "SGGameManager.h"

@implementation CDCookieDoughManager


-(void)DoughSetup{
    
    _doughTexture = [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkblock@2x"];
    
    SKAction *fillAnimate = [SKAction animateWithTextures:@[
                                                            
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn1@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn2@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn3@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn4@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn5@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn6@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn7@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn8@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn9@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn10@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn11@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn12@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn13@2x"],
                                                            [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-milkspawn14@2x"],
                                                            _doughTexture
                                                            
                                                            ] timePerFrame:0.06f];
    SKAction *fillAudio = [SKAction runBlock:^{ [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_milkfill" FileType:@"m4a"];}];
    _milkFill = [SKAction group:@[fillAudio, fillAnimate]];
    
    _milkRipple = [SKAction sequence:@[ [SKAction animateWithTextures:@[
                                                  
                                                  [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-ripple1@2x"],
                                                  [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-ripple2@2x"],
                                                  [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-ripple3@2x"],
                                                  [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-ripple4@2x"],
                                                  [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-ripple5@2x"],
                                                  [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-ripple6@2x"],
                                                  [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-ripple7@2x"],
                                                  [SKTexture textureWithImageNamed:@"cdd-alien-gameboard-ripple8@2x"]
                                                  
                                                  ] timePerFrame:0.08f], [SKAction removeFromParent]]];
    
}

-(void)Reset{
    
    _isHurt = NO;
    
    _myDoughyChildren = [NSMutableArray new];
    
}

-(void)MyTurn
{
    if(_isHurt || _myDoughyChildren.count == 0){
        _isHurt = NO;
        return;
    }
    
    SGGameManager* gameManager = [SGGameManager gameManager];
    
    CDGameBoardSpriteNode* newDough = [CDGameBoardSpriteNode spriteNodeWithColor:[SKColor clearColor]
                                                                            size:CGSizeMake(gameManager.columnWidth,
                                                                                            gameManager.RowHeight)];
    newDough.isVulnerable = NO;
    newDough.shouldMilkSplash = YES;
    newDough.typeID = BLOCKER_COOKIEDOUGH;
    
    CDGameBoardSpriteNode* victim = nil;
    
    int lookingIndex = arc4random() % _myDoughyChildren.count;
    
    for (int i=0; i<_myDoughyChildren.count; i++) {
        
        int index = lookingIndex + i;
        if(index >= _myDoughyChildren.count){
            index -= _myDoughyChildren.count;
        }
        
        CDGameBoardSpriteNode* myChild = _myDoughyChildren[index];
        victim = [self LookAround:myChild];
        
        if(victim != nil)
            break;
        
    }
    
    
    if(victim != nil){
        
        
        [_myDoughyChildren addObject:newDough];
        [gameManager.gameBoard addChild:newDough];
        [gameManager.theGameGrid replaceObjectAtIndex:[gameManager.theGameGrid indexOfObject:victim] withObject:newDough];
        [gameManager.theVisiblePieces addObject:newDough];
        
        [gameManager.SuperCookies removeObject:victim];
        [gameManager.WrappedCookies removeObject:victim];
        [gameManager.theVisiblePieces removeObject:victim];
        
        [victim removeAllActions];
        
        newDough.position = victim.position;
        newDough.zPosition = victim.zPosition;
        
        if([victim isMemberOfClass:[CDBombSpriteNode class]]){
            
            [[SGGameManager gameManager].allBombs removeObject:victim];
            [victim removeAllChildren];
        }
        
        [newDough runAction:_milkFill completion:^{
        
            [victim removeAllChildren];
            [victim removeFromParent];
        
        }];
        
    }
    
}

-(CDGameBoardSpriteNode*)LookAround:(CDGameBoardSpriteNode*)dough
{
    SGGameManager* gameManager = [SGGameManager gameManager];
    
    CDGameBoardSpriteNode* victim = nil;
    
    int dir = arc4random() % 4;  // up down left right
    
    for (int i=0; i<4; i++) {
        
        int direction = dir + i;
        if(direction >= dir)
            direction -= dir;
        
        CDGameBoardSpriteNode* checkPiece = nil;
        
        if(direction == 0 && dough.row < gameManager.numRows-1){ // up
            checkPiece = gameManager.theGameGrid[((dough.row + 1) * gameManager.numColumns) + dough.column];
        }else if(direction == 1 && dough.row > 0){ // down
            checkPiece = gameManager.theGameGrid[((dough.row - 1) * gameManager.numColumns) + dough.column];
        }else if(direction == 2 && dough.column > 0){ // left
            checkPiece = gameManager.theGameGrid[(dough.row * gameManager.numColumns) + (dough.column - 1)];
        }else if(direction == 3 && dough.column < gameManager.numColumns-1){ // right
            checkPiece = gameManager.theGameGrid[(dough.row * gameManager.numColumns) + (dough.column + 1)];
        }
        
        if(checkPiece != nil){
            if([checkPiece isKindOfClass:[CDCookieSpriteNode class]] && !checkPiece.isLocked && checkPiece.isVulnerable){
                victim = checkPiece;
                break;
            }
        }
        
    }
    
    return victim;
}

-(void)Ripple:(SKSpriteNode*)milkBlock
{
    
    SKSpriteNode* ripple = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:milkBlock.size];
    
    [milkBlock addChild:ripple];
    
    [ripple runAction:_milkRipple];
    
}

@end
