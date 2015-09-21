//
//  PinterestWebViewController.h
//  Preit
//
//  Created by charan on 5/9/13.
//
//

#import <UIKit/UIKit.h>

@interface PinterestWebViewController : UIViewController <UIWebViewDelegate,UINavigationBarDelegate>
{
    IBOutlet UIWebView *webViewToShareWithPinterest;
    UIActivityIndicatorView *spinner;
    
    IBOutlet UIButton *pinterestbutton;
    
//    IBOutlet UITextView *textView;
}
@property (nonatomic , retain)NSString *imageUrl;
@property (nonatomic , retain)NSString *searchUrl;
@property (nonatomic , retain)NSString *description;
@end
