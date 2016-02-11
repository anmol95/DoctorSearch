//
//  ViewController.m
//  DoctorSearch
//
//  Created by practo on 19/01/16.
//  Copyright © 2016 practo. All rights reserved.
//

#import "ViewController.h"
#import "DoctorViewController.h"

#define METRES_PER_MILES 55000

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController
NSDictionary *notesJSON;

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView.delegate = self;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *url = @"https://www-latest.practo.com/health/api/search?offset=0&city=Mumbai&location=Mumbai&mobile=true&query_type=speciality&query=Dentist&with_ad=true&ad_limit=2&location_type=city&limit=50&sort_by=practo_ranking&";
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.allowsCellularAccess = NO;
    
    [sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
    [sessionConfig setHTTPAdditionalHeaders: @{@"x-auth-token": @"3e46ff37f4cf95c92b90318b1f9e4cb1d7b9fdcc36e148e429c499674505d7d2"}];
    
    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        NSString *message = [[NSString alloc] initWithFormat:@"Succeeded! Received %ld bytes of data",[data length]];
        NSLog(message);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:@"Loading message" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                       }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (httpResp.statusCode == 200) {
            
            NSError *jsonError;
            
           // NSDictionary
            notesJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
          //  NSLog(@"%@", [notesJSON description]);
            unsigned long docArrSize = [[notesJSON objectForKey:@"doctors"] count];
            
            CLLocationCoordinate2D doctorLocation;
            
            for(unsigned long i = 0; i < docArrSize; i++) {
                //CLLocationCoordinate2D doctorLocation;
                doctorLocation.latitude = [[[[notesJSON objectForKey:@"doctors"] objectAtIndex:i] objectForKey:@"latitude"] doubleValue];
                doctorLocation.longitude =[[[[notesJSON objectForKey:@"doctors"] objectAtIndex:i] objectForKey:@"longitude"] doubleValue];
                
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = doctorLocation;
                point.title = [[[notesJSON objectForKey:@"doctors"] objectAtIndex:i] objectForKey:@"doctor_name"];
                point.subtitle = [[[notesJSON objectForKey:@"doctors"] objectAtIndex:i] objectForKey:@"clinic_name"];
            
                [self.mapView addAnnotation:point];
                
            }
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(doctorLocation, 0.5*METRES_PER_MILES, 0.5*METRES_PER_MILES);
            
            [_mapView setRegion:viewRegion animated:true];
            NSLog(@"%lu", docArrSize);
        }
    }];
    
    [dataTask resume];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segue1"])
    {
        DoctorViewController *dc = [segue destinationViewController];
        NSDictionary *doctorDict;
        for(int i = 0; i < [[notesJSON objectForKey:@"doctors"] count]; i++) {
            
            if([[[[notesJSON objectForKey:@"doctors"] objectAtIndex:i] objectForKey:@"doctor_name"] isEqualToString:sender]) {
            
                doctorDict = [[NSDictionary alloc] initWithDictionary:[[notesJSON objectForKey:@"doctors"] objectAtIndex:i]];
                dc.title = sender;
               break;
                
            }
        }
        //NSLog([doctorDict objectForKey:@"doctor_name"]);
        // Pass any objects to the view controller here, like...
        [dc setMyJSON:doctorDict];
    }
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
   
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        //annotation
        NSLog(@"Move pressed for %@",[annotation title]);
        NSString *title =[annotation title];
        /*DoctorViewController* doctorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorViewController"];
        [self.navigationController presentViewController: doctorViewController animated:YES completion: nil];
         */
        [self performSegueWithIdentifier:@"segue1" sender:title];

    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinTintColor = [UIColor blueColor];
            pinView.enabled = YES;
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, 32);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            pinView.rightCalloutAccessoryView = rightButton;
            
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
