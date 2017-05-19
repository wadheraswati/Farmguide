//
//  AppConstants.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#ifndef AppConstants_h
#define AppConstants_h


//constant variables
#define kPlaceHolderImage [UIImage squareImageWithColor:kTertiaryWhiteColor dimension:10]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


// colors

#define kPrimaryWhiteColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]
#define kPrimaryBlackColor [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1]

#define kSecondaryWhiteColor UIColorFromRGB(0xF1F1F1)
#define kSecondaryBlackColor [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0]

#define kTertiaryBlackColor [UIColor colorWithRed:37.0/255.0 green:37.0/255.0 blue:37.0/255.0 alpha:1]
#define kTertiaryWhiteColor [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:1]

// Observers
#define kProfileUpdateObserver @"kProfileUpdateObserver"

#endif /* AppConstants_h */
