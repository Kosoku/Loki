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

#import "UIImage+KLOExtensions.h"
#import "KLOCGImageFunctions.h"

@implementation UIImage (KLOExtensions)

- (BOOL)KLO_hasAlpha; {
    return KLOCGImageHasAlpha(self.CGImage);
}

+ (UIImage *)KLO_imageByResizingImage:(UIImage *)image toSize:(CGSize)size; {
    CGImageRef imageRef = KLOCGImageCreateThumbnailWithSizeMaintainingAspectRatio(image.CGImage, size, true);
    
    if (imageRef == NULL) {
        return nil;
    }
    
    UIImage *retval = [[UIImage alloc] initWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (UIImage *)KLO_imageByResizingToSize:(CGSize)size; {
    return [UIImage KLO_imageByResizingImage:self toSize:size];
}

+ (UIImage *)KLO_imageByBlurringImage:(UIImage *)image radius:(CGFloat)radius; {
    CGImageRef imageRef = KLOCGImageCreateImageByBlurringImageWithRadius(image.CGImage, radius * [UIScreen mainScreen].scale);
    
    if (imageRef == NULL) {
        return nil;
    }
    
    UIImage *retval = [[UIImage alloc] initWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (UIImage *)KLO_imageByBlurringWithRadius:(CGFloat)radius; {
    return [UIImage KLO_imageByBlurringImage:self radius:radius];
}

@end
