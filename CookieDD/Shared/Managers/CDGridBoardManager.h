//
//  CDGridBoardManager.h
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

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

// NOTE:
// We make the grid seperate object so that we can use same code
// for multiple scenes and it good way keep clean.

@interface CDGridBoardManager : NSObject
@property (assign, nonatomic) int numRows;
@property (assign, nonatomic) int numColumns;
@property (assign, nonatomic) int buffer;

+ (CDGridBoardManager *)sharedManager;

#pragma mark - Board Creation.

- (void)initGridLayoutWithScene:(SKScene *)scene
                        numRows:(int)numRows
                     numColumns:(int)numColumns
                     blockWidth:(float)blockWidth
                    blockHeight:(float)blockHeight
                  bufferSpacing:(int)bufferSpacing
                 withBlockArray:(NSMutableArray *)blockArray;

- (void)setUpRowsArray:(NSMutableArray *)blockArray rowArray:(NSMutableArray *)blockRowArray;

- (SKSpriteNode *)newBlockWithWidth:(CGFloat)width withHeight:(CGFloat)height;


#pragma mark - Helpers

- (int)distanceBetweenPointA:(CGPoint)pointA fromPointB:(CGPoint)pointB;

@end
