//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^SaveImageCompletion)(ALAsset *asset, NSURL *assetURL, NSError* error);
typedef void(^GetImageCompletion)(UIImage *image, NSString* error);
typedef void(^GetVideoCompletion)(NSData *videoData, NSString* error);


@interface ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
-(void)saveVideo:(NSURL *)path toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
- (void)getImage:(NSURL *)thumbnail withCompletionBlock:(GetImageCompletion)completionBlock;
- (void)getVideo: (NSURL *)path withCompletionBlock:(GetVideoCompletion)completionBlock;


@end
