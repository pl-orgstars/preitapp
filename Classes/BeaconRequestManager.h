//
//  BeaconRequestManager.h
//  Preit
//
//  Created by kuldeep on 1/23/15.
//
//

#import <Foundation/Foundation.h>
#import "BeaconModel.h"
@interface BeaconRequestManager : NSObject
{
    BeaconModel *beacon;
    
    NSMutableArray *beaconArray;
}
-(void)intWithUrl:(NSString *)url;

-(void)removeRequestManager;
-(void)addingNotification;
@end
