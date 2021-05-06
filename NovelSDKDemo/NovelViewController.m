//
//  NovelViewController.m
//  NovelSDKDemo
//
//  Created by likun on 2021/4/28.
//

#import "NovelViewController.h"
#import <BXBookStoreSDK/BXNovelManager.h>
#import <BUAdSDK/BUAdSDK.h>
@interface NovelViewController ()<BookStoreDelegate,BUNativeExpressRewardedVideoAdDelegate>
@property (nonatomic,strong) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic,strong) NSString *callBack;
@end

@implementation NovelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BXNovelManager defaultManager].delegate = self;
    
    CGFloat h = self.isTabBar ? self.tabBarController.tabBar.frame.size.height:0;
    // 获取小说页面,控制器自己实现
    // thirdUserId: 用户的id
    // placeId: 资源位id,通过小满运营获取
    UIView *view = [[BXNovelManager defaultManager] getBookStoreViewWithFram:CGRectMake(0, [self getStatusBarHeight]+[self getNavigationBarHeight], self.view.frame.size.width, self.view.frame.size.height-[self getStatusBarHeight]-[self getNavigationBarHeight]-h) thirdUserId:@"1234566789" placeId:@"3582"];
    [self.view addSubview:view];
}

- (void)showAd:(NSDictionary *)params callBack:(NSString *)callBack{
    NSLog(@"%@========%@",params,callBack);
    // 根据params中的adFrom判断广告源平台,根据posId获得对应平台的代码位.具体参考文档中的定义
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
    
    // 如果采用 getBookStoreViewWithFram 方式加载小说页面,请使用当前控制器作为根控制器
    [self.rewardedVideoAd showAdFromRootViewController:self ritScene:BURitSceneType_home_get_bonus ritSceneDescribe:nil];
    
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

/**
 *  获取状态栏高度
 */
-(CGFloat)getStatusBarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}
/**
 *  获取导航栏高度
 */
-(CGFloat)getNavigationBarHeight{
    return self.navigationController.navigationBar.frame.size.height;
}

@end
