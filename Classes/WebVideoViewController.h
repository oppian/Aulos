//
//  WebVideoViewController.h
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebVideoViewController : UIViewController <UIWebViewDelegate>
{
	IBOutlet UIWebView*	webView;
	IBOutlet UIActivityIndicatorView* activity;
	NSDictionary* params;
	BOOL		navBarIsHidden;
}

@property(nonatomic, retain) UIWebView* webView;
@property(nonatomic, retain) UIActivityIndicatorView* activity;
@property(nonatomic, retain) NSDictionary* params;
@property(nonatomic) BOOL navBarIsHidden;

@end
