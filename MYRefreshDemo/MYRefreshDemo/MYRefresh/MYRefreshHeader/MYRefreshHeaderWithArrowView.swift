//
//  MYRefreshHeaderWithArrowView.swift
//  SmartCloud
//
//  Created by 朱益锋 on 2017/1/20.
//  Copyright © 2017年 SmartPower. All rights reserved.
//

import UIKit

class MYRefreshHeaderWithArrowView: MYRefreshHeaderWithIndicator {
    
    lazy var arrowView: UIImageView = {
        return UIImageView(image: UIImage.my_image(named: "arrow.png"))
    }()
    
    override var state: MYRefreshState {
        didSet {
            switch self.state {
            case .idle:
                if oldValue == .refreshing {
                    self.arrowView.transform = CGAffineTransform.identity
                    UIView.animate(withDuration: kMYRefreshSlowAnimationDuration, animations: { 
                        self.loadingView.alpha = 0.0
                    }, completion: { (finished) in
                        if self.state != .idle {
                            return
                        }
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    })
                }else {
                    self.loadingView.stopAnimating()
                    self.arrowView.isHidden = false
                    UIView.animate(withDuration: kMYRefreshFastAnimationDuration, animations: { 
                        self.arrowView.transform = CGAffineTransform.identity
                    }, completion: nil)
                }
            case .pulling:
                self.loadingView.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(withDuration: kMYRefreshFastAnimationDuration, animations: { 
                    self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(M_PI))
                })
            case .refreshing:
                self.loadingView.alpha = 1.0
                self.loadingView.startAnimating()
                self.arrowView.isHidden = true
            default:
                break
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        self.addSubview(self.arrowView)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if self.arrowView.constraints.count == 0 {
            if self.arrowView.image != nil {
                self.arrowView.frame.size = self.arrowView.image!.size
            }
            self.arrowView.center = self.loadingView.center
        }
    }
}
