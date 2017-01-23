//
//  MYRefreshFooterWithIndicator.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/23.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class MYRefreshFooterWithIndicator: MYRefreshFooterWithState {
    
    var loadingViewStyle = UIActivityIndicatorViewStyle.white {
        didSet {
            self.loadingView.activityIndicatorViewStyle = self.loadingViewStyle
        }
    }
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: self.loadingViewStyle)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    override var state: MYRefreshState {
        didSet {
            switch self.state {
            case .idle, .noMoreData:
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
        self.addSubview(self.loadingView)
        self.loadingViewStyle = .gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if self.loadingView.constraints.count > 0 {
            return
        }
        var loadingViewCenterX = self.frame.size.width/2
        if !self.isRefreshingTitleHidden {
            loadingViewCenterX -= self.stateLabel.textWidth()/2 + 25
        }
        let loadingViewCenterY = self.frame.size.height/2
        self.loadingView.center = CGPoint(x: loadingViewCenterX, y: loadingViewCenterY)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
