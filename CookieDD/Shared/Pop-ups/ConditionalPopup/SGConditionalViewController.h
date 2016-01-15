//
//  SGConditionalViewController.h
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

#import <UIKit/UIKit.h>

typedef enum ConditionalType
{
    ConditionalType_Default,
    ConditionalType_NoInternetAccess,
    ConditionalType_InsufficentFunds,
    ConditionalType_Error
}   ConditionalType;

typedef enum PresentationType {
    
    PresentationType_Default,
    PresentationType_Error,
    PresentationType_Loading
    
} PresentationType;


typedef void (^AnimateOutErrorPopUpCompletionHandler)(BOOL didFinish);

typedef void (^AnimateInErrorPopUpCompletionHandler)(BOOL didFinish);


@protocol SGConditionalViewControllerDelegate;

@interface SGConditionalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *errorContainerView;

@property (weak, nonatomic) IBOutlet UIView *fadedBackGroundView;

@property (weak, nonatomic) IBOutlet UIView *errorPopUp;

@property (weak, nonatomic) IBOutlet UIView *loadingPopup;

@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;

@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@property (weak, nonatomic) IBOutlet UIImageView *cookieImageView;

@property (weak, nonatomic) id <SGConditionalViewControllerDelegate> delegate;

@property (assign, nonatomic) ConditionalType conditionalType;

@property (assign, nonatomic) PresentationType presentationType;

@property (weak, nonatomic) IBOutlet UIButton *requestButton;

@property (strong, nonatomic) NSString *errorDescription;

@property (strong, nonatomic) NSString *loadingText;

- (void)animateInErrorPopUpWithCompletionHandler:(AnimateOutErrorPopUpCompletionHandler)handler;

- (void)animateOutErrorPopUpWithCompletionHandler:(AnimateInErrorPopUpCompletionHandler)handler;

- (IBAction)acceptRequest:(id)sender;

- (IBAction)denyRequest:(id)sender;

@end

@protocol SGConditionalViewControllerDelegate <NSObject>

@optional
- (void)conditionalViewControllerDidAccept:(SGConditionalViewController *)controller;
- (void)conditionalViewControllerDidDeny:(SGConditionalViewController *)controller;
@end


@interface UIImage (CDDAdditions)
- (UIImage *)scaleToSize:(CGSize)size;
@end
