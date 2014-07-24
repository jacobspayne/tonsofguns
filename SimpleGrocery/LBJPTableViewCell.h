//
//  LBJPTableViewCell.h
//  SimpleGrocery
//
//  Created by X Code User on 7/21/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LBJPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) PFObject *parseObject;

@end
