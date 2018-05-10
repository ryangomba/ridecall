//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

typedef void (^RGAPIRequestHandler)(NSDictionary *responseDict, RGRequestError *error);

@interface RGService (RideCall)

- (void)startAPIRequest:(RGRequest *)request responseHandler:(RGAPIRequestHandler)responseHandler;

@end
