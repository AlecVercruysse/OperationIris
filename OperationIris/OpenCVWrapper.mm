//
//  OpenCVWrapper.mm
//  OperationIris
//
//  Created by Alec Vercruysse on 3/9/19.
//  Copyright © 2019 Alec Vercruysse. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"
#import "OpenCVCam.h"

@implementation OpenCVWrapper

+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

- (void)setDelegate: (id<OpenCVCamDelegate>) delegate
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    cvCam.delegate = delegate;
}

- (void) start
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    [cvCam start];
}

- (void) stop
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    [cvCam stop];
}

- (void) setFirstPhoto
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    [cvCam setTakeFirstImg:true];
}

- (void) setSecondPhoto
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    [cvCam setTakeSecondImg:true];
}

- (UIImage *) getFirstImage
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    UIImage* img = [UIImage imageWithCVMat:[cvCam getFirstImg]];
    return img;
}

- (UIImage *) getSecondImage
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    UIImage* img = [UIImage imageWithCVMat:[cvCam getSecondImg]];
    return img;
}

- (int) getFirstRadius
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    return [cvCam getFirstRadius];
}

- (int) getSecondRadius
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    return [cvCam getSecondRadius];
}
- (int) getFirstIrisRadius
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    return [cvCam getFirstIrisRadius];
}

- (int) getSecondIrisRadius
{
    OpenCVCam* cvCam = [OpenCVCam sharedInstance];
    return [cvCam getSecondIrisRadius];
}

@end
