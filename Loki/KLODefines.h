//
//  KLODefines.h
//  Loki
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

#ifndef __KLO_DEFINES__
#define __KLO_DEFINES__

#import <TargetConditionals.h>

#if (TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#if (TARGET_OS_WATCH)
#import <WatchKit/WatchKit.h>
#endif

#define KLOSize CGSize
#define KLOImage UIImage
#define KLOColor UIColor

#define KLOSizeMake(w,h) CGSizeMake((w),(h))

#else
#import <AppKit/AppKit.h>

#define KLOSize NSSize
#define KLOImage NSImage
#define KLOColor NSColor

#define KLOSizeMake(w,h) NSMakeSize((w),(h))

#endif

/**
 Mask describing possible options for PDF image creation.
 */
typedef NS_OPTIONS(NSUInteger, KLOPDFOptions) {
    /**
     No options.
     */
    KLOPDFOptionsNone = 0,
    /**
     Preserve the aspect ratio of the PDF when drawing.
     */
    KLOPDFOptionsPreserveAspectRatio = 1 << 0,
    /**
     Cache the drawn PDF image in memory, subsequent requests will return the cached image.
     */
    KLOPDFOptionsCacheMemory = 1 << 1,
    /**
     The default options. These are used unless custom options are passed or set globally using the KLO_defaultPDFOptions method.
     */
    KLOPDFOptionsDefault = KLOPDFOptionsPreserveAspectRatio|KLOPDFOptionsCacheMemory,
    /**
     Convenience for all options.
     */
    KLOPDFOptionsAll = KLOPDFOptionsPreserveAspectRatio|KLOPDFOptionsCacheMemory
};

#endif
