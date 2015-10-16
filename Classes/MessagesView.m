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
    
}

- (void)showInView:(UIView *)parentView {
    parentView_ = parentView;
    tableView_.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    overallMessages = [NSMutableArray new];
    propertyMessages = [NSMutableArray new];
    
    PreitAppDelegate *delegate = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *votigoUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
    
    double destinationLat = [delegate.mallData[@"location_lat"] doubleValue];
    double destinationLong = [delegate.mallData[@"location_lng"] doubleValue];
    
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:destinationLat longitude:destinationLong];
    CLLocation *current = [[CLLocation alloc] initWithLatitude:delegate.latitude longitude:delegate.longitude];
    
    CLLocationDistance distance = [current distanceFromLocation:destination];
    if (distance >= 1609 && votigoUserID) //1609 meters = 1 mile
    {
        [self getPropertyMessages];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSDictionary *params = @{@"mall_id" : delegate.mallData[@"id"],
//                                 @"udid" : votigoUserID};
//        
//        [manager GET:@"http://preitmessage.r5i.com/api/messages" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [dataArray addObjectsFromArray:responseObject];
//            
//            if (dataArray.count > 0) {
//                [tableView_ reloadData];
//                
//                self.frame = CGRectMake(10.0, 65.0, self.frame.size.width, self.frame.size.height);
//                [parentView addSubview:self];
//                [parentView bringSubviewToFront:self];
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"localizedDescription %@", error.localizedDescription);
//        }];
    }
    else {
        NSLog(@"Should Not Add");
    }
}

- (void)getOverallMessages {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"preitmessage.r5i.com/api/messages/overall_message" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [overallMessages addObjectsFromArray:(NSArray *)responseObject];
        [self getPropertyMessages];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"localizedDescription %@", error.localizedDescription);
    }];
}

- (void)getPropertyMessages {
    PreitAppDelegate *delegate = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *votigoUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
    
    NSDictionary *params = @{@"mall_id" : delegate.mallData[@"id"],
                             @"udid" : votigoUserID};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://preitmessage.r5i.com/api/messages" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [propertyMessages addObjectsFromArray:responseObject];
        
        if (overallMessages.count > 0 || propertyMessages.count > 0) {
            [tableView_ reloadData];

            self.frame = CGRectMake(10.0, 65.0, self.frame.size.width, self.frame.size.height);
            [parentView_ addSubview:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"localizedDescription %@", error.localizedDescription);
    }];
}

- (void)markAsReadMessage:(NSIndexPath *)indexPath {
    NSDictionary *dict;
    if (overallMessages.count > 0 && propertyMessages.count > 0) {
        if (indexPath.section == 0)
            dict = overallMessages[indexPath.row];
        else
            dict = propertyMessages[indexPath.row];
    }
    else if (overallMessages.count == 0 && propertyMessages.count > 0) {
        dict = propertyMessages[indexPath.row];
    }
    else if (overallMessages.count > 0 && propertyMessages.count == 0) {
        dict = overallMessages[indexPath.row];
    }
    
    NSString *votigoUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"votigoUserID"];
    NSDictionary *params = @{@"property_message_id" : [dict objectForKey:@"id"],
                             @"udid" : votigoUserID};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://preitmessage.r5i.com/api/user_infos" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response = %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error.localizedDescription);
    }];
}

#pragma mark - IBActions

- (IBAction)closeButtonAction:(UIButton *)sender {
    [self removeFromSuperview];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (overallMessages.count > 0 && propertyMessages.count > 0)
        return 2;
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (overallMessages.count > 0 && propertyMessages.count > 0) {
        if (section == 0)
            return @"Overall Messages";
        else
            return @"Property Messages";
    }
    else if (overallMessages.count == 0 && propertyMessages.count > 0) {
        return @"Property Messages";
    }
    else if (overallMessages.count > 0 && propertyMessages.count == 0) {
        return @"Overall Messages";
    }
    else {
        return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (overallMessages.count > 0 && propertyMessages.count > 0) {
        if (section == 0)
            return overallMessages.count;
        else
            return propertyMessages.count;
    }
    else if (overallMessages.count == 0 && propertyMessages.count > 0) {
        return propertyMessages.count;
    }
    else if (overallMessages.count > 0 && propertyMessages.count == 0) {
        return overallMessages.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagesCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MessagesCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict;
    if (overallMessages.count > 0 && propertyMessages.count > 0) {
        if (indexPath.section == 0)
            dict = overallMessages[indexPath.row];
        else
            dict = propertyMessages[indexPath.row];
    }
    else if (overallMessages.count == 0 && propertyMessages.count > 0) {
        dict = propertyMessages[indexPath.row];
    }
    else if (overallMessages.count > 0 && propertyMessages.count == 0) {
        dict = overallMessages[indexPath.row];
    }
    
    cell.cellLabel.text = dict[@"message_text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self markAsReadMessage:indexPath];
}

@end
