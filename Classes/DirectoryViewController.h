//
//  DirectoryViewController.h
//  Preit
//
//  Created by Noman iqbal on 9/23/15.
//
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"
#import "RequestAgent.h"
#import "DirectoryTableViewCell.h"
#import "StoreDetailsViewController.h"

@interface DirectoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    IBOutlet UISearchBar* searchBar_;
    IBOutlet UITableView* tableView_;
    IBOutlet UITableView* filterTableView;
    
    UIActivityIndicatorView* indicator;
    
    PreitAppDelegate* delegate;
    
    NSMutableArray *listContent;
    NSMutableArray *searchedListContent;
    
    NSMutableArray *filterCategories;
    
    
    
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    NSMutableArray  *webViewArray;
    BOOL isNoData;
    UIView *main_view;
    NSMutableDictionary *checkDict;
    
    BOOL filterTableOnFront;
}

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *searchedListContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
-(void)getData;
-(void)makeLoadingView;
-(void)loadingView:(BOOL)flag;

@end
