import UIKit

final class MyEventsViewController: UIViewController {
    
    typealias Model = MyEventsModel
    
    //MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Ошибка создания"
    }
    
    //MARK: - Fields
    
    var interactor : MyEventsBusinessLogic
    
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    //MARK: - Lyfecycle
    init(interactor: MyEventsBusinessLogic) {
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

