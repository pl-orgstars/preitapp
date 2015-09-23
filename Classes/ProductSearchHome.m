//
//  ProductSearchHome.m
//  Preit
//
//  Created by sameer on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductSearchHome.h"
#import "ProductListViewController.h"
#import "PreitAppDelegate.h"
#import "UIAlertView+Blocks.h"
#import "LocationViewController.h"

@implementation ProductSearchHome{
    NSString *webViewURLString;
    PreitAppDelegate *del;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    
    del = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *urlString = [del.mallData objectForKey:@"website_url"];
   NSLog(@"urlsrtrrttrWaseem  %@",urlString);
    

    urlString = [NSString stringWithFormat:@"%@%@",urlString,HOME_WEB_VIEW];
    NSLog(@"urlsrtrrttrviewWillAppear %@",urlString);
    webViewURLString = urlString;
    mobileWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, isIPhone5?66:65, 320, isIPhone5?534:417)];
    [mobileWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    mobileWebView.delegate = self;
//    [self.view addSubview:mobileWebView];
    [self.view insertSubview:mobileWebView belowSubview:spinner];
    
    [webViewBackButton setEnabled:YES];
    
    titleLabel.text = (NSString*)[del.mallData objectForKey:@"name"];
    titleLabel2.text = (NSString*)[del.mallData objectForKey:@"name"];
    NSLog(@"titleLabel1 ==%@",[del.mallData objectForKey:@"name"]);
    NSLog(@"titleLabel2 ==%@",[del.mallData objectForKey:@"name"]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSideMenu" object:nil];

    
    findLabel.text = [NSString stringWithFormat:@"Find what you are looking for at %@ from participating retailers",[del.mallData objectForKey:@"name"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [webview setDelegate:self];
}

 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)ShowMenu:(id)sender
{
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
//    [del ShowMenuViewOnTop];
}
-(IBAction)useProduct:(id)sender {

    
    NSLog(@"use product");
    PreitAppDelegate *del = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"delegate :: %@ %@",del,del.productSearchViewControllerDelegate);
    
    [del.productSearchViewControllerDelegate performSelectorOnMainThread:@selector(searchAction:) withObject:nil waitUntilDone:YES];

}

-(IBAction)moreInfo:(id)sender {
    PreitAppDelegate *del = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"del %@",del.mallData);
    NSString *website_url = [del.mallData objectForKey:@"website_url"];
    NSString *removeSlash = [[website_url componentsSeparatedByString:@"//"] objectAtIndex:1];
    NSString *pName = [[removeSlash componentsSeparatedByString:@"."] objectAtIndex:0];
    [moreInfoView setHidden:NO];

    
    NSString *urlString = @"http://cherryhillmall.com/product_search/mobileinfo?mobile=yes";
    NSLog(@"urlstring %@",urlString);
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

-(IBAction)hideMoreInfo:(id)sender {
    backFlag = YES;
    [moreInfoView setHidden:YES];
    [spinner stopAnimating];
    [webview stopLoading];
}
-(void)showALertWithRequest:(NSURLRequest *)urlRequest{
    
    [spinner stopAnimating];
    [UIAlertView showWithTitle:NSLocalizedString(@"WebView_title",@"") message:NSLocalizedString(@"WebView_message",@"") cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Open"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
         [[UIApplication sharedApplication]openURL:[urlRequest URL]];
        }
        
    }];
}
#pragma mark webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"request::::::::::: Waseem %@ %@",[request URL],[[request URL]absoluteString]);
    
    PreitAppDelegate *del = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *urlString = [del.mallData objectForKey:@"website_url"];
    
    if ([[[request URL]absoluteString]rangeOfString:urlString].location != NSNotFound) {
        return YES;
    }
    if ([Utils checkForEmptyString:[[request URL]absoluteString]]) {
        return NO;
    }
    [self showALertWithRequest:request];
    return NO;
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    if (!spinner.isAnimating) {
        [spinner startAnimating];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [spinner stopAnimating];

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [spinner stopAnimating];
}
-(IBAction)webViewBackButtonTapped:(id)sender{
    NSLog(@"yes");
    
    if(mobileWebView.canGoBack == YES)
    {
         [mobileWebView goBack];

        
    }else{
        LocationViewController *loaction = [[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
        loaction.shouldReload = YES;
        [self.navigationController pushViewController:loaction animated:YES];
        
//        PreitAppDelegate *appdelegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
//        appdelegate.isOnForeGround = YES;
//        [appdelegate.window addSubview:appdelegate.navController.view];
//        [appdelegate.tabBarController.view removeFromSuperview];    //Waseem Menu
//        
//        [appdelegate disableBeacon];
        
#warning handle navigation here
    }
}
@end
