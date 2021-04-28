//
//  ViewController.m
//  NovelSDKDemo
//
//  Created by likun on 2021/4/28.
//

#import "ViewController.h"
#import <BXBookStoreSDK/BXNovelManager.h>
#import <BUAdSDK/BUAdSDK.h>
@interface ViewController ()<BookStoreDelegate,BUNativeExpressRewardedVideoAdDelegate>
@property (nonatomic,strong) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic,strong) NSString *callBack;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [BXNovelManager defaultManager].delegate = self;
    
    // 获取小说页面,控制器自己实现
//    UIView *view = [[BXNovelManager defaultManager] getBookStoreViewWithFram:self.view.frame thirdUserId:@"1234566789" placeId:@"3582"];
//    [self.view addSubview:view];
    
    // 直接推出一个控制器,承载小说页面
    [[BXNovelManager defaultManager] presentBookStoreWtihUserId:@"12345677898" placeId:@"3582" rootController:self];
    
}

- (void)showAd:(NSDictionary *)params callBack:(NSString *)callBack{
    NSLog(@"%@========%@",params,callBack);
    
    self.params = params;
    self.callBack = callBack;
    
    BURewardedVideoModel *rewardModel = [[BURewardedVideoModel alloc] init];
    rewardModel.userId = @"123456789";
    self.rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:@"945734106" rewardedVideoModel:rewardModel];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
}
#pragma mark - BURewardedVideoAdDelegate

- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"穿山甲-激励视频广告-物料-加载成功");
    // 如果采用 present 方式加载小说页面,请使用 [BXNovelManager defaultManager].currentViewController 作为根控制器,不然视频出不来
    [self.rewardedVideoAd showAdFromRootViewController:[BXNovelManager defaultManager].currentViewController ritScene:BURitSceneType_home_get_bonus ritSceneDescribe:nil];
    
    // 如果采用 getBookStoreViewWithFram 方式加载小说页面,请使用当前控制器作为根控制器
//    [self.rewardedVideoAd showAdFromRootViewController:self ritScene:BURitSceneType_home_get_bonus ritSceneDescribe:nil];
    
    [[BXNovelManager defaultManager] uploadVideoLoad:self.params callBack:self.callBack];

}
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"穿山甲-视频关闭");
    [[BXNovelManager defaultManager] uploadVideoClose:self.params callBack:self.callBack];
    
}
- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"穿山甲-视频或素材加载失败: %@",error);
    [[BXNovelManager defaultManager] uploadVideoError:self.params callBack:self.callBack];
}

- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"穿山甲-激励视频广告-点击");
    [[BXNovelManager defaultManager] uploadVideoClick:self.params callBack:self.callBack];
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"穿山甲-激励视频广告-播放完成");
    [[BXNovelManager defaultManager] uploadVideoComplete:self.params callBack:self.callBack];

}
@end
