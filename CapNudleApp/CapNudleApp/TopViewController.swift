//
//  TopViewController.swift
//  CapNudleApp
//
//  Created by 齋藤一真 on 2016/11/18.
//  Copyright © 2016年 齋藤一真. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class TopViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    // 読み取り範囲（0 ~ 1.0の範囲で指定）
    let x: CGFloat = 0.1
    let y: CGFloat = 0.4
    let width: CGFloat = 0.8
    let height: CGFloat = 0.2
    
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let input = try? AVCaptureDeviceInput(device: device)
        session.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // どの範囲を解析するか設定する
        output.rectOfInterest = CGRect(origin: CGPoint(x:y, y:1-x-width), size: CGSize(width:height, height:width))
        
        // 解析範囲を表すボーダービューを作成する
        let borderView = UIView(frame: CGRect(origin: CGPoint(x:x * self.view.bounds.width, y:y * self.view.bounds.height), size: CGSize(width:width * self.view.bounds.width, height:height * self.view.bounds.height)))
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(borderView)
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer?.frame = view.bounds
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(layer!)
        
        session.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        print(metadataObjects.flatMap { $0.stringValue })
        
        // metadataが複数ある可能性があるためfor文で回す
        for data in metadataObjects {
            if data.type == AVMetadataObjectTypeEAN13Code {
                // 読み取りデータの全容をログに書き出す
                print("読み取りデータ：\(data)")
                print("データの文字列：\(data.description)")
                print("データの位置：\(data.bounds)")
            }
        }
        
        session.stopRunning()
    }
 
}
