//
//  CDNotificationCell.h
//  CookieDD
//
//  Created by Nate on 9/11/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDNotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftTypeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;

- (IBAction)removeButton:(id)sender;

@end
