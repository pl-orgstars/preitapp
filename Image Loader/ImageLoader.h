//
//  ImageLoader.h
//  CraigsPro2
//
//  Created by Ivan on 2/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@protocol ImageLoaderDelegate;

@interface ImageLoader : NSObject
{
	id <ImageLoaderDelegate> delegate;
	NSMutableData *receivedData;
	NSIndexPath *indexPath;
	CGFloat cellHeight;
    
    BOOL isFlag;
    
   
}

@property (nonatomic, retain) id <ImageLoaderDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property int tag;
@property CGFloat cellHeight;

@property BOOL isFlag;



-(void) loadImage:(NSString *)urlAddress;

-(UIImage *) thumbnailImageWithData:(NSData *)imgData;

@end


@protocol ImageLoaderDelegate <NSObject>
@required
-(void) imgLoader:(ImageLoader *)imgLoader processImage:(UIImage *)img indexPath:(NSIndexPath *)imgIndexPath;
@end
