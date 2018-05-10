//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGAuthManager.h"

static NSString * const kRGCurrentUserKey = @"current-user";
static NSString * const kRGSessionCookieKey = @"sessionid";

@interface RGAuthManager ()

@property (nonatomic, strong, readwrite) RGUser *currentUser;

@end


@implementation RGAuthManager

#pragma mark -
#pragma mark NSObject

- (id)init {
    if (self = [super init]) {
        [self restoreUserInfo];
    }
    return self;
}

+ (instancetype)sharedAuthManager {
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    })
}


#pragma mark -
#pragma mark Public

- (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
                  completion:(RGRequestFailureHandler)completion {

    // TODO insecure
    NSDictionary *parameters = @{
        @"username": username,
        @"password": password,
    };
    
    NSURL *url = [NSURL URLWithAPIPath:@"/auth/register/"];
    RGRequest *request = [RGPostRequest requestWithURL:url parameters:parameters files:nil];
    [[RGService sharedService] startAPIRequest:request responseHandler:
     ^(NSDictionary *responseDict, RGRequestError *error) {
         if (error) {
             NSLog(@"ERROR: %@", error);
         } else {
             [self doLogInWithResponseDict:responseDict];
         }
         
         if (completion) {
             completion(error);
         }
     }];
}

- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(RGRequestFailureHandler)completion {
    
    // TODO insecure
    NSDictionary *parameters = @{
        @"username": username,
        @"password": password,
    };
    
    NSURL *url = [NSURL URLWithAPIPath:@"/auth/login/"];
    RGRequest *request = [RGPostRequest requestWithURL:url parameters:parameters files:nil];
    [[RGService sharedService] startAPIRequest:request responseHandler:
     ^(NSDictionary *responseDict, RGRequestError *error) {
         if (error) {
             NSLog(@"ERROR: %@", error);
         } else {
             [self doLogInWithResponseDict:responseDict];
         }
         
         if (completion) {
             completion(error);
         }
    }];
}

- (void)logOut {
    [self clearUserInfo];
    
    NSURL *url = [NSURL URLWithAPIPath:@"/auth/logout/"];
    RGRequest *request = [RGPostRequest requestWithURL:url parameters:nil files:nil];
    [[RGService sharedService] startAPIRequest:request responseHandler:
     ^(NSDictionary *responseDict, RGRequestError *error) {
         // noop
    }];
}


#pragma mark -
#pragma mark Login

- (void)doLogInWithResponseDict:(NSDictionary *)responseDict {
    NSDictionary *userDict = [responseDict objectForKey:@"user"];
    RGUser *user = [[RGUser alloc] initWithDictionary:userDict];
    [self setCurrentUser:user];
    [self saveUserInfo];
}


#pragma mark -
#pragma mark Saving

- (void)saveUserInfo {
    NSDictionary *userDict = [self.currentUser asDictionary];
    [SUD setObject:userDict forKey:kRGCurrentUserKey];
    
    for (NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        if ([cookie.name isEqualToString:kRGSessionCookieKey]) {
            [SUD setObject:cookie.properties forKey:kRGSessionCookieKey];
            break;
        }
    }
    
    [SUD synchronize];
}

- (void)clearUserInfo {
    [self setCurrentUser:nil];
    
    [SUD removeObjectForKey:kRGCurrentUserKey];
    [SUD removeObjectForKey:kRGSessionCookieKey];
    [SUD synchronize];
}

- (void)restoreUserInfo {
    NSDictionary *userDict = [SUD objectForKey:kRGCurrentUserKey];
    NSDictionary *cookieDict = [SUD objectForKey:kRGSessionCookieKey];
    
    if (!userDict || !cookieDict) {
        return;
    }
    
    RGUser *user = [[RGUser alloc] initWithDictionary:userDict];
    [self setCurrentUser:user];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDict];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

@end
