//
//  ProfileViewController.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ProfileCell.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *items;
    NSArray *gender;
    NSUInteger keyboardHeight;
    
    UIView *datePickerView;
    
}
@property (nonatomic, retain) UIImageView *profileImgV;
@property (nonatomic, retain) UITableView *tableView;
@property (strong, atomic) ALAssetsLibrary* library;

@end
