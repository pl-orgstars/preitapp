//
//  WinViewController.m
//  Preit
//
//  Created by Noman iqbal on 10/1/15.
//
//

#import "WinViewController.h"


#define VOTIGO_SIGNUP @"http://sqa02demopartner.votigo.com/fbsweeps/sweeps/testsweepsforred5-1"
#define VOTIGO_CONFIRM @"http://sqa02demopartner.votigo.com/fbsweeps/confirmation/testsweepsforred5-1"
#define VOTIGO_MAIN @"http://sqa02demopartner.votigo.com/fbsweeps/pages/testsweepsforred5-1/mainmenu"
#define VOTIGO_SCAN_RECEIPT @"http://sqa02demopartner.votigo.com/fbsweeps/pages/testsweepsforred5-1/scanreceipt"
#define NOT_CHECKED_IN      @"http://staging.cherryhillmall.red5demo.com/promos/enter_to_win/not_in_mall?mobile=yes"

@interface WinViewController ()

@end

@implementation WinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate = (PreitAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString* votigoUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
    
    NSString* url;
    
    if (votigoUserID) {
        url = [NSString stringWithFormat:@"%@",VOTIGO_MAIN];
    }
    else{
        url = [NSString stringWithFormat:@"%@?mall_id=%@",VOTIGO_SIGNUP,[delegate.mallData objectForKey:@"id"]];
    }
    
    
    
    
    NSURLRequest* winRequest = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [winWebView loadRequest:winRequest];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - web view delgates

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
  
    
    NSString* url = [[request URL]absoluteString];
    
    if ([url rangeOfString:VOTIGO_SIGNUP].location != NSNotFound ) {
        return YES;
    }
    
    else if ([url rangeOfString:VOTIGO_CONFIRM].location != NSNotFound)
    {
        NSRange range = [url rangeOfString:VOTIGO_CONFIRM];
        NSString* page = [url substringWithRange:NSMakeRange(range.location + range.length, url.length - range.length - range.location)];
        
        NSString* returnedUserID = [[page componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        [[NSUserDefaults standardUserDefaults] setObject:returnedUserID forKey:@"votigoUserID"];
        
        return YES;
    }
    
    else if ([url rangeOfString:VOTIGO_SCAN_RECEIPT].location != NSNotFound){
        
        ScanReceiptViewController* scanReceiptVC = [[ScanReceiptViewController alloc] initWithNibName:@"ScanReceiptViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:scanReceiptVC animated:NO];
        
        return NO;
    }
    
    
    else if ([url rangeOfString:VOTIGO_MAIN].location != NSNotFound){
        return YES;
    }
    
    else if ([url rangeOfString:NOT_CHECKED_IN].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}


#pragma mark - Navigation

- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
}

- (IBAction)testButtonAction:(id)sender {
    double destinationLat = [delegate.mallData[@"location_lat"] doubleValue];
    double destinationLong = [delegate.mallData[@"location_lng"] doubleValue];
    
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:destinationLat longitude:destinationLong];
    CLLocation *current = [[CLLocation alloc] initWithLatitude:delegate.latitude longitude:delegate.longitude];
    
    CLLocationDistance distance = [current distanceFromLocation:destination];
    if (distance >= 1609) { //1609 meters = 1 mile
        NSURL *url = [NSURL URLWithString:NOT_CHECKED_IN];
        [winWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://smbaqa02code.votigo.com/api/signature.json?apiKey=fb86e75edb447a2b66e5db3471a26ddb" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *params = @{@"sweepuserentry_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"],
                                     @"sweep_id" : @"7239",
                                     @"mall_id" : delegate.mallData[@"id"],
                                     @"signature" : responseObject[@"signature"],
                                     @"action_type" : @"checkin"
                                     };
            [manager GET:@"http://smbaqa02code.votigo.com/sweeps/awardSweepentryCredits.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Params = %@", responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error = %@", error);
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error = %@", error);
        }];
    }
}

@end
