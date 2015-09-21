//
//  NavigationRotateController.m
//  Preit
//
//  Created by Aniket on 9/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NavigationRotateController.h"


@implementation NavigationRotateController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if([self.parentViewController class] == [UITabBarController class] && 
		((UITabBarController*)self.parentViewController).selectedViewController != self)
			return YES;
	return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super initWithRootViewController:rootViewController];
	if(self)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll:) name:@"ReloadAll" object:nil];
	}
	
	return self;
}

- (void)reloadAll:(NSNotification*)notification
{
	[self popToRootViewControllerAnimated:NO];
}


@end

@implementation TabBarRotateController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
