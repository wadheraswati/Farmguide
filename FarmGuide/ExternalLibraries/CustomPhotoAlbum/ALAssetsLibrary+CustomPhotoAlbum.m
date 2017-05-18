//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    //write the image data to the assets library (camera roll)
    [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation 
                        completionBlock:^(NSURL* assetURL, NSError* error) {
                              
                          //error handling
                          if (error!=nil) {
                              completionBlock(nil, assetURL, error);
                              return;
                          }

                          //add the asset to the custom photo album
                          [self addAssetURL: assetURL 
                                    toAlbum:albumName 
                        withCompletionBlock:completionBlock];
                          
                      }];
}

-(void)saveVideo:(NSURL *)pathURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    [self writeVideoAtPathToSavedPhotosAlbum:pathURL completionBlock:^(NSURL* assetURL, NSError* error) {
        
        //error handling
        if (error!=nil) {
            completionBlock(nil, assetURL, error);
            return;
        }
        
        //add the asset to the custom photo album
        [self addAssetURL: assetURL
                  toAlbum:albumName
      withCompletionBlock:completionBlock];
        
    }];
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    __block BOOL albumWasFound = NO;
    
    //search all photo albums in the library
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum 
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

                            //compare the names of the albums
                            if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                
                                //target album is found
                                albumWasFound = YES;
                                
                                //get a hold of the photo's asset instance
                                [self assetForURL: assetURL 
                                      resultBlock:^(ALAsset *asset) {
                                                  
                                          //add photo to the target album
                                          [group addAsset: asset];
                                          
                                          //run the completion block
                                          completionBlock(asset, assetURL, nil);
                                          
                                      } failureBlock: (nil, nil)];

                                //album was found, bail out of the method
                                return;
                            }
                            
                            if (group==nil && albumWasFound==NO) {
                                //photo albums are over, target album does not exist, thus create it
                                
                                __weak ALAssetsLibrary* weakSelf = self;

                                //create new assets album
                                [self addAssetsGroupAlbumWithName:albumName 
                                                      resultBlock:^(ALAssetsGroup *group) {
                                                                  
                                                          //get the photo's instance
                                                          [weakSelf assetForURL: assetURL 
                                                                        resultBlock:^(ALAsset *asset) {

                                                                            //add photo to the newly created album
                                                                            [group addAsset: asset];
                                                                            
                                                                            //call the completion block
                                                                            completionBlock(asset, assetURL, nil);

                                                                        } failureBlock: (nil, nil)];
                                                          
                                                      } failureBlock: (nil, nil)];

                                //should be the last iteration anyway, but just in case
                                return;
                            }
                            
                        } failureBlock: (nil, nil)];
    
}

- (void)getImage:(NSURL *)thumbnail withCompletionBlock:(GetImageCompletion)completionBlock;
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
        
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];

        //uint8_t *bytes = malloc([rep size]);
        //NSError *error = nil;
        if (iref){
            UIImage *myImage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
            completionBlock(myImage, nil);
        }
        else
        {
            completionBlock(nil, @"Image Not Found");
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
       // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Basepin" message:[[myerror localizedFailureReason]  stringByAppendingString:@"Please enable access in Privacy Settings and try again" ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        completionBlock(nil, @"Please enable access in Privacy Settings and try again");
        NSLog(@"file not found");
        //failed to get image.
    };
    
    [library assetForURL:thumbnail resultBlock:resultblock failureBlock:failureblock];
}

- (void)getVideo: (NSURL *)path withCompletionBlock:(GetVideoCompletion)completionBlock
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
        
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        uint8_t *bytes = malloc([rep size]);
        NSError *error = nil;
        NSUInteger length = [rep getBytes:bytes fromOffset:0 length:[rep size] error:&error];
        NSData *videoData1 = [NSData dataWithBytes:bytes length:length];
        
        //uint8_t *bytes = malloc([rep size]);
        //NSError *error = nil;
        if ([videoData1 length]){
            
            completionBlock(videoData1, nil);
        }
        else
        {
            completionBlock(nil, @"video Not Found");
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
        // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Basepin" message:[[myerror localizedFailureReason]  stringByAppendingString:@"Please enable access in Privacy Settings and try again" ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        completionBlock(nil, @"Please enable access in Privacy Settings and try again");
        NSLog(@"file not found");
        //failed to get image.
    };
    
    [library assetForURL:path resultBlock:resultblock failureBlock:failureblock];
}


@end
