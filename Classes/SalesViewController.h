//
//  SalesViewController.h
//  Preit
//
//  Created by Aniket on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"

@interface SalesViewController : SuperViewController {
	IBOutlet UITableView *tableSales;
	IBOutlet UIImageView *imageView;
	int screenIndex;
	PreitAppDelegate *delegate;
	NSMutableArray *tableData;
	BOOL isNoData;
	IBOutlet UIActivityIndicatorView *indicator_;
	NSMutableArray *disclosureRow;
	NSMutableArray *webViewArray;
	NSURL *url_LinkClicked;
}

-(NSString *)getDateStringFrom:(NSString *)d1 toDate:(NSString *)d2;
-(void)setHeader;
-(void)getData;
@end
