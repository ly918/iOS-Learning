//
//  MyTableViewController.swift
//  autoLayoutTest2
//
//  Created by LY on 15/4/19.
//  Copyright (c) 2015年 YQC. All rights reserved.

import UIKit

class MyTableViewController: UITableViewController {
    
    var labelArray = Array<String>() // 用于存储 label 文字内容
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "firstTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "firstTableViewCell")
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 循环生成 label 文字内容
        for i in 1...10 {
            var text = ""
            for j in 1...i {
                text += "Auto Layout Layout"
            }
            labelArray.append(text)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("firstTableViewCell", forIndexPath: indexPath) as! firstTableViewCell
        
        cell.firstLabel.text = labelArray[indexPath.row]
        
        var image = UIImage(named: (indexPath.row % 3).description)!
        if image.size.width > 80 {
            image = image.resizeToSize(CGSizeMake(80, image.size.height * (80 / image.size.width)))
        }
        cell.logoImageView.image = image
        
        return cell
    }
}
