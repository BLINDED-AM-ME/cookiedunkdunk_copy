//
//  SelectedLevelInfoViewController.h
//  Map_Plist
//
//  Created by Josh on 10/1/13.
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
#import "SGLevelSelectPageControl.h"
#import "CDPlanetoidObject.h"
#import "CDCookieDunkDunKViewController.h"
#import "SGGameManager.h"

@protocol LevelInfoViewControllerDelegate;

@interface LevelInfoViewController : UIViewController

@property (weak, nonatomic) id <LevelInfoViewControllerDelegate> delegate;

// Outlet Variables
@property (weak, nonatomic) IBOutlet UIView *mainInfoView; // Holds all the details such as high score, level goal, friends, etc.
@property (weak, nonatomic) IBOutlet UIView *controlsView; // Holds the buttons to start or cancel the level.

@property (weak, nonatomic) IBOutlet UIButton *pageLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *pageRightButton;

@property (weak, nonatomic) IBOutlet SGStrokeLabel *planetNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *levelsCollectionView;
@property (weak, nonatomic) IBOutlet SGLevelSelectPageControl *levelsPageControl;

// Temporary minigame stuff
@property (weak, nonatomic) IBOutlet UILabel *playMinigameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playMinigameButton;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *minigameButtonLabel;

- (IBAction)playMinigame:(id)sender;

// Other Variables
@property (assign, nonatomic) BOOL willUpdateLevel;
@property (assign, nonatomic) float backgroundFadeAlpha; // This is the alpha of the background color when fully visible.
@property (strong, nonatomic) NSNumber *worldType;
@property (strong, nonatomic) NSArray *levelsArray;
@property (strong, nonatomic) NSString *levelsFileName;

// These are exactly what they say on the tin.
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


// These are exactly what they say on the tin.
- (IBAction)startLevel:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)pageLeft:(id)sender;
- (IBAction)pageRight:(id)sender;

// Controls the animation for when this view is presented.
- (void)animateIn;
- (void)loadPlanetoid:(CDPlanetoidObject *)planetoid;

// Utility
- (double)calculateIndexFromLevelNumber:(int)levelNumber;

// Dev Cheats
@property (weak, nonatomic) IBOutlet UIButton *unlockNextLevelButton;
- (IBAction)unlockNextLevel:(id)sender;

@end


@protocol LevelInfoViewControllerDelegate <NSObject>

@optional
- (void)levelInfoViewController:(LevelInfoViewController *)levelInfoVC DidSelectLevel:(NSNumber *)levelType OnPlanet:(NSNumber*)planetType;
- (void)levelInfoViewController:(LevelInfoViewController *)levelInfoVC DidSelectMinigameForPlanetWithID:(NSNumber *)planetID;
- (void)levelInfoViewControllerDidCancel:(LevelInfoViewController *)viewController;

@end