//
//  ViewController.m
//  MapView
//
//  Created by Chris on 8/4/15.
//  Copyright (c) 2015 chuppy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager requestWhenInUseAuthorization];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.logo.image = [UIImage imageNamed:@"apple-logo"];
    self.mapView.showsUserLocation = YES;
    self.annotations = [[NSMutableArray alloc] init];
    self.mapDidLoadForFirstTime = NO;
    
    self.webViewVC = [[webViewController alloc] initWithNibName:@"webViewController" bundle:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Hide navigation bar in mapView since it won't be needed
    self.navigationController.navigationBarHidden = YES;
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    // Create annotation for Turn to Tech
    MKPointAnnotation *turnToTech = [[MKPointAnnotation alloc] init];
    turnToTech.title = @"Turn to Tech";
    turnToTech.subtitle = @"I go here!";
    turnToTech.coordinate = CLLocationCoordinate2DMake(40.741655, -73.989980);
    [self.mapView addAnnotation:turnToTech];
    
    // Check if this is the first time mapView has loaded
    if (!self.mapDidLoadForFirstTime)
    {
        // Zoom on Turn To Tech. Without bool, the map will re-center to Turn to Tech each time the user scrolls to a new part of the map, recalling this method.
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(turnToTech.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
    }
    
    // Trip bool to YES
    self.mapDidLoadForFirstTime = YES;
}

-(IBAction)setMap:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex)
    {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

- (IBAction) pressShowRestaurants:(id)sender
{
    // Local search for restaurants in current region
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"restaurant";
    request.region = self.mapView.region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        // Handle results of search
        for (MKMapItem *item in response.mapItems)
        {
            // Get item's address from addressDictionary property of placemark
            NSString *itemAddress = [NSString stringWithFormat:@"%@, %@, %@ %@",
                                     [item.placemark.addressDictionary objectForKey:@"Street"],
                                     [item.placemark.addressDictionary objectForKey:@"City"],
                                     [item.placemark.addressDictionary objectForKey:@"State"],
                                     [item.placemark.addressDictionary objectForKey:@"ZIP"]];
            
            // Create annotation for item, matching pertinent properties between annos. and items
            customPointAnnotation *annotation = [[customPointAnnotation alloc] init];
            annotation.coordinate = item.placemark.coordinate;
            annotation.title = item.name;
            annotation.subtitle = item.phoneNumber;
            annotation.subtitle = itemAddress;
            annotation.url = item.url;
            
            [self.annotations addObject:annotation];
        }
        
        // Remove current annotations
        [self.mapView removeAnnotations:self.annotations];
        // Add new annotations
        [self.mapView addAnnotations:self.annotations];
    }];
}

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[customPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, 32);
            pinView.animatesDrop = YES;
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout. HAVE TO RESIZE
            //            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foodicon.png"]];
            //            pinView.leftCalloutAccessoryView = iconView;
            
        } else {
            pinView.annotation = annotation;
            
        }
        return pinView;
    }
    else
    {
        return nil;
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    customPointAnnotation *annotation = [view annotation];
    
    if ([annotation isKindOfClass:[customPointAnnotation class]])
    {
        self.webViewVC.url = annotation.url;
    }
    // Push the view controller.
    [self.navigationController pushViewController:self.webViewVC animated:YES];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Location: %f, %f",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
