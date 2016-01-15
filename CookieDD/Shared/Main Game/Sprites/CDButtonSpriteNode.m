//
//  CDButtonSpriteNode.m
//  CookieDD
//
//  Created by Luke McDonald on 2/10/14.
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

#import "CDButtonSpriteNode.h"

@implementation CDButtonSpriteNode

#pragma mark - Initialization

- (id)initButtonSpriteNodeWithItemType:(ItemType)itemType
{
    SKTexture *iconTexture = [self setIconTexture:itemType];
    
    self = [super initWithTexture:iconTexture];
    
    if (self)
    {
        // Initialization...
        self.userInteractionEnabled = YES;
        
        self.zPosition = 9001;
        
        self.itemType = itemType;
    }
    
    return self;
}

- (SKTexture *)setIconTexture:(ItemType)itemType
{
    DebugLog(@"itemType = %i", itemType);
    NSString *itemString = @"";
    NSArray *referenceArray = [[SGFileManager fileManager] loadArrayWithFileName:@"itemtypes-textures-master-list" OfType:@"plist"];
    if (itemType < [referenceArray count]) {
        itemString = [referenceArray objectAtIndex:itemType];
        if ([itemString length] < 1) {
            // If the string comes back bad, give it the error image.
            itemString = @"erron";
            //self.userInteractionEnabled = NO;
        }
    }
    else {
        itemString = @"erron";
        //self.userInteractionEnabled = NO;
    }
    
    
    NSString *iconString = [NSString stringWithFormat:@"cdd-main-board-hud-icon-%@", itemString];
    SKTexture *iconTexture = [SKTexture sgtextureWithImageNamed:iconString];
    
    if (([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-spatula"]) && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"spatula"] intValue] > 0))
    {
        _boosterName = @"spatula";
        _boosterCount = [[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"spatula"] intValue];
        
        if (_boosterCount <= 99)
        {
            _boosterLabelText = [NSString stringWithFormat:@"%i", _boosterCount];
        }
        else if (_boosterCount > 99)
        {
            _boosterLabelText = @"99+";
        }
    }
    else if ([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-spatula"])
    {
        _boosterCount = 0;
        _boosterLabelText = @"0";
    }
    else if (([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-nuke"]) && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"nuke"] intValue] > 0))
    {
        _boosterName = @"nuke";
        _boosterCount = [[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"nuke"] intValue];
        
        if (_boosterCount <= 99)
        {
            _boosterLabelText = [NSString stringWithFormat:@"%i", _boosterCount];
        }
        else if (_boosterCount > 99)
        {
            _boosterLabelText = @"99+";
        }
    }
    else if ([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-nuke"])
    {
        _boosterCount = 0;
        _boosterLabelText = @"0";
    }
    else if (([iconString isEqualToString:@"cdd-main-board-hud-icon-fortune"]) && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"fortune"] intValue] > 0))
    {
        _boosterName = @"fortune";
        _boosterCount = [[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"fortune"] intValue];
        
        if (_boosterCount <= 99)
        {
            _boosterLabelText = [NSString stringWithFormat:@"%i", _boosterCount];
        }
        else if (_boosterCount > 99)
        {
            _boosterLabelText = @"99+";
        }
    }
    else if ([iconString isEqualToString:@"cdd-main-board-hud-icon-fortune"])
    {
        _boosterCount = 0;
        _boosterLabelText = @"0";
    }
    else if (([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-lightning"]) && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"thunderbolt"] intValue] > 0))
    {
        _boosterName = @"thunderbolt";
        _boosterCount = [[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"thunderbolt"] intValue];
        
        if (_boosterCount <= 99)
        {
            _boosterLabelText = [NSString stringWithFormat:@"%i", _boosterCount];
        }
        else if (_boosterCount > 99)
        {
            _boosterLabelText = @"99+";
        }
    }
    else if ([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-lightning"])
    {
        _boosterCount = 0;
        _boosterLabelText = @"0";
    }
    else if (([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-slotmachine"]) && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"slotMachine"] intValue] > 0))
    {
        _boosterName = @"slotMachine";
        _boosterCount = [[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"slotMachine"] intValue];
        
        if (_boosterCount <= 99)
        {
            _boosterLabelText = [NSString stringWithFormat:@"%i", _boosterCount];
        }
        else if (_boosterCount > 99)
        {
            _boosterLabelText = @"99+";
        }
    }
    else if ([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-slotmachine"])
    {
        _boosterCount = 0;
        _boosterLabelText = @"0";
    }
    else if (([iconString isEqualToString:@"cdd-main-board-hud-icon-powerup-smore"]) && ([[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"smore"] intValue] > 0))
    {
        _boosterName = @"smore";
        _boosterCount = [[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"smore"] intValue];
        
        if (_boosterCount <= 99)
        {
            _boosterLabelText = [NSString stringWithFormat:@"%i", _boosterCount];
        }
        else if (_boosterCount > 99)
        {
            _boosterLabelText = @"99+";
        }
    }
    else if ([iconString isEqualToString:@"cdd-main-board-hud-icon-powerup-smore"])
    {
        _boosterCount = 0;
        _boosterLabelText = @"0";
    }
    else if (([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-radsprinkle"]) && ([[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"radioactiveSprinkle"] intValue] > 0))
    {
        _boosterName = @"radioactiveSprinkle";
        _boosterCount = [[[SGAppDelegate appDelegate].accountDict[@"boosters"] objectForKey:@"radioactiveSprinkle"] intValue];
        if (_boosterCount <= 99)
        {
            _boosterLabelText = [NSString stringWithFormat:@"%i", _boosterCount];
        }
        else if (_boosterCount > 99)
        {
            _boosterLabelText = @"99+";
        }
    }
    else if ([iconString isEqualToString:@"cdd-main-board-hud-icon-booster-radsprinkle"])
    {
        _boosterCount = 0;
        _boosterLabelText = @"0";
    }
    else if (([iconString isEqualToString:@"cdd-main-board-hud-icon-powerup-superglove"]) && ([[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"powerGlove"] intValue] > 0))
    {
        _boosterName = @"powerGlove";
        _boosterCount = [[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"powerGlove"] intValue];
        
        if (_boosterCount <= 99)
        {
            _boosterLabelText = [NSString stringWithFormat:@"%i", _boosterCount];
        }
        else if (_boosterCount > 99)
        {
            _boosterLabelText = @"99+";
        }
    }
    else if ([iconString isEqualToString:@"cdd-main-board-hud-icon-powerup-superglove"])
    {
        _boosterCount = 0;
        _boosterLabelText = @"0";
    }
    else if (([iconString isEqualToString:@"cdd-main-board-hud-icon-powerup-wrapper"]) && ([[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"wrappedCookie"] intValue] > 0))
    {
        _boosterName = @"wrappedCookie";
        _boosterCount = [[[SGAppDelegate appDelegate].accountDict[@"powerups"] objectForKey:@"wrappedCookie"] intValue];
        
        if (_boosterCount <= 99)
        {
            _boosterLabelText = [NSString stringWithFormat:@"%i", _boosterCount];
        }
        else if (_boosterCount > 99)
        {
            _boosterLabelText = @"99+";
        }
    }
    else if ([iconString isEqualToString:@"cdd-main-board-hud-icon-powerup-wrapper"])
    {
        _boosterCount = 0;
        _boosterLabelText = @"0";
    }
    
    return iconTexture;
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(cdButtonSpriteNode:wasSelectedForItemType:)])
    {
        [self.delegate cdButtonSpriteNode:(CDButtonSpriteNode *)self wasSelectedForItemType:(ItemType)self.itemType];
    }
}

@end
