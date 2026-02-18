//
//  ChooseMenuButton.swift
//  EWA
//
//  Created by Дарья Жданок on 14.02.26.
//

import UIKit

final class ChooseMenuButton: UIButton {
    
    enum Constants {
        static let buttonLeftRight: CGFloat = 10
        static let buttonCornerRadius: CGFloat = 10
        static let buttonHeight : CGFloat = 57
        static let buttonFont: String = "RubikMonoOne-Regular"
        static let buttonFontSize: CGFloat = 18
    }
    
    var img : UIImage?
    var view: UIView?
    var textLabel: String?
    
    init(imgName: String, text: String, view: UIView) {
        img = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
        self.view = view
        textLabel = text
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureButton() {
        self.setBackgroundImage(img, for: .normal)
        //self.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.layer.cornerRadius = Constants.buttonCornerRadius
        self.pinHorizontal(to: view!, Constants.buttonLeftRight)
        self.layer.borderWidth = 1
        self.setHeight(Constants.buttonHeight)
        self.setTitle(textLabel, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont(name: Constants.buttonFont, size: Constants.buttonFontSize)
        self.layer.masksToBounds = true
    }
    
}

