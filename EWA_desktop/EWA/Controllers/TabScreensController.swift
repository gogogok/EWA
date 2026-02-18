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
    
        static let selectedIndex: Int = 2
        static let fatalError: String = "Ошибка создания"

    }
    
    //MARK: - Fields
    
    var interactor : TabScreenBusinessLogic
    private let customBar = CustomTabBarView()
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        viewControllers = [
            SignUpAssembly.build(),
            SetIconsAssembly.build(),
            HomeScreenAssembly.build(),
            SignUpAssembly.build(),
            RegistrationAssembly.build()
        ]
        selectedIndex = Constants.selectedIndex
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    //MARK: - Lyfecycle
    init(interactor: TabScreenBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        setupCustomTabBar()
    }
    
    private func setupCustomTabBar() {
        view.addSubview(customBar)
        
        customBar.configurePosition(view: view)

        customBar.onSelect = { [weak self] index in
            self?.selectedIndex = index
        }

        customBar.setSelected(index: selectedIndex)
        
    }

}

