// DTBookMenuView.m
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

#import "DTBookMenuView.h"

#define kTableViewTag 1

#define kAnimationDuration 0.3f

typedef void (^DTMenuAnimationCompletion) (BOOL finished);

@interface DTBookMenuView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titles;
    BOOL _menuHidden;
}

@end

@implementation DTBookMenuView

+ (DTInstancetype)menuViewWithTitles:(NSArray *)titles
{
    DTBookMenuView *menuView = [[[DTBookMenuView alloc] initWithTitles:titles] autorelease];
    
    return menuView;
}

- (id)initWithTitles:(NSArray *)titles
{
    UIScreen *screen = [UIScreen mainScreen];
    CGSize winSize = screen.bounds.size;
    
    self = [super initWithFrame:CGRectMake(0, 0, winSize.width - 120, winSize.height)];
    if (self == nil) return nil;
    
    [self setClipsToBounds:NO];
    
    _titles = [[NSArray alloc] initWithArray:titles];
    _menuHidden = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setTag:kTableViewTag];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    [self addSubview:tableView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToCloseMenu:)];
    [panGesture setMaximumNumberOfTouches:1];
    
    [self addGestureRecognizer:panGesture];
    [panGesture release];
    
    return self;
}

- (void)dealloc
{
    [_titles release];
    
    [super dealloc];
}

#pragma mark - UIPanGestureRecognizer Method

- (IBAction)panToCloseMenu:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.frame.origin.x <= -self.frame.size.width / 2) {
            [self setMenuHidden:YES animation:YES];
        } else {
            [self setMenuHidden:NO animation:YES];
        }
    }
    
    CGPoint point = [sender translationInView:self];
    
    CGRect selfFrame = self.frame;
    selfFrame.origin.x += point.x;
    
    if (selfFrame.origin.x <= -self.frame.size.width) {
        selfFrame.origin.x = - self.frame.size.width;
        _menuHidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:DTBookMenuViewClosed object:nil];
    } else if (selfFrame.origin.x >= 0) {
        selfFrame.origin.x = 0;
        _menuHidden = NO;
    }
    
    [self setFrame:selfFrame];
    [sender setTranslation:CGPointZero inView:self];
}

#pragma mark - Override Property Methods

- (void)setMenuHidden:(BOOL)menuHidden
{
    [self setMenuHidden:menuHidden animation:NO];
}

- (void)setMenuHidden:(BOOL)menuHidden animation:(BOOL)animation
{
    _menuHidden = menuHidden;
    
    NSTimeInterval timeInterval = animation ? kAnimationDuration : 0 ;
    CGRect selfFrame = self.frame;
    
    CGRect newFrame = CGRectZero;
    newFrame.size = selfFrame.size;
    
    CGFloat newFrameX = 0;
    
    if (_menuHidden) {
        newFrameX = -selfFrame.size.width;
    } else {
        newFrameX = 0;
    }
    
    newFrame.origin = CGPointMake(newFrameX, selfFrame.origin.y);
    
    void (^animationsBlock) (void) = ^(){
        [self setFrame:newFrame];
    };
    
    DTMenuAnimationCompletion completion = ^(BOOL finshed){
        if (_menuHidden) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DTBookMenuViewClosed object:nil];
        }
    };
    
    [UIView animateWithDuration:timeInterval delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:animationsBlock completion:completion];
}

- (BOOL)isMenuHidden
{
    return _menuHidden;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.textLabel setText:_titles[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_delegate setViewControllAtIndex:indexPath.row];
}

@end
