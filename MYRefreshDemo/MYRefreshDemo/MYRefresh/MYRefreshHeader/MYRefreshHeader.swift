//
//  MYRefreshHeader.swift
//  SmartCloud
//
//  Created by 朱益锋 on 2017/1/19.
//  Copyright © 2017年 SmartPower. All rights reserved.
//

import UIKit

class MYRefreshHeader: MYRefreshComponent {
    
    var lastUpdatedTimeKey: String!
    
    var ignoredScrollViewContentInsetTop: CGFloat = 0.0
    
    var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as? Date
    }
    
    var insetTopDelta: CGFloat = 0.0
    
    override var state: MYRefreshState {
        didSet {
            switch self.state {
            case .idle:
                if oldValue != .refreshing {
                    return
                }
//                assert(self.lastUpdatedTimeKey == nil, "self.lastUpdatedTimeKey == nil")
                UserDefaults.standard.set(Date(), forKey: self.lastUpdatedTimeKey)
                UserDefaults.standard.synchronize()
                UIView.animate(withDuration: kMYRefreshSlowAnimationDuration, animations: { 
                    self.scrollView.contentInset.top += self.insetTopDelta
                    if self.automaticallyChangeAlpha {
                        self.alpha = 0.0
                    }
                }, completion: { (finished) in
                    self.pullingPercent = 0.0
                })
            case .refreshing:
                UIView.animate(withDuration: kMYRefreshFastAnimationDuration, animations: { 
                    let top = self.scrollViewOriginalInset.top + self.frame.size.height
                    self.scrollView.contentInset.top = top
                    self.scrollView.contentOffset.y = -top
                }, completion: { (finished) in
                    self.executeRefreshingCallback()
                })
            default:
                break
            }
        }
    }
    
    init(frame: CGRect, withBlock refreshingBlock: @escaping MYRefreshComponentRefreshingBlock) {
        super.init(frame: frame)
        self.refreshingBlock = refreshingBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        self.lastUpdatedTimeKey = kMYRefreshHeaderLastUpdatedTimeKey
        
        self.frame.size.height = kMYRefreshHeaderHeight
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.frame.origin.y = -self.frame.size.height - self.ignoredScrollViewContentInsetTop
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        guard let scrollView = self.scrollView else {
            return
        }
        guard let scrollViewOriginalInset = self.scrollViewOriginalInset else {
            return
        }
        
        if self.state == .refreshing {
            if self.window == nil {
                return
            }
            
            var insetTop = max(-scrollView.contentOffset.y, scrollViewOriginalInset.top)
            insetTop = min(insetTop, self.frame.size.height + scrollViewOriginalInset.top)
            scrollView.contentInset.top = insetTop
            self.insetTopDelta = scrollViewOriginalInset.top - insetTop
            return
        }
        
        self.scrollViewOriginalInset = self.scrollView?.contentInset
        
        let offsetY = scrollView.contentOffset.y
        let happenOffsetY = -scrollViewOriginalInset.top
        
        if offsetY > happenOffsetY {
            return
        }
        
        let normalPullingOffsetY = happenOffsetY - self.frame.size.height
        let pullingPercent = (happenOffsetY - offsetY) / self.frame.size.height
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .idle && offsetY < normalPullingOffsetY {
                self.state = .pulling
            }else if self.state == .pulling && offsetY >= normalPullingOffsetY {
                self.state = .idle
            }
        }else if self.state == .pulling {
            self.beginRefreshing()
        }else if pullingPercent < 1.0 {
            self.pullingPercent = pullingPercent
        }
        
        self.scrollView = scrollView
        self.scrollViewOriginalInset = scrollViewOriginalInset
    }
}

extension MYRefreshHeader {
    override func endRefreshing() {
        if self.scrollView.isKind(of: UICollectionView.self) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                super.endRefreshing()
            })
        }else {
            super.endRefreshing()
        }
    }
}
