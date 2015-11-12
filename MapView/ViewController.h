//
//  ViewController.h
//  MapView
//
//  Created by Chris on 8/4/15.
//  Copyright (c) 2015 chuppy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <WebKit/WebKit.h>
#import "webViewController.h"
#import "customPointAnnotation.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation>


@property(nonatomic,retain)IBOutlet MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) IBOutlet UIImageView *logo;
@property(nonatomic,strong) NSMutableArray *annotations;
@property BOOL mapDidLoadForFirstTime;

@property (nonatomic, strong) webViewController* webViewVC;



@end

