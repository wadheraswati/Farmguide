//
//  SidebarViewController.m
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "SidebarViewController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor greenColor];
    
    categories = [NSMutableArray arrayWithObjects:@"Profile", @"Completed Forms", @"Incomplete Forms", @"Map", nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 280, self.view.frame.size.height - 20)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[kPrimaryBlackColor colorWithAlphaComponent:0.15]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.library = [[ALAssetsLibrary alloc] init];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView2 numberOfRowsInSection:(NSInteger)section {
    return (section == 0)?1:3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0)?75:50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];

    if(indexPath.section == 0) {
        cell.imageView.image = kPlaceHolderImage;
        cell.imageView.clipsToBounds = YES;
        cell.imageView.image = [[cell.imageView.image imageCroppedAndScaledToSize:CGSizeMake(50, 50) contentMode:UIViewContentModeScaleAspectFill padToFit:NO] imageWithCornerRadius:25];
        [cell.textLabel setText:[[AppManager sharedManager] profile].name];
        [self.library getImage:[NSURL URLWithString:[[AppManager sharedManager] profile].imageURL] withCompletionBlock:^(UIImage *image, NSString* error) {
            if(image)
            cell.imageView.image = [[image imageCroppedAndScaledToSize:CGSizeMake(50, 50) contentMode:UIViewContentModeScaleAspectFill padToFit:NO] imageWithCornerRadius:25];
        }];
    }
    else {
        [cell.textLabel setText:categories[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView2 deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        ProfileViewController *profileObj = [[ProfileViewController alloc] init];
        UINavigationController *settingsNav = [[UINavigationController alloc] initWithRootViewController:profileObj];
        settingsNav.navigationBar.translucent = NO;
        settingsNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [APPDELEGATE.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:^(BOOL finished) {
            [APPDELEGATE.drawerViewController.centerViewController presentViewController:settingsNav animated:YES completion:nil];
        }];
    }
    else
    {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 1)
        return 40;
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    if(section == 0) headerTitle.text = @"";
    else if (section == 1) headerTitle.text = [@"     More" uppercaseString];
    headerTitle.textAlignment = NSTextAlignmentLeft;
    headerTitle.textColor = kSecondaryBlackColor;
    headerTitle.backgroundColor = [kSecondaryWhiteColor colorWithAlphaComponent:0.95];
    headerTitle.layer.borderWidth = 0.25;
    headerTitle.layer.borderColor = [kPrimaryBlackColor colorWithAlphaComponent:0.15].CGColor;
    headerTitle.font = [UIFont systemFontOfSize:14];
    headerTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return headerTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
