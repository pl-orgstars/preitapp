//
//  EmailListViewController.h
//  Preit
//
//  Created by sameer on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "PreitAppDelegate.h"
@interface EmailListViewController : BaseViewController <UIWebViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIWebView *webview;
    IBOutlet UIActivityIndicatorView *spinner;
    PreitAppDelegate *delegate;
    
    IBOutlet UITextField *name;
    IBOutlet UITextField *emailAddress;
//    IBOutlet UITextField *cellPhoneNo;
    
    BOOL isSubscribe;
    BOOL isUpdate;
    UIAlertView *alertView;
    UISegmentedControl *tabNavigation;
    IBOutlet UIScrollView *scrollView;
}

-(IBAction)subscribeBttnTapped:(id)sender;
-(IBAction)updateBttnTapped:(id)sender;
-(IBAction)sendListBttnTaped:(id)sender;

@property (retain,nonatomic) NSArray *productsArray;

@end
