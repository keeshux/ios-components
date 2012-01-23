//
//  VC_KSKeyboardScroller.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/23/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSKeyboardScroller.h"

@interface VC_KSKeyboardScroller : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) NSMutableArray *fields; // of UITextField
@property (nonatomic, retain) KSKeyboardScroller *scroller;

@end
