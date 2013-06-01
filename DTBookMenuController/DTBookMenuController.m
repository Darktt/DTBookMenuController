// DTBookMenuController.m
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

#import "DTBookMenuController.h"

// Config
#import "DTBookMenuConfig.h"

// Views
#import "DTBookMenuShadowView.h"
#import "DTBookMenuView.h"

@interface DTBookMenuController ()<DTBookMenuViewDelegate>
{
    NSArray *_viewControllers;
    
    // Views
    DTBookMenuShadowView *_menuViewShadow;
    DTBookMenuView *_menuView;
}

@end

@implementation DTBookMenuController

+ (id)menuViewWithViewControllers:(NSArray *)viewControllers
{
    DTBookMenuController *menuView = [[[DTBookMenuController alloc] initWithViewControllers:viewControllers] autorelease];
    
    return menuView;
}

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self == nil) return nil;
    _viewControllers = [[NSArray alloc] initWithArray:viewControllers];
    
    NSMutableArray *titles = [NSMutableArray array];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop){
        
        if (idx == 0) {
            [viewController.view setFrame:self.view.bounds];
            
            UINavigationController *nav = [self setNavigationWithRootViewController:viewController];
            [self setBarButtonItemWithViewController:viewController];
            
            [self.view addSubview:nav.view];
            [self addChildViewController:nav];
        }
        
        [titles addObject:viewController.title];
    }];
    
    _menuViewShadow = [DTBookMenuShadowView menuShadowWithFrame:self.view.bounds];
    [_menuViewShadow setHidden:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [_menuViewShadow addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    _menuView = [DTBookMenuView menuViewWithTitles:titles];
    [_menuView setDelegate:self];
    [_menuView setMenuHidden:YES];
    
    [self.view addSubview:_menuViewShadow];
    [self.view addSubview:_menuView];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMenuClosed:) name:DTBookMenuViewClosed object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)dealloc
{
    [_viewControllers release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override Property Methods

- (NSArray *)viewControllers
{
    return _viewControllers;
}

- (DTBookMenuView *)bookMenuView
{
    return _menuView;
}

#pragma mark - UINavigationController Setting

- (UINavigationController *)setNavigationWithRootViewController:(UIViewController *)viewController
{
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    [nav.navigationBar setTintColor:kNavigationBackgroundColor];
    [nav.view setFrame:self.view.bounds];
    
    return nav;
}

#pragma mark - UIBarButtonItem Setting

- (void)setBarButtonItemWithViewController:(UIViewController *)viewController
{
    UIButton *showMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showMenuBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [showMenuBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [showMenuBtn setBackgroundImage:kMenuBtn forState:UIControlStateNormal];
    [showMenuBtn setBackgroundImage:kMenuBtnPress forState:UIControlStateHighlighted];
    
    UIBarButtonItem *showMenu = [[UIBarButtonItem alloc] initWithCustomView:showMenuBtn];
    
    [viewController.navigationItem setLeftBarButtonItem:showMenu];
    [showMenu release];
}

#pragma mark - Menu Control Method

- (IBAction)showMenu:(id)Sender
{
    [_menuViewShadow setHidden:NO];
    [_menuView setMenuHidden:NO animation:YES];
}

- (IBAction)closeMenu:(UITapGestureRecognizer *)sender
{
    [_menuViewShadow setHidden:YES];
    [_menuView setMenuHidden:YES animation:YES];
}

#pragma mark - NSNotificationCenter Method

- (IBAction)receiveMenuClosed:(NSNotificationCenter *)sender
{
    [_menuViewShadow setHidden:YES];
}

#pragma mark - DTBookMenuView Deleagte

- (void)setViewControllAtIndex:(NSUInteger)index
{
    UIViewController *childViewController = self.childViewControllers[0];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
    
    UIViewController *viewController = _viewControllers[index];
    UINavigationController *nav = [self setNavigationWithRootViewController:viewController];
    [self setBarButtonItemWithViewController:viewController];
    
    [self.view insertSubview:nav.view atIndex:0];
    [self addChildViewController:nav];
    
    [_menuView setMenuHidden:!_menuView.menuHidden animation:YES];
}

@end
