//
//  ViewController.m
//  LokiDemo-macOS
//
//  Created by William Towe on 3/9/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ViewController.h"

#import <Loki/Loki.h>

#import <Quartz/Quartz.h>

@interface ViewController ()
@property (weak,nonatomic) IBOutlet NSButton *photoButton;
@property (weak,nonatomic) IBOutlet NSImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.photoButton setTarget:self];
    [self.photoButton setAction:@selector(_buttonAction:)];
}

- (IBAction)_buttonAction:(id)sender {
    IKPictureTaker *pictureTaker = [IKPictureTaker pictureTaker];
    
    [pictureTaker setValue:@NO forKey:IKPictureTakerAllowsFileChoosingKey];
    [pictureTaker setValue:@NO forKey:IKPictureTakerAllowsEditingKey];
    
    [pictureTaker beginPictureTakerSheetForWindow:self.view.window withDelegate:self didEndSelector:@selector(_pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)_pictureTakerDidEnd:(IKPictureTaker *)pictureTaker returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    __block NSImage *image = pictureTaker.outputImage;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        image = [image KLO_imageByBlurringWithRadius:10.0];
        image = [image KLO_imageByAdjustingBrightnessBy:-0.5];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:[image KLO_imageByResizingToSize:self.imageView.frame.size]];
        });
    });
}

@end
