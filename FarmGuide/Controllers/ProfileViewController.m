//
//  ProfileViewController.m
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    
    self.library = [[ALAssetsLibrary alloc] init];
    items = [NSArray arrayWithObjects:@{@"name":@"Name",@"type":@"1"},@{@"name":@"Gender",@"type":@"2"},@{@"name":@"Contact",@"type":@"3"},@{@"name":@"Date of Birth",@"type":@"4"},nil];
    
    self.profileImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width*(float)9/16)];
    [self.profileImgV setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:self.profileImgV];
    [self.profileImgV setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapped)];
    [self.profileImgV addGestureRecognizer:tapGesture];
    [self.library getImage:[NSURL URLWithString:[[AppManager sharedManager] profile].imageURL] withCompletionBlock:^(UIImage *image, NSString* error) {
        if(image) [self.profileImgV setImage:image];
    }];
    
    NSMutableParagraphStyle *centerPara = [NSMutableParagraphStyle new];
    centerPara.alignment = NSTextAlignmentCenter;
    UILabel *containerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width*(float)9/16)];
    containerTitle.numberOfLines = 3;
    containerTitle.backgroundColor = [kPrimaryBlackColor colorWithAlphaComponent:0.15];
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:@"\n\nSET PROFILE PICTURE" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: kPrimaryWhiteColor}];
    [attrstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"googleicon" size:48] range:NSMakeRange(0, 1)];
    [attrstr addAttribute:NSParagraphStyleAttributeName value:centerPara range:NSMakeRange(0, attrstr.length)];
    containerTitle.attributedText = attrstr;
    [self.view addSubview:containerTitle];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.profileImgV.frame.origin.y + self.profileImgV.frame.size.height, self.view.bounds.size.width, self.view.frame.size.height - 20)];
    self.tableView.backgroundColor = kPrimaryWhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 75;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[ProfileCell class] forCellReuseIdentifier:@"profileCell"];
    [self.view addSubview:self.tableView];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - UITableViewDelegate & UITableViewDataSource Methods -

- (NSInteger)tableView:(UITableView *)tableView2 numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"profileCell";
    ProfileCell *cell = (ProfileCell *)[tableView2 dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.nameLbl setText:[items[indexPath.row] valueForKey:@"name"]];
    [cell setType:[[items[indexPath.row] valueForKey:@"type"] integerValue]];
    [cell.valueField setDelegate:self];
    switch (indexPath.row) {
        case 0:
            [cell.valueField setText:[[AppManager sharedManager] profile].name];
            break;
        case 1:
            [cell.valueField setText:[[AppManager sharedManager] profile].gender];
            break;
        case 2:
            [cell.valueField setText:[NSString stringWithFormat:@"%lu",[[AppManager sharedManager] profile].contact]];
            break;
        case 3:
            [cell.valueField setText:[[AppManager sharedManager] profile].dob];
            break;
        default:
            break;
    }
    
    
    [cell layoutSubviews];
    return cell;
}

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView2 deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Action Methods -
- (void)imgTapped {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.profileImgV setImage:info[UIImagePickerControllerOriginalImage]];
    NSURL *imageURLStr = info[UIImagePickerControllerReferenceURL];
    [[[AppManager sharedManager] profile] setImageURL:imageURLStr.absoluteString];
    [[AppManager sharedManager] updateUserProfile];

}
#pragma mark - Helper Methods -


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
