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
                                                      message:@"Select a photo of your gun."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Take a picture",
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *smallImage = [self squareImageWithImage:image scaledToSize:CGSizeMake(253, 190)];
        
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
