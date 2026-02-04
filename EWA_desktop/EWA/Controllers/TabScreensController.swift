//
//  MainScreenViewController.swift
//  EWA
//
//  Created by Дарья Жданок on 27.01.26.
//

import UIKit
import FirebaseAuth

class TabScreensController: UITabBarController {
    
    typealias Model = EWAModel
    
    //MARK: - Constants
    private enum Constants {
    
        static let fatalError: String = "Ошибка создания"

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
    
    var welcomeLabel: PaddedLabel = PaddedLabel()
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            NewUserNameRegistrationViewController(interactor: interactor),
            HomeScreenViewController(interactor: interactor),
            ProfileIconChooseScreenController(interactor: interactor)
        ]
        selectedIndex = 1
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
    }

}

