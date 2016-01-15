//
//  GinderDeadMen_DeathNode.m
//  CookieDD
//
//  Created by BLINDED AM ME on 2/7/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import "GinderDeadMen_DeathNode.h"

@interface GinderDeadMen_DeathNode()

@property (assign, nonatomic) float bodySpeedX;
@property (assign, nonatomic) float bodySpeedY;
@property (assign, nonatomic) float leftArmSpeedX;
@property (assign, nonatomic) float leftArmSpeedY;
@property (assign, nonatomic) float rightArmSpeedX;
@property (assign, nonatomic) float rightArmSpeedY;
@property (assign, nonatomic) float leftLegSpeedX;
@property (assign, nonatomic) float leftLegSpeedY;
@property (assign, nonatomic) float rightLegSpeedX;
@property (assign, nonatomic) float rightLegSpeedY;

@property (strong, nonatomic) SKAction* movement;

@end

@implementation GinderDeadMen_DeathNode

-(void)SetupDeathNode{
    
    self.bloodCloud = [self.children objectAtIndex:0];
    self.body = [self.children objectAtIndex:1];
    self.rightArm = [self.children objectAtIndex:2];
    self.rightLeg = [self.children objectAtIndex:3];
    self.leftArm = [self.children objectAtIndex:4];
    self.leftLeg = [self.children objectAtIndex:5];
    
}
-(void)SetMovementAction
{
    
    float speed = 0.05f;
    
    self.movement = [SKAction sequence:@[
                                         [SKAction runBlock:^{
        
        // the torso
        {
            self.body.position = CGPointMake(self.body.position.x + self.bodySpeedX, self.body.position.y + self.bodySpeedY);
            
            CGSize bodySize = self.body.size;
            
            if(self.body.position.y <= self.ground){
                
                self.bodySpeedY = 0;
                
                if(self.bodySpeedX > bodySize.width * speed){
                    self.bodySpeedX -= bodySize.width * speed;
                }else
                    self.bodySpeedX =  0;

                
            }else{
                
                self.bodySpeedY -= (bodySize.width * speed);
                
            }
        }

        // the rightArm
        {
            self.rightArm.position = CGPointMake(self.rightArm.position.x + self.rightArmSpeedX, self.rightArm.position.y + self.rightArmSpeedY);
            
            CGSize rightArmSize = self.rightArm.size;
            
            if(self.rightArm.position.y <= self.ground){
                
                self.rightArmSpeedY = 0;
                
                if(self.rightArmSpeedX > rightArmSize.width * speed){
                    self.rightArmSpeedX -= rightArmSize.width * speed;
                }else
                    self.rightArmSpeedX =  0;
                
            }else{
                
                self.rightArmSpeedY -= (rightArmSize.width * speed);
                
            }
        }

        // the leftArm
        {
            self.leftArm.position = CGPointMake(self.leftArm.position.x + self.leftArmSpeedX, self.leftArm.position.y + self.leftArmSpeedY);
            
            CGSize leftArmSize = self.leftArm.size;
            
            if(self.leftArm.position.y <= self.ground){
                
                self.leftArmSpeedY = 0;
                
                if(self.leftArmSpeedX < -leftArmSize.width * speed){
                    self.leftArmSpeedX += leftArmSize.width * speed;
                }else
                    self.leftArmSpeedX =  0;
                
            }else{
                
                self.leftArmSpeedY -= (leftArmSize.width * speed);
                
            }
        }

        // the rightLeg
        {
            self.rightLeg.position = CGPointMake(self.rightLeg.position.x + self.rightLegSpeedX, self.rightLeg.position.y + self.rightLegSpeedY);
            
            CGSize rightLegSize = self.rightLeg.size;
            
            if(self.rightLeg.position.y <= self.ground){
                
                self.rightLegSpeedY = 0;
                
                if(self.rightLegSpeedX > rightLegSize.width * speed){
                    self.rightLegSpeedX -= rightLegSize.width * speed;
                }else
                    self.rightLegSpeedX =  0;
                
            }else{
                
                self.rightLegSpeedY -= (rightLegSize.width * speed);
                
            }
        }

        // the leftLeg
        {
            self.leftLeg.position = CGPointMake(self.leftLeg.position.x + self.leftLegSpeedX, self.leftLeg.position.y + self.leftLegSpeedY);
            
            CGSize leftLegSize = self.leftLeg.size;
            
            if(self.leftLeg.position.y <= self.ground){
                
                self.leftLegSpeedY = 0;
                
                if(self.leftLegSpeedX < -leftLegSize.width * speed){
                    self.leftLegSpeedX += leftLegSize.width * speed;
                }else
                    self.leftLegSpeedX =  0;
                
            }else{
                
                self.leftLegSpeedY -= (leftLegSize.width * speed);
                
            }
        }

        
        
    }],
                                         [SKAction waitForDuration:speed]
                                         ]];

}

-(void)Splode{
    
    float speed = 0.05f;
    
    int splodeFactor = arc4random();
    
    self.bodySpeedX = self.body.size.width * 0.1f;
    self.bodySpeedY = self.body.size.width * 0.1f;
    
    self.rightArmSpeedX = (self.rightArm.size.width * (splodeFactor % 8)) * speed;
    self.rightArmSpeedY = self.rightArm.size.height * speed;
    
    self.leftArmSpeedX = -(self.leftArm.size.width * (splodeFactor % 6)) * speed;
    self.leftArmSpeedY = self.leftArm.size.height * speed;
    
    self.rightLegSpeedX = (self.rightLeg.size.width * (splodeFactor % 4)) * speed;
    self.rightLegSpeedY = (self.rightLeg.size.height * 0.5) * speed;
    
    self.leftLegSpeedX = -(self.leftLeg.size.width * (splodeFactor % 5)) * speed;
    self.leftLegSpeedY = (self.leftLeg.size.height * 0.5) * speed;
    
    [self SetMovementAction];
    
    [self runAction:[SKAction repeatAction:self.movement count:30] completion:^{
    
        [self removeFromParent];
    
    }];
    
}

@end
