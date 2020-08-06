//
//  EasingViewController.swift
//  UIView动画
//
//  Created by 米明 on 15/6/17.
//  Copyright (c) 2015年 米明. All rights reserved.
//

import UIKit

class EasingViewController: UIViewController {

    @IBOutlet weak var blueSquare: UIView!
    
    @IBOutlet weak var greenSquare: UIView!
    
    @IBOutlet weak var orangeSquare: UIView!
    
    @IBOutlet weak var redSquare: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear (animated)
        
        UIView.animateWithDuration(1, animations: {
            self.blueSquare.center.x = self.view.bounds.size.width - self.blueSquare.center.x
        })
        
        UIView.animateWithDuration(1, delay: 0, options: .CurveEaseIn, animations: {
            self.greenSquare.center.x = self.view.bounds.size.width - self.greenSquare.center.x
        }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0, options: .CurveEaseOut, animations: {
            self.orangeSquare.center.x = self.view.bounds.size.width - self.orangeSquare.center.x
            }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0, options: .CurveEaseInOut, animations: {
            self.redSquare.center.x = self.view.bounds.size.width - self.redSquare.center.x
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
