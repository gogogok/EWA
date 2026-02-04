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

class NewUserNameRegistrationViewController: UIViewController {
    
    typealias Model = EWAModel
    
    //MARK: - Constants
    private enum Constants {
        
        static let backgroundLeftRight: CGFloat = 50
        
        static let topImageTop: CGFloat = -47
        
        static let fatalError: String = "Ошибка создания"
        
        static let enterNameLabelText: String = "Введите имя пользователя: "
        static let enterNameLabelFontSize: CGFloat = 20
        static let enterNameLabelTop: CGFloat = 95
        static let enterNameLabelLeftRight: CGFloat = 60
        static let enterNameLabelCornerRadius: CGFloat = 10
        
        static let enterNameFieldTop: CGFloat = 28
        static let enterNameFieldFontSize: CGFloat = 16
        static let enterNameFieldHeight: CGFloat = 35
        static let enterNameFieldText: String = "Имя пользователя..."
        static let enterNameFieldLeftRight: CGFloat = 90
        
        static let doneButtonText: String = "Далее"
        static let doneButtonTop : CGFloat = 28
        static let doneButtonLeftRight: CGFloat = 140
        static let doneButtonFontSize: CGFloat = 18
        static let doneButtonBoundWidth: CGFloat = 1.2
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        
        static let gradientStartX: CGFloat = 0.6
        static let gradientEndX: CGFloat = 1
        static let gradientStartY: CGFloat = 0.1
        static let gradientEndY: CGFloat = 0.1
    }
    
    //MARK: - Fields
    
    var interactor : EWAInteractor
    
    let background: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "птица_фон.png")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    let top_image: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "top_registratione_first.png")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    var enterNameLabel: PaddedLabel = PaddedLabel()
    var nameTextField: PaddedTextField = PaddedTextField()
    var doneButton: UIButton = UIButton(type: .system)
    
    private let gradientLayer = CAGradientLayer()
    
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = nameTextField.bounds
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
        configureGradient()
        
        view.backgroundColor = .white
        configureBackgroudUI()
        configureNameLabel()
        configureEnterNameTextField()
        configureDoneButton()
    }
    
    private func configureBackgroudUI() {
        view.backgroundColor = .white
        view.addSubview(background)
        view.addSubview(top_image)
        
        top_image.pinTop(to: view, Constants.topImageTop)
        top_image.pinHorizontal(to: view)
        
        background.pinCenter(to: view)
        background.pinHorizontal(to: view, Constants.backgroundLeftRight)
        
        view.sendSubviewToBack(background)
        view.sendSubviewToBack(top_image)
    }
    
    private func configureNameLabel() {
        view.addSubview(enterNameLabel)
        enterNameLabel.text = Constants.enterNameLabelText
        enterNameLabel.textAlignment = .center
        enterNameLabel.textColor = .black
        enterNameLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.enterNameLabelFontSize)
        enterNameLabel.pinTop(to: view, Constants.enterNameLabelTop)
        enterNameLabel.pinHorizontal(to: view, Constants.enterNameLabelLeftRight)
        
        enterNameLabel.layer.borderWidth = 1
        enterNameLabel.layer.cornerRadius = Constants.enterNameLabelCornerRadius
        enterNameLabel.layer.masksToBounds = true
        enterNameLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
    }
    
    private func configureEnterNameTextField() {
        view.addSubview(nameTextField)
        
        nameTextField.isEnabled = true
        nameTextField.tintColor = .black
        nameTextField.placeholder = Constants.enterNameFieldText
        
        nameTextField.textAlignment = .center
        nameTextField.textColor = .black
        nameTextField.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.enterNameFieldFontSize)
        nameTextField.pinTop(to: enterNameLabel.bottomAnchor, Constants.enterNameFieldTop)
        nameTextField.pinHorizontal(to: view, Constants.enterNameFieldLeftRight)
        nameTextField.setHeight(Constants.enterNameFieldHeight)
        
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = Constants.enterNameLabelCornerRadius
        nameTextField.layer.masksToBounds = true
        nameTextField.layer.insertSublayer(gradientLayer, at: 0)
        
        nameTextField.autocapitalizationType = .none
        nameTextField.keyboardType = .emailAddress
        nameTextField.autocorrectionType = .no

    }
    
    private func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.setTitle(Constants.doneButtonText, for: .normal)
        doneButton.titleLabel?.textAlignment = .center
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Bold", size: Constants.doneButtonFontSize)
        doneButton.pinTop(to: nameTextField.bottomAnchor, Constants.doneButtonTop)
        doneButton.pinHorizontal(to: view, Constants.doneButtonLeftRight)
        
        doneButton.layer.borderWidth = Constants.doneButtonBoundWidth
        doneButton.layer.cornerRadius = Constants.enterNameLabelCornerRadius
        doneButton.layer.masksToBounds = true
        doneButton.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightLightPurple)
        
        doneButton.addTarget(self, action: #selector(dispalaySecondRegistrationScreen), for: .touchUpInside)
    }
    
    
    
    //MARK: - TargetFunc
    @objc
    private func dispalaySecondRegistrationScreen() {
        let viewController: ProfileIconChooseScreenController = ProfileIconChooseScreenController(
            interactor: interactor
        )
        interactor.loadSecondRegistrationScreen(Model.GetProfileIcon.Request(viewController: viewController, name: nameTextField.text!))
    }
    
    //MARK: - Help func
    private func configureGradient() {
        gradientLayer.colors = [
            UIColor(hex: Constants.lightLightPurple)!.cgColor,
            UIColor(hex: Constants.purple)!.cgColor,
        ]
        
        gradientLayer.startPoint = CGPoint(x: Constants.gradientStartX, y: Constants.gradientStartY)
        gradientLayer.endPoint   = CGPoint(x: Constants.gradientEndX, y: Constants.gradientEndY)
    }
    
    func displayIconRegistrationScreen(_ viewModel: Model.GetProfileIcon.ViewModel) {
        navigationController?.pushViewController(viewModel.viewController, animated: true)
    }
    
}


