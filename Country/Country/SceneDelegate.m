//
//  SceneDelegate.m
//  Country
//
//  Created by Влад Шимченко on 14.08.2026.
//

// SceneDelegate.m
#import "SceneDelegate.h"
#import "CountryListViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene
    willConnectToSession:(UISceneSession *)session
                 options:(UISceneConnectionOptions *)connectionOptions {

    if (![scene isKindOfClass:[UIWindowScene class]]) return;
    UIWindowScene *windowScene = (UIWindowScene *)scene;

    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

    CountryListViewController *listVC = [[CountryListViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:listVC];

    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
}

@end
