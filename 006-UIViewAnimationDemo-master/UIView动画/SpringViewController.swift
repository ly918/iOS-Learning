//
//  SpringViewController.swift
//  UIView动画
//
//  Created by 米明 on 15/6/19.
//  Copyright (c) 2015年 米明. All rights reserved.
//

import UIKit

class SpringViewController: UIViewController {

    @IBOutlet weak var blueSquare: UIView!
    
    @IBOutlet weak var greenSquare: UIView!
    
    @IBOutlet weak var orangeSquare: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //线性效果
        UIView.animateWithDuration(1, animations: {
            self.blueSquare.center.x = self.view.bounds.size.width - self.blueSquare.center.x
        })
        
        
        /**
        弹簧效果
        */
        
        /**
        usingSprignWithDamping : 阻尼
        
        initialSpringVelocity : 初始速度
        */
        UIView.animateWithDuration(5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: nil, animations: {
            self.greenSquare.center.x = self.view.bounds.size.width - self.greenSquare.center.x
        }, completion: nil)
        
        UIView.animateWithDuration(5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 5, options: nil, animations: {
            self.orangeSquare.center.x = self.view.bounds.size.width - self.orangeSquare.center.x
            }, completion: nil)
        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
