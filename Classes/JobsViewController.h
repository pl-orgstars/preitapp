//
//  JobsViewController.h
//  Preit
//
//  Created by Aniket on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"

@interface JobsViewController : BaseViewController
{
	IBOutlet UITableView *tableJobs;
	IBOutlet UIImageView *imageView;
	PreitAppDelegate *delegate;
	NSMutableArray *tableData;
	BOOL isNoData;
}

-(void)setHeader;
-(void)getData;
@end
