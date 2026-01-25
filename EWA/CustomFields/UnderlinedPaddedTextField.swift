import UIKit

final class UnderlinedPaddedTextField: UITextField {
    
    var insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let underlineLayer = CALayer()
    var underlineHeight: CGFloat = 1
    var underlineColor: UIColor = .systemGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        underlineLayer.frame = CGRect(
            x: 0,
            y: bounds.height - underlineHeight,
            width: bounds.width,
            height: underlineHeight
        )
    }

    
    private func commonInit() {
        borderStyle = .none
        underlineLayer.backgroundColor = underlineColor.cgColor
        layer.addSublayer(underlineLayer)
        underlineLayer.zPosition = 999
    }
    
}
