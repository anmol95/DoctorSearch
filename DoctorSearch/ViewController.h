//
//  ViewController.h
//  DoctorSearch
//
//  Created by practo on 19/01/16.
//  Copyright © 2016 practo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"

@interface ViewController : UIViewController <NSURLSessionDataDelegate, CLLocationManagerDelegate>
{
    NSMutableData *response_data;
}


@end

