//
//  DirectionViewController.m
//  Preit
//
//  Created by Aniket on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DirectionViewController.h"
#import "RequestAgent.h"
#import "JSON.h"


@implementation AddressAnnotation

@synthesize coordinate,mTitle,mSubTitle;

- (NSString *)subtitle{
	return mSubTitle;
}
- (NSString *)title{
	return mTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end

@implementation DirectionViewController
@synthesize latitude,longitude,mallAddress;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //kk
//    self.trackedViewName = @"Direction";
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
//	self.navigationItem.title=NSLocalizedString(@"Screen6",@"");
    
    [self setNavigationTitle:NSLocalizedString(@"Screen6",@"") withBackButton:YES];
    
    if(([delegate.mallData objectForKey:@"location_lat" ] &&![[delegate.mallData objectForKey:@"location_lat" ] isEqual:[NSNull null]])&&([[delegate.mallData objectForKey:@"location_lat" ] intValue] !=0&&[[delegate.mallData objectForKey:@"location_lng" ] intValue] !=0))
    {
         
             self.latitude =[delegate.mallData objectForKey:@"location_lat" ];
             self.longitude =[delegate.mallData objectForKey:@"location_lng" ];  
             [self showAddress]; 
             
        
    }
    else
    {
		self.mallAddress=[NSString stringWithFormat:@"%@,+%@+%@+%@",[delegate.mallData objectForKey:@"address_street"],[delegate.mallData objectForKey:@"address_city"],[delegate.mallData objectForKey:@"address_state"],[delegate.mallData objectForKey:@"address_zipcode"]];
    self.mallAddress=[self.mallAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	NSString *url = [NSString stringWithFormat:@"%@json?address=%@&sensor=false",NSLocalizedString(@"API_GeoCoding",@""),self.mallAddress]; 
   // NSLog(@"url==>%@",url);
        RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
    
	[indicator_ startAnimating];
}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//- (void)dealloc {
//    [super dealloc];
//}


-(void)responseData:(NSData *)receivedData{
	[indicator_ stopAnimating];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSDictionary *tmpLocation=[jsonString JSONValue];

		if([[tmpLocation objectForKey:@"status"] isEqualToString:@"OK"])
		{
			NSDictionary *tmpAddress=[[[[tmpLocation objectForKey:@"results"]objectAtIndex:0]  objectForKey:@"geometry"] objectForKey:@"location"];
			self.latitude =[tmpAddress objectForKey:@"lat"];
			self.longitude =[tmpAddress objectForKey:@"lng"];
			NSLog(@"----------%@----++++%@",self.latitude,self.longitude);
			[self showAddress];
		}
		else
			[delegate showAlert:@"Error getting Geocodes.Please try again later." title:@"Message" buttontitle:@"Ok"];
	}
}

-(void)errorCallback:(NSError *)error{
	[indicator_ stopAnimating];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}


- (void) showAddress {
	mapView.showsUserLocation=YES;
	
	CLLocationCoordinate2D c;
	c.latitude = [self.latitude doubleValue];
	c.longitude = [self.longitude doubleValue];
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.1;
	span.longitudeDelta=0.1;
	
	region.span=span;
	region.center=c;
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
	AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:c];
	addAnnotation.mTitle=[delegate.mallData objectForKey:@"name"];
    NSLog(@"mTitle %@",[delegate.mallData objectForKey:@"name"]);
	addAnnotation.mSubTitle=[delegate.mallData objectForKey:@"address_street"];
	[mapView addAnnotation:addAnnotation];
	NSLog(@"delegate.mallData==>%@",delegate.mallData);
	//addAnnotation.currentPoint = [NSNumber numberWithInt:counter];
	[mapView addAnnotation:addAnnotation];
	[mapView selectAnnotation:addAnnotation animated:YES];

//	[addAnnotation release];
	
}

#pragma Action method

-(void)buttonAction:(id)sender
{
	/*
	    ll=: Stands for “latittude/longitude” and allows the user much greater accuracy when pulling up maps. This parameter is often used in conjunction with the on-board GPS to plot a “You are Here” point display. The value for this parameter must be supplied in decimal format and must be comma separated.
		saddr=: The start, or “source,” address to use when generating driving directions.
		daddr=: The end, or “destination,” address to use when generating driving directions.
		t=: The type of map that will be displayed.
		z=: The zoom level of the map that will be displayed.
	 */
	
//	NSString *geo=[NSString stringWithFormat:@"%@/%@",self.latitude,self.longitude];
	UIApplication *app = [UIApplication sharedApplication];
//	NSString *urlString=[NSString stringWithFormat:@"http://maps.google.com/maps?ll=%@",geo];
//	NSString *urlString=[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@&saddr=Cherry+Hill&daddr=",self.mallAddress,self.mallAddress];
	NSString *urlString=[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",self.mallAddress];

	[app openURL:[NSURL URLWithString:urlString]];  
	 
}

#pragma mark MKAnnotationView method

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	//AnnotationView contains a annotation
	//view.annotation.coordinate;
	//view.annotation.title;
	//view.annotation.subtible;	
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView_ viewForAnnotation:(id <MKAnnotation>) annotation{
	
	if ([[annotation title] isEqualToString:@"Current Location"])
	{
		return nil;		
	}
	
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];

	annView.pinColor = MKPinAnnotationColorRed;
	annView.animatesDrop=TRUE;
	annView.canShowCallout = YES;
	annView.calloutOffset = CGPointMake(-5, 5);
	
	UIButton *buttonDisclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	//buttonDisclosure.tag = postag;
	[buttonDisclosure addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

	annView.rightCalloutAccessoryView=buttonDisclosure;

	return annView;		
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView_
{
	
}

#pragma mark - navigation
- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}

- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}


@end
