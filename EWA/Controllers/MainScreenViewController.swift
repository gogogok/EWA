//
//  MainScreenViewController.swift
//  EWA
//
//  Created by Дарья Жданок on 27.01.26.
//

import UIKit
import FirebaseAuth

class MainScreenViewController: UIViewController {
    
    typealias Model = EWAModel
    
    //MARK: - Constants
    private enum Constants {
        
        static let fatalError: String = "Ошибка создания"

    }
    
    //MARK: - Fields
    
    var interactor : EWAInteractor
    
    
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.backgroundColor = .red
        
    }
    
    
}

