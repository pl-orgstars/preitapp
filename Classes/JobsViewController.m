//
//  JobsViewController.m
//  Preit
//
//  Created by Aniket on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JobsViewController.h"
#import "RequestAgent.h"
#import "WebViewController.h"
#import "AsyncImageView.h"
#import "JSON.h"
@implementation JobsViewController

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
	tableData=[[NSMutableArray alloc]init];
//	tableJobs.separatorColor=[UIColor whiteColor];	
//	tableJobs.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];

	[self setHeader];
	[self getData];
    
    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController.navigationBar setTranslucent:NO];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];

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




-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];
    headerView.backgroundColor = [UIColor clearColor];
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];
    NSLog(@"345 ==%@",[delegate.mallData objectForKey:@"name"]);

	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont boldSystemFontOfSize:18];
	titleLabel.shadowColor=[UIColor blackColor];
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];

	titleLabel = nil;
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];

	NSString *title=NSLocalizedString(@"Screen11",@"");
	
	titleLabel.text=title;
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
	
	self.navigationItem.titleView=headerView;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];

    [self setNavigationLeftBackButton];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];

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
		NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"job"];
		CGSize constraint = CGSizeMake(200.0000, 20000.0f);
		CGSize titlesize = [[tmpDict objectForKey:@"title"] sizeWithFont:[UIFont boldSystemFontOfSize:25] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//		height= (titlesize.height<60?is_iOS7?80:65:(titlesize.height+20));
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
//		if(cellIdentifier==@"Cell")
        if([cellIdentifier isEqualToString:@"Cell"])
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];// autorelease];
        else
			cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];// autorelease];
	}
//	if(cellIdentifier==@"Cell")
    if([cellIdentifier isEqualToString:@"Cell"]){
		cell.textLabel.numberOfLines=0;
		NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"job"];
		
		NSString *text=[tmpDict objectForKey:@"title"];
		if(text==NULL || text==nil)
			text=@"";
		
		cell.textLabel.text=text;		
		cell.textLabel.textColor=LABEL_TEXT_COLOR;
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.font= LABEL_TEXT_FONT;//[UIFont boldSystemFontOfSize:25];
		
		text=[tmpDict objectForKey:@"tenant_name"];
		if(text==NULL || text==nil)
			text=@"";
		
		cell.detailTextLabel.text=text;
		cell.detailTextLabel.backgroundColor=[UIColor clearColor];
		cell.detailTextLabel.textColor=  DETAIL_TEXT_COLOR;//[UIColor whiteColor];
		
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
        [view setFrame:CGRectMake(0, 0, 8, 14)];
        cell.accessoryView = view;
				
	}else
	{
		cell.textLabel.text=@"No Result";
		cell.textLabel.textColor= LABEL_TEXT_COLOR;//[UIColor whiteColor];
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.textAlignment=UITextAlignmentCenter;
	}	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(!isNoData)
	{
		NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"job"];
		WebViewController *screenWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
		screenWebView.htmlString=[tmpDict objectForKey:@"description"];
		screenWebView.titleString=NSLocalizedString(@"Screen11.1",@"");
        screenWebView.titleLabel.text= @"JOB OPENINGS";
		screenWebView.tmpdict=tmpDict;
        ////kk
        NSString *str = [NSString stringWithFormat:@"Job opening-%@",[tmpDict valueForKey:@"title"]];
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:str];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
       // [[GAI sharedInstance].defaultTracker sendView:str];
        
        
        NSLog(@"<<<<<<<<< %@,,,,,%@",screenWebView.htmlString,tmpDict);
		[self.navigationController pushViewController:screenWebView animated:YES];
//		[screenWebView release];
	}
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
 
#pragma mark Response methods

-(void)getData{
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(@"API11","")];
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
	[indicator_ startAnimating];
}

-(void)responseData:(NSData *)receivedData{
	[indicator_ stopAnimating];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSArray *tmpArray=[jsonString JSONValue];
		[tableData removeAllObjects];
		
		if([tmpArray count]!=0){
			isNoData=NO;
			[tableData addObjectsFromArray:tmpArray];
		}
		else{
			isNoData=YES;
		}
	}
	else
		isNoData=YES;

	[tableJobs reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)errorCallback:(NSError *)error{
	[indicator_ stopAnimating];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];

}
@end
