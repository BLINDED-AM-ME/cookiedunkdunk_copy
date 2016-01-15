//
//  SGConditionalViewController.m
//  CookieDD
//
//  Created by Luke McDonald on 3/29/14.
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

#import "SGConditionalViewController.h"

@interface SGConditionalViewController ()
@property (assign, nonatomic) CGRect errorPopupOrigin;
@property (strong, nonatomic) NSString *deviceModel;
@property (strong, nonatomic) UIImage *cookieDefaultImage;
@property (strong, nonatomic) NSMutableArray *cookieAnimationArray;

@end

@implementation SGConditionalViewController

#pragma mark - Initialization

- (void)setup
{
    _cookieAnimationArray = [NSMutableArray new];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // Init...
        [self setup];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    
    self.errorPopupOrigin = self.errorPopUp.frame;
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        _deviceModel = @"@2x";
    }
    else if(IS_IPAD)
    {
        _deviceModel = @"@2x~ipad";
    }
    
    
//    NSMutableArray *selectorArray = [NSMutableArray arrayWithArray:@[[NSValue valueWithPointer:@selector(loadChipAnimations)],
//                                                       [NSValue valueWithPointer:@selector(loadMikeyAnimations)],
//                                                       [NSValue valueWithPointer:@selector(loadReginaldAnimations)],
//                                                       [NSValue valueWithPointer:@selector(loadLukeAnimations)],
//                                                       [NSValue valueWithPointer:@selector(loadDustinAnimations)],
//                                                       [NSValue valueWithPointer:@selector(loadGerryAnimations)],
//                                                       [NSValue valueWithPointer:@selector(loadJJAnimations)]]];
//    
////    NSArray *selectorArray = @[[NSValue valueWithPointer:@selector(loadChipAnimations)],
////                               [NSValue valueWithPointer:@selector(loadMikeyAnimations)],
////                               [NSValue valueWithPointer:@selector(loadReginaldAnimations)],
////                               [NSValue valueWithPointer:@selector(loadLukeAnimations)],
////                               [NSValue valueWithPointer:@selector(loadDustinAnimations)],
////                               [NSValue valueWithPointer:@selector(loadGerryAnimations)],
////                               [NSValue valueWithPointer:@selector(loadJJAnimations)]];
//    
//    int randomIndex = arc4random() % [selectorArray count];
//    
////    SEL selector = [selectorArray[randomIndex] pointerValue];
//    
//    _cookieAnimationArray = [self performSelector:[selectorArray[randomIndex] pointerValue] withObject:nil];
//
//    DebugLog(@"cookie array: %@", _cookieAnimationArray);
//
    _cookieAnimationArray = [self loadMikeyAnimations];
    
    if ([_cookieAnimationArray count] > 0)
    {
        _cookieDefaultImage = _cookieAnimationArray[0];
        _cookieImageView.image = _cookieDefaultImage;
        _cookieImageView.animationImages = _cookieAnimationArray;
        _cookieImageView.animationDuration = 1.25;
        _cookieImageView.animationRepeatCount = INFINITY;
        [_cookieImageView startAnimating];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.alpha = 0.0f;
    
    [self checkCondtionalType:self.conditionalType];
    
    [self checkPresentationType:self.presentationType];
    
    if (self.loadingText)
    {
        self.loadingLabel.text = self.loadingText;
    }
    else
    {
        self.loadingText = @"Loading";
        self.loadingLabel.text = self.loadingText;
    }
    
    //[self animateLoadingLabel];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [_cookieImageView stopAnimating];
}

#pragma mark - Load Cookies

- (NSMutableArray *)loadChipAnimations
{
    
    NSArray *allchipframes = @[

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip1%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip2%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip3%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip4%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip5%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip6%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip7%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip8%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip9%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip10%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip11%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip12%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip13%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip14%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip15%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip16%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip17%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip18%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip19%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip20%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip21%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip22%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip23%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip24%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip25%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip26%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip27%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip28%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-chip29%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size]

    ];
 
// _chip_Animation_Switch = [SKAction animateWithTextures:@[
// allchipframes[1],
// allchipframes[2]] timePerFrame:0.06];
// 
// _chip_Animation_Shocker = [SKAction animateWithTextures:@[
// 
// allchipframes[28],
// allchipframes[2],
// 
// ] timePerFrame:0.1];
// 
// _chip_Animation_SwitchBack = [SKAction animateWithTextures:@[
// 
// allchipframes[1],
// allchipframes[0]] timePerFrame:0.06];
// 
// _chip_Animation_Character = [SKAction animateWithTextures:@[
// allchipframes[0],
// allchipframes[20],
// allchipframes[21],
// allchipframes[22],
// allchipframes[23],
// 
// allchipframes[24],
// allchipframes[25],
// allchipframes[26],
// allchipframes[27],
// allchipframes[26],
// 
// allchipframes[25],// 11
// allchipframes[26],
// allchipframes[27],
// allchipframes[26],
// allchipframes[25],
// 
// allchipframes[26],// 16
// allchipframes[27],
// allchipframes[26],
// allchipframes[25],
// allchipframes[24],
// 
// allchipframes[23],// 21
// allchipframes[22],
// allchipframes[21],
// allchipframes[20],
// allchipframes[0]
// 
// ] timePerFrame:0.06];
// 
// _chip_Animation_Delete = [SKAction animateWithTextures:@[
// 
// allchipframes[3],
// allchipframes[4]
// 
// ] timePerFrame:0.06];
// 
// _chip_Animation_Falling = [SKAction animateWithTextures:@[
// 
// allchipframes[3],
// allchipframes[4],
// allchipframes[4],
// allchipframes[4],
// allchipframes[4],
// allchipframes[4],
// allchipframes[3],
// allchipframes[0]
// 
// ] timePerFrame:0.06];
 
// _chip_Animation_Idle = [SKAction animateWithTextures:@[
// 
// allchipframes[0],
// allchipframes[14],
// allchipframes[15],
// allchipframes[16],
// 
// allchipframes[17],
// allchipframes[18],
// allchipframes[19],
// allchipframes[0]
// 
// 
// ] timePerFrame:0.06];
 
     NSMutableArray *pickMeAnimation = [NSMutableArray arrayWithArray:@[
     
     allchipframes[0],
     allchipframes[5],
     allchipframes[6],
     allchipframes[7],
     allchipframes[8],
     
     allchipframes[9],
     allchipframes[10],
     allchipframes[11],
     allchipframes[12],
     allchipframes[11],
     
     allchipframes[10],
     allchipframes[9],
     allchipframes[8],
     allchipframes[7],
     allchipframes[6],
     
     allchipframes[5],
     allchipframes[13],
     allchipframes[0]
     
     ]];
    
    return pickMeAnimation;
 }

- (NSMutableArray *)loadMikeyAnimations
{
 
    NSArray *allmikeyframes = @[

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey1%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey2%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey3%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey4%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey5%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey6%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey7%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey8%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey9%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey10%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey11%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey12%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey13%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey14%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey15%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey16%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey17%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey18%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey19%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey20%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey21%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey22%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey23%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey24%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey25%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey26%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey27%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey28%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey29%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey30%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey31%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey32%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey33%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey34%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey35%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey36%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey37%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey38%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey39%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey40%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey41%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey42%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey43%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey44%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey45%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey46%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey47%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey48%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey49%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey50%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey51%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey52%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey53%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey54%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey55%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-mikey56%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size]

    ];
 
// _mikey_Animation_Shocker = [SKAction animateWithTextures:@[
// 
// allmikeyframes[55],
// allmikeyframes[2],
// 
// ] timePerFrame:0.1];
// 
// 
// _mikey_Animation_Switch = [SKAction animateWithTextures:@[
// 
// allmikeyframes[1],
// allmikeyframes[2]
// 
// ] timePerFrame:0.06];
// 
// _mikey_Animation_SwitchBack = [SKAction animateWithTextures:@[
// 
// allmikeyframes[1],
// allmikeyframes[0]
// 
// ] timePerFrame:0.06];
// 
// _mikey_Animation_Character = [SKAction animateWithTextures:@[
// 
// allmikeyframes[30],
// allmikeyframes[31],
// allmikeyframes[32],
// allmikeyframes[33],
// 
// allmikeyframes[34],
// allmikeyframes[35],
// allmikeyframes[36],
// allmikeyframes[37],
// allmikeyframes[38],
// 
// allmikeyframes[39],
// allmikeyframes[40],
// allmikeyframes[41],
// allmikeyframes[42],
// allmikeyframes[43],
// 
// allmikeyframes[44],
// allmikeyframes[45],
// allmikeyframes[46],
// allmikeyframes[47],
// allmikeyframes[48],
// 
// allmikeyframes[49],
// allmikeyframes[50],
// allmikeyframes[51],
// allmikeyframes[52],
// allmikeyframes[53],
// 
// allmikeyframes[54],
// allmikeyframes[0]
// 
// ] timePerFrame:0.06];
// 
// _mikey_Animation_Delete = [SKAction animateWithTextures:@[
// 
// allmikeyframes[0],
// allmikeyframes[3],
// allmikeyframes[4]
// 
// 
// ] timePerFrame:0.06];
// 
// _mikey_Animation_Falling = [SKAction animateWithTextures:@[
// 
// allmikeyframes[0],
// allmikeyframes[3],
// allmikeyframes[4],
// 
// allmikeyframes[4],
// allmikeyframes[4],
// allmikeyframes[4],
// 
// allmikeyframes[4],
// allmikeyframes[3],
// allmikeyframes[0]
// 
// ] timePerFrame:0.06];
// 
// _mikey_Animation_Idle = [SKAction animateWithTextures:@[
// 
// allmikeyframes[15],
// allmikeyframes[16],
// allmikeyframes[17],
// allmikeyframes[18], // 5
// 
// allmikeyframes[19],
// 
// allmikeyframes[20],allmikeyframes[20],
// allmikeyframes[20],allmikeyframes[20],
// 
// allmikeyframes[21],
// allmikeyframes[22],
// allmikeyframes[21],
// 
// allmikeyframes[20],
// allmikeyframes[21],
// allmikeyframes[22],
// allmikeyframes[21],
// 
// allmikeyframes[20],// 15
// allmikeyframes[20],
// allmikeyframes[20],
// allmikeyframes[20],
// 
// 
// allmikeyframes[19],
// allmikeyframes[18],
// allmikeyframes[16],
// allmikeyframes[23],
// allmikeyframes[24],
// 
// allmikeyframes[25],
// 
// allmikeyframes[26],//22
// allmikeyframes[26],
// allmikeyframes[26],
// allmikeyframes[26],
// 
// allmikeyframes[27],
// allmikeyframes[28],
// allmikeyframes[27], // 25
// 
// allmikeyframes[26],
// allmikeyframes[27],
// allmikeyframes[28],
// allmikeyframes[27],
// 
// allmikeyframes[26], // 30
// allmikeyframes[26],
// allmikeyframes[26],
// allmikeyframes[26],
// allmikeyframes[26],
// 
// 
// allmikeyframes[25],
// allmikeyframes[24],
// allmikeyframes[16],
// allmikeyframes[29],
// allmikeyframes[0]
// 
// ] timePerFrame:0.06];
 
     NSMutableArray *pickMeAnimation = [NSMutableArray arrayWithArray:@[
     
     allmikeyframes[5],
     allmikeyframes[6],
     allmikeyframes[7],
     allmikeyframes[8],
     
     allmikeyframes[9],
     allmikeyframes[10],
     allmikeyframes[11],
     allmikeyframes[12],
     allmikeyframes[11],
     
     allmikeyframes[10],
     allmikeyframes[13],
     allmikeyframes[6],
     allmikeyframes[7],
     allmikeyframes[14], // 15
     
     allmikeyframes[0]
     
     ]];
 
    return pickMeAnimation;
 }
 
- (NSMutableArray *)loadReginaldAnimations
{
    
    NSArray *allreginaldframes = @[

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald1%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald2%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald3%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald4%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald5%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald6%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald7%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald8%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald9%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald10%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald11%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald12%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald13%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald14%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald15%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald16%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald17%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald18%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald19%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald20%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald21%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald22%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald23%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald24%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald25%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald26%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald27%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald28%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald29%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald30%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald31%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald32%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald33%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald34%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald35%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald36%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald37%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald38%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald39%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald40%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald41%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald42%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald43%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-reginald44%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size]


    ];
 
// _reginald_Animation_Shocker = [SKAction animateWithTextures:@[
// 
// allreginaldframes[43],
// allreginaldframes[2],
// 
// ] timePerFrame:0.1];
// 
// _reginald_Animation_Switch = [SKAction animateWithTextures:@[
// 
// allreginaldframes[1],
// allreginaldframes[2]
// 
// ] timePerFrame:0.06];
// 
// _reginald_Animation_SwitchBack = [SKAction animateWithTextures:@[
// 
// allreginaldframes[1],
// allreginaldframes[0]
// 
// ] timePerFrame:0.06];
// 
// _reginald_Animation_Character = [SKAction animateWithTextures:@[
// 
// allreginaldframes[24],
// allreginaldframes[25],
// allreginaldframes[26],
// allreginaldframes[27],//5
// 
// allreginaldframes[28],
// allreginaldframes[29],
// allreginaldframes[30],
// allreginaldframes[31],
// allreginaldframes[32],// 10
// 
// allreginaldframes[33],
// allreginaldframes[34],
// allreginaldframes[35],
// allreginaldframes[36],
// allreginaldframes[37],// 15
// 
// allreginaldframes[38],
// allreginaldframes[39],
// allreginaldframes[40],
// allreginaldframes[41],
// allreginaldframes[42],// 20
// 
// allreginaldframes[0]
// 
// ] timePerFrame:0.06];
// 
// _reginald_Animation_Delete = [SKAction animateWithTextures:@[
// 
// allreginaldframes[0],
// allreginaldframes[3],
// allreginaldframes[4]
// 
// 
// ] timePerFrame:0.06];
// 
// _reginald_Animation_Falling = [SKAction animateWithTextures:@[
// 
// allreginaldframes[0],
// allreginaldframes[1],
// allreginaldframes[2],
// 
// allreginaldframes[2],
// allreginaldframes[2],
// allreginaldframes[2],
// 
// allreginaldframes[2],
// allreginaldframes[1],
// allreginaldframes[0]
// 
// ] timePerFrame:0.06];
// 
// _reginald_Animation_Idle = [SKAction animateWithTextures:@[
// 
// allreginaldframes[18],
// allreginaldframes[19],
// allreginaldframes[20],
// allreginaldframes[21], // 5
// 
// allreginaldframes[22],
// 
// // hold
// allreginaldframes[23],allreginaldframes[23],allreginaldframes[23],
// allreginaldframes[23],allreginaldframes[23],allreginaldframes[23],
// allreginaldframes[23],allreginaldframes[23],allreginaldframes[23],
// 
// allreginaldframes[22],
// allreginaldframes[21],
// allreginaldframes[20],//10
// 
// allreginaldframes[19],
// allreginaldframes[18],                                                            allreginaldframes[0]
// 
// ] timePerFrame:0.06];
 
    NSMutableArray *pickMeAnimation = [NSMutableArray arrayWithArray:@[

    allreginaldframes[5],
    allreginaldframes[6],
    allreginaldframes[7],
    allreginaldframes[8],//5

    allreginaldframes[7],
    allreginaldframes[9],
    allreginaldframes[10],
    allreginaldframes[11],
    allreginaldframes[12],// 10

    allreginaldframes[13],
    allreginaldframes[14],
    allreginaldframes[15],
    allreginaldframes[16],
    allreginaldframes[17], // 15

    allreginaldframes[6],
    allreginaldframes[5],
    allreginaldframes[0]

    ]];
    
    return pickMeAnimation;
 }
 
- (NSMutableArray *)loadLukeAnimations
{
    NSArray *alllukeframes = @[

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke1%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke2%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke3%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke4%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke5%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke6%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke7%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke8%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke9%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke10%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke11%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke12%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke13%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke14%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke15%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke16%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke17%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke18%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke19%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke20%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke21%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke22%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke23%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke24%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke25%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke26%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke27%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke28%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke29%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke30%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke31%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke32%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke33%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke34%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke35%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-luke36%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size]

    ];
 
 
// _luke_Animation_Shocker = [SKAction animateWithTextures:@[
// 
// alllukeframes[35],
// alllukeframes[2],
// 
// ] timePerFrame:0.1];
// 
// _luke_Animation_Switch = [SKAction animateWithTextures:@[
// 
// alllukeframes[1],
// alllukeframes[2]
// 
// ] timePerFrame:0.06];
// 
// _luke_Animation_SwitchBack = [SKAction animateWithTextures:@[
// 
// alllukeframes[1],
// alllukeframes[0]
// 
// ] timePerFrame:0.06];
// 
// _luke_Animation_Character = [SKAction animateWithTextures:@[
// 
// alllukeframes[25], //2
// 
// // hold
// alllukeframes[26], alllukeframes[26],alllukeframes[26],
// alllukeframes[26],alllukeframes[26],alllukeframes[26],
// alllukeframes[26], alllukeframes[26],alllukeframes[26],
// 
// 
// alllukeframes[27],//4
// alllukeframes[28],//5
// 
// alllukeframes[29],
// alllukeframes[30],
// alllukeframes[31],
// 
// // hold
// alllukeframes[32],alllukeframes[32],alllukeframes[32],alllukeframes[32],alllukeframes[32],alllukeframes[32],alllukeframes[32],alllukeframes[32],alllukeframes[32],
// 
// 
// alllukeframes[31],// 10
// 
// alllukeframes[30],
// alllukeframes[33],
// alllukeframes[34],
// alllukeframes[0] // 14
// 
// 
// ] timePerFrame:0.06];
// 
// _luke_Animation_Delete = [SKAction animateWithTextures:@[
// 
// alllukeframes[0],
// alllukeframes[3],
// alllukeframes[4]
// 
// 
// ] timePerFrame:0.06];
// 
// _luke_Animation_Falling = [SKAction animateWithTextures:@[
// 
// alllukeframes[0],
// alllukeframes[1],
// alllukeframes[2],
// 
// alllukeframes[2],
// alllukeframes[2],
// alllukeframes[2],
// 
// alllukeframes[2],
// alllukeframes[1],
// alllukeframes[0]
// 
// ] timePerFrame:0.06];
// 
// _luke_Animation_Idle = [SKAction animateWithTextures:@[
// 
// alllukeframes[14],
// alllukeframes[15],
// alllukeframes[16],
// alllukeframes[17], // 5
// 
// alllukeframes[18],
// alllukeframes[19],
// alllukeframes[20],
// //hold
// alllukeframes[21],alllukeframes[21],alllukeframes[21],
// alllukeframes[21],alllukeframes[21],alllukeframes[21],
// 
// alllukeframes[22],//10
// 
// alllukeframes[23],
// alllukeframes[24],
// alllukeframes[0]
// 
// ] timePerFrame:0.06];
 
    NSMutableArray *pickMeAnimation = [NSMutableArray arrayWithArray:@[

    alllukeframes[5],
    alllukeframes[6],
    alllukeframes[7],
    alllukeframes[8],//5

    alllukeframes[9],
    alllukeframes[10],
    alllukeframes[11],
    alllukeframes[12],
    alllukeframes[8],// 10

    alllukeframes[7],
    alllukeframes[6],
    alllukeframes[13],
    alllukeframes[0]

    ]];
 
    return pickMeAnimation;
 }
 
- (NSMutableArray *)loadDustinAnimations
{
 
 NSArray *alldustinframes = @[
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin1%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin2%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin3%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin4%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin5%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin6%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin7%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin8%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin9%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin10%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin11%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin12%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin13%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin14%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin15%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin16%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin17%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin18%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin19%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin20%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin21%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin22%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin23%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin24%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin25%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin26%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin27%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin28%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin29%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin30%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin31%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin32%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin33%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin34%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin35%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin36%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size]
 ,
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-dustin37%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size]
 
 ];
 
// _dustin_Animation_Shocker = [SKAction animateWithTextures:@[
// 
// alldustinframes[36],
// alldustinframes[2],
// 
// ] timePerFrame:0.1];
// 
// _dustin_Animation_Switch = [SKAction animateWithTextures:@[
// 
// alldustinframes[1],
// alldustinframes[2]
// 
// ] timePerFrame:0.06];
// 
// _dustin_Animation_SwitchBack = [SKAction animateWithTextures:@[
// 
// alldustinframes[1],
// alldustinframes[0]
// 
// ] timePerFrame:0.06];
// 
// _dustin_Animation_Character = [SKAction animateWithTextures:@[
// 
// alldustinframes[18], //2
// alldustinframes[19],
// alldustinframes[20],
// alldustinframes[21],//5
// 
// alldustinframes[22],
// alldustinframes[23], // 7
// alldustinframes[23], // 8
// alldustinframes[24],
// alldustinframes[20],// 10
// 
// alldustinframes[20],
// alldustinframes[25],//12
// alldustinframes[26],
// alldustinframes[27],
// alldustinframes[28],// 15
// 
// alldustinframes[29],
// alldustinframes[30],
// alldustinframes[31],
// alldustinframes[32], // 19
// alldustinframes[32], // 20
// 
// alldustinframes[33],//21
// alldustinframes[29],
// alldustinframes[34],
// alldustinframes[26],
// alldustinframes[35],// 25
// 
// alldustinframes[18],
// alldustinframes[0] // 27
// 
// ] timePerFrame:0.06];
// 
// _dustin_Animation_Delete = [SKAction animateWithTextures:@[
// 
// alldustinframes[0],
// alldustinframes[1],
// alldustinframes[2]
// 
// 
// ] timePerFrame:0.06];
// 
// _dustin_Animation_Falling = [SKAction animateWithTextures:@[
// 
// alldustinframes[0],
// alldustinframes[1],
// alldustinframes[2],
// 
// alldustinframes[2],
// alldustinframes[2],
// alldustinframes[2],
// 
// alldustinframes[2],
// alldustinframes[1],
// alldustinframes[0]
// 
// ] timePerFrame:0.06];
// 
// _dustin_Animation_Idle = [SKAction animateWithTextures:@[
// 
// alldustinframes[3],
// alldustinframes[4],
// alldustinframes[5],
// alldustinframes[6], // 5
// 
// alldustinframes[7],
// alldustinframes[8],
// alldustinframes[9],
// alldustinframes[10],
// alldustinframes[11],//10
// 
// alldustinframes[3],
// alldustinframes[0]
// 
// ] timePerFrame:0.06];
 
    NSMutableArray *pickMeAnimation = [NSMutableArray arrayWithArray:@[

    alldustinframes[12],
    alldustinframes[13],
    alldustinframes[14],
    alldustinframes[0],//5

    alldustinframes[14],
    alldustinframes[15],
    alldustinframes[16],
    alldustinframes[17],
    alldustinframes[0],// 10

    alldustinframes[12],
    alldustinframes[13],
    alldustinframes[12],
    alldustinframes[0]

    ]];
 
 
    return pickMeAnimation;
 }
 
- (NSMutableArray *)loadGerryAnimations
{
    
 NSArray *allgerryframes = @[
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry1%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry2%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry3%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry4%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry5%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry6%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry7%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry8%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry9%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry10%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry11%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry12%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry13%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry14%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry15%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry16%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry17%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry18%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry19%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry20%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry21%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry22%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry23%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry24%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry25%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry26%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry27%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry28%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry29%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry30%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry31%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry32%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry33%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry34%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry35%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry36%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry37%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry38%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry39%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry40%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry41%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry42%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry43%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry44%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry45%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry46%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry47%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry48%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
 
 [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-gerry49%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size]
 
 
 ];
 
// _gerry_Animation_Shocker = [SKAction animateWithTextures:@[
// 
// allgerryframes[48],
// allgerryframes[2],
// 
// ] timePerFrame:0.1];
// 
// _gerry_Animation_Switch = [SKAction animateWithTextures:@[
// 
// allgerryframes[1],
// allgerryframes[2]
// 
// ] timePerFrame:0.06];
// 
// _gerry_Animation_SwitchBack = [SKAction animateWithTextures:@[
// 
// allgerryframes[1],
// allgerryframes[0]
// 
// ] timePerFrame:0.06];
// 
// _gerry_Animation_Character = [SKAction animateWithTextures:@[
// 
// allgerryframes[36], //2
// allgerryframes[37],
// allgerryframes[38],
// allgerryframes[39],//5
// 
// allgerryframes[40],
// allgerryframes[41],
// allgerryframes[42],
// allgerryframes[43],
// allgerryframes[44],// 10
// 
// allgerryframes[45],
// allgerryframes[46],
// allgerryframes[46],
// allgerryframes[46],
// allgerryframes[46],//15
// 
// allgerryframes[46],
// allgerryframes[47],
// allgerryframes[43],
// allgerryframes[41],
// allgerryframes[39],// 20
// 
// allgerryframes[38],
// allgerryframes[37],
// allgerryframes[0]// 23
// 
// ] timePerFrame:0.06];
// 
// _gerry_Animation_Delete = [SKAction animateWithTextures:@[
// 
// allgerryframes[0],
// allgerryframes[3],
// allgerryframes[4]
// 
// 
// ] timePerFrame:0.06];
// 
// _gerry_Animation_Falling = [SKAction animateWithTextures:@[
// 
// allgerryframes[0],
// allgerryframes[1],
// allgerryframes[2],
// 
// allgerryframes[2],
// allgerryframes[2],
// allgerryframes[2],
// 
// allgerryframes[2],
// allgerryframes[1],
// allgerryframes[0]
// 
// ] timePerFrame:0.06];
// 
// _gerry_Animation_Idle = [SKAction animateWithTextures:@[
// 
// allgerryframes[20],
// allgerryframes[21],
// allgerryframes[22],
// allgerryframes[23], // 5
// 
// allgerryframes[24],
// allgerryframes[25],
// allgerryframes[26],
// allgerryframes[27],
// allgerryframes[28],//10
// 
// allgerryframes[29],
// allgerryframes[30],
// allgerryframes[31],
// allgerryframes[32],
// allgerryframes[33],//15
// 
// allgerryframes[34],
// allgerryframes[35],
// allgerryframes[0] // 18
// 
// ] timePerFrame:0.06];
 
    NSMutableArray *pickMeAnimation = [NSMutableArray arrayWithArray:@[

    allgerryframes[5],
    allgerryframes[6],
    allgerryframes[7],
    allgerryframes[8],//5

    allgerryframes[9],
    allgerryframes[10],
    allgerryframes[11],
    allgerryframes[12],
    allgerryframes[13],// 10

    allgerryframes[14],
    allgerryframes[15],
    allgerryframes[16],
    allgerryframes[17],
    allgerryframes[18],// 15

    allgerryframes[19],
    allgerryframes[5],
    allgerryframes[0]

    ]];
    
    return pickMeAnimation;
 }
 
 
- (NSMutableArray *)loadJJAnimations
{
    NSArray *alljjframes = @[

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj1%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj2%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj3%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj4%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj5%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj6%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj7%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj8%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj9%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj10%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj11%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj12%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj13%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj14%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj15%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj16%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj17%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj18%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj19%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj20%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj21%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj22%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj23%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj24%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj25%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj26%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj27%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj28%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj29%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj30%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj31%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj32%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj33%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj34%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj35%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj36%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj37%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj38%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj39%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj40%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],

    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj41%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size],
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj42%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size]

    ,
    [[UIImage imageNamed:[NSString stringWithFormat:@"cookie-jj43%@",_deviceModel]] scaleToSize:self.cookieImageView.frame.size]

    ];
 
// _jj_Animation_Shocker = [SKAction animateWithTextures:@[
// 
// alljjframes[42],
// alljjframes[2],
// 
// ] timePerFrame:0.1];
// 
// _jj_Animation_Switch = [SKAction animateWithTextures:@[
// 
// alljjframes[1],
// alljjframes[2]
// 
// ] timePerFrame:0.06];
// 
// _jj_Animation_SwitchBack = [SKAction animateWithTextures:@[
// 
// alljjframes[1],
// alljjframes[0]
// 
// ] timePerFrame:0.06];
// 
// _jj_Animation_Character = [SKAction animateWithTextures:@[
// 
// alljjframes[13], //2
// alljjframes[14],
// alljjframes[15],
// alljjframes[16],//5
// 
// alljjframes[17],
// alljjframes[16],
// alljjframes[15],
// alljjframes[14],
// alljjframes[18],// 10
// 
// alljjframes[19],
// alljjframes[20],
// alljjframes[19],
// alljjframes[18],
// alljjframes[14],//15
// 
// alljjframes[15],
// alljjframes[16],
// alljjframes[17],
// alljjframes[16],
// alljjframes[15],// 20
// 
// alljjframes[14],
// alljjframes[18],
// alljjframes[19],
// alljjframes[20],
// alljjframes[18],// 25
// 
// alljjframes[14],
// alljjframes[13],
// 
// alljjframes[0]// 28
// 
// 
// ] timePerFrame:0.06];
// 
// _jj_Animation_Delete = [SKAction animateWithTextures:@[
// 
// alljjframes[0],
// alljjframes[3],
// alljjframes[4]
// 
// 
// ] timePerFrame:0.06];
// 
// _jj_Animation_Falling = [SKAction animateWithTextures:@[
// 
// alljjframes[0],
// alljjframes[1],
// alljjframes[2],
// 
// alljjframes[2],
// alljjframes[2],
// alljjframes[2],
// 
// alljjframes[2],
// alljjframes[1],
// alljjframes[0]
// 
// ] timePerFrame:0.06];
// 
// _jj_Animation_Idle = [SKAction animateWithTextures:@[
// 
// alljjframes[21],
// alljjframes[22],
// alljjframes[23],
// alljjframes[24], // 5
// 
// alljjframes[25],
// alljjframes[26],
// alljjframes[27],
// alljjframes[28],
// alljjframes[29],//10
// 
// alljjframes[30],
// alljjframes[31],
// alljjframes[32],
// alljjframes[33],
// alljjframes[34],//15
// 
// alljjframes[35],
// alljjframes[36],
// alljjframes[37],
// alljjframes[38],
// alljjframes[29],//20
// 
// alljjframes[30],
// alljjframes[31],
// alljjframes[32],
// alljjframes[33],
// alljjframes[34],//25
// 
// alljjframes[35],
// alljjframes[39],
// alljjframes[40],
// alljjframes[41],
// alljjframes[0]//30
// 
// 
// ] timePerFrame:0.06];
 
    NSMutableArray *pickMeAnimation = [NSMutableArray arrayWithArray:@[

    alljjframes[5],
    alljjframes[6],
    alljjframes[5],
    alljjframes[7],//5

    alljjframes[8],
    alljjframes[9],
    alljjframes[10],
    alljjframes[5],
    alljjframes[6],// 10

    alljjframes[5],
    alljjframes[0],
    alljjframes[11],
    alljjframes[0],
    alljjframes[12],// 15

    alljjframes[0]

    ]];
    
    return pickMeAnimation;
 }

#pragma mark - Custom Methods

- (void)checkCondtionalType:(ConditionalType)type
{
    self.requestButton.titleLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:12.0f];
    self.conditionsLabel.font = [UIFont fontWithName:kFontDamnNoisyKids size:14.0f];
    
    switch (type)
    {
        case ConditionalType_Default:
        {
            
        }
            break;
            
        case ConditionalType_InsufficentFunds:
        {
            self.conditionsLabel.text = @"Insufficient Funds";
        }
            break;
            
        case ConditionalType_NoInternetAccess:
        {
            self.conditionsLabel.text = @"No Internet Access";
        }
            break;
            
        case ConditionalType_Error:
        {
            self.conditionsLabel.text = self.errorDescription;
        }
            break;
            
        default:
            break;
    }
}

- (void)checkPresentationType:(PresentationType)type
{
    switch (type)
    {
        case PresentationType_Default:
        {
            
        }
            break;
        
        case PresentationType_Error:
        {
            [self.errorPopUp setHidden:NO];
            [self.loadingPopup setHidden:YES];
        }
            break;
            
        case PresentationType_Loading:
        {
            [self.errorPopUp setHidden:YES];
            [self.loadingPopup setHidden:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void)animateInErrorPopUpWithCompletionHandler:(AnimateOutErrorPopUpCompletionHandler)handler
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.alpha = 1.0f;
       // self.errorPopUp.frame = CGRectMake(kScreenHeight * 0.5f, kScreenWidth * 0.5f, self.errorPopUp.frame.size.width, self.errorPopUp.frame.size.height);
    } completion:^(BOOL finished) {
        if (handler) handler(YES);
    }];
}

- (void)animateOutErrorPopUpWithCompletionHandler:(AnimateInErrorPopUpCompletionHandler)handler
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.alpha = 0.0f;
       // self.errorPopUp.frame = self.errorPopupOrigin;
    } completion:^(BOOL finished) {
        if (handler) handler(YES);
    }];
}



#pragma mark - Animations

- (void)animateLoadingLabel
{
    [UIView animateWithDuration:0.3f animations:^{
        if ([self.loadingLabel.text isEqualToString:[NSString stringWithFormat:@"%@...", self.loadingText]]) {
            self.loadingLabel.text = self.loadingText;
        } else {
            self.loadingLabel.text = [NSString stringWithFormat:@"%@.", self.loadingLabel.text];
        }
    } completion:^(BOOL finished) {
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self animateLoadingLabel];
        });
    }];
}

- (void)animateCookie
{
}

#pragma mark - IBActions

- (IBAction)acceptRequest:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(conditionalViewControllerDidAccept:)])
    {
        [self.delegate conditionalViewControllerDidAccept:self];
    }
}

- (IBAction)denyRequest:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(conditionalViewControllerDidDeny:)])
    {
        [self.delegate conditionalViewControllerDidDeny:self];
    }
}


#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    if (_presentRight)
//    {
//        return UIInterfaceOrientationLandscapeRight;
//    }
//    return UIInterface;
//}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    if (_mainButtonViewController)
//    {
//        [_mainButtonViewController orientationHasChanged:toInterfaceOrientation WithDuration:duration];
//    }
}

@end

@implementation UIImage (CDDAdditions)

- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

/*

 */