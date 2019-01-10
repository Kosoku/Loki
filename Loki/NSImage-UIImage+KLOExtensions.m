//
//  UIImage+KLOExtensions.m
//  Loki
//
//  Created by William Towe on 3/9/17.
//  Copyright © 2019 Kosoku Interactive, LLC. All rights reserved.
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

#import <TargetConditionals.h>
#import "KLODefines.h"

#if (TARGET_OS_IPHONE)
#import "UIImage+KLOExtensions.h"
#else
#import "NSImage+KLOExtensions.h"
#endif
#import "KLOCGImageFunctions.h"

#if (TARGET_OS_IPHONE)
#define CGSizeFromKLOSize(s) (s)
#define KLOCGImageFromImage(theImage) (theImage.CGImage)
#define KLOImageFromCGImageAndImage(theImageRef,theImage) ([[UIImage alloc] initWithCGImage:theImageRef scale:theImage.scale orientation:theImage.imageOrientation])
#else
#define CGSizeFromKLOSize(s) NSSizeFromCGSize(s)
#define KLOCGImageFromImage(theImage) ([theImage CGImageForProposedRect:NULL context:nil hints:nil])
#define KLOImageFromCGImageAndImage(theImageRef,theImage) ([[NSImage alloc] initWithCGImage:theImageRef size:NSZeroSize])
#endif

@implementation KLOImage (KLOExtensions)

- (BOOL)KLO_hasAlpha; {
#if (TARGET_OS_IPHONE)
    return KLOCGImageHasAlpha(self.CGImage);
#else
    return KLOCGImageHasAlpha([self CGImageForProposedRect:NULL context:nil hints:nil]);
#endif
}

+ (KLOImage *)KLO_imageByHighlightingImage:(KLOImage *)image withColor:(KLOColor *)color; {
    NSParameterAssert(image);
    NSParameterAssert(color);
    
    KLOImage *retval;
    
#if (TARGET_OS_IPHONE)
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    CGContextClipToMask(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    CGContextSetFillColorWithColor(context, color.CGColor);
    UIRectFillUsingBlendMode(CGRectMake(0, 0, image.size.width, image.size.height), kCGBlendModeNormal);
    
    retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retval;
#else
    retval = [image copy];
    
    [retval setTemplate:NO];
    
    [retval lockFocus];
    
    [color set];
    NSRectFillUsingOperation(NSMakeRect(0, 0, retval.size.width, retval.size.height), NSCompositingOperationColor);
    
    [retval unlockFocus];
#endif
    
    return retval;
}
- (KLOImage *)KLO_imageByHighlightingWithColor:(KLOColor *)color; {
    return [KLOImage KLO_imageByHighlightingImage:self withColor:color];
}

+ (KLOImage *)KLO_imageByTintingImage:(KLOImage *)image withColor:(KLOColor *)color {
    NSParameterAssert(image);
    NSParameterAssert(color);
    
    KLOImage *retval;
    
#if (TARGET_OS_IPHONE)
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    
    [color setFill];
    [[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0];
    
    retval = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIGraphicsEndImageContext();
#else
    retval = [image copy];
    
    [retval setTemplate:NO];
    
    [retval lockFocus];
    
    [color set];
    NSRectFillUsingOperation(NSMakeRect(0, 0, retval.size.width, retval.size.height), NSCompositingOperationSourceAtop);
    
    [retval unlockFocus];
#endif
    
    return retval;
}
- (KLOImage *)KLO_imageByTintingWithColor:(KLOColor *)color {
    return [KLOImage KLO_imageByTintingImage:self withColor:color];
}

+ (KLOImage *)KLO_resizableImageWithColor:(KLOColor *)color {
    NSParameterAssert(color);
    
    KLOImage *retval;
    
#if (TARGET_OS_IPHONE)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0.0);
    
    [color setFill];
    UIRectFill(CGRectMake(0, 0, 1, 1));
    
    retval = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    UIGraphicsEndImageContext();
#else
    retval = [[NSImage alloc] initWithSize:NSMakeSize(1, 1)];
    
    [retval setResizingMode:NSImageResizingModeTile];
    
    [retval lockFocus];
    
    [color setFill];
    NSRectFill(NSMakeRect(0, 0, 1, 1));
    
    [retval unlockFocus];
#endif
    
    return retval;
}

+ (KLOImage *)KLO_imageByResizingImage:(KLOImage *)image withWidth:(CGFloat)width {
    CGFloat newHeight = width * (image.size.height / image.size.width);
    KLOSize targetSize = KLOSizeMake(width, newHeight);
    
    return [KLOImage KLO_imageByResizingImage:image toSize:targetSize];
}
- (KLOImage *)KLO_imageByResizingWithWidth:(CGFloat)width; {
    return [KLOImage KLO_imageByResizingImage:self withWidth:width];
}
+ (KLOImage *)KLO_imageByResizingImage:(KLOImage *)image withHeight:(CGFloat)height {
    CGFloat newWidth = height * (image.size.width / image.size.height);
    KLOSize targetSize = KLOSizeMake(newWidth, height);
    
    return [KLOImage KLO_imageByResizingImage:image toSize:targetSize];
}
- (KLOImage *)KLO_imageByResizingWithHeight:(CGFloat)height; {
    return [KLOImage KLO_imageByResizingImage:self withHeight:height];
}
+ (KLOImage *)KLO_imageByResizingImage:(KLOImage *)image toSize:(KLOSize)size; {
    return [self KLO_imageByResizingImage:image toSize:size maintainAspectRatio:YES];
}
- (KLOImage *)KLO_imageByResizingToSize:(CGSize)size; {
    return [KLOImage KLO_imageByResizingImage:self toSize:size];
}
+ (KLOImage *)KLO_imageByResizingImage:(KLOImage *)image toSize:(KLOSize)size maintainAspectRatio:(BOOL)maintainAspectRatio; {
    CGSize destSize = KLOCGImageThumbnailSizeFromSizeMaintainingAspectRatio(KLOCGImageFromImage(image), CGSizeFromKLOSize(size), maintainAspectRatio);
    KLOImage *retval = nil;
    
#if (TARGET_OS_IPHONE)
    UIGraphicsBeginImageContextWithOptions(destSize, ![image KLO_hasAlpha], 0.0);
    
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    
    [image drawInRect:CGRectMake(0, 0, destSize.width, destSize.height)];
    
    retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
#else
    NSImage *temp = [[NSImage alloc] initWithSize:destSize];
    
    [temp lockFocus];
    
    NSGraphicsContext.currentContext.imageInterpolation = NSImageInterpolationHigh;
    
    [image drawInRect:NSMakeRect(0, 0, destSize.width, destSize.height)];
    
    [temp unlockFocus];
    
    retval = temp;
#endif
    
    return retval;
}
- (KLOImage *)KLO_imageByResizingToSize:(KLOSize)size maintainAspectRatio:(BOOL)maintainAspectRatio; {
    return [KLOImage KLO_imageByResizingImage:self toSize:size maintainAspectRatio:maintainAspectRatio];
}

#if (!TARGET_OS_WATCH)
+ (KLOImage *)KLO_imageByBlurringImage:(KLOImage *)image radius:(CGFloat)radius; {
#if (TARGET_OS_IPHONE)
    radius = radius * [UIScreen mainScreen].scale;
#else
    radius = radius * [NSScreen mainScreen].backingScaleFactor;
#endif
    
    CGImageRef imageRef = KLOCGImageCreateImageByBlurringImageWithRadius(KLOCGImageFromImage(image), radius);
    
    if (imageRef == NULL) {
        return nil;
    }
    
    KLOImage *retval = KLOImageFromCGImageAndImage(imageRef,image);
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (KLOImage *)KLO_imageByBlurringWithRadius:(CGFloat)radius; {
    return [KLOImage KLO_imageByBlurringImage:self radius:radius];
}

+ (KLOImage *)KLO_imageByAdjustingBrightnessOfImage:(KLOImage *)image delta:(CGFloat)delta; {
    CGImageRef imageRef = KLOCGImageCreateImageByAdjustingBrightnessOfImageByDelta(KLOCGImageFromImage(image), delta);
    
    if (imageRef == NULL) {
        return nil;
    }
    
    KLOImage *retval = KLOImageFromCGImageAndImage(imageRef,image);
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (KLOImage *)KLO_imageByAdjustingBrightnessBy:(CGFloat)delta; {
    return [KLOImage KLO_imageByAdjustingBrightnessOfImage:self delta:delta];
}

+ (KLOImage *)KLO_imageByAdjustingContrastOfImage:(KLOImage *)image delta:(CGFloat)delta {
    CGImageRef imageRef = KLOCGImageCreateImageByAdjustingContrastOfImageByDelta(KLOCGImageFromImage(image), delta);
    
    if (imageRef == NULL) {
        return nil;
    }
    
    KLOImage *retval = KLOImageFromCGImageAndImage(imageRef,image);
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (KLOImage *)KLO_imageByAdjustingContrastBy:(CGFloat)delta {
    return [KLOImage KLO_imageByAdjustingContrastOfImage:self delta:delta];
}

+ (KLOImage *)KLO_imageByAdjustingSaturationOfImage:(KLOImage *)image delta:(CGFloat)delta {
    CGImageRef imageRef = KLOCGImageCreateImageByAdjustingSaturationOfImageByDelta(KLOCGImageFromImage(image), delta);
    
    if (imageRef == NULL) {
        return nil;
    }
    
    KLOImage *retval = KLOImageFromCGImageAndImage(imageRef,image);
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (KLOImage *)KLO_imageByAdjustingSaturationBy:(CGFloat)delta {
    return [KLOImage KLO_imageByAdjustingSaturationOfImage:self delta:delta];
}
#endif

@end
