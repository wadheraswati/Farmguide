//
//  ViewController.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UITableView *formTable;
    
    NSArray *gender;
    
    NSUInteger banks;
    NSUInteger lands;
    NSUInteger keyboardHeight;

    UIView *datePickerView;
}

@property (nonatomic, assign) NSUInteger formID;
@end

