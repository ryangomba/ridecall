//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGModel.h"
#import "RGUser.h"

@interface RGAttendee : RGModel

@property (nonatomic, strong) RGUser *user;
@property (nonatomic, assign) CGFloat probability;

@end
