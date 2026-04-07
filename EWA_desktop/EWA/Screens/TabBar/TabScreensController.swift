import UIKit
import FirebaseAuth

class TabScreensController: UITabBarController {
    
    typealias Model = TabBarModel
    
    //MARK: - Constants
    private enum Constants {
        static let selectedIndex: Int = 4
        static let fatalError: String = "Ошибка создания"
    }
    
    //MARK: - Fields
    var interactor: TabScreenBusinessLogic
    private let customBar = CustomTabBarView()
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        
        viewControllers = [
            UINavigationController(rootViewController: SettingsMainScreenAssembly.build()),
            UINavigationController(rootViewController: SetIconsAssembly.build()),
            UINavigationController(rootViewController: HomeScreenAssembly.build()),
            UINavigationController(rootViewController: SignUpAssembly.build()),
            UINavigationController(rootViewController: AdventureMainScreenAssembly.build())
        ]
        
        selectedIndex = Constants.selectedIndex
        configureUI()
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
