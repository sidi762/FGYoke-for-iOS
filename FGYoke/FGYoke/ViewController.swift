//
//  ViewController.swift
//  FGYoke
//
//  Created by 梁思地 on 10/20/16.
//  Copyright © 2016 梁思地 FGPRC. All rights reserved.
//

//bug记录：未完成点击保存时ip与port输入框是否为空判定√
//        未完成连接时ip与port是否有值的判定?√
//        开关有时不自动弹回√
//        !!!!无法连接！！！！√
//todo: 校准√
//      增加开关图片√
//      增加更多用户提示
//      增加尾舵支持
import UIKit
import CoreData
import CoreMotion
import CocoaAsyncSocket

var isConnected:Bool = false
var isWorking:Bool = false
var xdata:Double = 0.0
var ydata:Double = 0.0
var calibrateDataX:Double = 0.0
var calibrateDataY:Double = 0.0
var isAcWorking = false
var debugInfoText = "nothing"
class ViewController: UIViewController,GCDAsyncSocketDelegate  {

    @IBOutlet weak var debugInfo: UILabel!
    @IBOutlet weak var yokepic: UIImageView!
    @IBOutlet weak var xlabel: UILabel!
    @IBOutlet weak var ylabel: UILabel!
    @IBOutlet weak var zlabel: UILabel!
    @IBOutlet weak var calibrateButton: UIButton!
    @IBOutlet weak var swichButton: UIButton!
//  @IBOutlet weak var testbut: UIButton!
   
    var cmm = CMMotionManager()
//    var client:TCPClient = TCPClient() //旧Socket
    var clientSocket:GCDAsyncSocket!

   
//    @IBAction func testconnect(_ sender: UIButton) {
//        connect(addre: "localhost", portt: 12345)
//    }
    
    func swichIsOff(){
        swichButton.setImage(#imageLiteral(resourceName: "swichoff.png"), for: UIControlState.normal)
    }
    
    func swichIsOn(){
        swichButton.setImage(#imageLiteral(resourceName: "swichon.png"), for: UIControlState.normal)
    }
    
    func swichIsTriped(){
        swichIsOff()
        swichIsOn()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
        self.swichIsOff()

        })
        

        
        
    }
    
    override func viewDidLoad() {
        isConnected = false
        super.viewDidLoad()
        cmm = CMMotionManager()
        yokepic.isHidden = true
        calibrateButton.isHidden=true
        debugInfo.isHidden = true
        }
    
    
    func startWorking(){
        clientSocket = GCDAsyncSocket()
        clientSocket.delegate = self
        clientSocket.delegateQueue = DispatchQueue.global()
        do{
            try clientSocket.connect(toHost: acipaddre, onPort: (UInt16)(acport!), viaInterface: nil, withTimeout: 2)
            isConnected = true

        }catch{
            print("error")
            stopWorking()
            isConnected = false
            
            }
        if(clientSocket.isDisconnected == false){
        print("success")
        self.yokepic.isHidden = false
        swichIsOn()
        mainActivity()
        isWorking = true
        debugInfoText = "success to connect"
        self.debugInfo.text = debugInfoText
        }
        


        
//        client = TCPClient(addr: acipaddre, port: acport!)
//        var (success, errmsg) = client.connect(timeout: 2)
//        if success {
//            print("success")
//            debugInfoText = "success to connect"
//            isConnected = true
//            self.yokepic.isHidden = false
//            swichIsOn()
//            mainActivity()
//            isWorking = true
//            self.debugInfo.text = debugInfoText
//        } else {
//            print(errmsg)
//            debugInfoText = errmsg
//            stopWorking()
//            
//            
//        }
//
    }
    
    func stopWorking(){
        yokepic.isHidden = true
        calibrateButton.isHidden = true
        swichIsTriped()
//        client.close()
        clientSocket?.disconnect()
        isConnected = false
        isWorking = false
        self.debugInfo.text = debugInfoText
    }
    
    @IBAction func switchMoved(_ sender: UIButton) {
        if(devModeState == true){
            self.debugInfo.isHidden = false
        }else{
            self.debugInfo.isHidden = true
        }
            if(isWorking==false){
            if(acipaddre != ""){
                if(acport != nil){
                    startWorking()
                }else{
                    stopWorking()
                    }
            }else{
                stopWorking()
            }
                    }else{
             stopWorking()
            yokepic.isHidden = true

        }
        self.debugInfo.text = debugInfoText
           }
    
    @IBAction func calibrateStart(_ sender: UIButton) {
        if(isWorking){
        calibrateDataX = xdata
        calibrateDataY = ydata
        }
    }
    
    func mainActivity(){
        calibrateButton.isHidden = false
//        var accelerometerData="0"
//        var error="0"
        cmm.accelerometerUpdateInterval = 0.05
        if cmm.isAccelerometerAvailable{
            cmm.startAccelerometerUpdates(to: OperationQueue.main) {(accelerometerData:CMAccelerometerData?,error:Error?) in
                if error != nil{
                    self.cmm.stopAccelerometerUpdates()
                    }else{
                    //正常情况
                    isAcWorking = true
                    self.xlabel.text = "X:\(accelerometerData!.acceleration.x)"
                    self.ylabel.text = "Y:\(accelerometerData!.acceleration.y)"
                    self.zlabel.text = "Z:\(accelerometerData!.acceleration.z)"
                    xdata = accelerometerData!.acceleration.y
                    ydata = accelerometerData!.acceleration.z
                    if(devModeState == true){
                        self.debugInfo.isHidden = false
                    }else{
                        self.debugInfo.isHidden = true
                    }
                    self.debugInfo.text = debugInfoText
                    
                    //动画
                    let animx = CABasicAnimation(keyPath: "transform.rotation")
                    animx.toValue = (accelerometerData!.acceleration.y) * 90 * (M_PI / 180) - calibrateDataX * 90 * (M_PI / 180)
                    animx.duration = 0.3
                    animx.repeatCount = 1
                    animx.isRemovedOnCompletion = false
                    animx.fillMode = kCAFillModeForwards
                    self.yokepic.layer.add(animx, forKey: nil)
                    let animationz = CABasicAnimation(keyPath: "bounds.size")
                    animationz.fromValue = NSValue(cgSize: self.yokepic.frame.size)
                    let datasizeheight = self.yokepic.frame.size.height+CGFloat(accelerometerData!.acceleration.z*100)-CGFloat(calibrateDataY*100)
                    let datasizewidth = self.yokepic.frame.size.width+CGFloat(accelerometerData!.acceleration.z*100)-CGFloat(calibrateDataY*100)
                    let size = CGSize(width: CGFloat(datasizewidth), height: CGFloat(datasizeheight))
                    animationz.toValue = NSValue(cgSize:(size))
                    animationz.duration = 0.01
                    animationz.isRemovedOnCompletion = false
                    animationz.fillMode = kCAFillModeForwards
                    self.yokepic.layer.add(animationz, forKey: nil)
                    //旧socket发送至FG
//                    let (success, errmsg) = self.client.send(str:"\((Float)(accelerometerData!.acceleration.y)-(Float)(calibrateDataX)),\((Float)(-accelerometerData!.acceleration.z)+(Float)(calibrateDataY))\n")
//                    if success {
//                        print("success")
//                        debugInfoText = "success to connect"
//                    } else {
//                        print(errmsg)
//                        debugInfoText = errmsg
//                    }
                    //新socket发送
                    let sentData = "\((Float)(accelerometerData!.acceleration.y)-(Float)(calibrateDataX)),\((Float)(-accelerometerData!.acceleration.z)+(Float)(calibrateDataY))\n"
                    self.clientSocket?.write(sentData.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withTimeout: -1, tag: 0)
                    //判断是否断线
                    if(self.clientSocket.isConnected == false){
                        if(self.clientSocket.isDisconnected == true){
                        self.stopWorking()
                        self.cmm.stopAccelerometerUpdates()
                        }
                    }
                    

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
