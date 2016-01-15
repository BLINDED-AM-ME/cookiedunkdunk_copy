//
//  CDCookieCostumeSelectionView.h
//  CookieDD
//
//  Created by Gary Johnston on 6/5/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDCookieCostumeSelectionTableViewCell.h"
#import "CDAccountCollectionCell.h"

@protocol CDCookieCostumeSelectionViewDelegate;



@interface CDCookieCostumeSelectionView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<CDCookieCostumeSelectionViewDelegate> delegate;

@property (strong, nonatomic) CDAccountCollectionCell *accountCell;

@property (strong, nonatomic) NSMutableArray *costumeArray;
@property (weak, nonatomic) IBOutlet UITableView *costumeSelectionTableView;

- (void)setupWithArray:(NSArray *)cookieArray;

@end



@protocol CDCookieCostumeSelectionViewDelegate

@required
- (void)costumeSelectionViewDidSelectCostumeWithCell:(CDCookieCostumeSelectionTableViewCell *)cell;

@end