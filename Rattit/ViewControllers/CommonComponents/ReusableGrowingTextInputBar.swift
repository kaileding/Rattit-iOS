//
//  ReusableGrowingTextInputBar.swift
//  Rattit
//
//  Created by DINGKaile on 8/4/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusableGrowingTextInputBar: UIView {
    
    var delegate: ReusableGrowingTextInputBarDelegate?
    var keyboardObserver: ReusableKeyboardObservingView?
    
    /// Used for the intrinsic content size for autolayout
    var defaultHeight: CGFloat = 44
    
    /// If true the right button will always be visible else it will only show when there is text in the text view
    var alwaysShowRightButton = false
    
    /// The horizontal padding between the view edges and its subviews
    var horizontalPadding: CGFloat = 10
    
    /// The horizontal spacing between subviews
    var horizontalSpacing: CGFloat = 5
    
    /// Convenience set and retrieve the text view text
    var text: String! {
        get {
            return textView.text
        }
        set(newValue) {
            textView.text = newValue
            textView.delegate?.textViewDidChange?(textView)
        }
    }
    
    var textViewBorderView: UIView! = {
        let _textViewBorderView = UIView()
        _textViewBorderView.isHidden = false
        _textViewBorderView.layer.cornerRadius = 4.0
        _textViewBorderView.layer.borderWidth = 1.0
        _textViewBorderView.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        _textViewBorderView.backgroundColor = UIColor.white
        
        return _textViewBorderView
    }()
    
    public let textView: ReusableGrowingTextView = {
        let _textView = ReusableGrowingTextView()
        _textView.textContainerInset = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        _textView.textContainer.lineFragmentPadding = 0
        _textView.maxNumberOfLinesWithoutScroll = 4
        _textView.placeHolderText = "Hmm"
        _textView.placeHolderColor = UIColor.lightGray
        _textView.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightLight)
        _textView.textColor = UIColor.black
        _textView.backgroundColor = UIColor.clear
        // This changes the caret color
        _textView.tintColor = UIColor.lightGray
        
        return _textView
    }()
    
    var leftButtonView: UIButton? = nil
    var rightButtonView: UIButton? = nil
    var showRightButton = false
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        
        self.addSubview(self.textViewBorderView)
        self.addSubview(self.textView)
        self.textView.textViewDelegate = self
        self.backgroundColor = UIColor.groupTableViewBackground
        
        self.leftButtonView = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.defaultHeight, height: self.defaultHeight))
        self.leftButtonView!.setImage(UIImage(named: "cameraIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.leftButtonView!.imageEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)
        self.leftButtonView!.imageView?.contentMode = .scaleAspectFit
        self.leftButtonView!.tintColor = UIColor.darkGray
        self.leftButtonView!.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        self.addSubview(self.leftButtonView!)
        
        self.rightButtonView = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.defaultHeight, height: self.defaultHeight))
        self.rightButtonView!.setImage(UIImage(named: "flyIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.rightButtonView!.imageEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)
        self.rightButtonView!.imageView?.contentMode = .scaleAspectFit
        self.rightButtonView!.tintColor = UIColor.black
        self.rightButtonView!.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        self.addSubview(self.rightButtonView!)
    }
    
    // MARK: - View positioning and layout -
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: defaultHeight)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let size = frame.size
        let height = floor(size.height)
        
        var leftViewSize = CGSize.zero
        var rightViewSize = CGSize.zero
        
        if let view = leftButtonView {
            leftViewSize = view.bounds.size
            
            let leftViewX: CGFloat = horizontalPadding
            let leftViewVerticalPadding = (defaultHeight - leftViewSize.height) / 2
            let leftViewY: CGFloat = height - (leftViewSize.height + leftViewVerticalPadding)
            
            view.frame = CGRect(x: leftViewX, y: leftViewY, width: leftViewSize.width, height: leftViewSize.height)
        }
        
        if let view = rightButtonView {
            rightViewSize = view.bounds.size
            
            let rightViewVerticalPadding = (defaultHeight - rightViewSize.height) / 2
            var rightViewX = size.width
            let rightViewY = height - (rightViewSize.height + rightViewVerticalPadding)
            
            if self.showRightButton || self.alwaysShowRightButton {
                rightViewX -= (rightViewSize.width + horizontalPadding)
            }
            
            view.frame = CGRect(x: rightViewX, y: rightViewY, width: rightViewSize.width, height: rightViewSize.height)
        }
        
        let textViewPadding = (defaultHeight - textView.minimumHeight) / 2
        var textViewX = horizontalPadding
        let textViewY = textViewPadding
        let textViewHeight = textView.expectedHeight
        var textViewWidth = size.width - (horizontalPadding + horizontalPadding)
        
        if leftViewSize.width > 0 {
            textViewX += leftViewSize.width + horizontalSpacing
            textViewWidth -= leftViewSize.width + horizontalSpacing
        }
        
        
        if (showRightButton || alwaysShowRightButton) && rightViewSize.width > 0 {
            textViewWidth -= (horizontalSpacing + rightViewSize.width)
        } else {
            
        }
        
        self.textView.frame = CGRect(x: textViewX, y: textViewY, width: textViewWidth, height: textViewHeight)
        self.textViewBorderView.frame = UIEdgeInsetsInsetRect(self.textView.frame, UIEdgeInsets.zero)
    }
    
    
}

extension ReusableGrowingTextInputBar: GrowingTextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        
        self.textView.textViewDidChange()
        let shouldShowButton = textView.text.characters.count > 0
        if self.showRightButton != shouldShowButton && !self.alwaysShowRightButton {
            self.showRightButton = shouldShowButton
            
            UIView.animate(withDuration: 0.2) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    public func textViewHeightChanged(textView: ReusableGrowingTextView, newHeight: CGFloat) {
        
        let padding = self.defaultHeight - self.textView.minimumHeight
        let height = padding + newHeight
        
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutAttribute.height && constraint.firstItem as! NSObject == self {
                constraint.constant = (height < defaultHeight) ? defaultHeight : height
            }
        }
        
        self.frame.size.height = height
        
        if let ko = self.keyboardObserver {
            ko.updateHeight(height: height)
        }
        
        self.textView.frame.size.height = newHeight
    }
}

extension ReusableGrowingTextInputBar {
    func leftButtonTapped() {
        print("ReusableGrowingTextInputBar.leftButtonTapped() func.")
    }
    
    func rightButtonTapped() {
        print("ReusableGrowingTextInputBar.rightButtonTapped() func.")
    }
}


