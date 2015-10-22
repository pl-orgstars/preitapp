//
//  WinViewController.m
//  Preit
//
//  Created by Noman iqbal on 10/1/15.
//
//

#import "WinViewController.h"
#import "LoadingAgent.h"

#define VOTIGO_SIGNUP @"http://sqa02demopartner.votigo.com/fbsweeps/sweeps/testsweepsforred5-1"
#define VOTIGO_CONFIRM @"http://sqa02demopartner.votigo.com/fbsweeps/confirmation/testsweepsforred5-1"
#define VOTIGO_MAIN @"http://sqa02demopartner.votigo.com/fbsweeps/pages/testsweepsforred5-1/mainmenu"
#define VOTIGO_SCAN_RECEIPT @"http://sqa02demopartner.votigo.com/fbsweeps/pages/testsweepsforred5-1/scanreceipt"

#define NOT_CHECKED_IN      @"http://cherryhillmall.red5demo.com/promos/enter_to_win/not_in_mall?mobile=yes"
#define ALREADY_CHECKED_IN  @"http://cherryhillmall.red5demo.com/promos/enter_to_win/already_checked_in?mobile=yes"
#define CHECKED_IN          @"http://cherryhillmall.red5demo.com/promos/enter_to_win/successful?mobile=yes"
#define NOT_PERMITTED       @"http://cherryhillmall.red5demo.com/promos/enter_to_win/no_permissions?mobile=yes"
#define NOT_IN_MALL         @"http://cherryhillmall.red5demo.com/promos/enter_to_win/not_in_mall?mobile=yes"
#define MAIN_MENU           @"http://cherryhillmall.red5demo.com/main_menu"

@interface WinViewController ()

@end

@implementation WinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate = (PreitAppDelegate*)[UIApplication sharedApplication].delegate;
    NSString* votigoUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
    NSString* url;
//    [[LoadingAgent defaultAgent] makeBusy:YES];
    
    if (votigoUserID) {
        url = [NSString stringWithFormat:@"%@?mall_id=%@&sweepuserentry_id=%@", VOTIGO_MAIN, [delegate.mallData objectForKey:@"id"], votigoUserID];
    }
    else{
        url = [NSString stringWithFormat:@"%@?mall_id=%@", VOTIGO_SIGNUP, [delegate.mallData objectForKey:@"id"]];
    }
    
    NSURLRequest* winRequest = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [winWebView loadRequest:winRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [winWebView stopLoading];
}



#pragma mark - web view delgates


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[LoadingAgent defaultAgent] makeBusy:NO];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[LoadingAgent defaultAgent] makeBusy:NO];

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[LoadingAgent defaultAgent] makeBusy:YES];

}
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
    
    else if ([url rangeOfString:@"/checkin"].location != NSNotFound) {
        [self chekinMallAction];
    }
    
    else if ([url rangeOfString:VOTIGO_MAIN].location != NSNotFound){
        return YES;
    }
    
    else if ([url rangeOfString:NOT_CHECKED_IN].location != NSNotFound) {
        return YES;
    }
    else if ([url rangeOfString:ALREADY_CHECKED_IN].location != NSNotFound) {
        return YES;
    }
    else if ([url rangeOfString:CHECKED_IN].location != NSNotFound) {
        return YES;
    }
    else if ([url rangeOfString:MAIN_MENU].location != NSNotFound) {
        NSString* votigoUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
        NSString* url = [NSString stringWithFormat:@"%@?mall_id=%@&sweepuserentry_id=%@", VOTIGO_MAIN, [delegate.mallData objectForKey:@"id"], votigoUserID];
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    
    return NO;
}


#pragma mark - Navigation

- (IBAction)backBtnCall:(id)sender {
    if ([winWebView canGoBack])
        [winWebView goBack];
    else
        [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
}

- (void)chekinMallAction {
    double destinationLat = [delegate.mallData[@"location_lat"] doubleValue];
    double destinationLong = [delegate.mallData[@"location_lng"] doubleValue];
    
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:destinationLat longitude:destinationLong];
    CLLocation *current = [[CLLocation alloc] initWithLatitude:delegate.latitude longitude:delegate.longitude];
    
    CLLocationDistance distance = [current distanceFromLocation:destination];
    if (distance <= 1609) { //1609 meters = 1 mile
        NSURL *url = [NSURL URLWithString:NOT_CHECKED_IN];
        [winWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://smbaqa02code.votigo.com/api/signature.json?apiKey=fb86e75edb447a2b66e5db3471a26ddb" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response = %@", responseObject);
            
            NSDictionary *params = @{@"sweepuserentry_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"],
                                     @"sweep_id" : @"7239",
                                     @"mall_id" : delegate.mallData[@"id"],
                                     @"signature" : responseObject[@"signature"],
                                     @"action_type" : @"checkin"
                                     };
            [manager GET:@"http://smbaqa02code.votigo.com/sweeps/awardSweepentryCredits.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Response = %@", responseObject);
                
                if ([responseObject[@"status"] integerValue] == 1) {
                    NSURL *url = [NSURL URLWithString:CHECKED_IN];
                    [winWebView loadRequest:[NSURLRequest requestWithURL:url]];
                }
                else
                    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
                        NSURL *url = [NSURL URLWithString:NOT_PERMITTED];
                        [winWebView loadRequest:[NSURLRequest requestWithURL:url]];
                    }
                    else if ([responseObject[@"message"] isEqualToString:@"Checkin limit reached for today."]) {
                        NSURL *url = [NSURL URLWithString:ALREADY_CHECKED_IN];
                        [winWebView loadRequest:[NSURLRequest requestWithURL:url]];
                    }
                    else {
                        NSURL *url = [NSURL URLWithString:NOT_IN_MALL];
                        [winWebView loadRequest:[NSURLRequest requestWithURL:url]];
                    }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error = %@", error);
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error = %@", error);
        }];
    }
}

@end
