//
//  ViewController.swift
//  FGYoke
//
//  Created by 梁思地 on 10/20/16.
//  Copyright © 2016 梁思地. All rights reserved.
//

import UIKit
import CoreData
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var yokepic: UIImageView!
    @IBOutlet weak var xlabel: UILabel!
    @IBOutlet weak var ylabel: UILabel!
    @IBOutlet weak var zlabel: UILabel!
    var cmm = CMMotionManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cmm = CMMotionManager()
        mainActivity()
    }
   
    func mainActivity(){
        var accelerometerData="0"
        var error="0"
        cmm.accelerometerUpdateInterval = 0.1
        if cmm.isAccelerometerAvailable{
            cmm.startAccelerometerUpdates(to: OperationQueue.main) {(accelerometerData:CMAccelerometerData?,error:Error?) in
                if error != nil{
                    self.cmm.stopAccelerometerUpdates()
                }else{
                    self.xlabel.text = "X:\(accelerometerData!.acceleration.x)"
                    self.ylabel.text = "X:\(accelerometerData!.acceleration.y)"
                    self.zlabel.text = "X:\(accelerometerData!.acceleration.z)"
                }
            }}else{
            let aler = UIAlertView(title:"您的设备不支持加速度传感器 Your device doesn't support accelerometer", message:nil,delegate:nil ,cancelButtonTitle:"OK")
            aler.show()
              xlabel.text="error"
              ylabel.text="error"
              zlabel.text="error"
            }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
