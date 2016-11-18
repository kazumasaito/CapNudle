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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // セッションの作成.
        let mySession: AVCaptureSession! = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // デバイスを格納する.
        var myDevice: AVCaptureDevice!
        
        // バックカメラをmyDeviceに格納.
        for device in devices! {
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // バックカメラから入力(Input)を取得.
        let myVideoInput = try! AVCaptureDeviceInput.init(device: myDevice)
        
        if mySession.canAddInput(myVideoInput) {
            // セッションに追加.
            mySession.addInput(myVideoInput)
        }
        
        // 出力(Output)をMeta情報に.
        let myMetadataOutput: AVCaptureMetadataOutput! = AVCaptureMetadataOutput()
        
        if mySession.canAddOutput(myMetadataOutput) {
            // セッションに追加.
            mySession.addOutput(myMetadataOutput)
            // Meta情報を取得した際のDelegateを設定.
            myMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // 判定するMeta情報にQRCodeを設定.
            myMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode,
                                                    AVMetadataObjectTypeCode39Code,
                                                    AVMetadataObjectTypeCode39Mod43Code,
                                                    AVMetadataObjectTypeEAN13Code,
                                                    AVMetadataObjectTypeEAN8Code,
                                                    AVMetadataObjectTypeCode93Code,
                                                    AVMetadataObjectTypeCode128Code,
                                                    AVMetadataObjectTypePDF417Code,
                                                    AVMetadataObjectTypeQRCode,
                                                    AVMetadataObjectTypeAztecCode
            ]
        }
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer = AVCaptureVideoPreviewLayer.init(session: mySession)
        myVideoLayer?.frame = self.view.bounds
        myVideoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer!)
        
        // セッション開始.
        mySession.startRunning()
    }
    
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    // Meta情報を検出際に呼ばれるdelegate.
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, from connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            let qrData: AVMetadataMachineReadableCodeObject  = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            print("\(qrData.type)")
            print("\(qrData.stringValue)")
            
            // SafariでURLを表示.
            UIApplication.shared.openURL(URL(string: qrData.stringValue)!)
        }
    }
    
    
    /*
    // 読み取り範囲（0 ~ 1.0の範囲で指定）
    let x: CGFloat = 0.1
    let y: CGFloat = 0.4
    let width: CGFloat = 0.8
    let height: CGFloat = 0.2
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCamera(_ sender: Any) {
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // デバイスを格納する.
        var myDevice: AVCaptureDevice!
        
        // バックカメラをmyDeviceに格納.
        for device in devices! {
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // バックカメラから入力(Input)を取得.
        let myVideoInput = try! AVCaptureDeviceInput.init(device: myDevice)
        
        if session.canAddInput(myVideoInput) {
            // セッションに追加.
            session.addInput(myVideoInput)
        }
        
        // カメラからの取得映像を画面全体に表示する
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer?.frame = CGRect(origin:CGPoint(x:0, y:20), size:CGSize(width:self.view.bounds.width, height:self.view.bounds.height - 20))
        self.view.layer.insertSublayer(self.previewLayer!, at: 0)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        self.session.addOutput(output)
        
        // どのmetadataを取得するか設定する
        output.metadataObjectTypes = [AVMetadataObjectTypeUPCECode,
                                      AVMetadataObjectTypeCode39Code,
                                      AVMetadataObjectTypeCode39Mod43Code,
                                      AVMetadataObjectTypeEAN13Code,
                                      AVMetadataObjectTypeEAN8Code,
                                      AVMetadataObjectTypeCode93Code,
                                      AVMetadataObjectTypeCode128Code,
                                      AVMetadataObjectTypePDF417Code,
                                      AVMetadataObjectTypeQRCode,
                                      AVMetadataObjectTypeAztecCode
        ];
        
        // どの範囲を解析するか設定する
        output.rectOfInterest = CGRect(origin:CGPoint(x:y, y:1-x-width), size:CGSize(width:height,height:width))
        
        // 解析範囲を表すボーダービューを作成する
        let borderView = UIView(frame: CGRect(origin: CGPoint(x:x * self.view.bounds.width, y:y * self.view.bounds.height), size: CGSize(width:width * self.view.bounds.width, height:height * self.view.bounds.height)))
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(borderView)
        
        session.startRunning()
        
        print("カメラ起動")
    }
    

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, from connection: AVCaptureConnection!) {
        
        print("バーコード読み取り中。。。")
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
 */
 
    
    /*
    let session: AVCaptureSession = AVCaptureSession()
    var prevlayer: AVCaptureVideoPreviewLayer!
    var hview: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //準備（サイズ調整、ボーダーカラー、カメラオブジェクト取得、エラー処理）
        self.hview.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin,
            UIViewAutoresizing.flexibleBottomMargin,
            UIViewAutoresizing.flexibleLeftMargin,
            UIViewAutoresizing.flexibleRightMargin]
        self.hview.layer.borderColor = UIColor.green.cgColor
        self.hview.layer.borderWidth = 3
        self.view.addSubview(self.hview)
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            //インプット
            let input : AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: device)
            if input != nil {
                session.addInput(input)//カメラインプットセット
            }
        } catch let error as NSError {
            print(error)
        }
        
        //アウトプット
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.addOutput(output)//プレビューアウトプットセット
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        prevlayer = AVCaptureVideoPreviewLayer.init(session: session) as AVCaptureVideoPreviewLayer
        prevlayer.frame = self.view.bounds
        prevlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(prevlayer)
        
        session.startRunning()
        
        print("カメラ起動！")
    }
    
    //バーコードが見つかった時に呼ばれる
    private func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        print("バーコード読み取り中。。。")
        
        var highlightViewRect = CGRect.zero
        var barCodeObject : AVMetadataObject!
        var detectionString : String!
        
        //対応バーコードタイプ
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
                            AVMetadataObjectTypeCode39Code,
                            AVMetadataObjectTypeCode39Mod43Code,
                            AVMetadataObjectTypeEAN13Code,
                            AVMetadataObjectTypeEAN8Code,
                            AVMetadataObjectTypeCode93Code,
                            AVMetadataObjectTypeCode128Code,
                            AVMetadataObjectTypePDF417Code,
                            AVMetadataObjectTypeQRCode,
                            AVMetadataObjectTypeAztecCode
        ]
        
        //複数のバーコードの同時取得も可能
        for metadata in metadataObjects {
            for barcodeType in barCodeTypes {
                if metadata.type == barcodeType {
                    barCodeObject = self.prevlayer.transformedMetadataObject(for: metadata as! AVMetadataMachineReadableCodeObject)
                    highlightViewRect = barCodeObject.bounds
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    self.session.stopRunning()
                    break
                }
            }
        }
        print(detectionString)
        self.prevlayer.frame = highlightViewRect
        self.view.bringSubview(toFront: self.hview)
    }*/
 
}
