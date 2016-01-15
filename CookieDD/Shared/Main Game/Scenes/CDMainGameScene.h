//
//  CDMainGameScene.h
//  CookieDD
//
//  Created by Luke McDonald on 7/2/13.
//  Copyright (c) 2013 SevenGun. All rights reserved.
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

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CDGridBoardManager.h"

typedef enum BlockDirection {
    
    BlockDirection_DEFAULT,
    BlockDirection_UP,
    BlockDirection_DOWN,
    BlockDirection_LEFT,
    BlockDirection_RIGHT

}   BlockDirection;

@interface CDMainGameScene : SKScene
@property (strong, nonatomic) NSMutableArray *blockColumnArray;
@property (strong, nonatomic) NSMutableArray *blockRowsArray;
@property (strong, nonatomic) NSMutableArray *currentArray;
@property (assign, nonatomic) CGPoint startPosition;
@property (strong, nonatomic) SKSpriteNode *selectedBlock;
@property (strong, nonatomic) SKSpriteNode *swappedBlock;
@property (strong, nonatomic) UISwipeGestureRecognizer *upSwipper;
@property (assign, nonatomic) BlockDirection direction;



- (void)panEnded:(NSSet *)touches withEvent:(UIEvent *)event directionPanned:(BlockDirection)direction;

@end
