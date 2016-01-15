//
//  SGFileManager.m
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

#import "SGFileManager.h"

static SGFileManager *fileManager = nil;

@implementation SGFileManager

#pragma mark - Init

+ (SGFileManager *)fileManager {
    fileManager = [SGFileManager new];
    
    return fileManager;
}


#pragma mark - Loading Files

// Simply loads and returns a dictionary from a given file.
- (NSDictionary *)loadDictionaryWithFileName:(NSString *)fileName OfType:(NSString *)fileType
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSDictionary *fileDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        return fileDict;
    }
    else
    {
        DebugLog(@"Error: Could not find a file named '%@'", fileName);
    }
    
    return nil;
}

// Simply loads and returns a dictionary from a given file.
- (NSArray *)loadArrayWithFileName:(NSString *)fileName OfType:(NSString *)fileType
{
    //DebugLog(@"Loading file named '%@.%@'", fileName, fileType);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSArray *fileArray = [[NSArray alloc] initWithContentsOfFile:filePath];
        
        return fileArray;
    }
    else
    {
        DebugLog(@"Error: Could not find a file named '%@.%@'", fileName, fileType);
    }
    
    return nil;
}



#pragma mark - Lookup Values in Files

// Returns an integer value for a given key.
//  - Useful when there's a dictionary of indexes for item names.
- (NSNumber *)findTypeIndexFromString:(NSString *)typeString
                   InFileNamed:(NSString *)fileName
{
    NSArray *referenceArray = [self loadArrayWithFileName:fileName OfType:@"plist"];
    
    return [NSNumber numberWithInt:(int) [referenceArray indexOfObject:typeString]];
}


- (NSString *)stringFromIndex:(int)index inFile:(NSString *)fileName {
    NSArray *referenceArray = [self loadArrayWithFileName:fileName OfType:@"plist"];
    
    return (NSString *) referenceArray[index];
}


#pragma mark - Device Specific

- (NSString *)getImageSuffixForDevice {
    NSString *suffixString = @"";
    
    // Done in order of appearance.
    
    if (IS_IPHONE_5) {
        suffixString = @"-568h";
    }
    // This may not be necessary, but I want to be thorough.  // Note: This actually breaks things.
    //    if ([self deviceIsRetna]) {
    //        //suffixString = [NSString stringWithFormat:@"%@%@", suffixString, @"@2x"];
    //    }
    
    if (IS_IPAD) {
        suffixString = [NSString stringWithFormat:@"%@%@", suffixString, @"~ipad"];
    }
    
    return suffixString;
}

- (NSString *)getAtlasSuffixForDevice {
    NSString *suffixString = @"";

    // Done in order of appearance.
    
    if (IS_IPAD) {
        suffixString = [NSString stringWithFormat:@"%@%@", suffixString, @"_ipad"];
    }
    else if (IS_IPHONE_5) {
        suffixString = [NSString stringWithFormat:@"%@%@", suffixString, @"_iphone5"];
    }
    
    // This may not be necessary, but I want to be thorough.
    if (IS_RETINA) {
        suffixString = [NSString stringWithFormat:@"%@%@", suffixString, @"_retina"];
    }
    
    return suffixString;
}


#pragma mark - Directories and Files

- (BOOL)fileExistsInProject:(NSString *)fileName {
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath =  [documentsPath stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }
    else {
        DebugLog(@"Error: Image named '%@' does not exist in the project.", fileName);
    }
    
    return NO;
}

- (NSURL *)urlForFileNamed:(NSString *)fileName fileType:(NSString *)fileType {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    NSURL *url;
    if (path) {
        url = [NSURL fileURLWithPath:path];
    }
    
    return url;
}


#pragma mark - Info

- (void)listAllFonts {
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    DebugLog(@"----------------------------------");
    DebugLog(@"Available Fonts:");
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        DebugLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            DebugLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
    DebugLog(@"----------------------------------");
}



@end
