//
//  ReusablePlaceHolderTextView.swift
//  Rattit
//
//  Created by DINGKaile on 7/29/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusablePlaceHolderTextView: UIView {
    
    @IBOutlet weak var textView: UITextView!
    
    var placeHolderText: String = ""
    var hasTextHandler: (() -> Void)? = nil
    var noTextHandler: (() -> Void)? = nil
    
    override func awakeFromNib() {
        let reusablePlaceHolderTextView = Bundle.main.loadNibNamed("ReusablePlaceHolderTextView", owner: self, options: nil)?.first as! UIView
        
        reusablePlaceHolderTextView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(reusablePlaceHolderTextView)
        reusablePlaceHolderTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        reusablePlaceHolderTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        reusablePlaceHolderTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        reusablePlaceHolderTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        
        self.textView.delegate = self
        self.textView.text = "Say something"
        self.placeHolderText = "Say something"
        self.textView.textColor = UIColor.lightGray
    }
    
    func setTextView(placeHolder: String, hasTextHandler: @escaping () -> Void, noTextHandler: @escaping () -> Void) {
        
        self.placeHolderText = placeHolder
        self.hasTextHandler = hasTextHandler
        self.noTextHandler = noTextHandler
    }
    
    func getCurrentText() -> String {
        if self.textView.textColor == UIColor.black {
            return self.textView.text
        } else {
            return ""
        }
    }
    
}

extension ReusablePlaceHolderTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text
        let newText = currentText?.replacingCharacters(in: Range<String.Index>(range, in: currentText!)!, with: text)
        
        if newText!.isEmpty {
            textView.text = self.placeHolderText
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            if self.noTextHandler != nil {
                self.noTextHandler!()
            }
            return false
        } else {
            if textView.textColor == UIColor.lightGray && !text.isEmpty {
                textView.text = nil
                textView.textColor = UIColor.black
            }
            if self.hasTextHandler != nil {
                self.hasTextHandler!()
            }
        }
        
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
}

