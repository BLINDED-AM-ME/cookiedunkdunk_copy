//
//  SGTestiCloudViewController.m
//  CookieDD
//
//  Created by Luke McDonald on 2/27/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "SGTestiCloudViewController.h"

@interface SGTestiCloudViewController ()

@end

@implementation SGTestiCloudViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReload:) name:@"noteModified" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textView.text = [LMICloudManager iCloudManager].document.documentContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataReload:(NSNotification *)note
{
    [LMICloudManager iCloudManager].document = note.object;
    self.textView.text = [LMICloudManager iCloudManager].document.documentContent;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [LMICloudManager iCloudManager].document.documentContent = textView.text;
    [[LMICloudManager iCloudManager].document updateChangeCount:UIDocumentChangeDone];
}

@end
