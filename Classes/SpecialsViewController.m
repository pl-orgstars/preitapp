    //
//  SpecialsViewController.m
//  Preit
//
//  Created by Aniket on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpecialsViewController.h"
#import "EventsDetailsViewController.h"
#import "AsyncImageView.h"

#define TAG_WEBVIEW 100


@implementation SpecialsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.screenIndex=4;
    [super viewDidLoad];
	
	if(delegate.image3==nil)
	{
		imageView.image=[UIImage imageNamed:@"shopping.jpg"];
		if(delegate.imageLink3 && [delegate.imageLink3 length]!=0)
		{
			CGRect frame;
			frame.size.width=320;
			frame.size.height=480;
			frame.origin.x=0; frame.origin.y=0;
			AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame] ;//autorelease];
			NSURL *url=[NSURL URLWithString:delegate.imageLink3];
			[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
		}
	}
	else
	{
		imageView.image=delegate.image3;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage3:) name:@"updateGeneral_IMG" object:nil];

//	tableCustom.separatorColor=[UIColor blackColor];
//	tableCustom.backgroundColor=[UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated{
	if(delegate.refreshSpecials)
	{
		delegate.refreshSpecials=NO;
		apiString=nil;
		[self viewDidLoad];
	}
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

- (CGFloat)tableView_:(UITableView *)tableView modified_heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *tmpDict=[[self.tableData objectAtIndex:indexPath.row]objectForKey:@"sale"];
	CGSize constraint = CGSizeMake(200.0000, 20000.0f);
	CGSize titlesize = [[tmpDict objectForKey:@"headline"] sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	return (titlesize.height<60?65:(titlesize.height+20));
}

- (void)tableView_:(UITableView *)tableView modified_cellForRowAtIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell*)cell {
	NSDictionary *tmpDict=[[self.tableData objectAtIndex:indexPath.row]objectForKey:@"sale"];
	cell.textLabel.text=[tmpDict objectForKey:@"headline"];
	cell.textLabel.backgroundColor=[UIColor clearColor];
	cell.textLabel.textColor=LABEL_TEXT_COLOR;
	NSString *dateString=[NSString stringWithFormat:@"%@ - %@",[tmpDict objectForKey:@"startsOn"],[tmpDict objectForKey:@"endsOn"]];
	cell.detailTextLabel.text=dateString;
	cell.detailTextLabel.backgroundColor=[UIColor clearColor];
	cell.detailTextLabel.textColor=[UIColor whiteColor];

	
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
//		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle=UITableViewCellSelectionStyleGray;
		
	}
	
	UIWebView *label_tmp=(UILabel*)[cell.contentView viewWithTag:TAG_WEBVIEW];
	if(label_tmp)
		[label_tmp removeFromSuperview];
	
	NSString *teaserString=[tmpDict objectForKey:@"teaser"];
	if(teaserString && teaserString!=[NSNull null] && [teaserString length]>0)
	{
		CGRect frame=CGRectMake(0, cell.frame.size.height, 320, 20);
		UILabel *label=[[UILabel alloc]initWithFrame:frame];
		label.tag=TAG_WEBVIEW;
		label.text=teaserString;
		[cell.contentView addSubview:label];
//		[label release];
	}
	
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

- (void)tableView:(UITableView *)tableView modified_didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	if([[disclosureRow objectAtIndex:indexPath.row] boolValue])
	{
		EventsDetailsViewController *screenEventDetail=[[EventsDetailsViewController alloc]initWithNibName:@"EventsDetailsViewController" bundle:nil];
		screenEventDetail.dictData=[[self.tableData objectAtIndex:indexPath.row]objectForKey:@"sale"];
		screenEventDetail.flagScreen=NO;
		[self.navigationController pushViewController:screenEventDetail animated:YES];
//		[screenEventDetail release];
	}

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView modified_didSelectRowAtIndexPath:indexPath];
	
}
- (void)reload:(NSNotification*)notification
{
	[self viewDidLoad];
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

@end
