//
//  MYRefreshHeaderWithIndicator.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/23.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class MYRefreshHeaderWithIndicator: MYRefreshHeaderWithState {

    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .white {
        didSet {
            self.loadingView.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorViewStyle)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    override var state: MYRefreshState {
        didSet {
            switch self.state {
            case .idle:
                if oldValue == .refreshing {
                    UIView.animate(withDuration: kMYRefreshSlowAnimationDuration, animations: {
                        self.loadingView.alpha = 0.0
                    }, completion: { (finished) in
                        if self.state != .idle {
                            return
                        }
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                    })
                }else {
                    self.loadingView.stopAnimating()
                }
            case .pulling:
                self.loadingView.stopAnimating()
            case .refreshing:
                self.loadingView.alpha = 1.0
                self.loadingView.startAnimating()
            default:
                break
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        self.addSubview(self.loadingView)
        self.activityIndicatorViewStyle = .gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
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

}
