//
// Created by sbeyers on 3/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
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


#import "SharingActivityProvider.h"


@implementation SharingActivityProvider {

}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    // Log out the activity type that we are sharing with
    DebugLog(@"%@", activityType);

    // Create the default sharing string
//    self.shareString = @"Seven Gun Games is a great place to work!";

    // customize the sharing string for facebook, twitter, weibo, and google+
    if ([activityType isEqualToString:UIActivityTypePostToFacebook])
    {
        self.shareMessage = [NSString stringWithFormat:@"Attention Facebook: %@", self.shareMessage];
    }
    else if ([activityType isEqualToString:UIActivityTypePostToTwitter])
    {
        self.shareMessage = [NSString stringWithFormat:@"Attention Twitter: %@", self.shareMessage];
    }
    else if ([activityType isEqualToString:UIActivityTypePostToWeibo])
    {
        self.shareMessage = [NSString stringWithFormat:@"Attention Weibo: %@", self.shareMessage];
    }
    else if ([activityType isEqualToString:@"com.sevengungames.cookiedunkdunk"])
    {
        self.shareMessage = [NSString stringWithFormat:@"Attention Google+: %@", self.shareMessage];
    }

    return self.shareMessage;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}

@end