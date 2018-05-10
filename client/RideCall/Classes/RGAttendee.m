//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGAttendee.h"

@implementation RGAttendee

#pragma mark -
#pragma mark NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %@ (+%.01f)>",
            NSStringFromClass(self.class),
            self.user,
            self.probability];
}


#pragma mark -
#pragma mark Updates

- (void)updateWithDictionary:(NSDictionary *)dict {
    [super updateWithDictionary:dict];
    
    NSDictionary *userDict = [dict objectForKey:@"user"];
    RGUser *user = [[RGUser alloc] initWithDictionary:userDict];
    [self setUser:user];
    
    NSNumber *probabilityValue = [dict objectForKey:@"probability"];
    CGFloat probability = [probabilityValue floatValue];
    [self setProbability:probability];
}


#pragma mark -
#pragma mark Equality

- (BOOL)isEqual:(id)object {
    return ([object isKindOfClass:self.class] &&
            [[object user] isEqual:self.user]);
}

- (NSUInteger)hash {
    return [self.user hash];
}

@end
