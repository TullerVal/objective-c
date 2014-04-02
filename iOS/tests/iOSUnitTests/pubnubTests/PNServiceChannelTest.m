//
//  PNServiceChannelTest.m
//  UnitTestSample
//
//  Created by Vadim Osovets on 5/5/13.
//  Copyright (c) 2013 Micro-B. All rights reserved.
//

#import "PNServiceChannelTest.h"
#import "PNServiceChannel.h"

#import "PNMessage.h"
#import "PNChannel.h"
#import "PNMessagePostRequest.h"

#import "NSData+PNAdditions.h"

#import <OCMock/OCMock.h>

@interface PNMessage ()
@property (nonatomic, assign, getter = shouldCompressMessage) BOOL compressMessage;
@end

@interface PNServiceChannel ()
+ (PNMessage *)sendMessage:(id)message toChannel:(PNChannel *)channel;
@end

@interface PNMessage (test)

+ (PNMessage *)messageWithObject:(id)object forChannel:(PNChannel *)channel compressed:(BOOL)shouldCompressMessage error:(PNError **)error;
+ (PNMessage *)messageFromServiceResponse:(id)messageBody onChannel:(PNChannel *)channel atDate:(PNDate *)messagePostDate;
- (id)initWithObject:(id)object forChannel:(PNChannel *)channel compressed:(BOOL)shouldCompressMessage;
@property (nonatomic, assign, getter = shouldCompressMessage) BOOL compressMessage;

@end


@implementation PNServiceChannelTest

- (void)setUp
{
    [super setUp];
    
    NSLog(@"setUp: %@", self.name);
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

#pragma mark - States tests

- (void)testServiceChannelWithDelegate {
    /*
     Test scenario:
      - initService with some delegate object
      - check service is ready to work
     */
    
    PNServiceChannel *channel = [PNServiceChannel serviceChannelWithDelegate:nil];
    STAssertNotNil(channel, @"Channel is not available");
}

- (void)testInitWithTypeAndDelegate {
    /*
     Test scenario:
     - initService with type: service and some delegate object
     - check service is ready to work
     
     - initService with type: messaging and some delegate object
     - check service is ready to work
     */
    
    PNServiceChannel *channel = [[PNServiceChannel alloc] initWithType:PNConnectionChannelService andDelegate:nil];
    STAssertNotNil(channel, @"Channel is not available");
    
    channel = [[PNServiceChannel alloc] initWithType:PNConnectionChannelMessaging andDelegate:nil];
    STAssertNotNil(channel, @"Channel is not available");
}


@end
