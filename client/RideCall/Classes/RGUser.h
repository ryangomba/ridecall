//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGModel.h"

@interface RGUser : RGModel

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, copy) NSString *bio;

- (NSDictionary *)asDictionary;

@end
