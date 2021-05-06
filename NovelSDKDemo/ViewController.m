//
//  ViewController.m
//  NovelSDKDemo
//
//  Created by likun on 2021/4/28.
//

#import "ViewController.h"
#import <BXBookStoreSDK/BXNovelManager.h>
#import <BUAdSDK/BUAdSDK.h>
#import "NovelViewController.h"
@interface ViewController ()<BookStoreDelegate,BUNativeExpressRewardedVideoAdDelegate>
@property (nonatomic,strong) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic,strong) NSString *callBack;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小说demo";
}

/// 直接弹出控制器
- (IBAction)showViewController:(id)sender {
    [BXNovelManager defaultManager].delegate = self;
    // 直接推出一个控制器,承载小说页面
    // userId: 用户的id
    // placeId: 资源位id,通过小满运营获取
    [[BXNovelManager defaultManager] presentBookStoreWtihUserId:@"12345677898" placeId:@"3582" rootController:self];
}

/// 进入二级页面
- (IBAction)showUIView:(id)sender {
    NovelViewController *vc = [[NovelViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
/// tab方式
- (IBAction)showTab:(id)sender {
    
    NovelViewController *vc = [[NovelViewController alloc] init];
    vc.isTabBar = YES;
    vc.tabBarItem.title = @"小说";
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.tabBarItem.title = @"其他";
    vc2.view.backgroundColor = UIColor.whiteColor;
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    [tabVC setViewControllers:@[vc,vc2]];
    [self.navigationController pushViewController:tabVC animated:YES];
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
