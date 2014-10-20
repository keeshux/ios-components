//
//  VC_NSMutableArray_Shuffling.h
//  Components
//
//  Created by Davide De Rosa on 1/15/12.
//  Copyright (c) 2012 Davide De Rosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSMutableArray_Shuffling : LegacyViewController

@property (nonatomic, strong) NSMutableArray *testData;
@property (nonatomic, strong) UILabel *beforeLabel;
@property (nonatomic, strong) UIButton *shuffleButton;
@property (nonatomic, strong) UILabel *afterLabel;

- (void) shuffleData:(id)sender;

@end
