//
//  OpenCVCamDelegate.h
//  OperationIris
//
//  Created by Alec Vercruysse on 3/9/19.
//  Copyright © 2019 Alec Vercruysse. All rights reserved.
//

#ifndef OpenCVCamDelegate_h
#define OpenCVCamDelegate_h

@protocol OpenCVCamDelegate <NSObject>
- (void) imageProcessed: (UIImage*) image;
@end

#endif /* OpenCVCamDelegate_h */
