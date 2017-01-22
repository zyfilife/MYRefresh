//
//  MYRefreshHeaderWithState.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/23.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class MYRefreshHeaderWithState: MYRefreshHeader {
    
    lazy var stateLabel: UILabel = {
        return UILabel.my_refreshLabel()
    }()
    
    lazy var stateTitels: [MYRefreshState: String] = {
        return [MYRefreshState: String]()
    }()
    
    override var state: MYRefreshState {
        didSet {
            self.stateLabel.text = self.stateTitels[self.state]
        }
    }
    
    func setTitle(title: String, forState state: MYRefreshState) {
        self.stateTitels[state] = title
        self.stateLabel.text = self.stateTitels[self.state]
    }
    
    override func prepare() {
        super.prepare()
        self.refreshHeaderHeight = 36
        self.addSubview(self.stateLabel)
        self.setTitle(title: kMYRefreshHeaderIdleText, forState: MYRefreshState.idle)
        self.setTitle(title: kMYRefreshHeaderPullingText, forState: MYRefreshState.pulling)
        self.setTitle(title: kMYRefreshHeaderRefreshingText, forState: MYRefreshState.refreshing)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.stateLabel.frame = self.bounds
    }
}
