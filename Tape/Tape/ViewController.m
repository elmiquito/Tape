//
//  ViewController.m
//  Tape
//
//  Created by Jamie Bullock on 13/05/2013.
//  Copyright (c) 2013 Jamie Bullock. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (strong, nonatomic) NSTimer *progressTimer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (assign, nonatomic) BOOL isPaused;
@property (assign, nonatomic) BOOL isStopped;

@end

@implementation ViewController

+ (NSString *)stringWithMinutes:(NSInteger)minutes andSeconds:(NSInteger)seconds
{
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

+ (NSString *)stringWithTimeInterval:(NSTimeInterval)interval
{
    NSInteger minutes = (int)roundf(interval / 60.f);
    NSInteger seconds = (int)roundf(interval) % 60;

    return [ViewController stringWithMinutes:minutes andSeconds:seconds];
}

- (void)setPlayButtonTitleWithString:(NSString *)titleString
{
    [self.playButton setTitle:titleString forState:UIControlStateNormal];
}

- (void)zeroPlayState
{
    if (self.audioPlayer == nil)
    {
        NSLog(@"error: audioPlayer is nil");
        assert(0);
    }
    self.audioPlayer.currentTime = 0.f;
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
    [self.audioPlayer play];
    [self startTimer];
    self.isStopped = self.isPaused = NO;
}

- (void)pause
{
    [self.audioPlayer stop];
    [self stopTimer];
    self.isPaused = YES;
    self.isStopped = NO;
}

- (void)stop
{
    [self pause];
    [self zeroPlayState];
    self.isStopped = YES;
    self.isPaused = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error = Nil;
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp3"];

    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    self.progressSlider.maximumValue = self.audioPlayer.duration;
    self.durationLabel.text = [ViewController stringWithTimeInterval:self.audioPlayer.duration];
    [self stop];
}

- (void)progressTick:(NSTimer *)timer
{
    NSTimeInterval currentTime = self.audioPlayer.currentTime;
    self.progressSlider.value = currentTime;
    self.progressLabel.text = [ViewController stringWithTimeInterval:currentTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonTouchUpInside:(id)sender
{
    if (self.isPaused || self.isStopped)
    {
        [self play];
        [self setPlayButtonTitleWithString:@"Pause"];

    }
    else
    {
        [self pause];
        [self setPlayButtonTitleWithString:@"Play"];
    }
}

- (IBAction)stopButtonTouchUpInside:(id)sender
{
    [self stop];
    [self setPlayButtonTitleWithString:@"Play"];
}


- (IBAction)playPositionSliderChanged:(id)sender
{
    self.audioPlayer.currentTime = self.progressSlider.value;
    self.progressLabel.text = [ViewController stringWithTimeInterval:self.audioPlayer.currentTime];
}



@end
