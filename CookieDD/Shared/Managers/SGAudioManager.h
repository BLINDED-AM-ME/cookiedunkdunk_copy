//
//  SGAudioManager.h
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

#import <Foundation/Foundation.h>
#import "SGAudioPlayer.h"


@protocol SGAudioManagerDelegate;

@interface SGAudioManager : NSObject
<
SGAudioPlayerDelegate
>

@property (weak, nonatomic) id <SGAudioManagerDelegate> delegate;



+(SGAudioManager *)audioManager;


+(SKAction*)MakeSoundEffectAction:(NSString*)soundName withFileType:(NSString *)fileType __attribute__((deprecated));
-(SGAudioPlayer*)MakeAudioPlayerForSoundEffect:(NSString*)soundName withType:(NSString*)fileType __attribute__((deprecated));


#pragma mark - Music
-(void)playBackgroundMusicWithFilename:(NSString*)fileName FileType:(NSString*)fileType;
-(void)playBackgroundMusicWithFilename:(NSString*)fileName FileType:(NSString*)fileType volume:(float)volume;
-(void)playBackgroundMusicWithFilename:(NSString*)fileName FileType:(NSString*)fileType volume:(float)volume numberOfLoopes:(int)loopCount;
-(void)playBackgroundMusicWithFilename:(NSString*)fileName FileType:(NSString*)fileType volume:(float)volume numberOfLoopes:(int)loopCount completion:(void(^)(void))block;

-(void)playTheMusic;
-(void)stopTheMusic;
-(void)pauseTheMusic;
-(void)updateMusicVolume;


#pragma mark - Sound Effects
-(SGAudioPlayer *)playSoundEffectWithFilename:(NSString*)fileName FileType:(NSString*)fileType;
-(SGAudioPlayer *)playSoundEffectWithFilename:(NSString*)fileName FileType:(NSString*)fileType volume:(float)volume;
-(SGAudioPlayer *)playSoundEffectWithFilename:(NSString*)fileName FileType:(NSString*)fileType volume:(float)volume completion:(void(^)(void))block;
-(SGAudioPlayer *)playSoundEffectWithFilename:(NSString*)fileName FileType:(NSString*)fileType volume:(float)volume numberOfLoopes:(int)loopCount;
-(SGAudioPlayer *)playSoundEffectWithFilename:(NSString*)fileName FileType:(NSString*)fileType volume:(float)volume numberOfLoopes:(int)loopCount completion:(void(^)(void))block;
-(SGAudioPlayer *)playSoundEffectWithFilename:(NSString*)fileName FileType:(NSString*)fileType volume:(float)volume numberOfLoopes:(int)loopCount delay:(float)delay completion:(void(^)(void))block;

-(void)playAllSoundEffects;
-(void)stopAllSoundEffects;
-(void)pauseAllSoundEffects;
-(void)updateAllSoundEffectsVolume;


-(void)playAudioPlayer:(SGAudioPlayer*)audioPlayer;
-(void)playAudioPlayer:(SGAudioPlayer*)audioPlayer completion:(void(^)(BOOL))block;


#pragma mark - Generic Controls
-(void)playAllAudio;
-(void)stopAllAudio;
-(void)pauseAllAudio;
-(void)updateAudioVolume;

#pragma mark - Other things

-(void)activateAudio;
-(void)deactivateAudio;

@end


@protocol SGAudioManagerDelegate <NSObject>

@optional
-(void)audioManager:(SGAudioManager*)audioManager didFinishPlayingSoundWithAudioPLayer:(SGAudioPlayer*)player successfully:(BOOL)flag;

@end
