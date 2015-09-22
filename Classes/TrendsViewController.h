//
//  TrendsViewController.h
//  Preit
//
//  Created by Aniket on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"

@interface TrendsViewController : UIViewController {
	IBOutlet UITableView *tableTrends;
	IBOutlet UIImageView *imageViewMovie;
	PreitAppDelegate *delegate;
	NSMutableArray *tableData;
	BOOL isNoData;
	IBOutlet UIActivityIndicatorView *indicator_;
}
-(void)setHeader;
-(void)getData;
@end
