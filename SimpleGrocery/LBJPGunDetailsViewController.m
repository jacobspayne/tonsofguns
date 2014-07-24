//
//  LBJPGunDetailsViewController.m
//  SimpleGrocery
//
//  Created by X Code User on 7/23/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import "LBJPGunDetailsViewController.h"
#import "LBJPViewController.h"
#import "TUSafariActivity.h"
#import "LBJPImageHelper.h"
#import <UIKit/UIKit.h>

@interface LBJPGunDetailsViewController ()

@end

@implementation LBJPGunDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *activity = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareMenu)];
    self.navigationItem.rightBarButtonItem = activity;
    
    _nicknameLabel.text = [_parseObject objectForKey:@"nickname"];
    _typeLabel.text = [_parseObject objectForKey:@"type"];
    _manufacturerLabel.text = [_parseObject objectForKey:@"manufacturer"];
    _nameLabel.text = [_parseObject objectForKey:@"name"];
    _caliberLabel.text = [_parseObject objectForKey:@"caliber"];
    _rateOfFireLabel.text = [_parseObject objectForKey:@"rate_of_fire"];

    [LBJPImageHelper loadParseImage:_parseObject forImageColumn:@"picture" andCompletionBlock:^(UIImage *imageAsImage, NSError *error){
        if (!error){
            _pictureImageView.image = imageAsImage;
        }}];

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)showShareMenu {
    NSString *unescapedName = [_parseObject objectForKey:@"name"];
    NSString *escapedName = [unescapedName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *imfdbIncompleteURL = @"http://www.imfdb.org/index.php?title=Special%3ASearch&profile=default&search=";
    NSLog(@"escapedString: %@", escapedName);
    
    NSString *imfdbSearchURL = [imfdbIncompleteURL stringByAppendingString:escapedName];
    NSURL *URL = [NSURL URLWithString:imfdbSearchURL];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[[[TUSafariActivity alloc] init] ] ];
    activityViewController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier] isEqualToString:@"gunEditView"]) {
         
         // Get destination view
         LBJPViewController *destinationViewController = [segue destinationViewController];
         
         PFObject *objectUnderWork = [self parseObject];
         
         // Pass the information to your destination view
         [destinationViewController setParseObject:objectUnderWork];
     }
 }


@end
