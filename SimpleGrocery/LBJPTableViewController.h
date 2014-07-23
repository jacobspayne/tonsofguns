//
//  LBJPTableViewController.h
//  SimpleGrocery
//
//  Created by X Code User on 7/21/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LBJPTableViewController : PFQueryTableViewController


@property (weak, nonatomic, readwrite) NSMutableArray *tableData;

@end
