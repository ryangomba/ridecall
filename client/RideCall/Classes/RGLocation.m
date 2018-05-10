//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGLocation.h"

@implementation RGLocation

#pragma mark -
#pragma mark NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %@ (%d)>",
            NSStringFromClass(self.class),
            self.name,
            self.pk];
}


#pragma mark -
#pragma mark Updates

- (void)updateWithDictionary:(NSDictionary *)dict {
    [super updateWithDictionary:dict];
    
    NSString *name = [dict objectForKey:@"name"];
    [self setName:name];
    
    NSArray *coordinatesArray = [dict objectForKey:@"coordinates"];
    CLLocationDegrees latitude = [coordinatesArray[0] doubleValue];
    CLLocationDegrees longitude = [coordinatesArray[1] doubleValue];
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
    [self setCoordinates:coordinates];
}

@end
