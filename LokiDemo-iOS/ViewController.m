//
//  ViewController.m
//  LokiDemo-iOS
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

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak,nonatomic) IBOutlet UIButton *button;
@property (weak,nonatomic) IBOutlet UIImageView *imageView1;
@property (weak,nonatomic) IBOutlet UIImageView *imageView2;
@property (weak,nonatomic) IBOutlet UIImageView *imageView3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.button addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        [self.imageView1 setImage:[image KLO_imageByResizingToSize:self.imageView1.frame.size]];
        [self.imageView2 setImage:[image KLO_imageByResizingToSize:self.imageView2.frame.size]];
        [self.imageView3 setImage:[image KLO_imageByResizingToSize:self.imageView3.frame.size]];
    }];
}

- (IBAction)_buttonAction:(id)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [controller setDelegate:self];
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
