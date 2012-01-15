//
//  VC_NSMutableArray_Shuffling.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/15/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSMutableArray_Shuffling : UIViewController

@property (nonatomic, retain) NSMutableArray *testData;
@property (nonatomic, retain) UILabel *beforeLabel;
@property (nonatomic, retain) UIButton *shuffleButton;
@property (nonatomic, retain) UILabel *afterLabel;

- (void) shuffleData:(id)sender;

@end
