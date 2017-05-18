//
//  AppManager.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DBManager.h"

typedef void(^GetImageCompletion)(UIImage *image, NSString* error);

@interface AppManager : NSObject

+ (id)sharedManager;

@property (nonatomic, retain) UserProfile *profile;

- (void)setUserProfile;
- (void)updateUserProfile;

@end
