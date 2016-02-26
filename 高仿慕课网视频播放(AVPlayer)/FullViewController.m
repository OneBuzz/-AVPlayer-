//
//  FullViewController.m
//  高仿慕课网视频播放(AVPlayer)
//
//  Created by BuzzLightYear23 on 16/2/24.
//  Copyright © 2016年 Irving. All rights reserved.
//
//单独做一个控制器对全屏进行控制
#import "FullViewController.h"

@interface FullViewController ()

@end

@implementation FullViewController

-(instancetype)init{
 
    
    if(self = [super init]){
        
    }
    return self;
}
//设置支持某个方向
-(NSUInteger)supportedInterfaceOrientations{
    
    
    return UIInterfaceOrientationMaskLandscapeLeft;
}
@end
