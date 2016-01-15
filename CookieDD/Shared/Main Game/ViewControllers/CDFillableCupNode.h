//
//  CDFillableCupNode.h
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

#import <SpriteKit/SpriteKit.h>
#import "SGVector3.h"

@interface CDFillableCupNode : SKNode

@property (strong, nonatomic) SKSpriteNode *liquidSprite;
@property (strong, nonatomic) SKSpriteNode *liquidMaskSprite;
@property (strong, nonatomic) SKCropNode *croppedLiquid;

@property (strong, nonatomic) SKSpriteNode *strawSprite;
@property (strong, nonatomic) SKSpriteNode *strawMaskSprite;
@property (strong, nonatomic) SKCropNode *croppedStraw;
@property (assign, nonatomic) CGPoint strawOffset;

@property (strong, nonatomic) SKSpriteNode *cupFront;
@property (strong, nonatomic) SKSpriteNode *cupBack;

@property (strong, nonatomic) SKSpriteNode *bronzeStarSprite;
@property (strong, nonatomic) SKSpriteNode *silverStarSprite;
@property (strong, nonatomic) SKSpriteNode *goldStarSprite;

@property (assign, nonatomic) float bronzeLevel;
@property (assign, nonatomic) float silverLevel;
@property (assign, nonatomic) float goldLevel;
@property (assign, nonatomic) StarType starLevel;

@property (assign, nonatomic) float filledHeightDifference;
//@property (assign, nonatomic) float fillSpeed;
@property (assign, nonatomic) float liquidLevel;



// Initializes with arrays of sprites for the liquid and the cup.
// liquidArray[0] is the visible sprite, and liquidArray[1] is the mask.
// cupArray[0] is the back image, and cupArray[1] is the front.
-(id)initWithLiquid:(NSArray*)liquidSpritesArray
         MaskOffset:(CGPoint)maskOffset
                Cup:(NSArray*)cupSpritesArray
          CupOffset:(float)cupOffset
              Straw:(SKSpriteNode*)strawSprite
        StrawOffset:(CGPoint)strawOffset
         StarLevels:(SGVector3*)starLevels
        StarMarkers:(NSArray*)starmarkerSpritesArray;

-(void)setLiquidLevelTo:(float)liquidLevel;

@end
