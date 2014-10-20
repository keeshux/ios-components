//
//  VC_KSGridView.h
//  Components
//
//  Created by Davide De Rosa on 10/17/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSGridView.h"

@interface VC_KSGridView : LegacyViewController <KSGridViewDataSource, KSGridViewDelegate> {
    BOOL alternative;
}

@property (nonatomic, strong) KSGridView *grid;

@end
