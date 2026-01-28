//
//  ProfileIconChooseScreen.swift
//  EWA
//
//  Created by Дарья Жданок on 28.01.26.
//

//

import UIKit
import FirebaseAuth

class ProfileIconChooseScreenController : UIViewController {
    
    typealias Model = EWAModel
    
    //MARK: - Constants
    private enum Constants {
        
        static let fatalError: String = "Ошибка создания"
        
        static let backgroundLeftRight: CGFloat = 50
        
        static let topImageTop: CGFloat = -18
        static let topImageLeft: CGFloat = 25
        static let topImageHeight: CGFloat = 170
        
        static let bottonImageHeight: CGFloat = 170
        static let bottonImageHBottom: CGFloat = -10
        
        static let backButtonWidthConstant: CGFloat = 2.3
        static let backButtonTop: CGFloat = -100
        
        static let сhooseIconLabelText: String = "Выбери новую аватарку! "
        static let сhooseIconLabelFontSize: CGFloat = 20
        static let сhooseIconLabelTop: CGFloat = 200
        static let сhooseIconLabelLeftRight: CGFloat = 60
        static let сhooseIconLabelCornerRadius: CGFloat = 10
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        
    }
    
    //MARK: - Fields
    
    var interactor : EWAInteractor
    
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
    
    let bottom_image: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "left_bottom_registration")
        label.contentMode = .scaleAspectFit
        label.tintColor = .white
        return label
    }()
    
    
    let customBackButton = UIButton(type: .system)
    var сhooseIconLabel: PaddedLabel = PaddedLabel()
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
        configureBackgroudUI()
        configurebackButton()
        configureChooseIconLabel()
        
    }
    
    private func configureBackgroudUI() {
        view.addSubview(background)
        view.addSubview(top_image)
        view.addSubview(bottom_image)
        
        view.backgroundColor = .white
        top_image.pinTop(to: view, Constants.topImageTop)
        top_image.pinLeft(to: view.leadingAnchor, Constants.topImageLeft)
        top_image.setHeight(Constants.topImageHeight)

        bottom_image.pinBottom(to: view.bottomAnchor, Constants.bottonImageHBottom)
        bottom_image.pinLeft(to: view.leadingAnchor)
        bottom_image.setHeight(Constants.bottonImageHeight)
        bottom_image.setWidth(Constants.bottonImageHeight)
        
        background.pinCenter(to: view)
        background.pinHorizontal(to: view, Constants.backgroundLeftRight)
        
        view.sendSubviewToBack(top_image)
        view.sendSubviewToBack(bottom_image)
        view.sendSubviewToBack(background)
    }
    
    private func configurebackButton() {
        
        let img = UIImage(named: "back_button")?.withRenderingMode(.alwaysOriginal)
        customBackButton.setImage(img, for: .normal)
        customBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        customBackButton.imageView?.contentMode = .scaleAspectFit
        
        view.addSubview(customBackButton)
        let viewWidth: CGFloat = view.frame.width
        customBackButton.pinTop(to: view.topAnchor, Constants.backButtonTop)
        customBackButton.setWidth(viewWidth / Constants.backButtonWidthConstant)
        customBackButton.pinLeft(to: view)
    }
    
    private func configureChooseIconLabel() {
        view.addSubview(сhooseIconLabel)
        сhooseIconLabel.text = Constants.сhooseIconLabelText
        сhooseIconLabel.textAlignment = .center
        сhooseIconLabel.textColor = .black
        сhooseIconLabel.font = UIFont(name: "YanoneKaffeesatz-ExtraLight_Regular", size: Constants.сhooseIconLabelFontSize)
        сhooseIconLabel.pinTop(to: view, Constants.сhooseIconLabelTop)
        сhooseIconLabel.pinHorizontal(to: view, Constants.сhooseIconLabelLeftRight)
        
        сhooseIconLabel.layer.borderWidth = 1
        сhooseIconLabel.layer.cornerRadius = Constants.сhooseIconLabelCornerRadius
        сhooseIconLabel.layer.masksToBounds = true
        сhooseIconLabel.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
    }
    
    //MARK: - Target func
    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

