//
//  PDFViewControllerMacOS.m
//  LokiDemo-macOS
//
//  Created by William Towe on 9/5/18.
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
