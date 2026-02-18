//
//  AdaptiveGridStackView.swift
//  EWA
//
//  Created by Дарья Жданок on 14.02.26.
//

import UIKit

final class AdaptiveGridStackView: UIStackView {

    private enum Constants {
        static let iconCornerConstant: CGFloat = 6
    }
    
    private let columns: Int
    private let spacingValue: CGFloat

    init(columns: Int, spacing: CGFloat) {
        self.columns = columns
        self.spacingValue = spacing
        super.init(frame: .zero)

        axis = .vertical
        self.spacing = spacing
        alignment = .fill
        distribution = .fill
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setItems(_ views: [UIView]) {

        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        var index = 0

        while index < views.count {

            let rowViews = Array(views[index..<min(index + columns, views.count)])
            let row = UIStackView(arrangedSubviews: rowViews)

            row.axis = .horizontal
            row.spacing = spacingValue
            row.distribution = .fillEqually
            row.alignment = .fill

            addArrangedSubview(row)

            rowViews.forEach { view in
                view.translatesAutoresizingMaskIntoConstraints = false

                view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            }

            index += columns
        }
    }
}

