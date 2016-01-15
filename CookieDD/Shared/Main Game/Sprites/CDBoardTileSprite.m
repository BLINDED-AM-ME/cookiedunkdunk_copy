//
//  CookieDD
//
//  Created by Josh on 1/23/14.
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

#import "CDBoardTileSprite.h"
#import "CDCommonHelpers.h"

@implementation CDBoardTileSprite

#pragma mark - Positioning

- (void)rotate90Clockwise {
    SKAction *rotate90cw = [SKAction rotateByAngle:90.0f duration:0.0f];
    [self runAction:rotate90cw];
}

- (void)rotate90CounterClockwise {
    SKAction *rotate90ccw = [SKAction rotateByAngle:270.0f duration:0.0f];
    [self runAction:rotate90ccw];
}

- (void)rotate180 {
    SKAction *rotate180 = [SKAction rotateByAngle:180.0f duration:0.0f];
    [self runAction:rotate180];
}

- (void)flipHorizontal {
    SKAction *flipHorizontal = [SKAction scaleXTo:-1.0f duration:0.0f];
    [self runAction:flipHorizontal];
}

- (void)flipVertical {
    SKAction *flipVertical = [SKAction scaleYTo:-1.0f duration:0.0f];
    [self runAction:flipVertical];
}

#pragma mark - Calculating Shape & Position


- (void)calculateAndSetTileDirectionWithNeighbors:(NSArray *)neighborsArray {  // <<< This is complete, but untested.
    // neighborsArray starts at Left, and wraps around clockwise.
    
    int neighborCount = (int)neighborsArray[0] + (int)neighborsArray[2] + (int)neighborsArray[4] + (int)neighborsArray[6];
    
    switch (neighborCount) {
        case 0: {
            [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-4A"]];
            break;
        }
            
        case 1: {
            if (neighborsArray[0]) {
                // ╡
                [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-3A"]];
                [self rotate90CounterClockwise];
            }
            else if (neighborsArray[2]) {
                // ╨
                [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-3A"]];
            }
            else if (neighborsArray[4]) {
                // ╞
                [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-3A"]];
                [self rotate90Clockwise];
            }
            else if (neighborsArray[6]) {
                // ╥
                [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-3A"]];
                [self rotate180];
            }
            break;
        }
            
        case 2: {
            if (neighborsArray[0] && neighborsArray[4]) {
                // Horizontal tube.
                [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2C"]];
            }
            else if (neighborsArray[2] && neighborsArray[6]) {
                // Vertical tube.
                [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2C"]];
                [self rotate90Clockwise];
            }
            else {
                // Corner   // Check for corner tab.
                if (neighborsArray[0] && neighborsArray[2]) {
                    if (neighborsArray[1]) {
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2B"]];
                        [self rotate180];
                    }
                    else {
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2C"]];
                        [self rotate180];
                    }
                }
                else if (neighborsArray[2] && neighborsArray[4]) {
                    // ┗
                    if (neighborsArray[1]) {
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2B"]];
                        [self rotate90CounterClockwise];
                    }
                    else {
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2C"]];
                        [self rotate90CounterClockwise];
                    }
                }
                else if (neighborsArray[4] && neighborsArray[6]) {
                    // ┏
                    if (neighborsArray[1]) {
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2B"]];
                    }
                    else {
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2C"]];
                    }
                }
                else if (neighborsArray[6] && neighborsArray[0]) {
                    // ┓
                    if (neighborsArray[1]) {
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2B"]];
                        [self rotate90Clockwise];
                    }
                    else {
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-2C"]];
                        [self rotate90Clockwise];
                    }
                }
            }
            break;
        }
            
        case 3: {
            if (neighborsArray[0] && neighborsArray[2] && neighborsArray[4]) {
                // Bottom wall.
                if (neighborsArray[1]) {
                    if (neighborsArray[3]) {
                        // No Corner.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1A"]];
                    }
                    else {
                        // Right Corner.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1B"]];
                    }
                }
                else if (neighborsArray[3]) {
                    // Left Corner.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1B"]];
                    [self flipHorizontal];
                }
                else {
                    // No Corner.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1A"]];
                }
            }
            else if (neighborsArray[2] && neighborsArray[4] && neighborsArray[6]) {
                // Left wall.
                if (neighborsArray[3]) {
                    if (neighborsArray[5]) {
                        // No Corner.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1A"]];
                    }
                    else {
                        // Left Corner.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1C"]];
                    }
                }
                else if (neighborsArray[5]) {
                    // Right Corner.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1B"]];
                }
                else {
                    // Both Corners.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1D"]];
                }
                
                [self rotate90Clockwise];
            }
            else if (neighborsArray[4] && neighborsArray[6] && neighborsArray[0]) {
                // Top wall.
                if (neighborsArray[5]) {
                    if (neighborsArray[7]) {
                        // Both corners.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1D"]];
                    }
                    else {
                        // Left Corner.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1C"]];
                    }
                }
                else if (neighborsArray[7]) {
                    // Right Corner.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1B"]];
                }
                else {
                    // No Corner.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1A"]];
                }
                
                [self rotate180];
            }
            else if (neighborsArray[6] && neighborsArray[0] && neighborsArray[2]) {
                // Right wall.
                if (neighborsArray[7]) {
                    if (neighborsArray[1]) {
                        // Both corners.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1D"]];
                    }
                    else {
                        // Left Corner.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1C"]];
                    }
                }
                else if (neighborsArray[1]) {
                    // Right Corner.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1B"]];
                }
                else {
                    // No Corner.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-1A"]];
                }
                
                [self rotate90CounterClockwise];
            }
            break;
        }
            
        case 4: {
            if (neighborsArray[1]) {
                if (neighborsArray[3]) {
                    if (neighborsArray[5]) {
                        if (neighborsArray[7]) {
                            // No corners.
                            [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0A"]];
                        }
                        else {
                            // Bottom left corner.
                            [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0B"]];
                            [self rotate90CounterClockwise];
                        }
                    }
                    else if (neighborsArray[7]) {
                        // Bottom right corner.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0B"]];
                        [self rotate180];
                    }
                    else {
                        // Both bottom corners.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0C"]];
                        [self rotate180];
                    }
                }
                else if (neighborsArray[5]) {
                    if (neighborsArray[7]) {
                        // Top right corner.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0B"]];
                        [self rotate90Clockwise];
                    }
                    else {
                        // Top right and Bottom left.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0D"]];
                        [self rotate90Clockwise];
                    }
                }
                else if (neighborsArray[7]) {
                    // Both right corners.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0C"]];
                    [self rotate90Clockwise];
                }
                else {
                    // All but top left.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0E"]];
                    [self rotate90Clockwise];
                }
            }
            else if (neighborsArray[3]) {
                if (neighborsArray[5]) {
                    if (neighborsArray[7]) {
                        // Top left corner.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0B"]];
                    }
                    else {
                        // Both left corners.
                        [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0C"]];
                        [self rotate90CounterClockwise];
                    }
                }
                else if (neighborsArray[7]) {
                    // Top left and Bottom right.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0D"]];
                }
                else {
                    // All but top right.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0E"]];
                    [self rotate180];
                }
            }
            else if (neighborsArray[5]) {
                if (neighborsArray[7]) {
                    // Both top corners.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0C"]];
                }
                else {
                    // All but bottom right.
                    [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0E"]];
                    [self rotate90CounterClockwise];
                }
            }
            else if (neighborsArray[7]) {
                // All but bottom left.
                [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0E"]];
            }
            else {
                // All corners.
                [self setTexture:[SKTexture sgtextureWithImageNamed:@"cdd-tile-0F"]];
            }
            break;
        }
            
        default:
            break;
    }
}

@end
