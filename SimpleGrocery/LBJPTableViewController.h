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
-(void)loadParseImage:(PFObject *)parseObject forImageColumn:(NSString *)columnName withProgressBar:(UIProgressView *)progressBar andCompletionBlock:(void (^)(UIImage *imageFile, NSError *error))completionBlock;

@end
