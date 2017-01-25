//
//  ViewController.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/22.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var type: MYRefreshHeaderType = .state
    
    var numberOfRows = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var header: MYRefreshHeader!
        
        var footer: MYRefreshFooter!
        
        switch self.type {
        case .state:
            header = MYRefreshHeaderWithState(withBlock: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.numberOfRows = 5
                    self.tableView.reloadData()
                    self.endRefreshing()
                })
            })
            footer = MYRefreshFooterWithState(withBlock: { 
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.numberOfRows += 3
                    self.tableView.reloadData()
                    self.endRefreshing()
                })
            })
        case .indicator:
            header = MYRefreshHeaderWithIndicator(withBlock: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.numberOfRows = 5
                    self.tableView.reloadData()
                    self.endRefreshing()
                })
            })
            footer = MYRefreshFooterWithIndicator(withBlock: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.numberOfRows += 0
                    self.tableView.reloadData()
                    self.endRefreshing(showNoDataLabel: true)
                })
            })
        case .arrowView:
            header = MYRefreshHeaderWithArrowView(withBlock: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.numberOfRows = 5
                    self.tableView.reloadData()
                    self.endRefreshing()
                })
            })
            footer = MYRefreshFooterWithIndicator(withBlock: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.numberOfRows += 0
                    self.tableView.reloadData()
                    self.endRefreshing(showNoDataLabel: true)
                })
            })
        case .lastTime:
            header = MYRefreshHeaderWithLastTime(withBlock: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.numberOfRows = 5
                    self.tableView.reloadData()
                    self.endRefreshing()
                })
            })
            footer = MYRefreshFooterWithIndicator(withBlock: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.numberOfRows += 0
                    self.tableView.reloadData()
                    self.endRefreshing(showNoDataLabel: true)
                })
            })
        case .loadingView:
            header = MYRefreshHeaderWithLoadingView(withBlock: { 
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.numberOfRows = 5
                    self.tableView.reloadData()
                    self.endRefreshing()
                })
            })
        }
        
        self.title = "\(header.classForCoder)"
        
        self.tableView.my_header = header
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView.my_footer = footer
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func endRefreshing(showNoDataLabel: Bool=false) {
        if showNoDataLabel {
            self.tableView.my_footer?.endRefreshingWithNoMoreData()
        }else {
            self.tableView.my_footer?.endRefreshing()
        }
        self.tableView.my_header?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
        cell.textLabel?.text = "第\(indexPath.row+1)只🐸"
        return cell
    }
}

