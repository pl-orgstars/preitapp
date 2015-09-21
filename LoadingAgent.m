//
//  PreitAppDelegate.h
//  Preit
//
//  Created by Aniket on 9/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "LoadingAgent.h"
#import "QuartzCore/QuartzCore.h"

static LoadingAgent *agent;

@implementation LoadingAgent
- (id)init{
	return nil;
}

- (id)myinit{
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	if( (self = [super init])){
		loadingCount = 0;
		UIWindow* keywindow = [[UIApplication sharedApplication] keyWindow];
        CGRect keyFrame=[keywindow frame];
		CGRect frame=CGRectMake(keyFrame.origin.x, keyFrame.origin.y, keyFrame.size.width, keyFrame.size.height-60);
		main_view = [[UIView alloc] initWithFrame:frame];
		main_view.backgroundColor = [UIColor clearColor];
		main_view.alpha =1.0;
		
		wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		wait.hidesWhenStopped = NO;
		//wait.center=[main_view center];			
		
		frame=CGRectMake(56.0, 200.0, 211.0, 121.0);
		UIView *loadingView=[[UIView alloc]initWithFrame:frame];
		loadingView.backgroundColor=[UIColor darkGrayColor];
	//	loadingView.alpha=0.8;
		frame=CGRectMake(32.0, 20.0, 159.0,27.0);
		UILabel *loadingLabel = [[UILabel alloc] initWithFrame:frame];
		loadingLabel.textColor = [UIColor whiteColor];
		loadingLabel.backgroundColor = [UIColor clearColor];
		loadingLabel.font=[UIFont boldSystemFontOfSize:18];
		loadingLabel.textAlignment = UITextAlignmentCenter;
		loadingLabel.text = @"Please wait...";
		loadingLabel.lineBreakMode=UILineBreakModeWordWrap;		
		loadingLabel.numberOfLines=0;		
		[loadingView addSubview:loadingLabel];
		[loadingView addSubview:wait];
		
		frame=CGRectMake(86.0, 67.0, 37.0,37.0);
		wait.frame=frame;
		
		CALayer *l=[loadingView layer];
		[l setCornerRadius:10.0];
		[l setBorderWidth:3.0];
		[l setBorderColor:[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]CGColor]];
	
        //[loadingView addSubview:wait];
		[main_view addSubview:loadingView];
		[wait startAnimating];
		[loadingLabel release];
		[loadingView release];
		
		return self;
	}	
	return nil;
}

-(BOOL) isBusy{
   if(loadingCount!=0)
	   return YES;
  return NO;
}

- (void) makeBusy:(BOOL)yesOrno{
	if(yesOrno){
		[delegate showNetworkIndicator:YES];
		loadingCount++;
//        NSLog(@"::::: yesOrno loading count %d",loadingCount);
	}else {
        
		loadingCount--;
        NSLog(@":::::loading count %d",loadingCount);
		if(loadingCount<=0){
			[delegate showNetworkIndicator:NO];
			loadingCount = 0;
		}
	}
	
	//NSLog(@"::::::::::::::::::::::::::Busy count:::::::::::::::::%d",loadingCount);
	if(loadingCount == 1){
		[[[UIApplication sharedApplication] keyWindow] addSubview:main_view];
		[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:main_view];
	}else if(loadingCount == 0) {
		[main_view removeFromSuperview];
	}else {
		[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:main_view];
	}
	
}

- (void) forceRemoveBusyState{
	loadingCount = 0;
	[main_view removeFromSuperview];
}

+ (LoadingAgent*)defaultAgent{
	if(!agent){
		agent =[[LoadingAgent alloc] myinit];
	}
	return agent;
}

- (void)dealloc{
	[wait release];
	[main_view release];	
	[super dealloc];
}
@end
