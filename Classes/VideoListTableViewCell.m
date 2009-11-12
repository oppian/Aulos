//
//  VideoListTableViewCell.m
//  promo
//
//  Created by Neil Davis on 10/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import "VideoListTableViewCell.h"

@interface VideoListTableViewCell (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end

@implementation VideoListTableViewCell

@synthesize urlConnection;
@synthesize imgData;

static NSUInteger thumbRequestCount = 0;

/** Obtain a better icon if possible based on the video URL
 */
- (void) loadIconForVideoWithUrl:(NSString*)url
{
	NSURL* parserUrl = [NSURL URLWithString:url];
	NSString* host = [parserUrl host];
	// Check to see if this is a youtube video - for now this is all we support
	NSRange range = [host rangeOfString:@"youtube.com" options:NSCaseInsensitiveSearch];
	if (range.location != NSNotFound)
	{
		// this is a youtube video - find the video id from the v= param
		NSString* query = [parserUrl query];
		range = [query rangeOfString:@"v="];
		if (range.location != NSNotFound)
		{
			NSUInteger startIndex = range.location + 2;
			NSRange subRange = {startIndex, [query length] - startIndex };
			range = [query rangeOfString:@"&" options:NSLiteralSearch range:subRange];
			if (range.location != NSNotFound)
				subRange.length = range.location - startIndex;
			NSString* vid = [query substringWithRange:subRange];
			NSString* youTubeThumbnailUrl = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/2.jpg", vid];
			NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:youTubeThumbnailUrl]];
			self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
			[urlConnection start];
			if (++thumbRequestCount == 1)
				[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		}
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc 
{
	[urlConnection release];
	[imgData release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	if ([httpResponse statusCode] == 200)
	{
		NSString* contentLength = [[httpResponse allHeaderFields] objectForKey:@"Content-Length"];
		self.imgData = 	[NSMutableData dataWithCapacity:[contentLength integerValue]];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.imgData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	UIImage* image = [UIImage imageWithData:self.imgData];
	self.imgData = nil;
	if (image)
	{
		self.imageView.image = image;
	}
	if (--thumbRequestCount == 0)
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.imgData = nil;
	if (--thumbRequestCount == 0)
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



@end
