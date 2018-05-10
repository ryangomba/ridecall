//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGRide.h"

#import "NSDate+Timestamps.h"

@implementation RGRide

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
    
    NSString *description = [dict objectForKey:@"description"];
    [self setDetails:description];
    
    NSString *style = [dict objectForKey:@"style"];
    [self setStyle:style];
    
    NSNumber *statusValue = [dict objectForKey:@"status"];
    RGRideStatus status = [statusValue unsignedIntegerValue];
    [self setStatus:status];

    NSNumber *startTimeValue = [dict objectForKey:@"start_time"];
    NSDate *startTime = [NSDate dateFromTimestamp:startTimeValue];
    [self setStartTime:startTime];
    
    NSNumber *createdValue = [dict objectForKey:@"created"];
    NSDate *created = [NSDate dateFromTimestamp:createdValue];
    [self setCreated:created];
    
    NSNumber *updatedValue = [dict objectForKey:@"created"];
    NSDate *updated = [NSDate dateFromTimestamp:updatedValue];
    [self setUpdated:updated];
    
    // relationships
    
    NSDictionary *locationDict = [dict objectForKey:@"location"];
    RGLocation *location = [[RGLocation alloc] initWithDictionary:locationDict];
    [self setLocation:location];
    
    NSDictionary *callerDict = [dict objectForKey:@"caller"];
    RGUser *caller = [[RGUser alloc] initWithDictionary:callerDict];
    [self setCaller:caller];
    
    NSArray *attendeeDicts = [dict objectForKey:@"attendees"];
    NSMutableSet *attendees = [NSMutableSet setWithCapacity:[attendeeDicts count]];
    for (NSDictionary *attendeeDict in attendeeDicts) {
        RGAttendee *attendee = [[RGAttendee alloc] initWithDictionary:attendeeDict];
        [attendees addObject:attendee];
    }
    [self setAttendees:attendees];
    
    NSArray *commentDicts = [dict objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:[commentDicts count]];
    for (NSDictionary *commentDict in commentDicts) {
        RGComment *comment = [[RGComment alloc] initWithDictionary:commentDict];
        [comments addObject:comment];
    }
    [self setComments:comments];
}


#pragma mark -
#pragma mark Public

- (BOOL)isOwnedByCurrentUser {
    return [self.caller isEqual:CURRENT_USER];
}

- (void)addComment:(RGComment *)comment {
    NSMutableArray *comments = [self.comments mutableCopy];
    [comments addObject:comment];
    [self setComments:comments];
    
    [DNC postNotificationName:kRGRideUpdated object:self];
}

- (void)removeComment:(RGComment *)comment {
    NSMutableArray *comments = [self.comments mutableCopy];
    [comments removeObject:comment];
    [self setComments:comments];
    
    [DNC postNotificationName:kRGRideUpdated object:self];
}

- (CGFloat)currentUserCommitment {
    for (RGAttendee *attendee in self.attendees) {
        if ([attendee.user isEqual:CURRENT_USER]) {
            return attendee.probability;
        }
    }
    return 0.0;
}

- (void)setCurrentUserCommitment:(CGFloat)currentUserCommitment {
    RGAttendee *currentUserAttendee = [[RGAttendee alloc] init];
    [currentUserAttendee setUser:CURRENT_USER];
    [currentUserAttendee setProbability:currentUserCommitment];

    [self.attendees removeObject:currentUserAttendee];
    
    if (currentUserCommitment > 0.0) {
        [self.attendees addObject:currentUserAttendee];
    }
    
    [DNC postNotificationName:kRGRideUpdated object:self];
}

@end
