//
//  AsyncImageView.m
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "QuartzCore/QuartzCore.h"


@implementation AsyncImageView
@synthesize delegate,callback;




- (void)loadImageFromURL:(NSURL*)url delegate:(id)requestDelegate requestSelector:(SEL)requestSelector{
	delegate=requestDelegate;
	self.callback=requestSelector;
	
	
	if (connection!=nil) {connection =nil; }//[connection release]; } //in case we are downloading a 2nd image
	if (data!=nil) {data = nil; }//[data release]; }
	myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	myIndicator.center = self.center;
	[myIndicator startAnimating];
//    self.image = [[UIImage alloc]init];
	
	myIndicator.hidesWhenStopped = NO;
	
	[self addSubview:myIndicator];
	
	[self setNeedsLayout];
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
	//TODO error handling, what if connection is nil?
}


//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
}

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
//	[connection release];
	connection=nil;
	if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
	}
	
	//make an image view for the image
	
	if([delegate respondsToSelector:self.callback]) {
		[delegate performSelector:self.callback withObject:data];
	}

	UIImageView *imageView= [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] ;//autorelease];
    [myIndicator stopAnimating];
    myIndicator.hidden = TRUE;
	//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
//	CALayer *l = [imageView layer];
//	[l setMasksToBounds:YES];
//	[l setCornerRadius:5.0];
//	[self addSubview:imageView];
//	imageView.frame = self.bounds;
	
	[imageView setNeedsLayout];
	[self setNeedsLayout];
	
//	[data release]; //don't need this any more, its in the UIImageView now
	data=nil;
}

-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
//	[connection release];
	connection=nil;

	if([delegate respondsToSelector:self.callback]) {
		[delegate performSelector:self.callback withObject:nil];
	}
}

//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	//NSLog(@"::::::::::::::::::::::::");
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	//NSLog(@"::::::::::::::::::::::::");
	return [iv image];
}

- (void) setImage:(UIImage*)img {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	iv.image=img;
}

- (void) setImage2:(NSData*)imgData {
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    UIImage *img = [UIImage imageWithData:imgData];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    [imageView setTag:100];
    [imageView setImage:img];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView];
    [self setBackgroundColor:[UIColor whiteColor]];
    
//    [imageView release];
}
- (void) setImageNew:(NSData*)imgData WithFrame:(float)xPoint
{
    UIImage *img = [UIImage imageWithData:imgData];
    CGRect rect = self.frame;
    rect.origin.x = xPoint - self.frame.origin.x;
    rect.origin.y = 0;
    if ( img.size.height > 280)
    {
        rect.size.height = 280;
        
    }else
    {
        rect.size.width = img.size.width;
        rect.size.height = img.size.height;

    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.backgroundColor = [UIColor yellowColor];
    [imageView setTag:100];
    [imageView setImage:img];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView];
    [self setBackgroundColor:[UIColor clearColor]];
    
    //    [imageView release];
}

@end
