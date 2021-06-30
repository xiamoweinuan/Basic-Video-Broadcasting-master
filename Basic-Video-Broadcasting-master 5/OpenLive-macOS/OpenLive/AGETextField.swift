//
//  AGETextField.swift
//
//  Created by CavanSu on 2019/9/29.
//  Copyright © 2019 Agora. All rights reserved.
//

import Cocoa

extension NSAttributedString {
    convenience init(title: String, with color: NSColor, alignment: AGETextAlignment = .center) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraph,
                          NSAttributedString.Key.foregroundColor: color]
        
        self.init(string: title, attributes: attributes)
    }
}

class AGETextField: NSTextField {
    override func becomeFirstResponder() -> Bool {
        if let editor = self.currentEditor() as? NSTextView {
            editor.insertionPointColor = NSColor.AGBlue
        }

        return super.becomeFirstResponder()
    }
}

extension NSTextField {
    func setTitle(_ title: String, with color: NSColor, alignment: AGETextAlignment = .center) {
        self.attributedStringValue = NSAttributedString(title: title,
                                                        with: color,
                                                        alignment: alignment)
    }
    
    func setPlacehold(_ title: String, with color: NSColor, alignment: AGETextAlignment = .center) {
        self.placeholderAttributedString = NSAttributedString(title: title,
                                                              with: color,
                                                              alignment: alignment)
    }
    
    private func getAttributes(_ title: String, with color: NSColor, alignment: AGETextAlignment = .center) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraph,
                          NSAttributedString.Key.foregroundColor: color]
        
        return NSAttributedString(string: title,
                                  attributes: attributes)
    }
}

class AGETextFieldCell: NSTextFieldCell {
    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        var frame: NSRect
        
        if let newFrame = adjstedFrameToVerticallyCenterText(frame: rect) {
            frame = newFrame
        } else {
            frame = rect
        }
        
        super.edit(withFrame: frame, in: controlView, editor: textObj, delegate: delegate, event: event)
    }
    
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        var frame: NSRect
        
        if let newFrame = adjstedFrameToVerticallyCenterText(frame: rect) {
            frame = newFrame
        } else {
            frame = rect
        }
        
        super.select(withFrame: frame, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        var frame: NSRect
        
        if let newFrame = adjstedFrameToVerticallyCenterText(frame: cellFrame) {
            frame = newFrame
        } else {
            frame = cellFrame
        }
        
        super.drawInterior(withFrame: frame, in: controlView)
    }
    
    private func adjstedFrameToVerticallyCenterText(frame: NSRect) -> NSRect? {
        guard let fontHeight = self.font?.boundingRectForFont.size.height else {
            return nil
        }
        
        let offset = (Float(NSHeight(frame)) - ceilf(Float(fontHeight))) * 0.5
        return NSInsetRect(frame, 0, CGFloat(offset))
    }
}
