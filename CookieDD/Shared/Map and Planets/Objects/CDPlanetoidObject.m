//
//  CDPlanetoidObject.m
//  CookieDD
//
//  Created by Josh on 10/24/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.
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

#import "CDPlanetoidObject.h"

@interface CDPlanetoidObject()

// General variables.
@property (assign, nonatomic) CGRect baseFrame;
@property (assign, nonatomic) CGAffineTransform baseTransform;
@property (strong, nonatomic) UIView *planetTintOverlay;
@property (strong, nonatomic) UIView *lockTintOverlay;
@property (strong, nonatomic) NSString *basePlanetImageString;

// Morph variables.
@property (assign, nonatomic) float morphTargetPrecision;
@property (assign, nonatomic) float midMorphScale;
@property (assign, nonatomic) float previousXMorph;
@property (assign, nonatomic) bool shouldMorphOut;

@end

@implementation CDPlanetoidObject

- (id)initWithImageNamed:(NSString *)planetImageString {
    self.basePlanetImageString = planetImageString;
    self = [super initWithImageNamed:[NSString stringWithFormat:@"%@%@", self.basePlanetImageString, @"-back"]];
    if (self) {
        [self setPlanetImageFromString:self.basePlanetImageString Animating:NO];
        [self setup];
    }
    return self;
}

- (id)initWithImageNamed:(NSString *)planetImageString AndPosition:(CGPoint)position {
    self.basePlanetImageString = planetImageString;
    self = [super initWithImageNamed:[NSString stringWithFormat:@"%@%@", self.basePlanetImageString, @"-back"] AndPosition:position];
    if (self) {
        [self setPlanetImageFromString:self.basePlanetImageString Animating:NO];
        [self setup];
    }
    return self;
}

- (void)setup {
    [super setup];
    // Idle Animations
    [self initLock];
    self.baseFrame = self.backgroundImageView.frame;
    self.baseTransform = self.backgroundImageView.transform;
    [self setupMorphingAnimation];
}

- (void)initLock {
    UIImage *lockImage = [UIImage imageNamed:@"cdd-main-board-hud-planetlock"];
    CGRect lockFrame = CGRectMake((self.frame.size.width / 2) - (lockImage.size.width / 2),
                                  (self.frame.size.height / 2) - (lockImage.size.height / 2),
                                  lockImage.size.width,
                                  lockImage.size.height);
    
    self.lockImageView = [[UIImageView alloc] initWithFrame:lockFrame];
    self.lockImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.lockImageView setImage:lockImage];
    //[self.lockImageView setAlpha:0.4];
    //[self.lockImageView setTintColor:[UIColor colorWithRed:0.139 green:0.169 blue:0.525 alpha:0.350]];
    
    [self addSubview:self.lockImageView];
    //[self createLockTintLayer];
}

- (void)setPlanetImageFromString:(NSString *)planetImageString Animating:(bool)shouldAnimate {
    UIImage *planetImage = [UIImage imageNamed:planetImageString];
    self.planetImageView = [[UIImageView alloc] initWithImage:planetImage];
    //self.planetImageView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    self.planetImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.planetImageView];
    self.planetImageView.center = self.backgroundImageView.center;
    //[self createPlanetTintLayer];
}

- (void)setPropertiesFromDictionary:(NSDictionary *)propertiesDict {
    self.propertiesDict = propertiesDict;
    
    if (propertiesDict[@"name"]) {
        self.name = propertiesDict[@"name"];
    }
    else {
        self.name = @"Cookie Planet";
    }
    
    if (propertiesDict[@"displayName"]) {
        self.displayName = propertiesDict[@"displayName"];
    }
    else {
        self.displayName = @"cookie_planet";
    }
    
    if (propertiesDict[@"id"]) {
        self.planetID = propertiesDict[@"id"];
    }
    else {
        self.planetID = [NSNumber numberWithInt:-1];
    }
    
    if (propertiesDict[@"bubbleCoords"]) {
        self.bubbleCoords = propertiesDict[@"bubbleCoords"];
    }
    else {
        self.bubbleCoords = [NSArray new];
    }
    
    if (propertiesDict[@"bubbleScales"]) {
        self.bubbleScales = propertiesDict[@"bubbleScales"];
    }
    else {
        NSMutableArray *tempScalesArray = [NSMutableArray new];
        for (int index = 0; index < [_bubbleCoords count]; index++) {
            [tempScalesArray addObject:[NSNumber numberWithInt:1]];
        }
        self.bubbleScales = [NSArray arrayWithArray:tempScalesArray];
    }
    
    if (propertiesDict[@"friendImageOrientation"])
    {
        self.friendImageOrientations = propertiesDict[@"friendImageOrientation"];
    }
    else
    {
        self.friendImageOrientations = [[NSArray alloc] init];
    }
    
    if (propertiesDict[@"minigameName"]) {
        self.minigameName = propertiesDict[@"minigameName"];
    } else {
        self.minigameName = @"'Unknown Game'";
    }
    
    if (propertiesDict[@"minigameStartPoint"]) {
        self.minigameStartPoint = propertiesDict[@"minigameStartPoint"];
    }

//    if (self.isUnlocked) {
//        [self setActive];
//    } else {
//        [self setInactive];
//    }
    
    if (propertiesDict[@"morphScaleMin"])
    {
        self.morphScaleMin = [propertiesDict[@"morphScaleMin"] floatValue];
    }
    else
    {
        self.morphScaleMin = 0.95f;
    }
    
    if (propertiesDict[@"morphScaleMax"])
    {
        self.morphScaleMax = [propertiesDict[@"morphScaleMax"] floatValue];
    }
    else
    {
        self.morphScaleMax = 1.05f;
    }
    
    // Offsest
    if (propertiesDict[@"atmosphereOffset"]) {
        self.atmosphereOffset = CGPointFromString(propertiesDict[@"atmosphereOffset"]);
        CGRect destFrame = self.planetImageView.frame;
        destFrame.origin = CGPointMake(destFrame.origin.x + self.atmosphereOffset.x, destFrame.origin.y + self.atmosphereOffset.y);
        self.planetImageView.frame = destFrame;
        self.planetTintOverlay.frame = destFrame;
    }
//    else {
//        self.atmosphereOffset = CGPointMake(0.0f, 0.0f);
//    }
//    CGRect tempAtmosFrame = self.backgroundImageView.frame;
//    tempAtmosFrame.origin = CGPointMake(tempAtmosFrame.origin.x + self.atmosphereOffset.x, tempAtmosFrame.origin.y + self.atmosphereOffset.y);
//    self.planetImageView.center = CGPointMake(tempAtmosFrame.origin.x + (tempAtmosFrame.size.width/2), tempAtmosFrame.origin.y + (tempAtmosFrame.size.height/2));
}

- (void)setIsUnlocked:(BOOL)isUnlocked {
    _isUnlocked = isUnlocked;
    if (isUnlocked) {
        [self setActive];
    }
    else {
        [self setInactive];
    }
}

//- (void)createPlanetTintLayer {
//    // Initialize the overlay view we'll use to tint the planet image.
//    self.planetTintOverlay = [[UIView alloc] initWithFrame:self.planetImageView.frame];
//    
//    // Create a mask for the tint, so transparent pixels are ignored.
//    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:self.planetImageView.image];
//    [maskImageView setFrame:self.planetTintOverlay.bounds];
//    [[self.planetTintOverlay layer] setMask:[maskImageView layer]];
//    
//    // Make the overlay clear (no tint) initially.
//    self.planetTintOverlay.backgroundColor = [UIColor yellowColor];
//    self.planetTintOverlay.alpha = 0.8f;
//    
//    // Add the overlay to the pile.
//    [self addSubview:self.planetTintOverlay];
//}

//- (void)createLockTintLayer {
//    // Initialize the overlay view we'll use to tint the planet image.
//    self.lockTintOverlay = [[UIView alloc] initWithFrame:self.lockImageView.frame];
//    
//    // Create a mask for the tint, so transparent pixels are ignored.
//    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:self.lockImageView.image];
//    [maskImageView setFrame:self.lockImageView.bounds];
//    [[self.lockImageView layer] setMask:[maskImageView layer]];
//    
//    // Set the tint color.
//    self.lockTintOverlay.backgroundColor = [UIColor colorWithRed:0.139 green:0.169 blue:0.525 alpha:0.350];
//    
//    // Add the overlay to the pile.
//    [self addSubview:self.lockTintOverlay];
//}

- (void)setupMorphingAnimation {
    self.morphScaleLimit = 0.94f;
    self.midMorphScale = self.morphScaleLimit + ((1 - self.morphScaleLimit)/2);
    self.morphMargin = 0.5f;
    self.morphSpeed = 1.0f;
    self.morphTargetPrecision = 1000.0f;
    //self.morphTargetReference = (1 - self.morphScaleLimit) * self.morphTargetPrecision;
    
    self.backgroundImageView.transform = CGAffineTransformScale(self.transform, self.midMorphScale, self.midMorphScale);
    self.previousXMorph = self.midMorphScale;
    
    self.shouldMorphOut = YES;
}

//- (void)setupScalingAnimation {
//    //self.transform = CGAffineTransformScale(self.transform, 0.9f, 0.9f);
//    //self.previousScale = 0.9f;
//    
//    //self.shouldScaleOut = YES;
//}

- (void)setupPlanetoidScene {
    DebugLog(@"Create the planetoid scene for %@.", self.name);
    // TODO: Create a scene, and fill it with little animated details.
}


#pragma mark - Active State

- (void)setActive {
    UIImage *planetImage = [UIImage imageNamed:self.basePlanetImageString];
    [self.planetImageView setImage:planetImage];
    self.lockImageView.hidden = YES;
}

- (void)setInactive {
    UIImage *planetImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.basePlanetImageString, @"-locked"]];
    [self.planetImageView setImage:planetImage];
    self.lockImageView.hidden = NO;
}

- (void)tintBackgroundWithColor:(UIColor *)tintColor {
    [super tintBackgroundWithColor:tintColor];
    self.planetTintOverlay.backgroundColor = tintColor;
}


#pragma mark - Morphing

- (void)morphBubble:(CALayer *)layer
{
//    float targetXMorph;
//    if (self.shouldMorphOut) {
//        targetXMorph = self.previousXMorph + ((1 - self.previousXMorph) * [self chooseNewMorphTarget]);
//    }
//    else {
//        targetXMorph = self.previousXMorph - ((self.previousXMorph - self.morphScaleLimit) * [self chooseNewMorphTarget]);
//    }
//    self.shouldMorphOut = !self.shouldMorphOut;
//    float targetYMorph = self.midMorphScale - (targetXMorph - self.midMorphScale);
//    float deltaScale = fabsf(self.previousXMorph - targetXMorph);
//    float animationDuration = (deltaScale * (1/(1-self.morphScaleLimit)))/self.morphSpeed;
//    self.previousXMorph = targetXMorph;
//    
//    [UIView animateWithDuration:animationDuration delay:0.0f options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
//        
//        self.backgroundImageView.transform = CGAffineTransformMakeScale(targetXMorph, targetYMorph);
//        
//    } completion:^(BOOL finished) {
//        if (_willMorphBubble) {
//            [self morphBubble];
//        }
//    }];
    
    // Nate
    // Use CAKeyFrameAnimation to animate morphBubble
    
    // Allocate a CAKeyFrameAnimation for the specified keyPath
    CAKeyframeAnimation *transformScaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    
    // Allocate array to hold the values to interpolate
    NSMutableArray *valuesX = [[NSMutableArray alloc] init];
    // Add the start value
    [valuesX addObject:[NSNumber numberWithFloat:self.morphScaleMax]];
    // Add the end value
    [valuesX addObject:[NSNumber numberWithFloat:self.morphScaleMin]];
    // Set the values that should be interpolated during the animation
    transformScaleX.values = valuesX;
    
    // Allocate a CAKeyFrameAnimation for the specified keyPath
    CAKeyframeAnimation *transformScaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    
    // Allocate array to hold the values to interpolate
    NSMutableArray *valuesY = [[NSMutableArray alloc] init];
    // Add the start value
    [valuesY addObject:[NSNumber numberWithFloat:self.morphScaleMin]];
    // Add the end value - value to scale up to
    [valuesY addObject:[NSNumber numberWithFloat:self.morphScaleMax]];
    // Set the values that should be interpolated during the animation
    transformScaleY.values = valuesY;
    
    // Create animation group to hold morphing animations
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    // Add animations to group
    group.animations = [NSArray arrayWithObjects:transformScaleX, transformScaleY, nil];
    
    // Set animation group values
    group.duration = 2.0f;
    group.repeatCount = HUGE_VAL;
    group.autoreverses = YES;
    
    // Add animation group to layer
    [layer addAnimation:group forKey:@"transform"];
    //[self.backgroundImageView.layer addAnimation:group forKey:@"transform"];
    
}

// NOTE
// It's Morphing Time!
- (void)startMorphBubble
{
    _willMorphBubble = YES;
}

// NOTE
// The Power Rangers Died!
- (void)endMorphBubble
{
    _willMorphBubble = NO;
}

- (float)chooseNewMorphTarget {
    float morphTarget = ((arc4random() % (int)(self.morphMargin * self.morphTargetPrecision))/self.morphTargetPrecision) + self.morphMargin;
    return morphTarget;
}

@end
