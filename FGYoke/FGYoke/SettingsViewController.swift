//
//  SettingsViewController.swift
//  FGYoke
//
//  Created by 梁思地 on 10/29/16.
//  Copyright © 2016 梁思地. All rights reserved.
//

import UIKit
var acipaddre:String = ""
var acport:Int?


class SettingsViewController: UIViewController {
    @IBOutlet weak var statelabel: UILabel!

    @IBOutlet weak var iplabel: UILabel!
    
    @IBOutlet weak var portlabel: UILabel!
    
    @IBOutlet weak var ipinput: UITextField!
    
    @IBOutlet weak var portinput: UITextField!
    
    @IBOutlet weak var savebutton: UIButton!
    
    @IBAction func saveSettings(_ sender: UIButton) {
        iplabel.text = "IP:" + acipaddre
        portlabel.text = "Port端口:" + (String)(describing: acport)
        acipaddre = self.ipinput.text!
        acport = Int(self.portinput.text!)

    }
            @IBAction func ipinputed(_ sender: UITextField) {
        acipaddre = self.ipinput.text!
    }
    
    @IBAction func portinputed(_ sender: UITextField) {
        acport = Int(self.portinput.text!)

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iplabel.text = "IP:" + acipaddre
        portlabel.text = "Port端口:" + (acport?.description)!
                      // Do any additional setup after loading the view.
    }
    @IBAction func close(){
        dismiss(animated: true, completion: nil); }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
