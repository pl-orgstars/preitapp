//
//  ContactUsViewController.h
//  Preit
//
//  Created by Aniket on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PreitAppDelegate.h"
#import "BaseViewController.h"

#import "MFSideMenu.h"

@interface ContactUsViewController : BaseViewController <MFMailComposeViewControllerDelegate> {
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *streelLabel;
    IBOutlet UILabel *state_zipLabel;
    
    IBOutlet UILabel *phoneLabel;
    IBOutlet UILabel *emailLabel;
    
	PreitAppDelegate *delegate;
	IBOutlet UIActivityIndicatorView *indicator_;
}

@end
