//
//  ZoomInSegue.m
//  Map_Plist
//
//  Created by Josh on 10/2/13.
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

#import "ZoomInSegue.h"

@implementation ZoomInSegue

- (void)perform {
    // Make the source and destination into UIViewControllers so we can access their views.
    UIViewController *destinationViewController = (UIViewController *) self.destinationViewController;
    UIViewController *sourceViewController = (UIViewController *) self.sourceViewController;
    
    // Add the destination to the source as a subview. (This solves a problem where the source would
    // go black, even though you can still see it behind the destination.
    [sourceViewController.view addSubview:destinationViewController.view];
    [destinationViewController.view setFrame:sourceViewController.view.window.frame];
    
    // Set the initial state for the destination view.
    [destinationViewController.view setTransform:CGAffineTransformMakeScale(0.05f, 0.05f)];
    [destinationViewController.view setAlpha:0.8f];
    
    // Do the animation.
    [UIView animateWithDuration:0.66f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Animate the destination returning to it's original state.
                         [destinationViewController.view setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                         [destinationViewController.view setAlpha:1.0f];
                         
                        } completion:^(BOOL finished) {
                            // remove the temporary destination view from the source and present it properly
                            // without animation, to give the illusion that we presented with a zoom.
                            [destinationViewController.view removeFromSuperview];
                            [sourceViewController.navigationController presentViewController:destinationViewController animated:NO completion:^{
                                // This is empty.
                            }];
    }];
}

@end
