//
//  ScaleViewController.swift
//  UIView动画
//
//  Created by 米明 on 15/6/17.
//  Copyright (c) 2015年 米明. All rights reserved.
//

import UIKit

class ScaleViewController: UIViewController {

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
        
        UIView.animateWithDuration(1, animations: {
              self.orangeSquare.transform = CGAffineTransformMakeScale(2, 2)
        })
      
        UIView.animateWithDuration(1, delay: 0.5, options: nil, animations: {
            
            self.orangeSquare.transform = CGAffineTransformMakeScale(0.3, 0.3)
            
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
