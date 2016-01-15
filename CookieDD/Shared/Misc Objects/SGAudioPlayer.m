//
//  SWAudioPlayer.m
//  AudioPlayerCompletion
//
//  Created by Josh on 5/21/14.
//  Copyright (c) 2014 SevenGunGames. All rights reserved.
//

#import "SGAudioPlayer.h"

@interface  SGAudioPlayer() <SGAudioPlayerDelegate>

@property (weak, nonatomic) id <SGAudioPlayerDelegate> originalDelegate;
@property (nonatomic, copy) SGAudioPlayerBlock delegateBlock;

@end



@implementation SGAudioPlayer

@synthesize delegateBlock;


- (id)initWithContentsOfURL:(NSURL *)url error:(NSError *__autoreleasing *)outError {
    self = [super initWithContentsOfURL:url error:outError];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.baseVolume = self.volume;
}


#pragma mark - Custom Methods

- (void)playWithCompletion:(SGAudioPlayerBlock)delegate {
    // Play the audio like normal.
    [super play];
    
    // Set up the completion block.
    self.delegateBlock = delegate;
    self.originalDelegate = (SGAudioPlayer *)self.delegate;
    self.delegate = self;
}

- (void)stop {
    [super stop];
    
    if ([self.originalDelegate respondsToSelector:@selector(audioPlayerDidStop:)]) {
        [self.originalDelegate audioPlayerDidStop:self];
    }
}



#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    delegateBlock(flag);
    
    if ([self.originalDelegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
        [self.originalDelegate audioPlayerDidFinishPlaying:self successfully:flag];
    }
}

@end
