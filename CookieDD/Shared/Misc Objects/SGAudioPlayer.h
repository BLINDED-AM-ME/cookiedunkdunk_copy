//
//  SWAudioPlayer.h
//  AudioPlayerCompletion
//
//  Created by Josh on 5/21/14.
//  Copyright (c) 2014 SevenGunGames. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef void (^SGAudioPlayerBlock)(BOOL);

@protocol SGAudioPlayerDelegate;



@interface SGAudioPlayer : AVAudioPlayer <AVAudioPlayerDelegate> {
    
@protected SGAudioPlayerBlock delegateBlock;
    
}


@property (assign, nonatomic) float baseVolume;




-(void)playWithCompletion:(SGAudioPlayerBlock)delegate;

@end


@protocol SGAudioPlayerDelegate <NSObject>

@optional
-(void)audioPlayerDidStop:(SGAudioPlayer *)player;
-(void)audioPlayerDidFinishPlaying:(SGAudioPlayer *)player successfully:(BOOL)flag;

@end