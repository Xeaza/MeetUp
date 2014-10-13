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
        self.name = [eventDictionary objectForKey:@"name"];
        self.meetUpDescription = [eventDictionary objectForKey:@"description"];
        self.hostName = [[eventDictionary objectForKey:@"group"] objectForKey:@"name"];
        self.address = [[eventDictionary objectForKey:@"venue"] objectForKey:@"address_1"];
        self.rsvpCount = [[eventDictionary objectForKey:@"yes_rsvp_count"] integerValue];
    }
    return self;
}

@end
