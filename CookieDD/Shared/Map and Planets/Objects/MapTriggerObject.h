//
//  MapTriggerObject.h
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

#import <UIKit/UIKit.h>
#import "MapObject.h"

@protocol MapTriggerObjectDelegate;

@interface MapTriggerObject : MapObject

// Delegate stuff.
@property (weak, nonatomic) id delegate;

// The trigger id is used to keep track of this icon, as well as any array index connections.
@property (assign, nonatomic) int triggerId;

// Basic method for when the button is tapped.
// - (void)buttonDidActivate;

@end


@protocol MapTriggerObjectDelegate <NSObject>

@optional
// Let's this icon's delegate know when the user taps on it.
- (void)mapTriggerObjectDidTrigger:(MapTriggerObject *)triggerObject;

@end