//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGModel.h"

@implementation RGModel

#pragma mark -
#pragma mark NSObject

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self updateWithDictionary:dict];
    }
    return self;
}


#pragma mark -
#pragma mark Public

- (void)updateWithDictionary:(NSDictionary *)dict {
    NSInteger pk = [[dict objectForKey:@"pk"] integerValue];
    [self setPk:pk];
}


#pragma mark -
#pragma mark Equality

- (BOOL)isEqual:(id)object {
    return ([object isKindOfClass:self.class] &&
            [object pk] == self.pk);
}

- (NSUInteger)hash {
    return self.pk;
}

@end
