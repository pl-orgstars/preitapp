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
    
    [locationInfoLabel setHidden:YES];


	delegate=(PreitAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    noEvents = NO;
    noDeals  = NO;
    
    
    [buttonMap.layer setBorderWidth:1.0];
    [buttonMap.layer setBorderColor:([[UIColor whiteColor] CGColor])];
    
    [callBtn.layer setBorderWidth:1.0];
    [callBtn.layer setBorderColor:([[UIColor whiteColor] CGColor])];
    
    NSDictionary *suite=[dictData objectForKey:@"suite"];
    int suiteID=[[suite objectForKey:@"id"] intValue];

	if(suiteID>0)
	{
		
		
        
        NSString *url=[NSString stringWithFormat:@"%@/tenant_categories/tenant_image?suite_id=%d",[delegate.mallData objectForKey:@"resource_url"],suiteID];
        [self showHudWithMessage:@""];
        RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
		[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
        
        url = [NSString stringWithFormat:@"%@/areas/%@",[delegate.mallData objectForKey:@"resource_url"],[suite objectForKey:@"area_id"]];
        RequestAgent *reqArea = [[RequestAgent alloc] init];
        [reqArea requestToServer:self callBackSelector:@selector(responseDataForArea:) errorSelector:@selector(errorCallback:) Url:url];
        

	}
    
    if (self.navigationController.viewControllers.count<2) {
        [backBtn setHidden:YES];
    }
	
	
}

-(void)setData{
//    [self setDefaultThumbnail];
    
	labelName.text=[dictData objectForKey:@"name"];
    
    if ([dictData objectForKeyWithNullCheck:@"description"]) {
        if (![dictData[@"description"] isEqualToString:@""])
        {
            NSString *strDis = [self stringByStrippingHTML:dictData[@"description"]];
            txtViewDis.text = strDis;
            
            CGSize newSize = [txtViewDis sizeThatFits:CGSizeMake(304, MAXFLOAT)];
            CGRect newFrame = txtViewDis.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, 304), newSize.height);
            txtViewDis.frame = newFrame;
            [mainScroll setContentSize:CGSizeMake(0, descriptionView.frame.origin.y + txtViewDis.frame.size.height +35)];
            txtViewDis.textColor = [UIColor whiteColor];
            txtViewDis.scrollEnabled = FALSE;
        }else
            [descriptionView setHidden:YES];
    }else
        [descriptionView setHidden:YES];
}

-(NSString *) stringByStrippingHTML:(NSString *)str {
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    return str;
}

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




#pragma mark - web view delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [webView_.scrollView setScrollEnabled:NO];
    
    if (webView_.scrollView.contentSize.height > webView_.frame.size.height) {
        CGRect webFrame = webView_.frame;
        
        [webView_ setFrame:CGRectMake(webFrame.origin.x, webFrame.origin.y, webFrame.size.width, webView_.scrollView.contentSize.height)];
        
        
        webFrame = webView_.frame;
        if ((webFrame.origin.y + webFrame.size.height + descriptionView.frame.origin.y) > mainScroll.frame.size.height) {
            float diff = (webFrame.origin.y + webFrame.size.height + descriptionView.frame.origin.y) - mainScroll.frame.size.height;
            
            CGSize scrollContent = mainScroll.frame.size;
            
            scrollContent.height = scrollContent.height + diff;
            
            [mainScroll setContentSize:scrollContent];
            
            [webView_.scrollView setScrollEnabled:NO];

            
        }
        
    }
    
    
    
}

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
    

    
    NSString* phoneNumber = dictData[@"telephone"];
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSString *url = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    
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

-(void)responseDataForArea:(NSData*)receivedData{
    
    if (receivedData!=nil) {
        NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
        NSDictionary *tmpDict=[jsonString JSONValue];
        
        if ([tmpDict[@"area"] objectForKeyWithNullCheck:@"name"]) {
            locationInfoLabel.text = [tmpDict[@"area"] objectForKey:@"name"];
            [locationInfoLabel setHidden:NO];

        }
        
    }
    
}
-(void)responseData:(NSData *)receivedData{

    [self hideHud];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];

        
        NSDictionary *tmpDict=[jsonString JSONValue];
		if(tmpDict && [tmpDict objectForKey:@"tenant"])
		{
			NSDictionary *tmpInnerDict=[tmpDict objectForKey:@"tenant"];
			NSString *imageLink=[tmpInnerDict objectForKey:@"image"];
			if([imageLink length]!=0)
			{

				AsyncImageView* thumbnailImage = [[AsyncImageView alloc] initWithFrame:image_thumbNail.frame] ;//autorelease];
				NSURL *url=[NSURL URLWithString:imageLink];
				[thumbnailImage loadImageFromURL:url delegate:self requestSelector:@selector(responseThumb_Image:)];				
			}
			else [self hideLogoImageView];
		}
	}
    
    
    NSString *url=[NSString stringWithFormat:@"%@/sales",[delegate.mallData objectForKey:@"resource_url"]];
    [self showHudWithMessage:@""];
    RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
    [req requestToServer:self callBackSelector:@selector(responseDataForDeal:) errorSelector:@selector(errorCallback2:) Url:url];

    
}

-(void)responseForEvents:(NSData*)receivedData{
    
    if (receivedData!=nil) {
        NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
        NSArray *tmparr=[jsonString JSONValue];
        int tenantID = [[dictData[@"suite"] objectForKey:@"tenant_id"] intValue];
        
        int counter = 0;
        if (tmparr) {
            if (tmparr.count) {
                for (NSDictionary *tmpDic in tmparr) {
                    NSDictionary* eventDic = tmpDic[@"event"];
                    if ([[eventDic objectForKeyWithNullCheck:@"tenant_id"] intValue] == tenantID) {
                        [eventsBtn setHidden:NO];
                        counter++;
                    }
                    
                }
            }
        }
        
        if (counter>0) {
            noEvents = NO;
        }
        else{
            noEvents = YES;
        }
        
        [self hideDealEventsView];

    }
    
    [self setData];
}

-(void)responseDataForDeal:(NSData *)receivedData{
    
    [self hideHud];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
        NSLog(@"kuldeep::::%@ ",[jsonString JSONValue]);
        
        
        NSArray *tmparr=[jsonString JSONValue];
		NSDictionary *suite=[dictData objectForKeyWithNullCheck:@"suite"];
        
        int tenantID = [[suite objectForKeyWithNullCheck:@"tenant_id"] intValue];

        int counter = 0;
        if (tmparr) {
            if (tmparr.count) {
                //                NSArray *array = [tmparr objectAtIndex:0];
                for (NSDictionary *dict in tmparr) {
                    NSDictionary *dictDeal = [dict objectForKeyWithNullCheck:@"sale"];
                    
                    if ([[dictDeal objectForKeyWithNullCheck:@"tenant_id"]intValue] == tenantID) {
                        showDealDictionary = dictDeal;
                        [dealBttn setHidden:NO];
                        counter++;
                        break;
                    }
                }
            }
        }
        
        if (counter>0) {
            noDeals = NO;
        }
        else{
            noDeals = YES;
        }
        
        [self hideDealEventsView];
        
        
        NSString* url=[NSString stringWithFormat:@"%@/events",[delegate.mallData objectForKey:@"resource_url"]];
        RequestAgent *req1=[[RequestAgent alloc] init];
        [req1 requestToServer:self callBackSelector:@selector(responseForEvents:) errorSelector:@selector(errorCallback2:) Url:url];
    }
}
-(void)errorCallback2:(NSError *)error
{
    [self hideHud];

}
-(void)errorCallback:(NSError *)error
{
        [self hideHud];
	[self hideLogoImageView];
}

-(void)responseThumb_Image:(NSData *)receivedData{
	if(receivedData)
	{
		UIImage *image=[UIImage imageWithData:receivedData];
		if([delegate checkImage:image])
			image_thumbNail.image=image;
		else [self hideLogoImageView];
			
	}
	else [self hideLogoImageView];

}

-(void)setDefaultThumbnail
{
	image_thumbNail.image=[UIImage imageNamed:@"shopingBag.png"];
}


#pragma mark Hide Funcs

-(void)hideLogoImageView{
    
    [image_thumbNail setHidden:YES];
    [image_thumbNail setUserInteractionEnabled:NO];
    
    float diff = -image_thumbNail.frame.size.height;
    [callMapView setFrame:[self newFrameWithDiffPosY:diff existingFrame:callMapView.frame]];
    [dealEventsView setFrame:[self newFrameWithDiffPosY:diff existingFrame:dealEventsView.frame]];
    [locationView setFrame:[self newFrameWithDiffPosY:diff existingFrame:locationView.frame]];
    [descriptionView setFrame:[self newFrameWithDiffPosY:diff existingFrame:descriptionView.frame]];
    
    
    
}

-(void)hideDealEventsView{
    
    if (noDeals && noEvents) {
        [dealEventsView setHidden:YES];
        [dealEventsView setUserInteractionEnabled:NO];
        
        float diff = - dealEventsView.frame.size.height;
        [locationView setFrame:[self newFrameWithDiffPosY:diff existingFrame:locationView.frame]];
        [descriptionView setFrame:[self newFrameWithDiffPosY:diff existingFrame:descriptionView.frame]];
    }
    
}

-(CGRect)newFrameWithDiffPosY:(float)diff existingFrame:(CGRect)frame
{
    
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y+diff, frame.size.width, frame.size.height);
    return newFrame;
    
}


@end
