import UIKit
import Foundation

final class MyAlarmsViewController: UIViewController {
    
    typealias Model = MyAlarmsModel
    
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
        static let backButtonTop: CGFloat = -120
        
        static let contentViewTop: CGFloat = 53
        static let contentViewBottom : CGFloat = 90
        
        static let purple: String = "#9F5FFC"
        static let topPurple : String = "#B895FF"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let pinkLightPurple: String = "#EDD1FF"
        static let lightGreen: String = "#9DE8CE"
        static let green: String = "#40A27B"
        
        static let yanoneKaffeesatzBold: String = "YanoneKaffeesatz-ExtraLight_Bold"
        static let yanoneKaffeesatzRegular: String = "YanoneKaffeesatz-ExtraLight_Regular"
    }
    
    //MARK: - Fields
    
    var interactor : MyAlarmsBusinessLogic
    
    private var collectionView: UICollectionView!
    
    private var createdAlarms: [AlarmResponse] = []
    private var registeredAlarms: [AlarmResponse] = []
    
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
    
    let customBackButton = UIButton(type: .system)
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.loadUserCreatedAlarms(Model.LoadAlarms.Request())
        interactor.loadUserPartAlarms(Model.LoadAlarms.Request())
    }
    
    //MARK: - Lifecycle
    init(interactor: MyAlarmsBusinessLogic) {
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
        configureCollectionView()
    }
    
    private func configureBackgroudUI() {
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
    
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 20, bottom: 10, right: 20)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 60)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(AlarmCollectionCardCell.self, forCellWithReuseIdentifier: "AlarmCollectionCardCell")
        collectionView.register(
            MyEventsSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier:  "MyEventsSectionHeaderView"
        )
        
        view.addSubview(collectionView)
        
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.contentViewTop)
        collectionView.pinHorizontal(to: view)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.contentViewBottom)
    }
    
    
    //MARK: - Public func
    func eventSaved() {
        goBack()
    }
    
    //MARK: - Target func
    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: - Load func
    func loadCreateData(_ vm: Model.LoadAlarms.ViewModel) {
        guard let alarms = vm.alarms else {return}
        createdAlarms = alarms
        collectionView.reloadData()
    }
    
    func loadPartData(_ vm: Model.LoadAlarms.ViewModel) {
        guard let alarms = vm.alarms else {return}
        registeredAlarms = alarms
        collectionView.reloadData()
    }
    
    func alarmtLeft(_ vm: Model.LoadLeaveAlarms.ViewModel) {
        guard vm.success else {
            showMessage(vm.message ?? "Неизвестная ошибка", "Ошибка")
            return
        }
        
        registeredAlarms.removeAll { $0.id == vm.alarmId }
        collectionView.reloadData()
    }
    
    func alarmDelete(_ vm: Model.LoadDeleteAlarms.ViewModel) {
        guard vm.success else {
            showMessage(vm.message ?? "Неизвестная ошибка", "Ошибка")
            return
        }

        createdAlarms.removeAll { $0.id == vm.alarmId }
        collectionView.reloadData()
        showMessage(vm.message ?? "Будтльник удалён", "Успех")
    }
    
    //MARK: - Help func
    private func showMessage(_ message: String, _ title: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
            completion?()
        })
        
        present(alert, animated: true)
    }
    
}

extension MyAlarmsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        SectionAlarms.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = SectionAlarms(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .created:
            return createdAlarms.count
        case .registered:
            return registeredAlarms.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AlarmCollectionCardCell.reuseIdentifier,
                for: indexPath
            ) as? AlarmCollectionCardCell,
            let sectionType = SectionAlarms(rawValue: indexPath.section)
        else {
            return UICollectionViewCell()
        }
        
        let alarm: AlarmResponse
        switch sectionType {
        case .created:
            alarm = createdAlarms[indexPath.item]
            cell.configure(with: alarm, title: "Отменить")
            cell.onJoinTap = { [weak self] in
                self?.interactor.deleteAlarm(Model.LoadDeleteAlarms.Request(alarmId: alarm.id))
            }
            cell.cardView.isEditingMode = true
            cell.onEditTap = { [weak self] in
                let vc = CreateNewAlarmAssembly.build(mode: .edit(alarm))
                self?.navigationController?.pushViewController(vc, animated: true)
               
            }
            cell.onCardTap = { [weak self] in
                let vc = AlarmDetailsAssembly.build(alarm: alarm)
                vc.modalPresentationStyle = .overCurrentContext
                self?.present(vc, animated: true, completion: nil)
            }
        case .registered:
            alarm = registeredAlarms[indexPath.item]
            cell.configure(with: alarm, title: "Разбудить!")
            cell.cardView.isEditingMode = false
//            cell.onJoinTap = { [weak self] in
//                self?.interactor.leaveAlarm(Model.LoadLeaveAlarms(alarmId: alarm.id))
//            }
            cell.onCardTap = { [weak self] in
                let vc = AlarmDetailsAssembly.build(alarm: alarm)
                vc.modalPresentationStyle = .overCurrentContext
                self?.present(vc, animated: true, completion: nil)
            }
            cell.onSwipeLeft = { [weak self] in
                self?.interactor.leaveAlarm(
                    Model.LoadLeaveAlarms.Request(alarmId: alarm.id)
                )
            }
        }
        
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyEventsSectionHeaderView.reuseIdentifier,
                for: indexPath
              ) as? MyEventsSectionHeaderView,
              let sectionType = SectionAlarms(rawValue: indexPath.section)
        else {
            return UICollectionReusableView()
        }
        
        header.configure(title: sectionType.title)
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}
