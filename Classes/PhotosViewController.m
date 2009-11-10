//
//  PhotosViewController.m
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import "PhotosViewController.h"
#import "Categories.h"

#define kCachedImageCount	5; // per side of current photo

@interface PhotosViewController()
- (void) findAndLoadPhotos;
- (void) layoutScrollImages;
@end

@implementation PhotosViewController

@synthesize scrollView;

- (void) findAndLoadPhotos
{
	currentImage = 0;
	NSArray* imageFilenames = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:@"photos"];
	numImages = [imageFilenames count];
	for (NSUInteger i = 0; i < numImages; i++)
	{
		NSString* fn = [imageFilenames objectAtIndex:i];
		UIImage* image = [UIImage imageWithContentsOfFile:fn];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = scrollView.frame;
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		imageView.tag = i + 1;	// tag our images for later use when we place them in serial fashion
		[scrollView addSubview:imageView];
		[imageView release];
	}
}

- (void) layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [scrollView subviews];
	
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += (frame.size.width);
		}
	}
	
	// set the content size so it can be scrollable
	[scrollView setContentSize:CGSizeMake((numImages * self.view.frame.size.width), [scrollView bounds].size.height)];
}


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
	[scrollView setBackgroundColor:[UIColor blackColor]];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	scrollView.delegate = self;
	[self findAndLoadPhotos];
	[self layoutScrollImages];	// now place the photos in serial layout within the scrollview
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


- (void)dealloc 
{
	[scrollView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
	CGFloat offset = theScrollView.contentOffset.x;
	currentImage = floor(offset / scrollView.frame.size.width);
}

@end
