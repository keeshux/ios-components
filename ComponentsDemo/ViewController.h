//
//  ViewController.h
//  Components
//
//  Created by Davide De Rosa on 11/7/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItem : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *categoryName;

+ (instancetype)itemWithClassName:(NSString *)className;
+ (instancetype)itemWithClassName:(NSString *)className categoryName:(NSString *)categoryName;
- (instancetype)initWithClassName:(NSString *)className;
- (instancetype)initWithClassName:(NSString *)className categoryName:(NSString *)categoryName;

- (NSString *)viewControllerClassName;
- (NSString *)title;

@end

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *menu;

@end
