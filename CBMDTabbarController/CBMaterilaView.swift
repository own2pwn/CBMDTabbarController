// CBMaterialView.swift
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

@IBDesignable
public class CBMaterialView: UIView {

    /// @IBInspectable - Ripple Enable switch.
    @IBInspectable public var rippleEnabled: Bool = true {
        didSet {
            self.MaterialLayer.rippleEnabled = rippleEnabled
        }
    }
    
    /// @IBInspectable - Ripple animation duration.
    @IBInspectable public var rippleDuration: Double = 0.35 {
        didSet {
            self.MaterialLayer.rippleDuration = rippleDuration
        }
    }
    
    /// @IBInspectable - Background animation enable switch.
    @IBInspectable public var backgroundAnimationEnabled: Bool = true {
        didSet {
            self.MaterialLayer.backgroundAnimationEnabled = backgroundAnimationEnabled
        }
    }
    
    /// @IBInspectable - BackgroundLayer size.
    @IBInspectable public var backgroundLayerSize: CGSize = CGSize(width: 100, height: 100) {
        didSet {
            self.MaterialLayer.backgroundLayerSize = backgroundLayerSize
        }
    }
    
    /// @IBInspectable - Ripple color.
    @IBInspectable public var rippleLayerColor: UIColor = UIColor.black {
        didSet {
            self.MaterialLayer.setRippleColor(rippleLayerColor: rippleLayerColor)
        }
    }
    
    /// @IBInspectable - Background layer color.
    @IBInspectable public var backgroundLayerColor: UIColor = UIColor.black {
        didSet {
            self.MaterialLayer.setRippleColor(backgroundLayerColor: backgroundLayerColor)
        }
    }
    
    /// CBMaterialLayer instance.
    private lazy var MaterialLayer: CBMaterialLayer = CBMaterialLayer.init(withSuperView: self)

    // Init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initial()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initial()
    }
    
    /// Override - Resize.
    override public var frame: CGRect {
        didSet {
            self.MaterialLayer.superLayerDidResize()
        }
    }
    
    /// Advance setup
    private func initial() {
        MaterialLayer.rippleDuration = self.rippleDuration
        MaterialLayer.rippleEnabled = self.rippleEnabled
        MaterialLayer.backgroundAnimationEnabled = self.backgroundAnimationEnabled
        MaterialLayer.backgroundLayerSize = self.backgroundLayerSize
    }
    
    /// Start ripple animation at specified point.
    ///
    /// - Parameter location: Specified point.
    public func startAnimation(atLocation location: CGPoint, yOffset: CGFloat) {
        self.MaterialLayer.startAnimation(atLocation: location, yOffset: yOffset)
    }
}
