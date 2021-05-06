//
//  AppDelegate.m
//  NovelSDKDemo
//
//  Created by likun on 2021/4/28.
//

#import "AppDelegate.h"
#import <BXBookStoreSDK/BXNovelManager.h>
#import <BUAdSDK/BUAdSDK.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 小说sdk初始化 appkey和secretKey注意替换成自己的
    [[BXNovelManager defaultManager] setAppKey:@"kljbxsSDKzk_aoptsy" secretKey:@"Q046Lo8g736d0Bn3"];
    
    // 穿山甲sdk初始化
    [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
    [BUAdSDKManager setAppID:@"5133954"];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
