//
//  MessagesView.m
//  Preit
//
//  Created by Jawad Ahmed on 10/14/15.
//
//

#import "MessagesView.h"
#import "PreitAppDelegate.h"

@implementation MessagesView

#pragma mark - Class Methods

- (void)awakeFromNib {
    tableView_.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    dataArray = [NSMutableArray new];
    
    PreitAppDelegate *del = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://preitmessage.r5i.com/api/messages?mall_id=%@", del.mallData[@"id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr = (NSArray *)responseObject;
        NSArray *read = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReadPropertyMessages"];
        
        if (arr.count > 0) {
            for (NSDictionary *dict in arr) {
                NSString *key = [NSString stringWithFormat:@"%@-%@", dict[@"property_id"], dict[@"id"]];
                if (![read containsObject:key]) {
                    [dataArray addObject:dict];
                }
            }
            
            if (dataArray.count > 0) {
                numberOfSections = 1;
                [tableView_ reloadData];
                self.frame = CGRectMake(10.0, 65.0, 300.0, 250.0);
            }
            else {
                [self removeFromSuperview];
            }
        }
        else {
            [self removeFromSuperview];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"localizedDescription %@", error.localizedDescription);
    }];
}

- (void)setDataArray:(NSArray *)array {
    [dataArray addObjectsFromArray:array];
}

#pragma mark - IBActions

- (IBAction)closeButtonAction:(UIButton *)sender {
    [self removeFromSuperview];
}

#pragma mark - TableView Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagesCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MessagesCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = dataArray[indexPath.row];
    cell.cellLabel.text = dict[@"message_text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = dataArray[indexPath.row];
    NSArray *read = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReadPropertyMessages"];
    NSString *key = [NSString stringWithFormat:@"%@-%@", dict[@"property_id"], dict[@"id"]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:read];
    [arr addObject:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"ReadPropertyMessages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
