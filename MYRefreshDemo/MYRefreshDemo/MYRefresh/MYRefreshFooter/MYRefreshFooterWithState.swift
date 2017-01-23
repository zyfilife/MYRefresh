//
//  MYRefreshFooterWithState.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/23.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class MYRefreshFooterWithState: MYRefreshFooterWithAuto {

    lazy var stateLabel: UILabel = {
        return UILabel.my_refreshLabel()
    }()
    
    override var state: MYRefreshState {
        didSet {
            if self.isRefreshingTitleHidden && self.state == .refreshing {
                self.stateLabel.text = nil
            }else {
                self.stateLabel.text = self.stateTitels[self.state]
            }
        }
    }
    
    lazy var stateTitels: [MYRefreshState: String] = {
        return [MYRefreshState: String]()
    }()
    
    var isRefreshingTitleHidden = false
    
    override func prepare() {
        super.prepare()
        self.refreshFooterHeight = 44
        self.addSubview(self.stateLabel)
        self.setTitle(title: kMYRefreshAutoFooterIdleText, forState: MYRefreshState.idle)
        self.setTitle(title: kMYRefreshAutoFooterRefreshingText, forState: MYRefreshState.refreshing)
        self.setTitle(title: kMYRefreshAutoFooterNoMoreDataText, forState: MYRefreshState.noMoreData)
        let tap = UITapGestureRecognizer(target: self, action: #selector(MYRefreshFooterWithState.clickFooterAction))
        self.stateLabel.addGestureRecognizer(tap)
        self.stateLabel.isUserInteractionEnabled = true
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.stateLabel.frame = self.bounds
    }
    
    func setTitle(title: String, forState state: MYRefreshState) {
        self.stateTitels[state] = title
        self.stateLabel.text = self.stateTitels[self.state]
    }
    
    func clickFooterAction() {
        if self.state == .idle {
            self.beginRefreshing()
        }
    }
}
