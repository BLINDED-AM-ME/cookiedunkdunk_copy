//
//  CDVideoPlayerViewController.h
//  CookieDD
//
//  Created by gary johnston on 4/19/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol CDVideoPlayerViewControllerDelegate;



@interface CDVideoPlayerViewController : UIViewController

@property (weak, nonatomic) id<CDVideoPlayerViewControllerDelegate> delegate;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@property (weak, nonatomic) IBOutlet UIView *skipView;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *skipLabel;

@property (assign, nonatomic) BOOL didEnd;

- (void)playVideoNamed:(NSString*)videoName;

- (IBAction)skipButtonHit:(id)sender;

@end




@protocol CDVideoPlayerViewControllerDelegate <NSObject>

@required
- (void)videoPlayerHasEnded:(CDVideoPlayerViewController *) videoViewController;

@end