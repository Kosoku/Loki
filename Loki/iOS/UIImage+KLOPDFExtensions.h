//
//  UIImage+KLOPDFExtensions.h
//  Loki-iOS
//
//  Created by William Towe on 9/5/18.
//  Copyright © 2021 Kosoku Interactive, LLC. All rights reserved.
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

#import <Loki/KLODefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KLOPDFExtensions)

/**
 Set and get the default PDF options used for any method that does not provide them as a parameter.
 
 The default is KLOPDFOptionsDefault.
 
 @see KLOPDFOptions
 */
@property (class,assign,nonatomic) KLOPDFOptions KLO_defaultPDFOptions;

#pragma mark Name, Width
/**
 Calls KLO_imageWithPDFNamed:width:page:options:, passing *PDFName*, *width*, 0, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param width The desired width of the image, the height will be determined automatically
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName width:(CGFloat)width;
/**
 Calls KLO_imageWithPDFNamed:width:page:options:, passing *PDFName*, *width*, *page*, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param width The desired width of the image, the height will be determined automatically
 @param page The page of the PDF to render
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName width:(CGFloat)width page:(NSUInteger)page;
/**
 Calls KLO_imageWithPDFNamed:bundle:width:page:options:, passing *PDFName*, nil, *width*, *page*, and *options* respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param width The desired width of the image, the height will be determined automatically
 @param page The page of the PDF to render
 @param options The PDF options to use
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName width:(CGFloat)width page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark Name, Height
/**
 Calls KLO_imageWithPDFNamed:height:page:options:, passing *PDFName*, *height*, 0, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param height The desired height of the image, the width will be determined automatically
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName height:(CGFloat)height;
/**
 Calls KLO_imageWithPDFNamed:height:page:options:, passing *PDFName*, *height*, *page*, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param height The desired height of the image, the width will be determined automatically
 @param page The page of the PDF to render
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName height:(CGFloat)height page:(NSUInteger)page;
/**
 Calls KLO_imageWithPDFNamed:bundle:height:page:options:, passing *PDFName*, nil, *height*, *page*, and *options* respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param height The desired height of the image, the width will be determined automatically
 @param page The page of the PDF to render
 @param options The PDF options to use
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName height:(CGFloat)height page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark Name, Size
/**
 Calls KLO_imageWithPDFNamed:size:page:options:, passing *PDFName*, *size*, 0, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param size The desired size of the image
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName size:(CGSize)size;
/**
 Calls KLO_imageWithPDFNamed:size:page:options:, passing *PDFName*, *size*, *page*, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param size The desired size of the image
 @param page The page of the PDF to render
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName size:(CGSize)size page:(NSUInteger)page;
/**
 Calls KLO_imageWithPDFNamed:bundle:size:page:options:, passing *PDFName*, nil, *size*, *page*, and *options* respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param size The desired size of the image
 @param page The page of the PDF to render
 @param options The PDF options to use
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName size:(CGSize)size page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark Name, Bundle, Width
/**
 Calls KLO_imageWithPDFNamed:bundle:width:page:options:, passing *PDFName*, *bundle*, *width*, 0, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param bundle The bundle to search for the PDF, NSBundle.mainBundle is used if nil
 @param width The desired width of the image, the height will be determined automatically
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle width:(CGFloat)width;
/**
 Calls KLO_imageWithPDFNamed:bundle:width:page:options:, passing *PDFName*, *bundle*, *width*, *page*, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param bundle The bundle to search for the PDF, NSBundle.mainBundle is used if nil
 @param width The desired width of the image, the height will be determined automatically
 @param page The page of the PDF to render
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle width:(CGFloat)width page:(NSUInteger)page;
/**
 Calls KLO_imageWithPDFAtURL:width:page:options:, passing the URL to a PDF named *PDFName* in *bundle*, *width*, *page*, and *options* respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param bundle The bundle to search for the PDF, NSBundle.mainBundle is used if nil
 @param width The desired width of the image, the height will be determined automatically
 @param page The page of the PDF to render
 @param options The PDF options to use
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle width:(CGFloat)width page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark Name, Bundle, Height
/**
 Calls KLO_imageWithPDFNamed:bundle:height:page:options:, passing *PDFName*, *bundle*, *height*, 0, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param bundle The bundle to search for the PDF, NSBundle.mainBundle is used if nil
 @param height The desired height of the image, the width will be determined automatically
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle height:(CGFloat)height;
/**
 Calls KLO_imageWithPDFNamed:bundle:height:page:options:, passing *PDFName*, *bundle*, *height*, *page*, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param bundle The bundle to search for the PDF, NSBundle.mainBundle is used if nil
 @param height The desired height of the image, the width will be determined automatically
 @param page The page of the PDF to render
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle height:(CGFloat)height page:(NSUInteger)page;
/**
 Calls KLO_imageWithPDFAtURL:height:page:options:, passing the URL to a PDF named *PDFName* in *bundle*, *height*, *page*, and *options* respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param bundle The bundle to search for the PDF, NSBundle.mainBundle is used if nil
 @param height The desired height of the image, the width will be determined automatically
 @param page The page of the PDF to render
 @param options The PDF options to use
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle height:(CGFloat)height page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark Name, Bundle, Size
/**
 Calls KLO_imageWithPDFNamed:bundle:size:page:options:, passing *PDFName*, *bundle*, *size*, 0, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param bundle The bundle to search for the PDF, NSBundle.mainBundle is used if nil
 @param size The desired size of the image
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle size:(CGSize)size;
/**
 Calls KLO_imageWithPDFNamed:bundle:size:page:options:, passing *PDFName*, *bundle*, *size*, *page*, and [self KLO_defaultPDFOptions] respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param bundle The bundle to search for the PDF, NSBundle.mainBundle is used if nil
 @param size The desired size of the image
 @param page The page of the PDF to render
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle size:(CGSize)size page:(NSUInteger)page;
/**
 Calls KLO_imageWithPDFAtURL:size:page:options:, passing the URL to a PDF named *PDFName* in *bundle*, *size*, *page*, and *options* respectively.
 
 @param PDFName The name of the PDF, with or without the @"pdf" extension
 @param bundle The bundle to search for the PDF, NSBundle.mainBundle is used if nil
 @param size The desired size of the image
 @param page The page of the PDF to render
 @param options The PDF options to use
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFNamed:(NSString *)PDFName bundle:(nullable NSBundle *)bundle size:(CGSize)size page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark URL, Width
/**
 Calls KLO_imageWithPDFAtURL:width:page:options:, passing *URL*, *width*, 0, and [self KLO_defaultPDFOptions] respectively.
 
 @param URL The URL of the PDF
 @param width The desired width of the image, the height will be determined automatically
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFAtURL:(NSURL *)URL width:(CGFloat)width;
/**
 Calls KLO_imageWithPDFAtURL:width:page:options:, passing *URL*, *width*, *page*, and [self KLO_defaultPDFOptions] respectively.
 
 @param URL The URL of the PDF
 @param width The desired width of the image, the height will be determined automatically
 @param page The page of the PDF to render
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFAtURL:(NSURL *)URL width:(CGFloat)width page:(NSUInteger)page;
/**
 Calls KLO_imageWithPDFAtURL:size:page:options:, passing *URL*, a size where width is *width* and height is determined automatically, *page*, and *options* respectively.
 
 @param URL The URL of the PDF
 @param width The desired width of the image, the height will be determined automatically
 @param page The page of the PDF to render
 @param options The PDF options to use
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFAtURL:(NSURL *)URL width:(CGFloat)width page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark URL, Height
/**
 Calls KLO_imageWithPDFAtURL:height:page:options:, passing *URL*, *height*, 0, and [self KLO_defaultPDFOptions] respectively.
 
 @param URL The URL of the PDF
 @param height The desired height of the image, the width will be determined automatically
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFAtURL:(NSURL *)URL height:(CGFloat)height;
/**
 Calls KLO_imageWithPDFAtURL:height:page:options:, passing *URL*, *height*, *page*, and [self KLO_defaultPDFOptions] respectively.
 
 @param URL The URL of the PDF
 @param height The desired height of the image, the width will be determined automatically
 @param page The page of the PDF to render
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFAtURL:(NSURL *)URL height:(CGFloat)height page:(NSUInteger)page;
/**
 Calls KLO_imageWithPDFAtURL:size:page:options:, passing *URL*, a size where height is *height* and width is determined automatically, *page*, and *options* respectively.
 
 @param URL The URL of the PDF
 @param height The desired height of the image, the width will be determined automatically
 @param page The page of the PDF to render
 @param options The PDF options to use
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFAtURL:(NSURL *)URL height:(CGFloat)height page:(NSUInteger)page options:(KLOPDFOptions)options;

#pragma mark URL, Size
/**
 Calls KLO_imageWithPDFAtURL:size:page:options:, passing *URL*, *size*, 0, and [self KLO_defaultPDFOptions] respectively.
 
 @param URL The URL of the PDF
 @param size The desired size of the image
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(CGSize)size;
/**
 Calls KLO_imageWithPDFAtURL:size:page:options:, passing *URL*, *size*, *page*, and [self KLO_defaultPDFOptions] respectively.
 
 @param URL The URL of the PDF
 @param size The desired size of the image
 @param page The page of the PDF to render
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(CGSize)size page:(NSUInteger)page;
/**
 Returns an image by drawing the PDF *page* at *URL* at the provided *size* using *options*.
 
 @param URL The URL of the PDF
 @param size The desired size of the image
 @param page The page of the PDF to render
 @param options The PDF options to use
 @return The image or nil
 */
+ (nullable UIImage *)KLO_imageWithPDFAtURL:(NSURL *)URL size:(CGSize)size page:(NSUInteger)page options:(KLOPDFOptions)options;

@end

NS_ASSUME_NONNULL_END
