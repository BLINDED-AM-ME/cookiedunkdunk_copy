//
//  SGFileManager.h
//  CookieDD
//
//  Created by Josh on 11/25/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SGFileManager : NSObject

+ (SGFileManager*)fileManager;

// Simply loads and returns a dictionary from a given file.
- (NSDictionary*)loadDictionaryWithFileName:(NSString*)fileName OfType:(NSString*)fileType;

// Simply loads and returns an array from a given file.
- (NSArray*)loadArrayWithFileName:(NSString*)fileName OfType:(NSString*)fileType;

// Returns an integer value for a given key.
//  - Useful when there's a dictionary of indexes for item names.
- (NSNumber *)findTypeIndexFromString:(NSString*)typeString InFileNamed:(NSString*)fileName;

- (NSString*)stringFromIndex:(int)index inFile:(NSString*)fileName;

// Get the suffex needed to load the correct images.
- (NSString *)getImageSuffixForDevice;

// Get the suffex needed to load images from the proper atlas.
- (NSString *)getAtlasSuffixForDevice;

- (BOOL)fileExistsInProject:(NSString *)fileName;

- (NSURL *)urlForFileNamed:(NSString *)fileName fileType:(NSString *)fileType;

-(void)listAllFonts;

@end
