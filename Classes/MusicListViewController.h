//
//  MusicListViewController.h
//  promo
//
//  Created by Neil Davis on 10/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MusicListViewController : UITableViewController 
{
	NSArray* albums;
}

@property(nonatomic, retain) NSArray* albums;	// array of dict

@end
