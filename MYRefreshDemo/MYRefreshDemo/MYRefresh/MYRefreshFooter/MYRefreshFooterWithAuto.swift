//
//  MYRefreshFooterWithAuto.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/23.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class MYRefreshFooterWithAuto: MYRefreshFooter {
    
    var triggerAutomaticallyRefreshPercent: CGFloat = 0.0
    
    var autoRefresh = false
    
    override var isHidden: Bool {
        didSet {
            if !oldValue && self.isHidden {
                self.state = .idle
                self.scrollView.contentInset.bottom -= self.frame.size.height
            }else if oldValue && !self.isHidden {
                self.scrollView.contentInset.bottom += self.frame.size.height
                self.frame.origin.y = self.scrollView.contentSize.height
            }
        }
    }
    
    override var state: MYRefreshState {
        didSet {
            switch self.state {
            case .refreshing:
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: { 
                    self.executeRefreshingCallback()
                })
            case .noMoreData, .idle:
                if oldValue == .refreshing {
                    self.endRefreshingCompletionBlock?()
                }
            default:
                break
            }
        }
    }

    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview != nil {
            if !self.isHidden {
                self.scrollView.contentInset.bottom += self.refreshFooterHeight
            }
            self.frame.origin.y = self.scrollView.contentSize.height
        }else {
            if self.isHidden {
                self.scrollView.contentInset.bottom -= self.refreshFooterHeight
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        self.triggerAutomaticallyRefreshPercent = 1.0
        self.autoRefresh = true
    }
    
    override func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change: change)
        self.frame.origin.y = self.scrollView.contentSize.height
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        if self.state != .idle || !self.autoRefresh || self.frame.origin.y == 0 {
            return
        }
        if self.scrollView.contentInset.top + self.scrollView.contentSize.height > self.scrollView.frame.size.height {
            if self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.frame.size.height + self.frame.size.height * self.triggerAutomaticallyRefreshPercent + self.scrollView.contentInset.bottom - self.frame.size.height {
                if let old = change?[NSKeyValueChangeKey.oldKey] as? CGPoint,
                    let new = change?[NSKeyValueChangeKey.newKey] as? CGPoint {
                    if new.y <= old.y {
                        return
                    }
                    self.beginRefreshing()
                }
            }
        }
    }
    
    override func scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change: change)
        if self.state != .idle {
            return
        }
        if self.scrollView.panGestureRecognizer.state == .ended {
            if self.scrollView.contentInset.top + self.scrollView.contentSize.height <= self.scrollView.frame.size.height {
                if self.scrollView.contentOffset.y >= -self.scrollView.contentInset.top {
                    self.beginRefreshing()
                }
            }else {
                if self.scrollView.contentOffset.y >= self.scrollView.contentSize.height + self.scrollView.contentInset.bottom - self.scrollView.frame.size.height {
                    self.beginRefreshing()
                }
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
