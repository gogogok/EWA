import UIKit
import SwiftUI

struct CreateNewRoomPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            CreateNewRoomViewController(interactor: MockCreateNewRoomInteractor())
        }
    }
}

final class CreateNewRoomViewController: UIViewController, UITextViewDelegate {
    
    typealias Model = CreateNewRoomModel
    
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
        
        static let avatarIconSize: CGFloat = 140
        static let avatarTop: CGFloat = 210
        
        static let nameLabelFontSize: CGFloat = 20
        static let nameLabelTop: CGFloat = 20
        static let nameLabelHeight: CGFloat = 39
        static let nameLabelLeftRight: CGFloat = 30
        static let nameLabelCornerRadius: CGFloat = 8
        
        static let doneButtonText: String = "Создать!"
        static let doneButtonTop: CGFloat = 15
        static let doneButtonLeftRight: CGFloat = 115
        static let doneButtonCornerRadius: CGFloat = 10
        static let doneButtonFontSize: CGFloat = 19
        
        static let yanoneKaffeesatzBold: String = "YanoneKaffeesatz-ExtraLight_Bold"
        static let yanoneKaffeesatzRegular: String = "YanoneKaffeesatz-ExtraLight_Regular"
        
        static let topLabelFontSize: CGFloat = 20
        static let topLabelCornerRadius: CGFloat = 11
        static let topLabelLeftRight: CGFloat = 90
        static let topLabelTop: CGFloat = 60
        static let topLabelHeight: CGFloat = 50
        
        static let centralViewWidth: CGFloat = 20
        
        static let labelTop: CGFloat = 12
        
        static let errorLabelFontSize: CGFloat = 12
        
        static let purple: String = "#9F5FFC"
        static let topPurple : String = "#B895FF"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let pinkLightPurple: String = "#EDD1FF"
        static let lightGreen: String = "#9DE8CE"
        static let green: String = "#40A27B"
        
        static let greenForType: String = "#3AC300"
        static let redForType: String = "#C70000"
    }
    
    //MARK: - Fields
    
    var interactor : CreateNewRoomBusinessLogic
    
    private let roomTypePicker = UIPickerView()
    private let roomTypes = ["public", "private"]
    private var selectedRoomType: String?
    
    private var selectedVideoURL: String?
    
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
    
    var topLabel : PaddedLabel = {
        let label = PaddedLabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: Constants.yanoneKaffeesatzRegular, size: Constants.topLabelFontSize)
        label.numberOfLines = 1
        label.backgroundColor = UIColor(hex: Constants.topPurple)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.topLabelCornerRadius
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    var typeLabel : PaddedTextField = {
        let label = PaddedTextField()
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = UIColor(hex: Constants.lightGreen)
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.nameLabelCornerRadius
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    var centralView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var tagLabel : PaddedTextField = {
        let label = PaddedTextField()
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = UIColor(hex: Constants.lightGreen)
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.topLabelCornerRadius
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    var nameLabel : PaddedTextField = {
        let label = PaddedTextField()
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = UIColor(hex: Constants.lightGreen)
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.topLabelCornerRadius
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    var chooseBGButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выбрать видео", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(
            name: Constants.yanoneKaffeesatzRegular,
            size: Constants.topLabelFontSize
        )
        button.backgroundColor = UIColor(hex: Constants.lightGreen)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.topLabelCornerRadius
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()
    
    var descriptionLabel : PaddedTextField = {
        let label = PaddedTextField()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: Constants.yanoneKaffeesatzRegular, size: Constants.nameLabelFontSize)
        label.backgroundColor = UIColor(hex: Constants.lightGreen)
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.nameLabelCornerRadius
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    
    var errorLabel : UILabel = {
        let label = UILabel()
        label.text = "Заполните все обязательные поля!"
        label.textColor = .red
        label.textAlignment = .left
        label.font = .systemFont(ofSize: Constants.errorLabelFontSize)
        return label
    }()
    
    var doneButton: UIButton = UIButton(type: .system)
    
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureUI()
        
        roomTypePicker.delegate = self
        roomTypePicker.dataSource = self
        
        typeLabel.inputView = roomTypePicker
        typeLabel.inputAccessoryView = makeToolbar(doneAction: #selector(roomTypeDoneTapped))
        typeLabel.delegate = self
    }
    
    //MARK: - Lifecycle
    init(interactor: CreateNewRoomBusinessLogic) {
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
        configureTopButton()
        configureFields()
        configureDoneButtonAndError()
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
    
    private func configureTopButton() {
        view.addSubview(topLabel)
        
        topLabel.text = "Комната"
        topLabel.pinCenterY(to: customBackButton, Constants.topLabelTop)
        topLabel.pinHorizontal(to: view, Constants.topLabelLeftRight)
    }
    
    private func configureFields() {
        view.addSubview(typeLabel)
        view.addSubview(centralView)
        view.addSubview(tagLabel)
        
        typeLabel.attributedPlaceholder = makePlaceholder("Тип комнаты")
        typeLabel.pinTop(to: topLabel.bottomAnchor, Constants.labelTop)
        typeLabel.setHeight(Constants.nameLabelHeight)
        typeLabel.pinLeft(to: view.leadingAnchor, Constants.nameLabelLeftRight)
        
        tagLabel.attributedPlaceholder = makePlaceholder("Тег")
        tagLabel.pinRight(to: view.trailingAnchor, Constants.nameLabelLeftRight)
        tagLabel.pinTop(to: typeLabel.topAnchor)
        tagLabel.setHeight(Constants.nameLabelHeight)
        
        centralView.setWidth(Constants.centralViewWidth)
        centralView.pinVertical(to: typeLabel)
        centralView.pinCenterX(to: view)
        typeLabel.pinRight(to: centralView.leadingAnchor)
        tagLabel.pinLeft(to: centralView.trailingAnchor)
        
        view.addSubview(nameLabel)
        
        nameLabel.attributedPlaceholder = makePlaceholder("Название")
        nameLabel.pinTop(to: tagLabel.bottomAnchor, Constants.labelTop)
        nameLabel.setHeight(Constants.nameLabelHeight)
        nameLabel.pinLeft(to: typeLabel.leadingAnchor)
        nameLabel.pinRight(to: tagLabel.trailingAnchor)
        
        
        view.addSubview(chooseBGButton)
        view.addSubview(descriptionLabel)
        
        chooseBGButton.pinTop(to: nameLabel.bottomAnchor, Constants.labelTop)
        chooseBGButton.pinHorizontal(to: nameLabel)
        chooseBGButton.setHeight(Constants.nameLabelHeight)
        chooseBGButton.addTarget(self, action: #selector(chooseVideoTapped), for: .touchUpInside)
        
        descriptionLabel.attributedPlaceholder = makePlaceholder("Цель")
        descriptionLabel.pinTop(to: chooseBGButton.bottomAnchor, Constants.labelTop)
        descriptionLabel.pinHorizontal(to: chooseBGButton)
        descriptionLabel.setHeight(Constants.nameLabelHeight)
        
    }
    
    private func configureDoneButtonAndError() {
        view.addSubview(doneButton)
        view.addSubview(errorLabel)
        
        errorLabel.isHidden = true
        errorLabel.pinTop(to: descriptionLabel.bottomAnchor, Constants.doneButtonTop)
        errorLabel.pinCenterX(to: view)
        
        doneButton.setTitle(Constants.doneButtonText, for: .normal)
        doneButton.titleLabel?.textAlignment = .center
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: Constants.yanoneKaffeesatzRegular, size: Constants.doneButtonFontSize)
        doneButton.pinTop(to: errorLabel.bottomAnchor, Constants.doneButtonTop)
        doneButton.pinHorizontal(to: view, Constants.doneButtonLeftRight)
        
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = Constants.doneButtonCornerRadius
        doneButton.layer.masksToBounds = true
        doneButton.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightPurple)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Public func
    func roomSaved(_ vm: Model.LoadCreateNewStudeRoom.ViewModel) {
        if(vm.success) {
            showMessage(vm.errorMessage, "Успех") { [weak self] in
                self?.goBack()
            }
        } else {
            showMessage(vm.errorMessage, "Ошибка")
        }
    }
    
    
    //MARK: - Target func
    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func doneButtonTapped() {
        
        guard
            let id = UserDefaults.standard.string(forKey: UserDefaultsKeys.id),
            let name = UserDefaults.standard.string(forKey: UserDefaultsKeys.username),
            let email = UserDefaults.standard.string(forKey: UserDefaultsKeys.email),
            let iconName = UserDefaults.standard.string(forKey: UserDefaultsKeys.iconName)
        else {
            showMessage("Пользователь не зарегистрирован!", "Ошибка")
            return
        }
        
        guard
            
            let roomDescription = descriptionLabel.text,
            !roomDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            
                let roomCategory = tagLabel.text,
            !roomCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            
                
                let roomName = nameLabel.text,
            !roomName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            
                let type = typeLabel.text,
            !type.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                
                let mediaURL = selectedVideoURL,
                !mediaURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            errorLabel.isHidden = false
            return
        }
        
        let user = UserResponse(id: id, name: name, email: email, iconName: iconName)
        if type == "private" {
            askPassword { [weak self] password in
                guard let self = self else { return }

                let room = StudyResponse(
                    id: UUID().uuidString,
                    userId: id,
                    name: roomName,
                    description: roomDescription,
                    category: roomCategory,
                    type: type,
                    user: user,
                    mediaUrl: mediaURL,
                    password: password
                )

                self.interactor.saveRoom(
                    Model.LoadCreateNewStudeRoom.Request(roomRequest: room)
                )
            }
        } else {

            let room = StudyResponse(
                id: UUID().uuidString,
                userId: id,
                name: roomName,
                description: roomDescription,
                category: roomCategory,
                type: type,
                user: user,
                mediaUrl: mediaURL,
                password: nil
            )

            interactor.saveRoom(
                Model.LoadCreateNewStudeRoom.Request(roomRequest: room)
            )
        }
    }
    
    @objc
    private func roomTypeDoneTapped() {
        let selectedRow = roomTypePicker.selectedRow(inComponent: 0)
        selectedRoomType = roomTypes[selectedRow]
        if selectedRoomType == "public" {
            typeLabel.backgroundColor = UIColor(hex: Constants.greenForType)
        } else {
            typeLabel.backgroundColor = UIColor(hex: Constants.redForType)
        }
        typeLabel.text = selectedRoomType
        typeLabel.textColor = .black
        typeLabel.resignFirstResponder()
    }
    
    @objc
    private func chooseVideoTapped() {
        showVideoInputAlert()
    }
    
    //MARK: - Help func
    
    
    private func makeToolbar(doneAction: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: doneAction
        )
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        return toolbar
    }
    
    private func makePlaceholder(_ text: String) -> NSAttributedString {
        let font = UIFont(name: Constants.yanoneKaffeesatzRegular, size: Constants.nameLabelFontSize)!
        
        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.lightGray
            ]
        )
        
        let star = NSAttributedString(
            string: " *",
            attributes: [
                .font: font.withSize(font.pointSize * 0.5),
                .foregroundColor: UIColor.red,
                .baselineOffset: font.pointSize * 0.3
            ]
        )
        
        attributed.append(star)
        return attributed
    }
    
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
    
    private func askPassword(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(
            title: "Приватная комната",
            message: "Придумайте пароль для входа в комнату (4 цифры)",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Пароль"
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
        }

        let createAction = UIAlertAction(title: "Создать", style: .default) { _ in
            guard
                let text = alert.textFields?.first?.text,
                let password = Int(text),
                text.count == 4
            else {
                self.showMessage("Пароль должен состоять из 4 цифр", "Ошибка")
                return
            }

            completion(String(password))
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(cancelAction)
        alert.addAction(createAction)

        present(alert, animated: true)
    }
    
    private func showVideoInputAlert() {
        let alert = UIAlertController(
            title: "Выбрать видео",
            message: "Вставьте ссылку на YouTube",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "https://www.youtube.com/watch?v=..."
        }

        let cancel = UIAlertAction(title: "Отмена", style: .cancel)

        let choose = UIAlertAction(title: "Выбрать", style: .default) { [weak self] _ in
            guard let self else { return }

            let link = alert.textFields?.first?.text ?? ""

            guard self.extractYouTubeVideoId(from: link) != nil else {
                self.showMessage("Не удалось распознать ссылку YouTube", "Ошибка")
                return
            }

            self.selectedVideoURL = link
            self.chooseBGButton.setTitle("Видео выбрано", for: .normal)
            self.chooseBGButton.backgroundColor = UIColor(hex: Constants.lightPurple)
        }

        alert.addAction(cancel)
        alert.addAction(choose)

        present(alert, animated: true)
    }
    
    func extractYouTubeVideoId(from url: String) -> String? {
        if let components = URLComponents(string: url),
           let videoId = components.queryItems?.first(where: { $0.name == "v" })?.value {
            return videoId
        }

        if url.contains("youtu.be/") {
            return url
                .components(separatedBy: "youtu.be/")
                .last?
                .components(separatedBy: "?")
                .first
        }

        if url.contains("youtube.com/embed/") {
            return url
                .components(separatedBy: "youtube.com/embed/")
                .last?
                .components(separatedBy: "?")
                .first
        }

        return nil
    }
    
}

extension CreateNewRoomViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        roomTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        roomTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRoomType = roomTypes[row]
        if selectedRoomType == "public" {
            typeLabel.backgroundColor = UIColor(hex: Constants.greenForType)
        } else {
            typeLabel.backgroundColor = UIColor(hex: Constants.redForType)
        }
        typeLabel.text = selectedRoomType
        typeLabel.textColor = .black
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == typeLabel {
            return false
        }
        return true
    }
}
