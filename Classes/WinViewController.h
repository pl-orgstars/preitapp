//
//  WinViewController.h
//  Preit
//
//  Created by Noman iqbal on 10/1/15.
//
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"
#import "ScanReceiptViewController.h"
#import "MyCLController.h"

@interface WinViewController : UIViewController <UIWebViewDelegate,MyCLControllerDelegate>
{
    IBOutlet UIWebView* winWebView;
    
    PreitAppDelegate* delegate;
    MyCLController *locationController;
}

@end
