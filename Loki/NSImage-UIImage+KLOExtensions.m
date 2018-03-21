//
//  UIImage+KLOExtensions.m
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

#import <TargetConditionals.h>

#if (TARGET_OS_IPHONE)
#import "UIImage+KLOExtensions.h"
#else
#import "NSImage+KLOExtensions.h"
#endif
#import "KLOCGImageFunctions.h"

#if (TARGET_OS_IPHONE)
#define KLOSize CGSize
#define KLOSizeMake(w,h) CGSizeMake((w),(h))
#define CGSizeFromKLOSize(s) (s)
#define KLOImage UIImage
#define KLOColor UIColor
#define KLOCGImageFromImage(theImage) (theImage.CGImage)
#define KLOImageFromCGImageAndImage(theImageRef,theImage) ([[UIImage alloc] initWithCGImage:theImageRef scale:theImage.scale orientation:theImage.imageOrientation])
#else
#define KLOSize NSSize
#define KLOSizeMake(w,h) NSMakeSize((w),(h))
#define CGSizeFromKLOSize(s) NSSizeFromCGSize(s)
#define KLOImage NSImage
#define KLOColor NSColor
#define KLOCGImageFromImage(theImage) ([theImage CGImageForProposedRect:NULL context:nil hints:nil])
#define KLOImageFromCGImageAndImage(theImageRef,theImage) ([[NSImage alloc] initWithCGImage:theImageRef size:NSZeroSize])
#endif

#if (TARGET_OS_IPHONE)
@implementation UIImage (KLOExtensions)
#else
@implementation NSImage (KLOExtensions)
#endif

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
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
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
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
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
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0);
    
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
    CGImageRef imageRef = KLOCGImageCreateThumbnailWithSizeMaintainingAspectRatio(KLOCGImageFromImage(image), CGSizeFromKLOSize(size), maintainAspectRatio);
    
    if (imageRef == NULL) {
        return nil;
    }
    
    KLOImage *retval = KLOImageFromCGImageAndImage(imageRef,image);
    
    CGImageRelease(imageRef);
    
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
