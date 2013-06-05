//
//  DTFirstViewController.m
//  DTMenuController
//
//  Created by Darktt on 13/5/30.
//  Copyright (c) 2013 Darktt Personal Company. All rights reserved.
//

#import "DTFirstViewController.h"

@interface DTFirstViewController ()

@end

@implementation DTFirstViewController

- (id)init
{
    self = [super init];
    if (self == nil) return nil;
    
    [self setTitle:@"First"];
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectZero];
    [labelView setText:@"TEST"];
    [labelView setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [labelView setTextColor:[UIColor colorWithWhite:105/255.0f alpha:1]];
    [labelView setBackgroundColor:[UIColor clearColor]];
    [labelView setShadowColor:[UIColor whiteColor]];
    [labelView setShadowOffset:CGSizeMake(0, 1)];
    [labelView sizeToFit];
    
//    [self.navigationItem setTitleView:labelView];
    
    [labelView release];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
