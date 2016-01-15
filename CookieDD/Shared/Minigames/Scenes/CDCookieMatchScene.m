//
//  MyScene.m
//  NewGame
//
//  Created by Guest User on 7/21/13.
//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import "CDCookieMatchScene.h"
#import "CDCardMatchViewController.h"
//#import "CardSpriteNode.h"

@interface CDCookieMatchScene() <CDCookieMatchSceneDelegate>

@property (strong, nonatomic) CDCardSpriteNode *firstCookieSelected;
@property (strong, nonatomic) CDCardSpriteNode *secondCookieSelected;

@property (assign, nonatomic) CGSize cookieSize;
@property (strong, nonatomic) SKTextureAtlas *atlas;
@property (strong, nonatomic) SKLabelNode *scoreLabel;

@property (assign, nonatomic) float xOffset;
@property (assign, nonatomic) float yOffset;
@property (assign, nonatomic) float cardSpacingVert;
@property (assign, nonatomic) float cardSpacingHorz;
@property (assign, nonatomic) float edgeSpacing;
@property (assign, nonatomic) float previousTime;

@property (assign, nonatomic) BOOL didWin;

@property (assign, nonatomic) int goalScore;
@property (assign, nonatomic) int numCookiesWide;
@property (assign, nonatomic) int numCookiesHigh;
@property (assign, nonatomic) int flipCardCount;
@property (assign, nonatomic) int currentMatchCount;
@property (assign, nonatomic) int maxMatchCount;
@property (assign, nonatomic) int scoreEnd;

@property (strong, nonatomic) SKSpriteNode *timerObject;
@property (strong, nonatomic) SKSpriteNode *scoreObject;

// Dustins sound variables
@property (strong, nonatomic) SKAction* Card_Flip1;
@property (strong, nonatomic) SKAction* Card_Flip2;
@property (strong, nonatomic) SKAction* Card_Flip3;
@property (strong, nonatomic) SKAction* Card_Flip4;


@property (assign, nonatomic) int whichLoserSound;
@property (strong, nonatomic) SKAction* Card_Lose1;
@property (strong, nonatomic) SKAction* Card_Lose2;
@property (strong, nonatomic) SKAction* Card_Lose3;
@property (strong, nonatomic) SKAction* Card_Lose4;
@property (strong, nonatomic) SKAction* Card_Lose5;
@property (strong, nonatomic) SKAction* Card_Lose6;

@property (strong, nonatomic) SKAction* Card_Win1;
@property (strong, nonatomic) SKAction* Card_Win2;
@property (strong, nonatomic) SKAction* Card_Win3;
@property (strong, nonatomic) SKAction* Card_Win4;
@property (strong, nonatomic) SKAction* Card_Win5;
@property (strong, nonatomic) SKAction* Card_Win6;
@property (strong, nonatomic) SKAction* Card_Win7;
@property (strong, nonatomic) SKAction* Card_Win8;

@end

@implementation CDCookieMatchScene

- (void)test:(int)value
{
    DebugLog(@"Test, Test.");
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        self.flipCardCount = 0;
        
        self.scoreEnd = 0;
        
        self.currentMatchCount = 0;
        self.backgroundColor = [SKColor colorWithRed:104.0f/256.0f green:109.0f/256.0f blue:110.0f/256.0f alpha:1.0];
        
        NSString *bgImageString = [NSString stringWithFormat:@"minigame-cardmatch-background%@", [[SGFileManager fileManager] getImageSuffixForDevice]];
        SKSpriteNode *bgSprite = [SKSpriteNode spriteNodeWithImageNamed:bgImageString];
        bgSprite.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgSprite];
        
        
        // Default Values.
        self.firstCookieSelected = nil;
        self.secondCookieSelected = nil;
        
        // Sizes
        // - NOTE: numCardsAcross = totalCards/rnd(sqrt(totalCards))
        //         numCardsDown = ceil(totalCards / numCardsAcross)
        if (IS_IPHONE_5)
        {
            // 4 inch
            self.numCookiesWide = 4;
            self.numCookiesHigh = 5;
            self.edgeSpacing = 6;
        }
        else if (IS_IPHONE_4)
        {
            // 3.5 inch
            self.numCookiesWide = 5;
            self.numCookiesHigh = 4;
            self.edgeSpacing = 8;
        }
        else if (IS_IPAD)
        {
            // iPad
            self.numCookiesWide = 5;
            self.numCookiesHigh = 4;
            self.edgeSpacing = 4;
        }
        
        _maxMatchCount = (_numCookiesHigh * _numCookiesWide)/2;
        
        self.cookieSize = CGSizeMake(57, 80);
        self.cardSpacingHorz = (self.frame.size.width * .85 - (self.numCookiesWide * (self.cookieSize.width + (self.edgeSpacing / 2)))) / (self.numCookiesWide - 1);
        self.cardSpacingVert = (self.frame.size.height * .8 - (self.numCookiesHigh * (self.cookieSize.height + (self.edgeSpacing / 2)))) / (self.numCookiesHigh - 1);
        self.xOffset = self.edgeSpacing;
        self.yOffset = self.edgeSpacing;
        
        // Build stuff up.
        [self createGameboard];
        
        self.enabled = YES;
        self.hasStarted = NO;
        self.previousTime = 0.0f;
        self.userInteractionEnabled = NO;
        
        self.didWin = NO;
        self.goalScore = self.maxMatchCount;
        
        self.whichLoserSound = 0;
        
        self.Card_Flip1 = [SGAudioManager MakeSoundEffectAction:@"Card_Flip1" withFileType:@".wav"];
        self.Card_Flip2 = [SGAudioManager MakeSoundEffectAction:@"Card_Flip2" withFileType:@".wav"];
        self.Card_Flip3 = [SGAudioManager MakeSoundEffectAction:@"Card_Flip3" withFileType:@".wav"];
        self.Card_Flip4 = [SGAudioManager MakeSoundEffectAction:@"Card_Flip4" withFileType:@".wav"];
        self.Card_Lose1 = [SGAudioManager MakeSoundEffectAction:@"Card_Lose1" withFileType:@".wav"];
        self.Card_Lose2 = [SGAudioManager MakeSoundEffectAction:@"Card_Lose2" withFileType:@".wav"];
        self.Card_Lose3 = [SGAudioManager MakeSoundEffectAction:@"Card_Lose3" withFileType:@".wav"];
        self.Card_Lose4 = [SGAudioManager MakeSoundEffectAction:@"Card_Lose4" withFileType:@".wav"];
        self.Card_Lose5 = [SGAudioManager MakeSoundEffectAction:@"Card_Lose5" withFileType:@".wav"];
        self.Card_Lose6 = [SGAudioManager MakeSoundEffectAction:@"Card_Lose6" withFileType:@".wav"];
        self.Card_Win1 = [SGAudioManager MakeSoundEffectAction:@"Card_Win1" withFileType:@".wav"];
        self.Card_Win2 = [SGAudioManager MakeSoundEffectAction:@"Card_Win2" withFileType:@".wav"];
        self.Card_Win3 = [SGAudioManager MakeSoundEffectAction:@"Card_Win3" withFileType:@".wav"];
        self.Card_Win4 = [SGAudioManager MakeSoundEffectAction:@"Card_Win4" withFileType:@".wav"];
        self.Card_Win5 = [SGAudioManager MakeSoundEffectAction:@"Card_Win5" withFileType:@".wav"];
        self.Card_Win6 = [SGAudioManager MakeSoundEffectAction:@"Card_Win6" withFileType:@".wav"];
        self.Card_Win7 = [SGAudioManager MakeSoundEffectAction:@"Card_Win7" withFileType:@".wav"];
        self.Card_Win8 = [SGAudioManager MakeSoundEffectAction:@"Card_Win8" withFileType:@".wav"];
        
        
        _timerLabel = [SKLabelNode labelNodeWithFontNamed:kFontDamnNoisyKids];
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:kFontDamnNoisyKids];
        
        if (IS_IPHONE_4 || IS_IPHONE_5)
        {
            _timerLabel.fontSize = 15;
            _scoreLabel.fontSize = 15;
        }
        else if (IS_IPAD)
        {
            _timerLabel.fontSize = 50;
            _scoreLabel.fontSize = 50;
        }
        
        _timerLabel.position = CGPointMake((_timerObject.frame.size.width * .20), 0 - (_timerObject.frame.size.height * .17));
        _timerLabel.hidden = YES;
        [_timerObject addChild:_timerLabel];
        
    }
    return self;
}

- (void)startMiniGame
{
    self.hasStarted = YES;
    self.userInteractionEnabled = YES;
    self.paused = NO;
    
    if ([self.delegate respondsToSelector:@selector(timeDidPass:WithScore:WithGoalScore:WithWin:)])
    {
        [self.delegate timeDidPass:self WithScore:_currentMatchCount WithGoalScore:_goalScore WithWin:_didWin];
    }
}

- (void)setup
{
    self.hasStarted = NO;
    self.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(cookieMatchDifficultyWasSelected:)])
    {
        [self.delegate cookieMatchDifficultyWasSelected:self];
    }
}

// This sets the cards in a random order on the grid.
- (void)createGameboard
{
    // Find all the images for the cards.
    NSArray *cardFrontImages = [self gatherCardImages];
//    SKTexture *cardBackTexture = [self.atlas textureNamed:@"cardMatch_back"];
    SKTexture *cardBackTexture = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-back"];
    
    SKTexture *tempMainButton = [SKTexture sgtextureWithImageNamed:@"cdd-hud-button"];
    int buttonSize = tempMainButton.size.height;
    
    // Create an array of IDs.  This fixes the infinitely choosing unvailable IDs problem.
    NSMutableArray *cardIDs = [NSMutableArray arrayWithArray:[self generateCardIDs:(self.numCookiesWide * self.numCookiesHigh)/2]];
    DebugLog(@"Card IDs were created");
    
    // This can start anywhere, but zero's nice.
    NSNumber *uniqueID = [NSNumber numberWithInt:0];
    
    // Move through the grid and place a card at each slot.
    for (int x = 0; x < self.numCookiesWide; x++)
    {
        for (int y = 0; y < self.numCookiesHigh; y++)
        {
            //DebugLog(@"Creating a new card at (%i, %i)", x, y);
            
            // Pick a random ID from the array, and remove it.
            int idIndex = arc4random() % [cardIDs count];
            NSNumber *matchID = [cardIDs objectAtIndex:idIndex];
            [cardIDs removeObjectAtIndex:idIndex];
            
            // Find the front image based on the match ID.
            SKTexture *frontTexture;
            if ([cardFrontImages count] > [matchID intValue]) {
                frontTexture = [cardFrontImages objectAtIndex:[matchID intValue]];
            }
            else {
                // You're right Josh, there isn't a texture by this name....
                DebugLog(@"Warning: There isn't a card texture at this index (%@).  Applying the default texture instead.", matchID);
//                frontTexture = [self.atlas textureNamed:@"card-notexture"];
                frontTexture = [SKTexture sgtextureWithImageNamed:@"card-notexture"];

            }
            
            // Create the card and set its properties.
            CDCardSpriteNode *card = [[CDCardSpriteNode alloc] initCardWithUniqueID:uniqueID  MatchID:matchID backTexture:cardBackTexture frontTexture:frontTexture forSize:self.cookieSize];
            CGPoint position = CGPointMake((x * (card.size.width + self.cardSpacingHorz)) + self.xOffset + (card.size.width/2) + (self.frame.size.width * .075), (y * (card.size.height + self.cardSpacingVert)) + self.yOffset + (card.size.height/2) + (buttonSize * .55));
            card.position = position;
            card.delegate = self;
            [self addChild:card];
            
            // Don't forget to get a new uniqueID.
            uniqueID = [NSNumber numberWithInt:[uniqueID intValue] + 1];
        }
    }
}

- (NSArray *)gatherCardImages
{
    _atlas = [SKTextureAtlas atlasNamed:@"cardMatch_retina"];
//    
//    SKTexture *texture1 = [_atlas textureNamed:@"cardMatch-spade-ace"];
//    SKTexture *texture2 = [_atlas textureNamed:@"cardMatch-spade-king"];
//    SKTexture *texture3 = [_atlas textureNamed:@"cardMatch-spade-queen"];
//    SKTexture *texture4 = [_atlas textureNamed:@"cardMatch-club-ace"];
//    SKTexture *texture5 = [_atlas textureNamed:@"cardMatch-club-king"];
//    SKTexture *texture6 = [_atlas textureNamed:@"cardMatch-diamond-ace"];
//    SKTexture *texture7 = [_atlas textureNamed:@"cardMatch-diamond-queen"];
//    SKTexture *texture8 = [_atlas textureNamed:@"cardMatch-heart-jack"];
//    SKTexture *texture9 = [_atlas textureNamed:@"cardMatch-heart-ace"];
//    SKTexture *texture10 = [_atlas textureNamed:@"cardMatch-joker"];
    
    SKTexture *texture1;
    SKTexture *texture2;
    SKTexture *texture3;
    SKTexture *texture4;
    SKTexture *texture5;
    SKTexture *texture6;
    SKTexture *texture7;
    SKTexture *texture8;
    SKTexture *texture9;
    SKTexture *texture10;
    
    if (IS_IPHONE_4)
    {
        DebugLog(@"iphone 4");
        
        _timerObject = [SKSpriteNode spriteNodeWithTexture:[SKTexture sgtextureWithImageNamed:@"cdd-hud-mini-timer"]];
        _timerObject.position = CGPointMake(0 + (_timerObject.size.width * .5), CGRectGetMaxY(self.frame) - _timerObject.size.height * .5);
        [self addChild:_timerObject];
        
        texture1 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-spade-ace"];
        texture2 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-spade-king"];
        texture3 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-spade-queen"];
        texture4 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-club-ace"];
        texture5 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-club-king"];
        texture6 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-diamond-ace"];
        texture7 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-diamond-queen"];
        texture8 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-heart-jack"];
        texture9 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-heart-ace"];
        texture10 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-heart-queen"];
    }
    else if (IS_IPHONE_5)
    {
        DebugLog(@"iphone 5");
        
        _timerObject = [SKSpriteNode spriteNodeWithTexture:[SKTexture sgtextureWithImageNamed:@"cdd-hud-mini-timer"]];
        _timerObject.position = CGPointMake(0 + (_timerObject.size.width * .5), CGRectGetMaxY(self.frame) - _timerObject.size.height * .5);
        [self addChild:_timerObject];
        
        texture1 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-spade-ace-568h"];
        texture2 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-spade-king-568h"];
        texture3 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-spade-queen-568h"];
        texture4 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-club-ace-568h"];
        texture5 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-club-king-568h"];
        texture6 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-diamond-ace-568h"];
        texture7 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-diamond-queen-568h"];
        texture8 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-heart-jack-568h"];
        texture9 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-heart-ace-568h"];
        texture10 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-heart-queen-568h"];
    }
    else if (IS_IPAD)
    {
        DebugLog(@"ipad");
        
        _timerObject = [SKSpriteNode spriteNodeWithTexture:[SKTexture sgtextureWithImageNamed:@"minigame-timer~ipad"]];
        _timerObject.position = CGPointMake(0 + (_timerObject.size.width * .5), CGRectGetMaxY(self.frame) - _timerObject.size.height * .5);
        [self addChild:_timerObject];
        
        texture1 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-spade-ace~ipad"];
        texture2 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-spade-king~ipad"];
        texture3 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-spade-queen~ipad"];
        texture4 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-club-ace~ipad"];
        texture5 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-club-king~ipad"];
        texture6 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-diamond-ace~ipad"];
        texture7 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-diamond-queen~ipad"];
        texture8 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-heart-jack~ipad"];
        texture9 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-heart-ace~ipad"];
        texture10 = [SKTexture sgtextureWithImageNamed:@"minigame-cardmatch-card-heart-queen~ipad"];
    }
    
    
    
    NSArray *cardImagesArray =  [NSArray arrayWithObjects:
                                 texture1, texture2,
                                 texture3, texture4,
                                 texture5, texture6,
                                 texture7, texture8,
                                 texture9, texture10,
                                nil];
    
    return cardImagesArray;
}

// Creates an array of potential IDs for the given number of matches.
- (NSArray *)generateCardIDs:(int)numberOfMatches
{
    NSMutableArray *cardIDs = [[NSMutableArray alloc] init];
    for (int count = 0; count < numberOfMatches; count++)
    {
        [cardIDs addObject:[NSNumber numberWithInt:count]];
        [cardIDs addObject:[NSNumber numberWithInt:count]];
    }
    return cardIDs;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    if (self.enabled) {
        for (UITouch *touch in touches) {
            //Get the touch location.
            CGPoint touchLocation = [touch locationInNode:self];
            
            //Find all the nodes under the touch.
            NSArray *nodes = [self nodesAtPoint:touchLocation];
            
            if ([nodes count]) {
                //If there are nodes, do something.
                for (SKNode *node in nodes) {
                    //Make sure it's the proper type.
                    if ([node isKindOfClass:[CDCardSpriteNode class]]) {
                        //Convert it and do your stuff.
                        CDCardSpriteNode *cardNode = (CDCardSpriteNode *)node;
                        
                        //If it's already revealed, then don't worry about it.
                        if (!cardNode.isRevealed) {
                            self.flipCardCount += 1;
                            
                            if (self.flipCardCount <= 2)
                            {
                                [cardNode revealCard];
                            
                                //Check if this is the first or second card we've selected.
                                if (self.firstCookieSelected) {
                                    //If we've already selected one, make sure we're not reselecting it.
                                    if (cardNode.uniqueID != self.firstCookieSelected.uniqueID) {
                                        //If it's the second, save it for later.
                                        self.secondCookieSelected = cardNode;
                                        
                                        //***  We check for a match when the flip animation  ***//
                                        //***  finishes, in 'cardDidFinishFlipping'.         ***//
                                    }
                                    else {
                                        DebugLog(@"Error: This card is already selected.");
                                    }
                                }
                                //If it's the first, make sure to save it for later.
                                else {
                                    self.firstCookieSelected = cardNode;
                                }
                            }
                        }
                    }
                }
            }
            else {
                //No nodes exist here.
            }
        }
    }
}

#pragma mark - Cards

//Exactly what it says on the tin.
- (BOOL)checkForAMatch {
    if (self.firstCookieSelected.matchID == self.secondCookieSelected.matchID) {
        //DebugLog(@"Match Found.");
        
        int which = arc4random() % 8;
        
        switch (which) {
            case 0:
                [self runAction:self.Card_Win1];
                break;
            case 1:
                [self runAction:self.Card_Win2];
                break;
            case 2:
                [self runAction:self.Card_Win3];
                break;
            case 3:
                [self runAction:self.Card_Win4];
                break;
            case 4:
                [self runAction:self.Card_Win5];
                break;
            case 5:
                [self runAction:self.Card_Win6];
                break;
            case 6:
                [self runAction:self.Card_Win7];
                break;
            case 7:
                [self runAction:self.Card_Win8];
                break;
        }
        
        return YES;
    }
    else {
        //DebugLog(@"Sorry, No Match.");
        
        switch (self.whichLoserSound) {
            case 0:
                [self runAction:self.Card_Lose1];
                break;
            case 1:
                [self runAction:self.Card_Lose2];
                break;
            case 2:
                [self runAction:self.Card_Lose3];
                break;
            case 3:
                [self runAction:self.Card_Lose4];
                break;
            case 4:
                [self runAction:self.Card_Lose5];
                break;
            case 5:
                [self runAction:self.Card_Lose6];
                break;
            
        }
        
        self.whichLoserSound++;
        if(self.whichLoserSound >= 6)
            self.whichLoserSound = 0;

        
        return NO;
    }
}

//Get rid of both cards.
- (void)removeSelectedCards {
    [self.firstCookieSelected removeCard];
    self.firstCookieSelected = nil;
    [self.secondCookieSelected removeCard];
    self.secondCookieSelected = nil;
}

//Set both cards back to hidden.
- (void)resetSelectedCards {
    [self.firstCookieSelected hideCard];
    self.firstCookieSelected = nil;
    [self.secondCookieSelected hideCard];
    self.secondCookieSelected = nil;
    
}
////////
//////////
////////////
//////////////
- (void)update:(CFTimeInterval)currentTime
{
    if (currentTime > self.previousTime+1)
    {
        _previousTime = currentTime;
        if ([self.delegate respondsToSelector:@selector(timeDidPass:WithScore:WithGoalScore:WithWin:)])
        {
            [self.delegate timeDidPass:self WithScore:_currentMatchCount WithGoalScore:_goalScore WithWin:_didWin];
        }
        
 
    }
    // DebugLog(@"Time interval: %f", currentTime);
}

#pragma mark - CardSpriteNodeDelegate

- (void)cardDidFinishFlipping:(CDCardSpriteNode *)card {
    
    // play a flip sound
    int whichFlipSound = arc4random() % 4;
    
    switch (whichFlipSound) {
        case 0:
            [self runAction:self.Card_Flip1];
            break;
        case 1:
            [self runAction:self.Card_Flip2];
            break;
        case 2:
            [self runAction:self.Card_Flip3];
            break;
        case 3:
            [self runAction:self.Card_Flip4];
            break;
            
    }
    
    //Make sure we have both cards selected.
    if (self.firstCookieSelected && self.secondCookieSelected && [card isEqual:self.secondCookieSelected]) {
        //If so, check for a match and react accordingly.
        if ([self checkForAMatch]) {
            [self removeSelectedCards];
            _currentMatchCount  += 1;
            
            self.scoreLabel.text = [NSString stringWithFormat:@"score: %i", _currentMatchCount];
            if (_currentMatchCount >= _maxMatchCount)
            {
                _didWin = YES;
                if ([self.delegate respondsToSelector:@selector(cookieMatchDidEndScene:WithScore:WithGoalScore:WithWin:)])
                {
                    [self.delegate cookieMatchDidEndScene:self WithScore:_currentMatchCount WithGoalScore:_goalScore WithWin:_didWin];

                    //_scoreEnd = _currentMatchCount;
                    DebugLog(@"Score: %i", _scoreEnd);
                }
            }
        }
        else {
            [self resetSelectedCards];
        }
        self.flipCardCount = 0;
        
    }
}

@end
