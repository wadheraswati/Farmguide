//
//  UIImage+FX.h
//
//  Version 1.2
//
//  Created by Nick Lockwood on 31/10/2011.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/FXImageView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>

@interface UIImage (FX)

- (UIImage *)takeSnapshot:(UIView*)view;
- (UIImage *)makeGrabberImageWithBaseColor:(UIColor*)baseColor andSize:(CGSize)size;

- (UIImage *)imageCroppedToRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToFitSize:(CGSize)size;
- (UIImage *)imageScaledToFillSize:(CGSize)size;
- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode padToFit:(BOOL)padToFit;

- (UIImage *)reflectedImageWithScale:(CGFloat)scale;
- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha;
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
- (UIImage *)imageWithShadowOfSize:(CGFloat)shadowSize;
- (UIImage *)imageWithShadowOfSize:(CGFloat)shadowSize andColor:(UIColor *)color;

- (UIImage *)stackBlur:(NSUInteger)radius;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
- (UIImage*)getBlurredImageWithRadius:(int)radius;

+ (UIImage *)mergeBackImage:(UIImage *)backImage withFrontImage:(UIImage *)frontImage;
+ (UIImage *)mergeBackImage:(UIImage *)backImage withFrontImageScaled:(UIImage *)frontImage;

+ (UIImage *)squareImageWithColor:(UIColor *)color dimension:(int)dimension;
+ (UIImage *)imageWithColor:(UIColor *)color width:(int)w height:(int)h;

- (UIImage *)normalize;
- (UIImage *)toGrayscale;
- (UIImage *)negativeImage;
- (UIImage *)ApplyVignetteToImage:(UIImage *)image;

- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size;
+ (UIImage *)placeholderIconImageFromString:(NSString*)string withSize:(CGSize)sz;

+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;

@end
