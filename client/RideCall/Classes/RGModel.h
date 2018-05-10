//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

@interface RGModel : NSObject

@property (nonatomic, assign) NSUInteger pk;

- (id)initWithDictionary:(NSDictionary *)dict;
- (void)updateWithDictionary:(NSDictionary *)dict;

@end
