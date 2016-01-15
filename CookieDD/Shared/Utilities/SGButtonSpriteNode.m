//
//  SGButtonSpriteNode.m
//  CookieDD
//
//  Created by Josh on 8/5/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "SGButtonSpriteNode.h"

@implementation SGButtonSpriteNode

- (id)initWithColor:(UIColor *)color size:(CGSize)size {
    self = [super initWithColor:color size:size];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithTexture:(SKTexture *)texture {
    self = [super initWithTexture:texture];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size {
    self = [super initWithTexture:texture color:color size:size];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.userInteractionEnabled = YES;
    self.tag = NULL;
    
    [self setupTextLabel];
}

- (void)setupTextLabel {
    self.textLabel = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [self.textLabel setFontColor:[UIColor colorWithRed:0.135 green:0.235 blue:0.605 alpha:1.000]];
    //[self.textLabel setText:@"Button"];
    [self.textLabel setFontSize:8.0f];
    [self.textLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [self.textLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self addChild:self.textLabel];
}



#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(buttonSpriteNodeWasSelected:)]) {
        [self.delegate buttonSpriteNodeWasSelected:self];
    }
}

@end
