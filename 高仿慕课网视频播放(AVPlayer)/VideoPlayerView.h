//
//  VideoPlayerView.h
//  高仿慕课网视频播放(AVPlayer)
//
//  Created by BuzzLightYear23 on 16/2/21.
//  Copyright © 2016年 Irving. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVfoundation.h>

@protocol VideoPlayViewDelegate <NSObject>

@optional
-(void)videoplayViewSwitch:(BOOL)isFull;

@end

@interface VideoPlayerView : UIView

+(instancetype)videoPlayView;

@property(weak ,nonatomic)id<VideoPlayViewDelegate>delegate;

@property(nonatomic,strong) AVPlayerItem *playerItem;

@end
