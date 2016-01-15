//
//  LMICloudDocument.h
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

#import <UIKit/UIKit.h>

#define kFILENAME @"mydocument.dox"

@protocol  LMICloudDocumentDelegate;

@interface LMICloudDocument : UIDocument

@property (strong, nonatomic) NSString *documentContent;
@property (strong, nonatomic) NSMetadataQuery *query;
@property (weak, nonatomic) id <LMICloudDocumentDelegate> delegate;

- (void)loadDocument;
@end

@protocol LMICloudDocumentDelegate <NSObject>

@optional
- (void)iCloudDocument:(LMICloudDocument *)document didLoadContents:(NSArray *)contents;
- (void)iCloudDocumentFailedToLoadContent:(LMICloudDocument *)document;
@end