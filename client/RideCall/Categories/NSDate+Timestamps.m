//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "NSDate+Timestamps.h"

@implementation NSDate (Timestamps)

+ (NSDate *)dateFromTimestamp:(NSNumber *)timestampValue {
    NSTimeInterval timestamp = [timestampValue doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

@end
