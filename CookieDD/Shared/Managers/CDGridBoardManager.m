//
//  CDGridBoardManager.m
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

/*
 UITouch *touch = [touches anyObject];
 CGPoint currentPosition = [touch locationInNode:self];
 
 CGFloat deltaX = fabsf(self.startPosition.x - currentPosition.x);
 CGFloat deltaY = fabsf(self.startPosition.y - currentPosition.y);
 
 // left gesture
 if (gestureStartPoint.x > currentPosition.x && deltaY <= kMaximumVariance && deltaX >= kMinimumGestureLength) {
 
 }
 // right gesture
 else if (gestureStartPoint.x < currentPosition.x && deltaY <= kMaximumVariance && deltaX >= kMinimumGestureLength) {
 
 }
 // up gesture
 else if (gestureStartPoint.y > currentPosition.y && deltaX <= kMaximumVariance && deltaY >= kMinimumGestureLength) {
 
 }
 // down gesture
 else if (gestureStartPoint.y < currentPosition.y && deltaX <= kMaximumVariance && deltaY >= kMinimumGestureLength) {
 
 }*/


#import "CDGridBoardManager.h"

static CDGridBoardManager *gridBoardManager = nil;

@interface CDGridBoardManager ()
@property (assign, nonatomic) NSUInteger lastIndex;
@property (assign, nonatomic) NSInteger counter;
@property (strong, nonatomic) SKSpriteNode *previosSprite;
@end

@implementation CDGridBoardManager

+ (CDGridBoardManager *)sharedManager
{
    if (!gridBoardManager)
    {
        gridBoardManager = [[CDGridBoardManager alloc] init];
    }
    return gridBoardManager;
}

#pragma mark - Board Creation.

- (void)initGridLayoutWithScene:(SKScene *)scene
                        numRows:(int)numRows
                     numColumns:(int)numColumns
                     blockWidth:(float)blockWidth
                    blockHeight:(float)blockHeight
                  bufferSpacing:(int)bufferSpacing
                 withBlockArray:(NSMutableArray *)blockArray
{
    self.numColumns = numColumns;
    self.numRows = numRows;
    self.buffer = bufferSpacing;
    static int margin = 20;

    // NOTE:
    // standard "top left" in iOS 20 x 20
    // However sprite kit and skview starts from bottom screen up. its vice versa for sprite kit.
    CGPoint topLeft = CGPointMake(margin,margin);

    
    // NOTE:
    // Here we add multi-dimension array, an array of columns,
    // with each column containing an array of blocks (representing the rows)
    // Iterate through how many columns SHOULD exist (numColumns)
    
    for (int i = 0; i < numColumns; i = i + 1)
    {
        // NOTE:
        // Check if this "column" exists (does this index exist in  blockArray?)
        
        if (i >= [blockArray count])
        {
            // NOTE:
            // It doesn't exist, so we need to add a blank array
            
            [blockArray addObject:[NSMutableArray array]];
        }
        NSMutableArray *column = [blockArray objectAtIndex:i];
        
        // NOTE:
        // Now, we iterate through how many rows/blocks SHOULD exist (numRows)
        
        for (int j = 0; j < numRows; j = j + 1)
        {
            // NOTE:
            // Check if this "row"/"Block" exists
            
            if (j >= [column count])
            {
                // NOTE:
                // It doesn't exist, so we need to add a new block AND PLACE IT!
                // This is where we create our blocks
                
                SKSpriteNode *block = [self newBlockWithWidth:blockWidth withHeight:blockHeight];
                block.position = CGPointMake(topLeft.x, topLeft.y);
                
                // NOTE:
                // Do whatever else you need to do with the Block or sprite...
                // Add Label to show row and column number...
                
                SKLabelNode *blockNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
                blockNumberLabel.text = [NSString stringWithFormat:@"(%d,%d)", i + 1, j + 1];
                blockNumberLabel.fontSize = 8.0f;
                [block addChild:blockNumberLabel];
             
                // NOTE:
                // Add the block to the scene
                
                [scene addChild:block];
                
                // NOTE:
                // Add the block to the array
                
                [column addObject:block];
            }
            
            // NOTE:
            // Increment topLeft to the next "row" for correct block placement...
            
            topLeft = CGPointMake(topLeft.x, topLeft.y + blockHeight + bufferSpacing);
        }
        
        // NOTE:
        // Increment topLeft to the next "column" for correct block placement...
        
        topLeft = CGPointMake(topLeft.x + blockWidth + bufferSpacing, margin);
    }
    
    // NOTE:
    // Uncomment this code if you wish to redraw the view. This if you add more blocks to the grid.
    // [[self view] setNeedsDisplay];
}


- (void)setUpRowsArray:(NSMutableArray *)blockArray rowArray:(NSMutableArray *)blockRowArray
{
    NSMutableArray *aRowArray = [NSMutableArray new];
    
    for (int index = 0; index < self.numRows ; index++)
    {
        [aRowArray insertObject:[NSMutableArray new] atIndex:index];
    }
    
    for (NSMutableArray *column in blockArray)
    {
        int index = 0;
        
        for (SKSpriteNode *block in column) {

            NSMutableArray *rowArray = [aRowArray objectAtIndex:index];
 /*
            SKLabelNode *blockNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            blockNumberLabel.text = [NSString stringWithFormat:@"(%i)",index];
            blockNumberLabel.fontSize = 8.0f;
            [block addChild:blockNumberLabel];
   */         
            if (![rowArray containsObject:block])
            {
                [rowArray addObject:block];
            }
            
            index++;
        }
    }
    [blockRowArray addObjectsFromArray:aRowArray];
}

// NOTE:
// Method to handle creating a new block...

- (SKSpriteNode *)newBlockWithWidth:(CGFloat)width withHeight:(CGFloat)height
{
    NSDictionary *colorTagDict = [self setblockColorAndTag];
    if (!colorTagDict) {
        return nil;
    }
    UIColor *blockColor = nil;
    NSString *name = nil;
    
    if (colorTagDict[@"color"]) blockColor = colorTagDict[@"color"];
    if (colorTagDict[@"name"]) name = colorTagDict[@"name"];
    
    SKSpriteNode *block = [[SKSpriteNode alloc] initWithColor:blockColor size:CGSizeMake(width , height)];
    
    
    block.name = name;
    block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size];
    block.physicsBody.dynamic = NO;
    block.physicsBody.mass = 1.01f;
    
    return block;
}

// NOTE
// For setting random color to block
// And setting tag/name for sprite

- (NSDictionary *)setblockColorAndTag
{
    NSDictionary *colorTagDict;
    
    NSDictionary *colorOneDict = @{@"color":    [UIColor redColor], @"name": @"red"};
    
    NSDictionary *colorTwoDict = @{@"color":    [UIColor orangeColor], @"name": @"orange"};
    
    NSDictionary *colorThreeDict = @{@"color":  [UIColor yellowColor], @"name": @"yellow"};
    
    NSDictionary *colorFourDict = @{@"color":   [UIColor greenColor], @"name": @"green"};
    
    NSDictionary *colorFiveDict = @{@"color":   [UIColor blueColor], @"name": @"blue"};
    
    
    NSArray *arrayOfColors = [NSArray arrayWithObjects:colorOneDict, colorTwoDict, colorThreeDict, colorFourDict, colorFiveDict, nil];
    
    NSUInteger randIndex = arc4random() % [arrayOfColors count];

    // Note
    // These checks are so that we do not spawn the same block more than two times
    // other wise the user will have matches off the start of the game
    if (self.lastIndex == randIndex)
    {
        self.counter++;
        if (self.counter >= 2)
        {
            while (self.lastIndex == randIndex)
            {
                randIndex = arc4random() % [arrayOfColors count];
            }
        }
    }
    else
    {
        self.counter = 0;
    }
    
    colorTagDict = [arrayOfColors objectAtIndex:randIndex];
    self.lastIndex = randIndex;
    return colorTagDict;
}

#pragma mark - Helpers

// NOTE:
// Distance Formula
// d = (x2 - x1) + (y2 - y1)
- (int)distanceBetweenPointA:(CGPoint)pointA fromPointB:(CGPoint)pointB
{
    int distance = 0.0f;
    distance = (pointA.x - pointB.x) + (pointA.y - pointB.y);
    int reformatDistance = abs(distance);
    return reformatDistance;
}

@end
