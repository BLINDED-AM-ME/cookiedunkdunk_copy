//
//  SGPlayerPreferencesManager.m
//  CookieDD
//
//  Created by BLINDED AM ME on 4/16/14.
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

#import "SGPlayerPreferencesManager.h"
#import "SGCookieDunkDunkScene.h"

static SGPlayerPreferencesManager *preferenceManager = nil;

@implementation SGPlayerPreferencesManager

+ (SGPlayerPreferencesManager*)preferenceManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        preferenceManager = [SGPlayerPreferencesManager new];
        
        preferenceManager.redSuperLooks = KeyThemeDefault;
        preferenceManager.orangeSuperLooks = KeyThemeDefault;
        preferenceManager.yellowSuperLooks = KeyThemeDefault;
        preferenceManager.greenSuperLooks = KeyThemeDefault;
        preferenceManager.blueSuperLooks = KeyThemeDefault;
        preferenceManager.purpleSuperLooks = KeyThemeDefault;
        preferenceManager.brownSuperLooks = KeyThemeDefault;
       
        
    });
    
    return preferenceManager;
}

@end
