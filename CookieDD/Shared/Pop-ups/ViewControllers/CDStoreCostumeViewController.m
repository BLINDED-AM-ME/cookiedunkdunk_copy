//
//  CDStoreCostumeViewController.m
//  CookieDD
//
//  Created by Gary Johnston on 6/20/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDStoreCostumeViewController.h"
#import "CDAccountCollectionCell.h"
#import "CDStoreCostumeCell.h"
#import "SGPlayerPreferencesManager.h"

@interface CDStoreCostumeViewController ()

//@property (strong, nonatomic) NSMutableArray *selectedCookieCostumeArray;
@property (strong, nonatomic) NSMutableArray *cookieArray;
@property (strong, nonatomic) NSMutableArray *cookieCostumeArray;
@property (strong, nonatomic) NSMutableArray *costumeArray;
@property (strong, nonatomic) NSMutableArray *currentCostumeArray;

@property (strong, nonatomic) NSString *cookieName;
@property (strong, nonatomic) NSString *cookieTheme;

@property (strong, nonatomic) UICollectionViewCell *cellHit;

@end


@implementation CDStoreCostumeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentCostumeArray = [NSMutableArray new];
    _cookieCostumeArray = [NSMutableArray new];
    _cookieArray = [NSMutableArray new];
    
    [_costumeCollectionView registerNib:[UINib nibWithNibName:@"CDAccountCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CDAccountCollectionCell"];
    [_cookieCollectionView registerNib:[UINib nibWithNibName:@"CDStoreCostumeCell" bundle:nil] forCellWithReuseIdentifier:@"CDStoreCostumeCell"];
    
    NSUserDefaults *cookieCostumesArrayDefault = [NSUserDefaults standardUserDefaults];
    NSArray *tempArray = [NSMutableArray arrayWithArray:[cookieCostumesArrayDefault objectForKey:CookieCostumeArrayDefault]];
    
    for (NSDictionary *dictionary in tempArray)
    {
        NSMutableDictionary *mutableDict = [dictionary mutableCopy];
        
        if (![_cookieArray containsObject:mutableDict])
        {
            [_cookieArray addObject:mutableDict];
        }
    }
    
    NSDictionary *firstCookieDictionary = [_cookieArray objectAtIndex:0];
    _cookieName = [firstCookieDictionary objectForKey:@"cookieName"];
    _cookieTheme = [firstCookieDictionary objectForKey:@"imageTheme"];
    
    _costumeArray = [[NSMutableArray alloc] initWithArray:[SGAppDelegate appDelegate].accountDict[@"cookieCostumes"]];
    
    NSMutableArray *tempDefaultArray = [[NSMutableArray alloc] initWithArray:_costumeArray];
    for (NSDictionary *dict in _costumeArray)
    {
        NSDictionary *defaultCookieDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"isSelected", [NSNumber numberWithBool:YES], @"isUnlocked", [dict objectForKey:@"name"], @"name", KeyThemeDefault, @"theme", nil];
        
        BOOL isInArray = NO;
        
        for (NSDictionary *dictionary in tempDefaultArray)
        {
            if ([[dictionary objectForKey:@"name"] isEqualToString:[defaultCookieDict objectForKey:@"name"]] &&
                [[dictionary objectForKey:@"theme"] isEqualToString:[defaultCookieDict objectForKey:@"theme"]])
            {
                isInArray = YES;
            }
        }
        
        if (!isInArray)
        {
            [tempDefaultArray insertObject:defaultCookieDict atIndex:0];
        }
    }
    
    [_costumeArray setArray:tempDefaultArray];
    
    
    for (NSDictionary *dict in _costumeArray)
    {
        if ([[dict objectForKey:@"name"] isEqualToString:_cookieName])
        {
            [_currentCostumeArray addObject:dict];
        }
    }
    
    [_costumeCollectionView reloadData];
    [_cookieCollectionView reloadData];
    
    _cookieNameLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17];
    _cookieNameLabel.text = [[SGAppDelegate appDelegate] retrieveProperCookieName:_cookieName withTheme:KeyThemeDefault];
    _cookieNameLabel.adjustsFontSizeToFitWidth = YES;
    _cookieNameLabel.numberOfLines = 1;
    _cookieNameLabel.minimumScaleFactor = .5;
    
    
    NSString *theme = [firstCookieDictionary objectForKey:@"imageTheme"];
    _costumeNameLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17];
    _costumeNameLabel.text = [[SGAppDelegate appDelegate] retrieveProperCookieName:_cookieName withTheme:theme];
    _costumeNameLabel.adjustsFontSizeToFitWidth = YES;
    _costumeNameLabel.numberOfLines = 2;
    _costumeNameLabel.minimumScaleFactor = .5;
    
    _buyButtonLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:14];
    _cancelButtonLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:14];
    
    _animationImageView.animationImages = [self animationsForCostumeWithName:_cookieName WithTheme:theme];
    _animationImageView.animationDuration = 1.25;
    _animationImageView.animationRepeatCount = INFINITY;
    [_animationImageView startAnimating];
    
    _buyCostumeButton.enabled = NO;
    
    [_cookiePageDots setCurrentPage:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)updatePageDots
{
    for (int count = 0; count < [_cookiePageDots.subviews count]; count++)
    {
        UIView *dotView = [_cookiePageDots.subviews objectAtIndex:count];
        UIImageView *dot = nil;
        
        for (UIView *subview in dotView.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dotView.frame.size.width, dotView.frame.size.height)];
            [dotView addSubview:dot];
        }
        
        if (count == _cookiePageDots.currentPage)
        {
            dot.image = [UIImage imageNamed:@"cdd-hud-lvl-page-active"];
        }
        else
        {
            dot.image = [UIImage imageNamed:@"cdd-hud-lvl-page-base"];
        }
    }
}

#pragma mark - IBActions
- (IBAction)exitButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(storeCostumeViewControllerDidExit:)])
    {
        [self.delegate storeCostumeViewControllerDidExit:self];
    }
}

- (IBAction)buyCostumeButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buyButtonHitInStoreCostumeViewController:WithCookieName:WithCostumeTheme:)])
    {
        [self.delegate buyButtonHitInStoreCostumeViewController:self WithCookieName:_cookieName WithCostumeTheme:_cookieTheme];
    }
//    [_costumeCollectionView reloadData];
}

- (IBAction)cancelButtonHit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(storeCostumeViewControllerDidExit:)])
    {
        [self.delegate storeCostumeViewControllerDidExit:self];
    }
}


#pragma mark - Collection View
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _cookieCollectionView)
    {
        CDStoreCostumeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDStoreCostumeCell" forIndexPath:indexPath];
        
        NSDictionary *cookieDictionary = [_cookieArray objectAtIndex:indexPath.row];
        [cell.costumeImageView setImage:[UIImage imageWithData:[cookieDictionary objectForKey:@"currentSuperImage"]]];
        cell.cellCookieName = [cookieDictionary objectForKey:@"cookieName"];
        cell.cellTheme = [cookieDictionary objectForKey:@"imageTheme"];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", [[SGAppDelegate appDelegate] retrieveProperCookieName:cell.cellCookieName withTheme:KeyThemeDefault]];
        cell.nameLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:17];
        cell.nameLabel.adjustsFontSizeToFitWidth = YES;
        cell.nameLabel.numberOfLines = 1;
        cell.nameLabel.minimumScaleFactor = .5;
        
        return cell;
    }
    else if (collectionView == _costumeCollectionView)
    {
        CDAccountCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDAccountCollectionCell" forIndexPath:indexPath];
        [cell.lockedView setHidden:YES];
        
//        NSDictionary *cookieDictionary = [_currentCostumeArray objectAtIndex:indexPath.row];
        [self configureCell:cell collectionView:collectionView indexPath:indexPath withArray:_currentCostumeArray];
        
        return cell;
    }
        
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _cookieCollectionView)
    {
        return [_cookieArray count];
    }
    else if (collectionView == _costumeCollectionView)
    {
        return [_currentCostumeArray count];
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _costumeCollectionView)
    {
        return CGSizeMake(60, 60);
    }
    else if (collectionView == _cookieCollectionView)
    {
        return CGSizeMake(124, 109);
    }
    return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _costumeCollectionView)
    {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        CDAccountCollectionCell *cdCell = (CDAccountCollectionCell *)cell;
        _cookieName = cdCell.cellCookieName;
        _cookieTheme = cdCell.cellTheme;
        _cellHit = cdCell;
        
        if (cdCell.cellIsUnlocked)
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
        }
        
        for (NSMutableDictionary *dictionary in _cookieArray)
        {
            if ([[dictionary objectForKey:@"cookieName"] isEqualToString:cdCell.cellCookieName])
            {
                if (cdCell.icon.image != [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"])
                {
                    [_animationImageView stopAnimating];
                    
                    [_costumeNameLabel setText:[[SGAppDelegate appDelegate] retrieveProperCookieName:cdCell.cellCookieName withTheme:cdCell.cellTheme]];
                    [_cookieNameLabel setText:[[SGAppDelegate appDelegate] retrieveProperCookieName:cdCell.cellCookieName withTheme:KeyThemeDefault]];
                    
                    _animationImageView.animationImages = [self animationsForCostumeWithName:cdCell.cellCookieName WithTheme:cdCell.cellTheme];
                    _animationImageView.animationDuration = 1.25;
                    _animationImageView.animationRepeatCount = INFINITY;
                    [_animationImageView startAnimating];
                    
                    if (cdCell.cellIsUnlocked)
                    {
                        _cookieName = cdCell.cellCookieName;
                        _cookieTheme = cdCell.cellTheme;
                        
                        [dictionary setObject:UIImagePNGRepresentation([self sendMeAnImageForCell:cdCell]) forKey:@"currentSuperImage"];
                        [dictionary setObject:cdCell.cellTheme forKey:@"imageTheme"];
                        [[NSUserDefaults standardUserDefaults] setObject:(NSMutableArray *)_cookieArray forKey:CookieCostumeArrayDefault];
                        [_cookieCollectionView  reloadData];
                        
                        _buyCostumeButton.enabled = NO;
                    }
                    else
                    {
                        if (([cdCell.cellTheme isEqualToString:KeyThemeSuperHero] && [cdCell.cellCookieName isEqualToString:KeyNameJJJams]) ||
                            ([cdCell.cellTheme isEqualToString:KeyThemeFarmer] && [cdCell.cellCookieName isEqualToString:KeyNameDustinMartianMint]) ||
                            ([cdCell.cellTheme isEqualToString:KeyThemeZombie] && [cdCell.cellCookieName isEqualToString:KeyNameGerryJ]))
                        {
                            _buyCostumeButton.enabled = NO;
                        }
                        else
                        {
                            _buyCostumeButton.enabled = YES;
                        }
                    }
                }
            }
        }
        
        if (cdCell.cellIsUnlocked)
        {
            [[NSUserDefaults standardUserDefaults] setObject:(NSMutableArray *)_cookieArray forKey:CookieCostumeArrayDefault];
            [_cookieCollectionView reloadData];
        }
        
    }
    else if (collectionView == _cookieCollectionView)
    {
        _buyCostumeButton.enabled = NO;
        [_animationImageView stopAnimating];
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        CDAccountCollectionCell *cdCell = (CDAccountCollectionCell *)cell;
        _cookieName = cdCell.cellCookieName;
        _cookieTheme = cdCell.cellTheme;
        
        [_currentCostumeArray removeAllObjects];
        for (NSDictionary *dict in _costumeArray)
        {
            if ([[dict objectForKey:@"name"] isEqualToString:_cookieName])
            {
                [_currentCostumeArray addObject:dict];
            }
        }
        
        [_costumeNameLabel setText:[[SGAppDelegate appDelegate] retrieveProperCookieName:_cookieName withTheme:cdCell.cellTheme]];
        [_cookieNameLabel setText:[[SGAppDelegate appDelegate] retrieveProperCookieName:_cookieName withTheme:KeyThemeDefault]];
        
        [_costumeCollectionView reloadData];
        [_costumeCollectionView scrollToItemAtIndexPath:0 atScrollPosition:0 animated:YES];
        
        _animationImageView.animationImages = [self animationsForCostumeWithName:_cookieName WithTheme:cdCell.cellTheme];
        _animationImageView.animationDuration = 1.25;
        _animationImageView.animationRepeatCount = INFINITY;
        [_animationImageView startAnimating];
    }
}

- (UIImage *)sendMeAnImageForCell:(CDAccountCollectionCell *)cdCell
{
    UIImage *imageToSet = [UIImage new];
    if ([cdCell.cellCookieName isEqualToString:KeyNameChip])
    {
        if ([cdCell.cellTheme isEqualToString:KeyThemeDefault])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-chip"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeChef])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-chefchip"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeSuperHero])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-superchip"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeFarmer])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-farmerchip"];
        }
    }
    else if ([cdCell.cellCookieName isEqualToString:KeyNameDustinMartianMint])
    {
        if ([cdCell.cellTheme isEqualToString:KeyThemeDefault])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-dustin"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeChef])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-chefdustin"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeSuperHero])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-superdustin"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeFarmer])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-farmerdustin"];
        }
    }
    else if ([cdCell.cellCookieName isEqualToString:KeyNameGerryJ])
    {
        if ([cdCell.cellTheme isEqualToString:KeyThemeDefault])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-gerry"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeChef])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-chefgerry"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeSuperHero])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-supergerry"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeFarmer])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-farmergerry"];
        }
    }
    else if ([cdCell.cellCookieName isEqualToString:KeyNameJJJams])
    {
        if ([cdCell.cellTheme isEqualToString:KeyThemeDefault])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-jj"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeChef])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-chefjj"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeSuperHero])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-superjj"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeFarmer])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-farmerjj"];
        }
    }
    else if ([cdCell.cellCookieName isEqualToString:KeyNameLukeLocoLemon])
    {
        if ([cdCell.cellTheme isEqualToString:KeyThemeDefault])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-luke"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeChef])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-chefluke"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeSuperHero])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-superluke"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeFarmer])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-farmerluke"];
        }
    }
    else if ([cdCell.cellCookieName isEqualToString:KeyNameMikeyMcSprinkles])
    {
        if ([cdCell.cellTheme isEqualToString:KeyThemeDefault])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-mikey"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeChef])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-chefmikey"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeSuperHero])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-supermikey"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeFarmer])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-farmermikey"];
        }
    }
    else if ([cdCell.cellCookieName isEqualToString:KeyNameReginald])
    {
        if ([cdCell.cellTheme isEqualToString:KeyThemeDefault])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-reginald"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeChef])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-chefreggie"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeSuperHero])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-superreggie"];
        }
        else if ([cdCell.cellTheme isEqualToString:KeyThemeFarmer])
        {
            imageToSet = [UIImage imageNamed:@"cdd-store-icon-farmerreggie"];
        }
    }
    
    return imageToSet;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float pageWidth = _cookieCollectionView.frame.size.width; // [_cookieCollectionView.subviews count];
    int page = _cookieCollectionView.contentOffset.x / pageWidth;
    
    if (scrollView == _cookieCollectionView)
    {
//        for (UICollectionViewCell *cell in [self.cookieCollectionView visibleCells])
//        {
//            NSIndexPath *indexPath = [self.cookieCollectionView indexPathForCell:cell];
//            DebugLog(@"%@",indexPath);
            
            [_cookiePageDots setCurrentPage:page];
//        }
        [self updatePageDots];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)resetCostumeCollectionViewWithCell:(CDAccountCollectionCell *)cell
{
    
}

- (void)configureCell:(UICollectionViewCell *)cell collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath withArray:(NSMutableArray *)array
{
    NSDictionary *cookieCostumeInfoDict = array[indexPath.row];

    NSString *theme = nil;
    NSString *cookieName = nil;
    
    if (cookieCostumeInfoDict[@"theme"])
    {
        theme = cookieCostumeInfoDict[@"theme"];
    }
    
    if (cookieCostumeInfoDict[@"name"])
    {
        cookieName = cookieCostumeInfoDict[@"name"];
    }

    if (collectionView == _costumeCollectionView)
    {
        CDAccountCollectionCell *costumeCell = (CDAccountCollectionCell *)cell;
        [costumeCell.lockedView setHidden:YES];
        costumeCell.cellCookieName = cookieName;
        costumeCell.cellTheme = theme;
        costumeCell.cellIsUnlocked = [cookieCostumeInfoDict[@"isUnlocked"] boolValue];
        
//        if (costumeCell.cellIsUnlocked)
//        {
//            [costumeCell.icon setImage:[self themedCookieImage:theme cookieName:cookieName]];
//        }
//        else
//        {
//            [costumeCell.icon setImage:[UIImage imageNamed:@"cdd-store-icon-cookie-mystery"]];
//        }
        
        [costumeCell.icon setImage:[self themedCookieImage:theme cookieName:cookieName]];
       
        for (UIView *view in costumeCell.icon.subviews)
        {
            if (view.tag == 10)
            {
                [view removeFromSuperview];
            }
        }
        
        if ((!costumeCell.cellIsUnlocked) &&
            [theme isEqualToString:KeyThemeWestern] &&
            [theme isEqualToString:KeyThemeOriental] &&
            [theme isEqualToString:KeyThemePirate] &&
            [theme isEqualToString:KeyThemeEgypt] &&
            [theme isEqualToString:KeyThemeMedieval] &&
            [theme isEqualToString:KeyThemeSoldier])
        {
            costumeCell.lockedView.hidden = NO;
        }
        else if ((!costumeCell.cellIsUnlocked))
        {
            costumeCell.lockedView.hidden = NO;
            [self createTintLayer:costumeCell.icon];
        }
        
        cell = costumeCell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    if (collectionView == _cookieCollectionView)
//    {
//        return UIEdgeInsetsMake(0, 20, -15, 0);
//    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
//  return UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>);
}

- (UIImage *)themedCookieImage:(NSString *)theme cookieName:(NSString *)cookieName
{
    UIImage *themedCookieImage = nil;
    
    if ([theme isEqualToString:KeyThemeDefault])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"store-chip-naked"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"store-dustin-naked"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"store-gerry-naked"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"store-jj-naked"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"store-luke-naked"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"store-mikey-naked"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"store-reggie-naked"];
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
            themedCookieImage = [UIImage imageNamed:@"store-chip-chef"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"store-dustin-chef"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"store-gerry-chef"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"store-jj-chef"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"store-luke-chef"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"store-mikey-chef"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"store-reggie-chef"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];//@""];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];//@""];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];//@""];
        }
    }
    else if ([theme isEqualToString:KeyThemeSuperHero])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"store-chip-super"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"store-dustin-super"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"store-gerry-super"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"store-jj-super"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"store-luke-super"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"store-mikey-super"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"store-reggie-super"];
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
            themedCookieImage = [UIImage imageNamed:@"store-chip-farmer"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"store-dustin-farmer"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"store-gerry-farmer"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"store-jj-farmer"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"store-luke-farmer"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"store-mikey-farmer"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"store-reggie-farmer"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];//@""];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];//@""];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];//@""];
        }
    }
    else if ([theme isEqualToString:KeyThemeZombie])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            themedCookieImage = [UIImage imageNamed:@"store-chip-zombie"];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            themedCookieImage = [UIImage imageNamed:@"store-dustin-zombie"];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            themedCookieImage = [UIImage imageNamed:@"store-gerry-zombie"];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            themedCookieImage = [UIImage imageNamed:@"store-jj-zombie"];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            themedCookieImage = [UIImage imageNamed:@"store-luke-zombie"];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            themedCookieImage = [UIImage imageNamed:@"store-mikey-zombie"];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            themedCookieImage = [UIImage imageNamed:@"store-reggie-zombie"];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];//@""];
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];//@""];
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];//@""];
        }
    }
    
    if (!themedCookieImage)
    {
        themedCookieImage = [UIImage imageNamed:@"cdd-store-icon-cookie-mystery"];
    }
    
    return themedCookieImage;
}

- (NSArray *)animationsForCostumeWithName:(NSString *)cookieName WithTheme:(NSString *)theme
{
    NSArray *pickMeAnimationArray = [NSArray new];
    
    if ([theme isEqualToString:KeyThemeDefault])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"naked-hero-chip-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme4"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme5"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme6"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme7"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme8"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme9"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme1"],
                                    
                                    [UIImage imageNamed:@"naked-hero-chip-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-chip-pickme1"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"naked-hero-dustin-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme4"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme5"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme6"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme7"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme8"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme1"],
                                    
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-dustin-pickme1"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"naked-hero-gerry-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme4"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme5"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme6"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme7"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme8"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme9"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme4"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme1"],
                                    
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-gerry-pickme1"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"naked-hero-luke-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme4"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme5"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme6"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme7"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme8"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme9"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme1"],
                                    
                                    [UIImage imageNamed:@"naked-hero-luke-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-luke-pickme1"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"naked-hero-jj-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme4"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme5"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme6"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme7"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme8"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme9"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme1"],
                                    
                                    [UIImage imageNamed:@"naked-hero-jj-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-jj-pickme1"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"naked-hero-mikey-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme4"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme5"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme6"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme7"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme8"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme9"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme10"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme1"],
                                    
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-mikey-pickme1"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"naked-hero-reginald-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme3"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme4"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme5"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme6"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme7"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme8"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme9"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme10"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme11"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme2"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme1"],
                                    
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme1"],
                                    [UIImage imageNamed:@"naked-hero-reginald-pickme1"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            
        }
    }
    else if ([theme isEqualToString:KeyThemeChef])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-chip-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-dustin-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-gerry-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-jj-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-luke-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-mikey-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-milkyway-hero-reginald-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            
        }
    }
    else if ([theme isEqualToString:KeyThemeSuperHero])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme12-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme13-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-chip-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-dustin-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-gerry-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-jj-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-luke-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-dunkop-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-mikey-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-dunkop-hero-reggie-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            
        }
    }
    else if ([theme isEqualToString:KeyThemeFarmer])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-farmer-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme12-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-chip-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-farmer-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme12-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-dustin-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-farmer-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme12-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-gerry-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-farmer-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme12-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-jj-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-farmer-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme12-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-luke-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-farmer-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme12-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-mikey-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-farmer-reggie-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme12-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-farmer-reggie-pickme1-store"],
                                    nil];
        }
    }
    else if ([theme isEqualToString:KeyThemeZombie])
    {
        if ([cookieName isEqualToString:KeyNameChip])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-survivor-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-survivor-chip-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameDustinMartianMint])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-survivor-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-survivor-dustin-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameGerryJ])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-zombie-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-gerry-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameJJJams])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-survivor-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-survivor-jj-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameLukeLocoLemon])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-zombie-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme12-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-luke-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameMikeyMcSprinkles])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-zombie-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-mikey-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameReginald])
        {
            pickMeAnimationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"cdd-zombie-reginald-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme4-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme5-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme6-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme7-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme8-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme9-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme10-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme11-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme3-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme2-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme1-store"],
                                    
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme1-store"],
                                    [UIImage imageNamed:@"cdd-zombie-reginald-pickme1-store"],
                                    nil];
        }
        else if ([cookieName isEqualToString:KeyNameMoorie])
        {
            
        }
        else if ([cookieName isEqualToString:KeyNameCheri])
        {
            
        }
        else if ([cookieName isEqualToString:KeyNameStar])
        {
            
        }
    }
    
    return pickMeAnimationArray;
}

- (void)createTintLayer:(UIImageView *)imageViewToTint
{
    // Initialize the overlay view we'll use to tint the planet image.
    UIView *tintOverlayView = [[UIView alloc] initWithFrame:imageViewToTint.frame];

    // Create a mask for the tint, so transparent pixels are ignored.
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:imageViewToTint.image];
    [maskImageView setFrame:tintOverlayView.bounds];
    [[tintOverlayView layer] setMask:[maskImageView layer]];
        
    // Make the overlay clear (no tint) initially.
    tintOverlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    tintOverlayView.tag = 10;
    
    // Add the overlay to the pile.
    [imageViewToTint addSubview:tintOverlayView];
}

- (void)boughtACostume
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DebugLog(@"Memory Warning: CDStoreCostumeViewController");
}

@end
