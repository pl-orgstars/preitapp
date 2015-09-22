//
//  MovieListingViewController.h
//  Preit
//
//  Created by Aniket on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"

//kk
@interface MovieListingViewController : BaseViewController {
	IBOutlet UITableView *tableMovie;
	IBOutlet UIImageView *imageViewMovie;
	PreitAppDelegate *delegate;
	NSMutableArray *tableData;
	BOOL isNoData;
	IBOutlet UIActivityIndicatorView *indicator_;
}
-(void)setHeader;
-(void)getData;
@end
