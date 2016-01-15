//
//  MapTriggerObject.m
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

#import "MapTriggerObject.h"

@interface MapTriggerObject()

@end

@implementation MapTriggerObject

#pragma mark - Init

// These inits only add a UIButton to the icon.
- (id)initWithImageNamed:(NSString *)backgroundImageString {
    self = [super initWithImageNamed:backgroundImageString];
    if (self) {
        // Stuff
        
    }
    return self;
}

- (id)initWithImageNamed:(NSString *)backgroundImageString AndPosition:(CGPoint)position {
    self = [super initWithImageNamed:backgroundImageString AndPosition:position];
    if (self) {
        // Stuff
        
    }
    return self;
}

- (void)setup {
    [super setup];
    [self createActivationButton];
}

#pragma mark - Trigger Button

// Adds a button over the icon, which is used to sense when the user taps this icon.
- (void)createActivationButton {
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleFingerTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self activateButton];
}
#pragma mark - Delegate

// Tell the delegate that this icon's been triggered.
- (void)activateButton
{
    if ([self.delegate respondsToSelector:@selector(mapTriggerObjectDidTrigger:)])
    {
        [self.delegate mapTriggerObjectDidTrigger:self];
    }
}


@end
