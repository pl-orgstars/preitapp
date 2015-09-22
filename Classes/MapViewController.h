//
//  MapViewController.h
//  Preit
//
//  Created by Aniket on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MapViewController : SuperViewController {
	IBOutlet UIWebView *webView;
	NSString *mapUrl;
}
@property(nonatomic,retain)NSString *mapUrl;

-(void)mapX:(float)x Y:(float)y;

@end
