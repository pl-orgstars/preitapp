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
@interface ContactUsViewController : BaseViewController <MFMailComposeViewControllerDelegate> {
//	IBOutlet UIImageView *imageView;
//	IBOutlet UILabel *label_City;
//	IBOutlet UILabel *label_State;
//	IBOutlet UILabel *label_Street;
//	IBOutlet UILabel *label_Suite;
//	IBOutlet UILabel *label_Zipcode;
//	IBOutlet UIButton *button_Phone;
//	IBOutlet UIButton *button_Email;
	IBOutlet UITableView *tableContact;
	NSMutableArray *tableData;
	PreitAppDelegate *delegate;
	IBOutlet UIActivityIndicatorView *indicator_;
    
    __weak IBOutlet UILabel *navigationLabel;

    
    
    
    
}

-(IBAction)backButtonTapped:(id)sender;
-(void) actionPhone:(NSString *)phone;
-(void) actionEmail:(NSString *)email;
-(void)setHeader;
-(void)getData;
-(void)sendDetailOnMail:(NSString *)email;
@end
