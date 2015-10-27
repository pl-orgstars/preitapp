    //
//  StoreViewController.m
//  Preit
//
//  Created by Aniket on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShoppingStoreViewController.h"
#import "StoreDetailsViewController.h"
#import "AsyncImageView.h"


@implementation ShoppingStoreViewController
@synthesize titleString;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.screenIndex=1;
    [super viewDidLoad];
	if(delegate.image1==[NSNull null] || delegate.image1==nil)
	{
		if(delegate.image3)
			imageView.image=delegate.image3;
		else
			imageView.image=[UIImage imageNamed:@"shopping.jpg"];
		
		if(delegate.imageLink1 && [delegate.imageLink1 length]!=0)
		{
			CGRect frame;
			frame.size.width=320;
			frame.size.height=480;
			frame.origin.x=0; frame.origin.y=0;
			AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];// autorelease];
			NSURL *url=[NSURL URLWithString:delegate.imageLink1];
			[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
		}
	}
	else
	{
		imageView.image=delegate.image1;
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


-(void)getData{
	//No Request in this class
}
- (CGFloat)tableView_:(UITableView *)tableView modified_heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *tmpDict=[self.tableData objectAtIndex:indexPath.row];
	CGSize constraint = CGSizeMake(200.0000, 20000.0f);
	CGSize titlesize = [[tmpDict objectForKey:@"name"] sizeWithFont:[UIFont boldSystemFontOfSize:25] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	return (titlesize.height<60?65:(titlesize.height+10));
}
- (void)tableView_:(UITableView *)tableView modified_cellForRowAtIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell*)cell {
	NSDictionary *tmpDict=[self.tableData objectAtIndex:indexPath.row];
	cell.textLabel.text=[tmpDict objectForKey:@"name"];
	cell.textLabel.textColor=LABEL_TEXT_COLOR;
	cell.textLabel.backgroundColor=[UIColor clearColor];
    
    cell.detailTextLabel.text = [tmpDict objectForKeyWithNullCheck:@"area_name"];
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
    [view setFrame:CGRectMake(0, 0, 8, 14)];
    cell.accessoryView = view;
//	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView modified_didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	StoreDetailsViewController *screenStoreDetail=[[StoreDetailsViewController alloc]initWithNibName:@"CustomStoreDetailViewController" bundle:nil];
    ///kk
    NSDictionary *tmpDict=[self.tableData objectAtIndex:indexPath.row];
    NSLog(@"again sabasss %@",[tmpDict objectForKey:@"name"]);
    // Change google
    //[[GAI sharedInstance].defaultTracker sendView:[tmpDict objectForKey:@"name"]];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:[tmpDict objectForKey:@"name"]];
    
    // Send a screenview.
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
	screenStoreDetail.dictData=[self.tableData objectAtIndex:indexPath.row];

    ///kk
	[self.navigationController pushViewController:screenStoreDetail animated:YES];
//	[screenStoreDetail release];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView modified_didSelectRowAtIndexPath:indexPath];	
}
-(void)responseData_Image:(NSData *)receivedData{
	delegate.image1=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image1;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateShopping_IMG" object:nil];

}

@end
