//
//  MeetUp.m
//  MeetUp
//
//  Created by Taylor Wright-Sanson on 10/13/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "MeetUp.h"

@implementation MeetUp

-(instancetype)initWithDictionary:(NSDictionary *)eventDictionary
{
    self = [super init];
    if (self)
    {
        self.name              = eventDictionary[@"name"];
        self.meetUpDescription = eventDictionary[@"description"];
        self.hostName          = eventDictionary[@"group"][@"name"];
        self.address           = eventDictionary[@"venue"][@"address_1"];
        self.rsvpCount         = [[eventDictionary objectForKey:@"yes_rsvp_count"] integerValue];
        self.url               = [NSURL URLWithString:eventDictionary[@"event_url"]];
        self.groupID           = eventDictionary[@"group"][@"id"];
    }
    return self;
}

@end
