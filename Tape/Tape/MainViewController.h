//
//  MainViewController.h
//  Tape
//
//  Created by Jamie Bullock on 23/07/2013.
//  Copyright (c) 2013 Jamie Bullock. All rights reserved.
//


#import "PlayListViewController.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface MainViewController : UIViewController <AVAudioPlayerDelegate, PlayListViewControllerDelegate>

@end
