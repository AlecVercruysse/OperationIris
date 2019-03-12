//
//  OpenCVCam.h
//  OperationIris
//
//  Created by Alec Vercruysse on 3/9/19.
//  Copyright © 2019 Alec Vercruysse. All rights reserved.
//

#ifndef OpenCVCam_h
#define OpenCVCam_h

#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import "OpenCVCamDelegate.h"

@interface OpenCVCam : NSObject<CvVideoCameraDelegate> {
    cv::Mat firstImg;
    cv::Mat secondImg;
    int firstIrisRadius;
    int secondIrisRadius;
}

@property CvVideoCamera* cam;
@property id<OpenCVCamDelegate> delegate;
@property BOOL takeFirstImg;
@property BOOL takeSecondImg;
@property double timeSecondTaken;

+ (id) sharedInstance;

- (void) start;
- (void) stop;
- (void) initCam;
- (cv::Mat) getFirstImg;
- (void) setFirstImg:(cv::Mat)first;
- (cv::Mat) getSecondImg;
- (int) getFirstRadius;
- (int) getSecondRadius;
- (int) getFirstIrisRadius;
- (int) getSecondIrisRadius;

@end

#endif /* OpenCVCam_h */
