//
//  WebViewController.m
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "RequestAgent.h"
#import "AsyncImageView.h"
#import "JSON.h"

#import "UIAlertView+Blocks.h"
@implementation WebViewController
{

    NSString *webViewURLString;
}
@synthesize urlString,htmlString,titleString,screenIndex,tmpdict;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

- (void)viewDidLoad {
    [super viewDidLoad];


    
	delegate=(PreitAppDelegate *)[[UIApplication sharedApplication] delegate];	
 	NSLog(@"=====>%@",tmpdict);
	[lab1 setHidden:TRUE];
	[lab2 setHidden:TRUE];
	[webView1 setHidden:TRUE];
    if (screenIndex == 50) {
        
        NSString *titleLabel = (NSString*)[delegate.mallData objectForKey:@"name"];
        NSLog(@"delegate titleLabel ==%@",[delegate.mallData objectForKey:@"name"]);
        [self setNavigationTitle:titleLabel withBackButton:YES];
        [webView loadHTMLString:htmlString baseURL:nil];
    }else if(htmlString)
	{
		lab1.text=[tmpdict objectForKey:@"title"];
		lab2.text=[tmpdict objectForKey:@"tenant_name"];
		[lab1 setHidden:FALSE];
		[lab2 setHidden:FALSE];
		[webView1 setHidden:FALSE];
//		self.navigationItem.title=titleString;
        
        [self setNavigationTitle:titleString withBackButton:YES];
		NSLog(@"*************************************");
		webView1.frame=CGRectMake(16,isIPhone5?346:280, 290, 70);
		[webView1 loadHTMLString:[tmpdict objectForKey:@"contact"] baseURL:nil];
		
		webView.frame=CGRectMake(16, 95, 290, 251);
		[webView loadHTMLString:htmlString baseURL:nil];
       
	}
	else if(screenIndex==12)
	{
		NSString *screenTitle=[NSString stringWithFormat:@"Screen%d",screenIndex];
//		self.navigationItem.title=NSLocalizedString(screenTitle,"");
        [self setNavigationTitle:NSLocalizedString(screenTitle,"") withBackButton:YES];
        
		NSString *apiString=[NSString stringWithFormat:@"API%d",screenIndex];
		NSURL *apiUrl=[NSURL URLWithString:NSLocalizedString(apiString,"")];
		NSURLRequest *req = [NSURLRequest requestWithURL:apiUrl];
		[webView setScalesPageToFit:YES];
		[webView loadRequest:req];
		//return;
	}
	else if(screenIndex==9)
	{
	    [self setHeader];		
//		NSString *apiString=@"API9";
//		NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(apiString,"")];
        
        NSString *urlStrings = [delegate.mallData objectForKey:@"website_url"];
        NSLog(@"urlsrtrrttr %@",urlStrings);
        
//        urlStrings = [[urlStrings componentsSeparatedByString:@"."] objectAtIndex:0];
        
        urlStrings = [NSString stringWithFormat:@"%@%@",urlStrings,TRENDS_WEB_VIEW];
        NSLog(@"urlsrtrrttr %@",urlStrings);
        
        webViewURLString = urlStrings;
        webView.delegate = self;
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStrings]];
        [webView loadRequest:req];
        
//		RequestAgent *req=[[RequestAgent alloc] init];//autorelease];
//		[req requestToServer:self callBackSelector:@selector(responseDataTrends:) errorSelector:@selector(errorCallback:) Url:urlStrings];
//		[indicator startAnimating];
	}
	else 
	{
		if(screenIndex==0) screenIndex=2;
			[self setHeader];
		
		NSString *apiString=[NSString stringWithFormat:@"API%d",screenIndex];
		NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(apiString,"")];
		RequestAgent *req=[[RequestAgent alloc] init];//autorelease];
		[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
		[indicator startAnimating];
	}
    

	webView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
	webView1.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [webView setOpaque:NO];
    [webView1 setOpaque:NO];
    
	if(delegate.image3==nil)
	{
		imageView.image=[UIImage imageNamed:@"shopping.jpg"];
		if(delegate.imageLink3 && [delegate.imageLink3 length]!=0)
		{
			CGRect frame;
			frame.size.width=320;
			frame.size.height=480;
			frame.origin.x=0; frame.origin.y=0;
			AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];// autorelease];
			NSURL *url=[NSURL URLWithString:delegate.imageLink3];
			[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
		
		}
	}
	else
	{
		imageView.image=delegate.image3;
	}
    
  
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[webView stopLoading];
}


//- (void)dealloc {
//    [super dealloc];
//}

-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];
	
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];
     NSLog(@"gate.mallDa %@",[delegate.mallData objectForKey:@"name"]);
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont boldSystemFontOfSize:18];
	titleLabel.shadowColor=[UIColor blackColor];
	titleLabel.textAlignment=UITextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
//	[titleLabel release];
	titleLabel = nil;
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
	NSString *title=[NSString stringWithFormat:@"Screen%d",screenIndex];
	title=NSLocalizedString(title,@"");
	//	if(self.heading)
	//		title=[NSString stringWithFormat:@"%@-%@",title,self.heading];
	
	titleLabel.text=title;
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.textAlignment=UITextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
    
    
//	[titleLabel release];
	
	self.navigationItem.titleView=headerView;
    [self setNavigationLeftBackButton];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];

//	[headerView release];
}

#pragma mark Response methods

-(void)responseData:(NSData *)receivedData{
	[indicator stopAnimating];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding] ;//autorelease];
		NSDictionary *tmpDict=[jsonString JSONValue];
//		//NSLog(@"jsonString=========%@=============",jsonString);
//		//NSLog(@"tmpArray==%@",tmpDict);
		[self loadHtml:tmpDict];
	}
	else{
		[delegate showAlert:@"Sorry no data availiable.Please try again later." title:@"Message" buttontitle:@"Ok"];
	}
}

-(void)responseDataTrends:(NSData *)receivedData{
	[indicator stopAnimating];

	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSArray *tmpArray=[jsonString JSONValue];
		if([tmpArray count]>0)
		{
		NSDictionary *resDict=[tmpArray objectAtIndex:0];
		NSDictionary *tmpDict=[resDict objectForKey:@"webpage"];

			if(tmpDict && [tmpDict objectForKey:@"content"])			
			{	
				NSLog(@"image url===%@",delegate.website_url);
				webView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
				NSString *htmlContent=[tmpDict objectForKey:@"content"];
				htmlContent=[htmlContent stringByReplacingOccurrencesOfString:@" src=\"" withString:[NSString stringWithFormat:@" src=\"%@",delegate.website_url]];
				[webView loadHTMLString:htmlContent baseURL:nil];		
			}
		}
		else {
			[delegate showAlert:@"Sorry no Trends available at the moment.Please try again later." title:@"Message" buttontitle:@"Ok"];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	else{
		[delegate showAlert:@"Sorry no data availiable.Please try again later." title:@"Message" buttontitle:@"Ok"];
	}
}

-(void)errorCallback:(NSError *)error{
	[indicator stopAnimating];
//	//NSLog(@":::::::::::::Error::::::::::::::");
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try agian later." title:@"Message" buttontitle:@"Ok"];
}

- (void)callWebPage
{	
   	NSURL *url = [NSURL URLWithString:urlString];
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
}

#pragma mark UIWebView methods
-(void)showALertWithRequest:(NSURLRequest *)urlRequest{
    webView.userInteractionEnabled=TRUE;
	[indicator stopAnimating];
    
    [UIAlertView showWithTitle:NSLocalizedString(@"WebView_title",@"") message:NSLocalizedString(@"WebView_message",@"") cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Open"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[urlRequest URL]];
        }
        
    }];
}
#pragma mark webview delegate
- (BOOL)webView:(UIWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    webView.userInteractionEnabled=FALSE;
	[indicator startAnimating];
//	return YES;
    NSString *urlStrings = [delegate.mallData objectForKey:@"website_url"];
    if (self.screenIndex == 9) {
        if ([[[request URL]absoluteString]rangeOfString:urlStrings].location != NSNotFound) {
            return YES;
        }
        [self showALertWithRequest:request];
        return NO;
    }else{
       return YES;
    }
    
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//	webView.userInteractionEnabled=FALSE;
//	[indicator startAnimating];
//	return YES;
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	webView.userInteractionEnabled=TRUE;
	[indicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	//[delegate showAlert:@"Sorry there was some error please try again later."  title:@"" buttontitle:@"Close"];
	webView.userInteractionEnabled=TRUE;
	[delegate showNetworkIndicator:NO];
	[indicator stopAnimating];
}

-(void)loadHtml:(NSDictionary *)dict{
	switch (screenIndex) {
		case 2:
		{
			htmlString=[dict objectForKey:@"webpage"];			
		}
		case 6:
		{
			NSDictionary *tmpDict1=[dict objectForKey:@"webpage"];
			htmlString=[tmpDict1 objectForKey:@"content"];

		}
			break;
		case 8:
		{
			NSDictionary *tmpDict2=[dict objectForKey:@"property"];
			htmlString=[tmpDict2 objectForKey:@"hours_of_operation"];
		}
			break;
//		case 9:
//		{
//			NSDictionary *tmpDict3=[dict objectForKey:@"webpage"];
//			htmlString=[tmpDict3 objectForKey:@"content"];
//			
//		}
			break;
		default:
			break;
	}
	[webView loadHTMLString:htmlString baseURL:nil];

}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];

}

- (IBAction)backBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
    
}


@end


