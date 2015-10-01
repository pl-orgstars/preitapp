//
//  CustomTable.h
//  Preit
//
//  Created by Aniket on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"


@interface CustomTable : SuperViewController  <UISearchBarDelegate>{
	IBOutlet UITableView *tableCustom;
	IBOutlet UIImageView *imageView;
	int screenIndex;
	PreitAppDelegate *delegate;
	NSMutableArray *tableData;
    NSString *heading;
	BOOL isNoData;
	NSString *apiString;
	IBOutlet UIActivityIndicatorView *indicator_;
	NSMutableArray *disclosureRow;
    
    
    IBOutlet UISearchBar* searchBar_;
    
    NSArray* downloadedData;
    
    
}
@property(nonatomic,retain) IBOutlet UILabel* titleLabel;


@property(nonatomic,retain) UITableView *tableCustom;;
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain)PreitAppDelegate *delegate;
@property(nonatomic)int screenIndex;
@property(nonatomic,retain)NSMutableArray *tableData;
@property(nonatomic,retain)NSString *heading;
@property(nonatomic,retain)NSString *apiString;
@property(nonatomic,retain)NSMutableArray *disclosureRow;

-(void)setHeader;
-(void)getData;
- (void)tableView_:(UITableView *)tableView modified_cellForRowAtIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell*)cell;
- (void)tableView:(UITableView *)tableView modified_didSelectRowAtIndexPath:(NSIndexPath *)indexPath ;
@end
