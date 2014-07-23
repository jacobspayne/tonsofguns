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
    PFObject *object = [PFObject objectWithClassName:@"Gun"];
    [object setObject:_nicknameTextField.text forKey:@"nickname"];
    [object setObject:_typeTextField.text forKey:@"type"];
    [object setObject:_manufacturerTextField.text forKey:@"manufacturer"];
    [object setObject:_nameTextField.text forKey:@"name"];
    [object setObject:_caliberTextField.text forKey:@"caliber"];
    [object setObject:_rateOfFireTextField.text forKey:@"rate_of_fire"];
    
    // get the displayed file, upload it and save the gun after the upload was sucessful.
    NSData *imageData = UIImagePNGRepresentation(_pictureImageView.image);
    PFFile *imageFile = [PFFile fileWithName:@"gun.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [object setObject:imageFile forKey:@"picture"];
        [object saveInBackground];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
