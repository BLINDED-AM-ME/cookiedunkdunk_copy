//
//  CDCookieCostumeSelectionView.m
//  CookieDD
//
//  Created by Gary Johnston on 6/5/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDCookieCostumeSelectionView.h"
#import "CDIAPManager.h"
#import "SGPlayerPreferencesManager.h"

@implementation CDCookieCostumeSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)setupWithArray:(NSArray *)cookieArray
{
    //DebugLog(@"setupWithArray");
    
    _costumeArray = [[NSMutableArray alloc] initWithArray:cookieArray];
    [_costumeSelectionTableView registerNib:[UINib nibWithNibName:@"CDCookieCostumeSelectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CDCookieCostumeSelectionTableViewCell"];
    
    NSDictionary *firstDict = _costumeArray[0];
    NSDictionary *defaultCookieDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"isSelected", [NSNumber numberWithBool:YES], @"isUnlocked", [firstDict objectForKey:@"name"], @"name", KeyThemeDefault, @"theme", nil];
    
    
    BOOL isInArray = NO;
    
    for (NSDictionary *dictionary in _costumeArray)
    {
        if ([[dictionary objectForKey:@"name"] isEqualToString:[defaultCookieDict objectForKey:@"name"]] &&
            [[dictionary objectForKey:@"theme"] isEqualToString:[defaultCookieDict objectForKey:@"theme"]])
        {
            isInArray = YES;
        }
    }
    
    if (!isInArray)
    {
        [_costumeArray insertObject:defaultCookieDict atIndex:0];
    }
}

- (void)cellWasHit:(CDCookieCostumeSelectionTableViewCell *)cell
{
//        if ([_delegate respondsToSelector:@selector(costumeSelectionViewDidSelectCostumeWithCell:)])
//        {
//    
//        }
    //DebugLog(@"cellWasHit");
    [self.delegate costumeSelectionViewDidSelectCostumeWithCell:cell];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_costumeArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DebugLog(@"tableView");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell = (CDCookieCostumeSelectionTableViewCell *)cell;
    
    CDCookieCostumeSelectionTableViewCell *cdCell = (CDCookieCostumeSelectionTableViewCell *)cell;
    DebugLog(@"cell name: %@", cdCell.cellCookieName);
    DebugLog(@"cell theme: %@", cdCell.cellTheme);
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click" FileType:@"caf"];
    
    if (cdCell.isUnlocked)
    {
        if ([cdCell.cellCookieName isEqualToString:KeyNameChip])
        {
            [SGPlayerPreferencesManager preferenceManager].brownSuperLooks = cdCell.cellTheme;
        }
        else if ([cdCell.cellCookieName isEqualToString:KeyNameDustinMartianMint])
        {
            [SGPlayerPreferencesManager preferenceManager].greenSuperLooks = cdCell.cellTheme;
        }
        else if ([cdCell.cellCookieName isEqualToString:KeyNameGerryJ])
        {
            [SGPlayerPreferencesManager preferenceManager].purpleSuperLooks = cdCell.cellTheme;
        }
        else if ([cdCell.cellCookieName isEqualToString:KeyNameJJJams])
        {
            [SGPlayerPreferencesManager preferenceManager].redSuperLooks = cdCell.cellTheme;
        }
        else if ([cdCell.cellCookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            [SGPlayerPreferencesManager preferenceManager].yellowSuperLooks = cdCell.cellTheme;
        }
        else if ([cdCell.cellCookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            [SGPlayerPreferencesManager preferenceManager].blueSuperLooks = cdCell.cellTheme;
        }
        else if ([cdCell.cellCookieName isEqualToString:KeyNameReginald])
        {
            [SGPlayerPreferencesManager preferenceManager].orangeSuperLooks = cdCell.cellTheme;
        }
    
        [self cellWasHit:cdCell];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DebugLog(@"cellForRowAtIndexPath");
    if ([_costumeSelectionTableView.subviews count] > 2)
    {
        UIImageView *scrollViewBarImgView = [_costumeSelectionTableView.subviews objectAtIndex:2];
        UIImage *imgBar = [UIImage imageNamed:@"cdd-hud-panel-scrollerbar"];
        
        [scrollViewBarImgView setImage:imgBar];
    }
    else
    {
        UIImageView *scrollViewBarImgView = [_costumeSelectionTableView.subviews objectAtIndex:1];
        UIImage *imgBar = [UIImage imageNamed:@"cdd-hud-panel-scrollerbar"];
     
        [scrollViewBarImgView setImage:imgBar];
    }
    
    CDCookieCostumeSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDCookieCostumeSelectionTableViewCell"];

    if ([_costumeArray count] > 0)
    {
        NSDictionary *cookieCostumeInfoDict = _costumeArray[indexPath.row];
        
        NSString *theme = nil;
        NSString *cookieName = nil;
        
        BOOL isUnlocked = NO;
//        BOOL isSelected = NO;
        
        
        if (cookieCostumeInfoDict[@"theme"])
        {
            theme = cookieCostumeInfoDict[@"theme"];
            cell.cellTheme = theme;
        }
        
        if (cookieCostumeInfoDict[@"name"])
        {
            cookieName = cookieCostumeInfoDict[@"name"];
            cell.cellCookieName = cookieName;
        }
        
        if (cookieCostumeInfoDict[@"isUnlocked"])
        {
            isUnlocked = [cookieCostumeInfoDict[@"isUnlocked"] boolValue];
        }
        
//        if (cookieCostumeInfoDict[@"isSelected"])
//        {
//            isSelected = [cookieCostumeInfoDict[@"isSelected"] boolValue];
//        }
        
        if (isUnlocked)
        {
            cell.isUnlocked = YES;
            [cell.cookieCostumeImage setImage:[self themedCookieImage:theme cookieName:cookieName]];
        }
        else
        {
            cell.isUnlocked = NO;
            [cell.cookieCostumeImage setImage:[UIImage imageNamed:@"cdd-store-icon-cookie-mystery"]];
        }
    }
    
    return cell;
}

- (UIImage *)themedCookieImage:(NSString *)theme cookieName:(NSString *)cookieName
{
    //DebugLog(@"themedCookieImage");
    UIImage *themedCookieImage = nil;
    if ([theme isEqualToString:KeyThemeDefault])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chip"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-dustin"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-gerry"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-jj"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-luke"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-mikey"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-reginald"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeChef])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefchip"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefdustin"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefgerry"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefjj"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefluke"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefmikey"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-chefreggie"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeSuperHero])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superchip"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superdustin"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-supergerry"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superjj"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superluke"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-supermikey"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-superreggie"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeFarmer])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerchip"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerdustin"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmergerry"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerjj"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerluke"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmermikey"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-farmerreggie"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeZombie])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombieschip"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesdustin"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesgerry"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesjj"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesluke"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesmikey"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-zombiesreggie"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeWestern])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeEgypt])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeMedieval])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeOriental])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemePirate])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    else if ([theme isEqualToString:KeyThemeSoldier])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@""];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
        }
    }
    
    return themedCookieImage;
}

@end
