//
//  PDFViewController.m
//  LokiDemo-iOS
//
//  Created by William Towe on 9/5/18.
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

#import "PDFViewController.h"

#import <Loki/Loki.h>

@interface PDFViewController () <UITextFieldDelegate>
@property (weak,nonatomic) IBOutlet UITextField *widthTextField;
@property (weak,nonatomic) IBOutlet UITextField *heightTextField;
@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PDFViewController

- (NSString *)title {
    return @"pdfs";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.widthTextField.delegate = self;
    self.heightTextField.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.widthTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger width = self.widthTextField.text.integerValue;
    NSInteger height = self.heightTextField.text.integerValue;
    
    if (width > 0 &&
        height > 0) {
        
        self.imageView.image = [UIImage KLO_imageWithPDFNamed:@"kosoku-logo" size:CGSizeMake(width, height)];
    }
    else if (width > 0) {
        self.imageView.image = [UIImage KLO_imageWithPDFNamed:@"kosoku-logo" width:width];
    }
    else if (height > 0) {
        self.imageView.image = [UIImage KLO_imageWithPDFNamed:@"kosoku-logo" height:height];
    }
    
    return YES;
}

@end
