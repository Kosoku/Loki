//
//  KLODefines.h
//  Loki
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
