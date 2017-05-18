//
//  ProfileCell.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell
{
    UIView *lineView;
}
@property (nonatomic, retain) UILabel *nameLbl;
@property (nonatomic, retain) UITextField *valueField;
@property (nonatomic, assign) NSUInteger type;

@end
