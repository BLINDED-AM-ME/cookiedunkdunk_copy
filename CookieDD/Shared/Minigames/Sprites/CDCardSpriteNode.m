//
//  CardSpriteNode.m
//  NewGame
//
//  Created by Guest User on 7/21/13.
//  Copyright (c) 2013 Guest User. All rights reserved.
//

#import "CDCardSpriteNode.h"
//#import "SGAppDelegate.h"

@interface CDCardSpriteNode()

@property (assign, nonatomic) bool shouldFlip;
@property (assign, nonatomic) bool didFlip;
@property (strong, nonatomic) UIImage *backImage;
@property (strong, nonatomic) UIImage *frontImage;
@property (strong, nonatomic, readwrite) NSNumber *uniqueID;
@property (strong, nonatomic, readwrite) NSNumber *matchID;


@end

@implementation CDCardSpriteNode

///////testing

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

///end

- (id)initCardWithUniqueID:(NSNumber *)uniqueID MatchID:(NSNumber *)matchID backTexture:(SKTexture *)backTexture frontTexture:(SKTexture *)frontTexture forSize:(CGSize)size {
    self.uniqueID = uniqueID;
    self.matchID = matchID;
    self.isRevealed = NO;
    
    //The back texture is simple.
    self.backTexture = backTexture;
    
    //The front, not so much.
    
    self.frontTexture = frontTexture;
    
    return [super initWithTexture:self.backTexture color:nil size:size];
}

// Always sets the card to show it's front texture.
- (void)revealCard {
    self.isRevealed = YES;
    [self animateToShowTexture:self.frontTexture];
}

// Always sets the card to show it's back texture.
- (void)hideCard {
    self.isRevealed = NO;
    [self animateToShowTexture:self.backTexture];
}

// Alternates the card between it's front and back textures.
- (void)flipCard {
    if (self.isRevealed) {
        [self hideCard];
    }
    else {
        [self revealCard];
    }
}

// Main logic for the flip animation.
- (void)animateToShowTexture:(SKTexture *)texture {
    float flipDuration = 0.25f;
    
    // This causes the cards to flip their front and back textures.
    SKAction *turnUp = [SKAction scaleXTo:0.0 duration:flipDuration];
    turnUp.timingMode = SKActionTimingEaseOut;
    SKAction *switchTexture = [SKAction setTexture:texture];
    SKAction *turnDown = [SKAction scaleXTo:1.0 duration:flipDuration];
    turnDown.timingMode = SKActionTimingEaseIn;
    SKAction *flipAction = [SKAction sequence:[NSArray arrayWithObjects:turnUp, switchTexture, turnDown, nil]];
    
    // Give a little bump vertically to help make it feel 3D.
    float moveDistance = 3.0f;
    SKAction *moveUp = [SKAction moveByX:0.0f y:moveDistance duration:flipDuration];
    moveUp.timingMode = SKActionTimingEaseOut;
    SKAction *moveDown = [SKAction moveByX:0.0f y:-moveDistance duration:flipDuration];
    moveDown.timingMode = SKActionTimingEaseIn;
    SKAction *moveAction = [SKAction sequence:[NSArray arrayWithObjects:moveUp, moveDown, nil]];
    
    // Scale it, because I'm still trying to make it feel 3D.
    float scaledSize = 1.05f;
    SKAction *scaleUp = [SKAction scaleYTo:scaledSize duration:flipDuration];
    scaleUp.timingMode = SKActionTimingEaseOut;
    SKAction *scaleDown = [SKAction scaleYTo:1.0f duration:flipDuration];
    scaleDown.timingMode = SKActionTimingEaseIn;
    SKAction *scaleAction = [SKAction sequence:[NSArray arrayWithObjects:scaleUp, scaleDown, nil]];
    
    // Run the animation.
    [self runAction:[SKAction group:[NSArray arrayWithObjects:flipAction, moveAction, scaleAction, nil]] completion:^{
        if ([self.delegate respondsToSelector:@selector(cardDidFinishFlipping:)]) {
            [self.delegate cardDidFinishFlipping:self];
        }
    }];
}

// Any cleanup or outro code goes here.
- (void)removeCard {
    
    float fadeDuration = 0.3f;
    SKAction *scaleDown = [SKAction scaleTo:0.6f duration:fadeDuration];
    SKAction *fade = [SKAction fadeAlphaTo:0.0f duration:fadeDuration];
    SKAction *fadeOut = [SKAction group:[NSArray arrayWithObjects:scaleDown, fade, nil]];
    [self runAction:fadeOut completion:^{
        [self removeFromParent];
    }];
}

@end
