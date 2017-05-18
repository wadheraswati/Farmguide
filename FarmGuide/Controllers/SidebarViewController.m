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
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.rowHeight = 75;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
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

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    
    if(indexPath.section == 0) {
        [cell.textLabel setText:[[AppManager sharedManager] profile].name];
        [cell.imageView setBackgroundColor:kTertiaryWhiteColor];
        [self.library getImage:[NSURL URLWithString:[[AppManager sharedManager] profile].imageURL] withCompletionBlock:^(UIImage *image, NSString* error) {
            if(image) [cell.imageView setImage:image];
        }];
    }
    else {
        [cell.textLabel setText:categories[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView2 deselectRowAtIndexPath:indexPath animated:YES];
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
