//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGComment.h"

#import "NSDate+Timestamps.h"

@implementation RGComment

#pragma mark -
#pragma mark NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %@ (%d)>",
            NSStringFromClass(self.class),
            self.text,
            self.pk];
}


#pragma mark -
#pragma mark Updates

- (void)updateWithDictionary:(NSDictionary *)dict {
    [super updateWithDictionary:dict];
    
    NSString *text = [dict objectForKey:@"text"];
    [self setText:text];
    
    NSNumber *timestampValue = [dict objectForKey:@"created"];
    NSDate *created = [NSDate dateFromTimestamp:timestampValue];
    [self setCreated:created];
    
    // relationships
    
    NSDictionary *userDict = [dict objectForKey:@"author"];
    RGUser *user = [[RGUser alloc] initWithDictionary:userDict];
    [self setUser:user];
}

@end
