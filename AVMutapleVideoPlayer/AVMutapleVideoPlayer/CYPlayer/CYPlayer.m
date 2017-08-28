//
//  CYPlayer.m
//  AVMutapleVideoPlayer
//
//  Created by yu cao on 2017/8/25.
//  Copyright © 2017年 wolf. All rights reserved.
//

#import "CYPlayer.h"
#import "NSString+TimeFunctions.h"
#import "RACEXTScope.h"
#import "CYVideoQueueModel.h"
#import "AVPlayerItem+List.h"

CGFloat getVideoDuration(NSURL*URL) {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];

    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float       second   = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale;

    return second;
}


@implementation CYPlayer

@end


@interface CYPlayerView ()

@property (nonatomic,strong) CYPlayer          *player;

@property (nonatomic,assign) NSTimeInterval     durationTime;
@property (nonatomic,assign) NSTimeInterval     currentTime;
@property (nonatomic,strong) NSDictionary      *header;
@property (nonatomic,strong) CYVideoQueueModel *queueModel;
@property (nonatomic,strong)  id                timeObser;
@property (nonatomic,strong)  AVPlayerLayer    *playerLayer;

@end

@implementation CYPlayerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setupWithURLs:(NSArray*)stirngFormatURLs andHeader:(NSDictionary*)header {
    self.header = header;
    CYVideoQueueModel *queueModel = [[CYVideoQueueModel alloc] initWithUrls:stirngFormatURLs header:header];
    [self setupPlayerWithModel:queueModel];
    self.queueModel = queueModel;
    
    if ([self.delegate respondsToSelector:@selector(receiveDuration:)]) {
        [self.delegate receiveDuration:queueModel.duration];
    }
}

- (void)setupPlayerWithModel:(CYVideoQueueModel*)queueModel {
    AVPlayerItem * headerItem  = [queueModel headerItem];
    CYPlayer *player = [[CYPlayer alloc] initWithPlayerItem:headerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [self.layer addSublayer:_playerLayer];
    self.player = player;
    [player play];
    [self setNeedsLayout];

    //Add Obbserver
    [self addPlayEndObserver:headerItem];
    CMTime interval = CMTimeMakeWithSeconds(1, 1 * NSEC_PER_SEC);
    __weak typeof(self)weakSelf = self;
    self.timeObser              = \
        [player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float seconds = CMTimeGetSeconds(weakSelf.player.currentItem.currentTime);
        float duration = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        weakSelf.currentTime = seconds;
        weakSelf.durationTime = duration;

        CMTime endTime = CMTimeConvertScale(weakSelf.player.currentItem.asset.duration,
            weakSelf.player.currentTime.timescale,
            kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            NSLog(@"%f", CMTimeGetSeconds(weakSelf.player.currentItem.currentTime));
            if ([self.delegate respondsToSelector:@selector(progressTimeDidChange:)]) {
                [self.delegate progressTimeDidChange:seconds+self.queueModel.baseProgressTime];
            }
        }
    }];

}

#if (PlayerScheme==PlayerScheme1)
- (void)rebuildPlayerWithModel:(NSArray<AVPlayerItem*>*)playItemQueue {
    if (self.player && self.timeObser) {
        [self.player pause];
        [self.player replaceCurrentItemWithPlayerItem:nil];
        [self.player removeAllItems];
        [self.player removeTimeObserver:self.timeObser];

        [self.playerLayer removeFromSuperlayer];
        self.player      = nil;
        self.playerLayer = nil;
    }
    CYPlayer *player = [[CYPlayer alloc] initWithItems:playItemQueue];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [self.layer addSublayer:_playerLayer];
    self.player = player;
    [player play];

    CMTime interval = CMTimeMakeWithSeconds(1, 1 * NSEC_PER_SEC);
    __weak typeof(self)weakSelf = self;
    self.timeObser              = \
        [player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float seconds = CMTimeGetSeconds(weakSelf.player.currentItem.currentTime);
        float duration = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        weakSelf.currentTime = seconds;
        weakSelf.durationTime = duration;

        CMTime endTime = CMTimeConvertScale(weakSelf.player.currentItem.asset.duration, weakSelf.player.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            NSLog(@"%f", CMTimeGetSeconds(weakSelf.player.currentItem.currentTime));
            if ([self.delegate respondsToSelector:@selector(progressTimeDidChange:)]) {
                [self.delegate progressTimeDidChange:seconds+self.queueModel.baseProgressTime];
            }
        }
    }];
    self.player = player;
}
#elif (PlayerScheme==PlayerScheme2)
- (void)replacePlayItem:(AVPlayerItem *)playItem {
    if (playItem != self.player.currentItem) {
        [self removePlayEndObserver:[self.player currentItem]];
        [self.player replaceCurrentItemWithPlayerItem:playItem];
        [self addPlayEndObserver:playItem];
    }
}
#endif

- (void)seekTo:(NSTimeInterval)time {
#if (PlayerScheme==PlayerScheme1)
    @weakify(self);
    [self.queueModel seekTo:time completation:^(NSArray < AVPlayerItem* > *playItemQueue, NSTimeInterval sectionInterval) {
        @strongify(self);
        if ([playItemQueue count] && [playItemQueue objectAtIndex:0] != self.player.currentItem) {
            [self rebuildPlayerWithModel:playItemQueue];
            [self.player seekToTime:CMTimeMakeWithSeconds(sectionInterval, 1)];
        } else {
            [self.player seekToTime:CMTimeMakeWithSeconds(sectionInterval, 1)];
        }
    }];
#elif (PlayerScheme==PlayerScheme2)
    @weakify(self);
    [self.queueModel seekTo:time completation:^(AVPlayerItem*playItem, NSTimeInterval sectionInterval) {
        @strongify(self);
        [self replacePlayItem:playItem];
        [self.player seekToTime:CMTimeMakeWithSeconds(sectionInterval, 1)];
    }];
#else
#endif
}

- (void)addPlayEndObserver:(AVPlayerItem*)playeItem {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playeItem];
}

- (void)removePlayEndObserver:(AVPlayerItem*)playeItem {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:playeItem];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    //[self removePlayEndObserver:[self.player currentItem]];
    AVPlayerItem * nextPlayItem = [[self.player currentItem] next];
    if (nextPlayItem) {
        [self replacePlayItem:nextPlayItem];
        [self.queueModel updateBasePlayProgressTime:nextPlayItem];
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }else {
        if ([self.delegate respondsToSelector:@selector(didFinishedPlay)]) {
            [self.delegate didFinishedPlay];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.playerLayer setFrame:self.bounds];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
