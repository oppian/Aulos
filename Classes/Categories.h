//
//  Categories.h
//  promo
//
//  Created by Neil Davis on 09/11/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Extras)
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
@end;

@interface UIImageView (BackgroundOperations)
- (id) initWithBackgroundLoadWithContentsOfFile:(NSString*)imagePath frame:(CGRect)frame activityIndicator:(BOOL)activityIndicator;
@end

@interface UIColor (ExtendedColors)
+ (UIColor*) lighterLightGrayColor;
+ (UIColor*) veryLightGrayColor;
@end