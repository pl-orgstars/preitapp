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
//	self.navigationItem.title=NSLocalizedString(@"Screen7.1",@"");
    [self setNavigationTitle:NSLocalizedString(@"Screen7.1",@"") withBackButton:YES];
    
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
			timingString=[NSString stringWithFormat:@"%@ - %@",timingString,[movie_schedule_Dict objectForKey:@"scheduled_time"]];
		}
		labelTiming.text=timingString;
	}
	
	
	if(delegate.image3==nil)
	{
		imageView.image=[UIImage imageNamed:@"shopping.gif"];
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

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];

}

#pragma mark - navigation
- (IBAction)menuBtncall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}


- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
