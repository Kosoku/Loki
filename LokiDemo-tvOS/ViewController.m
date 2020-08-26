//
//  ViewController.m
//  LokiDemo-tvOS
//
//  Created by William Towe on 3/10/17.
//  Copyright © 2020 Kosoku Interactive, LLC. All rights reserved.
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

@interface ViewController ()
@property (weak,nonatomic) IBOutlet UIImageView *blurImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        UIImage *image = [[UIImage imageNamed:@"blur_image"] KLO_imageByBlurringWithRadius:75.0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.blurImageView setImage:[[image KLO_imageByResizingToSize:self.blurImageView.frame.size] KLO_imageByTintingWithColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5]]];
        });
    });
}

@end
