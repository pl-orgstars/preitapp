//
//  MapKitDragAndDropViewController.m
//  MapKitDragAndDrop
//
//abhi
//

#import "MapKitDragAndDropViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "PreitAppDelegate.h"

#define SELECTED_TITLE(value) !value?@"Save":@"Delete"
//#import "REVClusterAnnotationView.h"
@interface MapKitDragAndDropViewController ()
- (void)coordinateChanged_:(NSNotification *)notification;
@end

@implementation MapKitDragAndDropViewController
{
    MyCLController *locationController;
    PreitAppDelegate *appdelegate;
}
@synthesize mapView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    appdelegate = (PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"kkkkkk %@",appdelegate.mallData);
	
    mapView.showsUserLocation=YES;
    
//	theCoordinate.latitude = 37.810000;
//    theCoordinate.longitude = -122.477989;
    
    
    
   
}


- (void)viewWillAppear:(BOOL)animated
{
	
	[super viewWillAppear:animated];
	
    [rightBttn setTitle:SELECTED_TITLE(_isEdit) forState:UIControlStateNormal];
    
    if (_isEdit) {
        [self performSelector:@selector(getMallLocation) withObject:nil afterDelay:0.2];
    }else{
        [self performSelector:@selector(getCurrentLocation) withObject:nil afterDelay:0.2];
        
//        [self getCurrentLocation];
    }
    
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	
	[super viewWillDisappear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];	
}

-(void)getMallLocation{
    
//    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([[appdelegate.mallData objectForKey:@"location_lat"]floatValue], [[appdelegate.mallData objectForKey:@"location_lng"]floatValue]);
    

    int distances = 0;
    [mapView setRegion:MKCoordinateRegionMakeWithDistance(_loc,distances,distances) animated:YES];
    
//    [mapView setCenterCoordinate:_loc animated:YES];
    
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:_loc addressDictionary:nil];
    
    //@"Drag to Move Pin";
    //	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	[self getLocationName:[[CLLocation alloc]initWithLatitude:_loc.latitude longitude:_loc.longitude] annotation:annotation];
    [self.mapView addAnnotation:annotation];
}
-(void)getCurrentLocation{
    if(CLLocationManager.locationServicesEnabled)
    {
        
        locationController = [[MyCLController alloc] init];
        locationController.delegate = self;
        [locationController.locationManager startUpdatingLocation];
    }
    else
    {
        //            You have disabled location services for this app. If you'd like to take advantage of this app's location services in the future, please enable them in the Settings application
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your Location services are disabled.Please enable location services from the Settings application by toggling the Location Services switch in General or continue without using location?" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Ok",nil];
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You have disabled location services for this app. If you'd like to take advantage of this app's location services in the future, please enable them in the Settings application" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Ok",nil];
        [alert show];
        //			[alert release];
    }
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.mapView.delegate = nil;
	self.mapView = nil;
}

- (void)dealloc
{
	mapView.delegate = nil;
//	[mapView release];
//    [super dealloc];
}

#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification
{
	
//	DDAnnotation *annotation = notification.object;
//	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
    
	if (newState == MKAnnotationViewDragStateEnding)
    {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
        _loc = annotation.coordinate;
        
        
//        [appdelegate  showAlert:@"" title:[NSString stringWithFormat:@"la %f lon%f",annotation.coordinate.latitude,annotation.coordinate.longitude] buttontitle:@""];
//		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
        [self getLocationName:[[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude] annotation:annotation];
//        [annotationView.annotation setCoordinate:annotationView.annotation.coordinate];
        [annotationView setDragState:MKAnnotationViewDragStateNone];
//        if (_eventImage) {
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//            imageView.image = _eventImage;
//            [annotationView addSubview:imageView];
//        }
	}
    _isEdit = NO;
    [rightBttn setTitle:SELECTED_TITLE(_isEdit) forState:UIControlStateNormal];
//    if (_eventImage) {
//        [annotationView setImage:_eventImage];
//    }
}

-(void)getLocationName:(CLLocation*)location annotation:(DDAnnotation*)ann {
    __weak id weakself = self;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       NSLog(@"placemark.ISOcountryCode =%@",placemark.ISOcountryCode);
                       NSLog(@"placemark.country =%@",placemark.country);
                       NSLog(@"placemark.postalCode =%@",placemark.postalCode);
                       NSLog(@"placemark.administrativeArea =%@",placemark.administrativeArea);
                       NSLog(@"lat %f  long %f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
                       NSLog(@"placemark.name =%@",placemark.name);
                       NSLog(@"placemark.locality =%@",placemark.locality);
                       NSLog(@"placemark.Thoroughfare =%@",placemark.thoroughfare);
                       NSLog(@"placemark.subLocality =%@",placemark.subLocality);
                       
                       if (_checkinFlag) {
                           if (placemark.name != nil) {
                               [ann setTitle:placemark.name];
                               [weakself setDest:placemark.name];
                           } else if (placemark.thoroughfare != nil) {
                               if (placemark.subThoroughfare == nil) {
                                   [ann setTitle:placemark.thoroughfare];
                                   [weakself setDest:placemark.thoroughfare];
                               } else {
                                   NSString *add = [NSString stringWithFormat:@"%@, %@",placemark.subThoroughfare,placemark.thoroughfare];
                                   [ann setTitle:add];
                                   [weakself setDest:add];
                               }
                           } else {
                               [ann setTitle:placemark.locality?placemark.locality:@" "];
                               [weakself setDest:placemark.locality?placemark.locality:@" "];
                           }
                       } else {
                           if (placemark.locality == nil) {
                               [ann setTitle:placemark.administrativeArea?placemark.administrativeArea:@" "];
                               [weakself setDest:placemark.administrativeArea?placemark.administrativeArea:@" "];
                           } else {
                               [ann setTitle:placemark.locality];
                               [weakself setDest:placemark.locality];
                           }
                       }
//                       [self.mapView removeAnnotations:[self.mapView annotations]];
//                       [self.mapView addAnnotation:ann];
                   }];
}

//- (MKAnnotationView *)annotationView
//{
//    if (!annotationView) {
//        id <MKAnnotation> annotation = [self point];
//        if (annotation) {
//            MKAnnotationView *pin =
//            [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
//            pin.canShowCallout = YES;
//            annotationView = pin;
//        }
//    }
//    return annotationView;
//}
- (MKAnnotationView *)mapView:(MKMapView *)mapViews viewForAnnotation:(id <MKAnnotation>)annotation
{
	
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;		
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
    MKPinAnnotationView *draggablePinView;

    draggablePinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
//    [annotation annotationView]

	if (draggablePinView)
    {
		draggablePinView.annotation = annotation;
	} else
    {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
//		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:mapViews];
		
        
        draggablePinView =
        [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier];
//        [[MKAnnotationView alloc] initWithAnnotation:annotation
//                                             reuseIdentifier:kPinAnnotationIdentifier] ;
        
//        draggablePinView.image = _eventImage;//[UIImage imageNamed:@"cluster1.png"];
        draggablePinView.draggable = YES;
        draggablePinView.canShowCallout = YES;
        [draggablePinView setDraggable:YES];
        draggablePinView.animatesDrop = YES;
//        draggablePinView.an = YES;


        
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]])
        {
			// draggablePinView is DDAnnotationView on iOS 3.
		} else
        {
			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
		}
	}		
//	if (_eventImage) {
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        imageView.image = _eventImage;
//        [draggablePinView addSubview:imageView];
//        draggablePinView.image = _eventImage;
    
//    }
	return draggablePinView;
}

-(void)setDest:(NSString*)des {
    destinationStr = des;
}

-(IBAction)done {
//    NSLog(@"sdsadaskdhaksdhajksdhkuas %@",_event);
    if (_isEdit) {
        _isEdit = NO;
        
        REMOVE_PARK_LOCATION;
        _callback(nil,_loc,NO);
       [self performSelector:@selector(getCurrentLocation) withObject:nil afterDelay:0.2];
        [Parking storeParkingMapImage:nil];
    }else{
         _isEdit = YES;
       _callback(destinationStr,_loc,YES);
        UIGraphicsBeginImageContext(self.mapView.bounds.size);
        [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
        [Parking storeParkingMapImage:mapImage];
    }
    [rightBttn setTitle:SELECTED_TITLE(_isEdit) forState:UIControlStateNormal];
    return;
    
    if (self.checkinFlag) {
//        self.event.latitude = _loc.latitude;
//        self.event.longitude = _loc.longitude;
//        self.event.place = destinationStr;
////        self.event.sharedWith = NONE;
//        CheckinShareViewController *viewCntr = [[CheckinShareViewController alloc]initWithNibName:NSStringFromClass([CheckinShareViewController class]) bundle:nil];
//        viewCntr.event = self.event;
//        [self.navigationController pushViewController:viewCntr animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delgatemethod
- (void)locationUpdate:(CLLocation *)location{
    [locationController.locationManager stopUpdatingLocation];
    CLLocationCoordinate2D coordinates = [location coordinate];
    
//    NSLog(@"loc %f %f",_loc.latitude,_loc.longitude);
    int distance = 0;//  _checkinFlag?0:500000;
    [mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinates,distance,distance) animated:YES];
    
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:coordinates addressDictionary:nil];
	annotation.title = @"Drag to Move Pin";
    //	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
    _loc = coordinates;
    
	[self getLocationName:[[CLLocation alloc]initWithLatitude:coordinates.latitude longitude:coordinates.longitude] annotation:annotation];
    [self.mapView addAnnotation:annotation];
}
- (void)locationError:(NSError *)error{
    [locationController.locationManager stopUpdatingLocation];
	
	if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied)
	{
        //		NSString *msg=@"You have disabled location services for PREIT app.To perfrom location based search in future please enable location services for PREIT app from the Settings application by toggling the Location Services switch for PREIT in General";
        NSString *msg=@"You have disabled location services for this app. If you'd like to take advantage of this app's location services in the future, please enable them in the Settings application";
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		alert.tag=100;
		[alert show];
        //		[alert release];
    }
	else if([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorLocationUnknown)
	{
		NSString *msg=@"Sorry an unknown error occured,would you like to try again or continue without location?";
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Try Again",nil];
		[alert show];
        //		[alert release];
	}
	else
	{
        //		NSString *msg=[NSString stringWithFormat:@"%@,would you like to try again or continue without location?",[error localizedDescription]];
        NSString *msg=@"Error geting your location,would you like to try again or continue without location?";
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Try Again",nil];
		[alert show];
        //		[alert release];
	}
}

@end
