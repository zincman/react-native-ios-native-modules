//
//  CallM.m
//  iosNativeModule
//
//  Created by Derek on 22/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(CalendarManager, NSObject)

RCT_EXTERN_METHOD(addEvent:(NSString *)name location:(NSString *)location date:(nonnull NSNumber *)date callback:(RCTResponseSenderBlock)callback);

@end
