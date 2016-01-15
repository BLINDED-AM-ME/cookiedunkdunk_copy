//
//  BLINDED_Math.h
//  CookieDD
//
//  Created by BLINDED AM ME on 5/16/14.
//

#import <Foundation/Foundation.h>

@interface BLINDED_Math : NSObject


+(BOOL)PHYSICS_CanHitPoint_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity;

+(float)PHYSICS_FindDelta_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity;

+(float)PHYSICS_Find_Needed_Angle1_radians_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity;

+(float)PHYSICS_Find_Needed_Angle2_radians_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity;

+(float)PHYSICS_Find_Needed_Angle1_degrees_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity;

+(float)PHYSICS_Find_Needed_Angle2_degrees_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity;

+(CGVector)AngleToVector_radians:(float)angle; // in radians

+(CGVector)AngleToVector_degrees:(float)angle; // in degrees

+(float) VectorToAngle_Degrees:(CGVector) dir;

+(float) VectorToAngle_Radians:(CGVector) dir;

+(float) Value_from_another_Scope:(float)value OldMin:(float)oldMin OldMax:(float)oldMax NewMin:(float)newMin NewMax:(float)newMax;

+(CGPoint) positionFromMagnetude:(float)magnatude Degrees:(float)degrees;

@end
