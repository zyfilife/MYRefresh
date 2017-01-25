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
    
    var anglePer:CGFloat = 0.0 {
        didSet {
            self.anglePer = self.anglePer <= 1.0 && self.anglePer >= 0.0 ? self.anglePer: (self.anglePer >= 1.0 ? 1.0: (self.anglePer <= 0.0 ? 0.0: self.anglePer))
            self.setNeedsDisplay()
        }
    }
    
    init(frame: CGRect = CGRect.zero, lineWidth: CGFloat=1.5, lineColor: UIColor=UIColor.white) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayerWithRing(progress: CGFloat) {
        
        let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2), radius: self.bounds.width/2-self.lineWidth, startAngle: self.toAngle(angle: 120), endAngle: self.toAngle(angle: 120)+self.toAngle(angle: 330*self.anglePer), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.bounds.size)
        shapeLayer.lineJoin = kCALineJoinBevel
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.strokeColor = self.lineColor.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        self.layer.addSublayer(shapeLayer)
        
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
    
    
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineWidth(self.lineWidth)
        context.setStrokeColor(self.lineColor.cgColor)
        context.setLineCap(CGLineCap.round)
        context.setLineJoin(CGLineJoin.bevel)
        context.addArc(center: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2), radius: self.bounds.width/2-self.lineWidth, startAngle: self.toAngle(angle: 120), endAngle: self.toAngle(angle: 120)+self.toAngle(angle: 330*self.anglePer), clockwise: false)
        context.strokePath()
    }
    
    fileprivate func toAngle(angle: CGFloat) -> CGFloat {
        return CGFloat(M_PI)*2/360*angle
    }

}
