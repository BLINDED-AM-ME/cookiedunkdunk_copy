//
//  CDHowtoPopup.h
//  CookieDD
//
//  Created by BLINDED AM ME on 4/20/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDHowtoPopup : UIView

@property (weak, nonatomic) IBOutlet SGStrokeLabel* nextbuttonText;
@property (weak, nonatomic) IBOutlet SGStrokeLabel* backbuttonText;
@property (weak, nonatomic) IBOutlet UIButton* nextbutton;
@property (weak, nonatomic) IBOutlet UIButton* backbutton;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* SuperText;
@property (weak, nonatomic) IBOutlet UIView* supersView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* wrapText;
@property (weak, nonatomic) IBOutlet UIView* wrappersView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* ingredientText;
@property (weak, nonatomic) IBOutlet UIView* ingredientsView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* glassText;
@property (weak, nonatomic) IBOutlet UIView* glasscasesView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* icecreamText;
@property (weak, nonatomic) IBOutlet UIView* icreamView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* lightningText;
@property (weak, nonatomic) IBOutlet UIView* lightningView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* nukeText;
@property (weak, nonatomic) IBOutlet UIView* theNukeView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* smorerText;
@property (weak, nonatomic) IBOutlet UIView* smoresView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* spatulaText;
@property (weak, nonatomic) IBOutlet UIView* spatulaView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* powerText;
@property (weak, nonatomic) IBOutlet UIView* powerPunchView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* slotText;
@property (weak, nonatomic) IBOutlet UIView* slotMachineView;

@property (weak, nonatomic) IBOutlet SGStrokeLabel* sprinkleText;
@property (weak, nonatomic) IBOutlet UIView* sprinklesView;

@property (assign, nonatomic) int currentFrame;
@property (assign, nonatomic) int lastFrame;
@property (strong, nonatomic) NSArray* basicFrames;


-(IBAction)Next:(id)sender;
-(IBAction)Back:(id)sender;

-(void)setup:(NSString*)piece;


@end
