//
//  UIImage+KLOExtensions.h
//  Loki
//
//  Created by William Towe on 3/9/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KLOExtensions)

/**
 Returns whether the receiver has an alpha component.
 
 @return YES if the receiver has alpha, otherwise NO
 */
- (BOOL)KLO_hasAlpha;

/**
 Creates and returns a UIImage by resizing *image* to *size* while maintaining its aspect ratio.
 
 @param image The UIImage to resize
 @param size The target size
 @return The resized image
 */
+ (nullable UIImage *)KLO_imageByResizingImage:(UIImage *)image toSize:(CGSize)size;
/**
 Returns `[UIImage BB_imageByResizingImage:self toSize:size]`.
 
 @param size The target size
 @return The resized image
 */
- (nullable UIImage *)KLO_imageByResizingToSize:(CGSize)size;

/**
 Creates a new image by blurring *image* using a box blur.
 
 @param image The original image
 @param radius A value greater than 0.0 describing the blur radius to use
 @return The blurred image
 @exception NSException Thrown if *image* is nil
 */
+ (nullable UIImage *)KLO_imageByBlurringImage:(UIImage *)image radius:(CGFloat)radius;
/**
 Calls `+[UIImage BB_imageByBlurringImage:radius:]`, passing self and _radius_ respectively.
 
 @param radius A value greater than 0.0 describing the blur radius to use
 @return The blurred image
 */
- (nullable UIImage *)KLO_imageByBlurringWithRadius:(CGFloat)radius;

/**
 Creates a new image by adjusting the brightness of image by delta. The delta parameter should be between -1.0 and 1.0, with negative numbers making the image darker and positive numbers making it lighter by a percentage. For example, 0.5 would return an image that is 50 percent brighter than the original. The delta parameter is clamped between -1.0 and 1.0, when larger values are provided.
 
 @param image The image to brighten or darken
 @param delta The amount to brighten or darken the image
 @return The brightened or darkened image
 @exception NSException Thrown if _image_ is nil
 */
+ (nullable UIImage *)KLO_imageByAdjustingBrightnessOfImage:(UIImage *)image delta:(CGFloat)delta;
/**
 Calls `+[UIImage BB_imageByAdjustingBrightnessOfImage:delta:]`, passing self and _delta_ respectively.
 
 @param delta The amount to brighten or darken the image
 @return The brightened or darkened image
 */
- (nullable UIImage *)KLO_imageByAdjustingBrightnessBy:(CGFloat)delta;

/**
 Creates a new image by adjusting the contrast of image by delta. The delta parameter should be between -1.0 and 1.0, with negative numbers decreasing the contrast and positive numbers increasing the contrast by a percentage. For example, 0.5 would return an image where the contrast has been increased by 50 percent over the original. The delta parameter is clamped between -1.0 and 1.0, when larger values are provided.
 
 @param image The image whose contrast to adjust
 @param delta The amount to adjust the image contrast by
 @return The image with its contrast adjusted
 @exception NSException Thrown if _image_ is nil
 */
+ (nullable UIImage *)KLO_imageByAdjustingContrastOfImage:(UIImage *)image delta:(CGFloat)delta;
/**
 Calls `+[UIImage BB_imageByAdjustingContrastOfImage:delta:]`, passing self and _delta_ respectively.
 
 @param delta The amount to adjust the image contrast by
 @return The image with its contrast adjusted
 */
- (nullable UIImage *)KLO_imageByAdjustingContrastBy:(CGFloat)delta;

@end

NS_ASSUME_NONNULL_END
