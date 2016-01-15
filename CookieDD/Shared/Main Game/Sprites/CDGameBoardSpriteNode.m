//
//  CDGameBoardSpriteNode.m
//  CookieDD
//
//  Created by Luke McDonald on 1/27/14.
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

#import "CDGameBoardSpriteNode.h"
#import "SGGameManager.h"

@interface CDGameBoardSpriteNode ()

@property (assign, nonatomic) BOOL isGoingOver; // for shuffle


@end

@implementation CDGameBoardSpriteNode

-(void)ShuffleMovement:(int)target_row TargetColumn:(int)target_column{
    
    if(_row == target_row && _column == target_column){
        
        DebugLog(@"already there");
        
        return;
    }
    
    if(_isGoingOver){
        
        if(_column == target_column)
            _isGoingOver = NO;
        
    }else{
        
        if(_row == target_row)
            _isGoingOver = YES;
        
    }
    
    //switch
    
    CDGameBoardSpriteNode* otherPiece;
    
    if(_isGoingOver){
        if(target_column > _column){
            otherPiece = [SGGameManager gameManager].theGameGrid[(_row * [SGGameManager gameManager].numColumns) + (_column+1)];
        }
        else
        {
            otherPiece = [SGGameManager gameManager].theGameGrid[(_row * [SGGameManager gameManager].numColumns) + (_column-1)];
        }
    }else{
        if(target_row > _row){
            otherPiece = [SGGameManager gameManager].theGameGrid[((_row+1) * [SGGameManager gameManager].numColumns) + _column];
        }
        else
        {
            otherPiece = [SGGameManager gameManager].theGameGrid[((_row-1) * [SGGameManager gameManager].numColumns) + _column];
        }

    }
    
    
    
    CGPoint newPoint1 = self.position;
    float row1 = _row;
    float column1 = _column;
    
    CGPoint newPoint2 = otherPiece.position;
    float row2 = otherPiece.row;
    float column2 = otherPiece.column;
    
    _row = row2;
    _column = column2;
    
    [self runAction:[SKAction moveTo:newPoint2 duration:0.15] completion:^{
        
        self.position = newPoint2;
        
    }];
    
    if(otherPiece.typeID != CLEAR_BLOCK){
    
        otherPiece.row = row1;
        otherPiece.column = column1;
        
        [otherPiece runAction:[SKAction moveTo:newPoint1 duration:0.15] completion:^{
            
            otherPiece.position = newPoint1;
            
        }];
    }
    
    
    _isGoingOver = !_isGoingOver;
    
}


@end
