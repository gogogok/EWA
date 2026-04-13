//
//  PaddedLabelPinTop.swift
//  EWA
//
//  Created by Дарья Жданок on 12.04.26.
//

import UIKit

final class PaddedLabelPinTop: UILabel {

    var insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: insets)
        
        let textHeight = super.sizeThatFits(insetRect.size).height
        
        let topRect = CGRect(
            x: insetRect.origin.x,
            y: insetRect.origin.y,
            width: insetRect.width,
            height: textHeight
        )
        
        super.drawText(in: topRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
    }
}

