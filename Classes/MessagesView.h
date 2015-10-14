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
    IBOutlet UITableView *tableView_;
    NSMutableArray *dataArray;
    
    NSInteger numberOfSections;
}

//- (void)setDataArray:(NSArray *)array;

@end
