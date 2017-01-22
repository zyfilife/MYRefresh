//
//  MYRefreshNormalHeader.swift
//  SmartCloud
//
//  Created by 朱益锋 on 2017/1/20.
//  Copyright © 2017年 SmartPower. All rights reserved.
//

import UIKit

class MYRefreshNormalHeader: MYRefreshStateHeader {
    
    lazy var arrowView: UIImageView = {
        return UIImageView(image: UIImage.my_image(named: "arrow.png"))
    }()
    
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .white {
        didSet {
            self.loadingView?.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    lazy var loadingView: UIActivityIndicatorView? = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorViewStyle)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    override var state: MYRefreshState {
        didSet {
            switch self.state {
            case .idle:
                if oldValue == .refreshing {
                    self.arrowView.transform = CGAffineTransform.identity
                    UIView.animate(withDuration: kMYRefreshSlowAnimationDuration, animations: { 
                        self.loadingView?.alpha = 0.0
                    }, completion: { (finished) in
                        if self.state != .idle {
                            return
                        }
                        self.loadingView?.alpha = 1.0
                        self.loadingView?.stopAnimating()
                        self.arrowView.isHidden = false
                    })
                }else {
                    self.loadingView?.stopAnimating()
                    self.arrowView.isHidden = false
                    UIView.animate(withDuration: kMYRefreshFastAnimationDuration, animations: { 
                        self.arrowView.transform = CGAffineTransform.identity
                    }, completion: nil)
                }
            case .pulling:
                self.loadingView?.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(withDuration: kMYRefreshFastAnimationDuration, animations: { 
                    self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(M_PI))
                })
            case .refreshing:
                self.loadingView?.alpha = 1.0
                self.loadingView?.startAnimating()
                self.arrowView.isHidden = true
            default:
                break
            }
        }
    }
    
    override init(frame: CGRect, withBlock refreshingBlock: @escaping MYRefreshComponentRefreshingBlock) {
        super.init(frame: frame, withBlock: refreshingBlock)
        self.refreshingBlock = refreshingBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        if self.loadingView != nil {
            self.addSubview(self.loadingView!)
        }
        self.addSubview(self.arrowView)
        self.activityIndicatorViewStyle = .gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        var arrowCenterX = self.frame.size.width/2
        if !self.stateLabel.isHidden {
            arrowCenterX -= 100
        }
        let arrowCenterY = self.frame.size.height/2
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        if self.arrowView.constraints.count == 0 {
            if self.arrowView.image != nil {
                self.arrowView.frame.size = self.arrowView.image!.size
            }
            self.arrowView.center = arrowCenter
        }
        if self.loadingView?.constraints.count == 0 {
            self.loadingView?.center = arrowCenter
        }
    }
}
