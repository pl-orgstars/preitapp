//
//  _EventsDetailsViewController.m
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventsDetailsViewController.h"
#import "AsyncImageView.h"
//#import "NSAttributedString+HTML.h"

@implementation EventsDetailsViewController
@synthesize dictData,flagScreen;
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

//-(NSString*)convertHTML:(NSString*)HTMLString{
//    NSData *HTMLData = [HTMLString dataUsingEncoding:NSUTF8StringEncoding];
//    NSAttributedString *attrString = [NSAttributedString attributedStringWithHTML:HTMLData options:nil];
//    NSString *plainText = attrString.string;
//    return plainText;
//}
- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}
-(void)setTitleInWebView:(NSString *)title{
//    NSString *str = [NSString stringWithFormat:@"<p>%@</p>",title];
    [titleWebView loadHTMLString:title baseURL:nil];
//    NSString *yourHTMLSourceCodeString = [titleWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
//    document.body.innerHTML
     NSString *yourHTMLSourceCodeString = [titleWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    labelName.text = yourHTMLSourceCodeString;
    NSLog(@"titttttt :: %@",yourHTMLSourceCodeString);
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if(flagScreen){
//        NSString *htmlStripped = [[NSAttributedString attributedStringWithHTML:[dictData objectForKey:@"title"] options:nil] string];

        
//		labelName.text=    [dictData objectForKey:@"title"];
//        labelName.text=  [self flattenHTML:[dictData objectForKey:@"title"]];
        [self setTitleInWebView:[dictData objectForKey:@"title"]];
        
//		self.navigationItem.title=NSLocalizedString(@"Screen3.1",@"");
        [self setNavigationTitle:NSLocalizedString(@"Screen3.1",@"") withBackButton:YES];
		
		labelDate.text=[NSString stringWithFormat:@"%@ - %@",[dictData objectForKey:@"startsAt"],[dictData objectForKey:@"endsAt"]];
	}
    
	else{
//		labelName.text=[dictData objectForKey:@"headline"];

//        labelName.text= [self flattenHTML:[dictData objectForKey:@"headline"]];
        [self setTitleInWebView:[dictData objectForKey:@"headline"]];
        
//		self.navigationItem.title=NSLocalizedString(@"Screen4.1",@"");
        [self setNavigationTitle:NSLocalizedString(@"Screen4.1",@"") withBackButton:YES];
        
		labelDate.text=[NSString stringWithFormat:@"%@ - %@",[dictData objectForKey:@"startsOn"],[dictData objectForKey:@"endsOn"]];
		image_thumbNail.image=[UIImage imageNamed:@"dollar.png"];
	}

	NSString *htmlString=[dictData objectForKey:@"content"];
//    NSString *htmlString=[dictData objectForKey:@"headline"];
    if(!htmlString || htmlString==nil || htmlString==[NSNull null] || htmlString==@"<p></p>")
		htmlString=@"";
		
		
	htmlString = [htmlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if([htmlString length]==0){
		htmlString=@"<p>No data availiable for details</p>";
	}
	
	delegate=(PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
	[webView loadHTMLString:htmlString baseURL:nil];
	image_Background.image=delegate.image1;	
	
	if(delegate.image3==nil)
	{
		image_Background.image=[UIImage imageNamed:@"shopping.jpg"];
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
		image_Background.image=delegate.image3;
	}
	
	webView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [webView setOpaque:NO];
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

#pragma mark Action methods

-(IBAction)buttonAction:(id)sender{
	UIButton *button=(UIButton *)sender;
	switch (button.tag) {
		case 100:
		{
			NSLog(@"Phone Number clicked");
			//Phone Number
			NSURL *url = [[ NSURL alloc ] initWithString: @"tel:212-555-1234" ];
			[[UIApplication sharedApplication] openURL:url];
//			[url release];
		}
			break;
		case 101:
			//Map
			//NSLog(@"Map");
			break;
		default:
			break;
	}
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	image_Background.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		url_LinkClicked = request.URL;// retain];
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"You are leaving this app.Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
		[alert show];
		
		return NO;	
	}
	return YES;
}


#pragma mark UIAlertView delegate methods

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Yes"] == NSOrderedSame)
	{	
		if (![[UIApplication sharedApplication] openURL:url_LinkClicked])			
			NSLog(@"%@%@",@"Failed to open url:",[url_LinkClicked description]);
		
//		[url_LinkClicked release];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *yourHTMLSourceCodeString = [titleWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    labelName.text = yourHTMLSourceCodeString;
    NSLog(@"titttttt :: %@",yourHTMLSourceCodeString);
}
@end
