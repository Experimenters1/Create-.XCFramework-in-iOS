//
//  ViewController.swift
//  testQR
//
//  Created by Huy Vu on 9/9/25.
//

import UIKit
import HuyQRScanner

class ViewController: UIViewController {
  
  @IBOutlet weak var btnScan: UIButton!
  
  @IBOutlet weak var resultLB: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  
  @IBAction func ActionQR(_ sender: Any) {
    ScannerQR()
  }
  
  
  private func ScannerQR() {
    let qrScanner = QRScanner()
    qrScanner.delegate = self
    present(qrScanner, animated: true)
  }

}


extension ViewController : QRScannerDelegate {
  func didScan(code: String) {
    DispatchQueue.main.async {
      self.resultLB.text = code
    }
  }
  
  func didFail(error: any Error) {
    
  }
}
