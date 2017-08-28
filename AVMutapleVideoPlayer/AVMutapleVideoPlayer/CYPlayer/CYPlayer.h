//
//  CYPlayer.h
//  AVMutapleVideoPlayer
//
//  Created by yu cao on 2017/8/25.
//  Copyright © 2017年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CYPlayer : AVPlayer

@end

@protocol CYPlayerViewDelegate <NSObject>

- (void)receiveDuration:(NSTimeInterval)duration;
- (void)progressTimeDidChange:(NSTimeInterval)time;
- (void)didFinishedPlay;

@end

@interface CYPlayerView : UIView

@property (nonatomic,weak) id<CYPlayerViewDelegate>delegate;

- (void)setupWithURLs:(NSArray*)stirngFormatURLs andHeader:(NSDictionary*)header;

- (void)seekTo:(NSTimeInterval)time;

@end
