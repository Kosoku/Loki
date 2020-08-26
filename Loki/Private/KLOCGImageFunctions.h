//
//  KLOCGImageFunctions.h
//  Loki
//
//  Created by William Towe on 3/9/17.
//  Copyright © 2020 Kosoku Interactive, LLC. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT CGSize KLOCGImageThumbnailSizeFromSizeMaintainingAspectRatio(CGImageRef _Nullable imageRef, CGSize size, bool maintainAspectRatio);

FOUNDATION_EXPORT bool KLOCGImageHasAlpha(CGImageRef _Nullable imageRef);

#if (!TARGET_OS_WATCH)
FOUNDATION_EXPORT _Nullable CGImageRef KLOCGImageCreateImageByBlurringImageWithRadius(CGImageRef _Nullable imageRef, CGFloat radius);

FOUNDATION_EXPORT _Nullable CGImageRef KLOCGImageCreateImageByAdjustingBrightnessOfImageByDelta(CGImageRef _Nullable imageRef, CGFloat delta);

FOUNDATION_EXPORT _Nullable CGImageRef KLOCGImageCreateImageByAdjustingContrastOfImageByDelta(CGImageRef _Nullable imageRef, CGFloat delta);

FOUNDATION_EXPORT _Nullable CGImageRef KLOCGImageCreateImageByAdjustingSaturationOfImageByDelta(CGImageRef _Nullable imageRef, CGFloat delta);
#endif

NS_ASSUME_NONNULL_END
