//
//  AppDelegate.m
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize drawerViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[AppManager sharedManager] setUserProfile];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    drawerViewController = [[JVFloatingDrawerViewController alloc] initWithNibName:nil bundle:nil];
    drawerViewController.leftViewController = [[SidebarViewController alloc] init];
    drawerViewController.centerViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    drawerViewController.view.clipsToBounds = YES;
    drawerViewController.backgroundImage = [self squareImageWithColor:kPrimaryWhiteColor dimension:10];
    drawerViewController.animator = [[JVFloatingDrawerSpringAnimator alloc] init];
    
    [self.window setRootViewController:drawerViewController];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

- (UIImage *)squareImageWithColor:(UIColor *)color dimension:(int)dimension {
    CGRect rect = CGRectMake(0, 0, dimension, dimension);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
