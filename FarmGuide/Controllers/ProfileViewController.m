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
    
    self.navigationItem.title = @"Profile";
    
    gender = [NSArray arrayWithObjects:@"Female", @"Male", nil];
    self.library = [[ALAssetsLibrary alloc] init];
    items = [NSArray arrayWithObjects:@"Name", @"Gender", @"Contact", @"Date Of Birth", nil];
    
    NSDictionary *barButtonAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"googleicon" size:21.0f], NSForegroundColorAttributeName: kTertiaryBlackColor};
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [backButton setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.profileImgV.frame.origin.y + self.profileImgV.frame.size.height, self.view.bounds.size.width, self.view.frame.size.height - self.profileImgV.frame.size.height)];
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
    
    [cell.nameLbl setText:items[indexPath.row]];
    [cell.valueField setDelegate:self];
    [cell.valueField setTag:indexPath.row + 1];
    
    switch (indexPath.row) {
        case 0:
            [cell.valueField setText:[[AppManager sharedManager] profile].name];
            break;
        case 1:
            [cell.valueField setText:[[AppManager sharedManager] profile].gender];
            [cell.valueField setEnabled:NO];
            break;
        case 2:
            [cell.valueField setText:[NSString stringWithFormat:@"%lu",[[AppManager sharedManager] profile].contact]];
            [cell.valueField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            break;
        case 3:
            [cell.valueField setText:[[AppManager sharedManager] profile].dob];
            [cell.valueField setEnabled:NO];
            break;
        default:
            break;
    }
    
    
    [cell layoutSubviews];
    return cell;
}

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 1 || indexPath.row == 3) {
        [self.view endEditing:YES];
        CGRect toolbarTargetFrame = CGRectMake(0, self.view.window.bounds.size.height - 216 - 44, self.view.window.bounds.size.width, 44);
        CGRect datePickerTargetFrame = CGRectMake(0, self.view.window.bounds.size.height - 216, self.view.window.bounds.size.width, 216);
        
        datePickerView = [[UIView alloc] initWithFrame:self.view.window.bounds];
        datePickerView.alpha = 0;
        datePickerView.tag = 9;
        datePickerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        [datePickerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setDOB)]];
        [self.view.window addSubview:datePickerView];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.window.bounds.size.height + 44, self.view.window.bounds.size.width, self.view.bounds.size.width*(float)9/16)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.backgroundColor = kSecondaryWhiteColor;
        datePicker.tag = 8;
        datePicker.date = [NSDate date];
        [datePickerView addSubview:datePicker];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.width*(float)9/16)];
        [pickerView setDelegate:self];
        [pickerView setDataSource:self];
        [pickerView setBackgroundColor:kSecondaryWhiteColor];
        [datePickerView addSubview:pickerView];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.window.bounds.size.height, self.view.window.bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleDefault;
        toolBar.translucent = YES;
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setDOB)];
        doneButton.tintColor = kPrimaryBlackColor;
        [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, spacer, nil]];
        [datePickerView addSubview:toolBar];
        
        [UIView animateWithDuration:0.25 animations:^{
            toolBar.frame = toolbarTargetFrame;
            if(indexPath.row == 3)
                datePicker.frame = datePickerTargetFrame;
            else
                pickerView.frame = datePickerTargetFrame;
            datePickerView.alpha = 1;
        }];

    }
    
    [tableView2 deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Action Methods -

- (void)setDOB {
    ProfileCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-YYYY"];
    [cell.valueField setText:[formatter stringFromDate:((UIDatePicker *)[datePickerView viewWithTag:8]).date]];
    [UIView animateWithDuration:0.25 animations:^{
        datePickerView.alpha = 0;
    } completion:^(BOOL finished) {
        [datePickerView removeFromSuperview];
    }];
}

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

#pragma mark - UITextFieldDelegate Methods -

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    keyboardHeight = keyboardSize.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, self.view.bounds.size.height - keyboardHeight);
    }];
    
}
- (void)keyboardWillHide:(NSNotification *) notification {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(0, self.profileImgV.frame.origin.y + self.profileImgV.frame.size.height, self.tableView.bounds.size.width, self.view.bounds.size.height - self.profileImgV.frame.size.height);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.tag == 3)
    {
        if(![self validateNumber:textField.text])
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops.. Please enter a valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            textField.text = [NSString stringWithFormat:@"%lu",[[AppManager sharedManager] profile].contact];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource Methods -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return (row ==  0)?@"Female":@"Male";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    ProfileCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell.valueField setText:gender[row]];

}

#pragma mark - Secondary Methods -

- (void)save {
    
    UserProfile *profile = [[UserProfile alloc] init];
    
    profile.name = ((ProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).valueField.text;
    profile.gender = ((ProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).valueField.text;
    profile.contact = [((ProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).valueField.text integerValue];
    profile.dob = ((ProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).valueField.text;
    profile.imageURL = [[AppManager sharedManager] profile].imageURL;
    [[AppManager sharedManager] setProfile:profile];
    if([[AppManager sharedManager] updateUserProfile]){
        [self.view endEditing:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kProfileUpdateObserver object:nil];
        [[[UIAlertView alloc] initWithTitle:@"Wohoo.." message:@"Profile saved successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateNumber:(NSString *)string
{
    NSString *phoneRegex = @"[987][0-9]{9}?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:string];
    return matches;
}

#pragma mark - Helper Methods -


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

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
