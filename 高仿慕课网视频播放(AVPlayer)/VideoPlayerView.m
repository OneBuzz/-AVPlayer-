//
//  VideoPlayerView.m
//  高仿慕课网视频播放(AVPlayer)
//
//  Created by BuzzLightYear23 on 16/2/21.
//  Copyright © 2016年 Irving. All rights reserved.
//

#import "VideoPlayerView.h"

@interface VideoPlayerView();

/*播放器*/
@property (nonatomic ,strong) AVPlayer *player;

/*播放器的Layer*/
@property(weak,nonatomic) AVPlayerLayer *playerLayer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;

@property (weak, nonatomic) IBOutlet UISlider *progressSilder;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


//记录当前是否显示了工具栏
@property(assign, nonatomic) BOOL isShowToolView;

/*定时器*/
@property (nonatomic,strong) NSTimer *markTimer;

#pragma mark - 监听事件的处理
//暂停按钮的监听
-(IBAction)playOrPase:(UIButton *)sender;
//点击屏幕时的工具栏处理
- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
//屏幕的切换
- (IBAction)switchOrientation:(UIButton *)sender;

//滑条的滑动处理
- (IBAction)slider;
//滑条点击到某个点时的事件
- (IBAction)startSlider;
//滑条移动时，后面时间的变化
- (IBAction)sliderChangeValue;

@end


@implementation VideoPlayerView

//快速创View的方法
+(instancetype)videoPlayView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"VideoPlayerView"owner:nil options:nil] firstObject];
}

-(void)awakeFromNib{
    
    self.player= [[AVPlayer alloc]init];
    self.playerLayer = [ AVPlayerLayer playerLayerWithPlayer:self.player ];
    [self.imageView.layer addSublayer:self.playerLayer];
    
    self.toolView.alpha=0;
    self.isShowToolView = NO;
    
    [self.progressSilder setThumbImage:[UIImage imageNamed:@"thumbImage" ]forState:UIControlStateNormal ];
    //设置滑条右侧的颜色
    [self.progressSilder setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    //设置滑条左侧的颜色
    [self.progressSilder setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    //记载view时自动播放
    [self removeMarkTimer];
    [self addMarkTimer];
    
    self.playOrPauseBtn.selected =YES ;
}
//对awakFromNib中的playLayer的frame的大小设置，是对subviews的重新布局，因为直接加载xib并不一定能够适应屏幕的
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 设置播放的视频
-(void)setPlayerItem:(AVPlayerItem *)playerItem{
    
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
}

//是否显示工具栏
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if(self.isShowToolView)
        {
            self.toolView.alpha=0;
            self.isShowToolView = NO;
        }
        else{
            self.toolView.alpha = 1;
            self.isShowToolView = YES;
            
        }
    }];
    
}
//暂停按钮的监听
-(IBAction)playOrPase:(UIButton *)sender{
    //取反，以前为暂停设置为播放，播放则设置为暂停
    sender.selected = !sender.selected;
    if(sender.selected){
        [self.player play];
        [self addMarkTimer];
        
    }else{
        [self.player pause];
        [self removeMarkTimer];
    }
    
}

#pragma mark - 定时器操作
//开启定时器
-(void)addMarkTimer{
    //创建一个定时器
    self.markTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    
}
-(void)updateProgressInfo{
    
    //1.更新时间
    self.timeLabel.text=[self timeString];
    
    //2.设置进度条的value，当前时间／时长
    self.progressSilder.value=CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    [[NSRunLoop mainRunLoop] addTimer:self.markTimer forMode:NSRunLoopCommonModes];
}
//返回目前的时间
-(NSString *)timeString{
    
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    return [self stringWithCurrentTime:currentTime duration:duration];
}

//取消定时器
-(void)removeMarkTimer
{
    [self.markTimer invalidate];
    self.markTimer = nil;
}

//切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender {
    
    sender.selected  =! sender.selected;
    // 判断是否有某个名字命名的方法
    if([self.delegate respondsToSelector:@selector(videoplayViewSwitch:)]){
        
        [self.delegate videoplayViewSwitch:sender.selected];
    }
}

//滑条的滑动处理
- (IBAction)slider {
    [self addMarkTimer];
    
    //当前时间＝时长*进度条的value值
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration)*self.progressSilder.value;
    
    //设置当前播放时间，从某个地点开始播放
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime,NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
    
    self.playOrPauseBtn.selected = YES;
}
//滑条的落点处理，在拖动时取消定时器(touch down)
- (IBAction)startSlider {
    [self removeMarkTimer];
    
}
//拖动进度条时，后面时间的变化
- (IBAction)sliderChangeValue{
    
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration)*self.progressSilder.value;
    
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
    
    
}

//时间格式的设置
-(NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval) duration
{   //duration时长，小时
    NSInteger dMin = duration / 60 ;
    NSInteger dSec = (NSInteger) duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger) currentTime % 60 ;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld" ,dMin,dSec];
    
    NSString  *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin,cSec];
    
    return [NSString stringWithFormat:@"%@/%@",currentString,durationString];
}
@end
