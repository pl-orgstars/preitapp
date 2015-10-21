//
//  SalesViewController.m
//  Preit
//
//  Created by Aniket on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SalesViewController.h"
#import "EventsDetailsViewController.h"
#import "RequestAgent.h"
#import "AsyncImageView.h"
#import "JSON.h"
#import "LoadingAgent.h"


#define TAG_HEAD_LABEL 101
#define TAG_DATE_LABEL 102
#define TAG_WEBVIEW 103

@implementation SalesViewController

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
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	screenIndex=4;
	[self setHeader];
	
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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage3:) name:@"updateGeneral_IMG" object:nil];
	
	
	tableSales.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
	tableSales.separatorColor=[UIColor whiteColor];	
	
	tableData=[[NSMutableArray alloc]init];
	webViewArray=[[NSMutableArray alloc]init];
    disclosureRow=[[NSMutableArray alloc]init];
	
	//	UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(buttonAction:)] autorelease];
	//	refreshButton.tag=100;
	//	self.navigationItem.rightBarButtonItem=refreshButton;
	
	[self getData];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"Reload" object:nil];
 	
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
//	[tableData release];
//	[disclosureRow release];
//    [super dealloc];
//}

-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];
	
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];
    NSLog(@"namename ==%@",[delegate.mallData objectForKey:@"name"]);
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
	
	titleLabel.text=title;
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.textAlignment=UITextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
//	[titleLabel release];
	
	self.navigationItem.titleView=headerView;
//	[headerView release];	
}

#pragma mark - Button Actions

- (IBAction)backBtnCall:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;
}

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height=60.0;
	if(!isNoData){
		NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"sale"];
		CGSize constraint = CGSizeMake(280.0000, 20000.0f);
		CGSize titlesize = [[tmpDict objectForKey:@"headline"] sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		NSString *dateString=[NSString stringWithFormat:@"%@ - %@",[tmpDict objectForKey:@"startsOn"],[tmpDict objectForKey:@"endsOn"]];
		CGSize datesize = [dateString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		
		NSString *teaserString=[tmpDict objectForKey:@"teaser"];
		
		if(teaserString && teaserString!=[NSNull null] && [teaserString length]>0)
		{
			CGSize teasersize = [teaserString sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			CGFloat apprHeight=titlesize.height+datesize.height+teasersize.height;
			
			return apprHeight;
		}
		return ((titlesize.height+datesize.height)<60?65:(titlesize.height+datesize.height));
	}
	return height;	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return isNoData?1:[tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier=isNoData?@"NoData":@"Cell";
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil){
		if(cellIdentifier==@"Cell")
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];// autorelease];
        else
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];// autorelease];
	}
	else 
	{
		UILabel *headlineLabel_tmp=(UILabel*)[cell viewWithTag:TAG_HEAD_LABEL];
		[headlineLabel_tmp removeFromSuperview];
		
		UILabel *dateLabel_tmp=(UILabel*)[cell viewWithTag:TAG_DATE_LABEL];
		[dateLabel_tmp removeFromSuperview];
		
		UIWebView *webview_tmp=(UIWebView*)[cell viewWithTag:TAG_WEBVIEW];
		[webview_tmp removeFromSuperview];
	}
	
	if(cellIdentifier==@"Cell")
	{
		cell.selectionStyle=UITableViewCellSelectionStyleGray;
		
		NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"sale"];
		
		NSString *headLine=[tmpDict objectForKey:@"headline"];
		CGSize constraint = CGSizeMake(280.0000, 20000.0f);
		CGSize titlesize = [headLine sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
		CGRect frame=CGRectMake(10.0, 0.0,280.0, titlesize.height);
		UILabel *headlineLabel=[[UILabel alloc]initWithFrame:frame];
		headlineLabel.tag=TAG_HEAD_LABEL;
		headlineLabel.text=headLine;
		headlineLabel.numberOfLines=0;
		headlineLabel.backgroundColor=[UIColor clearColor];
		headlineLabel.textColor=[UIColor whiteColor];
		headlineLabel.font=[UIFont boldSystemFontOfSize:18];
//		[cell.contentView addSubview:headlineLabel];
//		[headlineLabel sizeToFit];
        
        UIWebView *titleWebview = [[UIWebView alloc]initWithFrame:CGRectMake(2.0, -7.0,280.0, titlesize.height+20)];
        titleWebview.tag = TAG_HEAD_LABEL;
//        NSString *str = [NSString stringWithFormat:@"body {background-color: transparent;} <p>%@</p>",[tmpDict objectForKey:@"headline"]];
        NSString *str = [NSString stringWithFormat:@"<html><body style=\"background-color: transparent;\"> <h3><p style=\"color:#ffffff;\"> %@ </p></h3></body></html> ",[tmpDict objectForKey:@"headline"]];
        [titleWebview loadHTMLString:str baseURL:nil];
        [titleWebview setOpaque:NO];
        [titleWebview setBackgroundColor:[UIColor clearColor]];
//        [titleWebview setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        
        [cell.contentView addSubview:titleWebview];
        [titleWebview setUserInteractionEnabled:NO];
        
        [cell setClipsToBounds:YES];
//		[titleWebview sizeToFit];

        
		
		NSString *dateString=[NSString stringWithFormat:@"%@ - %@",[tmpDict objectForKey:@"startsOn"],[tmpDict objectForKey:@"endsOn"]];
		CGSize titlesize1 = [dateString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
		frame=CGRectMake(10.0,headlineLabel.frame.size.height,280.0, titlesize1.height);
		UILabel *dateLabel=[[UILabel alloc]initWithFrame:frame];
		dateLabel.tag=TAG_DATE_LABEL;
		dateLabel.text=dateString;
		dateLabel.backgroundColor=[UIColor clearColor];
		dateLabel.textColor=[UIColor whiteColor];
		dateLabel.font=[UIFont systemFontOfSize:14];
		[cell.contentView addSubview:dateLabel];
//		[dateLabel release];
//		[headlineLabel release];
		
		
		NSString *htmlString=[tmpDict objectForKey:@"content"];
		if(!htmlString || htmlString==nil || htmlString==[NSNull null] || htmlString==@"<p></p>" || htmlString==@"<p><p></p></p>")
			htmlString=@"";
		
		
		htmlString = [htmlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if([htmlString length]==0)
		{
			[disclosureRow addObject:[NSNumber numberWithBool:NO]];
			cell.accessoryType=UITableViewCellAccessoryNone;	
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
			
		}
		else
		{
			[disclosureRow addObject:[NSNumber numberWithBool:YES]];
            
            UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
            [view setFrame:CGRectMake(0, 0, 8, 14)];
            cell.accessoryView = view;
//			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle=UITableViewCellSelectionStyleGray;
			
		}
		
		if(([webViewArray count]==0 || [webViewArray count]-1< indexPath.row))
		{
			NSString *teaserString=[tmpDict objectForKey:@"teaser"];
		
		if(teaserString && teaserString!=[NSNull null] && [teaserString length]>0)
		{		
			CGSize constraint = CGSizeMake(280.0, 20000.0f);
			CGSize titlesize = [headLine sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			CGSize teasersize = [teaserString sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			CGSize datesize = [dateString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			
			frame=CGRectMake(10, titlesize.height+datesize.height, 280.0, teasersize.height);
		}
		else 
		{
			teaserString=@"";
			frame=CGRectMake(0, 0,0,0);
		}

		UIWebView *webView=[[UIWebView alloc]initWithFrame:frame];
		webView.dataDetectorTypes=UIDataDetectorTypeNone;
		webView.delegate=self;
		webView.tag=TAG_WEBVIEW;
		webView.backgroundColor=[UIColor clearColor];
		//webView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
		webView.opaque=NO;
		[webView loadHTMLString:teaserString baseURL:nil];
		
		[webView sizeThatFits:CGSizeZero];
		[cell.contentView addSubview:webView];
		[webViewArray addObject:webView];
//		[webView release];
		}
		else {
			[cell.contentView addSubview:[webViewArray objectAtIndex:indexPath.row]];
		}

	}else
	{
		cell.textLabel.text=@"No Result";		
		cell.textLabel.textColor=[UIColor whiteColor];
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.textAlignment=UITextAlignmentCenter;
	}	
	return cell;	
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 NSString *cellIdentifier=isNoData?@"NoData":@"Cell";
 UITableViewCell *cell;
 
 cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 if (cell == nil){
 if(cellIdentifier==@"Cell")
 cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
 else
 cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
 }
 else 
 {
 UIWebView *label_tmp=(UIWebView*)[cell viewWithTag:TAG_LABEL];
 [label_tmp removeFromSuperview];
 }
 
 if(cellIdentifier==@"Cell")
 {
 cell.textLabel.numberOfLines=0;
 cell.textLabel.font=[UIFont boldSystemFontOfSize:18];	
 cell.selectionStyle=UITableViewCellSelectionStyleGray;
 
 NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"sale"];
 cell.textLabel.text=[tmpDict objectForKey:@"headline"];
 cell.textLabel.backgroundColor=[UIColor clearColor];
 cell.textLabel.textColor=[UIColor whiteColor];
 cell.textLabel.font=[UIFont boldSystemFontOfSize:18];
 //		NSString *dateString=[NSString stringWithFormat:@"%@ - %@",[tmpDict objectForKey:@"startsOn"],[tmpDict objectForKey:@"endsOn"]];
 //		cell.detailTextLabel.text=dateString;
 //		cell.detailTextLabel.backgroundColor=[UIColor clearColor];
 //		cell.detailTextLabel.textColor=[UIColor whiteColor];
 
 
 NSString *htmlString=[tmpDict objectForKey:@"content"];
 if(!htmlString || htmlString==nil || htmlString==[NSNull null] || htmlString==@"<p></p>" || htmlString==@"<p><p></p></p>")
 htmlString=@"";
 
 
 htmlString = [htmlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
 if([htmlString length]==0)
 {
 [disclosureRow addObject:[NSNumber numberWithBool:NO]];
 cell.accessoryType=UITableViewCellAccessoryNone;	
 cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
 }
 else
 {
 [disclosureRow addObject:[NSNumber numberWithBool:YES]];
 cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
 cell.selectionStyle=UITableViewCellSelectionStyleGray;
 
 }
 
 
 NSString *teaserString=[tmpDict objectForKey:@"teaser"];
 CGRect frame;
 if(teaserString && teaserString!=[NSNull null] && [teaserString length]>0)
 {	
 
 CGSize constraint = CGSizeMake(200.0000, 20000.0f);
 CGSize titlesize = [[tmpDict objectForKey:@"headline"] sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
 CGSize teasersize = [teaserString sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
 
 NSLog(@"height=====%f====%f",titlesize.height,cell.textLabel.frame.size.height);
 frame=CGRectMake(0, titlesize.height+10, 320, 50);
 //			UILabel *dateLabel=[[UILabel alloc]initWithFrame:frame];
 //			dateLabel.tag=TAG_LABEL;
 //			dateLabel.text=teaserString;
 //			dateLabel.backgroundColor=[UIColor clearColor];
 //			dateLabel.textColor=[UIColor whiteColor];
 //			dateLabel.font=[UIFont systemFontOfSize:16];
 //			[cell.contentView addSubview:dateLabel];
 //			[dateLabel release];			
 }
 else 
 {
 teaserString=@"";
 frame=CGRectMake(0, 0,0,0);
 }
 NSLog(@"frame==%f===%f==%f==%f===",frame.origin.x,frame.origin.y,frame.size.height,frame.size.width);
 UIWebView *webView=[[UIWebView alloc]initWithFrame:frame];
 webView.tag=TAG_LABEL;
 //		webView.backgroundColor=[UIColor clearColor];
 webView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
 webView.opaque=NO;
 [webView loadHTMLString:teaserString baseURL:nil];
 
 //[webView sizeThatFits:CGSizeZero];
 [cell addSubview:webView];
 
 [webView release];
 
 //	UIWebView *webView_tmp=(UIWebView*)[cell.contentView viewWithTag:TAG_WEBVIEW];
 //	if(webView_tmp)
 //		[webView_tmp removeFromSuperview];
 //	
 //	NSString *teaserString=@"<p><strong>April 24th, 25th and 26th!</strong></p>";//[tmpDict objectForKey:@"teaser"];
 //	if(teaserString && teaserString!=[NSNull null] && [teaserString length]>0)
 //	{
 //	NSLog(@"========teaserString===%@",teaserString);
 //	
 //	CGRect frame=CGRectMake(0, cell.frame.size.height, 320, 20);
 //	
 //	UIWebView *webView=[[UIWebView alloc]initWithFrame:frame];
 //	webView.tag=TAG_WEBVIEW;
 //	[cell.contentView addSubview:webView];
 //	[webView loadHTMLString:teaserString baseURL:nil];
 ////	[webView sizeThatFits:CGSizeZero];
 //		
 //	NSLog(@"height===%d",[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] integerValue]);
 //	[webView release];
 //	}
 
 }else
 {
 cell.textLabel.text=@"No Result";		
 cell.textLabel.textColor=[UIColor whiteColor];
 cell.textLabel.backgroundColor=[UIColor clearColor];
 cell.textLabel.textAlignment=UITextAlignmentCenter;
 }	
 return cell;	
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(!isNoData)
	{
		if([[disclosureRow objectAtIndex:indexPath.row] boolValue])
		{
            
			EventsDetailsViewController *screenEventDetail=[[EventsDetailsViewController alloc]initWithNibName:@"EventsDetailsViewController" bundle:nil];
			screenEventDetail.dictData=[[tableData objectAtIndex:indexPath.row]objectForKey:@"sale"];
			screenEventDetail.flagScreen=NO;
			[self.navigationController pushViewController:screenEventDetail animated:YES];
//			[screenEventDetail release];
		}
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		url_LinkClicked = request.URL ;//retain];
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"You are leaving this app.Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
		[alert show];
//		[alert release];
		
		return NO;	
	}
	return YES;
}

#pragma mark Response methods

-(void)getData{	
	NSString *apiString=[NSString stringWithFormat:@"API%d",screenIndex];
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(apiString,"")];
	//NSLog(@"url:::::::::::%@",url);
	//self.navigationItem.rightBarButtonItem.enabled=NO;
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
//	[indicator_ startAnimating];
    [[LoadingAgent defaultAgent]makeBusy:YES];
}

-(void)responseData:(NSData *)receivedData{
//	[indicator_ stopAnimating];
    [[LoadingAgent defaultAgent]makeBusy:NO];
	//self.navigationItem.rightBarButtonItem.enabled=YES;
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSArray *tmpArray=[jsonString JSONValue];
		NSLog(@"tmpArray========%@",tmpArray);
		[tableData removeAllObjects];
		[webViewArray removeAllObjects];
		if([tmpArray count]!=0){
			if(screenIndex==2)
				tmpArray=[[[tmpArray objectAtIndex:0]objectForKey:@"tenant_category"]objectForKey:@"tenants" ];
			
			[tableData addObjectsFromArray:tmpArray];
			
		}
		else{
			isNoData=YES;
		}
	}
	else
		isNoData=YES;
	
	[tableSales reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)errorCallback:(NSError *)error{
	//self.navigationItem.rightBarButtonItem.enabled=YES;
//	[indicator_ stopAnimating];
    [[LoadingAgent defaultAgent]makeBusy:NO];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

- (void)reload:(NSNotification*)notification
{
	[self viewDidLoad];
}

-(void)buttonAction:(id)sender
{
	[self getData];
}

-(NSString *)getDateStringFrom:(NSString *)d1 toDate:(NSString *)d2{
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *theDate = [dateFormatter dateFromString:d1];
	d1=[dateFormatter stringFromDate:theDate];
	
	theDate = [dateFormatter dateFromString:d2];
	d2=[dateFormatter stringFromDate:theDate];
//    [dateFormatter release];
	
	return [NSString stringWithFormat:@"%@ - %@",d1,d2];
	
}

-(void)updateImage3:(NSNotification *)notification
{
	imageView.image=delegate.image3;
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];	
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

@end
