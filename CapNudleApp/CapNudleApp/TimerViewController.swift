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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewText() {
        print("JANコード:\(self.JANCodeString!)")
        print("IPアドレス:\(self.ipAddrString!)")
    }
}
