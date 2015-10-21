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
        CGRect frame=CGRectMake(keyFrame.origin.x, keyFrame.origin.y, keyFrame.size.width, keyFrame.size.height);
        
        main_view = [[UIView alloc] initWithFrame:frame];
        main_view.backgroundColor = [UIColor clearColor];
        main_view.alpha =1.0;
        
        wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.hidesWhenStopped = NO;
        
        frame=CGRectMake(56.0,180.0, 211.0, 121.0);
        UIView *loadingView=[[UIView alloc]initWithFrame:frame];
        loadingView.backgroundColor=[UIColor clearColor];
        
        frame=CGRectMake(32.0,20.0, 159.0,60.0);
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:frame];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.font=[UIFont boldSystemFontOfSize:18];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.text = @"LOADING";
        loadingLabel.numberOfLines=0;
        [loadingView addSubview:loadingLabel];
        [loadingView addSubview:wait];
        
        frame=CGRectMake(86.0, 77.0, 37.0,37.0);
        wait.frame=frame;
        
        [main_view addSubview:loadingView];
        [wait startAnimating];

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
	if(yesOrno)
    {
		[delegate showNetworkIndicator:YES];
		loadingCount++;
	}else {
		loadingCount--;
		if(loadingCount<=0){
			[delegate showNetworkIndicator:NO];
			loadingCount = 0;
		}
	}
	
	NSLog(@"::::::::::::::::::::::::::Busy count:::::::::::::::::%d",loadingCount);
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
