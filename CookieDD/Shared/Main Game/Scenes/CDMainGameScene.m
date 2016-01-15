//
//  CDMainGameScene.m
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

#import "CDMainGameScene.h"


@interface CDMainGameScene ()
@property (strong, nonatomic) NSMutableArray *currentColumn;
@end

@implementation CDMainGameScene

- (void)setup
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    // NOTE:
    // Must remove once block drops and spawning is working.
    self.physicsWorld.gravity = CGVectorMake(0.0f, -0.1f);
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Cookie Dunk Dunk!";
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [self addChild:myLabel];

    self.blockColumnArray = [NSMutableArray new];
    self.blockRowsArray = [NSMutableArray new];
    
    // NOTE:
    // This method you can change the board to fit your needs
    [[CDGridBoardManager sharedManager] initGridLayoutWithScene:self
                                                            numRows:12
                                                         numColumns:8
                                                         blockWidth:32
                                                        blockHeight:32
                                                      bufferSpacing:8
                                                     withBlockArray:self.blockColumnArray];

    // NOTE:
    // This method set the blockrow array so you can access the rows on the board directly
    [[CDGridBoardManager sharedManager] setUpRowsArray:self.blockColumnArray
                                                  rowArray:self.blockRowsArray];
    // NSMutableArray *column = self.blockColumnArray[0];
}


- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        // setup scen initialization here
        [self setup];
    }
    return self;
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */

//    for (SKSpriteNode *sprite in self.children) {
//        if (sprite.physicsBody.isDynamic) {
//            [sprite.physicsBody setDynamic:NO];
//        }
//    }
}

#pragma mark - Touches Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Called when a touch begins 
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        for (NSMutableArray *column in self.blockColumnArray)
        {

            for (SKSpriteNode *block in column)
            {
                if ([block isKindOfClass:[SKSpriteNode class]])
                {
                    
                    BOOL doescontainPoint = [block containsPoint:location];
                    
                    if (doescontainPoint)
                    {                    
                        self.selectedBlock = block;
                        
                        self.startPosition = [touch locationInNode:self];
                    }
                }
            }
        }
    }
}


- (void)panEnded:(NSSet *)touches withEvent:(UIEvent *)event directionPanned:(BlockDirection)direction
{
    SKSpriteNode *swapBlock = nil;
    SKSpriteNode *currentBlock = nil;
    int i = 0;
    BOOL moveIsValid = NO;
    NSMutableArray *currentColumnArray = [NSMutableArray new];
    NSMutableArray *swapColumnArray = [NSMutableArray new];
    
    NSInteger Aindex = 0;
    NSInteger otherIndex = 0;
    NSInteger blockArrayIndex = 0;
    
    switch (direction)
    {
        case BlockDirection_DEFAULT:
        {

        }
            break;
            
        case BlockDirection_UP:
        {
            for (NSMutableArray *column in self.blockColumnArray)
            {
//                blockArrayIndex = [self.blockColumnArray indexOfObject:column];

                    for (SKSpriteNode *block in column)
                    {
                        if (block == self.selectedBlock)
                        {
                            Aindex = [column indexOfObject:block];
                            
                            if (Aindex+1 < [column count])
                            {
                                currentColumnArray = column;
                            
                                otherIndex = Aindex + 1;
                                swapBlock = (SKSpriteNode *)[currentColumnArray objectAtIndex:otherIndex];
                                currentBlock = (SKSpriteNode *)[currentColumnArray objectAtIndex:Aindex];
                                moveIsValid = YES;
                            }
                        }
                }
                
                i++;
            }
        }
            break;
        case BlockDirection_DOWN:
        {
            for (NSMutableArray *column in self.blockColumnArray)
            {
                blockArrayIndex = [self.blockColumnArray indexOfObject:column];
                if (blockArrayIndex != 0)
                {
                    for (SKSpriteNode *block in column)
                    {
                        if (block == self.selectedBlock)
                        {
                            Aindex = [column indexOfObject:block];
                            currentColumnArray = column;
                            otherIndex = Aindex - 1;
                            
                            if (otherIndex != -1)
                            {
                                swapBlock = (SKSpriteNode *)[currentColumnArray objectAtIndex:otherIndex];
                                currentBlock = (SKSpriteNode *)[currentColumnArray objectAtIndex:Aindex];
                                moveIsValid = YES;
                            }
                        }
                    }
                }
                
                i++;
            }
        }
            break;
        case BlockDirection_LEFT:
        {
            for (NSMutableArray *column in self.blockColumnArray)
            {
                blockArrayIndex = [self.blockColumnArray indexOfObject:column];
                if (blockArrayIndex != 0)
                {
                    for (SKSpriteNode *block in column)
                    {
                        if (block == self.selectedBlock)
                        {
                            Aindex = [column indexOfObject:block];
                            currentColumnArray = column;

                            swapColumnArray = [self.blockColumnArray objectAtIndex:i-1];
                            swapBlock = (SKSpriteNode *)[swapColumnArray objectAtIndex:Aindex];
                            currentBlock = (SKSpriteNode *)[currentColumnArray objectAtIndex:Aindex];
                            moveIsValid = YES;
                        }
                    }
                }
                
                i++;
            }
        }
            break;
        case BlockDirection_RIGHT:
        {
            for (NSMutableArray *column in self.blockColumnArray)
            {
                blockArrayIndex = [self.blockColumnArray indexOfObject:column];
                if (blockArrayIndex < [self.blockColumnArray count]-1)
                {
                    for (SKSpriteNode *block in column)
                    {
                        if (block == self.selectedBlock)
                        {
                            Aindex = [column indexOfObject:block];
                            currentColumnArray = column;

                            swapColumnArray = [self.blockColumnArray objectAtIndex:i+1];
                            swapBlock = (SKSpriteNode *)[swapColumnArray objectAtIndex:Aindex];
                            currentBlock = (SKSpriteNode *)[currentColumnArray objectAtIndex:Aindex];
                            moveIsValid = YES;
                        }
                    }
                }
                i++;
            }
        }
            break;
            
        default:
            break;
    }
    
    if (moveIsValid)
    {
        CGPoint swapBlockPos = swapBlock.position;
        CGPoint selectedBlockPos = currentBlock.position;
//        NSMutableArray *currentBlockArray = [NSMutableArray new];
        
        if (direction == BlockDirection_LEFT || direction == BlockDirection_RIGHT)
        {
            [currentColumnArray replaceObjectAtIndex:Aindex withObject:swapBlock];
            [swapColumnArray replaceObjectAtIndex:Aindex withObject:currentBlock];
//            currentBlockArray = swapColumnArray;
        }
        else if (direction == BlockDirection_DOWN || direction == BlockDirection_UP)
        {
            [currentColumnArray exchangeObjectAtIndex:Aindex withObjectAtIndex:otherIndex];
//            currentBlockArray = currentColumnArray;
        }
        
        currentBlock.position = swapBlockPos;
        swapBlock.position = selectedBlockPos;
        [self.blockRowsArray removeAllObjects];
        [[CDGridBoardManager sharedManager] setUpRowsArray:self.blockColumnArray
                                                      rowArray:self.blockRowsArray];

        [self checkBlocksToDelete:self.blockColumnArray];
       // [self checkBlocksToDelete:self.blockRowsArray];
    }
    
     self.selectedBlock = nil;
}

- (void)checkBlocksToDelete:(NSMutableArray *)blockArray
{
    int counter = 0;
    NSMutableArray *blocksToDelete = [NSMutableArray new];
    
    for (NSMutableArray *columnOrRow in blockArray) {
    // NOTE:
    // make copy of array so that we can remove objects while iterating through them.
        for (SKSpriteNode *block in [columnOrRow copy]) {
            
            if ([block isKindOfClass:[SKSpriteNode class]]) {
                
                NSInteger index = [columnOrRow indexOfObject:block];
                SKSpriteNode *nextSprite = nil;
                
                if (index+1 <= [columnOrRow count] && !(index+1 > [columnOrRow count]-1)) {
                    
                    nextSprite = [columnOrRow objectAtIndex:index+1];
                }
                
                int distance = [[CDGridBoardManager sharedManager] distanceBetweenPointA:block.position
                                                                              fromPointB:nextSprite.position];
                if (distance <= block.size.height + [CDGridBoardManager sharedManager].buffer &&
                    distance <= block.size.width + [CDGridBoardManager sharedManager].buffer &&
                    nextSprite  &&
                    [nextSprite.name isEqualToString:block.name]) {
                    
                    DebugLog(@"within distance");
                    
                    if (![blocksToDelete containsObject:nextSprite])
                    {
                        [blocksToDelete addObject:nextSprite];
                    }
                    
                    if (![blocksToDelete containsObject:block])
                    {
                        [blocksToDelete addObject:block];
                    }
                    
                    counter += 2;
                    
                    DebugLog(@"counter : %i", counter);
                }
                else
                {
                    if (counter >= 3)
                    {
                        if ([blocksToDelete count] >= 3)
                        {
                            for (SKSpriteNode *deleteBlock in blocksToDelete)
                            {
                                [deleteBlock removeFromParent];
                                if ([columnOrRow containsObject:deleteBlock]) {
                                    [columnOrRow removeObject:deleteBlock];
                                }
                            }
                            [blocksToDelete removeAllObjects];
                        }
                    }
                    
                    if (counter != 0)
                    {
                        counter = 0;
                        [blocksToDelete removeAllObjects];
                    }
                }
            }
        }
    }
    [self spawnAndDropWithBlockarray:blockArray];
}

- (void)spawnAndDropWithBlockarray:(NSMutableArray *)blockArray
{
    for (NSMutableArray *columnOrRow in blockArray) {
        BOOL willDrop = NO;
        
        if ([columnOrRow count] < [CDGridBoardManager sharedManager].numRows) {
            for (SKSpriteNode *sprite in columnOrRow)
            {
                NSInteger index = [columnOrRow indexOfObject:sprite];
                DebugLog(@"This is the index : %li", (long)index);
                SKSpriteNode *nextSprite = nil;
                
                if (index+1 <= [columnOrRow count] && !(index+1 > [columnOrRow count]-1)) {
                    
                    nextSprite = [columnOrRow objectAtIndex:index+1];
                }
                
                int distance = [[CDGridBoardManager sharedManager] distanceBetweenPointA:sprite.position
                                                                              fromPointB:nextSprite.position];
                DebugLog(@"This is the distance : %i", distance);
                if (distance > sprite.size.height + [CDGridBoardManager sharedManager].buffer &&
                    distance > sprite.size.width + [CDGridBoardManager sharedManager].buffer &&
                    nextSprite)
                {
                    willDrop = YES;

                    SKSpriteNode *tempSprite = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(30, 30)];
                    [nextSprite addChild:tempSprite];
                    
                    SKShapeNode *rayCastNode = [self drawRayCastWithStartPoint:nextSprite.position endPoint:CGPointMake(nextSprite.frame.origin.x + 15, 0)];
                    
                    [self addChild:rayCastNode];
                    
//                    [self.physicsWorld enumerateBodiesAlongRayStart:nextSprite.position end:CGPointMake(nextSprite.frame.origin.x + 15, 0) usingBlock:^
//                     (SKPhysicsBody *body, CGPoint point, CGPoint normal, BOOL *stop)
//                     {
//                         if (body) {
//                             DebugLog(@"The body : %@", body);
//                          
//                         }
//                     }];
                    
                    // [self.physicsWorld enumerateBodiesAtPoint:<#(CGPoint)#> usingBlock:<#^(SKPhysicsBody *body, BOOL *stop)block#>]
                    
                }
                
                if (willDrop) {
                    [nextSprite.physicsBody setDynamic:YES];
                }
            }
        }
    }
}

- (SKShapeNode *)drawRayCastWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    SKShapeNode *shapeNode = [SKShapeNode new];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    
    // CGPathAddLineToPoint(path, NULL, startPoint.x, startPoint.y);
    
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGContextSetStrokeColorWithColor(ctx,[UIColor whiteColor].CGColor);
    CGContextStrokePath(ctx);
    shapeNode.path = path;
    CGPathRelease(path);
    
    SKAction *remove = [SKAction removeFromParent];
    SKAction *waitForDuration = [SKAction waitForDuration:2.0f];
    SKAction *sequence = [SKAction sequence:@[waitForDuration, remove]];
    [shapeNode runAction:sequence];
    
    return shapeNode;
}

- (void)stopBlocks
{
    for (NSMutableArray *columnOrRow in self.blockColumnArray) {
        for (SKSpriteNode *sprite in columnOrRow) {
            [sprite.physicsBody setDynamic:NO];
        }
    }
}

// NOTE:
// Link for NSArray mutating array while in for loop
// http://stackoverflow.com/questions/8834031/objective-c-nsmutablearray-mutated-while-being-enumerated
@end
