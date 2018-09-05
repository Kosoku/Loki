//
//  UIImage+KLOPDFExtensions.m
//  Loki-iOS
//
//  Created by William Towe on 9/5/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <TargetConditionals.h>
#import "KLODefines.h"

#if (TARGET_OS_IPHONE)
#import "UIImage+KLOPDFExtensions.h"
#else
#import "NSImage+KLOPDFExtensions.h"
#endif

static inline CGFloat KLOPDFExtensionsMainScreenScale(void) {
    CGFloat retval = 1.0;
#if (TARGET_OS_WATCH)
    retval = WKInterfaceDevice.currentDevice.screenScale;
#elif (TARGET_OS_IOS || TARGET_OS_TV)
    retval = UIScreen.mainScreen.scale;
#else
    retval = NSScreen.mainScreen.backingScaleFactor;
#endif
    
    return retval;
}

@implementation KLOImage (KLOPDFExtensions)

+ (KLOImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(KLOSize)size page:(NSUInteger)page options:(KLOPDFOptions)options {
    CGFloat scale = KLOPDFExtensionsMainScreenScale();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, 0, colorSpaceRef, kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedFirst);
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    CGContextScaleCTM(contextRef, scale, scale);
    CGPDFDocumentRef PDFDocumentRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)URL);
    
    page = MAX(MIN(page, CGPDFDocumentGetNumberOfPages(PDFDocumentRef)), 1);
    
    CGPDFPageRef PDFPageRef = CGPDFDocumentGetPage(PDFDocumentRef, page);
    CGRect destRect = CGRectMake(0, 0, size.width, size.height);
    CGFloat PDFScale = size.width / CGRectGetWidth(CGPDFPageGetBoxRect(PDFPageRef, kCGPDFCropBox));
    bool preserveAspectRatio = (options & KLOPDFOptionsPreserveAspectRatio) != 0;
    CGAffineTransform transform = CGPDFPageGetDrawingTransform(PDFPageRef, kCGPDFCropBox, destRect, 0, preserveAspectRatio);
    
    // if the destination size is larger than the source pdf, upscale the image
    if (PDFScale > 1.0) {
        transform = CGAffineTransformScale(transform, PDFScale, PDFScale);
        transform.tx = 0.0;
        transform.ty = 0.0;
    }
    
    CGContextConcatCTM(contextRef, transform);
    CGContextDrawPDFPage(contextRef, PDFPageRef);
    
    CGPDFDocumentRelease(PDFDocumentRef);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
    
    KLOImage *retval = nil;
    
#if (TARGET_OS_IPHONE)
    retval = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
#else
    retval = [[NSImage alloc] initWithCGImage:imageRef size:size];
#endif
    
    CGImageRelease(imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    return retval;
}

@end
