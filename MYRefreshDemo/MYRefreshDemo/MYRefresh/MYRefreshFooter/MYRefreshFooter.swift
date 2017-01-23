//
//  MYRefreshFooter.swift
//  MYRefreshDemo
//
//  Created by 朱益锋 on 2017/1/23.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class MYRefreshFooter: MYRefreshComponent {
    
    var autoHidden: Bool!
    
    init(withBlock refreshingBlock: @escaping MYRefreshComponentRefreshingBlock) {
        super.init(frame: CGRect.zero)
        self.refreshingBlock = refreshingBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        self.refreshFooterHeight = 44
        self.autoHidden = false
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            if self.scrollView.isKind(of: UITableView.self) || self.scrollView.isKind(of: UICollectionView.self) {
                
            }
        }
    }
    
    func endRefreshingWithNoMoreData() {
        self.state = .noMoreData
    }
    
    func noticeNoMoreData() {
        self.endRefreshingWithNoMoreData()
    }
    
    func resetNoMoreData() {
        self.state = .idle
    }
}
