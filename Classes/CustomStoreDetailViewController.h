//
//  CustomStoreDetailViewController.h
//  Preit
//
//  Created by Aniket on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreitAppDelegate.h"


@interface CustomStoreDetailViewController : SuperViewController   <UIWebViewDelegate>{
//	IBOutlet UIImageView *image_Background;
	IBOutlet UIImageView *image_thumbNail;
	IBOutlet UILabel *labelName;
	IBOutlet UITextView *textDescription;
	IBOutlet UIButton *buttonMap;
	PreitAppDelegate *delegate;
	NSDictionary *dictData;
    
    IBOutlet UIButton* backBtn;
	
    __weak IBOutlet UIWebView *webView_;
    
    __weak IBOutlet UIButton *dealBttn;
    
    IBOutlet UIButton* callBtn;
    
    NSDictionary *showDealDictionary;
    
    IBOutlet UIButton* eventsBtn;
    
    IBOutlet UILabel* locationInfoLabel;
    
    
    IBOutlet UIView* callMapView;
    IBOutlet UIView* dealEventsView;
    IBOutlet UIView* locationView;
    IBOutlet UIView* descriptionView;
    
    IBOutlet UIScrollView* mainScroll;
    
    BOOL noEvents;
    BOOL noDeals;
}

@property (nonatomic,retain) IBOutlet UILabel* titleLabel;

@property (nonatomic,retain)NSDictionary *dictData;
-(void)setData;
-(IBAction)buttonAction:(id)sender;
-(void)setDefaultThumbnail;


-(IBAction)dealBttnTapped:(id)sender;
@end
