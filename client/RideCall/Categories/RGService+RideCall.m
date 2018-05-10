//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGService+RideCall.h"

@implementation RGService (RideCall)

- (void)startAPIRequest:(RGRequest *)request responseHandler:(RGAPIRequestHandler)responseHandler {
    [self startJSONRequest:request responseHandler:
     ^(RGRequest *completedRequest, id responseObject, RGRequestError *error) {
         if (error) {
             NSString *errorString = [responseObject objectForKey:@"error"];
             RGRequestError *APIError = [RGRequestError errorWithStatusCode:error.statusCode message:errorString];
             responseHandler(nil, APIError);
         } else {
             responseHandler(responseObject, nil);
         }
    }];
}

@end
