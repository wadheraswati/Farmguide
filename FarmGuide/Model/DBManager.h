//
//  DBManager.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/17/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "UserProfile.h"

@interface DBManager : NSObject
{
    sqlite3 *db;
}

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilePath;

+ (id)sharedManager;

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

- (BOOL)saveUserProfile:(UserProfile *)profile;
- (UserProfile *)getUserProfile;

@end