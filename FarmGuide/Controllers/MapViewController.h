//
//  MapViewController.h
//  FarmGuide
//
//  Created by Swati Wadhera on 5/19/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate>
{
    NSArray *items;
    NSArray *locArray;
    
    UITableView *locationTableView;
    UIView *locationView;
    
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D sourceCoord;
    CLLocationCoordinate2D destinationCoord;
    
    MKPlacemark *sourcePlacemark;
    MKPlacemark *destinationPlacemark;
    
    MKPolyline *polyline;
    
    BOOL locClicked;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UITableView *tableView;

@end
