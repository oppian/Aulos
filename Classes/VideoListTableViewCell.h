//
//  VideoListTableViewCell.h
//  promo
//
//  Created by Neil Davis on 10/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoListTableViewCell : UITableViewCell 
{
	NSURLConnection* urlConnection;
	NSMutableData* imgData;
}

@property(nonatomic, retain) NSURLConnection* urlConnection;
@property(nonatomic, retain) NSMutableData* imgData;

- (void) loadIconForVideoWithUrl:(NSString*)url;

@end
