//
//  ComposeMomentEditorView.swift
//  Rattit
//
//  Created by DINGKaile on 7/1/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ComposeMomentEditorView: UIView {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var wordsTextView: UITextView!
    @IBOutlet weak var pickedImageScrollView: UIScrollView!
    
    
    static func instantiateFromXib() -> ComposeMomentEditorView {
        let composeMomentEditorView = Bundle.main.loadNibNamed("ComposeMomentEditorView", owner: self, options: nil)?.first as! ComposeMomentEditorView
        
        composeMomentEditorView.wordsTextView.delegate = composeMomentEditorView
        composeMomentEditorView.wordsTextView.text = "Say something"
        composeMomentEditorView.wordsTextView.textColor = UIColor.lightGray
        
        return composeMomentEditorView
    }
    
    
    func showSelectedImagesOnScrollView() {
        let selectedImages = ComposeContentManager.sharedInstance.getSelectedImages()
        let imageCount = selectedImages.count
        let canvasFrame = CGRect(x: 0.0, y: 0.0, width: 44.0*Double(imageCount), height: 44.0)
        let canvasView = UIView(frame: canvasFrame)
        
        //        print("self.selectedImages.count = \(self.selectedImages.count)")
        //        print("canvasView.frame is \(canvasFrame.debugDescription)")
        
        selectedImages.enumerated().forEach { (offset, image) in
            let imageViewFrame = CGRect(x: 44.0*Double(offset)+2.0, y: 2.0, width: 40.0, height: 40.0)
            let imageView = UIImageView(frame: imageViewFrame)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
            canvasView.addSubview(imageView)
        }
        self.pickedImageScrollView.contentSize = CGSize(width: 44.0*Double(imageCount), height: 44.0)
        self.pickedImageScrollView.addSubview(canvasView)
        
        //        print("self.imageScrollView.frame is \(self.imageScrollView.frame.debugDescription)")
    }

}

extension ComposeMomentEditorView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text
        let newText = currentText?.replacingCharacters(in: Range<String.Index>(range, in: currentText!)!, with: text)
        
        if newText!.isEmpty {
            textView.text = "Say something"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
}
