//
//  SGVector3.m
//  MilkCupTesting
//
//  Created by Josh on 2/25/14.
//  Copyright (c) 2014 Josh. All rights reserved.
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

#import "SGVector3.h"

@implementation SGVector3

+(SGVector3 *)vector3WithX:(float)x Y:(float)y Z:(float)z {
    SGVector3 *vector3 = [[SGVector3 alloc] init];
    vector3.x = x;
    vector3.y = y;
    vector3.z = z;
    
    return vector3;
}

- (CGPoint)toCGPoint {
    CGPoint cgPoint = CGPointMake(self.x, self.y);
    return cgPoint;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{%f, %f, %f}", self.x, self.y, self.z];
}

@end
