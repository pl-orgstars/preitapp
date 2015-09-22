//
//  ShoppingIndexViewController.h
//  Preit
//
//  Created by Aniket on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OverlayViewController;

@interface ShoppingIndexViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
	UISearchBar *searchBar;
	BOOL searching;
	BOOL letUserSelectRow;
	
	OverlayViewController *ovController;
}
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end