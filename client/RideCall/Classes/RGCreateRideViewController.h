//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGRide.h"

static NSString * const kRGRideAddedNotification = @"ride-added";
static NSString * const kRGRideCanceled = @"ride-canceled";

@interface RGCreateRideViewController : UIViewController

- (id)initWithRide:(RGRide *)ride;

@end
