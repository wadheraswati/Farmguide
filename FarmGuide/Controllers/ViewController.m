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

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *hamburgerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [hamburgerButton setTitle:@"" forState:UIControlStateNormal];
    [hamburgerButton addTarget:self action:@selector(showSideMenu) forControlEvents:UIControlEventTouchUpInside];
    [hamburgerButton.titleLabel setFont:[UIFont fontWithName:@"googleicon" size:21.0f]];
    [hamburgerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hamburgerButton setFrame:CGRectMake(0, 0, 44, 44)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hamburgerButton];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)showSideMenu {
    [APPDELEGATE.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
