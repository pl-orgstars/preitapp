    //
//  DinningViewController.m
//  Preit
//
//  Created by Aniket on 10/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DiningViewController.h"
#import "AsyncImageView.h"
#import "DiningDetailViewController.h"

@implementation DiningViewController

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
	self.imageView.image=[UIImage imageNamed:@"dinning.jpg"];
	self.screenIndex=2;
    [super viewDidLoad];
	
	if(delegate.image2==[NSNull null] || delegate.image2==nil)
	{
		if(delegate.image3)
			imageView.image=delegate.image3;
		else
			imageView.image=[UIImage imageNamed:@"dinning.jpg"];
		
		if(delegate.imageLink2 && [delegate.imageLink2 length]!=0)
		{
			CGRect frame;
			frame.size.width=320;
			if(isIPhone5){frame.size.height=586;}else{frame.size.height=480;}
//            frame.size.height=480;
			frame.origin.x=0; frame.origin.y=0;
			AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];// autorelease];
			NSURL *url=[NSURL URLWithString:delegate.imageLink2];
			[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
		}
	}
	else
	{
		imageView.image=delegate.image2;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage2:) name:@"updateDining_IMG" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
	if(delegate.refreshDining)
	{
		delegate.refreshDining=NO;
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
	NSDictionary *tmpDict=[self.tableData objectAtIndex:indexPath.row];
	CGSize constraint = CGSizeMake(200.0000, 20000.0f);
	CGSize titlesize = [[tmpDict objectForKey:@"name"] sizeWithFont:[UIFont boldSystemFontOfSize:25] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	return (titlesize.height<60?65:(titlesize.height+30));	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableData count];
}

- (void)tableView_:(UITableView *)tableView modified_cellForRowAtIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell*)cell {
	NSDictionary *tmpDict=[self.tableData objectAtIndex:indexPath.row];
	cell.textLabel.text=[tmpDict objectForKey:@"name"];	
//	cell.textLabel.textColor=[UIColor whiteColor];
	cell.textLabel.backgroundColor=[UIColor clearColor];
	[cell.textLabel sizeToFit];
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
    [view setFrame:CGRectMake(0, 0, 8, 14)];
    cell.accessoryView = view;
//	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView modified_didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	DiningDetailViewController *screenStoreDetail=[[DiningDetailViewController alloc]initWithNibName:@"CustomStoreDetailViewController" bundle:nil];
	NSDictionary *tmpDict=[self.tableData objectAtIndex:indexPath.row];
    ///kkkkkk
    NSLog(@"dinning data are:::::%@",tmpDict);
    // Change google
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"name"];
    
    // Send a screenview.
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
   // [[GAI sharedInstance].defaultTracker sendView:[tmpDict objectForKey:@"name"]];
	screenStoreDetail.dictData=tmpDict;
	///kkkkk
	[self.navigationController pushViewController:screenStoreDetail animated:YES];
//	[screenStoreDetail release];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView modified_didSelectRowAtIndexPath:indexPath];	
}
-(void)updateImage2:(NSNotification *)notification
{
	imageView.image=delegate.image2;
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image2=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image2;
}
@end
