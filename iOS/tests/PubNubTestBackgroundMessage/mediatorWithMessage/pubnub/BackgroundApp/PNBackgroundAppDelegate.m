//
//  PNBackgroundAppDelegate.m
//  pubnub
//
//  Created by Valentin Tuller on 9/24/13.
//  Copyright (c) 2013 PubNub Inc. All rights reserved.
//

#import "PNBackgroundAppDelegate.h"
#import "PubNub.h"

@implementation PNBackgroundAppDelegate

#pragma mark - UIApplication delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Configure application window and its content
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];


	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: [[UITableViewController alloc] init]];
	self.window.rootViewController = navController;
	navController.topViewController.navigationItem.title = @"Mediator";


    [self initializePubNubClient];

	[PubNub clientIdentifier];
//	[self connect];


    return YES;
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSLog(@"applicationWillEnterForeground");
}

- (void)initializePubNubClient {

    [PubNub setDelegate:self];

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter addObserver:self
						   selector:@selector(handleClientConnectionStateChange:)
							   name:kPNClientDidConnectToOriginNotification
							 object:nil];
	[notificationCenter addObserver:self
						   selector:@selector(handleClientConnectionStateChange:)
							   name:kPNClientDidDisconnectFromOriginNotification
							 object:nil];
	[notificationCenter addObserver:self
						   selector:@selector(handleClientConnectionStateChange:)
							   name:kPNClientConnectionDidFailWithErrorNotification
							 object:nil];

    // Subscribe for client connection state change (observe when client will be disconnected)
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self
                                                        withCallbackBlock:^(NSString *origin,
                                                                            BOOL connected,
                                                                            PNError *error) {

															if (!connected && error) {

																PNLog(PNLogGeneralLevel, self, @"#2 PubNub client was unable to connect because of error: %@",
																	  [error localizedDescription],
																	  [error localizedFailureReason]);
															}
														}];


    // Subscribe application delegate on subscription updates (events when client subscribe on some channel)
    __pn_desired_weak __typeof__(self) weakSelf = self;
    [[PNObservationCenter defaultCenter] addClientChannelSubscriptionStateObserver:weakSelf
                                                                 withCallbackBlock:^(PNSubscriptionProcessState state,
                                                                                     NSArray *channels,
                                                                                     PNError *subscriptionError) {

																	 switch (state) {

																		 case PNSubscriptionProcessNotSubscribedState:

																			 PNLog(PNLogGeneralLevel, weakSelf,
																				   @"{BLOCK-P} PubNub client subscription failed with error: %@",
																				   subscriptionError);
																			 break;

																		 case PNSubscriptionProcessSubscribedState:

																			 PNLog(PNLogGeneralLevel, weakSelf,
																				   @"{BLOCK-P} PubNub client subscribed on channels: %@",
																				   channels);
																			 break;

																		 case PNSubscriptionProcessWillRestoreState:

																			 PNLog(PNLogGeneralLevel, weakSelf,
																				   @"{BLOCK-P} PubNub client will restore subscribed on channels: %@",
																				   channels);
																			 break;

																		 case PNSubscriptionProcessRestoredState:

																			 PNLog(PNLogGeneralLevel, weakSelf,
																				   @"{BLOCK-P} PubNub client restores subscribed on channels: %@",
																				   channels);
																			 break;
																	 }
																 }];

    // Subscribe on message arrival events with block
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:weakSelf
                                                         withBlock:^(PNMessage *message) {

															 PNLog(PNLogGeneralLevel, weakSelf, @"{BLOCK-P} PubNubc client received new message: %@",
																   message);
														 }];

    // Subscribe on presence event arrival events with block
    [[PNObservationCenter defaultCenter] addPresenceEventObserver:weakSelf
                                                        withBlock:^(PNPresenceEvent *presenceEvent) {

                                                            PNLog(PNLogGeneralLevel, weakSelf, @"{BLOCK-P} PubNubc client received new event: %@",
																  presenceEvent);
                                                        }];
}

- (void)connect {
	NSLog(@"!!! connect");
    [PubNub setConfiguration:[PNConfiguration defaultConfiguration]];
    [PubNub connectWithSuccessBlock:^(NSString *origin) {
		NSLog(@"!!! connected");
		pnChannel = [PNChannel channelWithName: [NSString stringWithFormat: @"mediatorWithMessage"]];

		[PubNub subscribeOnChannels: @[pnChannel]
		withCompletionHandlingBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *subscriptionError)
		 {
			NSLog(@"!!! subscribed");
			 [self sendMessage];
		 }];

    }
                         errorBlock:^(PNError *connectionError) {
	 }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	NSLog(@"openURL %@, %@, %@", url, sourceApplication, annotation);
<<<<<<< HEAD
	if( pnChannel == nil ) {
		NSLog(@"!!! connect from application: openURL: ");
=======
	countNewMessage = 0;
	countSendMessage = 0;
	if( pnChannel == nil )
>>>>>>> develop
		[self connect];
	}
	else {
		NSLog(@"!!! perform sendMessage");
		[self performSelector: @selector(sendMessage) withObject: nil afterDelay: 15];
	}
	return YES;
}

-(void)sendMessage {
	NSLog(@"!!! sendMessage");
	[PubNub sendMessage:[NSString stringWithFormat: @"mediatorWithMessage, %@", [NSDate date]] toChannel:pnChannel compressed: NO
<<<<<<< HEAD
	withCompletionBlock:^(PNMessageState messageSendingState, id data) {
		NSLog(@"!!! sendMessage %d, %@", messageSendingState, data);
		if( messageSendingState == PNMessageSent ) {
			NSLog(@"!!! performSelector openUrl");
			 [self performSelector: @selector(openUrl) withObject: nil afterDelay: 20.0];
		}
=======
	withCompletionBlock:^(PNMessageState messageSendingState, id data)
	 {
		 if( messageSendingState == PNMessageSent ) {
			 countSendMessage++;
			 [self performSelector: @selector(openUrl) withObject: nil afterDelay: 20.0];
		 }
>>>>>>> develop
		 if( messageSendingState == PNMessageSendingError ) {
			 NSLog(@"PNMessageSendingError %@", data);
			 [self performSelector: @selector(errorSelectorMessage)];
		 }
	 }];
}

-(void)openUrl {
	NSLog(@"\ncountSendMessage %d\ncountNewMessage %d", countSendMessage, countNewMessage);
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: [NSString stringWithFormat: @"%@://", @"pubNubTestBackgroundMessage"]]];
}

- (BOOL)shouldRunClientInBackground {
	return NO;
}

- (NSNumber *)shouldRestoreSubscriptionFromLastTimeToken {
    return @(NO);
}

- (void)handleClientConnectionStateChange:(NSNotification *)notification {

    // Default field values
    BOOL connected = YES;
    PNError *connectionError = nil;
    NSString *origin = @"";

    if([notification.name isEqualToString:kPNClientDidConnectToOriginNotification] ||
       [notification.name isEqualToString:kPNClientDidDisconnectFromOriginNotification]) {

        origin = (NSString *)notification.userInfo;
        connected = [notification.name isEqualToString:kPNClientDidConnectToOriginNotification];
    }
    else if([notification.name isEqualToString:kPNClientConnectionDidFailWithErrorNotification]) {

        connected = NO;
        connectionError = (PNError *)notification.userInfo;
    }

    // Retrieving list of observers (including one time and persistent observers)
}

- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
    NSLog( @"PubNub client received message: %@", message);
	NSString *string = [NSString stringWithFormat: @"%@", message.message];
	if( [string rangeOfString: @"mediatorWithMessage"].location != NSNotFound )
		countNewMessage++;
}


@end
