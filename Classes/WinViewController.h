//
//  WinViewController.h
//  Preit
//
//  Created by Noman iqbal on 10/1/15.
//
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"

@interface WinViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView* winWebView;
    
    PreitAppDelegate* delegate;
}

@end
