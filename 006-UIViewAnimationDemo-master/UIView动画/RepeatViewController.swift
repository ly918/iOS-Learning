//
//  RepeatViewController.swift
//  UIView动画
//
//  Created by 米明 on 15/6/17.
//  Copyright (c) 2015年 米明. All rights reserved.
//

import UIKit

class RepeatViewController: UIViewController {

    @IBOutlet weak var greenSquare: UIView!
    
    @IBOutlet weak var brownSquare: UIView!
    
    @IBOutlet weak var blueSquare: UIView!
    
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
            
            self.greenSquare.center.x = self.view.bounds.width - self.greenSquare.center.x
            
        })
        
        UIView.animateWithDuration(1, delay: 0, options:.Repeat, animations: {
            self.brownSquare.center.x = self.view.bounds.width - self.brownSquare.center.x
        }, completion: nil)
        
        
        UIView.animateWithDuration(1, delay: 0, options: .Repeat | .Autoreverse, animations: {
            self.blueSquare.center.x = self.view.bounds.width - self.blueSquare.center.x
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
