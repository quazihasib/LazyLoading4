//
//  ViewController.h
//  LazyLoading4
//
//  Created by Quazi Ridwan Hasib on 8/03/2016.
//  Copyright © 2016 Quazi Ridwan Hasib. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

// the main data model for our UITableView
@property (nonatomic, strong) NSArray *entries;

@end

