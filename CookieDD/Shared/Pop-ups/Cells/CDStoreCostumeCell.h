//
//  CDStoreCostumeCell.h
//  CookieDD
//
//  Created by Gary Johnston on 6/27/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDStoreCostumeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *costumeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) NSString *cellCookieName;
@property (strong, nonatomic) NSString *cellTheme;
@property (strong, nonatomic) NSString *cellIsUnlocked;

@end
