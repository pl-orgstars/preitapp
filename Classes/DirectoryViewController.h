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
    
    PreitAppDelegate* delegate;
    NSMutableArray *listContent;
    NSMutableArray *filteredListContent;
    
    
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
//    NSMutableArray  *tempArray;
    NSMutableArray  *webViewArray;
    BOOL isNoData;
    UIView *main_view;
//    NSMutableArray  *indexArray;
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
