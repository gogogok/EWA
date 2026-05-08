//
//  ColorPickerStackView.swift
//  EWA
//
//  Created by Дарья Жданок on 24.04.26.
//

import UIKit

final class ColorPickerStackView: UIStackView {

    private let colors: [(name: String, color: UIColor)] = [
        ("#00D78C", UIColor(hex: "#00D78C") ?? .green),
        ("#F38143", UIColor(hex: "#F38143") ?? UIColor.systemOrange),
        ("#890404", UIColor(hex: "#890404") ?? UIColor(red: 0.35, green: 0, blue: 0, alpha: 1))
    ]

    private var buttons: [UIButton] = []
    private(set) var selectedColorHex: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
        setupButtons()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStack() {
        axis = .horizontal
        spacing = 15
        distribution = .fillEqually
        alignment = .center
    }

    private func setupButtons() {
        colors.forEach { item in
            let button = UIButton(type: .system)

            button.backgroundColor = item.color
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.tintColor = .black

            button.setTitle("", for: .normal)
            button.accessibilityIdentifier = item.name

            button.addTarget(self, action: #selector(colorTapped(_:)), for: .touchUpInside)

            button.setWidth(90)
            button.setHeight(90)

            buttons.append(button)
            addArrangedSubview(button)
        }
    }
    
    func selectColor(name: String) {
        guard let button = buttons.first(where: {
            $0.accessibilityIdentifier == name
        }) else { return }
        
        select(button)
    }
    
    private func select(_ sender: UIButton) {
        buttons.forEach {
            $0.setImage(nil, for: .normal)
        }
        
        sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
        sender.tintColor = .black
        sender.imageView?.contentMode = .scaleAspectFit
        
        selectedColorHex = sender.accessibilityIdentifier
    }
    
    @objc private func colorTapped(_ sender: UIButton) {
        select(sender)
    }
}
