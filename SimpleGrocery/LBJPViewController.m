//
//  LBJPViewController.m
//  SimpleGrocery
//
//  Created by X Code User on 7/21/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import "LBJPViewController.h"
#import <Parse/Parse.h>

@interface LBJPViewController ()

@end

@implementation LBJPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAddItem:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveNewItem:(id)sender {
    PFObject *object = [PFObject objectWithClassName:@"GroceryListItem"];
    [object setObject:_itemTitle.text forKey:@"title"];
    NSNumber *checkedAsNumber = [NSNumber numberWithBool:FALSE];
    [object setValue:checkedAsNumber forKey:@"checked"];
    [object save];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
