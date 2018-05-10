//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGModel.h"
#import "RGUser.h"

@interface RGComment : RGModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSDate *created;

@property (nonatomic, strong) RGUser *user;

@end
