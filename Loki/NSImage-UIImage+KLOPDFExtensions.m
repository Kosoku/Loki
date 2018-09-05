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

#import <objc/runtime.h>

static CGFloat KLOPDFExtensionsMainScreenScale(void) {
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
static NSUInteger KLOPDFExtensionsBoundedPageForPDFDocumentRefAndPage(CGPDFDocumentRef PDFDocumentRef, NSUInteger page) {
    // pdf page indexes start at 1, so passing 0 should provide the 1st page
    return MAX(MIN(page, CGPDFDocumentGetNumberOfPages(PDFDocumentRef)), 1);
}
static CGRect KLOPDFExtensionsCropBoxRectForPDFDocumentRefAndPage(CGPDFDocumentRef PDFDocumentRef, NSUInteger page) {
    CGPDFPageRef PDFPageRef = CGPDFDocumentGetPage(PDFDocumentRef, KLOPDFExtensionsBoundedPageForPDFDocumentRefAndPage(PDFDocumentRef, page));
    CGRect retval = CGPDFPageGetBoxRect(PDFPageRef, kCGPDFCropBox);
    int rotation = CGPDFPageGetRotationAngle(PDFPageRef);
    
    if (rotation == 90 ||
        rotation == 270) {
        
        CGFloat width = CGRectGetWidth(retval);
        
        retval.size.width = retval.size.height;
        retval.size.height = width;
    }
    
    return retval;
}
static CGPDFDocumentRef KLOPDFExtensionsPDFDocumentRefCreateWithURL(NSURL *URL) {
    return CGPDFDocumentCreateWithURL((__bridge CFURLRef)URL);
}

@interface KLOImage (KLOPDFPrivateExtensions)

@property (class,readonly,nonatomic) NSCache *KLO_PDFImageCache;

+ (NSString *)KLO_PDFImageKeyForURL:(NSURL *)URL size:(KLOSize)size page:(NSUInteger)page;
+ (KLOImage *)KLO_PDFImageForKey:(NSString *)key;
+ (void)KLO_setPDFImage:(KLOImage *)PDFImage forKey:(NSString *)key;

+ (KLOImage *)KLO_imageWithPDFDocumentRef:(CGPDFDocumentRef)PDFDocumentRef size:(KLOSize)size page:(NSUInteger)page options:(KLOPDFOptions)options;

@end

@implementation KLOImage (KLOPDFExtensions)

static void const *kKLO_defaultPDFOptionsKey = &kKLO_defaultPDFOptionsKey;

@dynamic KLO_defaultPDFOptions;
+ (KLOPDFOptions)KLO_defaultPDFOptions {
    NSNumber *temp = objc_getAssociatedObject(self, kKLO_defaultPDFOptionsKey);
    
    if (temp != nil) {
        return temp.unsignedIntegerValue;
    }
    
    return KLOPDFOptionsDefault;
}
+ (void)setKLO_defaultPDFOptions:(KLOPDFOptions)KLO_defaultPDFOptions {
    objc_setAssociatedObject(self, kKLO_defaultPDFOptionsKey, @(KLO_defaultPDFOptions), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (KLOImage *)KLO_imageWithPDFNamed:(NSString *)PDFName size:(KLOSize)size {
    return [self KLO_imageWithPDFNamed:PDFName bundle:NSBundle.mainBundle size:size page:0 options:[self KLO_defaultPDFOptions]];
}
+ (KLOImage *)KLO_imageWithPDFNamed:(NSString *)PDFName size:(KLOSize)size page:(NSUInteger)page; {
    return [self KLO_imageWithPDFNamed:PDFName bundle:NSBundle.mainBundle size:size page:page options:[self KLO_defaultPDFOptions]];
}
+ (KLOImage *)KLO_imageWithPDFNamed:(NSString *)PDFName size:(KLOSize)size page:(NSUInteger)page options:(KLOPDFOptions)options {
    return [self KLO_imageWithPDFNamed:PDFName bundle:NSBundle.mainBundle size:size page:page options:options];
}

+ (KLOImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(NSBundle *)bundle size:(KLOSize)size; {
    return [self KLO_imageWithPDFNamed:PDFName bundle:bundle size:size page:0 options:[self KLO_defaultPDFOptions]];
}
+ (KLOImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(NSBundle *)bundle size:(KLOSize)size page:(NSUInteger)page; {
    return [self KLO_imageWithPDFNamed:PDFName bundle:bundle size:size page:page options:[self KLO_defaultPDFOptions]];
}
+ (KLOImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(NSBundle *)bundle size:(KLOSize)size page:(NSUInteger)page options:(KLOPDFOptions)options; {
    // assume @"pdf" is the extension, if it is not, append it, allows the caller to just pass the name before @"pdf"
    if (![PDFName.pathExtension.lowercaseString isEqualToString:@"pdf"]) {
        PDFName = [PDFName.stringByDeletingPathExtension stringByAppendingPathExtension:@"pdf"];
    }
    
    // search the bundle for the matching resource name
    NSURL *URL = [bundle URLForResource:PDFName.stringByDeletingPathExtension withExtension:PDFName.pathExtension];
    
    return [self KLO_imageWithPDFAtURL:URL size:size page:page options:options];
}

+ (KLOImage *)KLO_imageWithPDFAtURL:(NSURL *)URL width:(CGFloat)width page:(NSUInteger)page options:(KLOPDFOptions)options; {
    CGPDFDocumentRef PDFDocumentRef = KLOPDFExtensionsPDFDocumentRefCreateWithURL(URL);
    
    // if a pdf cannot be created from the provided url, bail early
    if (PDFDocumentRef == NULL) {
        return nil;
    }
    
    CGRect cropBoxRect = KLOPDFExtensionsCropBoxRectForPDFDocumentRefAndPage(PDFDocumentRef, page);
    CGFloat aspectRatio = CGRectGetWidth(cropBoxRect) / CGRectGetHeight(cropBoxRect);
    KLOSize size = KLOSizeMake(width, ceil(width / aspectRatio));
    
    return [self KLO_imageWithPDFDocumentRef:PDFDocumentRef size:size page:page options:options];
}

+ (KLOImage *)KLO_imageWithPDFAtURL:(NSURL *)URL height:(CGFloat)height page:(NSUInteger)page options:(KLOPDFOptions)options; {
    CGPDFDocumentRef PDFDocumentRef = KLOPDFExtensionsPDFDocumentRefCreateWithURL(URL);
    
    // if a pdf cannot be created from the provided url, bail early
    if (PDFDocumentRef == NULL) {
        return nil;
    }
    
    CGRect cropBoxRect = KLOPDFExtensionsCropBoxRectForPDFDocumentRefAndPage(PDFDocumentRef, page);
    CGFloat aspectRatio = CGRectGetWidth(cropBoxRect) / CGRectGetHeight(cropBoxRect);
    KLOSize size = KLOSizeMake(ceil(height * aspectRatio), height);
    
    return [self KLO_imageWithPDFDocumentRef:PDFDocumentRef size:size page:page options:options];
}

+ (KLOImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(KLOSize)size; {
    return [self KLO_imageWithPDFAtURL:URL size:size page:0 options:[self KLO_defaultPDFOptions]];
}
+ (KLOImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(KLOSize)size page:(NSUInteger)page; {
    return [self KLO_imageWithPDFAtURL:URL size:size page:page options:[self KLO_defaultPDFOptions]];
}
+ (KLOImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(KLOSize)size page:(NSUInteger)page options:(KLOPDFOptions)options {
    CGPDFDocumentRef PDFDocumentRef = KLOPDFExtensionsPDFDocumentRefCreateWithURL(URL);
    
    // if a pdf cannot be created from the provided url, bail early
    if (PDFDocumentRef == NULL) {
        return nil;
    }
    
    return [self KLO_imageWithPDFDocumentRef:PDFDocumentRef size:size page:page options:options];
}

@end

@implementation KLOImage (KLOPDFPrivateExtensions)

+ (NSCache *)KLO_PDFImageCache {
    static NSCache *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[NSCache alloc] init];
    });
    return kRetval;
}

+ (NSString *)KLO_PDFImageKeyForURL:(NSURL *)URL size:(KLOSize)size page:(NSUInteger)page; {
#if (TARGET_OS_IPHONE)
    return [NSString stringWithFormat:@"%@ - %@ - %@",URL.absoluteString,NSStringFromCGSize(size),@(page)];
#else
    return [NSString stringWithFormat:@"%@ - %@ - %@",URL.absoluteString,NSStringFromSize(size),@(page)];
#endif
}
+ (KLOImage *)KLO_PDFImageForKey:(NSString *)key {
    return [[self KLO_PDFImageCache] objectForKey:key];
}
+ (void)KLO_setPDFImage:(KLOImage *)PDFImage forKey:(NSString *)key {
    [[self KLO_PDFImageCache] setObject:PDFImage forKey:key cost:PDFImage.size.width * PDFImage.size.height];
}

+ (KLOImage *)KLO_imageWithPDFDocumentRef:(CGPDFDocumentRef)PDFDocumentRef size:(KLOSize)size page:(NSUInteger)page options:(KLOPDFOptions)options; {
    KLOImage *retval = nil;
    
    // if the document ref is NULL, bail early
    if (PDFDocumentRef == NULL) {
        return retval;
    }
    
    // ensure the page index is safe
    page = KLOPDFExtensionsBoundedPageForPDFDocumentRefAndPage(PDFDocumentRef, page);
    
    NSString *key = nil;
    
    if (options & KLOPDFOptionsCacheMemory) {
        key = [self KLO_PDFImageKeyForURL:URL size:size page:page];
        retval = [self KLO_PDFImageForKey:key];
        
        if (retval != nil) {
            return retval;
        }
    }
    
    // get the scale of our main screen, however that is defined
    CGFloat scale = KLOPDFExtensionsMainScreenScale();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    // create the bitmap context to draw our new image into
    CGContextRef contextRef = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, 0, colorSpaceRef, kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedFirst);
    // set to high, this matters more if we are scaling up
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    // scale the context by our scale factor
    CGContextScaleCTM(contextRef, scale, scale);
    
    CGPDFPageRef PDFPageRef = CGPDFDocumentGetPage(PDFDocumentRef, page);
    CGRect destRect = CGRectMake(0, 0, size.width, size.height);
    // check against the options to determine whether aspect ratio should be preserved
    bool preserveAspectRatio = (options & KLOPDFOptionsPreserveAspectRatio) != 0;
    CGAffineTransform drawingTransform = CGPDFPageGetDrawingTransform(PDFPageRef, kCGPDFCropBox, destRect, 0, preserveAspectRatio);
    
    CGFloat PDFScale = size.width / CGRectGetWidth(CGPDFPageGetBoxRect(PDFPageRef, kCGPDFCropBox));
    // if the destination size is larger than the source pdf, upscale the source pdf
    if (PDFScale > 1.0) {
        drawingTransform = CGAffineTransformScale(drawingTransform, PDFScale, PDFScale);
        drawingTransform.tx = 0.0;
        drawingTransform.ty = 0.0;
    }
    
    // apply the drawing transform to our context
    CGContextConcatCTM(contextRef, drawingTransform);
    // draw the page
    CGContextDrawPDFPage(contextRef, PDFPageRef);
    
    // release the document
    CGPDFDocumentRelease(PDFDocumentRef);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
    
#if (TARGET_OS_IPHONE)
    // this initializer tells the image its proper scale and always assumes up orientation because we apply the required drawing transform above
    retval = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
#else
    // this initializer tells the image it should treat itself as the passed in size, regardless of its scale, which may be different (e.g. 2.0 on a retina laptop)
    retval = [[NSImage alloc] initWithCGImage:imageRef size:size];
#endif
    
    // release everything else
    CGImageRelease(imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    if (options & KLOPDFOptionsCacheMemory) {
        [self KLO_setPDFImage:retval forKey:key];
    }
    
    return retval;
}

@end
