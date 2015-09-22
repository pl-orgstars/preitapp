//
//  BeaconModel.h
//  Preit
//
//  Created by kuldeep on 1/23/15.
//
//

#import <Foundation/Foundation.h>
//#define your_app_id_MICRO  @"2738e4deb2b6d34d0b7630f19e166f2ba94d4ec843de282db0213f23d09c7c38";
//#define secret_MICRO @"0e21208592006d04af618e39c1e2b9724c87e5d6c3496014bd4b13e8267b6d80";
//#define callback_MICRO @"comr5ipreit://authcode";

#define secret_MICRO   @"6f2f850d8352674ea0005750534a50683c0b602237f63c68d3e55b311bd6a327";
#define your_app_id_MICRO @"3eb430894e8daa3f097f5f0763c7038e64c5484653b8d7a1cf264ecb562ec385";
#define callback_MICRO @"comr5ipreit://authcode";


#import <FYX/FYX.h>
#import <FYX/FYXLogging.h>
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXSightingManager.h>
#import <FYX/FYXTransmitter.h>
#import <FYX/FYXVisit.h>
#import "Transmitter.h"
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\

@interface BeaconModel : NSObject<FYXServiceDelegate, FYXVisitDelegate>
{
    NSMutableArray *transmitters;
    FYXVisitManager *visitManager;
    
    void(^callback)(BOOL hasdata, NSString *identifier);
}
-(void)initilizeBeaconWithCallBack:(void(^)(BOOL hasdata, NSString *identifier))completion;
-(void)removeBeaconSearch;
@end
