//
//  MainMapViewController.h
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
#import "WorldViewController.h"
#import "CDLivesDisplayView.h"
#import "CDDifficultySelectScreenViewController.h"
#import "SGConditionalViewController.h"
#import "CDIsometricMapViewController.h"

@protocol MainMapViewControllerDelegate;

@interface MainMapViewController : UIViewController <UIScrollViewDelegate, WorldViewControllerDelegate, AVAudioPlayerDelegate, CDLivesDisplayViewDelegate, CDIsometricMapViewControllerDelegate>

@property (strong, nonatomic) CDLoadingScreenViewController *loadingScreen;

@property (weak, nonatomic) IBOutlet UIImageView *nebulaImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *nebulaScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *closeStarsScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *closeStarsImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *mapScrollView;
@property (weak, nonatomic) IBOutlet UIView *rootMapView;

//@property (weak, nonatomic) IBOutlet UIView *livesDisplayView;
//@property (weak, nonatomic) IBOutlet SGBorderLabel *livesCountLabel;
//@property (weak, nonatomic) IBOutlet SGBorderLabel *livesTimerLabel;
@property (weak, nonatomic) IBOutlet CDLivesDisplayView *livesDisplayView;
//@property (weak, nonatomic) IBOutlet UIView *viewForLivesDisplayViewAnimation;


@property (assign, nonatomic) int numberOfPlanetoids;
@property (assign, nonatomic) int levelsPerPlanetoid;
@property (assign, nonatomic) int accountButtonIsOpenForOrientation;

@property (assign, nonatomic) BOOL leaderboardIsOpen;
@property (assign, nonatomic) BOOL leaderBoardIsGlobal;
@property (assign, nonatomic) BOOL didTapSomething;
@property (assign, nonatomic) BOOL willShowVideo;
@property (assign, nonatomic) BOOL willNotPlayMusic;

@property (strong, nonatomic) NSString *videoName;

@property (assign, nonatomic) CDPlanetoidObject *lastSelectedPlanetoid;

@property (strong, nonatomic) NSArray *worldsArray;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *worldAudioPlayer;
@property (weak, nonatomic) id <MainMapViewControllerDelegate> delegate;

// Temp Testing.
@property (weak, nonatomic) IBOutlet UIImageView *achievementTestImageView;

@property (weak, nonatomic) IBOutlet UIButton *addLifeButton;
@property (weak, nonatomic) IBOutlet UIButton *subtractLifeButton;
@property (weak, nonatomic) IBOutlet UIButton *toggleDisplayButton;
@property (weak, nonatomic) IBOutlet UIButton *toggleTimerButton;
@property (weak, nonatomic) IBOutlet UIButton *shootStarsButton;
@property (weak, nonatomic) IBOutlet UIButton *sendGiftButton;
@property (weak, nonatomic) IBOutlet UIButton *notificationsButton;
@property (weak, nonatomic) IBOutlet UIButton *removeNotificationsButton;

- (void)setMapMinimumZoomScale:(float)minScale;
- (IBAction)toggleTimer:(id)sender;
- (IBAction)toggleDisplay:(id)sender;
- (IBAction)addLife:(id)sender;
- (IBAction)subtractLife:(id)sender;
- (IBAction)shootStars:(id)sender;
- (IBAction)sendGift:(id)sender;
- (IBAction)notifications:(id)sender;
- (IBAction)removeNotifications:(id)sender;

- (void)createMainGame;
@end

@protocol MainMapViewControllerDelegate <NSObject>

@optional
-(void)mainMapViewControllerDidPoptoMainMenu:(MainMapViewController *)controller;
-(void)mainMapDidAppearAndWillDeallocMainMenu;

@end
