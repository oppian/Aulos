//
//  MusicListViewController.m
//  promo
//
//  Created by Neil Davis on 10/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicAlbumViewController.h"

#define kCellHeight 68.5

@interface MusicListViewController()
- (void) loadAlbumViewController:(NSUInteger)index animated:(BOOL)animated;
@end

@implementation MusicListViewController

@synthesize albums;

- (void) loadAlbumViewController:(NSUInteger)index animated:(BOOL)animated
{
	NSDictionary* albumData = [albums objectAtIndex:index];
	MusicAlbumViewController* albumViewController = [[MusicAlbumViewController alloc] initWithNibName:@"MusicAlbumViewController" bundle:nil];
	albumViewController.albumData = albumData;
	if ([self.albums count] == 1)
	{
		albumViewController.navBarIsHidden = YES;
	}
	[self.navigationController pushViewController:albumViewController animated:animated];
	[albumViewController release];
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
	// Load the main content plist
	NSString* path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"plist"];
	NSDictionary* content = [NSDictionary dictionaryWithContentsOfFile:path];
	// grab the music section - an array of album dictionaries
	self.albums = [content objectForKey:@"music"];
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated
{
	if ([self.albums count] == 1)
	{
		[self loadAlbumViewController:0 animated:NO];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [albums count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSUInteger row = [indexPath row];
	NSDictionary* album = [albums objectAtIndex:row];
	cell.textLabel.text = [album objectForKey:@"title"];
	cell.detailTextLabel.text = [album objectForKey:@"caption"];
	NSString* imageFn = [album objectForKey:@"cover_img"];
	if (imageFn)
	{
		NSString* imgPath = [[NSBundle mainBundle] pathForResource:imageFn ofType:nil inDirectory:@"music"];
		UIImage* image = [UIImage imageWithContentsOfFile:imgPath];
		cell.imageView.image = image;
	}
	
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
	[self loadAlbumViewController:[indexPath row] animated:YES];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	return UITableViewCellAccessoryDisclosureIndicator;
}



- (void)dealloc 
{
	[albums release];
    [super dealloc];
}


@end

