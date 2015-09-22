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
    
    NSLog(@"setNavigationTitle ==%@",[delegate.mallData objectForKey:@"name"]);
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];

    [super viewDidLoad];
    
    NSString *urlString = [delegate.mallData objectForKey:@"website_url"];
    NSLog(@"urlsrtrrttr %@",urlString);
    
    //    urlString = [[urlString componentsSeparatedByString:@"."] objectAtIndex:0];
    
    webViewURLString = [NSString stringWithFormat:@"%@%@",urlString,DEAL_WEB_VIEW];
//    webViewURLString = urlString;
    NSLog(@"urlsrtrrttr %@",webViewURLString);
    
    
    //    NSString *mapUrl = [NSString stringWithFormat:@"%@/sales",[delegate.mallData objectForKey:@"website_url"]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webViewURLString]]];
    
    //    webView.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
