//
//  MainMapMessagesViewController.m
//  CookieDD
//
//  Created by Luke McDonald on 4/24/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "MainMapMessagesViewController.h"

@interface MainMapMessagesViewController ()
@property (strong, nonatomic) NSMutableArray *notificationsArray;
@end

@implementation MainMapMessagesViewController

#pragma mark - Initialization

- (void)setup
{
    _notificationsArray = [NSMutableArray new];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // Init....
        [self setup];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.messageLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
    [self.messageLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:1.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)requestNotifications
{
    [[WebserviceManager sharedManager] requestToShowNotificationsWithAccountId:[SGAppDelegate appDelegate].accountDict[@"_id"] completionHandler:^
     (NSError *error, NSDictionary *notificationsInfoDict)
    {
        if (!error && notificationsInfoDict)
        {
            if (notificationsInfoDict[@"notifications"])
            {
                _notificationsArray = [notificationsInfoDict[@"notifications"] mutableCopy];
            }
        }
    }];
}

@end
