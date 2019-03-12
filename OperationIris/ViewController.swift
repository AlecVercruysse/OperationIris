//
//  ViewController.swift
//  OperationIris
//
//  Created by Alec Vercruysse on 3/9/19.
//  Copyright © 2019 Alec Vercruysse. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, OpenCVCamDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var irisPx: UILabel!
    @IBOutlet weak var pupilPx: UILabel!
    @IBOutlet weak var ratioVal: UILabel!
    
    var openCVWrapper: OpenCVWrapper!
    
    var lastTimeSet: Double = 0
    var recordingStarted: Double = 0
    var recording: Bool = false
    
    var firstRatio = 0.0;
    var secondRatio = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openCVWrapper = OpenCVWrapper()
        openCVWrapper.setDelegate(self)
    }
    
    func imageProcessed(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
        if (recording && CACurrentMediaTime() >= recordingStarted + 1.0) {
            openCVWrapper.setSecondPhoto()
            toggleFlash()
            recording = false
        }
    }
    
    @IBAction func start(_ sender: Any) {
        openCVWrapper.start()
    }
    
    @IBAction func stop(_ button: UIButton) {
        openCVWrapper.stop()
    }
    
    @IBAction func startMeasurePressed(_ sender: Any) {
        recording = true
        toggleFlash()
        recordingStarted = CACurrentMediaTime()
        openCVWrapper.setFirstPhoto()
    }
    
    @IBAction func showFirstImg(_ sender: Any) {
        let firstImage = openCVWrapper.getFirstImage()
        self.imageView.image = firstImage;
    }
    
    @IBAction func showSecondImg(_ sender: Any) {
        let secondImage = openCVWrapper.getSecondImage()
        self.imageView.image = secondImage;
    }
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }

    @IBAction func calcRadius(_ sender: Any) {
        let rad = openCVWrapper.getFirstRadius()
        pupilPx.text = String(rad)
        let i_rad = openCVWrapper.getFirstIrisRadius()
        irisPx.text = String(i_rad)
        firstRatio = Double(Double(rad)/Double(i_rad));
        ratioVal.text = String(firstRatio)
        
    }
    
    
    @IBAction func calcSecondRadius(_ sender: Any) {
        let rad = openCVWrapper.getSecondRadius()
        pupilPx.text = String(rad)
        let i_rad = openCVWrapper.getSecondIrisRadius()
        irisPx.text = String(i_rad)
        secondRatio = Double(Double(rad)/Double(i_rad));
        ratioVal.text = String(secondRatio)
    }
    
    @IBAction func percentDiff(_ sender: Any) {
        let diff = (secondRatio - firstRatio)/firstRatio * 100
        let alert = UIAlertController(title: "Difference", message: "The percent difference between the first constricted ratio and the second is: " + String(diff) + ", with a .7 second fixed time interval", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
