//
//  CustomTabBarView.swift
//  EWA
//
//  Created by Дарья Жданок on 17.02.26.
//
import UIKit

final class CustomTabBarView: UIView {

    enum Constants {
        static let iconSize: CGFloat = 30
        static let customIconSize: CGFloat = 40
        static let stackLeftRight: CGFloat = 15
        static let stackTopBottom: CGFloat = 5
        
        static let indicatorWidth: CGFloat = 68
        static let indicatorHeight: CGFloat = 75
        static let indicatorCornerRadius: CGFloat = 12
        static let selectedScale: CGFloat = 1.20
        
        static let barBackgroundColor: UIColor = UIColor(hex: "#F3EDF7")!
        static let indicatorBackgroundColor: UIColor = UIColor(hex: "#EEDDF9")!
        
        static let selfBottom: CGFloat = 10
        static let selfLeftRight: CGFloat = 40
        static let selfCornerRadius: CGFloat = 20
        
        static let shadowHeight: CGFloat = 8
        
        static let borderWidth: CGFloat = 1
        
        static let sf = ["gearshape", "alarm", "house", "book"]
        static let adventureIcon: String = "adventure_icon"
        
        static let selectUp: CGFloat = -10
        
    }
    
    var onSelect: ((Int) -> Void)?

    private let stack = UIStackView()
    private let buttons: [UIButton] = [
        UIButton(type: .system),
        UIButton(type: .system),
        UIButton(type: .system),
        UIButton(type: .system),
        UIButton(type: .custom)
    ]
    private let indicatorView = UIView()
    private var selectedIndex: Int = 2

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        positionIndicator(at: selectedIndex, animated: false)
    }
    
    public func configurePosition(view: UIView) {
        self.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.selfBottom)
        self.pinHorizontal(to: view, Constants.selfLeftRight)
    }
    
    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = Constants.selfCornerRadius
        layer.shadowOpacity = 0.2
        layer.shadowRadius = Constants.selfCornerRadius
        layer.shadowOffset = CGSize(width: 0, height: Constants.shadowHeight)
        
        
        indicatorView.backgroundColor = Constants.indicatorBackgroundColor
        indicatorView.layer.cornerRadius = Constants.indicatorCornerRadius
        indicatorView.layer.borderWidth = Constants.borderWidth
        indicatorView.layer.borderColor = UIColor.lightGray.cgColor
        indicatorView.isUserInteractionEnabled = false
        addSubview(indicatorView)

        addSubview(stack)
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.pinHorizontal(to: self, Constants.stackLeftRight)
        stack.pinVertical(to: self, Constants.stackTopBottom)
        
        
        let config = UIImage.SymbolConfiguration(pointSize: Constants.iconSize, weight: .regular)
        
        for (ind, button) in buttons.enumerated() {
            
            if ind == buttons.count - 1 {
                let image = UIImage(named: Constants.adventureIcon)
                button.setImage(image, for: .normal, )
                button.setWidth(Constants.customIconSize)
                button.setHeight(Constants.customIconSize)
                button.imageView?.contentMode = .scaleAspectFit
                button.imageView?.clipsToBounds = true
                button.tintColor = .clear
            } else {
                button.setImage(UIImage(systemName: Constants.sf[ind], withConfiguration: config), for: .normal)
                button.tintColor = .black
            }
            button.tag = ind
            button.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)

            stack.addArrangedSubview(button)
        }
        selectedIndex = 2
        
    }

    func setSelected(index: Int, animated: Bool = true) {
        selectedIndex = index

        for (ind, button) in buttons.enumerated() {
            
            let isSelected = (ind == index)

            let updates = {
                if isSelected {
                    let scale = CGAffineTransform(scaleX: Constants.selectedScale, y: Constants.selectedScale)
                    let translate = CGAffineTransform(translationX: 0, y: Constants.selectUp)
                    button.transform = scale.concatenating(translate)
                } else {
                    button.transform = .identity
                }
            }

            if animated {
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
                    updates()
                }
            } else {
                updates()
            }
        }

        positionIndicator(at: index, animated: animated)
    }

    private func positionIndicator(at index: Int, animated: Bool) {
        guard index >= 0, index < buttons.count else { return }
        
        stack.layoutIfNeeded()

        let button = buttons[index]
        let buttonFrameInSelf = stack.convert(button.frame, to: self)

        let width = Constants.indicatorWidth
        let height = Constants.indicatorHeight
        
        let targetFrame = CGRect(
            x: buttonFrameInSelf.midX - width / 2,
            y: buttonFrameInSelf.midY - height / 2,
            width: width,
            height: height
        )

        let changes = {
            self.indicatorView.frame = targetFrame
        }

        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
                changes()
            }
        } else {
            changes()
        }
    }

    
    @objc private func tap(_ sender: UIButton) {
        setSelected(index: sender.tag)
        onSelect?(sender.tag)
    }
    
}
