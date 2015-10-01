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
    
    
    NSLog(@"%@",[request URL]);
    NSLog(@"%@",[[request URL]absoluteString]);
    
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
    
    else if ([url rangeOfString:VOTIGO_MAIN].location != NSNotFound){
        return YES;
    }
    
    return YES;
}


#pragma mark - Navigation

- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
    
}


/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
