//
//  BeaconViewController.h
//  Preit
//
//  Created by kuldeep on 1/13/15.
//
//

#import <UIKit/UIKit.h>
#import <FYX/FYX.h>
 #import <FYX/FYXVisitManager.h>
@interface BeaconViewController : UIViewController<FYXServiceDelegate,FYXVisitDelegate>

@property (nonatomic,copy) FYXVisitManager *visitManager;
@end
