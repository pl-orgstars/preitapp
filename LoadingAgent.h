//
//  PreitAppDelegate.h
//  Preit
//
//  Created by Aniket on 9/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreitAppDelegate.h"

@interface LoadingAgent : NSObject {
	UIView* main_view;
	UIActivityIndicatorView* wait;
	int loadingCount;
	PreitAppDelegate *delegate;
	
}
/**
 * Checks whether Loading is being carried out or not
 */
- (BOOL) isBusy;
/**
 * call this function. Pass yes if you want to set busy mode.
 * pass No if your done with your busy state
 */
- (void) makeBusy:(BOOL)yesOrno;

/**
 * Messed up with updateBusyState? call this method to remove busy state
 */
- (void) forceRemoveBusyState;

/**
 * Factory method
 */
+ (LoadingAgent*)defaultAgent;

@end
