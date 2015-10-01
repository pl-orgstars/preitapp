//
//  MovieDetailViewController.h
//  Preit
//
//  Created by Aniket on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"


@interface MovieDetailViewController : BaseViewController <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate> {
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *labelName;
	IBOutlet UITextView *textViewDesc;
	IBOutlet UILabel *labelType;
	NSDictionary *movieData;
//	IBOutlet UITextView *labelTiming;
	PreitAppDelegate *delegate;
    
    
    IBOutlet UITableView *tbleViewMain;
    
    NSMutableArray *arrayTable;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    
}
@property(nonatomic,retain) NSDictionary *movieData;
@end
