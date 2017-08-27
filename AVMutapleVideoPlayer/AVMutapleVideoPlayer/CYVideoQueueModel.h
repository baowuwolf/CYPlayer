//
//  CYVideoQueueModel.h
//  AVMutapleVideoPlayer
//
//  Created by yu cao on 2017/8/27.
//  Copyright © 2017年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class CYVideoModel;

@interface CYVideoQueueModel : NSObject

@property (nonatomic,strong) NSMutableArray<CYVideoModel*> *allVideoInfoQueue;
@property (nonatomic,strong) NSMutableArray<AVPlayerItem*> *allPlayeItemQueue;
@property (nonatomic,weak) CYVideoModel                    *currentVideoItem;
@property (nonatomic,assign) NSTimeInterval                 duration;
@property (nonatomic,assign) NSTimeInterval                 baseProgressTime;//currentPlayitem+baseProgressTime = realProgress


- (void)seekTo:(NSTimeInterval)seekToTime completation:(void (^)(NSArray<AVPlayerItem*>*playItemQueue,NSTimeInterval sectionInterval))completation;

- (instancetype)initWithUrls:(NSArray<NSString*>*)stirngFormatURLs header:(NSDictionary*)header;

@end
