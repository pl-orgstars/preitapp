//
//  AsyncImageView.h
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImageView : UIView {
	//could instead be a subclass of UIImageView instead of UIView, depending on what other features you want to 
	// to build into this class?

	NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data; //keep reference to the data so we can collect it as it downloads
	//but where is the UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class

	id	delegate;
	SEL	callback;
	SEL	errorCallback;
}

@property(nonatomic, retain) id	delegate;
@property(nonatomic) SEL callback;

//- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;
- (void)loadImageFromURL:(NSURL*)url delegate:(id)requestDelegate requestSelector:(SEL)requestSelector;

- (void) setImage2:(NSData*)imgData;

@end
