//
//  MovieListingViewController.m
//  Preit
//
//  Created by Aniket on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MovieListingViewController.h"
#import "RequestAgent.h"
#import "MovieDetailViewController.h"
#import "AsyncImageView.h"
#import "JSON.h"


@implementation MovieListingViewController



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //kk
    
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	[self setHeader];
	
	
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



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}





-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];
	
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];
    NSLog(@"headerViewheaderView ==%@",[delegate.mallData objectForKey:@"name"]);
	titleLabel.textColor=[UIColor blackColor];
	titleLabel.font=[UIFont boldSystemFontOfSize:18];
	titleLabel.shadowColor=[UIColor blackColor];
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
	titleLabel =nil;
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
	NSString *title=NSLocalizedString(@"Screen7",@"");
	
	titleLabel.text=title;
	titleLabel.textColor=[UIColor blackColor];
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];

	self.navigationItem.titleView=headerView;
    
    [self setNavigationLeftBackButton];
}

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height=60.0;
	if(!isNoData){
		NSDictionary *tmpDict=[tableData objectAtIndex:indexPath.row];
		CGSize constraint = CGSizeMake(200.0000, 20000.0f);

		NSString *timingString=@"";
		NSArray *tmpArray=[tmpDict objectForKey:@"timing"];
		if([tmpArray count])
		{
			NSDictionary *movie_schedule_Dict_0=[[tmpArray objectAtIndex:0]objectForKey:@"movie_schedule_time"];
			timingString=[movie_schedule_Dict_0 objectForKey:@"scheduled_time"];
			
			for(int i=1;i<[tmpArray count];i++)
			{
				NSDictionary *movie_schedule_Dict=[[tmpArray objectAtIndex:i]objectForKey:@"movie_schedule_time"];
				timingString=[NSString stringWithFormat:@"%@ - %@",timingString,[movie_schedule_Dict objectForKey:@"scheduled_time"]];
			}
			
		}
		NSDictionary *movieDict=[[tmpDict objectForKey:@"movie"] objectForKey:@"movie"];
		timingString=[[movieDict objectForKey:@"title"] stringByAppendingString:timingString];
		CGSize titlesize1 = [[movieDict objectForKey:@"title"] sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		CGSize titlesize2 = [timingString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		height=((titlesize1.height+titlesize2.height)<60?65:(titlesize1.height+titlesize2.height));
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
        if ([cellIdentifier isEqualToString:@"Cell"])
 			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        else
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    if ([cellIdentifier isEqualToString:@"Cell"])
	{
		NSDictionary *tmpDict=[tableData objectAtIndex:indexPath.row];
		NSDictionary *tmpDict1=[[tmpDict objectForKey:@"movie"]objectForKey:@"movie" ];
		NSString *titleString=[NSString stringWithFormat:@"%@ (%@)",[tmpDict1 objectForKey:@"title"],[tmpDict1 objectForKey:@"rating"]];
		cell.textLabel.text=titleString;
		cell.textLabel.numberOfLines=1;
		cell.textLabel.font=  LABEL_TEXT_FONT;
		cell.textLabel.textColor= LABEL_TEXT_COLOR;
		cell.textLabel.backgroundColor=[UIColor clearColor];
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
        [view setFrame:CGRectMake(0, 0, 8, 14)];
        cell.accessoryView = view;
		
		NSArray *tmpArray=[tmpDict objectForKey:@"timing"];
		if([tmpArray count])
		{
			NSDictionary *movie_schedule_Dict_0=[[tmpArray objectAtIndex:0]objectForKey:@"movie_schedule_time"];
			NSString *timingString=[movie_schedule_Dict_0 objectForKey:@"scheduled_time"];
			
			for(int i=1;i<[tmpArray count];i++)
			{
				NSDictionary *movie_schedule_Dict=[[tmpArray objectAtIndex:i]objectForKey:@"movie_schedule_time"];
				timingString=[NSString stringWithFormat:@"%@ - %@",timingString,[movie_schedule_Dict objectForKey:@"scheduled_time"]];
			}
			
			cell.detailTextLabel.text=timingString;
		}
		else {
			cell.detailTextLabel.text=@"";
		}
		cell.detailTextLabel.numberOfLines=2;
        cell.detailTextLabel.font=  DETAIL_TEXT_FONT_BOLD;
		cell.detailTextLabel.textColor= DETAIL_TEXT_COLOR;
		cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        

	}
	else
	{
		cell.textLabel.text=@"No Result";
		cell.textLabel.textColor= LABEL_TEXT_COLOR;
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.textAlignment=UITextAlignmentCenter;
	}	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(!isNoData)
	{
		MovieDetailViewController *screenMovie=[[MovieDetailViewController alloc]initWithNibName:@"MovieDetailViewController" bundle:nil];
		NSDictionary *tmpDict=[tableData objectAtIndex:indexPath.row];
        
        ///kk
        NSDictionary *tmpDict1=[[tmpDict objectForKey:@"movie"]objectForKey:@"movie" ];
		NSString *titleString=[NSString stringWithFormat:@"%@ (%@)",[tmpDict1 objectForKey:@"title"],[tmpDict1 objectForKey:@"rating"]];
        
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:titleString];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        
		screenMovie.movieData=tmpDict;
		[self.navigationController pushViewController:screenMovie animated:YES];
	}
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark Response methods

-(void)getData{
	NSString *apiString=@"API7";
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(apiString,"")];
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
	[indicator_ startAnimating];
}

-(void)responseData:(NSData *)receivedData
{
	[indicator_ stopAnimating];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSArray *tmpArray=[jsonString JSONValue];
		
		if([tmpArray count]!=0)
		{
			[tableData removeAllObjects];
			[tableData addObjectsFromArray:tmpArray];
			
		}
		else
		{
			isNoData=YES;
			[delegate showAlert:@"Sorry,no movie schedule is available at this time" title:@"Message" buttontitle:@"Ok"];
		}
	}
	else
		isNoData=YES;
	[tableMovie reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)errorCallback:(NSError *)error{
	[indicator_ stopAnimating];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageViewMovie.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];

}

#pragma mark - navigation

- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}


- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}


@end
