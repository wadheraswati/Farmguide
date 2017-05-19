//
//  AppManager.m
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

+ (id)sharedManager {
    static AppManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)setUserProfile {
    self.profile = [[DBManager sharedManager] getUserProfile];
}

- (BOOL)updateUserProfile {
    if(![[DBManager sharedManager] saveUserProfile:self.profile])
    {
        self.profile = [[DBManager sharedManager] getUserProfile];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops..Could not save the detail for now. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

@end
