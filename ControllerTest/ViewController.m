//
//  ViewController.m
//  ControllerTest
//
//  Created by Elviss Strazdins on 10.01.2014.
//  Copyright (c) 2014 Elviss. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)log:(NSString*)text
{
	_textView.text = [NSString stringWithFormat:@"%@%@\n", _textView.text, text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self log: @"Started"];
	
	[self initGameController];
}

- (void)handleConnected:(NSNotification *)note
{
	[self log: @"Connected"];
	
	[self setUpDevices];
}

- (void)setUpDevices
{
	NSArray* controllers = GCController.controllers;
	
	//search for the first attached controller
	for (GCController* controller in controllers)
	{
		[self log: [NSString stringWithFormat: @"%@ (%d)", controller.vendorName, controller.attachedToDevice]];
		
		if (controller.attachedToDevice)
		{
			controller.gamepad.dpad.valueChangedHandler = ^(GCControllerDirectionPad* dpad, float xValue, float yValue) {
				
				_dPadView.text = [NSString stringWithFormat: @"D pad: %f, %f", xValue, yValue];
			};
			
			controller.gamepad.buttonA.valueChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
				
				_aButtonView.text = [NSString stringWithFormat: @"A: %f, %d", value, pressed];
			};
			
			if (controller.extendedGamepad)
			{
				controller.extendedGamepad.leftThumbstick.valueChangedHandler = ^(GCControllerDirectionPad* dpad, float xValue, float yValue) {
					_dPadView.text = [NSString stringWithFormat: @"Left thumbstick: %f, %f", xValue, yValue];
				};
			}
			
			
			break;
		}
	}
}

- (void)handleDisconnected:(NSNotification *)note
{
	[self log: @"Disconnected"];
}

- (void)initGameController
{
	[self log: @"Searching for devices"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleConnected:)
												 name:GCControllerDidConnectNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleDisconnected:)
												 name:GCControllerDidDisconnectNotification
											   object:nil];
	
	[GCController startWirelessControllerDiscoveryWithCompletionHandler:
	 ^(void){ [self log:@"Disconvery finished"]; }];
	
	[self setUpDevices];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
