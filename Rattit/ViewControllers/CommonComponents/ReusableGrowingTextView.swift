//
//  ReusableGrowingTextView.swift
//  Rattit
//
//  Created by DINGKaile on 8/4/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

protocol GrowingTextViewDelegate: UITextViewDelegate {
    func textViewHeightChanged(textView: ReusableGrowingTextView, newHeight: CGFloat)
}

class ReusableGrowingTextView: UITextView {
    
    override public var font: UIFont? {
        didSet {
            self.placeHolderLabel.font = font
        }
    }
    
    override public var contentSize: CGSize {
        didSet {
            self.updateSize()
        }
    }
    
    weak var textViewDelegate: GrowingTextViewDelegate? {
        didSet {
            self.delegate = textViewDelegate
        }
    }
    
    var placeHolderText: String = "" {
        didSet {
            self.placeHolderLabel.text = placeHolderText
        }
    }
    
    var placeHolderColor: UIColor = UIColor.black {
        didSet {
            self.placeHolderLabel.textColor = placeHolderColor
        }
    }
    
    lazy var placeHolderLabel: UILabel = {
        var _placeHolderLabel = UILabel()
        _placeHolderLabel.clipsToBounds = false
        _placeHolderLabel.autoresizesSubviews = false
        _placeHolderLabel.numberOfLines = 1
        _placeHolderLabel.font = self.font
        _placeHolderLabel.backgroundColor = UIColor.clear
        _placeHolderLabel.textColor = self.tintColor
        _placeHolderLabel.isHidden = true
        self.addSubview(_placeHolderLabel)
        
        return _placeHolderLabel
    }()
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            self.placeHolderLabel.textAlignment = textAlignment
        }
    }
    
    var maxNumberOfLinesWithoutScroll: Int = 1
    var expectedHeight: CGFloat = 0
    var minimumHeight: CGFloat {
        get {
            return ceil(self.font!.lineHeight) + self.textContainerInset.top + self.textContainerInset.bottom
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.isScrollEnabled = false
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if self.placeHolderText.characters.count == 0 || self.text.characters.count > 0 {
            self.placeHolderLabel.isHidden = true
        } else {
            self.placeHolderLabel.isHidden = false
            
            var placeHolderFrameRect = UIEdgeInsetsInsetRect(self.bounds, self.textContainerInset)
            placeHolderFrameRect.origin.x += self.textContainer.lineFragmentPadding
            placeHolderFrameRect.size.width -= self.textContainer.lineFragmentPadding * 2.0
            self.placeHolderLabel.frame = placeHolderFrameRect
            self.sendSubview(toBack: self.placeHolderLabel)
        }
    }
    
    fileprivate func updateSize() {
        let maxHeight = (self.font == nil) ? CGFloat.infinity : ceil(self.font!.lineHeight)*CGFloat(self.maxNumberOfLinesWithoutScroll) + self.textContainerInset.top + self.textContainerInset.bottom
        let newHeight = self.roundHeight()
        
        if newHeight >= maxHeight {
            self.expectedHeight = maxHeight
            self.isScrollEnabled = true
        } else {
            self.expectedHeight = newHeight
            self.isScrollEnabled = false
        }
        
        self.textViewDelegate?.textViewHeightChanged(textView: self, newHeight: self.expectedHeight)
        if let range = self.selectedTextRange {
            let caretRect = self.caretRect(for: range.end)
            self.scrollRectToVisible(caretRect, animated: false)
        }
    }
    
    fileprivate func roundHeight() -> CGFloat {
        var newHeight: CGFloat = 0
        
        if let font = font {
            let attributes = [NSFontAttributeName: font]
            let boundingSize = CGSize(width: frame.size.width - textContainerInset.left - textContainerInset.right, height: CGFloat.infinity)
            let size = text.boundingRect(with: boundingSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
            newHeight = max(font.lineHeight, ceil(size.height))
        }
        return newHeight + textContainerInset.top + textContainerInset.bottom
    }
    
    func textViewDidChange() {
        if self.placeHolderText.characters.count == 0 || self.text.characters.count > 0 {
            self.placeHolderLabel.isHidden = true
        } else {
            self.placeHolderLabel.isHidden = false
        }
        self.updateSize()
    }

}
