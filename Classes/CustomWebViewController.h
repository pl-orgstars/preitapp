//
//  CustomWebViewController.h
//  Preit
//
//  Created by kuldeep on 6/4/14.
//
//

#import <UIKit/UIKit.h>

@interface CustomWebViewController : BaseViewController<UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *webView;
    __weak IBOutlet UIActivityIndicatorView *spinner;
    
    NSString *webViewURLString;
}
-(void)setNAvigationRightBttnEnable:(BOOL)enable;
@end
