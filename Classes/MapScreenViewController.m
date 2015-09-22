//
//  MapScreenViewController.m
//  Preit
//
//  Created by kuldeep on 5/29/14.
//
//

#import "MapScreenViewController.h"
#import "ProductListViewController.h"
#import "MapScreenViewController.h"
#import "JSBridgeViewController.h"
#import "PreitAppDelegate.h"
@interface MapScreenViewController ()

@end

@implementation MapScreenViewController

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
    NSLog(@"titleLabeltitleLabel ==%@",[delegate.mallData objectForKey:@"name"]);


    [super viewDidLoad];
    
//    webView.delegate = self;
    NSString *mapUrl = [NSString stringWithFormat:@"%@/directory",[delegate.mallData objectForKey:@"website_url"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:mapUrl]];
//    [request setValue:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3" forHTTPHeaderField:@"User-Agent"];
    
    [webView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttn:(id)sender{
    
    PreitAppDelegate *delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
    JSBridgeViewController *screenMap=[[JSBridgeViewController alloc]initWithNibName:@"JSBridgeViewController" bundle:nil];
    //screenMap.mapUrl=[NSString stringWithFormat:@"%@/areas/%d/show_map?suit_id=%d",[delegate.mallData objectForKey:@"resource_url"],[[dictData objectForKey:@"suite_id"] intValue],[[dictData objectForKey:@"suite_id"] intValue]];
    NSLog(@"mmmmmm ::: %@",delegate.mallData);
    
    
    screenMap.mapUrl= @"http://cherryhillmall.com/directory";
//    [NSString stringWithFormat:@"%@/areas/getarea?suit_id=%d",[delegate.mallData objectForKey:@"resource_url"],[[[[delegate.mallData objectForKey:@"webaddresses"]objectAtIndex:0]objectForKey:@"id"]intValue]];
    [self.navigationController pushViewController:screenMap animated:YES];
    
}
@end
