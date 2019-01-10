//
//  ViewController.m
//  LokiDemo-macOS
//
//  Created by William Towe on 3/9/17.
//  Copyright © 2019 Kosoku Interactive, LLC. All rights reserved.
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
    
    [pictureTaker setValue:@NO forKey:IKPictureTakerAllowsEditingKey];
    
    [pictureTaker beginPictureTakerSheetForWindow:self.view.window withDelegate:self didEndSelector:@selector(_pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)_pictureTakerDidEnd:(IKPictureTaker *)pictureTaker returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    __block NSImage *image = pictureTaker.outputImage;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        image = [image KLO_imageByBlurringWithRadius:20.0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:[[image KLO_imageByResizingToSize:self.imageView.frame.size] KLO_imageByTintingWithColor:[[NSColor orangeColor] colorWithAlphaComponent:0.25]]];
        });
    });
}

@end
