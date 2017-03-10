//
//  KLOCGImageFunctions.m
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

#import "KLOCGImageFunctions.h"

#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>

#define KLOBoundedValue(value, min, max) MAX(MIN((value), (max)), (min))

static CGSize KLOCGImageThumbnailSizeFromSizeMaintainingAspectRatio(CGImageRef imageRef, CGSize size, bool maintainAspectRatio) {
    return maintainAspectRatio ? AVMakeRectWithAspectRatioInsideRect(CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)), CGRectMake(0, 0, size.width, size.height)).size : size;
}

bool KLOCGImageHasAlpha(CGImageRef imageRef) {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    return (alphaInfo == kCGImageAlphaFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaPremultipliedLast);
}

CGImageRef KLOCGImageCreateThumbnailWithSizeMaintainingAspectRatio(CGImageRef imageRef, CGSize size, bool maintainAspectRatio) {
    if (imageRef == NULL) {
        return NULL;
    }
    
    NSCParameterAssert(!CGSizeEqualToSize(size, CGSizeZero));
    
    CGSize destSize = KLOCGImageThumbnailSizeFromSizeMaintainingAspectRatio(imageRef, size, maintainAspectRatio);
    vImage_Buffer source;
    vImage_CGImageFormat imageFormat = {(uint32_t)CGImageGetBitsPerComponent(imageRef), (uint32_t)CGImageGetBitsPerPixel(imageRef), CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef), 0, NULL, kCGRenderingIntentDefault};
    vImage_Error error = vImageBuffer_InitWithCGImage(&source, &imageFormat, NULL, imageRef, kvImageNoFlags);
    
    if (error != kvImageNoError) {
        free(source.data);
        return NULL;
    }
    
    vImage_Buffer destination;
    error = vImageBuffer_Init(&destination, (vImagePixelCount)destSize.height, (vImagePixelCount)destSize.width, (uint32_t)CGImageGetBitsPerPixel(imageRef), kvImageNoFlags);
    
    if (error != kvImageNoError) {
        free(source.data);
        free(destination.data);
        return NULL;
    }
    
    error = vImageScale_ARGB8888(&source, &destination, NULL, kvImageHighQualityResampling|kvImageEdgeExtend);
    
    if (error != kvImageNoError) {
        free(source.data);
        free(destination.data);
        return NULL;
    }
    
    CGImageRef destImageRef = vImageCreateCGImageFromBuffer(&destination, &imageFormat, NULL, NULL, kvImageNoFlags, &error);
    
    free(source.data);
    free(destination.data);
    
    if (error != kvImageNoError) {
        CGImageRelease(destImageRef);
        return NULL;
    }
    
    return destImageRef;
}

CGImageRef KLOCGImageCreateImageByBlurringImageWithRadius(CGImageRef imageRef, CGFloat radius) {
    if (imageRef == NULL) {
        return NULL;
    }
    
    // compute boxSize based on gassian blur radius http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
    uint32_t boxSize = floor(radius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5);
    
    // the boxSize must be odd
    boxSize += (boxSize + 1) % 2;
    
    // setup source and destination buffers for accelerate to work on
    CGSize destSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    vImage_Buffer source;
    vImage_CGImageFormat imageFormat = {(uint32_t)CGImageGetBitsPerComponent(imageRef), (uint32_t)CGImageGetBitsPerPixel(imageRef), CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef), 0, NULL, kCGRenderingIntentDefault};
    vImage_Error error = vImageBuffer_InitWithCGImage(&source, &imageFormat, NULL, imageRef, kvImageNoFlags);
    
    if (error != kvImageNoError) {
        free(source.data);
        return NULL;
    }
    
    vImage_Buffer destination;
    error = vImageBuffer_Init(&destination, (vImagePixelCount)destSize.height, (vImagePixelCount)destSize.width, (uint32_t)CGImageGetBitsPerPixel(imageRef), kvImageNoFlags);
    
    if (error != kvImageNoError) {
        free(source.data);
        free(destination.data);
        return NULL;
    }
    
    error = vImageBoxConvolve_ARGB8888(&source, &destination, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&destination, &source, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&source, &destination, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error != kvImageNoError) {
        free(source.data);
        free(destination.data);
        return NULL;
    }
    
    CGImageRef destImageRef = vImageCreateCGImageFromBuffer(&destination, &imageFormat, NULL, NULL, kvImageNoFlags, &error);
    
    free(source.data);
    free(destination.data);
    
    if (error != kvImageNoError) {
        CGImageRelease(destImageRef);
        return NULL;
    }
    
    return destImageRef;
}

CGImageRef KLOCGImageCreateImageByAdjustingBrightnessOfImageByDelta(CGImageRef imageRef, CGFloat delta) {
    if (imageRef == NULL) {
        return NULL;
    }
    
    // assume -1.0 to 1.0 range for delta, clamp actual value to -255 to 255
    float floatDelta = KLOBoundedValue(floor(delta * 255.0), -255.0, 255.0);
    
    size_t width = (size_t)CGImageGetWidth(imageRef);
    size_t height = (size_t)CGImageGetHeight(imageRef);
    
    // create a context to draw original image into
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGBitmapByteOrderDefault | (KLOCGImageHasAlpha(imageRef) ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst));
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    // grab the raw pixel data
    unsigned char *data = CGBitmapContextGetData(context);
    
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    
    // convert the raw data to float, since we are using the accelerate flt functions
    size_t numberOfPixels = width * height;
    float *floatData = malloc(sizeof(float) * numberOfPixels);
    float minimum = 0, maximum = 255;
    
    // red
    vDSP_vfltu8(data + 1, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &floatDelta, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 1, 4, numberOfPixels);
    
    // green
    vDSP_vfltu8(data + 2, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &floatDelta, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 2, 4, numberOfPixels);
    
    // blue
    vDSP_vfltu8(data + 3, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &floatDelta, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 3, 4, numberOfPixels);
    
    CGImageRef destImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    free(floatData);
    
    return destImageRef;
}

CGImageRef KLOCGImageCreateImageByAdjustingContrastOfImageByDelta(CGImageRef imageRef, CGFloat delta) {
    if (imageRef == NULL) {
        return NULL;
    }
    
    // assume -1.0 to 1.0 range for delta, clamp actual value to -255 to 255
    float floatDelta = KLOBoundedValue(floor(delta * 255.0), -255.0, 255.0);
    
    size_t width = (size_t)CGImageGetWidth(imageRef);
    size_t height = (size_t)CGImageGetHeight(imageRef);
    
    // create a context to draw original image into
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGBitmapByteOrderDefault | (KLOCGImageHasAlpha(imageRef) ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst));
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        return NULL;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    // grab the raw pixel data
    unsigned char *data = CGBitmapContextGetData(context);
    
    if (!data) {
        CGContextRelease(context);
        return NULL;
    }
    
    // convert the raw data to float, since we are using the accelerate flt functions
    size_t numberOfPixels = width * height;
    float *floatData = malloc(sizeof(float) * numberOfPixels);
    float minimum = 0, maximum = 255;
    
    // contrast factor
    float contrast = (259.0f * (floatDelta + 255.0f)) / (255.0f * (259.0f - floatDelta));
    float v1 = -128.0f, v2 = 128.0f;
    
    // red
    vDSP_vfltu8(data + 1, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v1, floatData, 1, numberOfPixels);
    vDSP_vsmul(floatData, 1, &contrast, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v2, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 1, 4, numberOfPixels);
    
    // green
    vDSP_vfltu8(data + 2, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v1, floatData, 1, numberOfPixels);
    vDSP_vsmul(floatData, 1, &contrast, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v2, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 2, 4, numberOfPixels);
    
    // blue
    vDSP_vfltu8(data + 3, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v1, floatData, 1, numberOfPixels);
    vDSP_vsmul(floatData, 1, &contrast, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v2, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 3, 4, numberOfPixels);
    
    CGImageRef destImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    free(floatData);
    
    return destImageRef;
}
