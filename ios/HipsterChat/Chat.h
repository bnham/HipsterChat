//
//  Chat.h
//  HipsterChat
//
//  Created by Thomas Bouldin on 11/4/13.
//  Copyright (c) 2013 Thomas Bouldin. All rights reserved.
//

#import <Parse/Parse.h>

@interface Chat : PFObject<PFSubclassing>
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *text;
+ (NSString*)parseClassName;
@end
