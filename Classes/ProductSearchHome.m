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
#import "Flurry.h"

#import "DirectoryViewController.h"
#import "DiningViewController.h"
#import "DirectionViewController.h"
#import "WebViewController.h"
#import "EventsViewController.h"
#import "DealScreenViewController.h"
#import "ProductListViewController.h"
#import "WinViewController.h"


#define VOTIGO_SIGNUP @"http://sqa02demopartner.votigo.com/fbsweeps/sweeps/testsweepsforred5-1"

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
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@".com" withString:SUB_DOMAIN];
    
//    NSString *mallName = [[del.mallData objectForKey:@"name"] lowercaseString];
//    mallName = [mallName stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString *urlString = [NSString stringWithFormat:@"http://%@.red5demo.com/mobilepromo?mobile=yes", mallName];
    
    urlString = [NSString stringWithFormat:@"%@%@",urlString,HOME_WEB_VIEW];
    
    NSLog(@"urlsrtrrttrviewWillAppear %@",urlString);
    webViewURLString = urlString;
    mobileWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, isIPhone5?66:65, 320, isIPhone5?534:417)];
    [mobileWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    mobileWebView.delegate = self;
    [self.view insertSubview:mobileWebView belowSubview:spinner];
    
    [webViewBackButton setEnabled:YES];
    
    titleLabel.text = (NSString*)[del.mallData objectForKey:@"name"];
    titleLabel2.text = (NSString*)[del.mallData objectForKey:@"name"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSideMenu" object:nil];
    findLabel.text = [NSString stringWithFormat:@"Find what you are looking for at %@ from participating retailers",[del.mallData objectForKey:@"name"]];
    
    [self showMessagesView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [webview setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLocationView) name:@"ShowLocationView" object:nil];
}

- (void)showMessagesView {
    if (!messagesView)
        messagesView = [[NSBundle mainBundle] loadNibNamed:@"MessagesView" owner:self options:nil][0];
    [messagesView showInView:self.view];
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

- (void)showLocationView {
    LocationViewController *loaction = [[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
    loaction.shouldReload = YES;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:loaction animated:NO];
}



#pragma mark webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"request::::::::::: Waseem %@ %@",[request URL],[[request URL]absoluteString]);
    
    
//    PreitAppDelegate *del = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *urlString = del.mallData[@"website_url"];//@".red5demo.com";
    urlString = [urlString stringByReplacingOccurrencesOfString:@".com" withString:SUB_DOMAIN];

    
    if ([[[request URL]absoluteString]rangeOfString:urlString].location != NSNotFound) {
        
        NSString* url = [[request URL]absoluteString];
        
        NSRange range = [url rangeOfString:@".com"];
        
        NSString* page = [url substringWithRange:NSMakeRange(range.location + range.length , url.length - range.length - range.location)];
        
        if ([page isEqualToString:HOME_WEB_VIEW]) {
            return YES;
        }
        else if ([page isEqualToString:@"/directory"]) {
            DirectoryViewController* directoryVC = [[DirectoryViewController alloc] initWithNibName:@"DirectoryViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:directoryVC animated:NO];
            return NO;
        }
        else if ([page isEqualToString:@"/directory/dining"]){
            DiningViewController *viewCnt = [[DiningViewController alloc]initWithNibName:@"CustomTable" bundle:nil];
            
            
            [self.navigationController pushViewController:viewCnt animated:NO];
            return NO;
        }
        else if ([page isEqualToString:@"/about_us/directions"]){
            DirectionViewController *directionVC=[[DirectionViewController alloc]initWithNibName:@"DirectionViewController" bundle:nil];
            [self.navigationController pushViewController:directionVC animated:NO];
            return NO;
            
        }
        else if ([page isEqualToString:@"/mall_hours"]){
            WebViewController *hoursWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
            hoursWebView.screenIndex=8;
            hoursWebView.isHours = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                hoursWebView.titleLabel.text = @"HOURS";
            });
            
            [self.navigationController pushViewController:hoursWebView animated:NO];
            return NO;
            
        }
        
        else if ([page isEqualToString:@"/events"]){
            EventsViewController *viewCnt = [[EventsViewController alloc]initWithNibName:@"EventsViewController" bundle:nil];
            
            [self.navigationController pushViewController:viewCnt animated:NO];
            
            return NO;
            
        }
        
        else if ([page isEqualToString:@"/sales"]){
            DealScreenViewController* dealsVC = [[DealScreenViewController alloc] initWithNibName:@"DealScreenViewController" bundle:[NSBundle mainBundle]];
            
            [self.navigationController pushViewController:dealsVC animated:NO];
            
            return NO;
        }
        
        else if ([page isEqualToString:@"/product_search"]){
            ProductListViewController *productListViewController = [[ProductListViewController alloc]initWithNibName:@"ProductListViewController copy" bundle:nil];
            
            [self.navigationController pushViewController:productListViewController animated:NO];
            return NO;
            
        }
        
        else if ([page rangeOfString:@"/product_search"].location != NSNotFound){
            
            
            NSRange range = [page rangeOfString:@"search="];
            NSString* searchString = [page substringWithRange:NSMakeRange(range.location + range.length, page.length - range.location - range.length)];
            
            ProductListViewController *productListViewController = [[ProductListViewController alloc]initWithNibName:@"ProductListViewController copy" bundle:nil];
            
            if (![searchString isEqualToString:@""]) {
                productListViewController.passedSearchString = searchString;
                
            }
            
            [self.navigationController pushViewController:productListViewController animated:NO];
            return NO;
            
        }
        
        return YES;
    }
    
    else if ([[[request URL] absoluteString] rangeOfString:VOTIGO_SIGNUP].location != NSNotFound){
        
        // flurry event here
        NSString *strEvent = [NSString stringWithFormat:@"%@ win.",[del.mallData objectForKey:@"name"]];

        [Flurry logEvent:strEvent timed:YES];
        WinViewController* winVC = [[WinViewController alloc] initWithNibName:@"WinViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:winVC animated:NO];
        
        return NO;
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
        [self showLocationView];
        
        PreitAppDelegate *appdelegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.isOnForeGround = YES;
        [appdelegate disableBeacon];
        
//        [appdelegate.window addSubview:appdelegate.navController.view];
//        [appdelegate.tabBarController.view removeFromSuperview];    //Waseem Menu
//        
        
#warning handle navigation here
    }
}
@end
