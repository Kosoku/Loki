//
//  Loki.h
//  Loki
//
//  Created by William Towe on 3/9/17.
//  Copyright (c) 2020 Kosoku Interactive, LLC. All rights reserved.
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

#import <TargetConditionals.h>

#if (TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

//! Project version number for Loki.
FOUNDATION_EXPORT double LokiVersionNumber;

//! Project version string for Loki.
FOUNDATION_EXPORT const unsigned char LokiVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Loki/PublicHeader.h>

#import <Loki/KLODefines.h>

#if (TARGET_OS_IPHONE)
#import <Loki/UIImage+KLOExtensions.h>
#import <Loki/UIImage+KLOPDFExtensions.h>
#else
#import <Loki/NSImage+KLOExtensions.h>
#import <Loki/NSImage+KLOPDFExtensions.h>
#endif
