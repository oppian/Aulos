//
//  TwitterWebViewController.m
//  promo
//
//  Created by Neil Davis on 10/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import "TwitterWebViewController.h"
#import "promoAppDelegate.h"

#define kCachedHtmlFilename @"twitter_cache.html"

@interface TwitterWebViewController()
- (void) loadHTMLStringInBackground:(NSString*)strUrl;
- (NSString*) cachedHTMLPath;
@end

@implementation TwitterWebViewController

@synthesize webView;

- (NSString*) cachedHTMLPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* docsDir = [paths objectAtIndex:0];
	return [docsDir stringByAppendingPathComponent:kCachedHtmlFilename];
}

- (void) loadHTMLStringInBackground:(NSString*)strUrl
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self performSelectorInBackground:@selector(loadHTMLStringThreadFunc:) withObject:strUrl];
}

- (void) loadHTMLStringThreadFunc:(NSString*) strUrl
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSURL* url = [NSURL URLWithString:strUrl];
	NSString* html = [NSString stringWithContentsOfURL:url];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self performSelectorOnMainThread:@selector(onLoadHTMLString:) withObject:html waitUntilDone:YES];
	[pool drain];
}

- (void) onLoadHTMLString:(NSString*)html
{
	if (html && [html hash] != htmlCacheHash)
	{
		// write to cache
		[html writeToFile:[self cachedHTMLPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
		htmlCacheHash = [html hash];
		// load up in web view
		NSDictionary* contentDict = ((promoAppDelegate*)[UIApplication sharedApplication].delegate).contentDict;
		NSString* twitterId = [contentDict objectForKey:@"twitter_id"];
		NSString* strUrl = [NSString stringWithFormat:@"http://m.twitter.com/%@", twitterId];
		[webView loadHTMLString:html baseURL:[NSURL URLWithString:strUrl]];
	}
	else if (!html)
	{
		// Twitter feed failed to load
		NSString* title = @"Error";
		NSString* msg = nil;
		if ([[NSFileManager defaultManager] fileExistsAtPath:[self cachedHTMLPath]])
		{
			// a cached version was loaded from disk
			msg = @"Unable to load live news feed. Content may be out of date. Connect to a network to see up to date news";
		}
		else
		{
			// no local cache available
			msg = @"Unable to load live news feed. Connect to a network to see news";
		}
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	NSDictionary* contentDict = ((promoAppDelegate*)[UIApplication sharedApplication].delegate).contentDict;
	NSString* twitterId = [contentDict objectForKey:@"twitter_id"];
	NSString* strUrl = [NSString stringWithFormat:@"http://m.twitter.com/%@", twitterId];
	// Load cached file into web view if it exists
	NSString* cachedFilePath = [self cachedHTMLPath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:cachedFilePath])
	{
		NSString* html = [NSString stringWithContentsOfFile:cachedFilePath];
		htmlCacheHash = [html hash];
		[webView loadHTMLString:html baseURL:[NSURL URLWithString:strUrl]];
	}
	else
		htmlCacheHash = 0;
	[self loadHTMLStringInBackground:strUrl];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)dealloc
{
	[webView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (UIWebViewNavigationTypeLinkClicked == navigationType)
	{
		NSURL* url = [request URL];
		[[UIApplication sharedApplication] openURL:url];
		return NO;
	}
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
