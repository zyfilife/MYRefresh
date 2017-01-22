//
//  MYRefreshStateHeader.swift
//  SmartCloud
//
//  Created by 朱益锋 on 2017/1/20.
//  Copyright © 2017年 SmartPower. All rights reserved.
//

import UIKit

class MYRefreshStateHeader: MYRefreshHeader {
    
    var lastUpdatedTimeTextActionHandler: ((_ lastUpdatedTime: Date?) -> String?)?

    lazy var lastUpdatedTimeLabel: UILabel = {
        return UILabel.my_refreshLabel()
    }()
    
    lazy var stateLabel: UILabel = {
        return UILabel.my_refreshLabel()
    }()
    
    lazy var stateTitels: [MYRefreshState: String] = {
        return [MYRefreshState: String]()
    }()
    
    var currentCalendar: Calendar {
        return Calendar(identifier: Calendar.Identifier.gregorian)
    }
    
    override var state: MYRefreshState {
        didSet {
            
            self.stateLabel.text = self.stateTitels[self.state]
            
            let key = self.lastUpdatedTimeKey
            self.lastUpdatedTimeKey = key
        }
    }
    
    override var lastUpdatedTimeKey: String! {
        didSet {
            if self.lastUpdatedTimeLabel.isHidden {
                return
            }
            let lastUpdatedTime = UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as? Date
            
            if self.lastUpdatedTimeTextActionHandler != nil {
                self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeTextActionHandler!(lastUpdatedTime)
                return
            }
            
            if lastUpdatedTime != nil {
                let calendar = self.currentCalendar
                let cmp1 = calendar.dateComponents(([.year, .month, .day, .hour, .minute]), from: lastUpdatedTime!)
                let cmp2 = calendar.dateComponents(([.year, .month, .day, .hour, .minute]), from: Date())
                
                let formatter = DateFormatter()
                if cmp1.day == cmp2.day {
                    formatter.dateFormat = "今天 HH:mm"
                }else if cmp1.year == cmp2.year {
                    formatter.dateFormat = "MM-dd HH:mm"
                }else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
                let time = formatter.string(from: lastUpdatedTime!)
                
                self.lastUpdatedTimeLabel.text = "最后更新：\(time)"
            }else {
                self.lastUpdatedTimeLabel.text = "最后更新：无记录"
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
    
    func setTitle(title: String, forState state: MYRefreshState) {
        self.stateTitels[state] = title
        self.stateLabel.text = self.stateTitels[self.state]
    }
    
    override func prepare() {
        super.prepare()
        self.addSubview(self.lastUpdatedTimeLabel)
        self.addSubview(self.stateLabel)
        self.setTitle(title: kMYRefreshHeaderIdleText, forState: MYRefreshState.idle)
        self.setTitle(title: kMYRefreshHeaderPullingText, forState: MYRefreshState.pulling)
        self.setTitle(title: kMYRefreshHeaderRefreshingText, forState: MYRefreshState.refreshing)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if self.stateLabel.isHidden {
            return
        }
        if self.lastUpdatedTimeLabel.isHidden {
            if self.stateLabel.constraints.count == 0 {
                self.stateLabel.frame = self.bounds
            }
        }else {
            let stateLabelH = self.frame.size.height/2
            if self.stateLabel.constraints.count == 0 {
                self.stateLabel.frame.origin.x = 0
                self.stateLabel.frame.origin.y = 0
                self.stateLabel.frame.size.width = self.frame.size.width
                self.stateLabel.frame.size.height = stateLabelH
            }
            
            if self.lastUpdatedTimeLabel.constraints.count == 0 {
                self.lastUpdatedTimeLabel.frame.origin.x = 0
                self.lastUpdatedTimeLabel.frame.origin.y = stateLabelH
                self.lastUpdatedTimeLabel.frame.size.width = self.frame.size.width
                self.lastUpdatedTimeLabel.frame.size.height = self.frame.size.height - self.lastUpdatedTimeLabel.frame.origin.y
            }
        }
    }
}
