//
//  ViewController.swift
//  521Travel_ UIDatePicker
//
//  Created by youngstar on 16/10/31.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var ctimer:UIDatePicker!
    var btnStar:UIButton!
    
    var leftTime:Int = 180
    var alertController:UIAlertController!
    
    var timer:Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 时间选择器
        setdatePick()
        
        // 倒计时
        setCountDownTimer()
        
    }
    
    func setdatePick()  {
        //创建日期选择器
        let dataPicker = UIDatePicker()
        dataPicker.frame = CGRect(x:0, y:0, width:320, height:216)
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        dataPicker.locale = Locale(identifier: "zh_CN")
        dataPicker.datePickerMode = .dateAndTime // 显示形式
        dataPicker .addTarget(self, action: #selector(dataChange), for: UIControlEvents.valueChanged)
        self.view .addSubview(dataPicker)
    }
    
    func dataChange(picker:UIDatePicker)  {
        
        // 更新提醒时间文本框
        let formatter = DateFormatter()
        
        // 日期形式
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print(formatter.string(from: picker.date))
        
    }
    
    
    func setCountDownTimer()  {
        ctimer = UIDatePicker()
        ctimer.frame = CGRect(x:0, y:250, width:320, height:216)
        self.ctimer.datePickerMode = UIDatePickerMode.countDownTimer
        
        // 设置时间 必须为60的整倍数，如果是100，则自动改为60
//        self.ctimer.countDownDuration = TimeInterval(leftTime) 改方法会导致第一次修改时间没有触发事件
        DispatchQueue.main.async{
            self.ctimer.countDownDuration = TimeInterval(self.leftTime)
        }
        ctimer .addTarget(self, action: #selector(timeChange), for: .valueChanged)
        self.view.addSubview(ctimer)
        
        btnStar = UIButton()
        btnStar.frame = CGRect(x:120, y:500, width:100, height:100)
        btnStar.setTitle("开始", for: .normal)
        btnStar.setTitle("倒计时中...", for: UIControlState.disabled)
        btnStar.setTitleColor(UIColor.red, for: .normal)
        btnStar.setTitleColor(UIColor.blue, for: .disabled)
        
        btnStar.clipsToBounds = true
        btnStar.layer.cornerRadius = 5
        btnStar .addTarget(self, action: #selector(startClicked), for: .touchUpInside)
        self.view .addSubview(btnStar)
    }

    func timeChange()  {
         print("您选择倒计时间为：\(self.ctimer.countDownDuration)")
    }
    
    func startClicked(sender:UIButton)
    {
        // 获取该倒计时器的剩余时间
        leftTime = Int(self.ctimer.countDownDuration)
        
        // 禁止控件和按钮
        self.btnStar.isEnabled = false
        self.ctimer.isEnabled = false
        
        // 创建警告窗
        alertController = UIAlertController.init(title: "系统提示", message: "倒计时开始，还有\(leftTime)秒", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
        alertController .addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        // 启用计时器，控制每秒执行一次tickDown方法
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
    }
    
    
    // 计时器每秒触发事件
    func tickDown() {
        alertController.message = "倒计时开始，还有 \(leftTime) 秒..."
        
        // 将剩余时间减少1秒
        leftTime -= 1
        
        // 修改UIDatePicker的剩余时间
        self.ctimer.countDownDuration = TimeInterval(leftTime)
        print(leftTime)
        
        // 如果时间小于 等于 0 
        if leftTime <= 0 {
            // 取消定时器
            timer.invalidate()
            
            // 启用UIDatePicker控件和按钮
            self.ctimer.isEnabled = true;
            self.btnStar.isEnabled = true;
            alertController.message = "时间到！"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

