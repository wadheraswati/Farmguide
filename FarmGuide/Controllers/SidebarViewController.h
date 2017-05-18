//
//  SidebarViewController.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "ProfileViewController.h"

@interface SidebarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *categories;
    
}

@property (nonatomic, retain) UITableView *tableView;
@property (strong, atomic) ALAssetsLibrary* library;

@end
