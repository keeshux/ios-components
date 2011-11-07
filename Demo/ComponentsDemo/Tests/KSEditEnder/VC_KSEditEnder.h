//
//  VC_KSEditEnder.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 11/6/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSEditEnder.h"

@interface VC_KSEditEnder : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) NSMutableArray *fields; // of UITextField
@property (nonatomic, retain) KSEditEnder *editEnder;

@end
