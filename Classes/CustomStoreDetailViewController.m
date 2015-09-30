//
//  CustomStoreDetailViewController.m
//  Preit
//
//  Created by Aniket on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomStoreDetailViewController.h"
#import "EventsViewController.h"
#import "JSBridgeViewController.h"
#import "LoadingAgent.h"
#import "AsyncImageView.h"
#import "RequestAgent.h"
#import "JSON.h"


#import "WebViewController.h"

@implementation CustomStoreDetailViewController
@synthesize dictData;

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
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [dealBttn setHidden:YES];
    [eventsBtn setHidden:YES];
  
    
//    
//    if ([dictData objectForKeyWithNullCheck:@"location_info"]) {
//        if ([[dictData objectForKeyWithNullCheck:@"location_info"] isEqualToString:@""]) {
//            locationInfoLabel.text = @"N/A";
//        }
//        else{
//            locationInfoLabel.text = [dictData objectForKeyWithNullCheck:@"location_info"];
//        }
//    }
//    
//    else{
//        locationInfoLabel.text = @"N/A";
//    }
	delegate=(PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    if ([delegate.mallData objectForKeyWithNullCheck:@"address_city"] && [delegate.mallData objectForKeyWithNullCheck:@"address_state"]) {
        if ([[delegate.mallData objectForKeyWithNullCheck:@"address_city"] isEqualToString:@""] && [[delegate.mallData objectForKeyWithNullCheck:@"address_state"] isEqualToString:@""]) {
            locationInfoLabel.text = @"N/A";
        }
        
        else{
            locationInfoLabel.text = [NSString stringWithFormat:@"%@, %@",[delegate.mallData objectForKeyWithNullCheck:@"address_city"],[delegate.mallData objectForKeyWithNullCheck:@"address_state"]];
        }
    }
    
    else{
        locationInfoLabel.text = @"N/A";
    }

    NSLog(@"<<<<<<<<<<<<<<<<<<<<<<< %@",dictData);
    
	NSDictionary *suite=[dictData objectForKey:@"suite"];
	int suiteID=[[suite objectForKey:@"id"] intValue];
    
    
    [buttonMap.layer setBorderWidth:1.0];
    [buttonMap.layer setBorderColor:([[UIColor whiteColor] CGColor])];
    
    [callBtn.layer setBorderWidth:1.0];
    [callBtn.layer setBorderColor:([[UIColor whiteColor] CGColor])];

	if(suiteID>0)
	{
		
		
        
        NSString *url=[NSString stringWithFormat:@"%@/tenant_categories/tenant_image?suite_id=%d",[delegate.mallData objectForKey:@"resource_url"],suiteID];
        [self showHudWithMessage:@""];
        RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
		[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];

	}
    
    if (self.navigationController.viewControllers.count<2) {
        [backBtn setHidden:YES];
    }
	
	[self setData];
}

-(void)setData{
//    [self setDefaultThumbnail];
    
	labelName.text=[dictData objectForKey:@"name"];
//	textDescription.text=[dictData objectForKey:@"description"];
    
//    NSString* desription = [dictData objectForKeyWithNullCheck:@"description"];
//    
//    desription = [desription stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
//    desription = [desription stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    
//    textDescription.text = desription;
    
    

    NSString *description = [dictData[@"description"] stringByReplacingOccurrencesOfString:@"<p>" withString:@"<p style='color:white'>"];
    [webView loadHTMLString:description baseURL:nil];
    
    [webView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [webView setOpaque:NO];
	

    

/*
    //set title, font size and font color
//    [button setAttributedTitle:[dictData objectForKey:@"telephone"] forState:UIControlStateNormal];
    [callBtn setTitle:[dictData objectForKey:@"telephone"] forState:UIControlStateNormal];
	callBtn.titleLabel.font =[UIFont boldSystemFontOfSize:17.0];
    [callBtn setTitleColor:LABEL_TEXT_COLOR forState:UIControlStateNormal];
    //set action of the button
    [callBtn addTarget:self action:@selector(buttonAction:)forControlEvents:UIControlEventTouchUpInside];
	callBtn.tag=100;
	[self.view addSubview:callBtn];	*/
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

#pragma mark Action methods

- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)menuBtnCall:(id)sender {
    
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}


-(IBAction)buttonAction:(id)sender{

	UIButton *button=(UIButton *)sender;
	switch (button.tag) {
		case 100:
		{
			//Phone Number
			if([dictData objectForKey:@"telephone"])
			{

				NSString *phoneNumber=[NSString stringWithFormat:@"tel:%@",[dictData objectForKey:@"telephone"]];
				NSLog(@"Phone Number clicked==%@",phoneNumber);

				NSURL *url = [[ NSURL alloc ] initWithString: phoneNumber];
				[[UIApplication sharedApplication] openURL:url];
//				[url release];
			}
		}
			break;
		case 101:
		{
			//Map
			NSLog(@"Map==%@",dictData);
			NSDictionary *suite=[dictData objectForKey:@"suite"];
			int suiteID=[[suite objectForKey:@"id"] intValue];
            if(suiteID>0)
			{
				JSBridgeViewController *screenMap=[[JSBridgeViewController alloc]initWithNibName:@"JSBridgeViewController" bundle:nil];
				//screenMap.mapUrl=[NSString stringWithFormat:@"%@/areas/%d/show_map?suit_id=%d",[delegate.mallData objectForKey:@"resource_url"],[[dictData objectForKey:@"suite_id"] intValue],[[dictData objectForKey:@"suite_id"] intValue]];
				screenMap.mapUrl=[NSString stringWithFormat:@"%@/areas/getarea?suit_id=%d",[delegate.mallData objectForKey:@"resource_url"],suiteID];
				[self.navigationController pushViewController:screenMap animated:YES];
//				[screenMap release];
			}
		}
			break;
		default:
			break;
	}
}

- (IBAction)callBtnCall:(id)sender {
    

    NSString *url = [NSString stringWithFormat:@"tel:%@", dictData[@"telephone"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else {
        NSLog(@"Error Calling");
    }
}

-(IBAction)dealBttnTapped:(id)sender{
    WebViewController *screenWebView=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    screenWebView.screenIndex=50;
    //    [[GAI sharedInstance].defaultTracker sendView:@"Hours"];
    
    screenWebView.htmlString = [showDealDictionary objectForKeyWithNullCheck:@"content"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        screenWebView.titleLabel.text = @"DEAL";
        
    });
    [self.navigationController pushViewController:screenWebView animated:YES];
}

- (IBAction)eventBtnCall:(id)sender {
    
    EventsViewController *viewCnt = [[EventsViewController alloc]initWithNibName:@"EventsViewController" bundle:nil];
    
    viewCnt.tenantID = [[dictData[@"suite"] objectForKey:@"tenant_id"] intValue];
    
    [self.navigationController pushViewController:viewCnt animated:NO];

}


#pragma mark - send and response DATA
-(void)responseData:(NSData *)receivedData{

    [self hideHud];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
        NSLog(@"kuldeep:::: dddddeeeeeeeellll  %@ ",[jsonString JSONValue]);
        
        
		
        
        NSDictionary *tmpDict=[jsonString JSONValue];
		if(tmpDict && [tmpDict objectForKey:@"tenant"])
		{
			NSDictionary *tmpInnerDict=[tmpDict objectForKey:@"tenant"];
			NSString *imageLink=[tmpInnerDict objectForKey:@"image"];
			if([imageLink length]!=0)
			{
//				CGRect frame;
//				frame.size.width=90;
//				frame.size.height=90;
//				frame.origin.x=10; frame.origin.y=10;	
				AsyncImageView* thumbnailImage = [[AsyncImageView alloc] initWithFrame:image_thumbNail.frame] ;//autorelease];
				NSURL *url=[NSURL URLWithString:imageLink];
				[thumbnailImage loadImageFromURL:url delegate:self requestSelector:@selector(responseThumb_Image:)];				
			}
			else [self setDefaultThumbnail];
		}
	}
    
    
    NSString *url=[NSString stringWithFormat:@"%@/sales",[delegate.mallData objectForKey:@"resource_url"]];
    [self showHudWithMessage:@""];
    RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(responseDataForDeal:) errorSelector:@selector(errorCallback2:) Url:url];
    
    url=[NSString stringWithFormat:@"%@/events",[delegate.mallData objectForKey:@"resource_url"]];
    RequestAgent *req1=[[RequestAgent alloc] init];
    [req1 requestToServer:self callBackSelector:@selector(responseForEvents:) errorSelector:@selector(errorCallback2:) Url:url];
    
}

-(void)responseForEvents:(NSData*)receivedData{
    
    if (receivedData!=nil) {
        NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
        NSArray *tmparr=[jsonString JSONValue];
        int tenantID = [[dictData[@"suite"] objectForKey:@"tenant_id"] intValue];
        
        if (tmparr) {
            if (tmparr.count) {
                for (NSDictionary *tmpDic in tmparr) {
                    NSDictionary* eventDic = tmpDic[@"event"];
                    if ([[eventDic objectForKeyWithNullCheck:@"tenant_id"] intValue] == tenantID) {
                        [eventsBtn setHidden:NO];
                    }
                }
            }
        }

    }
}

-(void)responseDataForDeal:(NSData *)receivedData{
    
    [self hideHud];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
        NSLog(@"kuldeep::::%@ ",[jsonString JSONValue]);
        
        
        NSArray *tmparr=[jsonString JSONValue];
		NSDictionary *suite=[dictData objectForKeyWithNullCheck:@"suite"];
        
        int tenantID = [[suite objectForKeyWithNullCheck:@"tenant_id"] intValue];
        NSLog(@"kuldeep::::%d ",tenantID);
        if (tmparr) {
            if (tmparr.count) {
                //                NSArray *array = [tmparr objectAtIndex:0];
                for (NSDictionary *dict in tmparr) {
                    NSDictionary *dictDeal = [dict objectForKeyWithNullCheck:@"sale"];
                    
                    if ([[dictDeal objectForKeyWithNullCheck:@"tenant_id"]intValue] == tenantID) {
                        showDealDictionary = dictDeal;
                        [dealBttn setHidden:NO];
                        break;
                    }
                }
            }
        }
    }
}
-(void)errorCallback2:(NSError *)error
{
    [self hideHud];

}
-(void)errorCallback:(NSError *)error
{
        [self hideHud];
	[self setDefaultThumbnail];
}

-(void)responseThumb_Image:(NSData *)receivedData{
	if(receivedData)
	{
		UIImage *image=[UIImage imageWithData:receivedData];
		if([delegate checkImage:image])
			image_thumbNail.image=image;
		else [self setDefaultThumbnail];
			
	}
	else [self setDefaultThumbnail];

}

-(void)setDefaultThumbnail
{
	image_thumbNail.image=[UIImage imageNamed:@"shopingBag.png"];
}



@end
