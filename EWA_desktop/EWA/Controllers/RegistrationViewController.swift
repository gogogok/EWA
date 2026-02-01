//
//  ViewController.swift
//  EWA
//
//  Created by Дарья Жданок on 25.01.26.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
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
        view.backgroundColor = .white
        
        configureGradient()
        
        configureWelcomeLabel()
        configureEnterEmailLabel()
        configureEnterEmaiTextField()
        configureDoneButton()
    }
    
    private func configureWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.setHeight(Constants.welcomeLabelHeightConstant)
        welcomeLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.welcomeLabelTopConstant)
        welcomeLabel.pinHorizontal(to: view, Constants.leftRightWelcomeLabelConstant)
        
    }
    
    private func configureEnterEmailLabel() {
        view.addSubview(enterEmailLabel)
        enterEmailLabel.text = Constants.enterEmailLabelText
        enterEmailLabel.textAlignment = .center
        enterEmailLabel.textColor = .black
        enterEmailLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.enterEmailLabelFontSize)
        enterEmailLabel.pinTop(to: welcomeLabel.bottomAnchor, Constants.enterEmailLabelTop)
        enterEmailLabel.pinHorizontal(to: view, Constants.enterEmailLabelLeftRight)
        
        enterEmailLabel.layer.borderWidth = 1
        enterEmailLabel.layer.cornerRadius = Constants.enterEmailLabelCornerRadius
        enterEmailLabel.layer.masksToBounds = true
        enterEmailLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
        
    }
    
    private func configureEnterEmaiTextField() {
        view.addSubview(emailTextField)
        
        emailTextField.isEnabled = true
        emailTextField.tintColor = .black
        emailTextField.placeholder = Constants.enterEmailFieldText
        
        emailTextField.textAlignment = .center
        emailTextField.textColor = .black
        emailTextField.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.enterEmailFieldFontSize)
        emailTextField.pinTop(to: enterEmailLabel.bottomAnchor, Constants.enterEmailFieldTop)
        emailTextField.pinHorizontal(to: view, Constants.enterEmailLabelLeftRight)
        emailTextField.setHeight(Constants.enterEmailFieldHeight)
        
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = Constants.enterEmailLabelCornerRadius
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.insertSublayer(gradientLayer, at: 0)
        
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
    }
    
    private func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.setTitle(Constants.doneButtonText, for: .normal)
        doneButton.titleLabel?.textAlignment = .center
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Bold", size: Constants.enterEmailLabelFontSize)
        doneButton.pinTop(to: emailTextField.bottomAnchor, Constants.doneButtonTop)
        doneButton.pinHorizontal(to: view, Constants.doneButtonLeftRight)
        
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = Constants.enterEmailLabelCornerRadius
        doneButton.layer.masksToBounds = true
        doneButton.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightLightPurple)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func configureGradient() {
        gradientLayer.colors = [
            UIColor(hex: Constants.lightLightPurple)!.cgColor,
            UIColor(hex: Constants.purple)!.cgColor,
        ]
        
        gradientLayer.startPoint = CGPoint(x: Constants.gradientStartX, y: Constants.gradientStartY)
        gradientLayer.endPoint   = CGPoint(x: Constants.gradientEndX, y: Constants.gradientEndY)
    }
    
    //MARK: - target func
    
    @objc
    private func doneButtonTapped() {
        email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        interactor.loadEmail(Model.GetEmail.Request(email: email))
        showInfoAlert(title: Constants.alertTitle, message: Constants.alertMassege)
    }
    
    
    //MARK: - Help func
    private func showInfoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

}

