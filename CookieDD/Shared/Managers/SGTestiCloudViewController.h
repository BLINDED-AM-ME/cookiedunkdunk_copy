//
//  SGTestiCloudViewController.h
//  CookieDD
//
//  Created by Luke McDonald on 2/27/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGTestiCloudViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) LMICloudDocument *document;
@end
