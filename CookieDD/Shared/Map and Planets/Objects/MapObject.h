//
//  MapObject.h
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

@interface MapObject : UIView

  ////////////////////
 // * Properties * //
////////////////////

// This is used to create a localized frame for subviews to be added to. Using 'self.frame' causes
// added subviews to inherit the MapObject's position, when all we want is the size.
@property (assign, nonatomic) CGRect subviewFrame;

// This is the main image view that shows the MapObject's image.
@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (assign, nonatomic) CGPoint position;

@property (assign, nonatomic) float scale;



  /////////////////
 // * Methods * //
/////////////////

// Initializes the MapObject at a given point with a zero'd frame.
-(id)initAtPosition:(CGPoint)position;

// Initializes the MapObject with the proviced UIImage, setting the Object's width and height to match.
-(id)initWithImageNamed:(NSString*)backgroundImageString;

// Same as 'initWithImage', but sets position as well. This way you don't have to mess with frames
// after it's created.
-(id)initWithImageNamed:(NSString*)backgroundImageString AndPosition:(CGPoint)position;

-(void)startAnimatingWithFrames:(NSArray*)animationFrames UsingAnimationDuration:(float)animationDuration;

// This tints the background image using the selected color.
-(void)tintBackgroundWithColor:(UIColor*)tintColor;

- (void)setup;


@end
