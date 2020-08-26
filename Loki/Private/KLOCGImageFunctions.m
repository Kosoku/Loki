//
//  KLOCGImageFunctions.m
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

#import "KLOCGImageFunctions.h"

#if (!TARGET_OS_WATCH)
#import <Accelerate/Accelerate.h>
#endif

#define KLOBoundedValue(value, min, max) MAX(MIN((value), (max)), (min))

CGSize KLOCGImageThumbnailSizeFromSizeMaintainingAspectRatio(CGImageRef imageRef, CGSize size, bool maintainAspectRatio) {
    if (maintainAspectRatio) {
        CGFloat width = CGImageGetWidth(imageRef);
        CGFloat height = CGImageGetHeight(imageRef);
        CGFloat widthScale = size.width / width;
        CGFloat heightScale = size.height / height;
        CGFloat scale = MIN(widthScale, heightScale);
        CGSize retval = CGSizeMake(ceil(width * scale), ceil(height * scale));
        
        return retval;
    }
    else {
        return size;
    }
}

bool KLOCGImageHasAlpha(CGImageRef imageRef) {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    return (alphaInfo == kCGImageAlphaFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaPremultipliedLast);
}

#if (!TARGET_OS_WATCH)
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
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    // grab the raw pixel data
    unsigned char *data = CGBitmapContextGetData(context);
    
    if (!data) {
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
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
    CGColorSpaceRelease(colorSpace);
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
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    // grab the raw pixel data
    unsigned char *data = CGBitmapContextGetData(context);
    
    if (!data) {
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
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
    CGColorSpaceRelease(colorSpace);
    free(floatData);
    
    return destImageRef;
}

CGImageRef KLOCGImageCreateImageByAdjustingSaturationOfImageByDelta(CGImageRef _Nullable imageRef, CGFloat delta) {
    if (imageRef == NULL) {
        return NULL;
    }
    
    // http://www.w3.org/TR/filter-effects-1/#elementdef-fecolormatrix
    CGFloat floatingPointSaturationMatrix[] = {
        0.0722 + 0.9278 * delta,  0.0722 - 0.0722 * delta,  0.0722 - 0.0722 * delta,  0,
        0.7152 - 0.7152 * delta,  0.7152 + 0.2848 * delta,  0.7152 - 0.7152 * delta,  0,
        0.2126 - 0.2126 * delta,  0.2126 - 0.2126 * delta,  0.2126 + 0.7873 * delta,  0,
        0,                    0,                    0,                    1,
    };
    
    // the maxtrix elements passed to accelerate need to be int16_t, this snippet converts them
    int32_t divisor = 256;
    NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
    int16_t saturationMatrix[matrixSize];
    for (NSUInteger i = 0; i < matrixSize; i++) {
        saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
    }
    
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
    
    // perform the matrix multiply adjusting the saturation
    error = vImageMatrixMultiply_ARGB8888(&source, &destination, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
    
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
#endif
