import UIKit

final class MyEventsSectionHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "MyEventsSectionHeaderView"
    
    private let titleLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: 20)
        label.numberOfLines = 1
        label.backgroundColor = UIColor(hex: "#B895FF")
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.pinVertical(to: self, 8)
        titleLabel.pinHorizontal(to: self, 90)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
