// DTBookMenuShadowView.m
// 
// Copyright (c) 2013 Darktt
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//   http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "DTBookMenuShadowView.h"

@implementation DTBookMenuShadowView

+ (DTInstancetype)menuShadowWithFrame:(CGRect)frame
{
    DTBookMenuShadowView *menuShadow = [[[DTBookMenuShadowView alloc] initWithFrame:frame] autorelease];
    
    return menuShadow;
}

- (DTInstancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self setBackgroundColor:[UIColor blackColor]];
    [self setAlpha:0.5f];
    
    return self;
}

#pragma mark - Override Property Methods

- (void)setHidden:(BOOL)hidden
{
    CGFloat alpha = hidden ? 0 : 0.5f;
    
    void (^hidenAnimation) (void) = ^(){
        if (hidden) {
            [self setAlpha:alpha];
        } else {
            [super setHidden:hidden];
            [self setAlpha:alpha];
        }
    };
    
    void (^animationCompletion) (BOOL finshed) = ^(BOOL finshed){
        if (hidden) {
            [super setHidden:hidden];
        }
    };
    
    [UIView animateWithDuration:0.2f animations:hidenAnimation completion:animationCompletion];
}

- (BOOL)isHidden
{
    return [super isHidden];
}

@end
