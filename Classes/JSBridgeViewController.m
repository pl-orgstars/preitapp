//
//  JSBridgeViewController.m
//  JSBridge
//
//  Created by Dante Torres on 10-09-03.
//  Copyright Dante Torres 2010. All rights reserved.
//

#import "JSBridgeViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "JSBridgeWebView.h"

#define TAG_INDICATOR 100

@implementation JSBridgeViewController
@synthesize mapUrl;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization

    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	self.navigationItem.title=@"Map";
    self.navigationController.navigationBar.hidden = YES;
    
//    [self setNavigationTitle:@"Map" withBackButton:YES];
//    [self setUIForIOS7];
    //kkk
    // change google
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"title"];
    
    // Send a screenview.
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
    //kkkk
	//NSLog(@"View Did Load!");
		
	webView = [[JSBridgeWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	webView.delegate = self;
	webView.backgroundColor=[UIColor whiteColor];
	webView.opaque=YES;
	
	
	UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.hidesWhenStopped=YES;
	indicator.tag=TAG_INDICATOR;
	indicator.center=webView.center;
	[webView addSubview:indicator];
//	[indicator release];
	
	[self loadMaskPage];
}

-(void) loadMaskPage
{	
	UIActivityIndicatorView *indicator=(UIActivityIndicatorView*)[webView viewWithTag:TAG_INDICATOR];
	[indicator startAnimating];
	//NSString *mapUrl=@"http://192.168.1.50:3000/api/v1/properties/24/areas/26/show_map?suit_id=7573";
	NSURL* url =[NSURL URLWithString:mapUrl];
	NSLog(@"url===%@",url);
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) viewWillAppear:(BOOL)animated
{
	[self.view addSubview:webView];
}

-(void)viewDidUnload
{
	[webView stopLoading];
}

- (BOOL)webView:(UIWebView *)p_WebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//NSLog(@"Should page load?. %@", [request URL]);
	return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)p_WebView
{
	UIActivityIndicatorView *indicator=(UIActivityIndicatorView*)[webView viewWithTag:TAG_INDICATOR];
	[indicator stopAnimating];
	//NSLog(@"Page did finish load. %@", [[p_WebView request] URL]);
}

- (void)webViewDidStartLoad:(UIWebView *)p_WebView
{
	//NSLog(@"Page did start load. %@", [[p_WebView request] URL]);
}

- (void)webView:(UIWebView *)p_WebView didFailLoadWithError:(NSError *)error
{
	UIActivityIndicatorView *indicator=(UIActivityIndicatorView*)[webView viewWithTag:TAG_INDICATOR];
	[indicator stopAnimating];
	//NSLog(@"Page did fail with error. %@", [[p_WebView request] URL]);
}

- (void)webView:(UIWebView*) webview didReceiveJSNotificationWithDictionary:(NSDictionary*) dictionary
{
	NSString* task = [dictionary objectForKey:@"task"];
	NSLog(@"response Dictionary======%@",dictionary);

	if([task compare:@"Coordinates"] == NSOrderedSame)
	{		
		UIScrollView *scroll = [[webView subviews] objectAtIndex:0];
//		scroll.minimumZoomScale = 1.2;
//		scroll.maximumZoomScale = 4;
		float x=[[dictionary objectForKey:@"x"]floatValue];
		float y=[[dictionary objectForKey:@"y"]floatValue];
//		NSLog(@"x=%f==y=%f",x,y);
		
	//	webview.frame=CGRectMake(0, 0, 500, 500);
	//  [scroll scrollRectToVisible:CGRectMake(x, y, 20, 20) animated:YES];
		
		if(x>450 || x<100)
			x=x-80;
		else
			x=x/2;

		
		if(y>450 || y<100)
			y=y-80;
		else 
			y=y/2;
		
		[scroll setContentOffset:CGPointMake(x, y) animated:YES];
	//	[scroll zoomToRect:CGRectMake(x, y, 10, 10) animated:YES];
	//	webview.frame=CGRectMake(0, 0, 320, 480);
	//  [webView setScalesPageToFit:YES];
		
//		NSString *str=[NSString stringWithFormat:@"window.scrollBy(%f,%f);",x,y];
//		[webView stringByEvaluatingJavaScriptFromString:str];

	}
	else if ([task compare:@"Completed"] == NSOrderedSame) 
	{
		
	}
}

//- (void)dealloc {
//	
//    [super dealloc];
//}

-(void)viewWillDisappear:(BOOL)animated {
    [webView stopLoading];
}
@end
