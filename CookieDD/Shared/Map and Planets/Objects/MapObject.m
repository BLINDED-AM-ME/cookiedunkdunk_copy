//
//  MapObject.m
//  Map_Plist
//
//  Created by Josh on 9/30/13.
//  Copyright (c) 2013 Josh. All rights reserved.
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

#import "MapObject.h"

@interface MapObject()

@property (strong, nonatomic) UIView *tintOverlay;

@end

@implementation MapObject

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setup];
        [self createSubviewFrameFromFrame:frame];
    }
    return self;
}

- (id)initAtPosition:(CGPoint)position {
    CGRect frame = CGRectMake(position.x, position.y, 0, 0);
    self = [self initWithFrame:frame];
    if (self) {
        [self createSubviewFrameFromFrame:frame];
        [self createBackgroundWithImage:nil];
    }
    
    return self;
}

- (id)initWithImageNamed:(NSString *)backgroundImageString {
    self = [self initWithImageNamed:backgroundImageString AndPosition:CGPointZero];
    if (self) {
        // Stuff
        
    }
    
    return self;
}

- (id)initWithImageNamed:(NSString *)backgroundImageString AndPosition:(CGPoint)position {
    UIImage *backgroundImage = [UIImage imageNamed:backgroundImageString];
    CGRect frame = CGRectMake(position.x, position.y, backgroundImage.size.width, backgroundImage.size.height);
    
    self = [self initWithFrame:frame];
    if (self) {
        // Stuff
        
        [self createSubviewFrameFromFrame:frame];
        [self createBackgroundWithImage:backgroundImage];
    }
    
    return self;
}

- (void)setup {
    _scale = 1.0f;
    self.autoresizesSubviews = YES;
}

- (void)setPosition:(CGPoint)position {
    _position = position;
    CGRect newFrame = self.frame;
    newFrame.origin = position;
    self.frame = newFrame;
}

- (void)setScale:(float)scale {
    _scale = scale;
    CGPoint originalCenter = self.center;
    float newWidth = self.frame.size.width * scale;
    float newHeight = self.frame.size.height * scale;
    CGRect newRect = CGRectMake(self.center.x - (newWidth/2), self.center.y - (newHeight/2), newWidth, newHeight);
    self.frame = newRect;
    self.center = originalCenter;
}

#pragma mark - Basic Construction

- (void)createSubviewFrameFromFrame:(CGRect)baseFrame {
    baseFrame.origin.x = 0.0f;
    baseFrame.origin.y = 0.0f;
    self.subviewFrame = baseFrame;
}

- (void)createBackgroundWithImage:(UIImage *)backgroundImage {
    self.backgroundImageView = [[UIImageView alloc] init];
    if (backgroundImage) {
        [self.backgroundImageView setImage:backgroundImage];
    }
    self.backgroundImageView.frame = self.subviewFrame;
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.backgroundImageView];
    
    [self createTintLayer];
}

#pragma mark - Animation

- (void)startAnimatingWithFrames:(NSArray *)animationFrames UsingAnimationDuration:(float)animationDuration {
    self.backgroundImageView.animationImages = animationFrames;
    self.backgroundImageView.animationDuration = animationDuration;
    [self.backgroundImageView startAnimating];
}

#pragma mark - Tinting

- (void)createTintLayer {
    // Initialize the overlay view we'll use to tint everything.
    self.tintOverlay = [[UIView alloc] initWithFrame:self.backgroundImageView.frame];

    // Create a mask for the tint, so transparent pixels are ignored.
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:self.backgroundImageView.image];
    [maskImageView setFrame:self.tintOverlay.bounds];
    [[self.tintOverlay layer] setMask:[maskImageView layer]];

    // Make the overlay clear (no tint) initially.
    self.tintOverlay.backgroundColor = [UIColor clearColor];

    // Add the overlay to the pile.
    [self addSubview:self.tintOverlay];
}

- (void)tintBackgroundWithColor:(UIColor *)tintColor {
    self.tintOverlay.backgroundColor = tintColor;
}

@end
