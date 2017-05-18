//
//  UserProfile.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (nonatomic, assign) NSUInteger profileID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, assign) NSUInteger contact;
@property (nonatomic, retain) NSString *dob;

@end
