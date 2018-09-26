## Loki

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](http://img.shields.io/cocoapods/v/Loki.svg)](http://cocoapods.org/?q=Loki)
[![Platform](http://img.shields.io/cocoapods/p/Loki.svg)]()
[![License](http://img.shields.io/cocoapods/l/Loki.svg)](https://github.com/Kosoku/Loki/blob/master/license.txt)

*Loki* is an iOS/macOS/tvOS/watchOS framework for manipulating `UIImage`/`NSImage`. Methods to resize, tint, highlight, blur, and adjust contrast, brightness or saturation are provided on iOS/macOS/tvOS. A subset of the methods are available on watchOS because of their reliance on the `Accelerate` framework.

Additional methods are provided to render images from PDF source documents, given a specific width, height, or size, provided the PDF name, bundle or URL.

### Installation

You can install *Loki* using [cocoapods](https://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or as a framework.

### Dependencies

Apple:

- `Accelerate`, `iOS`, `macOS`, and `tvOS`

### Examples

Highlight an image:

```objc
// assume image exists
UIImage *image = ...;

// the image will have a partially transparent orange tint applied over it
image = [image KLO_imageByHighlightingWithColor:[UIColor.orangeColor colorWithAlphaComponent:0.25]];
```

Tint an image:

```objc
// assume image exists
UIImage *image = ...;

// the image will have its opaque pixels colored orange
image = [image KLO_imageByTintingWithColor:UIColor.orangeColor];
```

Resize an image:

```objc
// assume image exists
UIImage *image = ...;

// the image will be resized to the provided size and its aspect ratio will be maintained
image = [image KLO_imageByResizingToSize:CGSizeMake(25, 25) maintainAspectRatio:YES];
```

Blur an image:

```objc
// assume image exists
UIImage *image = ...;

// the image will be blurred using a box blur with the provided radius
image = [image KLO_imageByBlurringWithRadius:25.0];
```

Generate PDF images:

```objc
// image with the provided name in the main bundle scaled to the provided width and automatically determined height
UIImage *image = [UIImage KLO_imageWithPDFNamed:@"image" width:100];
```

```objc
// image with the provided name in the main bundle scaled to the provided height and automatically determined width
UIImage *image = [UIImage KLO_imageWithPDFNamed:@"image" height:100];
```

```objc
// image with the provided name in the main bundle scaled to the provided size
UIImage *image = [UIImage KLO_imageWithPDFNamed:@"image" size:CGSizeMake(25, 25)];
```

There are numerous other method PDF related methods. See *UIImage+KLOPDFExtensions.h* and *NSImage+KLOPDFExtensions.h* for full method listing.

### Demo

The various demo targets in the workspace provide further examples of the image and PDF related methods in action.