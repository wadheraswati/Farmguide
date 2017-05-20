//
//  ProfileCell.m
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell
@synthesize nameLbl, valueField;
@synthesize addBtn;
@synthesize type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width - 10, 25)];
        [nameLbl setFont:[UIFont systemFontOfSize:16]];
        [nameLbl setTextAlignment:NSTextAlignmentLeft];
        [nameLbl setTextColor:[UIColor blackColor]];
        [nameLbl setNumberOfLines:1];
        [self addSubview:nameLbl];
        
        addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [addBtn sizeToFit];
        [addBtn setFrame:CGRectMake(self.bounds.size.width - addBtn.bounds.size.width - 10, 10, addBtn.bounds.size.width, addBtn.bounds.size.height)];
        //[self addSubview:addBtn];
        
        valueField = [[UITextField alloc] initWithFrame:CGRectMake(5, nameLbl.frame.origin.y + nameLbl.frame.size.height + 5, self.bounds.size.width - 10, 25)];
        [valueField setFont:[UIFont systemFontOfSize:15]];
        [valueField setTextColor:[kPrimaryBlackColor colorWithAlphaComponent:0.8]];
        [valueField setTextAlignment:NSTextAlignmentLeft];
        [valueField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self addSubview:valueField];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(valueField.frame.origin.x, valueField.frame.origin.y + valueField.frame.size.height, valueField.frame.size.width, 1)];
        [lineView setBackgroundColor:kPrimaryBlackColor];
        [self addSubview:lineView];

    }
    return self;
}

- (void)layoutSubviews {
    [nameLbl setFrame:CGRectMake(5, 5, self.bounds.size.width - 10, 25)];
    [valueField setFrame:CGRectMake(5, nameLbl.frame.origin.y + nameLbl.frame.size.height + 5, self.bounds.size.width - 10, 25)];
    [lineView setFrame:CGRectMake(valueField.frame.origin.x, valueField.frame.origin.y + valueField.frame.size.height, valueField.frame.size.width, 1)];
    [addBtn setFrame:CGRectMake(self.bounds.size.width - addBtn.bounds.size.width - 10, 10, addBtn.bounds.size.width, addBtn.bounds.size.height)];
}



@end
