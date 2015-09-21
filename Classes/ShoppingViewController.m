//
//  ShoppingViewController.m
//  Preit
//
//  Created by Aniket on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShoppingViewController.h"
#import "AsyncImageView.h"
#import "ShoppingIndexViewController.h"
#import "StoreSearchViewController.h"
#import "ProductListViewController.h"

@implementation ShoppingViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        delegate = (PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
        NSLog(@"initshopping");

        delegate.shoppingViewController = self;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.screenIndex=1;
    [super viewDidLoad];

	CGRect frame;
	frame.size.width=320;
	
    if(isIPhone5){ frame.size.height=586;}else{frame.size.height=480;};
	frame.origin.x=0; frame.origin.y=0;
	
	NSLog(@"iamge links %@",delegate.imageLink1);
	if(delegate.imageLink1 && [delegate.imageLink1 length]!=0)
	{
        NSLog(@"1");
		AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];// autorelease];
		NSURL *url=[NSURL URLWithString:delegate.imageLink1];
		[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];
	}
	NSLog(@"2");
	if(delegate.imageLink2 && [delegate.imageLink2 length]!=0)
	{
        NSLog(@"3");
		AsyncImageView* asyncImage2 = [[AsyncImageView alloc] initWithFrame:frame];// autorelease];
		NSURL *url2=[NSURL URLWithString:delegate.imageLink2];
		[asyncImage2 loadImageFromURL:url2 delegate:self requestSelector:@selector(responseData_Image2:)];
	}
    NSLog(@"4");
	if(delegate.imageLink3 && [delegate.imageLink3 length]!=0)
	{
        NSLog(@"5");
		AsyncImageView* asyncImage3 = [[AsyncImageView alloc] initWithFrame:frame];// autorelease];
		NSURL *url3=[NSURL URLWithString:delegate.imageLink3];
		[asyncImage3 loadImageFromURL:url3 delegate:self requestSelector:@selector(responseData_Image3:)];
	}
	
    NSLog(@"5");
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage1:) name:@"updateShopping_IMG" object:nil];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //kuldeep check
    [self tableView:tableView modified_didSelectRowAtIndexPath:indexPath];
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
	if([delegate checkImage:[UIImage imageWithData:receivedData]])
	{
		delegate.image1=[UIImage imageWithData:receivedData];
		imageView.image=delegate.image1;
	}
}

-(void)responseData_Image2:(NSData *)receivedData{
	if([delegate checkImage:[UIImage imageWithData:receivedData]])
	{
		delegate.image2=[UIImage imageWithData:receivedData];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"updateDining_IMG" object:nil];
	}
}

-(void)responseData_Image3:(NSData *)receivedData{
	if([delegate checkImage:[UIImage imageWithData:receivedData]])
	{
		delegate.image3=[UIImage imageWithData:receivedData];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];
	}
	
	if(!delegate.image1)
		imageView.image=delegate.image3;
}

-(void)updateImage1:(NSNotification *)notification
{
	imageView.image=delegate.image1;
}


-(void)searchAction:(id)sender {
    NSLog(@"searchAction");
    ProductListViewController *productListViewController = [[ProductListViewController alloc]initWithNibName:@"ProductListViewController" bundle:nil];
    [self.navigationItem setTitle:@"Back"];
    [self.navigationController pushViewController:productListViewController animated:YES];
    //kuldeep edit

}


-(void)         :(id)sender
{
	StoreSearchViewController *screenShoppingindex=[[StoreSearchViewController alloc]initWithNibName:@"StoreSearchViewController" bundle:nil];
	self.navigationItem.title=@"Back";
	[self.navigationController pushViewController:screenShoppingindex animated:YES];

	
}
@end
