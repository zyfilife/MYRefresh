//
//  UIScrollView+MYRefresh.swift
//  SmartCloud
//
//  Created by 朱益锋 on 2017/1/20.
//  Copyright © 2017年 SmartPower. All rights reserved.
//

import UIKit

extension NSObject {
    
    class func exchangeInsetance(method1: Selector, method2: Selector) {
        method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2))
    }
    
    class func  exchangeClass(method1: Selector, method2: Selector) {
        method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2))
    }
}

extension UIScrollView {
    
    static var kMYRefreshHeaderKey:Character = "0"
    
    var my_header: MYRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.kMYRefreshHeaderKey) as? MYRefreshHeader
        }
        set {
            if self.my_header != newValue {
                self.my_header?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                
                self.willChangeValue(forKey: "my_header")
                objc_setAssociatedObject(self, &UIScrollView.kMYRefreshHeaderKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
                self.didChangeValue(forKey: "my_header")
            }
        }
    }
}
