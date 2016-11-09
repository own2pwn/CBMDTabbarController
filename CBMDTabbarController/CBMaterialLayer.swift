// CBMaterialLayer.swift
// Copyright (c) 2016 陈超邦.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class CBMaterialLayer: CALayer, CAAnimationDelegate {
    
    /// Private - View variables.
    private var superView: UIView?
    
    /// Private - Layer variables.
    private var superLayer: CALayer?
    private var backgroundLayer: CAShapeLayer?
    private var rippleLayer: CAShapeLayer?
    private var maskLayer: CAShapeLayer?
    
    /// public - Control variables.
    public var rippleEnabled: Bool = true
    public var rippleDuration: CFTimeInterval = 0.3
    public var backgroundAnimationEnabled: Bool = true
    public var backgroundLayerSize: CGSize = CGSize(width: 100.0, height: 100.0)
    
    /// Init methods.
    ///
    /// - Parameter view: SuperView.
    public init(withSuperView view: UIView) {
        super.init()
        
        self.superView = view;
        self.superLayer = view.layer;
        
        self.initial()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Override - Resize.
    override var frame: CGRect {
        didSet {
            self.maskLayer?.path = UIBezierPath(roundedRect: self.superLayer!.bounds, cornerRadius: 0).cgPath
        }
    }
    
    /// Public - Resize.
    public func superLayerDidResize() {
        if let superLayer = self.superLayer {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.frame = superLayer.bounds
            CATransaction.commit()
        }
    }
    
    /// Advance setup
    private func initial() {
        self.rippleLayer = CAShapeLayer()
        self.rippleLayer!.opacity = 0
        self.addSublayer(self.rippleLayer!)
        
        self.backgroundLayer = CAShapeLayer()
        self.backgroundLayer!.opacity = 0
        self.addSublayer(self.backgroundLayer!)
        
        self.maskLayer = CAShapeLayer()
        self.maskLayer?.path = UIBezierPath(roundedRect: self.superLayer!.bounds, cornerRadius: 0).cgPath
        
        self.frame = self.superLayer!.bounds
        self.mask = self.maskLayer
        self.superLayer?.addSublayer(self)
    }
    
    /// Start animations with specified location point.
    ///
    /// - Parameter location: Specified location point.
    public func startAnimation(atLocation location: CGPoint, yOffset offset: CGFloat) {
        self.removeAllAnimations()
        
        self.calculateRippleSize(withLocation: location)
        
        if let rippleLayer = self.rippleLayer,
            let backgroundLayer = self.backgroundLayer {
            
            rippleLayer.removeAllAnimations()
            backgroundLayer.removeAllAnimations()
            
            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = 0
            scaleAnim.toValue = 1
            scaleAnim.duration = self.rippleDuration
            scaleAnim.fillMode = kCAFillModeForwards
            scaleAnim.isRemovedOnCompletion = false
            scaleAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            scaleAnim.delegate = self
            
            let moveAnim = CABasicAnimation(keyPath: "position")
            moveAnim.fromValue = NSValue(cgPoint: location)
            moveAnim.toValue = NSValue(cgPoint: CGPoint(
                x: location.x,
                y: location.y + offset))
            moveAnim.duration = rippleDuration
            moveAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let opacityAnim = CABasicAnimation(keyPath: "opacity")
            opacityAnim.fromValue = 1
            opacityAnim.toValue = 0
            opacityAnim.duration = self.rippleDuration
            opacityAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            opacityAnim.isRemovedOnCompletion = false
            opacityAnim.fillMode = kCAFillModeForwards
            opacityAnim.delegate = self
            
            rippleLayer.opacity = 1
            backgroundLayer.opacity = 1
            
            rippleLayer.add(scaleAnim, forKey: "scale_ripple")
            backgroundLayer.add(opacityAnim, forKey: "opacity_background")
            
            if offset != 0 {
                rippleLayer.add(moveAnim, forKey: "move_ripple")
                backgroundLayer.add(moveAnim, forKey: "move_background")
            }
        }
    }
    
    /// Set the size of ripple layer.
    ///
    /// - Parameter location: Touch location point.
    private func calculateRippleSize(withLocation location: CGPoint) {
        if let superLayer = self.superLayer,
        let rippleLayer = self.rippleLayer,
        let backgroundLayer = self.backgroundLayer {
            let sideLength =  CGFloat(
                sqrt(
                    powf(Float(superLayer.bounds.width), 2)
                        +
                        powf(Float(superLayer.bounds.height), 2))
                ) * 2
            
            rippleLayer.frame = CGRect(
                x: location.x - sideLength / 2, y: location.y - sideLength / 2,
                width: sideLength, height: sideLength
            )
            if rippleEnabled {
                rippleLayer.path = UIBezierPath(ovalIn: rippleLayer.bounds).cgPath
            }
            
            backgroundLayer.frame = CGRect(
                x: location.x - self.backgroundLayerSize.width / 2, y: location.y - self.backgroundLayerSize.height / 2,
                width: self.backgroundLayerSize.width, height: self.backgroundLayerSize.height
            )
            if backgroundAnimationEnabled {
                backgroundLayer.path = UIBezierPath(ovalIn: backgroundLayer.bounds).cgPath
            }
        }
    }
    
    /// Fill layer with specified color.
    ///
    /// - Parameters:
    ///   - rippleLayerColor: Specified ripple color.
    ///   - backgroundLayerColor: Specified background color.
    ///   - rippleLayerAlpha: Color of ripple layer.
    ///   - backgroundLayerAlpha: Color of background layer.
    public func setRippleColor(rippleLayerColor: UIColor,
                               backgroundLayerColor: UIColor,
                               withRippleLayerAlpha rippleLayerAlpha: CGFloat = 1.0,
                               withBackgroundLayerAlpha backgroundLayerAlpha: CGFloat = 1.0) {
        if let rippleLayer = self.rippleLayer,
        let backgroundLayer = self.backgroundLayer {
            rippleLayer.fillColor = rippleLayerColor.withAlphaComponent(rippleLayerAlpha).cgColor
            backgroundLayer.fillColor = backgroundLayerColor.withAlphaComponent(backgroundLayerAlpha).cgColor
        }
    }
    
    /// Fill layer with specified color.
    ///
    /// - Parameters:
    ///   - rippleLayerColor: Specified ripple color.
    ///   - rippleLayerAlpha: Color of ripple layer.
    public func setRippleColor(rippleLayerColor: UIColor,
                               withRippleLayerAlpha rippleLayerAlpha: CGFloat = 1.0) {
        if let rippleLayer = self.rippleLayer {
            rippleLayer.fillColor = rippleLayerColor.withAlphaComponent(rippleLayerAlpha).cgColor
        }
    }
    
    /// Fill layer with specified color.
    ///
    /// - Parameters:
    ///   - backgroundLayerColor: Specified background color.
    ///   - backgroundLayerAlpha: Color of background layer.
    public func setRippleColor(backgroundLayerColor: UIColor,
                               withBackgroundLayerAlpha backgroundLayerAlpha: CGFloat = 1.0) {
        if let backgroundLayer = self.backgroundLayer {
            backgroundLayer.fillColor = backgroundLayerColor.withAlphaComponent(backgroundLayerAlpha).cgColor
        }
    }
    
    /// Animation callback method.
    ///
    /// - Parameters:
    ///   - anim: Specified animation tagged by keypath like "scale_ripple".
    ///   - flag: Finish flag.
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == self.rippleLayer?.animation(forKey: "scale_ripple"),
        let backgroundLayer = self.backgroundLayer,
        let rippleLayer = self.rippleLayer,
        let superView = self.superView {
            backgroundLayer.opacity = 0
            rippleLayer.opacity = 0
            
            superView.backgroundColor = UIColor.init(cgColor: rippleLayer.fillColor!)
        }
    }
}
