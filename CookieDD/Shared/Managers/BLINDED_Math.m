//
//  BLINDED_Math.m
//  CookieDD
//
//  Created by BLINDED AM ME on 5/16/14.
//

#import "BLINDED_Math.h"

@implementation BLINDED_Math

+(BOOL)PHYSICS_CanHitPoint_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity {
    
    if([self PHYSICS_FindDelta_X:x Y:y Velocity:velocity Gravity:gravity] >= 0)
        return YES;
    else
        return NO;
}

+(float)PHYSICS_FindDelta_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity{
    
    float gravity_for_clearity = gravity * -1.0f;
    
    return velocity * velocity * velocity * velocity - gravity_for_clearity * (gravity_for_clearity * x * x + 2.0f * y * velocity * velocity);
}

+(float)PHYSICS_Find_Needed_Angle1_radians_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity
{
    float gravity_for_clearity = gravity * -1.0f;
    
    return atan((powf(velocity, 2.0f) + sqrtf( powf(velocity, 4.0f) - (gravity_for_clearity * ((gravity_for_clearity * powf(x, 2.0f)) + (2.0f * y * powf(velocity, 2.0f))))))/(gravity_for_clearity * x));
    
}

+(float)PHYSICS_Find_Needed_Angle1_degrees_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity
{
    float gravity_for_clearity = gravity * -1.0f;
    
    float returnValue = atan((powf(velocity, 2.0f) + sqrtf( powf(velocity, 4.0f) - (gravity_for_clearity * ((gravity_for_clearity * powf(x, 2.0f)) + (2.0f * y * powf(velocity, 2.0f))))))/(gravity_for_clearity * x));
    
    return returnValue * 57.2957795f;
    
}

+(float)PHYSICS_Find_Needed_Angle2_radians_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity
{
    float gravity_for_clearity = gravity * -1.0f;
    
    return atan((powf(velocity, 2.0f) - sqrtf( powf(velocity, 4.0f) - (gravity_for_clearity * ((gravity_for_clearity * powf(x, 2.0f)) + (2.0f * y * powf(velocity, 2.0f))))))/(gravity_for_clearity * x));
    
}

+(float)PHYSICS_Find_Needed_Angle2_degrees_X:(float)x Y:(float)y Velocity:(float)velocity Gravity:(float)gravity
{
    float gravity_for_clearity = gravity * -1.0f;
    
    float returnValue = atan((powf(velocity, 2.0f) - sqrtf( powf(velocity, 4.0f) - (gravity_for_clearity * ((gravity_for_clearity * powf(x, 2.0f)) + (2.0f * y * powf(velocity, 2.0f))))))/(gravity_for_clearity * x));
    
    return returnValue * 57.2957795f;
    
}

+(CGVector)AngleToVector_radians:(float)angle // in radians
{
    return CGVectorMake(cosf(angle), sinf(angle));
}

+(CGVector)AngleToVector_degrees:(float)angle // in degrees
{
    float converted_angle = angle * 0.01745329f;
    
    return CGVectorMake(cosf(converted_angle), sinf(converted_angle));
}

+(float) VectorToAngle_Degrees:(CGVector) dir
{
    float returnValue = atanf(dir.dy/dir.dx);
    
    return returnValue * 57.2957795f;
}

+(float) VectorToAngle_Radians:(CGVector) dir
{
    
    return atanf(dir.dy/dir.dx);
}

+(float) Value_from_another_Scope:(float)value OldMin:(float)oldMin OldMax:(float)oldMax NewMin:(float)newMin NewMax:(float)newMax
{
    float returnValue = 0;
    
    returnValue = ( (value - oldMin) / (oldMax - oldMin) ) * (newMax - newMin) + newMin;
    
    return returnValue;
}

+(CGPoint)positionFromMagnetude:(float)magnatude Degrees:(float)degrees {
    float x = magnatude * cos(DegreesToRadians(degrees));
    float y = magnatude * sin(DegreesToRadians(degrees));
    
    return CGPointMake(x, y);
}

@end

