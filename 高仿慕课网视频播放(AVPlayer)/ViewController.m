//
//  ViewController.m
//  高仿慕课网视频播放(AVPlayer)
//
//  Created by BuzzLightYear23 on 16/2/21.
//  Copyright © 2016年 Irving. All rights reserved.
//

#import "ViewController.h"
#import "VideoPlayerView.h"
#import "FullViewController.h"


@interface ViewController ()<VideoPlayViewDelegate>

@property(weak , nonatomic) VideoPlayerView *playView;
@property(nonatomic ,strong) FullViewController *fullVc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //改变状态栏的背景颜色和前景颜色
    CGFloat statwidth = [[UIApplication sharedApplication] statusBarFrame].size.width;
    CGFloat statheight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, statwidth, statheight)];
    
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    [self setTopVideoPlayerView];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"]];
    
    self.playView.playerItem = item;
}


//设置视频的位置
- (void)setTopVideoPlayerView
{
    VideoPlayerView *playView = [VideoPlayerView videoPlayView];
    //获取状态栏的高度
    CGFloat statheight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    playView.frame = CGRectMake(0, statheight, self.view.bounds.size.width, self.view.bounds.size.width * 9/16);
    [self.view addSubview:playView];
    self.playView = playView;
    self.playView.delegate = self;
}

-(void)videoplayViewSwitch:(BOOL)isFull
{
    
    if(isFull){
        //UIPresentationController，iOS8出现,它与 iOS 7 新添加的几个类与协议一道，帮助我们方便快捷地实现 ViewController 的自定义过渡效果
        [self presentViewController:self.fullVc animated:YES completion:^{
            self.playView.frame = self.fullVc.view.bounds;
            [self.fullVc.view addSubview:self.playView];
            
        }];
    }else{
        [self.fullVc dismissViewControllerAnimated:YES completion:^{
            self.playView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9/16);
            [self.view addSubview:self.playView];
        }];
    }
    
}

#pragma mark - 懒加载代码
-(FullViewController *)fullVc
{
    if(_fullVc == nil){
        self.fullVc=[[FullViewController alloc] init];
    }
    return _fullVc;
}

@end
