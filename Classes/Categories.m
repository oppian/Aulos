//
//  Categories.m
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import "Categories.h"

#define kActivityIndicatorViewTag 666

@implementation UIImage (Extras)

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor < heightFactor) 
			scaleFactor = widthFactor;
        else
			scaleFactor = heightFactor;
		
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
		
        if (widthFactor < heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        } else if (widthFactor > heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
	}
	
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) NSLog(@"could not scale image");
	
	
	return newImage ;
}

@end

@implementation UIImageView (BackgroundOperations)

- (id) initWithBackgroundLoadWithContentsOfFile:(NSString*)imagePath frame:(CGRect)frame activityIndicator:(BOOL)activityIndicator
{
	if (self = [self initWithFrame:frame])
	{
		if (activityIndicator)
		{
			UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
			aiv.center = self.center;
			aiv.tag = kActivityIndicatorViewTag;
			[self addSubview:aiv]; // retains
			[aiv startAnimating];
			[aiv release];
		}
		[self performSelectorInBackground:@selector(loadImageInBg:) withObject:imagePath];
	}
	return self;
}

- (void) loadImageInBg:(NSString*)imagePath
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
	[self performSelectorOnMainThread:@selector(onLoadImageFromBg:) withObject:image waitUntilDone:YES];
	[pool drain];
}

- (void) onLoadImageFromBg:(UIImage*)image
{
	self.image = image;
	// if there was an activity indicator used, remove it
	UIView* aiv = [self viewWithTag:kActivityIndicatorViewTag];
	if (aiv)
		[aiv removeFromSuperview]; // also releases
}

	
@end
