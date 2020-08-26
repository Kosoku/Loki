//
//  InterfaceController.m
//  LokiDemo-watchOS Extension
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

#import "InterfaceController.h"

#import <Loki/Loki.h>

@interface InterfaceController()
@property (weak,nonatomic) IBOutlet WKInterfaceImage *interfaceImage;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self.interfaceImage setImage:[[[UIImage imageNamed:@"demo_image"] KLO_imageByResizingToSize:CGSizeMake(300, 300)] KLO_imageByTintingWithColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5]]];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



