//
//  DBManager.m
//  FarmGuide
//
//  Created by Swati Wadhera on 5/17/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager


+ (id)sharedManager {
    static DBManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] initWithDatabaseFilename:@"FarmGuide.sql"];
    });
    return sharedMyManager;
}

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
    
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectoryWithPath:dbFilename];
    }
    return self;
}

- (void)copyDatabaseIntoDocumentsDirectoryWithPath:(NSString *)path{
    // Check if the database file exists in the documents directory.
    self.databaseFilePath = [self.documentsDirectory stringByAppendingPathComponent:path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.databaseFilePath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:self.databaseFilePath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (BOOL)saveUserProfile:(UserProfile *)profile{
    [self openDB];
    
    NSString *insertSQL = [NSString stringWithFormat:
                           @"UPDATE UserProfile SET name = \"%@\", contact = %lu, gender = \"%@\", dob = \"%@\", imageurl = \"%@\" WHERE id = 1" ,
                           profile.name, profile.contact, profile.gender, profile.dob, profile.imageURL];
    const char *sql = [insertSQL UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement");
        return NO;
    }
    
    sqlite3_open([self.databaseFilePath UTF8String], &db);
    sqlite3_step(sqlStatement);
    sqlite3_finalize(sqlStatement);
    sqlite3_close(db);
    return YES;
}

- (UserProfile *)getUserProfile {
    [self openDB];
    
    const char *sql = "SELECT * from UserProfile";
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement");
    }
    
    UserProfile *profile = [[UserProfile alloc]init];

    while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
        profile.profileID = sqlite3_column_int(sqlStatement, 0);
        profile.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
        profile.gender = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,2)];
        profile.imageURL = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)];
        profile.contact = sqlite3_column_int64(sqlStatement, 4);
        profile.dob = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,5)];
    }
    
    return profile;
}

- (void)createForm:(Form *)form {
    
    NSString *insertSQL = [NSString stringWithFormat:
                           @"INSERT into Forms(name, mobNumPrimary, mobNumSecondary, dob, sex, address, land, bank, status) values(\"%@\",%lu, %lu,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%lu);" ,
                           form.name, form.mobNumPrimary, form.mobNumSecondary, form.dob, form.gender, form.address, form.land, form.bank, form.status];
    
    const char *sql = [insertSQL UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement");
    }
    
    sqlite3_open([self.databaseFilePath UTF8String], &db);
    sqlite3_step(sqlStatement);
    sqlite3_finalize(sqlStatement);
    sqlite3_close(db);
}

- (BOOL)updateForm:(Form *)form WithID:(NSUInteger)formID {
    
    NSString *insertSQL = [NSString stringWithFormat:
                           @"UPDATE UserProfile SET name = \"%@\", mobNumPrimary = %lu, mobNumSecondary = %lu, dob = \"%@\", sex = \"%@\", address = \"%@\", land = \"%@\", bank = \"%@\", status = %lu WHERE id = %lu", form.name, form.mobNumPrimary, form.mobNumSecondary, form.dob, form.gender, form.address, form.land, form.bank, formID, form.status];

    const char *sql = [insertSQL UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement");
    }
    
    sqlite3_open([self.databaseFilePath UTF8String], &db);
    sqlite3_step(sqlStatement);
    sqlite3_finalize(sqlStatement);
    sqlite3_close(db);

    
    return YES;
}

- (Form *)getFormWithID:(NSString *)formID {
    [self openDB];
    
    NSString *insertSQL = [NSString stringWithFormat:@"SELECT * from Forms where id = %@",formID];
    const char *sql = [insertSQL UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement");
    }
    
    Form *formObj = [[Form alloc]init];
    
    while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
        formObj.formID = sqlite3_column_int(sqlStatement, 0);
        formObj.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
        formObj.mobNumPrimary = sqlite3_column_int64(sqlStatement, 2);
        formObj.mobNumSecondary = sqlite3_column_int64(sqlStatement, 3);
        formObj.dob = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
        formObj.gender = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,5)];
        formObj.address = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,6)];
        formObj.land = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,7)];
        formObj.bank = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,8)];
    }
    
    return formObj;

}


-(void)openDB {
    if(!(sqlite3_open([self.databaseFilePath UTF8String], &db) == SQLITE_OK))
    {
        NSLog(@"An error has occured.");
    }
    
}


@end
