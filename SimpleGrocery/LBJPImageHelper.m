//
//  LBJPImageHelper.m
//  TonsOfGuns
//
//  Created by X Code User on 7/24/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import "LBJPImageHelper.h"
#import <Parse/Parse.h>

@implementation LBJPImageHelper

// example from: https://coderwall.com/p/idwrhw and slightly modified
+(void)loadParseImage:(PFObject *)parseObject forImageColumn:(NSString *)columnName andCompletionBlock:(void (^)(UIImage *imageFile, NSError *error))completionBlock{
    NSString *parseFileName = [NSString stringWithFormat:@"%@", [[parseObject objectForKey:columnName] name]];
    
    // Get a path to the place in the local documents directory on the iOS device where the image file should be stored.
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // You can change the path as you see fit by altering the stringByAppendingPathComponent call here.
    NSString *imagesDirectory = [documentsDirectory stringByAppendingPathComponent:@"Images"];
    NSString *storePath = [imagesDirectory stringByAppendingPathComponent:parseFileName];
    
    // Image data from Parse.com is retrieved in the background.
    [[parseObject objectForKey:columnName] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if (!error){
            NSData *fileData = [[NSData alloc] initWithData:data];
            if (![[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory]){
                // Create the folder if it doesn't already exist.
                [[NSFileManager defaultManager] createDirectoryAtPath:imagesDirectory withIntermediateDirectories:NO attributes:nil error:&error];
            }
            
            // Write the PFFile data to the local file.
            [fileData writeToFile:storePath atomically:YES];
            
            UIImage *showcaseImage;
            if ([[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory]){
                showcaseImage = [UIImage imageWithContentsOfFile:storePath];
            } else // No file exists at the expected path. Perhaps the disk is full, etc.?
            {
                NSLog(@"Unable to find image file where we expected it: %@", storePath);
            }
            completionBlock(showcaseImage, error);
            
            // This may be a good place to clean up the target directory.
        }
        else // Unable to pull the image data from Parse.com. Consider more robust error handling.
        {
            NSLog(@"Error getting image data.");
            completionBlock(nil, error);
        }
    }];
}
@end
