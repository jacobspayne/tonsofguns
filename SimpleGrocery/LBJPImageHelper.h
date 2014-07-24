//
//  LBJPImageHelper.h
//  TonsOfGuns
//
//  Created by X Code User on 7/24/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface LBJPImageHelper : NSObject
+(void)loadParseImage:(PFObject *)parseObject forImageColumn:(NSString *)columnName andCompletionBlock:(void (^)(UIImage *imageFile, NSError *error))completionBlock;
@end
