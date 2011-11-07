//
//  ViewController.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 11/7/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
}

@property (nonatomic, retain) NSMutableArray *menu;

@end
