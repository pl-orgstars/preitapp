//
//  TrendsViewController.m
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TrendsViewController.h"
#import "RequestAgent.h"
#import "WebViewController.h"
#import "AsyncImageView.h"
#import "JSON.h"
#import "LoadingAgent.h"


@implementation TrendsViewController

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
	[self setHeader];
	
	tableTrends.separatorColor=[UIColor whiteColor];	
	tableTrends.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
	
	if(!tableData)
		tableData=[[NSMutableArray alloc]init];
	
	[self getData];
	
	if(delegate.image3==nil)
	{
		imageViewMovie.image=[UIImage imageNamed:@"shopping.jpg"];
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
		imageViewMovie.image=delegate.image3;
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

-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];
	
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];
    NSLog(@"delegate delegate ==%@",[delegate.mallData objectForKey:@"name"]);
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=[UIFont boldSystemFontOfSize:18];
	titleLabel.shadowColor=[UIColor blackColor];
	titleLabel.textAlignment=UITextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
//	[titleLabel release];
	titleLabel = nil;
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
	NSString *title=NSLocalizedString(@"Screen9",@"");
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
//	[headerView release];	
}

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height=60.0;
	if(!isNoData){
		NSDictionary *tmpDict=[tableData objectAtIndex:indexPath.row];
		NSArray *allkeys=[tmpDict allKeys];
		CGSize constraint = CGSizeMake(200.0000, 20000.0f);
		CGSize titlesize = [[allkeys objectAtIndex:0] sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		height=(titlesize.height<60?65:(titlesize.height+10));
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
		if([cellIdentifier isEqualToString:@"Cell"])
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];// autorelease];
        else
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];// autorelease];
	}
    if([cellIdentifier isEqualToString:@"Cell" ])
	{
		NSDictionary *tmpDict=[tableData objectAtIndex:indexPath.row];
		NSArray *allkeys=[tmpDict allKeys];	
		cell.textLabel.text=[allkeys objectAtIndex:0];
		cell.textLabel.numberOfLines=0;
		cell.textLabel.font=[UIFont boldSystemFontOfSize:25];
		cell.textLabel.textColor=[UIColor whiteColor];
		cell.textLabel.backgroundColor=[UIColor clearColor];
		[cell.textLabel sizeToFit];
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
        [view setFrame:CGRectMake(0, 0, 8, 14)];
        cell.accessoryView = view;
	}
	else
	{
		cell.textLabel.text=@"No Result";
		cell.textLabel.textColor=[UIColor whiteColor];
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.textAlignment=NSTextAlignmentCenter;
	}	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSDictionary *tmpDict=[tableData objectAtIndex:indexPath.row];
	NSArray *allkeys=[tmpDict allKeys];
    self.navigationItem.title=NSLocalizedString(@"Screen9",@"");
	
	WebViewController *screenWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
	screenWebView.htmlString=[tmpDict objectForKey:[allkeys objectAtIndex:0]];
	screenWebView.titleString=[allkeys objectAtIndex:0];
	[self.navigationController pushViewController:screenWebView animated:YES];
//	[screenWebView release];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark Response methods

-(void)getData{
	NSString *apiString=@"API9";
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(apiString,"")];
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
//	[indicator_ startAnimating];
    [[LoadingAgent defaultAgent]makeBusy:YES];
}

-(void)responseData:(NSData *)receivedData{
//	[indicator_ stopAnimating];
    [[LoadingAgent defaultAgent]makeBusy:NO];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding] ;//autorelease];
		NSArray *tmpArray=[jsonString JSONValue];
		//NSLog(@"tmpArray==%@",tmpArray);
		if([tmpArray count]!=0){
			[tableData removeAllObjects];
			[tableData addObjectsFromArray:tmpArray];
		}
		else{
			isNoData=YES;
		}
	}
	else
		isNoData=YES;
	[tableTrends reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)errorCallback:(NSError *)error{
//	[indicator_ stopAnimating];
    [[LoadingAgent defaultAgent]makeBusy:NO];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageViewMovie.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];

}

@end
