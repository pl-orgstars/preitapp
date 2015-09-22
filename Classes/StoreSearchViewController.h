//
//  StoreSearchViewController.h
//  Preit
//
//  Created by Aniket on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"


@interface StoreSearchViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>
{
	PreitAppDelegate *delegate;
	NSMutableArray  *listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
	NSMutableArray  *tempArray;
	NSMutableArray  *webViewArray;
	BOOL isNoData;
	UIView *main_view;
	NSMutableArray  *indexArray;
	NSMutableDictionary *checkDict;
}

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
-(void)getData;
-(void)makeLoadingView;
-(void)loadingView:(BOOL)flag;

@end