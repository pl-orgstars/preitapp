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
#import "JobsDetailViewController.h"
#import "JSON.h"
#import "LoadingAgent.h"

@implementation JobsViewController
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    [super viewDidLoad];	
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	tableData=[[NSMutableArray alloc]init];
    tableJobs.hidden =TRUE;
	[self setHeader];
	[self getData];
    
    self.navigationController.navigationBarHidden = YES;

	if(delegate.image3==nil)
	{
		imageView.image=[UIImage imageNamed:@"shopping.jpg"];
		if(delegate.imageLink3 && [delegate.imageLink3 length]!=0)
		{
			CGRect frame;
			frame.size.width=320;
			frame.size.height=480;
			frame.origin.x=0; frame.origin.y=0;
			AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];
			NSURL *url=[NSURL URLWithString:delegate.imageLink3];
			[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
		}
	}
	else
		imageView.image=delegate.image3;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];
    headerView.backgroundColor = [UIColor clearColor];
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];

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
	return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return isNoData?1:[tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier=isNoData?@"NoData":@"Cell";
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil){
        if([cellIdentifier isEqualToString:@"Cell"])
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];// autorelease];
        else
			cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];// autorelease];
	}
    if([cellIdentifier isEqualToString:@"Cell"]){
		cell.textLabel.numberOfLines=1;
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
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
		cell.textLabel.textAlignment=NSTextAlignmentCenter;
	}	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(!isNoData)
	{
		NSDictionary *tmpDict=[[tableData objectAtIndex:indexPath.row]objectForKey:@"job"];
        
        JobsDetailViewController* jobsDetailVC = [[JobsDetailViewController alloc] initWithNibName:@"JobsDetailViewController" bundle:[NSBundle mainBundle]];
        
        jobsDetailVC.jobDetailDict = tmpDict;
        
        [self.navigationController pushViewController:jobsDetailVC animated:NO];
        
        ////kk
        NSString *str = [NSString stringWithFormat:@"Job opening-%@",[tmpDict valueForKey:@"title"]];
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:str];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
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
    [[LoadingAgent defaultAgent]makeBusy:YES];
}

-(void)responseData:(NSData *)receivedData{
    tableJobs.hidden =FALSE;
    [[LoadingAgent defaultAgent]makeBusy:NO];
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
    tableJobs.hidden =FALSE;
	[[LoadingAgent defaultAgent]makeBusy:NO];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];

}
@end
