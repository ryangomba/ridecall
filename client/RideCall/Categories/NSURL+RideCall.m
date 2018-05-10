//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "NSURL+RideCall.h"

@implementation NSURL (RideCall)

+ (NSURL *)URLWithAPIPath:(NSString *)path {
//    NSString *hostPath = @"http://localhost:8000/api";
    NSString *hostPath = @"http://ridecall.herokuapp.com/api";
    NSString *fullPath = [hostPath stringByAppendingString:path];
    return [NSURL URLWithString:fullPath];
}

@end
