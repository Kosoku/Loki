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
#define KLOImage UIImage
#define KLOCGImageFromImage(theImage) (theImage.CGImage)
#define KLOImageFromCGImageAndImage(theImageRef,theImage) ([[UIImage alloc] initWithCGImage:theImageRef scale:theImage.scale orientation:theImage.imageOrientation])
#else
#define KLOImage NSImage
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

+ (KLOImage *)KLO_imageByResizingImage:(KLOImage *)image toSize:(CGSize)size; {
    CGImageRef imageRef = KLOCGImageCreateThumbnailWithSizeMaintainingAspectRatio(KLOCGImageFromImage(image), size, true);
    
    if (imageRef == NULL) {
        return nil;
    }
    
    KLOImage *retval = KLOImageFromCGImageAndImage(imageRef,image);
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (KLOImage *)KLO_imageByResizingToSize:(CGSize)size; {
    return [KLOImage KLO_imageByResizingImage:self toSize:size];
}

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

@end
