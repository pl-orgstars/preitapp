//
//  MapViewController.m
//  Preit
//
//  Created by Aniket on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController
@synthesize mapUrl;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
	self.navigationItem.title=@"Map";
	NSLog(@"************************************gaurav*************");
//	NSString *mapString=@"http://192.168.1.50:3000/api/v1/properties/24/areas/26/show_map?suit_id=7573";
	NSURL *fileURL = [NSURL URLWithString:mapUrl];
	NSLog(@"url=====%@",fileURL);
	NSURLRequest *req = [NSURLRequest requestWithURL:fileURL];
//	[req setValue:@"<meta name='viewport' content='width=device-width; initial-scale=2.0; maximum-scale=4.0; user-scalable=1;'/>" forHTTPHeaderField:@"User_Agent"];
	
	[webView loadRequest:req];
	
	//[webView setFrameLoadDelegate:self];
//   webView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];

//	[webView stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 5.0;"];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[webView stopLoading];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//- (void)dealloc {
//    [super dealloc];
//}

//- (BOOL)webView:(UIWebView *)webView_ shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//	[webView setScalesPageToFit:YES];
//	return YES;
//}
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//	
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView_
{
//	UIScrollView *scroll = [[webView subviews] objectAtIndex:0];
//	scroll.minimumZoomScale = 1.2;
//	scroll.maximumZoomScale = 4;
//	[scroll zoomToRect:CGRectMake(50, 50, 10, 10) animated:YES];
	//scroll.center=self.view.center
	
//	NSString *bodyStyle = @"document.getElementsByTagName('body')[0].style.textAlign = 'center';";
//	NSString *mapStyle = @"document.getElementById('mapid').style.margin = 'auto';";

	
	NSString *str=[webView stringByEvaluatingJavaScriptFromString:@"get_xy();"];
	NSLog(@"zzzzzzzzzzzzzzz--------------%@",str);
}

-(void)mapX:(float)x Y:(float)y
{
	//NSLog(@"::::::::::====%f==%f",x,y);
	[webView setScalesPageToFit:YES];
	UIScrollView *scroll = [[webView subviews] objectAtIndex:0];
	scroll.minimumZoomScale = 1.2;
	scroll.maximumZoomScale = 4;
	[scroll zoomToRect:CGRectMake(x, y, 10, 10) animated:YES];
	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
 {
//	 id win=[webView windowScriptObject];
//	 [win setValue:self forKey:@"Coordinates"];
	 //NSLog(@"path=========%@",request.mainDocumentURL.relativePath);
	 return YES;
 }


//- (void)webView:(UIWebView *)sender windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject
//{
//	[windowScriptObject setValue:self forKey:@"Coordinates"];
//}

@end
