//
//  PlayListViewController.m
//  Tape
//
//  Created by Jamie Bullock on 23/07/2013.
//  Copyright (c) 2013 Jamie Bullock. All rights reserved.
//

#import "PlayListViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#define kSongItemCellIdentifier @"songItemTableViewCell"

@interface PlayListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *songsTableView;
@property (strong, nonatomic) NSArray *songArray;

@end

@implementation PlayListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
#if TARGET_IPHONE_SIMULATOR
    self.songArray = @[@"one", @"two", @"three"];
#else
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:@"empty" withExtension:@"wav"];
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithBool:NO] forProperty:MPMediaItemPropertyIsCloudItem]];
    
    songsQuery.groupingType = MPMediaGroupingPlaylist;
    self.songArray = songsQuery.items;
    
    //    [self.songsTableView reloadData];
    
    [self.delegate loadSongWithURL:audioURL];
#endif
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSongItemCellIdentifier];
    
#if TARGET_IPHONE_SIMULATOR
    cell.textLabel.text = self.songArray[indexPath.row];
#else
    MPMediaItem *mediaItem = self.songArray[indexPath.row];
    cell.textLabel.text = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
#endif
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#if TARGET_IPHONE_SIMULATOR
#else
    MPMediaItem *mediaItem = self.songArray[indexPath.row];
    
    NSURL *url = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
    
    [self.delegate loadSongWithURL:url];
#endif
}

@end
