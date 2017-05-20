//
//  MapViewController.m
//  FarmGuide
//
//  Created by Swati Wadhera on 5/19/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {

    [self.view setBackgroundColor:kPrimaryWhiteColor];
    
    self.navigationItem.title = @"MAP";
    items = [NSArray arrayWithObjects:@"Origin", @"Destination", nil];
    
    NSDictionary *barButtonAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"googleicon" size:21.0f], NSForegroundColorAttributeName: kTertiaryBlackColor};
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [backButton setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 100, 200)];
    self.tableView.backgroundColor = kPrimaryWhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 75;
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[ProfileCell class] forCellReuseIdentifier:@"profileCell"];
    [self.view addSubview:self.tableView];
    
    UIButton *direct = [UIButton buttonWithType:UIButtonTypeCustom];
    [direct setFrame:CGRectMake(self.view.bounds.size.width - 100, 0, 100, 30)];
    [direct setTitle:@"Directions" forState:UIControlStateNormal];
    [direct setBackgroundColor:kPrimaryWhiteColor];
    [direct setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [direct setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [direct setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [direct addTarget:self action:@selector(directBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:direct];
    [direct setCenter:CGPointMake(direct.center.x, self.tableView.center.y + 30)];

    
    self.mapView = [[MKMapView alloc] init];
    [self.mapView setFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.tableView.bounds.size.height)];
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:self.mapView];

    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = kCLDistanceFilterNone; // or whatever
    [locationManager startUpdatingLocation];
    
    [locationManager requestWhenInUseAuthorization]; //Note this one
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Location Methods -

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    CLLocationCoordinate2D coord = [locations firstObject].coordinate;
    MKCoordinateSpan span = {.latitudeDelta =  1, .longitudeDelta =  1};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
}

- (void)directBtnClicked {
    
    NSString *origin = ((ProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).valueField.text;
    NSString *destination = ((ProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).valueField.text;
    
    if(!origin.length || !destination.length) return;
    
    sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoord];
    destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoord];
    
    MKMapItem *sourceMapItem = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    MKPointAnnotation *sAnnotation = [[MKPointAnnotation alloc] init];
    sAnnotation.title = @"A";
    sAnnotation.coordinate = sourceCoord;
    
    MKPointAnnotation *dAnnotation = [[MKPointAnnotation alloc] init];
    dAnnotation.title = @"B";
    dAnnotation.coordinate = destinationCoord;
    
    [self.mapView showAnnotations:@[sAnnotation, dAnnotation] animated:YES];
    
    MKDirectionsRequest *directionReq = [[MKDirectionsRequest alloc] init];
    directionReq.source = sourceMapItem;
    directionReq.destination = destinationMapItem;
    directionReq.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionReq];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error){
        if(error == nil) {
            MKRoute *route = [response.routes firstObject];
            //CLLocationCoordinate2D locations[route.steps.count];
            //for(int i = 0; i < route.steps.count; i++)
              //  locations[i] = (route.steps[i]).polyline.coordinate;
            //polyline = [MKPolyline polylineWithCoordinates:locations count:route.steps.count];
            [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
            [self.mapView setNeedsDisplay];
        }
        else
            NSLog(@"error - %@",error.localizedFailureReason);
    }];
    

}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {

    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.strokeColor = [UIColor greenColor];
    render.lineWidth = 4.0;
    return render;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource Methods -

- (NSInteger)tableView:(UITableView *)tableView2 numberOfRowsInSection:(NSInteger)section {
    if(tableView2 == locationTableView)
        return locArray.count;
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(tableView == locationTableView) return 40;
    
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView2 == locationTableView){
        UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
        }
        GMSAutocompletePrediction *result = [locArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:result.attributedPrimaryText.string];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [cell.textLabel setTextColor:kPrimaryBlackColor];
        [cell.detailTextLabel setText:result.attributedSecondaryText.string];
        [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [cell.detailTextLabel setTextColor:[kPrimaryBlackColor colorWithAlphaComponent:0.5]];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    else
    {
        NSString *cellIdentifier = @"profileCell";
        ProfileCell *cell = (ProfileCell *)[tableView2 dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [cell.valueField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [cell.valueField setTag:indexPath.row];
        [cell.valueField setDelegate:self];
        [cell.nameLbl setText:items[indexPath.row]];
        
        return cell;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(tableView2 == locationTableView)
    {
        GMSAutocompletePrediction *result = [locArray objectAtIndex:indexPath.row];
        
        [[GMSPlacesClient sharedClient] lookUpPlaceID:result.placeID callback:^(GMSPlace *place, NSError *error) {
                        if (error != nil) {
                            NSLog(@"Place Details error %@", [error localizedDescription]);
                            return;
                        }
            
                        if (place != nil) {
                            NSLog(@"place lat - %.2f\nplace long - %.2f",place.coordinate.latitude, place.coordinate.longitude);
                            NSString *city = @"";
                            NSString *country = @"";
                            for(GMSAddressComponent *comp in place.addressComponents)
                            {
                                if([comp.type isEqualToString:@"locality"])
                                    city = comp.name;
                                else if([comp.type isEqualToString:@"country"])
                                    country = comp.name;
                                NSLog(@"Place component name %@\ntype %@", comp.name, comp.type);
                            }
                            
                            ProfileCell *cell = ((ProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:tableView2.tag inSection:0]]);
                            if(tableView2.tag == 0){
                                sourceCoord = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude);
                            }
                            else
                                destinationCoord = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude);
                            ;
                            [cell.valueField setText:result.attributedFullText.string];
                            [cell.valueField resignFirstResponder];

                        } else {
                            NSLog(@"No place details for %@", place.placeID);
                        }
                    }];
    }
    else {
        [self addLocationViewForRow:(indexPath.row)];
    }
    [tableView2 deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma - Location Methods -

- (void)getLocationFromGooglePlacesWithText:(UITextField *)textField
{
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
    CLLocationCoordinate2D locBounds1 = CLLocationCoordinate2DMake(8.4, 68.97);
    CLLocationCoordinate2D locBounds2 = CLLocationCoordinate2DMake(37.6, 97.25);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate: locBounds1 coordinate:locBounds2];
    [[GMSPlacesClient sharedClient] autocompleteQuery:textField.text
                                               bounds:bounds
                                               filter:filter
                                             callback:^(NSArray *results, NSError *error) {
                                                 if (error != nil) {
                                                     NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                                     return;
                                                 }
                                                 locArray = [NSArray arrayWithArray:results];
                                                 CGRect frame = locationView.frame;
                                                 frame.size.height = locArray.count * 40;
                                                 [locationView setFrame:frame];
                                                 frame = locationTableView.frame;
                                                 frame.size.height = locArray.count * 40;
                                                 [locationTableView setFrame:frame];
                                                 [locationTableView reloadData];
                                                 
                                                 for (GMSAutocompletePrediction* result in results) {
                                                     NSLog(@"Full %@\n Primary '%@'\n secondary '%@'", result.attributedFullText.string, result.attributedPrimaryText.string, result.attributedSecondaryText);
                                                 }
                                             }];
    
}

- (void)addLocationViewForRow:(NSUInteger)row {
    CGRect frame = [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]] frame];
    locationView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 75 + self.navigationController.navigationBar.bounds.size.height + 20, frame.size.width, 0)];
    [locationView setBackgroundColor:kSecondaryWhiteColor];
    [locationView setClipsToBounds:YES];
    [self.view addSubview:locationView];
    
    locationTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width, 0)];
    [locationTableView setDelegate:self];
    [locationTableView setDataSource:self];
    [locationTableView setScrollEnabled:NO];
    [locationTableView setTag:row];
    [locationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [locationTableView setBackgroundColor:[UIColor clearColor]];
    [locationView addSubview:locationTableView];
}

- (void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate Methods -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self addLocationViewForRow:textField.tag];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(getLocationFromGooglePlacesWithText:) withObject:textField afterDelay:0.5];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [locationView removeFromSuperview];
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
