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

static CGSize const kImageSize = {.width=50, .height=50};
static NSInteger const kNumberOfRows = 100;

@interface ImageTableViewCell : UITableViewCell
@property (strong,nonatomic) UIImageView *PDFImageView;
@end

@implementation ImageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    _PDFImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _PDFImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _PDFImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_PDFImageView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]->=0-|" options:0 metrics:nil views:@{@"view": _PDFImageView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": _PDFImageView}]];
    
    return self;
}
@end

@interface PDFViewController () <UITableViewDataSource>
@property (weak,nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PDFViewController

- (NSString *)title {
    return @"pdfs";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:ImageTableViewCell.class forCellReuseIdentifier:NSStringFromClass(ImageTableViewCell.class)];
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTableViewCell *retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ImageTableViewCell.class) forIndexPath:indexPath];
    
    retval.PDFImageView.image = [UIImage KLO_imageWithPDFNamed:@"image" size:kImageSize];
    
    return retval;
}

@end
