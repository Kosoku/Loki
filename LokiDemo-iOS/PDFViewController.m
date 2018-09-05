//
//  PDFViewController.m
//  LokiDemo-iOS
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
