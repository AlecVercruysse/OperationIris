//
//  OpenCVCam.m
//  OperationIris
//
//  Created by Alec Vercruysse on 3/9/19.
//  Copyright © 2019 Alec Vercruysse. All rights reserved.
//

#import "OpenCVCam.h"
#import "UIImage+OpenCV.h"

using namespace cv;

@implementation OpenCVCam

+ (id)sharedInstance {
    static OpenCVCam *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance initCam];
    });
    return instance;
}

- (id) init
{
    return self;
}

- (void) start
{
    [self.cam start];
}

- (void) stop
{
    [self.cam stop];
}

- (void) initCam
{
    self.cam = [[CvVideoCamera alloc] init];
    
    self.cam.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    //self.cam.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
    self.cam.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    self.cam.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    
    self.cam.defaultFPS = 30;
    self.cam.grayscaleMode = NO;
    self.cam.delegate = self;
}

- (void)processImage:(cv::Mat &)image
{
    cvtColor(image, image, COLOR_BGR2GRAY);
    medianBlur(image, image, 5);
    std::vector<Vec3f> circles;
    HoughCircles(image, circles, HOUGH_GRADIENT, 1,
                 image.rows/2,  // change this value to detect circles with different distances to each other
                 100, 45, 30, 200 // change the last two parameters
                 // (min_radius & max_radius) to detect larger circles
                 );
    if (circles.size() > 0) {
        Vec3i c = circles[0];
        cv::Point center = cv::Point(c[0], c[1]);
        circle( image, center, 1, Scalar(0,100,100), 3, LINE_AA);
        circle( image, center, c[2], Scalar(255,0,255), 3, LINE_AA);
        int rad = c[2];
        int topx = c[0] - rad - 5;
        int topy = c[1] - rad - 5;
        int rad_box = rad * 2 + 10;
        if (_takeFirstImg && topx >= 0 && topy >= 0 && image.cols >= topx + rad_box && image.rows >= topy + rad_box && rad_box > 0) {
            [self setTakeFirstImg:false];
            cv::Mat cropped = image(cv::Rect(topx, topy, rad_box, rad_box));
            [self setFirstIrisRadius:rad];
            [self setFirstImg:cropped];
        }
        if (_takeSecondImg && topx >= 0 && topy >= 0 && image.cols >= topx + rad_box && image.rows >= topy + rad_box && rad_box > 0) {
            _timeSecondTaken = CACurrentMediaTime(); //in case it takes a while to find a circle
            [self setTakeSecondImg:false];
            cv::Mat cropped = image(cv::Rect(topx, topy, rad_box, rad_box));
            [self setSecondIrisRadius:rad];
            [self setSecondImg:cropped];
        }
    }
    
    if (self.delegate != nil) {
        [self.delegate imageProcessed:[UIImage imageWithCVMat: image]];
    }
}

- (cv::Mat)getFirstImg
{
    cv::Mat tmp;
    //resize(firstImg, tmp, cv::Size(1280, 720));
    resize(firstImg, tmp, cv::Size(640, 480));
    return tmp;
}

- (void) setFirstImg:(cv::Mat)first
{
    firstImg = first;
    
}

- (cv::Mat)getSecondImg
{
    cv::Mat tmp;
    //resize(firstImg, tmp, cv::Size(1280, 720));
    resize(secondImg, tmp, cv::Size(640, 480));
    return tmp;
}

- (void) setSecondImg:(cv::Mat)second
{
    secondImg = second;
    
}

- (int) getFirstRadius
{
    cv::Mat img = firstImg;
    equalizeHist(img, img);
    GaussianBlur( img, img, cv::Size(9, 9), 2, 2 );
    int midRow = img.rows/2;
    int edgeidx = img.cols/2;
    bool done = false;
    for(int i = img.cols * 25 / 40; i < img.cols; i++)
        if (img.at<unsigned char>(midRow, i) > 20 && !done) {
            NSLog(@"done setting edge: %i", i);
            edgeidx = i;
            done = true;
        }
    circle( img, cv::Point(img.cols/2, img.rows/2), edgeidx - img.cols/2, Scalar(0,255,255), 1, 8, 0 );
    return edgeidx - img.cols/2;
}

- (int) getSecondRadius
{
    cv::Mat img = secondImg;
    equalizeHist(img, img);
    GaussianBlur( img, img, cv::Size(9, 9), 2, 2 );
    int midRow = img.rows/2;
    int edgeidx = img.cols/2;
    bool done = false;
    for(int i = img.cols * 25 / 40; i < img.cols; i++)
        if (img.at<unsigned char>(midRow, i) > 20 && !done) {
            NSLog(@"done setting edge: %i", i);
            edgeidx = i;
            done = true;
        }
    circle( img, cv::Point(img.cols/2, img.rows/2), edgeidx - img.cols/2, Scalar(0,255,255), 1, 8, 0 );
    return edgeidx - img.cols/2;
}

- (int) getFirstIrisRadius
{
    return firstIrisRadius;
}

- (void) setFirstIrisRadius:(int)rad
{
    firstIrisRadius = rad;
}

- (int) getSecondIrisRadius
{
    return secondIrisRadius;
}

- (void) setSecondIrisRadius:(int)rad
{
    secondIrisRadius = rad;
}



@end
