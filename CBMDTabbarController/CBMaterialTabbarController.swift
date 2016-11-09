// CBMaterialTabbarController.swift
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

class CBMaterialTabbarController: UITabBarController {

    /// @IBInspectable - Tabbar height.
    @IBInspectable public var tabbarHeight: Double = Double(56) {
        didSet {
            self.viewWillLayoutSubviews()
        }
    }
    
    /// @IBInspectable - Tabbar black line.
    @IBInspectable public var removeBlackLine: Bool = false {
        didSet {
            if removeBlackLine {
                self.tabBar.shadowImage = UIImage.init()
                self.tabBar.backgroundImage = UIImage.init()
            } else {
                self.tabBar.shadowImage = nil
                self.tabBar.backgroundImage = nil
            }
        }
    }
    
    /// Private - Material background view.
    var MaterialView: CBMaterialView?
    
    /// Override - View life cycle.
    override func viewDidLoad() {
        self.initial()

        super.viewDidLoad()
        
        let containers = self.createViewContainers()
        self.createCustomIcons(containers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Advance setup.
    private func initial() {
        if removeBlackLine {
            self.tabBar.shadowImage = UIImage.init()
            self.tabBar.backgroundImage = UIImage.init()
        } else {
            self.tabBar.shadowImage = nil
            self.tabBar.backgroundImage = nil
        }
        
        self.selectedIndex = 0
        
        self.MaterialView = CBMaterialView.init(frame: self.tabBar.frame)
        self.MaterialView!.frame.size.height += 5;
        self.view.addSubview(self.MaterialView!)
    }
    
    /// Override - viewWillLayout.
    override func viewWillLayoutSubviews() {
        self.tabBar.frame = CGRect(
            x: self.tabBar.frame.origin.x, y: self.view.frame.size.height - CGFloat(self.tabbarHeight),
            width: self.tabBar.frame.size.width, height: CGFloat(self.tabbarHeight))
        
        if let MaterialView = self.MaterialView {
            MaterialView.frame = self.tabBar.frame
            MaterialView.frame.size.height += 5;
        }
    }
    
    /// Public - Init methods - Nib.
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib name.
    ///   - nibBundleOrNil: Bundle name.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// Public - Init method - Custom.
    ///
    /// - Parameter viewControllers: Items.
    public init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)

        self.setViewControllers(viewControllers, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createCustomIcons(_ containers : NSDictionary) {
        guard let items = tabBar.items as? [CBMaterialTabbarItem] else {
            fatalError("Items must inherit RAMAnimatedTabBarItem !")
        }
        
        var index = 0
        for item in items {
            guard let itemImage = item.image else {
                fatalError("Add image icon in UITabBarItem !")
            }
            
            guard let container = containers["container\(index)"] as? UIView else {
                fatalError()
            }
            
            container.tag = index
            
            let renderMode = item.iconColor.cgColor.alpha == 0 ? UIImageRenderingMode.alwaysOriginal :
                UIImageRenderingMode.alwaysTemplate
            
            let icon = UIImageView(image: item.image?.withRenderingMode(renderMode))
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.tintColor = item.iconColor
            
            let textLabel = UILabel()
            textLabel.text = item.title
            textLabel.backgroundColor = UIColor.clear
            textLabel.textColor = item.textColor
            textLabel.font = item.textFont
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            
            if selectedIndex != index {
                textLabel.layer.opacity = 0
            }
            
            let iconYOffset: CGFloat = selectedIndex == index ? -8 : 0
            
            container.addSubview(icon)
            self.createConstraints(icon, container: container, size: itemImage.size, yOffset: iconYOffset)

            container.addSubview(textLabel)
            let textLabelWidth = tabBar.frame.size.width / CGFloat(items.count) - 5.0
            self.createConstraints(textLabel, container: container, size: CGSize(width: textLabelWidth , height: 12), yOffset: 13)
            
            item.iconView = (icon:icon, textLabel:textLabel)
            
            if index == 0 {
                self.MaterialView?.backgroundColor = item.rippleLayerColor
            }
            
            item.image = nil
            item.title = ""
            index += 1
        }
    }
    
    /// Add constanints of icon and lable on iconViews.
    ///
    /// - Parameters:
    ///   - view: The view constanint should added to.
    ///   - container: The view's superView.
    ///   - size: The view's size.
    ///   - yOffset: The offset in origin Y direction.
    private func createConstraints(_ view:UIView, container:UIView, size:CGSize, yOffset:CGFloat) {
        let constX = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.centerX,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: container,
                                        attribute: NSLayoutAttribute.centerX,
                                        multiplier: 1,
                                        constant: 0)
        container.addConstraint(constX)
        
        let constY = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.centerY,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: container,
                                        attribute: NSLayoutAttribute.centerY,
                                        multiplier: 1,
                                        constant: yOffset)
        container.addConstraint(constY)
        
        let constW = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.width,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: nil,
                                        attribute: NSLayoutAttribute.notAnAttribute,
                                        multiplier: 1,
                                        constant: size.width)
        view.addConstraint(constW)
        
        let constH = NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.height,
                                        relatedBy: NSLayoutRelation.equal,
                                        toItem: nil,
                                        attribute: NSLayoutAttribute.notAnAttribute,
                                        multiplier: 1,
                                        constant: size.height)
        view.addConstraint(constH)
    }
    
    /// Private - Creat viewContainer with specified constaints.
    ///
    /// - Returns: A dictionary contain viewContainers.
    private func createViewContainers() -> NSDictionary {
        
        guard let items = tabBar.items else {
            fatalError("Add items in tabBar !")
        }
        
        var containersDict = [String: AnyObject]()
        
        for index in 0 ..< items.count {
            let viewContainer = UIView();
            viewContainer.backgroundColor = UIColor.clear
            viewContainer.translatesAutoresizingMaskIntoConstraints = false
            self.MaterialView!.addSubview(viewContainer)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
            tapGesture.numberOfTouchesRequired = 1
            viewContainer.addGestureRecognizer(tapGesture)
            
            let constB = NSLayoutConstraint(item: viewContainer,
                                            attribute: NSLayoutAttribute.bottom,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.MaterialView!,
                                            attribute: NSLayoutAttribute.bottom,
                                            multiplier: 1,
                                            constant: 0)
            self.MaterialView!.addConstraint(constB)
            
            let consT = NSLayoutConstraint(item: viewContainer,
                                           attribute: NSLayoutAttribute.top,
                                           relatedBy: NSLayoutRelation.equal,
                                           toItem: self.MaterialView!,
                                           attribute: NSLayoutAttribute.top,
                                           multiplier: 1,
                                           constant: 0)
            self.MaterialView!.addConstraint(consT)

            containersDict["container\(index)"] = viewContainer
        }
        
        var formatString = "H:|-(0)-[container0]"
        for index in 1..<items.count {
            formatString += "-(0)-[container\(index)(==container0)]"
        }
        formatString += "-(0)-|"
        let  constranints = NSLayoutConstraint.constraints(withVisualFormat: formatString,
                                                                    options: NSLayoutFormatOptions.directionLeftToRight,
                                                                    metrics: nil,
                                                                      views: (containersDict as [String : AnyObject]))
        self.view.addConstraints(constranints)
        
        return containersDict as NSDictionary
    }
    
    /// Private - Tap gesture handler.
    ///
    /// - Parameter gesture: Gesture.
    @objc private func tapHandler(_ gesture:UIGestureRecognizer) {
        guard let items = tabBar.items as? [CBMaterialTabbarItem],
            let gestureView = gesture.view else {
                fatalError("Items must inherit CBMaterialTabbarItem !")
        }
        
        let currentIndex = gestureView.tag
        
        if selectedIndex != currentIndex {
            let animationItem: CBMaterialTabbarItem = items[currentIndex]
            animationItem.startSelectAnimation(atIndex: currentIndex, itemCount: items.count)
            
            let deselectItem = items[selectedIndex]
            deselectItem.startDeselectAnimation()
            
            let controller = self.childViewControllers[currentIndex]

            selectedIndex = gestureView.tag
            delegate?.tabBarController?(self, didSelect: controller)
            
            let traAnim = CATransition()
            
            traAnim.duration = self.MaterialView!.rippleDuration / 1.5
            traAnim.type = animationItem.transitionType
            traAnim.subtype = kCATransitionFromTop
            traAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

            self.view.layer.add(traAnim, forKey: "view_traAnim")
        }
    }
}
