//
//  CDVideo.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/23.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDVideo.h"
#import <AVFoundation/AVFoundation.h>

@implementation CDVideo
{
    AVPlayer *_player;
    AVPlayerLayer *_playerLayer;
    AVPlayerItem *_playerItem;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPlayer];
    }
    return self;
}

- (void)setupPlayer {
    _player = [[AVPlayer alloc] init];
    _player.muted = YES;
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.bounds = self.bounds;
    _playerLayer.position = CGPointMake(self.width * .5, self.height * .5);
    [self.layer addSublayer:_playerLayer];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loopStart) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)setVideoUrl:(NSString *)urlStr {
    if (!urlStr.length) {
        return;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    _playerItem = [AVPlayerItem playerItemWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
}

- (void)play {
    [_player play];
}

- (void)loopStart {
    [_player seekToTime:kCMTimeZero];
}

+ (CDVideo *)startVideoLoopWithUrl:(NSString *)urlStr frame:(CGRect)frame {
    CDVideo *video = [[CDVideo alloc] initWithFrame:frame];
    [video setVideoUrl:urlStr];
    [video play];
    return video;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
