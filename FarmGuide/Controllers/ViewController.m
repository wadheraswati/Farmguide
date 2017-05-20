//
//  ViewController.m
//  FarmGuide
//
//  Created by Swati Wadhera on 5/18/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize formID;

- (void)viewDidLoad {
    
    gender = [NSArray arrayWithObjects:@"Female", @"Male", nil];

    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.title = @"New Form";
    
    if(self.formID){
        
    }
    else {
        UIButton *hamburgerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [hamburgerButton setTitle:@"" forState:UIControlStateNormal];
        [hamburgerButton addTarget:self action:@selector(showSideMenu) forControlEvents:UIControlEventTouchUpInside];
        [hamburgerButton.titleLabel setFont:[UIFont fontWithName:@"googleicon" size:21.0f]];
        [hamburgerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [hamburgerButton setFrame:CGRectMake(0, 0, 44, 44)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hamburgerButton];
    }
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    formTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height)];
    formTable.backgroundColor = kPrimaryWhiteColor;
    formTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    formTable.rowHeight = 75;
    formTable.delegate = self;
    formTable.dataSource = self;
    formTable.showsVerticalScrollIndicator = NO;
    [formTable registerClass:[ProfileCell class] forCellReuseIdentifier:@"profileCell"];
    [self.view addSubview:formTable];
    
    if(self.formID){
        Form *form = [[DBManager sharedManager] getFormWithID:formID];
        [self updateFormFieldsWithForm:form];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)showSideMenu {
    [APPDELEGATE.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:nil];
}

- (void)updateFormFieldsWithForm:(Form *)form {
    for(int i = 0; i < [formTable numberOfRowsInSection:0]; i++) {
        ProfileCell *cell = [formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        switch (i) {
            case 0:
                [cell.valueField setText:form.name];
                break;
            case 1:
                [cell.valueField setText:[NSString stringWithFormat:@"%lu",form.mobNumPrimary]];
                break;
            case 2:
                [cell.valueField setText:[NSString stringWithFormat:@"%lu",form.mobNumSecondary]];
                break;
            case 3:
                [cell.valueField setText:form.dob];
                break;
            case 4:
                [cell.valueField setText:form.gender];
                break;
            case 5:
                [cell.valueField setText:form.address];
                break;
            case 6:
                [cell.valueField setText:form.land];
                break;
            case 7:
                [cell.valueField setText:form.bank];
                break;
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource Methods -

- (NSInteger)tableView:(UITableView *)tableView2 numberOfRowsInSection:(NSInteger)section {
        return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"profileCell";
    ProfileCell *cell = (ProfileCell *)[tableView2 dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
     
    if(indexPath.section == 0)
    {
        [cell.addBtn setHidden:YES];
        [cell.valueField setDelegate:self];
        [cell.valueField setTag:indexPath.row + 1];
        [cell.valueField setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        switch (indexPath.row) {
            case 0:
                [cell.nameLbl setText:@"Farmer Name"];
                break;
            case 1:
                [cell.nameLbl setText:@"Mobile Number(Primary)"];
                break;
            case 2:
                [cell.nameLbl setText:@"Mobile Number(Secondary)"];
                break;
            case 3:
                [cell.nameLbl setText:@"Date of Birth"];
                [cell.valueField setEnabled:NO];
                break;
            case 4:
                [cell.nameLbl setText:@"Sex"];
                [cell.valueField setEnabled:NO];
                break;
            case 5:
                [cell.nameLbl setText:@"Address"];
                break;
            case 6:
                [cell.nameLbl setText:@"Land Details"];
                break;
            case 7:
                [cell.nameLbl setText:@"Bank Details"];
                break;
            default:
                break;
        }
    }
    


    return cell;
}

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 3 || indexPath.row == 4) {
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
        datePicker.maximumDate = [NSDate date];
        datePicker.date = [NSDate date];
        [datePickerView addSubview:datePicker];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.width*(float)9/16)];
        [pickerView setDelegate:self];
        [pickerView setDataSource:self];
        [pickerView setTag:10];
        [pickerView setBackgroundColor:kSecondaryWhiteColor];
        [datePickerView addSubview:pickerView];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.window.bounds.size.height, self.view.window.bounds.size.width, 44)];
        toolBar.barStyle = UIBarStyleDefault;
        toolBar.translucent = YES;
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        if(indexPath.row == 3)
        {
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setDOB)];
            doneButton.tintColor = kPrimaryBlackColor;
            [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, spacer, nil]];
        }
        else
        {
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setGender)];
            doneButton.tintColor = kPrimaryBlackColor;
            [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, spacer, nil]];
            
        }
        
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
    ProfileCell *cell = [formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-YYYY"];
    [cell.valueField setText:[formatter stringFromDate:((UIDatePicker *)[datePickerView viewWithTag:8]).date]];
    [UIView animateWithDuration:0.25 animations:^{
        datePickerView.alpha = 0;
    } completion:^(BOOL finished) {
        [datePickerView removeFromSuperview];
    }];
}

- (void)setGender {
    ProfileCell *cell = [formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [cell.valueField setText:gender[[((UIPickerView *)[datePickerView viewWithTag:10]) selectedRowInComponent:0]]];
    [UIView animateWithDuration:0.25 animations:^{
        datePickerView.alpha = 0;
    } completion:^(BOOL finished) {
        [datePickerView removeFromSuperview];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    keyboardHeight = keyboardSize.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        formTable.frame = CGRectMake(0, 0, formTable.bounds.size.width, self.view.bounds.size.height - keyboardHeight);
    }];
    
}
- (void)keyboardWillHide:(NSNotification *) notification {
    
    [UIView animateWithDuration:0.25 animations:^{
        formTable.frame = CGRectMake(0, formTable.frame.origin.y, formTable.bounds.size.width, self.view.bounds.size.height);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.tag < [formTable numberOfRowsInSection:0])
    {
        if(textField.tag == 3 || textField.tag == 4)
        {
            [self tableView:formTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
            [textField resignFirstResponder];
        }
        else
            [((ProfileCell *)[formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]]).valueField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [formTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag - 1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    /*if(textField.tag == 1)
    {
        if(![self isNameEnteredFine:textField.text]) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops.. Please enter a valid name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
    if(textField.tag == 2 || textField.text == 3)
    {
        if(![self validateNumber:textField.text])
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops.. Please enter a valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }*/
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
    ProfileCell *cell = [formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [cell.valueField setText:gender[row]];
}

#pragma mark - Helper Methods -

- (BOOL)validateNumber:(NSString *)string
{
    NSString *phoneRegex = @"[987][0-9]{9}?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:string];
    return matches;
}

- (BOOL)isNameEnteredFine:(NSString *)name {
    if(name.length >= 4 && name.length <= 75)
        return YES;
    return NO;
}

- (void)save {
    NSString *name = ((ProfileCell *)[formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).valueField.text;
    NSString *mobNumPrimary = ((ProfileCell *)[formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).valueField.text;
    NSString *mobNumSecondary = ((ProfileCell *)[formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).valueField.text;
    NSString *dob = ((ProfileCell *)[formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).valueField.text;
    NSString *genderStr = ((ProfileCell *)[formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]]).valueField.text;
    NSString *address = ((ProfileCell *)[formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]]).valueField.text;
    NSString *land = ((ProfileCell *)[formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]]).valueField.text;
    NSString *bank = ((ProfileCell *)[formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]]).valueField.text;
    
    if([self isNameEnteredFine:name]){
        Form *form = [[Form alloc] init];
        form.name = name;
        form.mobNumPrimary = mobNumPrimary.integerValue;
        form.mobNumSecondary = mobNumSecondary.integerValue;
        form.dob = dob;
        form.gender = genderStr;
        form.address = address;
        form.land = land;
        form.bank = bank;

        if(self.formID == 0)
        {
            if([self validateNumber:mobNumPrimary] && [self validateNumber:mobNumSecondary] && address.length && land.length && bank.length){
                form.status = 1;
            }
            else
            {
                form.status = 0;
                ;
            }
            if([[DBManager sharedManager] createForm:form])
            {
                form.status?[[[UIAlertView alloc] initWithTitle:@"Wohoo.." message:@"Form saved successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show]:[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Incomplete Data is saved. You can complete it later by viewing it in incomplete forms" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self clearFields];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error.." message:@"Could not save form" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
            
        }
        else
        {
            if([self validateNumber:mobNumPrimary] && [self validateNumber:mobNumSecondary] && address.length && land.length && bank.length){
                form.status = 1;
                [[DBManager sharedManager] updateForm:form WithID:formID];
            }
            else
            {
                if(form.status)
                {
                    [[[UIAlertView alloc] initWithTitle:@"Error.." message:@"Please complete all details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                }
                else{
                    [[DBManager sharedManager] updateForm:form WithID:formID];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Incomplete Data is saved. You can complete it later by viewing it in incomplete forms" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }

            }
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops.. Please enter Farmer's name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }

}

- (void)clearFields {
    for(int i = 0; i < [formTable numberOfRowsInSection:0]; i++) {
        ProfileCell *cell = [formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.valueField setText:@""];
    }
}

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


@end
