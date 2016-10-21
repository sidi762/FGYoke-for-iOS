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
        cmm.accelerometerUpdateInterval = 0.05
        if cmm.isAccelerometerAvailable{
            cmm.startAccelerometerUpdates(to: OperationQueue.main) {(accelerometerData:CMAccelerometerData?,error:Error?) in
                if error != nil{
                    self.cmm.stopAccelerometerUpdates()
                }else{
                    self.xlabel.text = "X:\(accelerometerData!.acceleration.x)"
                    self.ylabel.text = "Y:\(accelerometerData!.acceleration.y)"
                    self.zlabel.text = "Z:\(accelerometerData!.acceleration.z)"
                    let animx = CABasicAnimation(keyPath: "transform.rotation")
                    animx.toValue = (accelerometerData!.acceleration.y) * 90 * (M_PI / 180)
                    animx.duration = 0.3
                    animx.repeatCount = 1
                    animx.isRemovedOnCompletion = false
                    animx.fillMode = kCAFillModeForwards
                    self.yokepic.layer.add(animx, forKey: nil)

                }
            }}else{
            let aler = UIAlertView(title:"您的设备不支持加速度传感器 Your device doesn't support accelerometer", message:nil,delegate:nil ,cancelButtonTitle:"OK")
            aler.show()
              xlabel.text="error"
              ylabel.text="error"
              zlabel.text="error"
              let animxer = CABasicAnimation(keyPath: "transform.rotation")
              animxer.toValue = 0.9 * 90 * (M_PI / 180)
              animxer.repeatCount = 1
              animxer.duration = 0.01
              animxer.isRemovedOnCompletion = false
              animxer.fillMode = kCAFillModeForwards
              self.yokepic.layer.add(animxer, forKey: nil)

            }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
