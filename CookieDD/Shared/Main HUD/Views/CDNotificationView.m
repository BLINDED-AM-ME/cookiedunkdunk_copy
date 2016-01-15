//
//  CDNotificationView.m
//  CookieDD
//
//  Created by Nate on 9/8/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "CDNotificationView.h"
#import "CDNotificationCell.h"

@interface CDNotificationView()

@property (nonatomic, assign) int numberOfNotifications;
@property (nonatomic, strong) UIImage *giftImage;
@property (nonatomic, strong) NSString *giftMessage;
@property (nonatomic, strong) NSString *giftType;

@end

@implementation CDNotificationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupNotificationView];
    
    if (SYSTEM_VERSION_GREATER_THAN(IOS_7_0))
    {
        DebugLog(@"Version Greater Than 7.0");
    }
    if (SYSTEM_VERSION_EQUAL_TO(IOS_8_0))
    {
        DebugLog(@"Version 8.0");
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_8_0))
    {
        DebugLog(@"Version greater than or equal to 8.0");
    }
    if (SYSTEM_VERSION_LESS_THAN(IOS_8_0))
    {
        DebugLog(@"Version less than 8.0");
    }
    NSString *deviceVersion = [[UIDevice currentDevice] systemVersion];
    DebugLog(@"%@", deviceVersion);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setupNotificationView
{
    // Register tableview with cell identifier
    //[self.notificationsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.notificationsTableView registerNib:[UINib nibWithNibName:@"CDNotificationCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.notificationsTableView.dataSource = self;
    self.notificationsTableView.delegate = self;
    //self.notificationsTableView.backgroundView = nil;
    //self.notificationsTableView.backgroundColor = [UIColor clearColor];
    
    self.notificationsArray = [[NSMutableArray alloc] init];
    //NSMutableArray *notificationIds = [[NSMutableArray alloc] init];
    
    self.titleLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:14.0];
    [self.titleLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    
    // Retrieve notifications from account dictionary
    NSDictionary *notificationDict = [[NSDictionary alloc] init];
    notificationDict = [SGAppDelegate appDelegate].accountDict[@"notifications"];
    //    DebugLog(@"NotificationDict: %@", notificationDict);
    
//    if (notificationDict)
//    {
//        self.notificationsArray = [notificationDict mutableCopy];
//        
////        for (NSDictionary *notification in self.notificationsArray)
////        {
////            [notificationIds addObject:notification];
////        }
//
//    }
    
    //self.numberOfNotifications = [notificationIds count];
    
//    [[WebserviceManager sharedManager] requestToShowNotificationsWithAccountId:[SGAppDelegate appDelegate].accountDict[@"_id"] completionHandler:^
//     (NSError *error, NSDictionary *notificationsInfoDict)
//     {
//         if (!error && notificationsInfoDict)
//         {
//             //NSMutableArray *notificationsArray = [[NSMutableArray alloc] init];
//             
//             if (notificationsInfoDict[@"notifications"])
//             {
//                 self.notificationsArray = [notificationsInfoDict[@"notifications"] mutableCopy];
//                 
//                 for (NSDictionary *notification in self.notificationsArray)
//                 {
//                     [notificationIds addObject:notification[@"_id"]];
//                     //self.giftMessage = notification[@"message"];
//                 }
//             }
//             
//             self.numberOfNotifications = [notificationIds count];
//             
//             //    for (NSString *notification in notificationDict)
//             //    {
//             //        [notificationIds addObject:notification];
//             //    }
//             DebugLog(@"NotificationIdArray: %@", notificationIds);
//             
//             DebugLog(@"Removing notification");
//             //    [[WebserviceManager sharedManager] requestToRemoveNotificationsWithAccountId:[SGAppDelegate appDelegate].accountDict[@"_id"]
//             //                                                                 notificationIds:notificationIds[0]
//             //                                                               completionHandler:^
//             //     (NSError *error, NSDictionary *notificationsInfoDict)
//             //     {
//             //         if (!error && notificationsInfoDict)
//             //         {
//             //             DebugLog(@"%@", notificationsInfoDict);
//             //             // Update account dictionary
//             //         }
//             //         else if (error)
//             //         {
//             //             DebugLog(@"%@", error.description);
//             //         }
//             //     }];
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 
//                 [self.notificationsTableView reloadData];
//             });
//         }
//     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notificationsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //CDNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
    
    // Configure the cell.
    CDNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *notificationDict = [[NSDictionary alloc] init];
    notificationDict = self.notificationsArray[indexPath.row];
    
    //cell.backgroundColor = [UIColor clearColor];
    //cell.alpha = 0.5f;
    
    cell.messageLabel.text = [NSString stringWithFormat:@"%@", notificationDict[@"message"]];
    cell.giftTypeLabel.text = [NSString stringWithFormat:@"%@ %@", notificationDict[@"value"], notificationDict[@"command"]];
    
    UIImage *image = [UIImage imageNamed:@"cdd-hud-btnx-default.png"];
    cell.friendImageView.image = image;
    cell.giftImageView.image = image;
    
//    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", notificationDict[@"message"]];
//    //cell.textLabel.text = [NSString stringWithFormat:@"Hello there! %d", indexPath.row];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", notificationDict[@"command"]];
//    UIImage *image = [UIImage imageNamed:@"cdd-hud-btnx-default.png"];
//    //cell.contentView.alpha = 0.5f;
//    cell.imageView.image = image;
    
    //cell.textLabel.text  = @"Hello";
    return cell;
}

- (IBAction)exitButtonHit:(id)sender
{
    [self removeFromSuperview];
}

- (void)dealloc
{
    self.notificationsTableView.delegate = nil;
    self.notificationsTableView.dataSource = nil;
}

@end
