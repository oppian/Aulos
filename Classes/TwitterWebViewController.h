//
//  TwitterWebViewController.h
//  promo
//
//  Created by Neil Davis on 10/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterWebViewController : UIViewController <UIWebViewDelegate>
{
	IBOutlet UIWebView*	webView;
	NSUInteger	htmlCacheHash;
}

@property(nonatomic, retain) UIWebView* webView;

@end
