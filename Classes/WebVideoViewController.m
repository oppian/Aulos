//
//  WebVideoViewController.m
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import "WebVideoViewController.h"

@interface WebVideoViewController()
@end

@implementation WebVideoViewController

@synthesize webView;
@synthesize activity;
@synthesize params;
@synthesize navBarIsHidden;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = [params objectForKey:@"title"];
	// Fudge some HTML to embed a youtube video - this is better than using the youtube app url scheme since our app won't close
	NSString* template = [params objectForKey:@"template"];
	if (!template)
		template = @"std_video.html";
	// load html template from bundle and replace placeholders with param data
	NSString* templateFilename = [[NSBundle mainBundle] pathForResource:template ofType:nil inDirectory:@"templates"];
	NSString* htmlString = [NSString stringWithContentsOfFile:templateFilename];
	htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%URL%" withString:[params objectForKey:@"url"]];
	htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%TITLE%" withString:[params objectForKey:@"title"]];
	htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%CAPTION%" withString:[params objectForKey:@"caption"]];
	// load up the web page
	[self.webView loadHTMLString:htmlString baseURL:nil];
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
	if (!self.navBarIsHidden)
		[self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)dealloc 
{
	[webView release];
	[activity release];
	[params release];
    [super dealloc];
}


#pragma mark -
#pragma mark - UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[activity startAnimating];
	theWebView.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activity stopAnimating];
	theWebView.hidden = NO;
}

@end
