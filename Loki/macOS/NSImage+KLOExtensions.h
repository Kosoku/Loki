//
//  NSImage+KLOExtensions.h
//  Loki
//
//  Created by William Towe on 3/9/17.
//  Copyright © 2020 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (KLOExtensions)

/**
 Returns whether the receiver has an alpha component.
 
 @return YES if the receiver has alpha, otherwise NO
 */
- (BOOL)KLO_hasAlpha;

/**
 Creates a new image by first drawing the image then drawing a rectangle of color over it.
 
 @param image The original image
 @param color The color to overlay on top of the image, it should have some level of opacity
 @return The tinted image
 @exception NSException Thrown if _image_ or _color_ are nil
 */
+ (NSImage *)KLO_imageByHighlightingImage:(NSImage *)image withColor:(NSColor *)color;
/**
 Calls `+[NSImage KLO_imageByHighlightingImage:withColor:]`, passing self and _color_ respectively.
 
 @param color The color to overlay on top of the image, it should have some level of opacity
 @return The tinted image
 */
- (NSImage *)KLO_imageByHighlightingWithColor:(NSColor *)color;

/**
 Creates and returns a NSImage by tinting _image_ with _color_.
 
 @param image The NSImage to render as a template
 @param color The NSColor to use when rendering _image_
 @return The rendered template image
 @exception NSException Thrown if _image_ or _color_ are nil
 */
+ (NSImage *)KLO_imageByTintingImage:(NSImage *)image withColor:(NSColor *)color;
/**
 Calls `[NSImage KLO_imageByTingtingImage:self withColor:color]`.
 
 @param color The NSColor to use when rendering self
 @return The rendered template image
 */
- (NSImage *)KLO_imageByTintingWithColor:(NSColor *)color;

/**
 Returns a resizable image drawn as 1x1 with the provided color and its resizingMode property set to NSImageResizingModeTile.
 
 @param color The color to use when filling the image
 @return The resizable image
 */
+ (NSImage *)KLO_resizableImageWithColor:(NSColor *)color;

/**
 Returns `[NSImage KLO_imageByResizingImage:self toSize:size]` with proper aspect ratio when you only know the width of the target CGSize.
 
 @param image The image to resize
 @param width The width to resize to
 @return The resized image
 */
+ (nullable NSImage *)KLO_imageByResizingImage:(NSImage *)image withWidth:(CGFloat)width;
/**
 Returns `[NSImage KLO_imageByResizingImage:self withWidth:width]`.
 
 @param width The width to resize to
 @return The resized image
 */
- (nullable NSImage *)KLO_imageByResizingWithWidth:(CGFloat)width;
/**
 Returns `[NSImage KLO_imageByResizingImage:self toSize:size]` with proper aspect ratio when you only know the height of the target CGSize.
 
 @param image The image to resize
 @param height The target to resize to
 @return The resized image
 */
+ (nullable NSImage *)KLO_imageByResizingImage:(NSImage *)image withHeight:(CGFloat)height;
/**
 Returns `[NSImage KLO_imageByResizingImage:self withHeight:height]`.
 
 @param height The height to resize to
 @return The resized image
 */
- (nullable NSImage *)KLO_imageByResizingWithHeight:(CGFloat)height;
/**
 Creates and returns a NSImage by resizing *image* to *size* while maintaining its aspect ratio.
 
 @param image The NSImage to resize
 @param size The target size
 @return The resized image
 */
+ (nullable NSImage *)KLO_imageByResizingImage:(NSImage *)image toSize:(NSSize)size;
/**
 Returns `[NSImage KLO_imageByResizingImage:self toSize:size]`.
 */
- (nullable NSImage *)KLO_imageByResizingToSize:(NSSize)size;
/**
 Creates and returns a UIImage by resizing *image* to *size* and optionally maintaining its aspect ratio.
 
 @param image The UIImage to resize
 @param size The target size
 @param maintainAspectRatio Whether to maintain the aspect ratio of the receiver or scale to fill
 @return The resized image
 */
+ (nullable NSImage *)KLO_imageByResizingImage:(NSImage *)image toSize:(NSSize)size maintainAspectRatio:(BOOL)maintainAspectRatio;
/**
 Returns `[UIImage KLO_imageByResizingImage:self toSize:size maintainAspectRatio:maintainAspectRatio]`.
 */
- (nullable NSImage *)KLO_imageByResizingToSize:(NSSize)size maintainAspectRatio:(BOOL)maintainAspectRatio;

/**
 Creates a new image by blurring *image* using a box blur.
 
 @param image The original image
 @param radius A value greater than 0.0 describing the blur radius to use
 @return The blurred image
 @exception NSException Thrown if *image* is nil
 */
+ (nullable NSImage *)KLO_imageByBlurringImage:(NSImage *)image radius:(CGFloat)radius;
/**
 Calls `[NSImage KLO_imageByBlurringImage:self radius:radius]`.
 
 @param radius A value greater than 0.0 describing the blur radius to use
 @return The blurred image
 */
- (nullable NSImage *)KLO_imageByBlurringWithRadius:(CGFloat)radius;

/**
 Creates a new image by adjusting the brightness of image by delta. The delta parameter should be between -1.0 and 1.0, with negative numbers making the image darker and positive number making it lighter by a percentage. For example, 0.5 would return an image that is 50 percent brighter than the original. The delta parameter is clamped between -1.0 and 1.0, when larger values are provided.
 
 @param image The image to brighten or darken
 @param delta The amount to brighten or darken the image
 @return The brightened or darkened image
 @exception NSException Thrown if _image_ is nil
 */
+ (nullable NSImage *)KLO_imageByAdjustingBrightnessOfImage:(NSImage *)image delta:(CGFloat)delta;
/**
 Calls `[NSImage KLO_imageByAdjustingBrightnessOfImage:self delta:delta]`.
 
 @param delta The amount to brighten or darken the image
 @return The brightened or darkened image
 */
- (nullable NSImage *)KLO_imageByAdjustingBrightnessBy:(CGFloat)delta;

/**
 Creates a new image by adjusting the contrast of image by delta. The delta parameter should be between -1.0 and 1.0, with negative numbers decreasing the contrast and positive numbers increasing the contrast by a percentage. For example, 0.5 would return an image where the contrast has been increased by 50 percent over the original. The delta parameter is clamped between -1.0 and 1.0, when larger values are provided.
 
 @param image The image whose contrast to adjust
 @param delta The amount to adjust the image contrast by
 @return The image with its contrast adjusted
 @exception NSException Thrown if _image_ is nil
 */
+ (nullable NSImage *)KLO_imageByAdjustingContrastOfImage:(NSImage *)image delta:(CGFloat)delta;
/**
 Calls `[NSImage KLO_imageByAdjustingContrastOfImage:self delta:delta]`.
 
 @param delta The amount to adjust the image contrast by
 @return The image with its contrast adjusted
 */
- (nullable NSImage *)KLO_imageByAdjustingContrastBy:(CGFloat)delta;

/**
 Creates a new image by adjusting the saturation of image by delta. Values less than 1.0 will desaturate the image, values greater than 1.0 will supersaturate the image.
 
 @param image The image to desaturate or supersaturate
 @param delta The amount to adjust the image saturation
 @return The image with adjusted saturation
 @exception NSException Thrown if _image_ is nil
 */
+ (nullable NSImage *)KLO_imageByAdjustingSaturationOfImage:(NSImage *)image delta:(CGFloat)delta;
/**
 Calls `[NSImage KLO_imageByAdjustingSaturationOfImage:self delta:delta]`.
 
 @param delta The amount to adjust the image saturation
 @return The image with adjusted saturation
 */
- (nullable NSImage *)KLO_imageByAdjustingSaturationBy:(CGFloat)delta;

@end

NS_ASSUME_NONNULL_END
