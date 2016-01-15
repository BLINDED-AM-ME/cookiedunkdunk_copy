//
//  SGCloudWipeSegue.m
//  CookieDD
//
//  Created by Josh on 6/18/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "SGCloudWipeSegue.h"

@implementation SGCloudWipeSegue

- (void)perform {
    
    // Make the source and destination into UIViewControllers so we can access their views.
    UIViewController *destinationViewController = (UIViewController *) self.destinationViewController;
    UIViewController *sourceViewController = (UIViewController *) self.sourceViewController;
    
    // Set up the flash view.
    UIView *flashView = [[UIView alloc] initWithFrame:sourceViewController.view.window.frame];
    [flashView setBackgroundColor:[UIColor colorWithRed:0.998 green:0.922 blue:0.950 alpha:1.000]];
    [flashView setAlpha:0.0f];
    [sourceViewController.view addSubview:flashView];
    
    // Do the animation.
    [UIView animateWithDuration:0.5f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // Animate the sourceViewController to zoom in
                         [sourceViewController.view setTransform:CGAffineTransformMakeScale(1.4f, 1.4f)];
                         
                     } completion:^(BOOL finished) {
                         // Show flash view during transition to destinationViewController
                         [flashView setAlpha:1.0f];
                         [sourceViewController.navigationController presentViewController:destinationViewController
                                                                                 animated:NO
                                                                               completion:^{
                                                                                   // Hide flashView and scale sourceViewController back to normal
                                                                                   [flashView setAlpha:0.0f];
                                                                                   [sourceViewController.view setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                                                                                   
                                                                                   DebugLog(@"Finished transition.");
                                                                               }];

                     }];

//    // Make the source and destination into UIViewControllers so we can access their views.
//    UIViewController *destinationViewController = (UIViewController *) self.destinationViewController;
//    UIViewController *sourceViewController = (UIViewController *) self.sourceViewController;
//    
//    // Add the destination to the source as a subview. (This solves a problem where the source would
//    // go black, even though you can still see it behind the destination.
//    [sourceViewController.view addSubview:destinationViewController.view];
//    [destinationViewController.view setFrame:sourceViewController.view.window.frame];
//    
//    // Set the initial state for the destination view.
//    [destinationViewController.view setAlpha:0.0f];
//    
//    // Set up the flash view.
//    UIView *flashView = [[UIView alloc] initWithFrame:sourceViewController.view.window.frame];
//    [flashView setBackgroundColor:[UIColor colorWithRed:0.998 green:0.922 blue:0.950 alpha:1.000]];
//    [flashView setAlpha:0.0f];
//    [sourceViewController.view addSubview:flashView];
//    
//    
//    //[destinationViewController.view setTransform:CGAffineTransformMakeScale(0.05f, 0.05f)];
//    
//    // Do the animation.
//    [UIView animateWithDuration:0.5f
//                          delay:0.1f
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         // Animate the destination returning to it's original state.
//                         [sourceViewController.view setTransform:CGAffineTransformMakeScale(1.4f, 1.4f)];
//                         
//                     } completion:^(BOOL finished) {
//                         [UIView animateWithDuration:0.05 animations:^{
//                             [flashView setAlpha:1.0f];
//                         } completion:^(BOOL finished) {
//                             [sourceViewController.view setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
//                             [destinationViewController.view setAlpha:1.0f];
//                             [UIView animateWithDuration:1.0f animations:^{
//                                 [flashView setAlpha:0.0f];
//                             } completion:^(BOOL finished) {
//                                 [destinationViewController.view removeFromSuperview];
//                                 [sourceViewController.navigationController presentViewController:destinationViewController
//                                                                                         animated:NO
//                                                                                       completion:nil];
//                                 
//                                 DebugLog(@"Finished transition.");
//                             }];
//                         }];
//                     }];
}

@end
