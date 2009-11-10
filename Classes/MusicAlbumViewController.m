//
//  MusicAlbumViewController.m
//  promo
//
//  Created by Neil Davis on 10/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import "MusicAlbumViewController.h"

#define kMinCellHeight	30

@implementation MusicAlbumViewController

@synthesize albumData;
@synthesize coverImageView;
@synthesize titleLabel;
@synthesize captionLabel;
@synthesize copyrightLabel;
@synthesize iTunesLabel;
@synthesize iTunesButton;
@synthesize navBarIsHidden;

- (IBAction) onButtonPressed:(id)sender
{
	if (sender == iTunesButton)
	{
		NSString* iTunesUrl = [albumData objectForKey:@"itunes_url"];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesUrl]];
	}
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
	self.title = [albumData objectForKey:@"title"];
	titleLabel.text = self.title;
	captionLabel.text = [albumData objectForKey:@"caption"];
	copyrightLabel.text = [albumData objectForKey:@"copyright"];
	NSString* imageFn = [albumData objectForKey:@"cover_img"];
	if (imageFn)
	{
		NSString* imgPath = [[NSBundle mainBundle] pathForResource:imageFn ofType:nil inDirectory:@"music"];
		UIImage* image = [UIImage imageWithContentsOfFile:imgPath];
//		CGRect frame = coverImageView.frame;
		coverImageView.image = image;
//		coverImageView.frame = frame;
	}
	// hide the iTunes label & button if no URL
	NSString* iTunesUrl = [albumData objectForKey:@"itunes_url"];
	if (!iTunesUrl || [iTunesUrl length] == 0)
	{
		iTunesLabel.hidden = YES;
		iTunesButton.hidden = YES;
	}
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
	if (!self.navBarIsHidden)
		[self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)dealloc
{
	[albumData release];
	[coverImageView release];
	[titleLabel release];
	[captionLabel release];
	[copyrightLabel release];
	[iTunesLabel release];
	[iTunesButton release];
    [super dealloc];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray* tracks = [albumData objectForKey:@"tracks"];
    return [tracks count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AlbumTrackCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSUInteger row = [indexPath row];
	NSArray* tracks = [albumData objectForKey:@"tracks"];
	NSDictionary* trackData = [tracks objectAtIndex:row];
	cell.textLabel.text = [trackData objectForKey:@"title"];
    return cell;
}


#pragma mark UITableViewDelegate view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray* tracks = [albumData objectForKey:@"tracks"];
	CGFloat height = tableView.frame.size.height / [tracks count];
	if (height < kMinCellHeight)
		height = kMinCellHeight;
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	// hide the iTunes button if no URL
	NSArray* tracks = [albumData objectForKey:@"tracks"];
	NSDictionary* track = [tracks objectAtIndex:[indexPath row]];
	NSString* iTunesUrl = [track objectForKey:@"itunes_url"];
	if (!iTunesUrl || [iTunesUrl length] == 0)
		return UITableViewCellAccessoryNone;
	return UITableViewCellAccessoryDetailDisclosureButton;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSArray* tracks = [albumData objectForKey:@"tracks"];
	NSDictionary* track = [tracks objectAtIndex:[indexPath row]];
	NSString* iTunesUrl = [track objectForKey:@"itunes_url"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesUrl]];
}

@end
