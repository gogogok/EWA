import UIKit

final class GradientActionButton: UIButton {
    
    private let gradientLayer = CAGradientLayer()
    private let iconImageView = UIImageView()
    let customTitleLabel = UILabel()
    
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
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .black
        addSubview(iconImageView)
        
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        customTitleLabel.numberOfLines = 2
        customTitleLabel.textAlignment = .center
        customTitleLabel.textColor = .black
        customTitleLabel.font = UIFont(name: "Tinos-Bold", size: 15)
        addSubview(customTitleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 35),
            
            customTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            customTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            customTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            customTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func configure(title: String, image: UIImage?) {
        customTitleLabel.text = title
        iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
    }
}
