//
//  MeetUp.h
//  MeetUp
//
//  Created by Taylor Wright-Sanson on 10/13/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetUp : NSObject

@property NSString *name;
@property NSInteger rsvpCount;
@property NSString *meetUpDescription;
@property NSString *hostName;
@property NSString *address;
@property NSURL *url;

-(instancetype)initWithDictionary: (NSDictionary *)eventDictionary;

@end
