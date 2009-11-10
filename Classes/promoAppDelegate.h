//
//  promoAppDelegate.h
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright Oppian Systems Ltd 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface promoAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
