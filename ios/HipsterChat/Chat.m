//
//  Chat.m
//  HipsterChat
//
//  Created by Thomas Bouldin on 11/4/13.
//  Copyright (c) 2013 Thomas Bouldin. All rights reserved.
//

#import "Chat.h"
#import <Parse/PFObject+Subclass.h>

@implementation Chat
@dynamic title;
@dynamic text;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Chat";
}
@end
