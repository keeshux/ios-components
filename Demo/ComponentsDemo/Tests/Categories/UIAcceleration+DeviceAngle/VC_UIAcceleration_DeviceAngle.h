//
//  VC_UIAcceleration_DeviceAngle.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/15/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_UIAcceleration_DeviceAngle : UIViewController<UIAccelerometerDelegate>

@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (nonatomic, retain) UILabel *angleLabel;

@end
