//
//  LBJPViewController.h
//  SimpleGrocery
//
//  Created by X Code User on 7/21/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBJPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *manufacturerTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *caliberTextField;
@property (weak, nonatomic) IBOutlet UITextField *rateOfFireTextField;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

- (IBAction)cancelAddItem:(id)sender;
- (IBAction)saveNewItem:(id)sender;
@end
