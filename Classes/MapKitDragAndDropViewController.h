//
//  MapKitDragAndDropViewController.h
//  MapKitDragAndDrop
//
//abhi
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import "Event.h"
#import "ParkScreenViewController.h"
#import "MyCLController.h"
@interface MapKitDragAndDropViewController : BaseViewController <MKMapViewDelegate,MyCLControllerDelegate> {
	MKMapView *mapView;
    NSString *destinationStr;

        __weak IBOutlet UIButton *leftBttn;
        __weak IBOutlet UIButton *rightBttn;

}
@property (nonatomic, weak) ParkScreenViewController *parkingScreen;
@property (nonatomic,readwrite) BOOL isEdit;
@property (nonatomic,readwrite) CLLocationCoordinate2D loc;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic,copy) void(^callback)(NSString*destination,CLLocationCoordinate2D loc,BOOL isSaved);
@property (nonatomic,readwrite) BOOL checkinFlag;
//@property(nonatomic,weak)Event *event;
@property(nonatomic,strong)UIImage *eventImage;

-(IBAction)done;
-(IBAction)back;
@end

