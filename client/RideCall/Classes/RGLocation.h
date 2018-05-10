//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGModel.h"

#import <CoreLocation/CoreLocation.h>

@interface RGLocation : RGModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;

@end
