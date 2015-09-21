//
//  EventsViewController.h
//  Preit
//
//  Created by Aniket on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"

@interface EventsViewController : SuperViewController<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {
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
	IBOutlet UIActivityIndicatorView *indicator_;
}

-(IBAction)buttonAction:(id)sender;
-(void)setHeader;
-(void)getData:(NSString *)apiString;
//-(void)pickerShow:(BOOL) flag;
@end
