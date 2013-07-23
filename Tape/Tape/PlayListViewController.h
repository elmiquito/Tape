//
//  PlayListViewController.h
//  Tape
//
//  Created by Jamie Bullock on 23/07/2013.
//  Copyright (c) 2013 Jamie Bullock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayListViewControllerDelegate;

@interface PlayListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<PlayListViewControllerDelegate> delegate;

@end

@protocol PlayListViewControllerDelegate <NSObject>

- (void)loadSongWithURL: (NSURL *)url;

@end