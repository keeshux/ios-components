//
//  ViewController.h
//  Components
//
//  Created by Davide De Rosa on 11/7/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItem : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *categoryName;

+ (id) itemWithClassName:(NSString *)aClassName;
+ (id) itemWithClassName:(NSString *)aClassName categoryName:(NSString *)aCategoryName;
- (id) initWithClassName:(NSString *)aClassName;
- (id) initWithClassName:(NSString *)aClassName categoryName:(NSString *)aCategoryName;

- (NSString *) viewControllerClassName;
- (NSString *) title;

@end

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *menu;

@end
