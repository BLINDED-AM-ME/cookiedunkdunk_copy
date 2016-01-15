//
//  CDAwardPopupViewController.m
//  CookieDD
//
//  Created by gary johnston on 3/14/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
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

#import "CDAwardPopupViewController.h"
#import "SGAppDelegate.h"

@interface CDAwardPopupViewController () <UIGestureRecognizerDelegate>

@end

@implementation CDAwardPopupViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_awardFreeCostume)
    {
        NSDictionary *freeCostumeDictionary = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:FreeCookieCostumeDictionaryDefault]];
        DebugLog(@"%@", freeCostumeDictionary);
        
        _awardImage.image = [UIImage imageNamed:[freeCostumeDictionary objectForKey:@"imageName"]];
    
//        if ([[freeCostumeDictionary objectForKey:@"name"] isEqualToString:KeyNameJJJams] && [[freeCostumeDictionary objectForKey:@"theme"] isEqualToString:KeyThemeSuperHero])
//        {
//            _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %@!", [[SGAppDelegate appDelegate] retrieveProperCookieName:[freeCostumeDictionary objectForKey:@"name"] withTheme:[freeCostumeDictionary objectForKey:@"theme"]]];
//        }
//        else if ([[freeCostumeDictionary objectForKey:@"name"] isEqualToString:KeyNameDustinMartianMint] && [[freeCostumeDictionary objectForKey:@"theme"] isEqualToString:KeyThemeFarmer])
//        {
//            _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %@!", [[SGAppDelegate appDelegate] retrieveProperCookieName:[freeCostumeDictionary objectForKey:@"name"] withTheme:[freeCostumeDictionary objectForKey:@"theme"]]];
//        }
//        else if ([[freeCostumeDictionary objectForKey:@"name"] isEqualToString:KeyNameDustinMartianMint] && [[freeCostumeDictionary objectForKey:@"theme"] isEqualToString:KeyThemeFarmer])
//        {
//            _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %@!", [[SGAppDelegate appDelegate] retrieveProperCookieName:[freeCostumeDictionary objectForKey:@"name"] withTheme:[freeCostumeDictionary objectForKey:@"theme"]]];
//        }
//        else if ([[freeCostumeDictionary objectForKey:@"name"] isEqualToString:KeyNameGerryJ] && [[freeCostumeDictionary objectForKey:@"theme"] isEqualToString:KeyThemeZombie])
//        {
//            _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %@!", [[SGAppDelegate appDelegate] retrieveProperCookieName:[freeCostumeDictionary objectForKey:@"name"] withTheme:[freeCostumeDictionary objectForKey:@"theme"]]];
//        }
//        else
//        {
//            DebugLog(@"Error: Free Cookie not found!");
//        }
        
        _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %@!", [[SGAppDelegate appDelegate] retrieveProperCookieName:[freeCostumeDictionary objectForKey:@"name"] withTheme:[freeCostumeDictionary objectForKey:@"theme"]]];
        
        NSDictionary *emptyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"nothingForYou", @"name", nil];
        [[NSUserDefaults standardUserDefaults] setObject:emptyDictionary forKey:FreeCookieCostumeDictionaryDefault];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (_awardForMainGame)
    {
        _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
        _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", _coinsToAward];
        
        [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:_coinsToAward] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
            
        }];
    }
    else
    {
        NSUserDefaults *awardsAvailableDefault = [NSUserDefaults standardUserDefaults];
        NSUInteger awardsAvailable = [awardsAvailableDefault integerForKey:DailyPrizesAwardedDefault];
        
        if (_awardGem)
        {
            _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-gems"];
            _awardTextLabel.text = @"YOU HAVE WON: A GEM!";
            
            [[CDIAPManager iapMananger] requestToIncreaseGemsValue:[NSNumber numberWithInt:1] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                
            }];
        }
        else if (awardsAvailable > 0)
        {
            NSDate *timeOfLockout = [NSDate date];
            NSUserDefaults *timeOfAwardLockout = [NSUserDefaults standardUserDefaults];
            [timeOfAwardLockout setObject:timeOfLockout forKey:AwardLockoutTimeDefault];
            [awardsAvailableDefault setInteger:awardsAvailable-1 forKey:DailyPrizesAwardedDefault];
            
            int randomAward = (arc4random() % 100) + 1;
            int coinsWon;
            int livesWon = 3;
            
            
            if (_difficulty == gameDifficultyLevelEasy)
            {
                if ((randomAward >= 0) && (randomAward <= 15))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-super"];
                    _awardTextLabel.text = @"YOU HAVE WON: A POWER GLOVE!";
                    
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:[NSNumber numberWithInt:1] wrappedCookieValue:nil bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 16) && (randomAward <= 30))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-wrapped"];
                    _awardTextLabel.text = @"YOU HAVE WON: A WRAPPED COOKIE!";
                    
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:[NSNumber numberWithInt:1] bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 31) && (randomAward <= 45))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-smores"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SMORE!";
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:nil bombValue:nil smoreValue:[NSNumber numberWithInt:1] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 46) && (randomAward <= 60))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-lightning"];
                    _awardTextLabel.text = @"YOU HAVE WON: A LIGHTNING BOLT!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:nil thunderboltValue:[NSNumber numberWithInt:1] nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 61) && (randomAward <= 75))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-spatula"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SPATULA!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:[NSNumber numberWithInt:1] slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 76) && (randomAward <= 85))
                {
                    livesWon = 3;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtralives"];
                    _awardTextLabel.text = @"YOU HAVE WON: THREE LIVES!";
                    
                    [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:livesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 86) && (randomAward <= 90))
                {
                    coinsWon = 100;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if (randomAward >= 91)
                {
//                    movesWon = 5;
//                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                    _awardTextLabel.text = @"YOU HAVE WON: FIVE MOVES!";
//                    
//                    [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:movesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
//                        
//                    }];
                    coinsWon = 100;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else
                {
//                    _awardImage.image = [UIImage imageNamed:@"cdd-main-board-hud-icon-erron"];
//                    _awardTextLabel.text = @"AN ERROR HAS OCCURRED!";
                    
//                    movesWon = 5;
//                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                    _awardTextLabel.text = @"YOU HAVE WON: FIVE MOVES!";
//                    
//                    [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:movesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
//                        
//                    }];
                    coinsWon = 100;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
            }
            else if (_difficulty == gameDifficultyLevelMedium)
            {
                if ((randomAward >= 0) && (randomAward <= 15))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-super"];
                    _awardTextLabel.text = @"YOU HAVE WON: A POWER GLOVE!";
                    
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:[NSNumber numberWithInt:1] wrappedCookieValue:nil bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 16) && (randomAward <= 30))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-wrapped"];
                    _awardTextLabel.text = @"YOU HAVE WON: A WRAPPED COOKIE!";
                    
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:[NSNumber numberWithInt:1] bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 31) && (randomAward <= 45))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-smores"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SMORE!";
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:nil bombValue:nil smoreValue:[NSNumber numberWithInt:1] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 46) && (randomAward <= 60))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-lightning"];
                    _awardTextLabel.text = @"YOU HAVE WON: A LIGHTNING BOLT!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:nil thunderboltValue:[NSNumber numberWithInt:1] nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 61) && (randomAward <= 75))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-spatula"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SPATULA!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:[NSNumber numberWithInt:1] slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 76) && (randomAward <= 80))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-slots"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SLOT MACHINE!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:[NSNumber numberWithInt:1] thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 81) && (randomAward <= 85))
                {
                    livesWon = 3;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtralives"];
                    _awardTextLabel.text = @"YOU HAVE WON: THREE LIVES!";
                    
                    [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:livesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 86) && (randomAward <= 90))
                {
                    coinsWon = 100;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 91) && (randomAward <= 92))
                {
                    coinsWon = 300;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if (randomAward >= 93)
                {
//                    movesWon = 5;
//                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                    _awardTextLabel.text = @"YOU HAVE WON: FIVE MOVES!";
//                    
//                    [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:movesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
//                        
//                    }];
                    
                    coinsWon = 300;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else
                {
//                    _awardImage.image = [UIImage imageNamed:@"cdd-main-board-hud-icon-erron"];
//                    _awardTextLabel.text = @"AN ERROR HAS OCCURRED!";
//                    
//                    movesWon = 5;
//                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                    _awardTextLabel.text = @"YOU HAVE WON: FIVE MOVES!";
//                    
//                    [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:movesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
//                        
//                    }];
                    
                    coinsWon = 300;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
            }
            else if (_difficulty == gameDifficultyLevelHard)
            {
                if ((randomAward >= 0) && (randomAward <= 15))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-super"];
                    _awardTextLabel.text = @"YOU HAVE WON: A POWER GLOVE!";
                    
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:[NSNumber numberWithInt:1] wrappedCookieValue:nil bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 16) && (randomAward <= 30))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-wrapped"];
                    _awardTextLabel.text = @"YOU HAVE WON: A WRAPPED COOKIE!";
                    
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:[NSNumber numberWithInt:1] bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 31) && (randomAward <= 40))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-smores"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SMORE!";
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:nil bombValue:nil smoreValue:[NSNumber numberWithInt:1] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 41) && (randomAward <= 50))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-lightning"];
                    _awardTextLabel.text = @"YOU HAVE WON: A LIGHTNING BOLT!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:nil thunderboltValue:[NSNumber numberWithInt:1] nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 51) && (randomAward <= 60))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-spatula"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SPATULA!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:[NSNumber numberWithInt:1] slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 61) && (randomAward <= 65))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-slots"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SLOT MACHINE!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:[NSNumber numberWithInt:1] thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 66) && (randomAward <= 68))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-sprinkles"];
                    _awardTextLabel.text = @"YOU HAVE WON: A RAD SPRINKLE!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:[NSNumber numberWithInt:1] spatulaValue:nil slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 69) && (randomAward <= 73))
                {
                    livesWon = 3;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtralives"];
                    _awardTextLabel.text = @"YOU HAVE WON: THREE LIVES!";
                    
                    [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:livesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 74) && (randomAward <= 76))
                {
                    livesWon = 5;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtralives"];
                    _awardTextLabel.text = @"YOU HAVE WON: FIVE LIVES!";
                    
                    [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:livesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 77) && (randomAward <= 84))
                {
                    coinsWon = 100;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 85) && (randomAward <= 89))
                {
                    coinsWon = 300;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 90) && (randomAward <= 92))
                {
                    coinsWon = 500;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if (randomAward >= 93)
                {
//                    movesWon = 5;
//                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                    _awardTextLabel.text = @"YOU HAVE WON: FIVE MOVES!";
//                    
//                    [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:movesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
//                        
//                    }];
                    
                    coinsWon = 500;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else
                {
//                    _awardImage.image = [UIImage imageNamed:@"cdd-main-board-hud-icon-erron"];
//                    _awardTextLabel.text = @"AN ERROR HAS OCCURRED!";
//                    
//                    movesWon = 5;
//                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                    _awardTextLabel.text = @"YOU HAVE WON: FIVE MOVES!";
//                    
//                    [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:movesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
//                        
//                    }];
                    
                    coinsWon = 500;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
            }
            else if (_difficulty == gameDifficultyLevelCrazy)
            {
                if ((randomAward >= 0) && (randomAward <= 12))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-super"];
                    _awardTextLabel.text = @"YOU HAVE WON: A POWER GLOVE!";
                    
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:[NSNumber numberWithInt:1] wrappedCookieValue:nil bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 13) && (randomAward <= 24))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-wrapped"];
                    _awardTextLabel.text = @"YOU HAVE WON: A WRAPPED COOKIE!";
                    
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:[NSNumber numberWithInt:1] bombValue:nil smoreValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 25) && (randomAward <= 36))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-smores"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SMORE!";
                    [[CDIAPManager iapMananger] requestToUpdatePowerupsWithIncreasePowerGloveValue:nil wrappedCookieValue:nil bombValue:nil smoreValue:[NSNumber numberWithInt:1] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 37) && (randomAward <= 48))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-lightning"];
                    _awardTextLabel.text = @"YOU HAVE WON: A LIGHTNING BOLT!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:nil thunderboltValue:[NSNumber numberWithInt:1] nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 49) && (randomAward <= 58))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-spatula"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SPATULA!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:[NSNumber numberWithInt:1] slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 59) && (randomAward <= 61))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-slots"];
                    _awardTextLabel.text = @"YOU HAVE WON: A SLOT MACHINE!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:nil spatulaValue:nil slotMachineValue:[NSNumber numberWithInt:1] thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 62) && (randomAward <= 64))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-sprinkles"];
                    _awardTextLabel.text = @"YOU HAVE WON: A RAD SPRINKLE!";
                    [[CDIAPManager iapMananger] requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:[NSNumber numberWithInt:1] spatulaValue:nil slotMachineValue:nil thunderboltValue:nil nukeValue:nil costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 65) && (randomAward <= 67))
                {
                    livesWon = 3;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtralives"];
                    _awardTextLabel.text = @"YOU HAVE WON: THREE LIVES!";
                    
                    [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:livesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 68) && (randomAward <= 70))
                {
                    livesWon = 5;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtralives"];
                    _awardTextLabel.text = @"YOU HAVE WON: FIVE LIVES!";
                    
                    [[CDIAPManager iapMananger] requestToIncreaseLivesValue:[NSNumber numberWithInt:livesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 71) && (randomAward <= 82))
                {
                    coinsWon = 100;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 83) && (randomAward <= 85))
                {
                    coinsWon = 300;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if ((randomAward >= 86) && (randomAward <= 88))
                {
                    coinsWon = 500;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else if (randomAward >= 89)
                {
//                    movesWon = 5;
//                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                    _awardTextLabel.text = @"YOU HAVE WON: FIVE MOVES!";
//                    
//                    [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:movesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
//                        
//                    }];
                    
                    coinsWon = 500;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
                else
                {
//                    movesWon = 5;
//                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                    _awardTextLabel.text = @"YOU HAVE WON: FIVE MOVES!";
//                    
//                    [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:movesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
//                        
//                    }];
                    
                    coinsWon = 500;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                    
                    [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                        
                    }];
                }
            }
            else
            {
//                _awardImage.image = [UIImage imageNamed:@"cdd-main-board-hud-icon-erron"];
//                _awardTextLabel.text = @"AN ERROR HAS OCCURRED!";
                
//                movesWon = 5;
//                _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                _awardTextLabel.text = @"YOU HAVE WON: FIVE MOVES!";
//                
//                [[CDIAPManager iapMananger] requestToIncreaseMovesValue:[NSNumber numberWithInt:movesWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
//                    
//                }];
                
                coinsWon = 500;
                _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                
                [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                    
                }];
            }
        }
        else
        {
            DebugLog(@"You don't get anything!");
            
            _awardImage.image = [UIImage imageNamed:@"cdd-main-board-hud-menu-default"];
            
            NSUserDefaults *timeOfAwardLockout = [NSUserDefaults standardUserDefaults];
            
            NSDate *lockoutDate = [timeOfAwardLockout objectForKey:AwardLockoutTimeDefault];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:lockoutDate];
            double secondsInAnHour = 3600;
            float hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
            float hoursTillUnlock = 24 - hoursBetweenDates;
            
            if (hoursTillUnlock > 1)
            {
                _youWinLabel.text = [NSString stringWithFormat:@"COME BACK IN %i HOURS", (int)roundf(hoursTillUnlock)];
            }
            else
            {
                _youWinLabel.text = @"COME BACK IN A FEW MINUTES";
            }
            _youWinLabel.adjustsFontSizeToFitWidth = YES;
            _youWinLabel.numberOfLines = 1;
            _youWinLabel.minimumScaleFactor = .5;
            
            int randomAward = arc4random() % 100;
            int coinsWon;
            
            if ((randomAward >= 0) && (randomAward <= 55))
            {
                if (_difficulty == gameDifficultyLevelEasy)
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-super"];
                    _awardTextLabel.text = @"FOR A CHANCE TO WIN: A POWER GLOVE!";
                }
                else if (_difficulty == gameDifficultyLevelMedium)
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-wrapped"];
                    _awardTextLabel.text = @"FOR A CHANCE TO WIN: A WRAPPED COOKIE!";
                }
                else if ((_difficulty == gameDifficultyLevelHard) || (_difficulty == gameDifficultyLevelCrazy))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-sprinkles"];
                    _awardTextLabel.text = @"FOR A CHANCE TO WIN: A RAD SPRINKLE!";
                }
            }
            else if ((randomAward >= 56) && (randomAward <= 81))
            {
                if (_difficulty == gameDifficultyLevelEasy)
                {
                    coinsWon = 10;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"FOR A CHANCE TO WIN: %i COINS!", coinsWon];
                }
                else if (_difficulty == gameDifficultyLevelMedium)
                {
                    coinsWon = 30;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"FOR A CHANCE TO WIN: %i COINS!", coinsWon];
                }
                else if ((_difficulty == gameDifficultyLevelHard) || (_difficulty == gameDifficultyLevelCrazy))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-smores"];
                    _awardTextLabel.text = @"FOR A CHANCE TO WIN: A SMORE!";
                }
            }
            else if ((randomAward >= 82) && (randomAward <= 94))
            {
                if (_difficulty == gameDifficultyLevelEasy)
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-lightning"];
                    _awardTextLabel.text = @"FOR A CHANCE TO WIN: A LIGHTNING BOLT!";
                }
                else if (_difficulty == gameDifficultyLevelMedium)
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-spatula"];
                    _awardTextLabel.text = @"FOR A CHANCE TO WIN: A SPATULA!";
                }
                else if ((_difficulty == gameDifficultyLevelHard) || (_difficulty == gameDifficultyLevelCrazy))
                {
                    coinsWon = 50;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"FOR A CHANCE TO WIN: %i COINS!", coinsWon];
                }
            }
            else if ((randomAward >= 95) && (randomAward <= 100))
            {
                if (_difficulty == gameDifficultyLevelEasy)
                {
//                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtramoves"];
//                    _awardTextLabel.text = @"FOR A CHANCE TO WIN: FIVE MOVES!";
                    
                    coinsWon = 50;
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                    _awardTextLabel.text = [NSString stringWithFormat:@"FOR A CHANCE TO WIN: %i COINS!", coinsWon];
                }
                else if (_difficulty == gameDifficultyLevelMedium)
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-slots"];
                    _awardTextLabel.text = @"FOR A CHANCE TO WIN: A SLOT MACHINE!";
                }
                else if ((_difficulty == gameDifficultyLevelHard) || (_difficulty == gameDifficultyLevelCrazy))
                {
                    _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-xtralives"];
                    _awardTextLabel.text = @"FOR A CHANCE TO WIN: THREE LIVES!";
                }
            }
            else
            {
//                _awardImage.image = [UIImage imageNamed:@"cdd-main-board-hud-icon-erron"];
//                _awardTextLabel.text = @"AN ERROR HAS OCCURRED!";
                
                coinsWon = 10;
                _awardImage.image = [UIImage imageNamed:@"cdd-store-icon-coins"];
                _awardTextLabel.text = [NSString stringWithFormat:@"YOU HAVE WON: %i COINS!", coinsWon];
                
                [[CDIAPManager iapMananger] requestToIncreaseCoinsValue:[NSNumber numberWithInt:coinsWon] costValue:nil costType:CostType_None completionHandler:^(NSError *error, NSDictionary *updatedGameParametersDict) {
                    
                }];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:2/256 blue:52/256 alpha:.8];
    
    [_awardTextLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:12]];
    [_awardTextLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_youWinLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:35]];
    [_youWinLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 8 : 4];
    
    
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         _upperGlimmerImage.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:NULL];
    
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         _lowerGlimmerImage.transform = CGAffineTransformMakeRotation(M_PI_2);
                     }
                     completion:NULL];
}

- (IBAction)handleTapper:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapScreenToDismissAwardsPopupViewController:)])
    {
        [self.delegate didTapScreenToDismissAwardsPopupViewController:self];
    }
}

-(void)AnimateThisBitch
{
 
    [UIView animateWithDuration:0.4 delay:0.0
                        options:UIViewAnimationOptionLayoutSubviews//UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         
                     }
                     completion:^(BOOL fin) {
                         
                     }];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
