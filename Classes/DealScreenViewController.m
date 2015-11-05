//
//  DealScreenViewController.m
//  Preit
//
//  Created by kuldeep on 5/29/14.
//
//

#import "DealScreenViewController.h"
#import "PreitAppDelegate.h"
@interface DealScreenViewController ()

@end

@implementation DealScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    PreitAppDelegate *delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *titleLabel = (NSString*)[delegate.mallData objectForKey:@"name"];
    [self setNavigationTitle:titleLabel withBackButton:YES];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];

    [super viewDidLoad];
    
    NSString *urlString = [delegate.mallData objectForKey:@"website_url"];
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@".com" withString:SUB_DOMAIN];
    NSLog(@"urlsrtrrttr %@",urlString);
    
    
    webViewURLString = [NSString stringWithFormat:@"%@%@",urlString,DEAL_WEB_VIEW];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webViewURLString]]];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Web View Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    PreitAppDelegate *delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];

    NSString *urlString = [delegate.mallData objectForKey:@"website_url"];
    urlString = [urlString stringByAppendingString:@"/sales"];
    
    if ([[[request URL]absoluteString]rangeOfString:urlString].location != NSNotFound) {
        
        spotCount = 0;
        return YES;
    }
    
    // maha chaipi start
    
    if ([[[request URL]absoluteString]rangeOfString:@"spotzot"].location != NSNotFound) {
        spotCount++;
        
        if (spotCount>1) {
            return NO;
        }
        
        return YES;
    }
    
    // maha chaipi ends
   
    
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
