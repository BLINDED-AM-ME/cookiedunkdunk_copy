//
//  LMICloudManager.m
//  CookieDD
//
//  Created by Luke McDonald on 2/26/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//


/*
 http://www.raywenderlich.com/6015/beginning-icloud-in-ios-5-tutorial-part-1
 
 http://www.raywenderlich.com/6031/beginning-icloud-in-ios-5-tutorial-part-2
 
 http://www.raywenderlich.com/12779/icloud-and-uidocument-beyond-the-basics-part-1
 
 http://maniacdev.com/2012/04/tutorial-how-to-use-core-data-with-icloud-step-by-step
 */


/*
 
 Credits:
 
 President/CEO - Duane Schor
 
 Art Director - Neisha Bergman
 Artists - Ecieño Carmona
 Eric Eining
 Mike Swarts
 Erik Aamland
 Duane Schor
 
 Lead Programmer - Luke McDonald
 Programmers - Josh McGee
 Gary Johnston
 Dustin Whirle
 Jeremy Pagley
 Rodney Jenkins
 
 Server Programmer - Josh Pagley
 
 Lead Sound Designer - Ramsees Mechan
 Sound Designers - Richard Würth
 D’Andre Amos
 
 Voice Actors - Adrian Knapp
 Duane Schor
 Luke McDonald
 Neisha Bergman
 
 Lead Web Designer - Brittany Steed
 Web Designers - Yannik Bloscheck
 Lisa Menerick
 Andrew Gianikas
 
 Graphic Designer - Freddy Garcia
 
 Tech Support - Jonathan Marr-Cox
 
 Story - Audra Hudson
 Duane Schor
 
 Marketing Director - Rodney Jenkins
 Marketer - CJ Anderson
 
 Business Development Manager - Adam Hunt
 
 Quality Assurance - Vinny Spaulding
 
 Level Editing - Abner Velez
 
 
 Special Thanks - Jon Kurtz
 Benjamin Stahlhood II
 Andrew Nunley
 Steven Edsall
 And to all our friends and family that have supported us along the way!
 
 */

#import "LMICloudManager.h"

static LMICloudManager *iCloudManager = nil;

@implementation LMICloudManager

#pragma mark - Initialization

+ (LMICloudManager *)iCloudManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iCloudManager = [LMICloudManager new];
    });
    
    return iCloudManager;
}

- (id)init
{
    if (self = [super init])
    {
        self.document = [LMICloudDocument new];
        self.document.delegate = self;
    }
    
    return self;
}

- (BOOL)iCloudIsAvailable
{
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    
    BOOL isAvailable = NO;
    
    if (ubiq) isAvailable = YES;

    return isAvailable;
}

#pragma mark - LMICloudDocument

- (void)loadDocument
{
    [self.document loadDocument];
}

#pragma mark - LMICloudDocumentDelegate

- (void)iCloudDocument:(LMICloudDocument *)document didLoadContents:(NSArray *)contents
{
    NSMetadataItem *item = contents[0];
    NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
    _document = [[LMICloudDocument alloc] initWithFileURL:url];
     _document.delegate = self;
    [_document openWithCompletionHandler:^(BOOL success) {
        if (success) {
            DebugLog(@"iCloud document opened");
        } else {
            DebugLog(@"failed opening document from iCloud");
        }
    }];
}

- (void)iCloudDocumentFailedToLoadContent:(LMICloudDocument *)document
{
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    
    NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:
                                 @"Documents"] URLByAppendingPathComponent:kFILENAME];
    
    _document = [[LMICloudDocument alloc] initWithFileURL:ubiquitousPackage];
     _document.delegate = self;
    [_document saveToURL:[_document fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^
     (BOOL success) {
         if (success)
         {
             [_document openWithCompletionHandler:^
              (BOOL success) {
                 DebugLog(@"new document opened from iCloud");
             }];
         }
     }];
    
}

@end
