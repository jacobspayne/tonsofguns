//
//  LBJPGunDetailsViewController.h
//  SimpleGrocery
//
//  Created by X Code User on 7/23/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LBJPGunDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *caliberLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateOfFireLabel;
@property (strong, nonatomic) PFObject *parseObject;

@end
