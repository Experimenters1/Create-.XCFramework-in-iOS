//
//  QRScanner.swift
//  HuyQRScanner
//
//  Created by Huy Vu on 9/9/25.
//

import Foundation
import UIKit
import AVFoundation

public protocol QRScannerDelegate: AnyObject {
  func didScan(code: String)
  func didFail(error: Error)
  
}


public class QRScanner: UIViewController , AVCaptureMetadataOutputObjectsDelegate {
  public weak var delegate: QRScannerDelegate?
  
  private var captureSession: AVCaptureSession!
  private var previewLayer: AVCaptureVideoPreviewLayer!
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    setupScan()
  }
  
  private func setupScan() {
    captureSession = AVCaptureSession()
    
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
      let error = NSError(domain: "QRScanner", code: 1001, userInfo: [NSLocalizedDescriptionKey : "No camera available"])
      delegate?.didFail(error: error)
      return
    }
    
    guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
      let error = NSError(domain: "Camera", code: 2,userInfo: [NSLocalizedDescriptionKey : "Unable to open camera"])
      delegate?.didFail(error: error)
      return
    }
    
    if captureSession.canAddInput(videoInput) {
      captureSession.addInput(videoInput)
    }else {
      let error = NSError(domain: "Camera Input", code: 3, userInfo: [NSLocalizedDescriptionKey: "Unable to add"])
      delegate?.didFail(error: error)
    }
    
    let metadataOutput = AVCaptureMetadataOutput()
    
    if captureSession.canAddOutput(metadataOutput) {
      captureSession.addOutput(metadataOutput)
      
      metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
      metadataOutput.metadataObjectTypes = [.qr]
    }else {
      let error = NSError(domain: "Camera Output", code: 5, userInfo: [NSLocalizedDescriptionKey: "Unable to Output"])
      delegate?.didFail(error: error)
      return
    }
    
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.layer.bounds
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)
    
    captureSession.startRunning()
    
  }
  
  public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue else { return }
      
      captureSession.stopRunning()
      delegate?.didScan(code: stringValue)
      dismiss(animated: true, completion: nil)
    }
  }
  
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if captureSession?.isRunning == true {
      captureSession.stopRunning()
    }
  }
  
  
  
}
