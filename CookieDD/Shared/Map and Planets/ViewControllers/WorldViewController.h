//
//  WorldViewController.h
//  Map_Plist
//
//  Created by Josh on 9/24/13.
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
#import "MapTriggerObject.h"
#import "CDStoreObject.h"
#import "SGGalaxyObject.h"
#import "CDPlanetoidObject.h"
#import "CDTravelDot.h"
#import "CDSateliteObject.h"

@protocol WorldViewControllerDelegate;

@interface WorldViewController : UIViewController <MapTriggerObjectDelegate, CDStoreObjectDelegate>


// Delegate Stuff
@property (weak, nonatomic) id<WorldViewControllerDelegate> delegate;

// General Properties

@property (strong, nonatomic) NSDictionary *worldPropertiesDictionary; // Describes all the icons, detail objects, etc. for this world.

@property (assign, nonatomic) CGPoint position; // (0, 0) is centered, (0, 1) is one to the right, etc.
@property (strong, nonatomic) NSArray *regionsArray; // These are the areas we zoom in on to see an entire region.
@property (strong, nonatomic) NSArray *regionIconsArray; // These are the icons that represent specific regions.
@property (strong, nonatomic) NSArray *detailObjectsArray; // These are the extra little images that aren't part of the background.
@property (strong, nonatomic) NSArray *roadPiecesArray; // These are the chunks of road that become visible as you beat levels. -Not Implemented-

@property (strong, nonatomic) CDStoreObject *storeShip;


// Storyboard Outlets

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


// Public Methods

- (void)buildWorldFromProperties:(NSDictionary *)worldProperties;
- (void)addHologramWithSatelite:(CDSateliteObject *)sateliteObject;
@end


@protocol WorldViewControllerDelegate <NSObject>

@optional
- (void)userSelectedPlanetoid:(CDPlanetoidObject *)planetoidObject;
- (void)userSelectedStore:(CDStoreObject *)storeObject;
- (void)worldViewController:(WorldViewController *)controller didSelectPlanetoidSatelite:(CDSateliteObject *)sateliteObject;
@end
