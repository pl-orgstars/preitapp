//
//  CustomWebViewController.m
//  Preit
//
//  Created by kuldeep on 6/4/14.
//
//

#import "CustomWebViewController.h"
#import "UIAlertView+Blocks.h"
#import "PreitAppDelegate.h"
@interface CustomWebViewController ()

@end

@implementation CustomWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    nibNameOrNil = @"CustomWebViewController";
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    

    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    spinner.center = self.view.center;
    webView.delegate = self;
    [self setNAvigationRightBttnEnable:NO];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showALertWithRequest:(NSURLRequest *)urlRequest{
    
    [spinner stopAnimating];
    [UIAlertView showWithTitle:NSLocalizedString(@"WebView_title",@"") message:NSLocalizedString(@"WebView_message",@"") cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Open"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[urlRequest URL]];
        }
        
    }];
}

#pragma mark - Button Actions

- (IBAction)backBtnCall:(id)sender {
    if (webView.canGoBack)
        [webView goBack];
    else
        [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
}

#pragma mark webview delegate
- (BOOL)webView:(UIWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    PreitAppDelegate *delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *urlString = [delegate.mallData objectForKey:@"website_url"];
    if ([[[request URL]absoluteString]rangeOfString:urlString].location != NSNotFound) {
        return YES;
    }
    [self showALertWithRequest:request];
    return NO;
}
-(void)webViewDidStartLoad:(UIWebView *)webview {
    if (!spinner.isAnimating) {
        [spinner startAnimating];
    }
    [self setNAvigationRightBttnEnable:webView.canGoBack];

}

-(void)webViewDidFinishLoad:(UIWebView *)webview {
    [spinner stopAnimating];
    [self setNAvigationRightBttnEnable:webView.canGoBack];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [spinner stopAnimating];
}

-(void)setNAvigationRightBttnEnable:(BOOL)enable{
    
    if (enable) {
        [self setNavigationLeftBackButton];
    }else{
        [self.navigationItem setLeftBarButtonItem:nil];
    }
    
}
-(void)navigationbackButtonTapped:(id)sender{
    NSLog(@"yes");
    [webView goBack];
    
    [self setNAvigationRightBttnEnable:webView.canGoBack];
}
-(IBAction)webViewBackButtonTapped:(id)sender{
    NSLog(@"yes");
    [webView goBack];
    
    [self setNAvigationRightBttnEnable:webView.canGoBack];

}

@end
