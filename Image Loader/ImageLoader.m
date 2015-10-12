//
//  ImageLoader.m
//  CraigsPro2
//
//  Created by Ivan on 2/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageLoader.h"

// max image size, 200k (WAS 25k)
#define MAX_IMG_SIZE 2000000000000000
CGFloat MAX_IMG_W = 74.;
CGFloat MAX_IMG_H = 64.;

@implementation ImageLoader

@synthesize delegate;
@synthesize indexPath;
@synthesize cellHeight;
@synthesize isFlag;
@synthesize tag;


- (id) init {
	if ((self = [super init])) {
		delegate = nil;
		receivedData = nil;
		cellHeight = 13.;
	}
	return self;
}




-(void) loadImage:(NSString *)urlAddress {
	// create an URL request
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
												cachePolicy:NSURLRequestUseProtocolCachePolicy
											timeoutInterval:30.0];
	[urlRequest setValue:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_7; en-us) AppleWebKit/533.4 (KHTML, like Gecko) Version/4.1 Safari/533.4" forHTTPHeaderField:@"User-Agent"];
	
	// send the URL request :: ASYNCHRONOUS
	NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest 
																	 delegate:self];
	
	if (urlConnection) 
		receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse

    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
	if (receivedData != nil) 
		[receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
	if (receivedData != nil) 
		[receivedData appendData:data];
	
//	if ([receivedData length] > MAX_IMG_SIZE) {
//		//NSLog(@"*** SKIPPING TOO BIG IMAGE ***"); 
//		if (self.delegate)
//			[self.delegate imgLoader:self
//						processImage:nil
//						   indexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
//
//		[connection cancel];
//		[receivedData release];
//		receivedData = nil;
//		[connection release];
//	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
   

	if (self.delegate)
		[self.delegate imgLoader:self
					processImage:nil
					   indexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
	
    // inform the user
    //NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	//NSLog(@"finish");
	if (receivedData != nil) {
		if (self.delegate) {
                [self.delegate imgLoader:self
                            processImage:[UIImage imageWithData: receivedData]
                               indexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
		}
		
		// release the connection, and the data object
		
		receivedData = nil;
	}
   
}


-(UIImage *) thumbnailImageWithData:(NSData *)imgData { 
	//NSLog(@"making image");
	UIImage *sourceImg = [UIImage imageWithData:imgData];
    
//    UIImageWriteToSavedPhotosAlbum(sourceImg, self, nil, nil);
//	return sourceImg;
	CGFloat targetHeight = -1., targetWidth = -1.;
	if ((sourceImg.size.width > 10.) && (sourceImg.size.width >= sourceImg.size.height/3.) && (sourceImg.size.height >= sourceImg.size.width/3.)) {
		targetHeight = MAX_IMG_H;
		if (targetHeight < 1) 
			targetHeight = 1;
		targetWidth = targetHeight * sourceImg.size.width / sourceImg.size.height;
		
		// too long image
		if (targetWidth > MAX_IMG_W) {
			CGFloat new_i_h = targetHeight * MAX_IMG_W / targetWidth;
			targetHeight = new_i_h;
			targetWidth = MAX_IMG_W;
		}
	}
	if ((targetHeight <= 1.) || (targetHeight <= 1.))
		return nil;
	
	CGImageRef imageRef = [sourceImg CGImage];
	if (!imageRef) 
		return nil;
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	if (!colorSpaceInfo) 
		return nil;
	
	if ((bitmapInfo == kCGImageAlphaNone) || (bitmapInfo == kCGImageAlphaLast)) //vx6
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	
	CGContextRef bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), 
												0, colorSpaceInfo, bitmapInfo);
	if (!bitmap)
		return nil;
	CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return newImage; 
}


@end
