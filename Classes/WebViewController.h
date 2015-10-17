//
//  WebViewController.h
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"


@interface WebViewController : BaseViewController <UIWebViewDelegate>{
	IBOutlet UIWebView *webView,*webView1;
	IBOutlet UIActivityIndicatorView *indicator;
	IBOutlet UIImageView *imageView;
	PreitAppDelegate *delegate;
	NSString *urlString;
	NSString *htmlString;
	NSString *titleString;
	NSDictionary *tmpdict;
	int screenIndex;
	IBOutlet UILabel *lab1,*lab2;
    
    
    NSMutableArray *arrayTable;
    
    
    IBOutlet UITableView *tbleViewHours;
    
}


@property(nonatomic,retain) IBOutlet UILabel* titleLabel;
@property(nonatomic,retain) NSDictionary *tmpdict;
@property(nonatomic,retain) NSString *urlString;
@property(nonatomic,retain) NSString *htmlString;
@property(nonatomic,retain) NSString *titleString;
@property(nonatomic) BOOL isHours;

@property(nonatomic) int screenIndex;
-(void)setHeader;
- (void)callWebPage;
-(void)loadHtml:(NSDictionary *)dict;
@end