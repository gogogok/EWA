//
//  PaddedLabel.swift
//  EWA
//
//  Created by Дарья Жданок on 25.01.26.
//

import UIKit

final class PaddedLabel: UILabel {

    var insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
    }
}
