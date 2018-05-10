//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGUser.h"

#define CURRENT_USER [RGAuthManager sharedAuthManager].currentUser

@interface RGAuthManager : NSObject

@property (nonatomic, strong, readonly) RGUser *currentUser;

+ (instancetype)sharedAuthManager;

- (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
                  completion:(RGRequestFailureHandler)completion;

- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(RGRequestFailureHandler)completion;

- (void)logOut;

@end
