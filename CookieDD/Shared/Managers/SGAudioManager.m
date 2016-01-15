//
//  SGAudioManager.m
//  CookieDD
//
//  Created by Luke McDonald on 9/30/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.
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

#import "SGAudioManager.h"
#import "SGFileManager.h"

static SGAudioManager *audioManager = nil;

@interface SGAudioManager() <AVAudioPlayerDelegate, SGAudioPlayerDelegate>

// Original
@property (strong, nonatomic) NSMutableArray *audioPlayersArray;

// New
@property (strong, nonatomic) SGAudioPlayer *musicPlayer;
@property (assign, nonatomic) float baseMusicVolume;

@property (strong, nonatomic) NSMutableArray *soundEffectPlayersArray;

@end



@implementation SGAudioManager

//@synthesize soundEffectCompletionHandler;

+ (SGAudioManager *)audioManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioManager = [SGAudioManager new];
    });
    
    return audioManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        // Original
        self.audioPlayersArray = [NSMutableArray new];
        
        // New
        self.soundEffectPlayersArray = [NSMutableArray new];
    }
    
    return self;
}




#pragma mark - Music

- (void)playBackgroundMusicWithFilename:(NSString *)fileName FileType:(NSString *)fileType {
    [self playBackgroundMusicWithFilename:fileName FileType:fileType volume:1.0f numberOfLoopes:-1 completion:nil];
}

- (void)playBackgroundMusicWithFilename:(NSString *)fileName FileType:(NSString *)fileType volume:(float)volume {
    [self playBackgroundMusicWithFilename:fileName FileType:fileType volume:volume numberOfLoopes:-1 completion:nil];
}

- (void)playBackgroundMusicWithFilename:(NSString *)fileName FileType:(NSString *)fileType volume:(float)volume numberOfLoopes:(int)loopCount {
    [self playBackgroundMusicWithFilename:fileName FileType:fileType volume:volume numberOfLoopes:loopCount completion:nil];
}

- (void)playBackgroundMusicWithFilename:(NSString *)fileName FileType:(NSString *)fileType volume:(float)volume numberOfLoopes:(int)loopCount completion:(void (^)(void))block {
    [self.musicPlayer stop];
    
    NSURL *url = [[SGFileManager fileManager] urlForFileNamed:fileName fileType:fileType];
     
    if (url) {
        NSError *error = nil;
        self.musicPlayer = [[SGAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) {
            DebugLog(@"Error initializing music player: %@", error.description);
            return;
        }
        
        // Set the volume.
        self.baseMusicVolume = volume;
        [self.musicPlayer setBaseVolume:volume];
        [self updateMusicVolume];
        
        // Keep us updated.
        [self.musicPlayer setDelegate:self];
        
        // Anything below 0 will loop infinitly.
        [self.musicPlayer setNumberOfLoops:loopCount];
        
        // Start the music.
        [self.musicPlayer playWithCompletion:^(BOOL finishedSuccessfully) {
            if (block) block();
        }];
    }
    else {
        DebugLog(@"Error: Could not find music file '%@.%@'", fileName, fileType);
    }
}

- (float)getMusicVolumeMultiplier {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *musicState = [userDefaults objectForKey:@"musicButtonState"];
    
    if ([musicState isEqualToString:@"mute"]) {
        return 0.0f;
    }
    else if ([musicState isEqualToString:@"play"]) {
        return 1.0f;
    }
    
    // For safety.
    return 1.0f;
}

- (void)updateMusicVolume {
    
    float volumeMultiplier = [self getMusicVolumeMultiplier] * [self getSoundEffectVolumeMultiplier];
    [self.musicPlayer setVolume:self.musicPlayer.baseVolume * volumeMultiplier];

}

- (void)playTheMusic {
    DebugLog(@"playing the music.");
    [self.musicPlayer play];
}

- (void)stopTheMusic {
    DebugLog(@"stopping the music.");
    [self.musicPlayer stop];
}

- (void)pauseTheMusic {
    DebugLog(@"pausing music.");
    [self.musicPlayer pause];
}




#pragma mark - Sound Effects

- (SGAudioPlayer *)playSoundEffectWithFilename:(NSString *)fileName
                                      FileType:(NSString *)fileType {
    
    return [self playSoundEffectWithFilename:fileName FileType:fileType volume:1.0f numberOfLoopes:0 delay:0.0f completion:nil];
}

- (SGAudioPlayer *)playSoundEffectWithFilename:(NSString *)fileName
                                      FileType:(NSString *)fileType
                                        volume:(float)volume {
    
    return [self playSoundEffectWithFilename:fileName FileType:fileType volume:volume numberOfLoopes:0 delay:0.0f completion:nil];
}

- (SGAudioPlayer *)playSoundEffectWithFilename:(NSString *)fileName
                                      FileType:(NSString *)fileType
                                        volume:(float)volume
                                    completion:(void (^)(void))block {
    
    return [self playSoundEffectWithFilename:fileName FileType:fileType volume:volume numberOfLoopes:0 delay:0.0f completion:^{
        if (block) block();
    }];
}

- (SGAudioPlayer *)playSoundEffectWithFilename:(NSString *)fileName
                                      FileType:(NSString *)fileType
                                        volume:(float)volume
                                numberOfLoopes:(int)loopCount {
    
    return [self playSoundEffectWithFilename:fileName FileType:fileType volume:volume numberOfLoopes:loopCount delay:0.0f completion:nil];
}

- (SGAudioPlayer *)playSoundEffectWithFilename:(NSString *)fileName
                                      FileType:(NSString *)fileType
                                        volume:(float)volume
                                numberOfLoopes:(int)loopCount
                                    completion:(void(^)(void))block {
    
    return [self playSoundEffectWithFilename:fileName FileType:fileType volume:volume numberOfLoopes:loopCount delay:0.0f completion:^{
        if (block) block();
    }];
}

- (SGAudioPlayer *)playSoundEffectWithFilename:(NSString *)fileName
                                      FileType:(NSString *)fileType
                                        volume:(float)volume
                                numberOfLoopes:(int)loopCount
                                         delay:(float)delay
                                    completion:(void (^)(void))block {
    
    // Only create sound effect if the app is currently active.  Crashes can happen otherwise.
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        
        NSURL *url = [[SGFileManager fileManager] urlForFileNamed:fileName fileType:fileType];
        
        if (url) {
            NSError *error = nil;
            SGAudioPlayer *soundEffectPlayer = [[SGAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if (error) {
                DebugLog(@"Error initializing sound effect player: %@", error.description);
                return nil;
            }
            
            // Set the volume.
            float baseVolume = volume * [self getSoundEffectVolumeMultiplier];
            [soundEffectPlayer setVolume:baseVolume];
            [soundEffectPlayer setBaseVolume:baseVolume];
            
            // Set # of loops.
            [soundEffectPlayer setNumberOfLoops:loopCount];
            
            // Make sure it keeps us updated.
            soundEffectPlayer.delegate = self;
            
            // Add it to the list.
            [self.soundEffectPlayersArray addObject:soundEffectPlayer];
            
            // If a delay was set, wait for it.
            if (delay > 0.0f) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [soundEffectPlayer playWithCompletion:^(BOOL finishedSuccessfully) {
                        if (block) block();
                    }];
                });
            }
            // If there's no delay, then just play.
            else {
                [soundEffectPlayer playWithCompletion:^(BOOL finishedSuccessfully) {
                    if (block) block();
                }];
            }
            
            // Send back the audioPlayer so you can save it and do whatever you want with it later.
            return soundEffectPlayer;
        }
        else {
            DebugLog(@"Error: Could not find sound file '%@.%@'", fileName, fileType);
            return nil;
        }
    }
    
    return nil;
}

- (float)getSoundEffectVolumeMultiplier {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *volumeState = [userDefaults objectForKey:@"volumeButtonState"];
    
    if ([volumeState isEqualToString:@"mute"]) {
        return 0.0f;
    }
    else if ([volumeState isEqualToString:@"low"]) {
        return 0.5f;
    }
    else {
        return 1.0f;
    }
}

- (void)updateAllSoundEffectsVolume {
    DebugLog(@"playing all sound effects.");
    for (SGAudioPlayer *soundEffectPlayer in self.soundEffectPlayersArray) {
        [soundEffectPlayer setVolume:[self getSoundEffectVolumeMultiplier] * soundEffectPlayer.baseVolume];
    }
    DebugLog(@"Finished playing all sound effects.");
}

- (void)playAllSoundEffects {
    DebugLog(@"playing all sound effects.");
    for (SGAudioPlayer *soundEffectPlayer in self.soundEffectPlayersArray) {
        [soundEffectPlayer play];
    }
    DebugLog(@"Finished playing all sound effects.");
}

- (void)stopAllSoundEffects {
    DebugLog(@"stopping all sound effects.");
    // Editing an array while enumerating through it isn't allowed, so use a
    // temporary array to handle the enumerating.
    NSArray *enumerationArray = [NSArray arrayWithArray:self.soundEffectPlayersArray];
    for (SGAudioPlayer *soundEffectPlayer in enumerationArray)
    {
        [soundEffectPlayer stop];

    }
    DebugLog(@"Finished stopping all sound effects.");
}

- (void)pauseAllSoundEffects {
    DebugLog(@"pausing all sound effects.");
    for (SGAudioPlayer *soundEffectPlayer in self.soundEffectPlayersArray) {
        [soundEffectPlayer pause];
    }
    DebugLog(@"Finished pausing all sound effects.");
}



#pragma mark - Generic Controls

- (void)playAudioPlayer:(SGAudioPlayer *)audioPlayer {
    [self playAudioPlayer:audioPlayer completion:nil];
}

- (void)playAudioPlayer:(SGAudioPlayer *)audioPlayer completion:(void (^)(BOOL))block {
    [audioPlayer setVolume:audioPlayer.baseVolume * [self getSoundEffectVolumeMultiplier]];
    audioPlayer.delegate = self;
    
    [audioPlayer playWithCompletion:^(BOOL finishedSuccessfully) {
        if (block) block(finishedSuccessfully);
    }];
}

- (void)playAllAudio {
    DebugLog(@"playing all audio.");
    [self playTheMusic];
    [self playAllSoundEffects];
}

- (void)stopAllAudio { // <<< Is it just me, or is this being called a ridiculous number of times.
    DebugLog(@"stopping all audio.");
    [self stopTheMusic];
    [self stopAllSoundEffects];
}

- (void)pauseAllAudio {
    DebugLog(@"pausing all audio.");
    [self pauseTheMusic];
    [self pauseAllSoundEffects];
}

- (void)updateAudioVolume {
    DebugLog(@"Updating all volume.");
    [self updateMusicVolume];
    [self updateAllSoundEffectsVolume];
}




# pragma mark - Logistics

- (void)removeSoundEffectPlayer:(SGAudioPlayer *)player {
    if (player != self.musicPlayer) {
        [self.soundEffectPlayersArray removeObject:player];
    }
}




#pragma mark - SGAudioPlayerDelegate

- (void)audioPlayerDidStop:(SGAudioPlayer *)player {
    [self removeSoundEffectPlayer:player];
}

- (void)audioPlayerDidFinishPlaying:(SGAudioPlayer *)player successfully:(BOOL)flag
{
    // Remove any finished sound effects.
    [self removeSoundEffectPlayer:player];
    
    // Update the delegate.
    if ([self.delegate respondsToSelector:@selector(audioManager:didFinishPlayingSoundWithAudioPLayer:successfully:)])
    {
        [self.delegate audioManager:self didFinishPlayingSoundWithAudioPLayer:player successfully:flag];
    }
}




#pragma mark - Other

static BOOL isAudioSessionActive = NO;

- (void)activateAudio {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    if (audioSession.otherAudioPlaying) {
        [audioSession setCategory: AVAudioSessionCategoryAmbient error:&error];
    } else {
        [audioSession setCategory: AVAudioSessionCategorySoloAmbient error:&error];
    }
    
    if (!error) {
        [audioSession setActive:YES error:&error];
        isAudioSessionActive = YES;
    }
    
    NSLog(@"%s AVAudioSession Category: %@ Error: %@", __FUNCTION__, [audioSession category], error);

}

- (void)deactivateAudio {
    // Prevent background apps from duplicate entering if terminating an app.
    if (!isAudioSessionActive) return;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    [audioSession setActive:NO error:&error];
    
    NSLog(@"%s AVAudioSession Error: %@", __FUNCTION__, error);
    
    if (error) {
        // It's not enough to setActive:NO
        // We have to deactivate it effectively (without that error),
        // so try again (and again... until success).
        [self deactivateAudio];
    } else {
        isAudioSessionActive = NO;
    }
}



+ (SKAction*)MakeSoundEffectAction:(NSString*)soundName withFileType:(NSString *)fileType
{
    NSString* nameWithExtension = [NSString stringWithFormat:@"%@%@",soundName,fileType];
    
    SKAction *soundEffectAction = [SKAction playSoundFileNamed:nameWithExtension waitForCompletion:NO];
    
    return soundEffectAction;
}

- (SGAudioPlayer*)MakeAudioPlayerForSoundEffect:(NSString*)soundName withType:(NSString *)fileType
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:fileType];
    DebugLog(@"sound name %@",soundFilePath);
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    SGAudioPlayer *soundEffect = [[SGAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    soundEffect.delegate = self;
    [soundEffect prepareToPlay];
    [audioManager.audioPlayersArray addObject:soundEffect];
    return soundEffect;
}

@end
