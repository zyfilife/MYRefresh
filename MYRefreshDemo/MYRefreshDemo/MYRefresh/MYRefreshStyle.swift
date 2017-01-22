//
//  MYRefreshStyle.swift
//  SmartCloud
//
//  Created by 朱益锋 on 2017/1/19.
//  Copyright © 2017年 SmartPower. All rights reserved.
//
import UIKit

let KMYRefreshLabelTextColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
let kMYRefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)


let kMYRefreshFastAnimationDuration = 0.25
let kMYRefreshSlowAnimationDuration = 0.4

let kMYRefreshKeyPathContentOffset = "contentOffset"
let kMYRefreshKeyPathContentInset = "contentInset"
let kMYRefreshKeyPathContentSize = "contentSize"
let kMYRefreshKeyPathPanState = "state"

let kMYRefreshHeaderLastUpdatedTimeKey = "MYRefreshHeaderLastUpdatedTimeKey"

let kMYRefreshHeaderIdleText = "下拉可以刷新"
let kMYRefreshHeaderPullingText = "松开立即刷新"
let kMYRefreshHeaderRefreshingText = "正在刷新数据中..."

let kMYRefreshAutoFooterIdleText = "点击或上拉加载更多"
let kMYRefreshAutoFooterRefreshingText = "正在加载更多的数据..."
let kMYRefreshAutoFooterNoMoreDataText = "已经全部加载完毕"

let kMYRefreshBackFooterIdleText = "上拉可以加载更多"
let kMYRefreshBackFooterPullingText = "松开立即加载更多"
let kMYRefreshBackFooterRefreshingText = "正在加载更多的数据..."
let kMYRefreshBackFooterNoMoreDataText = "已经全部加载完毕"
