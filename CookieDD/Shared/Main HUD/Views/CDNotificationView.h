//
//  CDNotificationView.h
//  CookieDD
//
//  Created by Nate on 9/8/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDNotificationViewDelegate;

@interface CDNotificationView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<CDNotificationViewDelegate> delegate;

//@property (strong, nonatomic) NSMutableArray *notificationsArray;

@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *notificationsArray;

- (void)setupNotificationView;

- (IBAction)exitButtonHit:(id)sender;

@end

@protocol CDNotificationViewDelegate <NSObject>

@end