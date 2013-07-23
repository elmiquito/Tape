//
//  ContainerViewController.m
//  Tape
//
//  Created by Jamie Bullock on 13/05/2013.
//  Copyright (c) 2013 Jamie Bullock. All rights reserved.
//

#import "ContainerViewController.h"
#import "MainViewController.h"
#import "PlayListViewController.h"


@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addViewsToCube];
}

#pragma mark - Cube views
- (void)addViewsToCube
{
    MainViewController *mainViewController = (MainViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"Main"];
    UIViewController *leftViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"LeftView"];
    PlayListViewController *playListViewController = (PlayListViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"PlayList"];
    UIViewController *backViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"BackView"];
    
    [self addCubeSideForChildController:mainViewController];
    [self addCubeSideForChildController:playListViewController];
    [self addCubeSideForChildController:backViewController];
    [self addCubeSideForChildController:leftViewController];
    
    playListViewController.delegate = mainViewController;
    
}


@end
