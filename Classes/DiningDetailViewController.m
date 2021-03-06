    //
//  DiningDetailViewController.m
//  Preit
//
//  Created by Aniket on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DiningDetailViewController.h"
#import "AsyncImageView.h"

@implementation DiningDetailViewController




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
	[self setNavigationTitle:NSLocalizedString(@"Screen2.1",@"") withBackButton:YES];
    
	
	if(delegate.image2==nil)
	{
		
		if(delegate.imageLink2 && [delegate.imageLink2 length]!=0)
		{
			CGRect frame;
			frame.size.width=320;
            
			if(isIPhone5){frame.size.height=586;}else{frame.size.height=480;}
			frame.origin.x=0; frame.origin.y=0;
			AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];// autorelease];
			NSURL *url=[NSURL URLWithString:delegate.imageLink2];
			[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
		
		}
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




-(void)responseData_Image:(NSData *)receivedData{
	delegate.image2=[UIImage imageWithData:receivedData];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateDining_IMG" object:nil];

}
-(void)setDefaultThumbnail
{
	image_thumbNail.image=[UIImage imageNamed:@"whineglass.png"];
}

@end
