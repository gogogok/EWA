//
//  NewUserRegistrationViewController.swift
//  EWA
//
//  Created by Дарья Жданок on 27.01.26.
//

//
//  ViewController.swift
//  EWA
//
//  Created by Дарья Жданок on 25.01.26.
//

import UIKit
import FirebaseAuth

class NewUserRegistrationViewController: UIViewController {
    
    typealias Model = EWAModel
    
    //MARK: - Constants
    private enum Constants {
        static let welcomeLabelTopConstant: CGFloat = 100
        static let welcomeLabelHeightConstant: CGFloat = 150
        static let leftRightWelcomeLabelConstant: CGFloat = 30
        
        static let enterEmailLabelText: String = "Введите адрес электронной почты: "
        static let enterEmailLabelFontSize: CGFloat = 20
        static let enterEmailLabelTop: CGFloat = 30
        static let enterEmailLabelLeftRight: CGFloat = 50
        static let enterEmailLabelCornerRadius: CGFloat = 10
        
        static let enterEmailFieldTop: CGFloat = 30
        static let enterEmailFieldFontSize: CGFloat = 20
        static let enterEmailFieldHeight: CGFloat = 40
        static let enterEmailFieldText: String = "email..."
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        
        static let gradientStartX: CGFloat = 0.6
        static let gradientEndX: CGFloat = 1
        static let gradientStartY: CGFloat = 0.1
        static let gradientEndY: CGFloat = 0.1
        
        static let doneButtonText: String = "Подтвердить"
        static let doneButtonTop : CGFloat = 15
        static let doneButtonLeftRight: CGFloat = 100
        
        static let fatalError: String = "Ошибка создания"
        
        static let alertTitle: String = "Регистрация"
        static let alertMassege: String = "Проверьте почту, отправлена ссылка для подтверждения!"
    }
    
    //MARK: - Fields
    
    var interactor : EWAInteractor
    
    let welcomeLabel: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "EWA_welcome.png")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    var enterEmailLabel: PaddedLabel = PaddedLabel()
    var emailTextField: PaddedTextField = PaddedTextField()
    var doneButton: UIButton = UIButton(type: .system)
    
    private let gradientLayer = CAGradientLayer() //градиент для кнопки
    private var email: String = ""
    
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = emailTextField.bounds
    }
    
    //MARK: - Lyfecycle
    init(interactor: EWAInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .green
        
    }
    
    
}

