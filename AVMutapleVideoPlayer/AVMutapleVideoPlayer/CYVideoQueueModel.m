//
//  CYVideoQueueModel.m
//  AVMutapleVideoPlayer
//
//  Created by yu cao on 2017/8/27.
//  Copyright © 2017年 wolf. All rights reserved.
//

#import "CYVideoQueueModel.h"

@interface CYVideoModel : NSObject

@property (nonatomic,assign) NSTimeInterval s_duration;
@property (nonatomic,assign) NSTimeInterval s_beginTime;
@property (nonatomic,assign) NSTimeInterval s_endTime;//endtime 和下一个节点的begintime相同,这里注意边界判断

//判断所要找的时间是否在当前item中
- (BOOL)isInTime:(NSTimeInterval)time;
+ (instancetype)createItemWithBeginTime:(NSTimeInterval)beginTime duration:(NSTimeInterval)duration;
- (NSTimeInterval)sectionSeekTime:(NSTimeInterval)time;

@end

@implementation CYVideoModel

+ (instancetype)createItemWithBeginTime:(NSTimeInterval)beginTime duration:(NSTimeInterval)duration {
    if (duration <= 0) {
        NSLog(@"%s -- duration is 0",__FUNCTION__);
        return nil;
    }
    CYVideoModel *instance = [CYVideoModel new];
    instance.s_beginTime = beginTime;
    instance.s_duration  = duration;
    instance.s_endTime   = beginTime + duration;
    return instance;
}

- (BOOL)isInTime:(NSTimeInterval)time {
    if (self.s_endTime > self.s_beginTime && self.s_duration > 0) {
        if (time >= self.s_beginTime && time < self.s_endTime) {
            return YES;
        }
    }
    return NO;
}

- (NSTimeInterval)sectionSeekTime:(NSTimeInterval)time {
    if (self.s_endTime > self.s_beginTime && self.s_duration > 0) {
        if (time >= self.s_beginTime && time < self.s_endTime) {
            return time - self.s_beginTime;
        }
    }
    return 0;
}

@end

@implementation CYVideoQueueModel

- (instancetype)initWithUrls:(NSArray<NSString*>*)stirngFormatURLs header:(NSDictionary*)header {
    self = [super init];
    if (self) {
        _allVideoInfoQueue = [NSMutableArray new];
        _allPlayeItemQueue = [NSMutableArray new];
        _baseProgressTime  = 0;
        NSTimeInterval beginTime = 0;
        for (NSString *URLString in stirngFormatURLs) {
            if (![URLString isKindOfClass:[NSString class]]) {
                NSLog(@"%s:input is not a string:%@",__FUNCTION__,URLString);
                continue;
            }
            NSArray *keys = @[
                              @"tracks",
                              @"duration",
                              @"commonMetadata",
                              @"availableMediaCharacteristicsWithMediaSelectionOptions"
                              ];
            NSDictionary  *options = @{@"AVURLAssetHTTPHeaderFieldsKey":header?:@{},
                                       AVURLAssetPreferPreciseDurationAndTimingKey:[NSNumber numberWithBool:YES]};
            NSURL         *URL      = [NSURL URLWithString:URLString];
            AVURLAsset    *asset    = [AVURLAsset URLAssetWithURL:URL options:options];
            AVPlayerItem  *item     = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:keys];
            NSTimeInterval duration = CMTimeGetSeconds(asset.duration);
            CYVideoModel  *infoItem = [CYVideoModel createItemWithBeginTime:beginTime
                                                                   duration:duration];
            beginTime += duration;
            _duration += duration;
            [_allPlayeItemQueue addObject:item];
            [_allVideoInfoQueue addObject:infoItem];
            
            NSLog(@"--- duration = %f",duration);
        }
        if (![_allPlayeItemQueue count]) {
            NSLog(@"%s:没有有效的URL",__FUNCTION__);
            return nil;
        }
    }
    return self;
}

- (NSMutableArray<AVPlayerItem*>*)copyedPlayItemQueue {
    NSMutableArray<AVPlayerItem*> *items = [NSMutableArray new];
    
    for (int i = 0; i < [self.allPlayeItemQueue count];i++) {
        AVPlayerItem *item = [self.allPlayeItemQueue[i] copy];
        [items addObject:item];
    }
    
    return items;
}

- (void)seekTo:(NSTimeInterval)seekToTime completation:(void (^)(NSArray<AVPlayerItem*>*playItemQueue,NSTimeInterval sectionInterval))completation {
    _baseProgressTime = 0;
    if ([self.allPlayeItemQueue count] != [self.allVideoInfoQueue count]) {
        NSLog(@"%s:info和item 队列信息不匹配",__FUNCTION__);
        return;
    }
    NSMutableArray<AVPlayerItem*> *playItemQueue = [self copyedPlayItemQueue];
    for (NSInteger i = 0; i < [self.allVideoInfoQueue count];i++) {
        CYVideoModel *item = self.allVideoInfoQueue[i];
        if ([item isInTime:seekToTime]) {
            NSTimeInterval sectionSeekTime = [item sectionSeekTime:seekToTime];
            completation(playItemQueue,sectionSeekTime);
            return;
        } else {
            [playItemQueue removeObjectAtIndex:0];
            _baseProgressTime += item.s_duration;
        }
    }
    completation(nil,0);
}

@end
