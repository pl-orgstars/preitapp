//
//  MovieDetailViewController.m
//  Preit
//
//  Created by Aniket on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "AsyncImageView.h"

@implementation MovieDetailViewController
@synthesize movieData;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:NSLocalizedString(@"Screen7.1",@"") withBackButton:YES];
    NSLog(@"movieData %@",movieData);
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	NSDictionary *movieDetails=[[movieData objectForKey:@"movie"]objectForKey:@"movie"];
	labelName.text=[movieDetails objectForKey:@"title"];
	textViewDesc.text=[movieDetails objectForKey:@"description"];
	labelType.text=[movieDetails objectForKey:@"genre"];	

	NSArray *tmpArray=[movieData objectForKey:@"timing"];
	if([tmpArray count])
	{
		NSDictionary *movie_schedule_Dict_0=[[tmpArray objectAtIndex:0]objectForKey:@"movie_schedule_time"];
		
		NSString *timingString=[movie_schedule_Dict_0 objectForKey:@"scheduled_time"];
		
		for(int i=1;i<[tmpArray count];i++)
		{
			NSDictionary *movie_schedule_Dict=[[tmpArray objectAtIndex:i]objectForKey:@"movie_schedule_time"];
			timingString=[NSString stringWithFormat:@"%@ \n%@",timingString,[movie_schedule_Dict objectForKey:@"scheduled_time"]];
		}
		labelTiming.text=timingString;
	}
	
    AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:imageView.frame] ;
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://redf.tmsimg.com/%@",movieDetails[@"poster"]]];
    [asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}



-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image3;
    [activityIndicator stopAnimating];

}

#pragma mark - navigation
- (IBAction)menuBtncall:(id)sender
{
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}


- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
