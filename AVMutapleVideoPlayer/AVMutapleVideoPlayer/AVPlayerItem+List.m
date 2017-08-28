//
//  AVPlayerItem+List.m
//  AVMutapleVideoPlayer
//
//  Created by yu cao on 2017/8/28.
//  Copyright © 2017年 wolf. All rights reserved.
//

#import "AVPlayerItem+List.h"
#import <objc/runtime.h>

@implementation AVPlayerItem (List)

- (void)setNext:(AVPlayerItem *)next {
    objc_setAssociatedObject(self, @selector(setNext:), next, OBJC_ASSOCIATION_ASSIGN);
}

- (AVPlayerItem*)next {
    return objc_getAssociatedObject(self, @selector(setNext:));
}

@end
