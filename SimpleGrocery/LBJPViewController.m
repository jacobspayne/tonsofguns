//
//  LBJPViewController.m
//  SimpleGrocery
//
//  Created by X Code User on 7/21/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import "LBJPViewController.h"
#import "LBJPTableViewCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>

@interface LBJPViewController ()
{
    BOOL updatingPhoto;
}
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
    NSData *imageData = UIImagePNGRepresentation(_gunPictureButton.imageView.image);
    PFFile *imageFile = [PFFile fileWithName:@"gun.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [object setObject:imageFile forKey:@"picture"];
        [object saveInBackground];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)getNewGunImage:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"Select a photo for your profile."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Take Photo",
                            @"Choose from Library",
                            nil];
    [message show];
}




#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0)
    {
        NSLog(@"Cancel was pressed.");
    }
    else if(buttonIndex == 1)
    {
        updatingPhoto = YES;
        NSLog(@"Photo was pressed");
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                      (NSString *) kUTTypeImage,
                                      nil];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else if(buttonIndex == 2)
    {
        updatingPhoto = YES;
        NSLog(@"Library was pressed");
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                      (NSString *) kUTTypeImage,
                                      nil];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

-(void)uploadImage:(NSData*)imageData withFileName:(NSString*)jpgName
{
    PFFile *imageFile = [PFFile fileWithName:jpgName data:imageData];
    
    // First we check if an image already exists for this moniker.
    PFQuery *query = [PFQuery queryWithClassName:@"UserThumbnail"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Retrieved %d images.", objects.count);
            
            
            // save the new file.
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                PFObject *userPhoto;
                if (!error) {
                    if(objects.count >= 1) {
                        
                        // update existing object.
                        userPhoto = objects[0];
                    } else {
                        
                        //create a new object
                        userPhoto = [PFObject objectWithClassName:@"UserThumbnail"];
                        //[userPhoto setObject:self.moniker.text forKey:@"nickname"];
                    }
                    
                    // associate the image file with the user object.
                    [userPhoto setObject:imageFile forKey:@"imageFile"];
                    
                    // save the object
                    [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            NSLog(@"Successfuly stored image.jpg");
                        }
                        else{
                            // Log details of the failure
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }];
                    
                }
            }];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

// borrowed from http://www.samwirch.com/blog/cropping-and-resizing-images-camera-ios-and-objective-c
- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        
        // Resize image
        //        UIGraphicsBeginImageContext(CGSizeMake(250, 250));
        //        [image drawInRect: CGRectMake(0, 0, 250, 250)];
        //        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        
        UIImage *smallImage = [self squareImageWithImage:image scaledToSize:CGSizeMake(250, 250)];
        
        [self.gunPictureButton setImage:smallImage forState:UIControlStateNormal];
        [self.gunPictureButton setImage:smallImage forState:UIControlStateHighlighted];
        
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
}



@end
