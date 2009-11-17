//
//  promoAppDelegate.m
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright Oppian Systems Ltd 2009. All rights reserved.
//

#import "promoAppDelegate.h"


@implementation promoAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize contentDict;


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // Load up the content description data
	NSString* path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"plist"];
	self.contentDict = [NSDictionary dictionaryWithContentsOfFile:path];
    // Add the tab bar controller's current view as a subview of the window
	tabBarController.delegate = self;
    [window addSubview:tabBarController.view];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
	[contentDict release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	if ([viewController isKindOfClass:[UINavigationController class]])
	{
		[(UINavigationController*)viewController popToRootViewControllerAnimated:NO];
	}
}

@end

