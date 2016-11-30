//
//  AgreeViewController.swift
//  CapNudleApp
//
//  Created by 齋藤一真 on 2016/11/30.
//  Copyright © 2016年 齋藤一真. All rights reserved.
//

import Foundation
import UIKit

class AgreeViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushAgreeButton(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "Top") as! TopViewController
        self.present(nextView, animated: false, completion: nil)
    }
    
}
