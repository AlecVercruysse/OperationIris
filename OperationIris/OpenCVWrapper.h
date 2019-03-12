//
//  OpenCVWrapper.h
//  OperationIris
//
//  Created by Alec Vercruysse on 3/9/19.
//  Copyright © 2019 Alec Vercruysse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OpenCVCamDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString *)openCVVersionString;

- (void)setDelegate: (id<OpenCVCamDelegate>) delegate;
- (void)start;
- (void)stop;
- (void)setFirstPhoto;
- (UIImage *) getFirstImage;
- (UIImage *) getSecondImage;
- (int) getFirstRadius;
- (int) getSecondRadius;
- (int) getFirstIrisRadius;
- (int) getSecondIrisRadius;
- (void) setSecondPhoto;

@end

NS_ASSUME_NONNULL_END
