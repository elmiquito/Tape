//
//  MainViewController.m
//  Tape
//
//  Created by Jamie Bullock on 23/07/2013.
//  Copyright (c) 2013 Jamie Bullock. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (strong, nonatomic) NSTimer *progressTimer;
@property (assign, nonatomic) BOOL isPaused;
@property (assign, nonatomic) BOOL isStopped;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation MainViewController


#pragma mark - Helper methods

+ (NSString *)stringWithMinutes:(NSInteger)minutes andSeconds:(NSInteger)seconds
{
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

+ (NSString *)stringWithTimeInterval:(NSTimeInterval)interval
{
    NSInteger minutes = (int)roundf(interval / 60.f);
    NSInteger seconds = (int)roundf(interval) % 60;
    
    return [MainViewController stringWithMinutes:minutes andSeconds:seconds];
}

#pragma mark - Transport control logic

- (void)setPlayButtonTitleWithString:(NSString *)titleString
{
    [self.playButton setTitle:titleString forState:UIControlStateNormal];
}

- (void)zeroPlayState
{
    if (self.audioPlayer != nil)
    {
        self.audioPlayer.currentTime = 0.f;
    }
    self.progressLabel.text = @"00:00";
    self.progressSlider.value = 0.f;
}

- (void)startTimer
{
    if (self.progressTimer == nil)
    {
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.f target:self selector:@selector(progressTick:) userInfo:nil repeats:YES];
    }
    else
    {
        NSLog(@"error: timer already started");
        assert(0);
    }
}

- (void)stopTimer
{
    if (self.progressTimer == nil)
    {
        NSLog(@"error: timer is nil");
    }
    else
    {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}

- (void)play
{
    if (self.audioPlayer.duration == 0)
    {
        [self stop];
        return;
    }
    [self.audioPlayer play];
    [self startTimer];
    self.isStopped = self.isPaused = NO;
    [self setPlayButtonTitleWithString:@"Pause"];
}

- (void)pause
{
    [self.audioPlayer stop];
    [self stopTimer];
    self.isPaused = YES;
    self.isStopped = NO;
    [self setPlayButtonTitleWithString:@"Play"];
}

- (void)stop
{
    [self pause];
    [self zeroPlayState];
    self.isStopped = YES;
    self.isPaused = NO;
}

- (void)progressTick:(NSTimer *)timer
{
    NSTimeInterval currentTime = self.audioPlayer.currentTime;
    self.progressSlider.value = currentTime;
    self.progressLabel.text = [MainViewController stringWithTimeInterval:currentTime];
    
    if (currentTime >= self.audioPlayer.duration)
    {
        [self stop];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(orientationChanged:)
//     name:UIDeviceOrientationDidChangeNotification
//     object:[UIDevice currentDevice]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // TODO:Do we have a table sidebar, a burger + basement, or a popover list (UIPopoverController)
}

- (void)viewDidAppear:(BOOL)animated
{
    //    [self.songsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark - Orientation Handling
//- (void) orientationChanged:(NSNotification *)note
//{
//    UIDevice * device = note.object;
//    switch(device.orientation)
//    {
//        case UIDeviceOrientationPortrait:
//            self.playButton.hidden = NO;
//            self.stopButton.hidden = NO;
//            self.durationLabel.hidden = NO;
//            //            self.progressLabel.hidden = NO;
//            self.progressSlider.hidden = NO;
//            self.songsTableView.hidden = NO;
//            break;
//            
//        case UIDeviceOrientationPortraitUpsideDown:
//            /* start special animation */
//            break;
//            
//        case UIDeviceOrientationLandscapeLeft:
//        case UIDeviceOrientationLandscapeRight:
//            self.playButton.hidden = YES;
//            self.stopButton.hidden = YES;
//            self.durationLabel.hidden = YES;
//            //            self.progressLabel.hidden = YES;
//            self.progressSlider.hidden = YES;
//            self.songsTableView.hidden = YES;
//            break;
//            
//        default:
//            break;
//    };
//}

#pragma mark - UI Handling

- (IBAction)playButtonTouchUpInside:(id)sender
{
    if (self.isPaused || self.isStopped)
    {
        [self play];
    }
    else
    {
        [self pause];
    }
}

- (IBAction)stopButtonTouchUpInside:(id)sender
{
    [self stop];
}


- (IBAction)playPositionSliderChanged:(id)sender
{
    self.audioPlayer.currentTime = self.progressSlider.value;
    self.progressLabel.text = [MainViewController stringWithTimeInterval:self.audioPlayer.currentTime];
}


#pragma mark - PlayListViewControllerDelegate methods
- (void)loadSongWithURL: (NSURL *)url
{
    NSError *error = nil;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error)
    {
        NSLog(@"Error: %@", [error description]);
        return;
    }
    
    NSTimeInterval duration = self.audioPlayer.duration;
    
    self.progressSlider.maximumValue = duration;
    self.durationLabel.text = [MainViewController stringWithTimeInterval:self.audioPlayer.duration];
    [self stop];
}





@end
