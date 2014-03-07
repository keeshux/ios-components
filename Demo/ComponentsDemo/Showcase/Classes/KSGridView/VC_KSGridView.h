//
//  VC_KSGridView.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 10/17/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSGridView.h"

@interface VC_KSGridView : UIViewController <KSGridViewDataSource, KSGridViewDelegate> {
    BOOL alternative;
}

@property (nonatomic, strong) KSGridView *grid;

@end
