//
//  FormListViewController.m
//  FarmGuide
//
//  Created by Swati Wadhera on 5/19/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "FormListViewController.h"
#import "ViewController.h"

@interface FormListViewController ()

@end

@implementation FormListViewController

- (void)viewDidLoad {
    
    self.navigationItem.title = [self.status integerValue]?@"Completed":@"Incompleted";
    
    NSDictionary *barButtonAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"googleicon" size:21.0f], NSForegroundColorAttributeName: kTertiaryBlackColor};
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [backButton setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = backButton;

    forms = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height)];
    forms.backgroundColor = kPrimaryWhiteColor;
    forms.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    forms.rowHeight = 50;
    forms.delegate = self;
    forms.dataSource = self;
    forms.showsVerticalScrollIndicator = NO;
    [self.view addSubview:forms];

    formList = [NSArray arrayWithArray:[[DBManager sharedManager] getFormsWithStatus:self.status]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource Methods -

- (NSInteger)tableView:(UITableView *)tableView2 numberOfRowsInSection:(NSInteger)section {
    return formList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setText:formList[indexPath.row].name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ViewController *viewObj = [[ViewController alloc] init];
    [viewObj setFormID:formList[indexPath.row].formID];
    [self.navigationController pushViewController:viewObj animated:YES];
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
