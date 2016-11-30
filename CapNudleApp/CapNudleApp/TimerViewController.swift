//
//  TimerViewController.swift
//  CapNudleApp
//
//  Created by 齋藤一真 on 2016/11/22.
//  Copyright © 2016年 齋藤一真. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import MessageUI

@objc
class TimerViewController: UIViewController {
    var ipAddrString:String!
    var JANCodeString:String!
    var serverIpAddr:String!
    
    var menSize:Int = 0
    var menType:Int = 0
    var waitTime:Float = 0.0
    
    var timer:Timer!
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var selectedKatasa: UISegmentedControl!
    @IBOutlet weak var startButton: UIButton!
    
    //麺の硬さ（1:やわめ、2:かため）
    var katasa : Int? = nil
    
    //時間表示用のラベル.
    var myLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNotification()

        self.setTimer()
    }
    
    func setNotification() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            forName:Notification.Name(rawValue:"applicationDidEnterBackground"),
            object:nil, queue:nil) {
                notification in
                // Handle notification
                self.onEnterBackground()
        }
        
        notificationCenter.addObserver(
            forName:Notification.Name(rawValue:"applicationWillEnterForeground"),
            object:nil, queue:nil) {
                notification in
                // Handle notification
                self.onEnterForgound()
        }
        
        notificationCenter.addObserver(
            forName:Notification.Name(rawValue:"applicationWillTerminate"),
            object:nil, queue:nil) {
                notification in
                // Handle notification
                self.onTerminate()
        }
    }
    
    //バックグラウンドに行った時
    func onEnterBackground() {
        let time:Int = Int(NSDate().timeIntervalSince1970)
        userDefaults.set(time, forKey: "waitTime")
    }
    
    //フォアグラウンドに戻ってきた時
    func onEnterForgound() {
        let time:Int = Int(userDefaults.integer(forKey: "waitTime"))
        let now:Int = Int(NSDate().timeIntervalSince1970)
        let delay:Float = Float(now - time)
        
        self.waitTime -= delay
    }
    
    //アプリ終了時
    func onTerminate() {
        userDefaults.removeObject(forKey: "waitTime")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["CompleteNotification"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ローカル通知設定
    func setLocalPush() {
        let content = UNMutableNotificationContent()
        content.title = "☆★☆完成☆★☆"
        //content.subtitle  = "最高の1日！"
        content.body = "冷めないうちに早く食べよ〜！"
        content.sound = UNNotificationSound.default()
        
        /* 時間指定 */
        // UNCalendarNotificationTriggerを作成
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.waitTime), repeats: false)
        
        // id, content, triggerからUNNotificationRequestを作成
        let request = UNNotificationRequest.init(identifier: "CompleteNotification", content: content, trigger: trigger)
        
        // UNUserNotificationCenterにrequestを追加
        UNUserNotificationCenter.current().add(request)
    }
    
    @IBAction func changeKatasa(_ sender: Any) {
        //print(selectedKatasa.titleForSegment(at: selectedKatasa.selectedSegmentIndex)!)
        //print(selectedKatasa.selectedSegmentIndex)
    }
    
    @IBAction func onClickStart(_ sender: Any) {
        self.startButton.isEnabled = false
        self.katasa = selectedKatasa.selectedSegmentIndex
        self.httpRequest()
    }
    
    func httpRequest() {
        //!!!::デバック用↓
        //self.JANCodeString = "49698633"
        let url = URL(string:"http://27.120.120.174/NoodleApp/Index.php?jan_code=\(self.JANCodeString!)&katasa=\(self.katasa!)")
        
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
            
            let status:String = parsedData["status"] as! String!
            
            //データなし
            if (status == "INSERT FAILED") {
                self.showAlertView()
                return
            }
            
            let size:String   = parsedData["men_size"] as! String!
            let type:String   = parsedData["men_type"] as! String!
            let time:String   = parsedData["wait_time"] as! String!
            
            self.menSize  = Int(size)!
            self.menType  = Int(type)!
            self.waitTime = Float(time)!
            
            self.startTimer()
            self.setLocalPush()
            
        } catch let error as NSError {
            //ユーザーデータが存在しない場合
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    func showAlertView() {
        let alert: UIAlertController = UIAlertController(title: "！！！", message: "商品データが存在しません", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            self.changeViewController()
        })
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /*
    func showMailView() {
        //メールが送信できるかどうかの確認は必ず必要
        if mailComposeController.canSendMail() {
            let e = mailComposeController()
            e.mailComposeDelegate = self //delegateの設定
            e.setToRecipients(["test@swift-study.com"]) //宛先アドレス
            e.setCcRecipients(["cc@swift-study.com"]) //CCアドレス
            e.setBccRecipients(["bcc@swift-study.com"]) //BCCアドレス
            e.setSubject("テストサブジェクトです") //サブジェクト
            e.setMessageBody("テスト本文です", isHTML: false) //メール本文
            presentViewController(e, animated: true, completion: nil) //メール作成画面呼び出し
        } else {
            print("送信できません")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if result == MFMailComposeResultCancelled {
            print("メール送信がキャンセルされました")
        } else if result == MFMailComposeResultSaved {
            print("下書きとして保存されました")
        } else if result == MFMailComposeResultSent {
            print("メール送信に成功しました")
        } else if result == MFMailComposeResultFailed {
            print("メール送信に失敗しました")
        }
        dismiss(animated: true, completion: nil) //閉じる
        
        self.changeViewController()
    }
    */
    
    func changeViewController() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "Top") as! TopViewController
        self.present(nextView, animated: false, completion: nil)
    }
    
    func setTimer() {
        //ラベルを作る.
        myLabel = UILabel(frame: CGRect(origin:CGPoint(x:0,y:0), size:CGSize(width:200,height:50)))
        myLabel.backgroundColor = UIColor.gray
        myLabel.layer.masksToBounds = true
        myLabel.layer.cornerRadius = 20.0
        myLabel.text = "\(self.waitTime)秒"
        myLabel.textColor = UIColor.black
        myLabel.shadowColor = UIColor.darkGray
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: self.view.bounds.height/2)
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(myLabel)
    }
    
    func startTimer() {
        //タイマーを作る.
        myLabel.text = "\(self.waitTime)秒"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimerViewController.onUpdate(timer:)), userInfo: nil, repeats: true)
    }
    
    //NSTimerIntervalで指定された秒数毎に呼び出されるメソッド.
    func onUpdate(timer : Timer) {
        self.waitTime -= 0.1
        
        //桁数を指定して文字列を作る.
        let str = "\(String(format:"%.1f",self.waitTime))秒"
        
        myLabel.text = str
        
        if (self.waitTime <= 0) {
            //タイマー破棄
            timer.invalidate()
            myLabel.text = "完成しました！！"
        }
    }
}
