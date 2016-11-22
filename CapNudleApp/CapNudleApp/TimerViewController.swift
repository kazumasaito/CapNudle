//
//  TimerViewController.swift
//  CapNudleApp
//
//  Created by 齋藤一真 on 2016/11/22.
//  Copyright © 2016年 齋藤一真. All rights reserved.
//

import Foundation
import UIKit

class TimerViewController: UIViewController {
    var ipAddrString:String!
    var JANCodeString:String!
    var serverIpAddr:String!
    
    //時間計測用の変数.
    var cnt : Float = 180
    
    //時間表示用のラベル.
    var myLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //httpRequest()
        self.setTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func httpRequest() {
        let url = URL(string:"http://27.120.120.174/NoodleApp/Test.php")
        
        let task = URLSession.shared.dataTask(with: url!){ data, response, error in
            OperationQueue.main.addOperation {
                self.parseJson(data: data, error: error)
            }
        }
        task.resume()
    }
    
    /**
     * レスポンスデータをパースする
     */
    func parseJson(data: Data?, error: Error?) {
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            
            print(parsedData)
            
            self.serverIpAddr = parsedData["ip_addr"] as! String!
            
            self.viewText()
            
            self.setTimer()
            
        } catch let error as NSError {
            //ユーザーデータが存在しない場合
            print("Failed to load: \(error.localizedDescription)")
        }
        
    }
    
    func viewText() {
        print("JANコード:\(self.JANCodeString!)")
        print("IPアドレス(クライアント):\(self.ipAddrString!)")
        print("IPアドレス(サーバー):\(self.serverIpAddr!)")
    }
    
    func setTimer() {
        //ラベルを作る.
        myLabel = UILabel(frame: CGRect(origin:CGPoint(x:0,y:0), size:CGSize(width:200,height:50)))
        myLabel.backgroundColor = UIColor.orange
        myLabel.layer.masksToBounds = true
        myLabel.layer.cornerRadius = 20.0
        myLabel.text = "Time:\(cnt)"
        myLabel.textColor = UIColor.white
        myLabel.shadowColor = UIColor.gray
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 200)
        self.view.backgroundColor = UIColor.cyan
        self.view.addSubview(myLabel)
        
        //タイマーを作る.
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimerViewController.onUpdate(timer:)), userInfo: nil, repeats: true)
    }
    
    //NSTimerIntervalで指定された秒数毎に呼び出されるメソッド.
    func onUpdate(timer : Timer){
        
        cnt -= 0.1
        
        //桁数を指定して文字列を作る.
        let str = "Time:".appendingFormat("%.1f",cnt)
        
        myLabel.text = str
        
    }
}
