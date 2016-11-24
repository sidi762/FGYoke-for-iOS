//
//  ViewController.swift
//  FGYoke
//
//  Created by 梁思地 on 10/20/16.
//  Copyright © 2016 梁思地 FGPRC. All rights reserved.
//

//bug记录：未完成点击保存时ip与port输入框是否为空判定?
//        未完成连接时ip与port是否有值的判定?
//todo: 校准

import UIKit
import CoreData
import CoreMotion
var isConnected:Bool = false
var isWorking:Bool = false

class ViewController: UIViewController {

    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var yokepic: UIImageView!
    @IBOutlet weak var xlabel: UILabel!
    @IBOutlet weak var testbut: UIButton!
    @IBOutlet weak var ylabel: UILabel!
    @IBOutlet weak var zlabel: UILabel!
   
    var cmm = CMMotionManager()
    var client:TCPClient = TCPClient()

//    @IBAction func testconnect(_ sender: UIButton) {
//        connect(addre: "localhost", portt: 12345)
//    }
    

    override func viewDidLoad() {
        isConnected = false
        super.viewDidLoad()
        cmm = CMMotionManager()
        yokepic.isHidden = true
        }
    
    func startWorking(){
        client = TCPClient(addr: acipaddre, port: acport!)
        var (success, errmsg) = client.connect(timeout: 1)
        if success {
            print("success")
            isConnected = true
            self.yokepic.isHidden = false
            mainActivity()
        } else {
            print(errmsg)
            stopWorking()
            
            
        }

    }
    
    func stopWorking(){
        yokepic.isHidden = true
        `switch`.isOn = false
        client.close()
        isConnected = false
    }
    
    @IBAction func switchMoved(_ sender: UISwitch) {
        if(isWorking==false){
            if(acipaddre != ""){
                if(acport != nil){
                    startWorking()

                    }
                }
                    }else{
             stopWorking()
            yokepic.isHidden = true

        }
           }
    
    
    func mainActivity(){
        var accelerometerData="0"
        var error="0"
        cmm.accelerometerUpdateInterval = 0.05
        if cmm.isAccelerometerAvailable{
            cmm.startAccelerometerUpdates(to: OperationQueue.main) {(accelerometerData:CMAccelerometerData?,error:Error?) in
                if error != nil{
                    self.cmm.stopAccelerometerUpdates()
                }else{
                    
                    //正常情况
                    self.xlabel.text = "X:\(accelerometerData!.acceleration.x)"
                    self.ylabel.text = "Y:\(accelerometerData!.acceleration.y)"
                    self.zlabel.text = "Z:\(accelerometerData!.acceleration.z)"
                    //动画
                    let animx = CABasicAnimation(keyPath: "transform.rotation")
                    animx.toValue = (accelerometerData!.acceleration.y) * 90 * (M_PI / 180)
                    animx.duration = 0.3
                    animx.repeatCount = 1
                    animx.isRemovedOnCompletion = false
                    animx.fillMode = kCAFillModeForwards
                    self.yokepic.layer.add(animx, forKey: nil)
                    let animationz = CABasicAnimation(keyPath: "bounds.size")
                    animationz.fromValue = NSValue(cgSize: self.yokepic.frame.size)
                    let datasizeheight = self.yokepic.frame.size.height+CGFloat(accelerometerData!.acceleration.z*100)
                    let datasizewidth = self.yokepic.frame.size.width+CGFloat(accelerometerData!.acceleration.z*100)
                    let size = CGSize(width: CGFloat(datasizewidth), height: CGFloat(datasizeheight))
                    animationz.toValue = NSValue(cgSize:(size))
                    animationz.duration = 0.01
                    animationz.isRemovedOnCompletion = false
                    animationz.fillMode = kCAFillModeForwards
                    self.yokepic.layer.add(animationz, forKey: nil)
                    //发送至FG
                    let (success, errmsg) = self.client.send(str:"\((Float)(accelerometerData!.acceleration.y)),\((Float)(-accelerometerData!.acceleration.z))\n")
                    if success {
                        print("success")
                    } else {
                        print(errmsg)
                    }

                                        //test
//                    let client:TCPClient = TCPClient(addr: "10.0.8.201", port: 12345)
//                    var (success, errmsg) = client.connect(timeout: 1)
//                    client.send(str:"\(accelerometerData!.acceleration.y),\(accelerometerData!.acceleration.z)")
                }
            }
                        }else{
            //无加速度传感器
            let aler = UIAlertView(title:"您的设备不支持加速度传感器 Your device doesn't support accelerometer",message:nil,delegate:nil ,cancelButtonTitle:"OK")
            aler.show()
              xlabel.text="error"
              ylabel.text="error"
              zlabel.text="error"
              let animxer = CABasicAnimation(keyPath: "transform.rotation")
              animxer.toValue = 0.9 * 90 * (M_PI / 180)
              animxer.repeatCount = 1
              animxer.duration = 0.001
              animxer.isRemovedOnCompletion = false
              animxer.fillMode = kCAFillModeForwards
              self.yokepic.layer.add(animxer, forKey: nil)
              let animationzer = CABasicAnimation(keyPath: "bounds.size")
              animationzer.fromValue = NSValue(cgSize: self.yokepic.frame.size)
              let size = CGSize(width: 100, height: 100)
              animationzer.toValue = NSValue(cgSize:(size))
              animationzer.duration = 0.01
              animationzer.isRemovedOnCompletion = false
              animationzer.fillMode = kCAFillModeForwards
            self.yokepic.layer.add(animationzer, forKey: nil)

            }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
