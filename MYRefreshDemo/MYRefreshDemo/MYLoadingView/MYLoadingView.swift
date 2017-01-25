//
//  MYLoadingView.swift
//  MYPlayerDemo
//
//  Created by 朱益锋 on 2017/1/25.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class MYLoadingView: UIView {
    
    var lineWidth:CGFloat!
    
    var lineColor: UIColor!
    
    var isAnimating = false
    
    var radius: CGFloat!
    
    lazy var ringLayer: CAShapeLayer = {
        let path = UIBezierPath(arcCenter: CGPoint(x: (self.radius+self.lineWidth), y: (self.radius+self.lineWidth)), radius: self.radius, startAngle: self.toAngle(angle: 120), endAngle: self.toAngle(angle: 120)+self.toAngle(angle: 330), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (self.radius+self.lineWidth)*2, height: (self.radius+self.lineWidth)*2))
        shapeLayer.lineJoin = kCALineJoinBevel
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.strokeColor = self.lineColor.cgColor
        shapeLayer.lineCap = kCALineCapRound
        return shapeLayer
    }()
    
    var anglePer:CGFloat = 0.0 {
        didSet {
            self.anglePer = self.anglePer <= 1.0 && self.anglePer >= 0.0 ? self.anglePer: (self.anglePer >= 1.0 ? 1.0: (self.anglePer <= 0.0 ? 0.0: self.anglePer))
            self.ringLayer.strokeEnd = self.anglePer
        }
    }
    
    init(radius: CGFloat = 8, lineWidth: CGFloat=1.5, lineColor: UIColor=UIColor.white) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.radius = radius
        self.layer.addSublayer(self.ringLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        if self.isAnimating {
            self.stopAnimating()
            self.layer.removeAllAnimations()
        }
        self.transform = CGAffineTransform.identity
        self.isAnimating = true
        self.anglePer = 1.0
        self.startAnimationWithRotation()
    }
    
    fileprivate func startAnimationWithRotation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.23
        animation.toValue = M_PI/2
        animation.fillMode = kCAFillModeForwards
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.layer.add(animation, forKey: "keyFrameAnimation")
    }
    
    func stopAnimating() {
        self.isAnimating = false
        self.layer.removeAllAnimations()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: (self.radius+self.lineWidth)*2, height: (self.radius+self.lineWidth)*2)
    }
    
    fileprivate func toAngle(angle: CGFloat) -> CGFloat {
        return CGFloat(M_PI)*2/360*angle
    }

}
