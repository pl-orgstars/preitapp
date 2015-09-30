//
//  EventsViewController.h
//  Preit
//
//  Created by Aniket on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"

@interface EventsViewController : SuperViewController<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate> {
	IBOutlet UITableView *tableEvents;
	IBOutlet UIImageView *imageView;
	//IBOutlet UIPickerView *pickerView;
	PreitAppDelegate *delegate;
	NSMutableArray *tableData;
	NSArray *pickerItem;
	BOOL isNoData;
	int monthSelected;
	int yearSelected;
    NSMutableArray *constArray;
	NSMutableArray *disclosureRow;
    NSMutableArray *array_section;
	IBOutlet UIActivityIndicatorView *indicator_;
}

@property (nonatomic) int tenantID;


-(void)setHeader;
-(void)getData:(NSString *)apiString;


@end
