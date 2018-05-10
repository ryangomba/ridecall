//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGModel.h"

#import "RGUser.h"
#import "RGComment.h"
#import "RGLocation.h"
#import "RGAttendee.h"

typedef enum {
    RGRideStatusPending = 0,
    RGRideStatusFinished = 1,
    RGRideStatusCanceled = 2,
} RGRideStatus;

static NSString * const kRGRideUpdated = @"ride-updated";

@interface RGRide : RGModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, assign) RGRideStatus status;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSDate *updated;

@property (nonatomic, strong) RGLocation *location;
@property (nonatomic, strong) RGUser *caller;
@property (nonatomic, strong) NSMutableSet *attendees;
@property (nonatomic, strong) NSArray *comments;

@property (nonatomic, readonly) BOOL isOwnedByCurrentUser;
@property (nonatomic, assign) CGFloat currentUserCommitment;

- (void)addComment:(RGComment *)comment;
- (void)removeComment:(RGComment *)comment;

@end
