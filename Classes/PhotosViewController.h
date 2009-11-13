//
//  PhotosViewController.h
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotosViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>
{
	IBOutlet UIScrollView*	scrollView;
	IBOutlet UIPageControl* pageControl;
	NSUInteger currentImage;
	NSUInteger numImages;
}

@property(nonatomic, retain) UIScrollView* scrollView;
@property(nonatomic, retain) UIPageControl* pageControl;

- (IBAction) onSaveButtonPressed:(id)sender;

@end
