//
//  VideoListViewController.m
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import "VideoListViewController.h"
#import "WebVideoViewController.h"
#import "VideoListTableViewCell.h"
#import "promoAppDelegate.h"

#define kCellHeight 68.5

@interface VideoListViewController()
- (void) findAndLoadVideos;
- (void) onPlayVideoAtIndex:(NSUInteger)index animated:(BOOL)animated;
@end

@implementation VideoListViewController

@synthesize videos;

- (void) findAndLoadVideos
{
	// Load the main content plist
	NSDictionary* content = ((promoAppDelegate*)[UIApplication sharedApplication].delegate).contentDict;
	// grab the videos section
	self.videos = [content objectForKey:@"videos"];
}

- (void) onPlayVideoAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	NSDictionary* params = [videos objectAtIndex:index];
	NSString* strUrl = [params objectForKey:@"url"];
	if ([strUrl hasPrefix:@"http"])
	{
		// this is a web url - load it in a WebVideoViewController
		WebVideoViewController *anotherViewController = [[WebVideoViewController alloc] initWithNibName:@"WebVideoViewController" bundle:nil];
		anotherViewController.params = params;
		// If this is the only video, keep the nav bar hidden, else show it
		if ([self.videos count] == 1)
		{
			anotherViewController.navBarIsHidden = YES;
		}
		[self.navigationController pushViewController:anotherViewController animated:animated];
		[anotherViewController release];
	}
	else
	{
		// File URL - TODO: load video player
	}
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad 
{
    [super viewDidLoad];
	[self findAndLoadVideos];
}



- (void)viewWillAppear:(BOOL)animated
{
	if ([self.videos count] == 1)
	{
		[self onPlayVideoAtIndex:0 animated:NO];
	}
	else
		[self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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


#pragma mark UITableViewDataSource view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.videos count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"VideoCell";
    
    VideoListTableViewCell *cell = (VideoListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSUInteger row = [indexPath row];
	NSDictionary* params = [videos objectAtIndex:row];
	cell.textLabel.text = [params objectForKey:@"title"];
	cell.imageView.image = [UIImage imageNamed:@"defaut_video_cell_image.png"];
	[cell loadIconForVideoWithUrl:[params objectForKey:@"url"]];
	
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark UITableViewDelegate view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self onPlayVideoAtIndex:[indexPath row] animated:YES];
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


- (void)dealloc 
{
	[videos release];
    [super dealloc];
}


@end

