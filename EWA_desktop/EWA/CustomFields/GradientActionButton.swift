//
//  GradientActionButton.swift
//  EWA
//
//  Created by Дарья Жданок on 10.04.26.
//
import UIKit

final class GradientActionButton: UIButton {
    
    private let iconImageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        gradientLayer.colors = [
            UIColor(hex: "#9F5FFC")!.cgColor,
            UIColor(hex: "#D0B9FF")!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)
        
        titleLabel?.numberOfLines = 2
        titleLabel?.font = UIFont(name: "Tinos-Bold", size: 15)
        titleLabel?.textAlignment = .center
        
        setTitleColor(.black, for: .normal)
        contentHorizontalAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        iconImageView.frame = CGRect(
            x: 8,
            y: bounds.height * 0.2,
            width: bounds.height,
            height: bounds.height
        )
        
        titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: iconImageView.frame.maxX + 2,
            bottom: 0,
            right: 0
        )
    }
    
    func configure(title: String, image: UIImage?) {
        setTitle(title, for: .normal)
        iconImageView.image = image
    }
}
