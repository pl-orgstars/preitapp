//
//  DetailAsyncImageVIew.m
//  Preit
//
//  Created by sameer on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailAsyncImageVIew.h"

@implementation DetailAsyncImageVIew

@synthesize productIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


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
        
		[delegate performSelector:self.callback withObject:[NSDictionary dictionaryWithObjectsAndKeys:self,@"imgView",data,@"imgData", nil]];
	}
    
	UIImageView *imageView= [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] ;//autorelease];
	
	//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
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

@end
