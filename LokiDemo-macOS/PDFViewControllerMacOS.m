//
//  PDFViewControllerMacOS.m
//  LokiDemo-macOS
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

#import "PDFViewControllerMacOS.h"

#import <Loki/Loki.h>

@interface PDFViewControllerMacOS () <NSTextFieldDelegate>
@property (weak,nonatomic) IBOutlet NSTextField *widthTextField;
@property (weak,nonatomic) IBOutlet NSTextField *heightTextField;
@property (weak,nonatomic) IBOutlet NSImageView *imageView;
@end

@implementation PDFViewControllerMacOS

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.widthTextField.delegate = self;
    self.heightTextField.delegate = self;
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertNewline:)) {
        NSInteger width = self.widthTextField.integerValue;
        NSInteger height = self.heightTextField.integerValue;
        
        if (width > 0 &&
            height > 0) {
            
            self.imageView.image = [NSImage KLO_imageWithPDFNamed:@"kosoku-logo" size:CGSizeMake(width, height)];
        }
        else if (width > 0) {
            self.imageView.image = [NSImage KLO_imageWithPDFNamed:@"kosoku-logo" width:width];
        }
        else if (height > 0) {
            self.imageView.image = [NSImage KLO_imageWithPDFNamed:@"kosoku-logo" height:height];
        }
        
        return NO;
    }
    return YES;
}

@end
