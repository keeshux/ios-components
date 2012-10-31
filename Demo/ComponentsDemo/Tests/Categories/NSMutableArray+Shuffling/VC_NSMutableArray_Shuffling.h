//
//  VC_NSMutableArray_Shuffling.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/15/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSMutableArray_Shuffling : UIViewController

@property (nonatomic, strong) NSMutableArray *testData;
@property (nonatomic, strong) UILabel *beforeLabel;
@property (nonatomic, strong) UIButton *shuffleButton;
@property (nonatomic, strong) UILabel *afterLabel;

- (void) shuffleData:(id)sender;

@end
