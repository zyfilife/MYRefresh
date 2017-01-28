//
//  MYRefreshHeaderWithLoadingView.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/25.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class MYRefreshHeaderWithLoadingView: MYRefreshHeaderWithState {
    
    lazy var loadingView: MYLoadingView = {
        return MYLoadingView(lineColor: UIColor(white:0.3,alpha:0.9))
    }()
    
    override var state: MYRefreshState {
        didSet {
            switch self.state {
            case .idle:
                self.loadingView.stopAnimating()
            case .pulling:
                self.loadingView.stopAnimating()
            case .refreshing:
                self.loadingView.startAnimating()
            default:
                break
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        self.customNormalPullingOffsetY = -60
        self.addSubview(self.loadingView)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.loadingView.sizeToFit()
        var loadingCenterX = self.frame.size.width/2
        if !self.stateLabel.isHidden {
            loadingCenterX -= 80
        }
        let loadingCenterY = self.frame.size.height/2
        let loadingCenter = CGPoint(x: loadingCenterX, y: loadingCenterY)
        if self.loadingView.constraints.count == 0 {
            self.loadingView.center = loadingCenter
        }
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        if self.state == .refreshing {
            self.loadingView.anglePer = 1
            return
        }
        if self.scrollView.contentOffset.y > -30 {
            self.loadingView.anglePer = 0.0001
        }else {
            self.loadingView.anglePer = -(self.scrollView.contentOffset.y-30)/(-self.customNormalPullingOffsetY+30)
        }
//        self.loadingView.anglePer = -self.scrollView.contentOffset.y/self.refreshHeaderHeight
    }

}
