//
//  GuideViewController.swift
//  FGYoke
//
//  Created by 梁思地 on 1/08/17.
//  Copyright © 2016-2019 梁思地. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController,UIScrollViewDelegate {
 var numOfPages = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.bounds
        
        //更新提示
        let alert = UIAlertController(title: nil , message: "Welcome! This message indicates this software has been successfully updated. Don't forget to update your from_fgyoke.xml!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",style: .default,handler: nil)
                        alert.addAction(action)
                        present(alert,animated: true, completion: nil)
               
        
        //scrollView的初始化
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.delegate = self
        //为了能让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        scrollView.contentSize = CGSize(width:frame.size.width * CGFloat(numOfPages),
                                        height:frame.size.height)
        print("\(frame.size.width*CGFloat(numOfPages)),\(frame.size.height)")
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        for i in 0..<numOfPages{
            let imgfile = "Guide0\(Int(i+1)).png"
            print(imgfile)
            let image = UIImage(named:"\(imgfile)")
            let imgView = UIImageView(image: image)
            imgView.frame = CGRect(x:frame.size.width*CGFloat(i), y:CGFloat(0),
                                   width:frame.size.width, height:frame.size.height)
            scrollView.addSubview(imgView)
        }
        scrollView.contentOffset = CGPoint.zero
        self.view.addSubview(scrollView)
    }
    
    //scrollview滚动的时候就会调用
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        print("scrolled:\(scrollView.contentOffset)")
        let twidth = CGFloat(numOfPages-1) * self.view.bounds.size.width
        //如果在最后一个页面继续滑动的话就会跳转到主页面
        if(scrollView.contentOffset.x > twidth)
        {
            let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let viewController = mainStoryboard.instantiateInitialViewController()
            self.present(viewController!, animated: true, completion:nil)
        }
    

        // Do any additional setup after loading the view.
    }

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
