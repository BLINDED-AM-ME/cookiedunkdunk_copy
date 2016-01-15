//
//  LMICloudDocument.m
//  CookieDD
//
//  Created by Luke McDonald on 2/27/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

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

#import "LMICloudDocument.h"

@implementation LMICloudDocument

#pragma mark - Initialization

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup
{
    //_query = [NSMetadataQuery new];
}

- (id)init
{
    if (self)
    {
        // Initialize...
        [self setup];
    }
    
    return self;
}

//- (id)initWithFileURL:(NSURL *)url
//{
//    if (self)
//    {
//        // Initialize...
//        [self setup];
//    }
//    
//    return self;
//}

#pragma mark - Contents

// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName
                   error:(NSError **)outError
{
    if ([contents length] > 0)
    {
        _documentContent = [[NSString alloc]
                            initWithBytes:[contents bytes]
                            length:[contents length]
                            encoding:NSUTF8StringEncoding];
    }
    else
    {
        // When the note is first created, assign some default content
        _documentContent = @"Empty";
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"noteModified"
     object:self];
    
    return YES;
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    
    if ([_documentContent length] == 0)
    {
        _documentContent = @"Empty";
    }
    
    return [NSData dataWithBytes:[_documentContent UTF8String]
                          length:[_documentContent length]];
}

#pragma mark - Load Document

- (void)loadDocument
{
    NSMetadataQuery *query = [NSMetadataQuery new];
    _query = query;
    [query setSearchScopes:[NSArray arrayWithObject:
                            NSMetadataQueryUbiquitousDocumentsScope]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:
                         @"%K == %@", NSMetadataItemFSNameKey, kFILENAME];
    [query setPredicate:pred];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(queryDidFinishGathering:)
     name:NSMetadataQueryDidFinishGatheringNotification
     object:query];
    
    [query startQuery];
}

- (void)queryDidFinishGathering:(NSNotification *)notification
{
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query];
    
    _query = nil;
    
	[self loadData:query];
}

- (void)loadData:(NSMetadataQuery *)query
{
    if ([query resultCount] > 0)
    {
        NSArray *results = [query results];
        
        if ([self.delegate respondsToSelector:@selector(iCloudDocument:didLoadContents:)])
        {
            [self.delegate iCloudDocument:self didLoadContents:results];
        }
	}
    else
    {
        
        if ([self.delegate respondsToSelector:@selector(iCloudDocumentFailedToLoadContent:)])
        {
            [self.delegate iCloudDocumentFailedToLoadContent:self];
        }
    }
}

@end
