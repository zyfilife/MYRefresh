//
//  ViewController.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/22.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var numberOfRows = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = MYRefreshNormalHeader(frame: CGRect.zero, withBlock: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: { 
                self.numberOfRows = 5
                self.tableView.reloadData()
                self.tableView.my_header?.endRefreshing()
            })
        })
        self.tableView.my_header = header
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
        cell.textLabel?.text = "这是第\(indexPath.row+1)个cell"
        return cell
    }


}

