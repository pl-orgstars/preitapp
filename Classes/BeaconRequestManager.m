//
//  BeaconRequestManager.m
//  Preit
//
//  Created by kuldeep on 1/23/15.
//
//

#import "BeaconRequestManager.h"
#import "PreitAppDelegate.h"
#import "RequestAgent.h"
#import "JSON.h"
#import "UIAlertView+Blocks.h"
@implementation BeaconRequestManager


-(void)addingNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
}
-(void)intWithUrl:(NSString *)url
{
    
    
    RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
    

}
-(void)responseData:(NSData *)receivedData{

 if(receivedData!=nil)
    {
        beaconArray = [NSMutableArray new];
        
        NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
        
        id objectreponse = [jsonString JSONValue];
        NSArray *tmpArray;
        if ([objectreponse isKindOfClass:[NSDictionary class]]) {
            tmpArray = [[NSArray alloc]initWithObjects:objectreponse, nil];
        }else{
            tmpArray = objectreponse;
        }
        
        NSLog(@"tmpArray==%@",tmpArray);
        //		[self.tableData removeAllObjects];
        beaconArray = [NSMutableArray arrayWithArray:tmpArray];
        [self updatingBeacondata];
        [self initilizeBeacon];
        
        
    }
    
}

-(void)updatingBeacondata{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    for(NSDictionary *dict in beaconArray){
        NSDictionary *beaconDict = [dict objectForKeyWithNullCheck:@"ibeacon"];
        NSString *beacon_msg=[beaconDict objectForKeyWithNullCheck:@"message"];
        NSString *beacond_id=[beaconDict objectForKeyWithNullCheck:@"beacon_id"];
        if(![beacon_msg isEqualToString:[defaults valueForKey:beacond_id]]){
            [defaults removeObjectForKey:beacond_id];
    
        }
    
    }
}


-(void)errorCallback:(NSError *)error{
    
}

#pragma mark BEACON initilize

-(void)initilizeBeacon{
    if (!beacon) {
        beacon = [[BeaconModel alloc]init];
    }
    
   
    __block NSString *iden;
    [beacon initilizeBeaconWithCallBack:^(BOOL hasdata, NSString *identifier) {
        iden=identifier;
   // [self showMesage:identifier title:@"identifier"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:identifier forKey:@"identifier"];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"TestNotification"
         object:nil userInfo:userInfo];
        
    }];
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    NSDictionary *userInfo = notification.userInfo;
    BOOL flag=false;
    NSString *beaconmsg;
    if ([[notification name] isEqualToString:@"TestNotification"])
        
        for(NSDictionary *dict in beaconArray)
        {
            NSDictionary *beaconDict = [dict objectForKeyWithNullCheck:@"ibeacon"];
            beaconmsg=[beaconDict objectForKeyWithNullCheck:@"message"];
            NSString *beacond_id=[beaconDict objectForKeyWithNullCheck:@"beacon_id"];
            
            NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
            if([[userInfo valueForKey:@"identifier"] isEqualToString:beacond_id] && ![[[defaults dictionaryRepresentation] allKeys] containsObject:beacond_id]){
                flag=true;
                [self showMesage:beaconmsg title:beacond_id];
                
                [[NSUserDefaults standardUserDefaults] setValue:[beaconDict objectForKeyWithNullCheck:@"message"] forKey:[beaconDict objectForKeyWithNullCheck:@"beacon_id"]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [beaconArray removeObject:dict];
                break;
            }
        }

}


-(void)removeRequestManager{
    if (beacon) {
        [beacon removeBeaconSearch];
    }
    [beaconArray removeAllObjects];
//    beacon = nil;
//    beaconArray = nil;
}
-(void)showMesage:(NSString *)message title:(NSString *)title{
    
    PreitAppDelegate *delegate = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
//    
//    
    //[delegate setlocationNotifcation];
    [delegate showLocalNotificationsWithMessage:message :title];
    
}
@end
