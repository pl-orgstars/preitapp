//
//  WinViewController.m
//  Preit
//
//  Created by Noman iqbal on 10/1/15.
//
//

#import "WinViewController.h"
#import "LoadingAgent.h"
//
//#define VOTIGO_SIGNUP @"http://sqa02demopartner.votigo.com/fbsweeps/sweeps/testsweepsforred5-1"
//#define VOTIGO_CONFIRM @"http://sqa02demopartner.votigo.com/fbsweeps/confirmation/testsweepsforred5-1"
//#define VOTIGO_MAIN             @"http://sqa02demopartner.votigo.com/fbsweeps/pages/testsweepsforred5-1/mainmenu"
//#define VOTIGO_SCAN_RECEIPT     @"http://sqa02demopartner.votigo.com/fbsweeps/pages/testsweepsforred5-1/scanreceipt"

#define VOTIGO_SIGNUP           @"http://bestgiftever.votigo.com/fbsweeps/sweeps/Best-Gift-Ever?mall_id="
#define VOTIGO_SIGNUP_2         @"http://bestgiftever.votigo.com/fbsweeps/sweeps/Best-Gift-Ever-Sweeps-2"
#define VOTIGO_RULES            @"http://bestgiftever.votigo.com/fbsweeps/pages/Best-Gift-Ever/rules"
#define VOTIGO_CONFIRM          @"http://bestgiftever.votigo.com/fbsweeps/confirmation/Best-Gift-Ever"
#define REFER_FRIEND            @"http://bestgiftever.votigo.com/fbsweeps/pages/Best-Gift-Ever/referafriend"
#define VOTIGO_MAIN             @"http://bestgiftever.votigo.com/fbsweeps/pages/Best-Gift-Ever/mainmenu"
#define VOTIGO_SCAN_RECEIPT     @"http://bestgiftever.votigo.com/fbsweeps/pages/Best-Gift-Ever/scanreceipt"
#define VOTIGO_CHECK_IN         @"http://bestgiftever.votigo.com/fbsweeps/pages/Best-Gift-Ever/checkin"


//#define NOT_CHECKED_IN      @"http://cherryhillmall.red5demo.com/promos/enter_to_win/not_in_mall?mobile=yes"
//#define ALREADY_CHECKED_IN  @"http://cherryhillmall.red5demo.com/promos/enter_to_win/already_checked_in?mobile=yes"
//#define CHECKED_IN          @"http://cherryhillmall.red5demo.com/promos/enter_to_win/successful?mobile=yes"
//#define NOT_PERMITTED       @"http://cherryhillmall.red5demo.com/promos/enter_to_win/no_permissions?mobile=yes"
//#define NOT_IN_MALL         @"http://cherryhillmall.red5demo.com/promos/enter_to_win/not_in_mall?mobile=yes"
//#define SET_LOCATION_ACCESS @"http://cherryhillmall.red5demo.com/promos/enter_to_win/set_location_access?mobile=yes"
//#define MAIN_MENU           @"http://cherryhillmall.red5demo.com/main_menu"

#define NOT_CHECKED_IN      @"http://cherryhillmall.com/promos/enter_to_win/not_in_mall?mobile=yes"
#define ALREADY_CHECKED_IN  @"http://cherryhillmall.com/promos/enter_to_win/already_checked_in?mobile=yes"
#define CHECKED_IN          @"http://cherryhillmall.com/promos/enter_to_win/successful?mobile=yes"
#define NOT_PERMITTED       @"http://cherryhillmall.com/promos/enter_to_win/no_permissions?mobile=yes"
#define NOT_IN_MALL         @"http://cherryhillmall.com/promos/enter_to_win/not_in_mall?mobile=yes"
#define SET_LOCATION_ACCESS @"http://cherryhillmall.com/promos/enter_to_win/set_location_access?mobile=yes"
#define MAIN_MENU           @"http://cherryhillmall.com/main_menu"
//#define PRIZE               @"http://sqa02demopartner.votigo.com/fbsweeps/pages/testsweepsforred5-1/prizes"
//#define Rules               @"http://sqa02demopartner.votigo.com/fbsweeps/pages/testsweepsforred5-1/rules"
//#define REFER_FRIEND        @"http://sqa02demopartner.votigo.com/fbsweeps/pages/testsweepsforred5-1/referafriend"


@interface WinViewController ()

@end

@implementation WinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate = (PreitAppDelegate*)[UIApplication sharedApplication].delegate;
    votigoUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
    NSString* url;
//    [[LoadingAgent defaultAgent] makeBusy:YES];
    
    if (votigoUserID) {
        url = [NSString stringWithFormat:@"%@?u=%@&mall_id=%@", VOTIGO_MAIN, votigoUserID,[delegate.mallData objectForKey:@"id"]];
    }
    else{
        url = [NSString stringWithFormat:@"%@%@", VOTIGO_SIGNUP, [delegate.mallData objectForKey:@"id"]];
    }
    
    NSURLRequest* winRequest = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [winWebView loadRequest:winRequest];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSideMenu" object:nil];

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
    
//    if ([url rangeOfString:VOTIGO_SIGNUP].location != NSNotFound ) {
//        return YES;
//    }
    
    if ([url rangeOfString:VOTIGO_CHECK_IN].location != NSNotFound) {
        [self checkLocation];
        return NO;
    }
    
    else if ([url rangeOfString:VOTIGO_CONFIRM].location != NSNotFound /*&& [url rangeOfString:@"#container"].location != NSNotFound*/)
    {
        NSRange range = [url rangeOfString:VOTIGO_CONFIRM];
//        NSRange containerRange = [url rangeOfString:@"#container"];
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
    
 

    

    else if ([url rangeOfString:MAIN_MENU].location != NSNotFound) {
        votigoUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
        NSString* url = [NSString stringWithFormat:@"%@?mall_id=%@&sweepuserentry_id=%@", VOTIGO_MAIN, [delegate.mallData objectForKey:@"id"], votigoUserID];
        
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    }

//    else if([url rangeOfString:PRIZE].location != NSNotFound)
//    {
//        return YES;
//    }
//    else if ([url rangeOfString:NOT_PERMITTED].location != NSNotFound){
//        return YES;
//    }
    else if ([url rangeOfString:SET_LOCATION_ACCESS].location != NSNotFound){
        [self requestLocationAccess];
        return NO;

    }
    
    else if ([url rangeOfString:REFER_FRIEND].location != NSNotFound ) {
        votigoUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
//        NSString    *mallString = [NSString stringWithFormat:@"mall_id=%@",delegate.mallData[@"id"]];
//        NSString    *sweepUser  = [NSString stringWithFormat:@"sweepuserentry_id=%@",votigoUserID];
//        if ([url rangeOfString:mallString].location == NSNotFound  || [url rangeOfString:sweepUser].location == NSNotFound) {
//            NSString *newURL = [NSString stringWithFormat:@"%@?mall_id=%@&sweepuserentry_id=%@", REFER_FRIEND, delegate.mallData[@"id"], votigoUserID];
//            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newURL]]];
//            
//            return NO;
//        }
        if ([url rangeOfString:[NSString stringWithFormat:@"%@?sweepuserentry_id=%@",REFER_FRIEND,votigoUserID]].location == NSNotFound) {
            NSString *newURL = [NSString stringWithFormat:@"%@?sweepuserentry_id=%@",REFER_FRIEND,votigoUserID];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newURL]]];
            return NO;
        }
   
    }
    
    return YES;
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

-(void)checkLocation{
    if (![CLLocationManager locationServicesEnabled]) {
        NSURL *url = [NSURL URLWithString:NOT_PERMITTED];
        [winWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else{
        
        if (!locationController) {
            locationController = [[MyCLController alloc] init];
            locationController.delegate = self;
        }
        
        [[LoadingAgent defaultAgent] makeBusy:YES];
        [locationController.locationManager requestLocation];

       
    }
}

- (void)chekinMallAction {
  
    

    
    double destinationLat = [delegate.mallData[@"location_lat"] doubleValue];
    double destinationLong = [delegate.mallData[@"location_lng"] doubleValue];
    
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:destinationLat longitude:destinationLong];
    CLLocation *current = [[CLLocation alloc] initWithLatitude:delegate.latitude longitude:delegate.longitude];
    
    CLLocationDistance distance = [current distanceFromLocation:destination];
    
    if (distance >= 1609) { //1609 meters = 1 mile
        NSURL *url = [NSURL URLWithString:NOT_IN_MALL];
        [winWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [[LoadingAgent defaultAgent] makeBusy:YES];
        [manager GET:@"http://developerplatform.votigo.com/api/signature.json?apiKey=1551561c19fadbd4c5afb83cd14f3193" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
          
            NSLog(@"Response = %@", responseObject);
            
//            NSDictionary *params = @{@"sweepuserentry_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"],
//                                     @"sweep_id" : @"36369",
//                                     @"mall_id" : delegate.mallData[@"id"],
//                                     @"signature" : responseObject[@"signature"],
//                                     @"action_type" : @"checkin"
//                                     };
            NSString *urlString = [NSString stringWithFormat:@"http://developerplatform.votigo.com/sweeps/awardSweepentryCredits.json?sweep_id=36369&sweepuserentry_id=%@&mall_id=%@&action_type=checkin&signature=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"],delegate.mallData[@"id"],responseObject[@"signature"]];
            [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Response = %@", responseObject);
                
                [[LoadingAgent defaultAgent] makeBusy:NO];
                
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
                [[LoadingAgent defaultAgent] makeBusy:NO];
                NSLog(@"Error = %@", error);
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[LoadingAgent defaultAgent] makeBusy:NO];
            NSLog(@"Error = %@", error);
        }];
    }
    
    
}



-(void)requestLocationAccess{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled" message:@"Please turn on location services from privacy settings to check in the mall" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


-(void)locationUpdate:(CLLocation *)location{
    
    
    delegate.latitude   = location.coordinate.latitude;
    delegate.longitude  = location.coordinate.longitude;
    
    [self chekinMallAction];
    [[LoadingAgent defaultAgent] makeBusy:NO];

}

-(void)locationError:(NSError *)error{
    
    [[LoadingAgent defaultAgent] makeBusy:NO];
    NSLog(@"location error : %@",error.localizedDescription);
    
    delegate.latitude   = 0.0;
    delegate.longitude  = 0.0;
    
    [self chekinMallAction];
    
}
@end
