//
//  MessagesView.h
//  Preit
//
//  Created by Jawad Ahmed on 10/14/15.
//
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MessagesCell.h"

@interface MessagesView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UIView *parentView_;
    IBOutlet UITableView *tableView_;
    
    NSString *UDID;
    NSMutableArray *overallMessages;
    NSMutableArray *propertyMessages;
    
    NSInteger numberOfSections;
}

- (void)showInView:(UIView *)parentView;

//- (void)setDataArray:(NSArray *)array;

@end
