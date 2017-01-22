//
//  TableViewController.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/23.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

enum MYRefreshHeaderType {
    case state, indicator, arrowView, lastTime
}

class TableViewController: UITableViewController {
    
    var type = MYRefreshHeaderType.state

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.type = .state
        case 1:
            self.type = .indicator
        case 2:
            self.type = .arrowView
        default:
            self.type = .lastTime
        }
        self.performSegue(withIdentifier: "segueTableToTable", sender: self.type)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTableToTable" {
            if let destViewController = segue.destination as? ViewController {
                guard let type = sender as? MYRefreshHeaderType else {
                    return
                }
                destViewController.type = type
            }
        }
    }
    

}
