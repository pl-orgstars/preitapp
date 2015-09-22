//
//  JSBridgeViewController.h
//  JSBridge
//
//  Created by Dante Torres on 10-09-03.
//  Copyright Dante Torres 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBridgeWebView.h"
#import "GAITrackedViewController.h"
@interface JSBridgeViewController : GAITrackedViewController <JSBridgeWebViewDelegate> {

	IBOutlet JSBridgeWebView* webView;
	NSString *mapUrl;
}
@property(nonatomic,retain)NSString *mapUrl;

-(void) loadMaskPage;

@end

