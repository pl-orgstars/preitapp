//
//  _EventsDetailsViewController.h
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"

@interface EventsDetailsViewController : BaseViewController <UIWebViewDelegate>
{
    IBOutlet UILabel *headerLabel;
	IBOutlet UIImageView *image_Background;
	IBOutlet UIImageView *image_thumbNail;
	IBOutlet UILabel *labelName;
	IBOutlet UIWebView *webView;
	PreitAppDelegate *delegate;
	NSDictionary *dictData;
	BOOL flagScreen;
	IBOutlet UILabel *labelDateStart;
    IBOutlet UILabel *labelDateEnd;
    IBOutlet UILabel *labelMonthStart;
    IBOutlet UILabel *labelMonthEnd;
    
	NSString *dateString;
	NSURL *url_LinkClicked;
    
    IBOutlet UIWebView *titleWebView;
    
    IBOutlet UIScrollView *scrolviewMain;
}

@property (nonatomic,retain)NSDictionary *dictData;
@property (nonatomic)BOOL flagScreen;

-(IBAction)buttonAction:(id)sender;
@end
