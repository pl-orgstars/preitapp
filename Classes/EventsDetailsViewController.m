//
//  _EventsDetailsViewController.m
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventsDetailsViewController.h"
#import "AsyncImageView.h"
#import "RequestAgent.h"
#import "JSON.h"

//#import "NSAttributedString+HTML.h"

@implementation EventsDetailsViewController
@synthesize dictData,flagScreen;

- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}
-(void)setTitleInWebView:(NSString *)title
{
    [titleWebView loadHTMLString:title baseURL:nil];
     NSString *yourHTMLSourceCodeString = [titleWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    labelName.text = yourHTMLSourceCodeString;
    headerLabel.text = yourHTMLSourceCodeString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    NSLog(@"dictData %@",dictData);
	if(flagScreen){
        [self setTitleInWebView:[dictData objectForKey:@"title"]];
        
        [self setNavigationTitle:NSLocalizedString(@"Screen3.1",@"") withBackButton:YES];
		
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        
        NSDate *startdate = [dateFormatter dateFromString:dictData[@"starts_at"]];
        NSDate *enddate = [dateFormatter dateFromString:dictData[@"ends_at"]];

        
        [dateFormatter setDateFormat:@"MMM d"];
        
        NSString *strStartDate  = [dateFormatter stringFromDate:startdate];
        NSString *strEndDate  = [dateFormatter stringFromDate:enddate];
        
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *strStartTime  = [dateFormatter stringFromDate:startdate];
        NSString *strEndTime  = [dateFormatter stringFromDate:enddate];
        
        
        CGSize textSize = [strStartTime sizeWithAttributes:@{NSFontAttributeName:[labelDateStart font]}];
        
        CGFloat strikeWidth = textSize.width;

        labelDateStart.frame = CGRectMake(labelDateStart.frame.origin.x, labelDateStart.frame.origin.y,strikeWidth + 5 ,labelDateStart.frame.size.height);
        labelDateEnd.frame = CGRectMake(strikeWidth + 15, labelDateEnd.frame.origin.y,labelDateEnd.frame.size.width ,labelDateEnd.frame.size.height);
        labelMonthEnd.frame  =CGRectMake(strikeWidth + 25,labelMonthEnd.frame.origin.y,labelMonthEnd.frame.size.width ,labelMonthEnd.frame.size.height);
        
        labelDateEnd.text = [NSString stringWithFormat:@"- %@",strEndTime];
        labelDateStart.text = strStartTime;
        
        labelMonthStart.text = strStartDate;
        
        
        if ([dictData[@"start_date"] isEqualToString:dictData[@"end_date"]])
        {
            labelMonthEnd.text = @"";
        }else
        {
            labelMonthEnd.text = strEndDate;
        }
        
        
        
	}
    
	else{

        [self setTitleInWebView:[dictData objectForKey:@"headline"]];
        
        [self setNavigationTitle:NSLocalizedString(@"Screen4.1",@"") withBackButton:YES];
      
        
        labelMonthEnd.text = labelMonthStart.text = @"";
        labelDateStart.text =dictData[@"startsOn"];
        labelDateEnd.text =[NSString stringWithFormat:@"- %@",dictData[@"endsOn"]];
        image_thumbNail.image=[UIImage imageNamed:@"dollar.png"];
        
        CGSize textSize = [labelDateStart.text sizeWithAttributes:@{NSFontAttributeName:[labelDateStart font]}];
        
        CGFloat strikeWidth = textSize.width;
        
        labelDateStart.frame = CGRectMake(labelDateStart.frame.origin.x, labelDateStart.frame.origin.y,strikeWidth + 5 ,labelDateStart.frame.size.height);
        labelDateEnd.frame = CGRectMake(strikeWidth + 15, labelDateEnd.frame.origin.y,labelDateEnd.frame.size.width ,labelDateEnd.frame.size.height);
        
        
	}

	NSString *htmlString=[dictData objectForKey:@"content"];
    if(!htmlString || htmlString==nil || htmlString==[NSNull null] || htmlString==@"<p></p>")
		htmlString=@"";
		
		
	htmlString = [htmlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if([htmlString length]==0){
		htmlString=@"<p>No data availiable for details</p>";
	}
	
	delegate=(PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    htmlString = [self flattenHTML:htmlString];
    
    htmlString = [NSString stringWithFormat:@"<p style=\"color:white\">%@</font></p>",htmlString];
    
	[webView loadHTMLString:htmlString baseURL:nil];
    
//    txtViewDis.dataDetectorTypes = UIDataDetectorTypeNone;
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
    
    
    
    if ([dictData objectForKeyWithNullCheck:@"tenant_id"])
    {
         [self getData];
    }else{
        labelTenantName.text = @"";
        
        
        CGRect frame = headerLabel.frame;
        CGPoint origiinStart = frame.origin;
        origiinStart.y = origiinStart.y - 25;
        frame.origin = origiinStart;
        
        headerLabel.frame = frame;
        
        
        CGRect frame2 = webView.frame;
        CGPoint origiinStart2 = frame2.origin;
        origiinStart2.y = origiinStart2.y - 25;
        frame2.origin = origiinStart2;
        
        webView.frame = frame2;
        
    }
    
   
}


-(void)getData
{
    
    NSString *url=[NSString stringWithFormat:@"%@/tenants/%@",[delegate.mallData objectForKey:@"resource_url"],dictData[@"tenant_id"]];
    
    RequestAgent *req=[[RequestAgent alloc] init];
    [req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
}

-(void)responseData:(NSData *)receivedData{
    if(receivedData!=nil){
        //kuldeep edit
        NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];//autorelease];
        NSMutableDictionary *tmpArray=[jsonString JSONValue];
        labelTenantName.text = tmpArray[@"tenant"][@"name"];
    }
}





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



#pragma mark - Button Actions

- (IBAction)backBtnCall:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
}


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
		}
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
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)LocalwebView
{
    NSString *yourHTMLSourceCodeString = [titleWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    labelName.text = yourHTMLSourceCodeString;
    headerLabel.text = yourHTMLSourceCodeString;
    
    if (webView.scrollView.contentSize.height > 210)
    {
        CGRect frameWebView =  webView.frame;
        CGSize sizeWebView = frameWebView.size;
        sizeWebView.height = webView.scrollView.contentSize.height;
        frameWebView.size = sizeWebView;
        webView.frame = frameWebView;
        
        
        webView.scrollView.frame = CGRectMake(0,0, webView.frame.size.width, webView.frame.size.height);
        
        scrolviewMain.contentSize= CGSizeMake(0, webView.frame.origin.y + webView.frame.size.height);
    }
}


@end
