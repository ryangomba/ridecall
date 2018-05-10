//  Copyright (c) 2013-Present Ryan Gomba. All rights reserved.

#import "RGUser.h"

@implementation RGUser

#pragma mark -
#pragma mark NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %@ (%d)>",
            NSStringFromClass(self.class),
            self.username,
            self.pk];
}


#pragma mark -
#pragma mark Updates

- (void)updateWithDictionary:(NSDictionary *)dict {
    [super updateWithDictionary:dict];
    
    NSString *username = [dict objectForKey:@"username"];
    [self setUsername:username];
    
    NSString *fullName = [dict objectForKey:@"fullName"];
    [self setFullName:fullName];
    
    NSString *bio = [dict objectForKey:@"bio"];
    [self setBio:bio];
    
    NSString *avatarURLString = [dict objectForKey:@"avatar_url"];
    NSURL *avatarURL = [NSURL URLWithString:avatarURLString];
    [self setAvatarURL:avatarURL];
}


#pragma mark -
#pragma mark Dictionary

- (NSDictionary *)asDictionary {
    return @{
        @"pk": @(self.pk),
        @"username": self.username,
        @"fullName": self.fullName ?: @"",
        @"bio": self.bio ?: @"",
        @"avatar_url": self.avatarURL.absoluteString ?: @"",
    };
}

@end
