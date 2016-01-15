//
//  CDMainGameGoalPopup.m
//  CookieDD
//
//  Created by BLINDED AM ME on 4/18/14.
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

#import "CDMainGameGoalPopup.h"
#import "SGGameManager.h"

@implementation CDMainGameGoalPopup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setup
{
    [_gameNameLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:25]];
    [_gameNameLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    [_playLabel setFont:[UIFont fontWithName:kFontDamnNoisyKids size:17]];
    [_playLabel setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
    
    NSString* deviceModel = @"@2x";
    
    if(IS_IPHONE_4 || IS_IPHONE_5){
        
        deviceModel = @"@2x";
        
    }else
        if(IS_IPAD){
            
            deviceModel = @"@2x~ipad";
        }

    
    _itemTextures = @[
                      
                      [UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj1%@",deviceModel]],//0
                      [UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald1%@",deviceModel]],//1
                      [UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke1%@",deviceModel]],//2
                      [UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin1%@",deviceModel]],//3
                      [UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey1%@",deviceModel]],//4
                      [UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry1%@",deviceModel]],//5
                      [UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip1%@",deviceModel]],//6
                      
                      [UIImage imageNamed:[NSString stringWithFormat:@"cdd-main-board-item-egg%@",deviceModel]],//7
                      [UIImage imageNamed:[NSString stringWithFormat:@"cdd-main-board-item-chocchip%@",deviceModel]],//8
                      
                      [UIImage imageNamed:[NSString stringWithFormat:@"cdd-boardpiece-glasscase%@",deviceModel]]//9
                      
                      ];
    
}

- (IBAction)OK_LetsPlay:(id)sender{
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Click 2" FileType:@"caf"]; //@"m4a"];
    
    [[SGGameManager gameManager] ReadyToPlay];
}


-(void)ShowGoals
{
    float height = 20.0f;
    
    NSArray* previous_goals = [NSArray arrayWithArray:_goal_area.subviews];
    
    for (SGStrokeLabel* child in previous_goals) {
        [child removeFromSuperview];
    }
    
    float additiveY = 0;
    
    GoalTypes first_goal_type = [SGGameManager gameManager].mainGoalType;
    GoalTypes second_goal_type = [SGGameManager gameManager].secondGoalType;
    
    if(first_goal_type == GoalTypes_TOTALSCORE){
        
        SGStrokeLabel* goal = [SGStrokeLabel new];
        
        goal.text = [NSString stringWithFormat:@" SCORE: %i ",[SGGameManager gameManager].mainGoalValue];
        
        
        goal.textColor = [UIColor whiteColor];
        goal.frame = CGRectMake(0, additiveY, _goal_area.frame.size.width, height);
        [goal setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
        [goal setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
        
        [_goal_area addSubview:goal];
        
        additiveY += height;
        
    }else if (first_goal_type == GoalTypes_TYPECLEAR){
        
        NSArray* goals = [NSArray arrayWithArray:[SGGameManager gameManager].mainGoalItems];
        
        for(int i=0; i<goals.count; i+=2){
            
            SGStrokeLabel* goal = [SGStrokeLabel new];
            
            additiveY += (height*0.25) ;
            
            goal.text = [NSString stringWithFormat:@" Remove:  %i X ", [goals[i+1] intValue]];
            
            goal.textColor = [UIColor whiteColor];
            goal.frame = CGRectMake(0, additiveY, _goal_area.frame.size.width, height);
            [goal setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
            [goal setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
            
            [_goal_area addSubview:goal];
            
            // image
            
            
            UIImage* iconImage = _itemTextures[0];
            
            switch ([goals[i] intValue]) {
                case COOKIE_BLUE:
                    iconImage = _itemTextures[4];
                    break;
                case COOKIE_CHIP:
                    iconImage = _itemTextures[6];
                    break;
                case COOKIE_GREEN:
                    iconImage = _itemTextures[3];
                    break;
                case COOKIE_ORANGE:
                    iconImage = _itemTextures[1];
                    break;
                case COOKIE_PURPLE:
                    iconImage = _itemTextures[5];
                    break;
                case COOKIE_RED:
                    iconImage = _itemTextures[0];
                    break;
                case COOKIE_YELLOW:
                    iconImage = _itemTextures[2];
                    break;
                    
                case INGREDIENT_CHIPS:
                    iconImage = _itemTextures[8];
                    break;
                case INGREDIENT_EGG:
                    iconImage = _itemTextures[7];
                    break;
                    
                case 500:
                    iconImage = _itemTextures[9];
                    break;
                    
            }
            
            UIImageView* icon = [UIImageView new];
            
            float imageSize = height * 1.5;
            float digit = 1;
            
            if([goals[i+1] intValue] >= 10){
                digit = 2;
            }
            
            if([goals[i+1] intValue] >= 100){
                digit = 3;
            }
            
            icon.frame = CGRectMake(_goal_area.frame.size.width*0.5 + (digit * (imageSize * 0.5)),
                                    additiveY+ (imageSize * 0.5) - height,
                                    imageSize,
                                    imageSize);
            
            icon.image = iconImage;
            
            [_goal_area addSubview:icon];
            additiveY += height;
            
        }
        
    }
    
    
    if(first_goal_type != second_goal_type){
        if(second_goal_type == GoalTypes_TOTALSCORE){
            
            SGStrokeLabel* goal = [SGStrokeLabel new];
            
            goal.text = [NSString stringWithFormat:@" SCORE: %i ",[SGGameManager gameManager].mainGoalValue];
            
            goal.textColor = [UIColor whiteColor];
            goal.frame = CGRectMake(0, additiveY, _goal_area.frame.size.width, height);
            [goal setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
            [goal setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
            
            [_goal_area addSubview:goal];
            
            additiveY += height;
            
        }else
            if(second_goal_type == GoalTypes_TYPECLEAR){
            
            NSArray* goals = [NSArray arrayWithArray:[SGGameManager gameManager].secondGoalItems];
            
            for(int i=0; i<goals.count; i+=2){
                
                SGStrokeLabel* goal = [SGStrokeLabel new];
                
                additiveY += (height*0.25) ;
                
                goal.text = [NSString stringWithFormat:@" Remove:  %i X ", [goals[i+1] intValue]];
                
                goal.textColor = [UIColor whiteColor];
                goal.frame = CGRectMake(0, additiveY, _goal_area.frame.size.width, height);
                [goal setFont:[UIFont fontWithName:kFontDamnNoisyKids size:20]];
                [goal setStrokeColor:[UIColor blackColor] AndStrokeWidth:IS_IPAD? 4 : 2];
                
                [_goal_area addSubview:goal];
                
                // image
                
                UIImage* iconImage = _itemTextures[0];
                
                switch ([goals[i] intValue]) {
                    case COOKIE_BLUE:
                        iconImage = _itemTextures[4];
                        break;
                    case COOKIE_CHIP:
                        iconImage = _itemTextures[6];
                        break;
                    case COOKIE_GREEN:
                        iconImage = _itemTextures[3];
                        break;
                    case COOKIE_ORANGE:
                        iconImage = _itemTextures[1];
                        break;
                    case COOKIE_PURPLE:
                        iconImage = _itemTextures[5];
                        break;
                    case COOKIE_RED:
                        iconImage = _itemTextures[0];
                        break;
                    case COOKIE_YELLOW:
                        iconImage = _itemTextures[2];
                        break;
                        
                    case INGREDIENT_CHIPS:
                        iconImage = _itemTextures[8];
                        break;
                    case INGREDIENT_EGG:
                        iconImage = _itemTextures[7];
                        break;
                        
                    case 500:
                        iconImage = _itemTextures[9];
                        break;
        
                }
                
                UIImageView* icon = [UIImageView new];
                
                float imageSize = height * 1.5;
                
                float digit = 1;
                
                if([goals[i+1] intValue] >= 10){
                    digit = 2;
                }
                
                if([goals[i+1] intValue] >= 100){
                    digit = 3;
                }
                
                icon.frame = CGRectMake(_goal_area.frame.size.width*0.5 + (digit * (imageSize * 0.5)),
                                        additiveY+ (imageSize * 0.5) - height,
                                        imageSize,
                                        imageSize);

                icon.image = iconImage;
                
                [_goal_area addSubview:icon];
                additiveY += height;
                
            }
            
        }
    }
    
    _goal_area.contentSize = CGSizeMake(_goal_area.frame.size.width, additiveY);
}

@end
