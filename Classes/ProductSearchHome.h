//
//  ProductSearchHome.h
//  Preit
//
//  Created by sameer on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesView.h"

@interface ProductSearchHome : SuperViewController <UIWebViewDelegate>

{
    IBOutlet UILabel *findLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *titleLabel2;
    IBOutlet UIView *moreInfoView;
    IBOutlet UIWebView *webview;
    IBOutlet UIActivityIndicatorView *spinner;
    BOOL backFlag;
    
    IBOutlet UIWebView *mobilepromoWebView;
    
    IBOutlet UIButton *webViewBackButton;
    UIWebView *mobileWebView;
    
    MessagesView *messagesView;
}

-(IBAction)webViewBackButtonTapped:(id)sender;
-(IBAction)hideMoreInfo:(id)sender;
//@property BOOL isGiftViewPush;

@end
