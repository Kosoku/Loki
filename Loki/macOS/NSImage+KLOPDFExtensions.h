//
//  NSImage+KLOPDFExtensions.h
//  Loki-macOS
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

#import <Loki/KLODefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (KLOPDFExtensions)

@property (class,assign,nonatomic) KLOPDFOptions KLO_defaultPDFOptions;

#pragma mark -
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName width:(CGFloat)width;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName width:(CGFloat)width page:(NSUInteger)page;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName width:(CGFloat)width page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark -
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName height:(CGFloat)height;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName height:(CGFloat)height page:(NSUInteger)page;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName height:(CGFloat)height page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark -
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName size:(NSSize)size;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName size:(NSSize)size page:(NSUInteger)page;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName size:(NSSize)size page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark -
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle width:(CGFloat)width;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle width:(CGFloat)width page:(NSUInteger)page;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle width:(CGFloat)width page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark -
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle height:(CGFloat)height;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle height:(CGFloat)height page:(NSUInteger)page;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle height:(CGFloat)height page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark -
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle size:(NSSize)size;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle size:(NSSize)size page:(NSUInteger)page;
+ (nullable NSImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle size:(NSSize)size page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark -
+ (nullable NSImage *)KLO_imageWithPDFAtURL:(NSURL *)URL width:(CGFloat)width;
+ (nullable NSImage *)KLO_imageWithPDFAtURL:(NSURL *)URL width:(CGFloat)width page:(NSUInteger)page;
+ (nullable NSImage *)KLO_imageWithPDFAtURL:(NSURL *)URL width:(CGFloat)width page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark -
+ (nullable NSImage *)KLO_imageWithPDFAtURL:(NSURL *)URL height:(CGFloat)height;
+ (nullable NSImage *)KLO_imageWithPDFAtURL:(NSURL *)URL height:(CGFloat)height page:(NSUInteger)page;
+ (nullable NSImage *)KLO_imageWithPDFAtURL:(NSURL *)URL height:(CGFloat)height page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark -
+ (nullable NSImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(NSSize)size;
+ (nullable NSImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(NSSize)size page:(NSUInteger)page;
+ (nullable NSImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(NSSize)size page:(NSUInteger)page options:(KLOPDFOptions)options;

@end

NS_ASSUME_NONNULL_END
