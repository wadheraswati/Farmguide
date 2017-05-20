//
//  Form.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/19/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Form : NSObject

@property (nonatomic, assign) NSUInteger formID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSUInteger mobNumPrimary;
@property (nonatomic, assign) NSUInteger mobNumSecondary;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *land;
@property (nonatomic, retain) NSString *bank;
@property (nonatomic, assign) NSUInteger status;
@property (nonatomic, retain) NSString *dob;

@end
