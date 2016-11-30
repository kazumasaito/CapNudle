//
//  ViewController.swift
//  CapNudleApp
//
//  Created by 齋藤一真 on 2016/11/18.
//  Copyright © 2016年 齋藤一真. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //ロゴイメージ画像
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: { () in
                                    self.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (Bool) in
            
        })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2,
                                   delay: 1.3,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: { () in
                                    self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    self.logoImageView.alpha = 0
        }, completion: { (Bool) in
            self.logoImageView.removeFromSuperview()
            self.changeViewController()
        })        
    }
    
    func changeViewController() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ud = UserDefaults.standard
        if (ud.bool(forKey: "firstLaunch")) {
            
            //初回起動の処理
            let firstView = storyboard.instantiateViewController(withIdentifier: "Agree") as! AgreeViewController
            self.present(firstView, animated: false, completion: nil)
            
            ud.set(false, forKey: "firstLaunch")
            
            return
        }
        
        //2回目以降の処理
        let nextView = storyboard.instantiateViewController(withIdentifier: "Top") as! TopViewController
        self.present(nextView, animated: false, completion: nil)
    }
}

