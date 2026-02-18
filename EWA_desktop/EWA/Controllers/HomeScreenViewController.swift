//
//  HomeScreenViewController.swift
//  EWA
//
//  Created by Дарья Жданок on 4.02.26.
//

//
//  MainScreenViewController.swift
//  EWA
//
//  Created by Дарья Жданок on 27.01.26.
//

import UIKit
import FirebaseAuth

class HomeScreenViewController: UIViewController {
    
    typealias Model = EWAModel
    
    //MARK: - Constants
    private enum Constants {
        
        static let fatalError: String = "Ошибка создания"

        static let backgroundLeftRight: CGFloat = 50
        
        static let topImageTop: CGFloat = 0
        static let topImageLeft: CGFloat = 25
        static let topImageHeight: CGFloat = 170
        
        static let welcomeLabelText: String = "Выбери, что ты хочешь сделать сегодня! "
        static let welcomeLabelFontSize: CGFloat = 28
        static let welcomeLabelTop: CGFloat = 170
        static let welcomeLabelHeight: CGFloat = 75
        static let welcomeLabelLeftRight: CGFloat = 50
        static let welcomeLabelCornerRadius: CGFloat = 10
        
        static let stackButtonsTop: CGFloat = 70
        static let buttonFont: String = "RubikMonoOne-Regular"
        static let betweenButtonsTop: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 10
        static let buttonLeftRight: CGFloat = 10
        
        static let alarmButtonText: String = "ALARM"
        static let imgAlarm : String = "alarm"
        
        static let studyButtonText: String = "STUDY TOGETHER"
        static let studyImg: String = "study_together"
        
        static let adventureButtonText: String = "ADVENTURE   TIME"
        static let adventureImg: String = "adventure_time"
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let green: String = "#40A27B"
    }
    
    //MARK: - Fields
    
    var interactor : HomeScreenBusinessLogic
    
    let background: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "птица_фон")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    let top_image: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "right_top_registation")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    var welcomeLabel: PaddedLabel = PaddedLabel()
    var alarmButton : ChooseMenuButton?
    var adventureButton :  ChooseMenuButton?
    var studyButton : ChooseMenuButton?
    
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for button in [alarmButton, adventureButton, studyButton] {
            button!.layer.cornerRadius = Constants.buttonCornerRadius
        }
    }
    
    //MARK: - Lyfecycle
    init(interactor: HomeScreenBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        configureBackgroudUI()
        configureWelcomeLabel()
        configureButtons()
    }
    
    private func configureBackgroudUI() {
        view.backgroundColor = .white
        view.addSubview(background)
        view.addSubview(top_image)
        
        view.backgroundColor = .white
        top_image.pinTop(to: view, Constants.topImageTop)
        top_image.pinLeft(to: view.leadingAnchor, Constants.topImageLeft)
        top_image.setHeight(Constants.topImageHeight)
        
        
        background.pinCenter(to: view)
        background.pinHorizontal(to: view, Constants.backgroundLeftRight)
        
        view.sendSubviewToBack(top_image)
        view.sendSubviewToBack(background)
    }
    
    private func configureWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.text = Constants.welcomeLabelText
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .black
        welcomeLabel.font = UIFont(name: Constants.buttonFont, size: Constants.welcomeLabelFontSize)
        welcomeLabel.numberOfLines = 2
        welcomeLabel.pinTop(to: view, Constants.welcomeLabelTop)
        welcomeLabel.pinHorizontal(to: view, Constants.welcomeLabelLeftRight)
        welcomeLabel.setHeight(Constants.welcomeLabelHeight)
        welcomeLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.welcomeLabelFontSize)
        
        welcomeLabel.layer.borderWidth = 1
        welcomeLabel.layer.cornerRadius = Constants.welcomeLabelCornerRadius
        welcomeLabel.layer.masksToBounds = true
        welcomeLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
    }
    
    private func configureButtons() {
        alarmButton = ChooseMenuButton(imgName: Constants.imgAlarm, text: Constants.alarmButtonText, view: view)
        adventureButton = ChooseMenuButton(imgName: Constants.adventureImg, text: Constants.adventureButtonText, view: view)
        studyButton = ChooseMenuButton(imgName: Constants.studyImg, text: Constants.studyButtonText, view: view)
        let buttonStackView = UIStackView(arrangedSubviews: [alarmButton!, adventureButton!, studyButton!])
        view.addSubview(buttonStackView)
        for button in [alarmButton!, adventureButton!, studyButton!] {
            button.configureButton()
        }
        
        
        buttonStackView.axis = .vertical
        buttonStackView.spacing = Constants.betweenButtonsTop
        buttonStackView.pinTop(to: welcomeLabel.bottomAnchor, Constants.stackButtonsTop)
        buttonStackView.pinHorizontal(to: view, Constants.stackButtonsTop)
    }
}

