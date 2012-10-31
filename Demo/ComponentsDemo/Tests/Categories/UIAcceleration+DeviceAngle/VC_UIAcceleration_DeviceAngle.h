//
//  VC_UIAcceleration_DeviceAngle.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/15/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_UIAcceleration_DeviceAngle : UIViewController<UIAccelerometerDelegate>

@property (nonatomic, strong) UIAccelerometer *accelerometer;
@property (nonatomic, strong) UILabel *angleLabel;

@end
