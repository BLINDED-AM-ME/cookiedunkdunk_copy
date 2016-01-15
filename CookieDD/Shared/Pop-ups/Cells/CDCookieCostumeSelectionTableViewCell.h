//
//  CDCookieCostumeSelectionTableViewCell.h
//  CookieDD
//
//  Created by Gary Johnston on 6/5/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDCookieCostumeSelectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cookieCostumeImage;


@property (strong, nonatomic) NSString *cellTheme;
@property (strong, nonatomic) NSString *cellCookieName;

@property (assign, nonatomic) BOOL isUnlocked;

@end
