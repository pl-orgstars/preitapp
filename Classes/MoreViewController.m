    //
//  MoreViewController.m
//  Preit
//
//  Created by Aniket on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "MovieListingViewController.h"
#import "WebViewController.h"
#import "TrendsViewController.h"
#import "ContactUsViewController.h"
#import "JobsViewController.h"
#import "DirectionViewController.h"
#import "AsyncImageView.h"

@implementation MoreViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
	self.screenIndex=5;
 
	[super viewDidLoad];
	//self.navigationItem.rightBarButtonItem=nil;
	NSMutableArray *moreList;
	if(delegate.isMovie)
	    moreList=[[NSMutableArray alloc]initWithObjects:@"Directions",@"Movie Listing",@"Hours",@"Trends",@"Job Openings",@"Contact Us",@"Select a Different PREIT Property",nil];
	else
		moreList=[[NSMutableArray alloc]initWithObjects:@"Directions",@"Hours",@"Trends",@"Job Openings",@"Contact Us",@"Select a Different PREIT Property",nil];
	
    self.tableData=moreList;
	
	if(delegate.image3==nil)
	{
		imageView.image=[UIImage imageNamed:@"home.jpg"];
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

}

-(void)viewDidAppear:(BOOL)animated{
	if(delegate.refreshMore)
	{
		delegate.refreshMore=NO;
		[self.tableData removeAllObjects];
		[self viewDidLoad];
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


-(void)getData{
}

- (CGFloat)tableView_:(UITableView *)tableView modified_heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGSize constraint = CGSizeMake(200.0000, 20000.0f);
	CGSize titlesize = [[self.tableData objectAtIndex:indexPath.row] sizeWithFont:[UIFont boldSystemFontOfSize:25] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	return (titlesize.height<60?65:(titlesize.height+30));	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableData count];
}
- (void)tableView_:(UITableView *)tableView modified_cellForRowAtIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell*)cell {
	cell.textLabel.text=[self.tableData objectAtIndex:indexPath.row];
	cell.textLabel.textColor=LABEL_TEXT_COLOR;
	cell.textLabel.backgroundColor=[UIColor clearColor];
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
    [view setFrame:CGRectMake(0, 0, 8, 14)];
    cell.accessoryView = view;
//	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView modified_didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	int selectedRow=indexPath.row;
	if(!delegate.isMovie && selectedRow>0)
		selectedRow++;	
	NSLog(@"************************==>%d",selectedRow);
   
	if(selectedRow==0)
	{
		DirectionViewController *screenDirection=[[DirectionViewController alloc]initWithNibName:@"DirectionViewController" bundle:nil];
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Direction"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
		[self.navigationController pushViewController:screenDirection animated:YES];
	}
	else if(selectedRow==1)
	{
		MovieListingViewController *screenMovieListing=[[MovieListingViewController alloc]initWithNibName:@"MovieListingViewController" bundle:nil];
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Movie Listings"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];

		[self.navigationController pushViewController:screenMovieListing animated:YES];
	}
	else if(selectedRow==2)
	{
		WebViewController *screenWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
		screenWebView.screenIndex=8;
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Hours"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
		[self.navigationController pushViewController:screenWebView animated:YES];
	}
	else if(selectedRow==3)
	{
		WebViewController *screenWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
		screenWebView.screenIndex=9;
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Trends"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
		[self.navigationController pushViewController:screenWebView animated:YES];
	}

	else if(selectedRow==5)
	{
		ContactUsViewController *screenContact=[[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:nil];
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Contact Us"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];

		[self.navigationController pushViewController:screenContact animated:YES];
	}
	else if(selectedRow==4)
	{
		JobsViewController *screenJobs=[[JobsViewController alloc]initWithNibName:@"JobsViewController" bundle:nil];
        // Change google
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Job Openings"];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
		[self.navigationController pushViewController:screenJobs animated:YES];
		
	}	
	else if(selectedRow==6)
	{
        //kk
        delegate.isOnForeGround = YES;
		[delegate.navController popToRootViewControllerAnimated:YES];
		[self.delegate.tabBarController.view removeFromSuperview];   //Waseem Menu
		[self.delegate.window addSubview:delegate.navController.view];
        

	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView modified_didSelectRowAtIndexPath:indexPath];
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
