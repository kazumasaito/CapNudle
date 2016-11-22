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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpRequest()
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
}
