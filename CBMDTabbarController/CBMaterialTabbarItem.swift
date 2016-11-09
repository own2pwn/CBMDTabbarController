// CBMaterialTabbarItem.swift
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

class CBMaterialTabbarItem: UITabBarItem {
    
    /// @IBInspectable - The tint color of the UITabBarItem icon.
    @IBInspectable public var iconColor: UIColor = UIColor.white
    
    /// @IBInspectable - The color of the UITabBarItem text.
    @IBInspectable public var textColor: UIColor = UIColor.white
    
    /// IBInspectable - The font used to render the UITabBarItem text.
    @IBInspectable public var textFont: UIFont = UIFont.italicSystemFont(ofSize: 12)
    
    /// IBInspectable - Select animation duration.
    @IBInspectable public var seletctAnimationDuratin: Double = 0.5
    
    /// Ripple animation duration.
    @IBInspectable public var rippleDuration: Double = 0.5
    
    /// Ripple Enable switch.
    @IBInspectable public var rippleEnabled: Bool = true
    
    /// @IBInspectable - Background animation enable switch.
    @IBInspectable public var backgroundAnimationEnabled: Bool = false
    
    /// @IBInspectable - BackgroundLayer size.
    @IBInspectable public var backgroundLayerSize: CGSize = CGSize(width: 35, height: 35)

    /// @IBInspectable - Ripple color.
    @IBInspectable public var rippleLayerColor: UIColor = UIColor.black
    
    /// @IBInspectable - Background layer color.
    @IBInspectable public var backgroundLayerColor: UIColor = UIColor.black
    
    /// @IBInspectable - Transition type.
    @IBInspectable public var transitionType: String = kCATransitionFade
    
    /// Public - Container for icon and text in UITableItem.
    public var iconView: (icon: UIImageView, textLabel: UILabel)? {
        didSet {
            self.MaterialView = self.iconView?.icon.superview?.superview as? CBMaterialView
            
            self.MaterialViewSetup()
        }
    }
    
    /// Private - MaterialView.
    var MaterialView: CBMaterialView?
    
    /// Public - Init methods.
    public override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Private - Material view setup.
    private func MaterialViewSetup() {
        self.MaterialView?.backgroundAnimationEnabled = self.backgroundAnimationEnabled
        self.MaterialView?.rippleEnabled = self.rippleEnabled
        self.MaterialView?.rippleDuration = self.rippleDuration
        self.MaterialView?.rippleLayerColor = self.rippleLayerColor
        self.MaterialView?.backgroundLayerColor = self.backgroundLayerColor
        self.MaterialView?.backgroundLayerSize = self.backgroundLayerSize
    }
    
    /// Public Func - Start select animation.
    public func startSelectAnimation(atIndex index: Int, itemCount count: Int) {
        self.MaterialViewSetup()
        
        let lcoation = CGPoint (
            x: self.MaterialView!.frame.width * CGFloat(2 * index  + 1 ) / CGFloat(2 * count), y: self.MaterialView!.frame.size.height / 2
        )
        
        self.MaterialView?.startAnimation(atLocation: lcoation, yOffset: -8)

        if let icon = self.iconView?.icon,
        let label = self.iconView?.textLabel {
            let tempSize = label.frame.size
            label.layer.opacity = 1
            label.frame.size = CGSize.zero
            
            UIView.animate(withDuration: self.seletctAnimationDuratin,
                           delay: 0,
                           options: .curveLinear,
                           animations: { 
                            icon.layoutIfNeeded()
                            icon.frame.origin.y -= 8
            }, completion: { (finish) in
                label.frame.size = tempSize
            })
        }
    }
    
    /// Public Func - Start deslect animation.
    public func startDeselectAnimation() {
        if let icon = self.iconView?.icon,
            let label = self.iconView?.textLabel {
            let tempSize = label.frame.size
            label.layer.opacity = 1
            
            UIView.animate(withDuration: self.seletctAnimationDuratin,
                           delay: 0,
                           options: .curveLinear,
                           animations: {
                            icon.layoutIfNeeded()
                            icon.frame.origin.y += 8
                            
                            label.frame.size = CGSize.zero
            }, completion: nil)
            
            label.layer.opacity = 0
            label.frame.size = tempSize
        }
    }
}
