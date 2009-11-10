//
//  VideoListViewController.h
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoListViewController : UITableViewController 
{
	NSArray*	videos;	// array of dicts
}

@property(nonatomic, retain) NSArray* videos;

@end
