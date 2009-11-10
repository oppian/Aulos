//
//  MusicAlbumViewController.h
//  promo
//
//  Created by Neil Davis on 10/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MusicAlbumViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSDictionary* albumData;
	UIImageView* coverImageView;
	UILabel*	titleLabel;
	UILabel*	captionLabel;
	UILabel*	copyrightLabel;
	UILabel*	iTunesLabel;
	UIButton*	iTunesButton;
	BOOL		navBarIsHidden;
}

@property(nonatomic,retain) NSDictionary* albumData;
@property(nonatomic,retain) IBOutlet UIImageView* coverImageView;
@property(nonatomic,retain) IBOutlet UILabel* titleLabel;
@property(nonatomic,retain) IBOutlet UILabel* captionLabel;
@property(nonatomic,retain) IBOutlet UILabel* copyrightLabel;
@property(nonatomic,retain) IBOutlet UILabel* iTunesLabel;
@property(nonatomic,retain) IBOutlet UIButton* iTunesButton;
@property(nonatomic) BOOL navBarIsHidden;

- (IBAction) onButtonPressed:(id)sender;

@end
