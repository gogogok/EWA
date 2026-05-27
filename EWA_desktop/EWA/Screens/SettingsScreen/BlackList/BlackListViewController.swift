import UIKit

final class BlackListViewController: UIViewController {
    
    typealias Model = BlackListModel
    
    //MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Ошибка создания"
        
        static let viewTopInset: CGFloat = 60
        static let viewBottomInset: CGFloat = 190
        static let viewLeftRightInset: CGFloat = 30
        static let viewCornerRadius: CGFloat = 20
        
        static let backButtonWidthConstant: CGFloat = 2.1
        static let backButtonTop: CGFloat = -60
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let pinkLightPurple: String = "#EDD1FF"
        static let green: String = "#40A27B"
        
        static let topFont: String = "YanoneKaffeesatz-ExtraLight_Regular"
    }
    
    //MARK: - Fields
    
    var interactor : BlackListBusinessLogic
    
    var backView: UIView = UIView()
    let customBackButton = UIButton(type: .system)
    
    private var usersInList: [UserResponse] = []

    private lazy var usersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ParticipantCell.self, forCellWithReuseIdentifier: ParticipantCell.reuseId)
        
        return collectionView
    }()
    
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Чёрный список"
        label.font = UIFont(name: Constants.topFont, size: 30)
        return label
    }()
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurebackButton()
        loadUsers()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Lyfecycle
    init(
        interactor: BlackListBusinessLogic
    ) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    private func loadUsers() {
        Task {
            do {
                guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else { return }
                let usersInBlackList = try await UserApiClient.shared.getBlackList(userId: userId)
                
                usersInList = usersInBlackList
                usersCollectionView.reloadData()
            } catch {
                showAlert(error: error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - Configure UI
    private func configureUI() {
        configureView()
        configureTitleLabel()
        configureParticipantsCollectionView()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.addSubview(backView)
        backView.backgroundColor = UIColor(hex: Constants.pinkLightPurple)
        backView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.viewTopInset)
        backView.pinBottom(to: view, Constants.viewBottomInset)
        backView.pinHorizontal(to: view, Constants.viewLeftRightInset)
        
        backView.layer.cornerRadius = Constants.viewCornerRadius
    }
    
    private func configurebackButton() {
        let img = UIImage(named: "close_button")?.withRenderingMode(.alwaysOriginal)
        customBackButton.setImage(img, for: .normal)
        customBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        customBackButton.imageView?.contentMode = .scaleAspectFit
        
        view.addSubview(customBackButton)
        let viewWidth: CGFloat = view.frame.width
        customBackButton.pinTop(to: view.topAnchor, Constants.backButtonTop)
        customBackButton.setWidth(viewWidth / Constants.backButtonWidthConstant)
        customBackButton.pinRight(to: view.trailingAnchor)
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: backView.topAnchor, 30)
        titleLabel.pinCenterX(to: backView)
    }
    
    private func configureParticipantsCollectionView() {
        backView.addSubview(usersCollectionView)
        
        usersCollectionView.pinTop(to: titleLabel.bottomAnchor, 10)
        usersCollectionView.pinHorizontal(to: backView, 16)
        usersCollectionView.pinBottom(to: backView.bottomAnchor, 20)
    }
    
    private func showUsersAlert(
        user: UserResponse
    ) {
        
        let alert = UIAlertController(
            title: "Удалить из чёрного списка?",
            message: "\(user.name) снова сможет с вами взаимодействовать",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.interactor.deleteFromBlackList(Model.DeleteFromBlackList.Request(userId: user.id))
        })
        
        present(alert, animated: true)
    }
    
    private func showAlert(error: String?) {
        let message = error ?? "Пользователь удалён из чёрного списка"
        let alert = UIAlertController(
            title: "Готово",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    //MARK: - Target func
    @objc
    func goBack() {
        dismiss(animated: true)
    }
    
    func displaAddTolackListSuccess(vm: Model.DeleteFromBlackList.ViewModel) {
        DispatchQueue.main.async {
            self.showAlert(error: vm.error)
        }
    }

}

extension BlackListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        usersInList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ParticipantCell.reuseId,
            for: indexPath
        ) as? ParticipantCell else {
            return UICollectionViewCell()
        }
        
        let user = usersInList[indexPath.item]
        cell.configureWithUser(user: user)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let user = usersInList[indexPath.item]
        showUsersAlert(user: user)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.frame.width - 32,
            height: 60
        )
    }
}
