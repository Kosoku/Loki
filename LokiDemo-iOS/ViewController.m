//
//  ViewController.m
//  LokiDemo-iOS
//
//  Created by William Towe on 3/9/17.
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

#import "ViewController.h"

#import <Loki/Loki.h>

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak,nonatomic) IBOutlet UIButton *button;
@property (strong,nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

- (void)_updateWithImage:(UIImage *)image;
@end

@implementation ViewController

- (NSString *)title {
    return @"images";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.button addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIImageView *imageView in self.imageViews) {
        imageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            UIImage *image = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
            
            image = [image KLO_imageByBlurringWithRadius:50.0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIImageView *imageView in self.imageViews) {
                    [imageView setImage:[[image KLO_imageByResizingToSize:imageView.frame.size] KLO_imageByHighlightingWithColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5]]];
                }
            });
        });
    }];
}

- (void)_updateWithImage:(UIImage *)image; {
    for (UIImageView *imageView in self.imageViews) {
        imageView.image = [image KLO_imageByResizingToSize:imageView.frame.size];
    }
}

- (IBAction)_buttonAction:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Photos" message:@"Which one?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    void(^continueBlock)(UIImagePickerControllerSourceType) = ^(UIImagePickerControllerSourceType sourceType){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        [imagePickerController setSourceType:sourceType];
        [imagePickerController setDelegate:self];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    };
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        continueBlock(UIImagePickerControllerSourceTypePhotoLibrary);
    }]];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            continueBlock(UIImagePickerControllerSourceTypeCamera);
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
