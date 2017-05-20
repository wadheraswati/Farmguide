//
//  FormListViewController.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/19/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *forms;
    NSArray <Form *> *formList;
}

@property (nonatomic, retain) NSString *status;

@end
