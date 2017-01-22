//
//  MYRefreshComponent.swift
//  SmartCloud
//
//  Created by 朱益锋 on 2017/1/19.
//  Copyright © 2017年 SmartPower. All rights reserved.
//

import UIKit

enum MYRefreshState {
    case idle
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}

typealias MYRefreshComponentRefreshingBlock = ()->Void

class MYRefreshComponent: UIView {
    
    var state = MYRefreshState.idle
    
    var scrollView: UIScrollView!
    
    var scrollViewOriginalInset: UIEdgeInsets!
    
    var pan: UIPanGestureRecognizer?
    
    var refreshingBlock: MYRefreshComponentRefreshingBlock?
    
    var pullingPercent: CGFloat = 0.0 {
        didSet {
            if self.isRefreshing {
                return
            }
            if self.automaticallyChangeAlpha {
                self.alpha = self.pullingPercent
            }
        }
    }
    
    var isRefreshing: Bool {
        return self.state == .refreshing || self.state == .willRefresh
    }
    
    var automaticallyChangeAlpha: Bool = false {
        didSet {
            if self.isRefreshing {
                return
            }
            if self.automaticallyChangeAlpha {
                self.alpha = self.pullingPercent
            }else {
                self.alpha = 1.0
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
        self.state = .idle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.placeSubviews()
    }
    
    func placeSubviews() {
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let superview = newSuperview else {
            return
        }
        
        if !superview.isKind(of: UIScrollView.self) {
            return
        }
        
        self.removeObservers()
        
        self.frame.size.width = superview.frame.size.width
        
        self.frame.origin.x = 0
        
        self.scrollView = superview as! UIScrollView
        
        self.scrollView.alwaysBounceVertical = true
        
        self.scrollViewOriginalInset = self.scrollView.contentInset
        
        self.addObservers()
    }
    
    func addObservers() {
        
        guard let scrollView = self.scrollView else {
            return
        }
        
        scrollView.addObserver(self, forKeyPath: kMYRefreshKeyPathContentOffset, options: ([.new, .old]), context: nil)
        scrollView.addObserver(self, forKeyPath: kMYRefreshKeyPathContentSize, options: ([.new, .old]), context: nil)
        
        self.pan = scrollView.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: kMYRefreshKeyPathPanState, options: ([.new, .old]), context: nil)
    }
    
    func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: kMYRefreshKeyPathContentOffset)
        self.superview?.removeObserver(self, forKeyPath: kMYRefreshKeyPathContentSize)
        self.pan?.removeObserver(self, forKeyPath: kMYRefreshKeyPathPanState)
        self.pan = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !self.isUserInteractionEnabled {
            return
        }
        
        if keyPath == kMYRefreshKeyPathContentSize {
            self.scrollViewContentSizeDidChange(change: change)
        }
        
        if self.isHidden {
            return
        }
        
        if keyPath == kMYRefreshKeyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change: change)
        }else if keyPath == kMYRefreshKeyPathPanState {
            self.scrollViewPanStateDidChange(change: change)
        }
    }
    
    func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
    }
    
    func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
    }
    
    func scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
    }
}

// MARK: - RefreshAction
extension MYRefreshComponent {
    
    func executeRefreshingCallback() {
        DispatchQueue.main.async { 
            self.refreshingBlock?()
        }
    }
    
    func beginRefreshing() {
        UIView.animate(withDuration: kMYRefreshFastAnimationDuration) { 
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0
        if self.window != nil {
            self.state = .refreshing
        }else {
            self.state = .willRefresh
            self.setNeedsDisplay()
        }
    }
    
    func endRefreshing() {
        self.state = .idle
    }
}

extension UILabel {
    class func my_refreshLabel() -> UILabel {
        let label = UILabel()
        label.font = kMYRefreshLabelFont
        label.textColor = KMYRefreshLabelTextColor
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
}

extension UIImage {
    class func my_image(named: String) -> UIImage? {
        return UIImage(named: "MYRefresh.bundle/\(named)")
        
    }
}

extension DispatchTime {
    
    init(seconds: UInt64) {
        self = DispatchTime(uptimeNanoseconds: seconds*NSEC_PER_SEC)
    }
}
