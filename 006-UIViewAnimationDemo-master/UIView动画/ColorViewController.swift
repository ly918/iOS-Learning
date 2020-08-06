//
//  ColorViewController.swift
//  UIView动画
//
//  Created by 米明 on 15/6/17.
//  Copyright (c) 2015年 米明. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    @IBOutlet weak var greenSquare: UIView!
    
    @IBOutlet weak var label: UILabel!
    
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
            
            self.greenSquare.backgroundColor = UIColor.redColor()
            
            self.label.textColor=UIColor.whiteColor()
            
        })
        
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
