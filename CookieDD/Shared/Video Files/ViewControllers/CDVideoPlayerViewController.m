//
//  CDVideoPlayerViewController.m
//  CookieDD
//
//  Created by gary johnston on 4/19/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDVideoPlayerViewController.h"
#import "SGFileManager.h"

@interface CDVideoPlayerViewController ()

@end

@implementation CDVideoPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"SKIP"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    
    _skipLabel.attributedText = [attributeString copy];
    [_skipLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:19]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoEnded) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playVideoNamed:(NSString *)videoName {
    _didEnd = NO;
    
//    NSString *thePath = [[NSBundle mainBundle] pathForResource:videoName ofType:@"mp4"];
//    NSURL *theurl = [NSURL fileURLWithPath:thePath];
    NSURL *theurl = [[SGFileManager fileManager] urlForFileNamed:videoName fileType:@"mp4"];
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
    [_moviePlayer.view setFrame:CGRectMake(40, 197, 240, 160)];
    [_moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [_moviePlayer prepareToPlay];
    [_moviePlayer setShouldAutoplay:YES];
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    [_moviePlayer.view setFrame:_videoView.frame];
    
    [self.view insertSubview:_moviePlayer.view belowSubview:_skipView];
}

- (void)videoEnded
{
    DebugLog(@"Movie has finished!");    [_moviePlayer.view removeFromSuperview];
    _moviePlayer = nil;
    
    if (!_didEnd)
    {
        _didEnd = YES;
        
        if ([self.delegate respondsToSelector:@selector(videoPlayerHasEnded:)])
        {
            [self.delegate videoPlayerHasEnded:self];
        }
    }
}

- (IBAction)skipButtonHit:(id)sender
{
    //[self videoEnded];
    [_moviePlayer stop];

}


#pragma mark - Orientation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
