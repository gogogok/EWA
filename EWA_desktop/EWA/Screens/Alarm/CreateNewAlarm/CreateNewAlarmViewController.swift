import UIKit
import Foundation
import SwiftUI


struct CreateNewAlarmPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            CreateNewAlarmViewController(interactor: MockCreateNewAlarmInteractor())
        }
    }
}


final class CreateNewAlarmViewController: UIViewController, UITextViewDelegate {
    
    enum ScreenMode {
            case create
            case edit(AlarmResponse)
        }
    
    typealias Model = CreateNewAlarmModel
    
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
        
        static let doneButtonText: String = "Подтвердить"
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
    }
    
    //MARK: - Fields
    
    var interactor : CreateNewAlarmBusinessLogic
    private let mode: ScreenMode
    
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
    
    var dateLabel : PaddedTextField = {
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
    
    var centralView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var timeLabel : PaddedTextField = {
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
    
    var tagLabel : PaddedTextField = {
        let label = PaddedTextField()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: Constants.yanoneKaffeesatzRegular, size: Constants.topLabelFontSize)
        label.backgroundColor = UIColor(hex: Constants.lightGreen)
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.topLabelCornerRadius
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    var centralViewSecond : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    var descriptionLabel : PaddedTextField = {
        let label = PaddedTextField()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: Constants.yanoneKaffeesatzRegular, size: Constants.topLabelFontSize)
        label.backgroundColor = UIColor(hex: Constants.lightGreen)
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.topLabelCornerRadius
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    var commentLabel : UITextView = {
        let label = UITextView()
        label.text = "  Комментарий"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont(name: Constants.yanoneKaffeesatzRegular, size: Constants.topLabelFontSize)
        label.backgroundColor = UIColor(hex: Constants.lightGreen)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.topLabelCornerRadius
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()
    
    var colorPicker = ColorPickerStackView()
    
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
        configureDateAndTimePickers()
        applyMode()
    }
    
    //MARK: - Lifecycle
    init(interactor: CreateNewAlarmBusinessLogic, mode: ScreenMode = .create) {
        self.interactor = interactor
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "  Комментарий"
            textView.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
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
        
        topLabel.text = "Будильник"
        topLabel.pinCenterY(to: customBackButton, Constants.topLabelTop)
        topLabel.pinHorizontal(to: view, Constants.topLabelLeftRight)
    }
    
    private func configureFields() {
        view.addSubview(dateLabel)
        view.addSubview(centralView)
        view.addSubview(timeLabel)
        
        
        dateLabel.pinTop(to: topLabel.bottomAnchor, Constants.labelTop)
        dateLabel.attributedPlaceholder = makePlaceholder("Дата")
        dateLabel.setHeight(Constants.nameLabelHeight)
        dateLabel.pinLeft(to: view.leadingAnchor, Constants.nameLabelLeftRight)
        
        timeLabel.pinRight(to: view.trailingAnchor, Constants.nameLabelLeftRight)
        timeLabel.pinTop(to: dateLabel.topAnchor)
        timeLabel.setHeight(Constants.nameLabelHeight)
        timeLabel.attributedPlaceholder = makePlaceholder("Время")
        
        centralView.setWidth(Constants.centralViewWidth)
        centralView.pinVertical(to: dateLabel)
        centralView.pinCenterX(to: view)
        dateLabel.pinRight(to: centralView.leadingAnchor)
        timeLabel.pinLeft(to: centralView.trailingAnchor)
        
        view.addSubview(tagLabel)
        view.addSubview(centralViewSecond)
        view.addSubview(colorPicker)
        
        tagLabel.pinTop(to: timeLabel.bottomAnchor, Constants.labelTop)
        tagLabel.setHeight(Constants.nameLabelHeight)
        tagLabel.attributedPlaceholder = makePlaceholder("Тег")
        tagLabel.pinLeft(to: dateLabel.leadingAnchor)
        
        colorPicker.pinRight(to: timeLabel.trailingAnchor, 20)
        colorPicker.pinVertical(to: tagLabel, 5)
        
        centralViewSecond.setWidth(Constants.centralViewWidth)
        centralViewSecond.pinVertical(to: tagLabel)
        centralViewSecond.pinCenterX(to: view)
        tagLabel.pinRight(to: centralView.leadingAnchor)
        colorPicker.pinLeft(to: centralView.trailingAnchor, 20)
        
        view.addSubview(descriptionLabel)
        view.addSubview(commentLabel)
        
        descriptionLabel.pinTop(to: tagLabel.bottomAnchor, Constants.labelTop)
        descriptionLabel.pinLeft(to: dateLabel.leadingAnchor)
        descriptionLabel.pinRight(to: timeLabel.trailingAnchor)
        descriptionLabel.setHeight(Constants.nameLabelHeight)
        descriptionLabel.attributedPlaceholder = makePlaceholder("Описание")
        
        commentLabel.delegate = self
        commentLabel.pinTop(to: descriptionLabel.bottomAnchor, Constants.labelTop)
        commentLabel.pinHorizontal(to: descriptionLabel)
        commentLabel.setHeight(Constants.nameLabelHeight * 2)
        
    }
    
    private func configureDateAndTimePickers() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
        
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "ru_RU")
        
        dateLabel.inputView = datePicker
        timeLabel.inputView = timePicker
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        
        let dateToolbar = makeToolbar(doneAction: #selector(doneDatePicker))
        let timeToolbar = makeToolbar(doneAction: #selector(doneTimePicker))
        
        dateLabel.inputAccessoryView = dateToolbar
        timeLabel.inputAccessoryView = timeToolbar
    }
    
    private func configureDoneButtonAndError() {
        view.addSubview(doneButton)
        view.addSubview(errorLabel)
        
        errorLabel.isHidden = true
        errorLabel.pinTop(to: commentLabel.bottomAnchor, Constants.doneButtonTop)
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
    func alarmSaved(_ vm: Model.LoadCreateNewAlarm.ViewModel) {
        if(vm.success) {
            showMessage(vm.errorMessage, "Успех") { [weak self] in
                self?.goBack()
            }
        } else {
            showMessage(vm.errorMessage, "Ошибка")
        }
    }
    
    func alarmUpdated(_ vm: Model.LoadUpdateAlarm.ViewModel) {
        if vm.success {
            showMessage(vm.message, "Успех") { [weak self] in
                self?.goBack()
            }
        } else {
            showMessage(vm.message, "Ошибка")
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
            
            let alarmDescription = descriptionLabel.text,
            !alarmDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            
            let alarmCategory = tagLabel.text,
            !alarmCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            
            
            let alarmDate = dateLabel.text,
            !alarmDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                
            let timeText = timeLabel.text,
            !timeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            errorLabel.isHidden = false
            return
        }
        
        if !isValidDate(alarmDate) {
            showMessage("Введите дату в формате ДД.ММ.ГГГГ", "Ошибка")
            return
        }
        
        if !isValidTime(timeText) {
            showMessage("Введите время в формате ЧЧ:ММ", "Ошибка")
            return
        }
        
        if !isAlarmDateTimeInFuture(dateText: alarmDate, timeText: timeText) {
            showMessage("Дата и время будильника должны быть позже текущего момента", "Ошибка")
            return
        }
        
        var commentText = commentLabel.text ?? ""
        if commentText.trimmingCharacters(in: .whitespacesAndNewlines) == "Комментарий"
            || commentLabel.textColor == .placeholderText {
            commentText = ""
        }
        
        let user = UserResponse(id: id, name: name, email: email, iconName: iconName)
        
        switch mode {
        case .create:
            let alarm = AlarmResponse(id: UUID().uuidString, userId: id, description: alarmDescription, category: alarmCategory, comment: commentText, categoryHexColor: colorPicker.selectedColorHex ?? "#00D78C", date: alarmDate, time: timeText, user: user, countPart: 0)
            
            Task {
                let allowed = await AlarmPermissionManager.shared.requestPermission()

                guard allowed else {
                    await AlarmPermissionManager.shared.showDeniedAlert(from: self)
                    return
                }
            }
            
            interactor.saveAlarm(Model.LoadCreateNewAlarm.Request(alarmRequest: alarm))
            
        case .edit(let oldAlarm):
            let updateAlarm = AlarmResponse(id: oldAlarm.id, userId: oldAlarm.userId, description: alarmDescription, category: alarmCategory, comment: commentText, categoryHexColor: colorPicker.selectedColorHex ?? "#00D78C", date: alarmDate, time: timeText, user: user, countPart: 0)
          interactor.updateAlarm(Model.LoadUpdateAlarm.Request(alarmRequest: updateAlarm))
        }
    }
    
    @objc
    private func dateChanged() {
        dateLabel.text = dateFormatter.string(from: datePicker.date)
        dateLabel.textColor = .black
    }
    
    @objc
    private func timeChanged() {
        timeLabel.text = timeFormatter.string(from: timePicker.date)
        timeLabel.textColor = .black
    }
    
    @objc
    private func doneDatePicker() {
        dateLabel.text = dateFormatter.string(from: datePicker.date)
        dateLabel.textColor = .black
        dateLabel.resignFirstResponder()
    }
    
    @objc
    private func doneTimePicker() {
        timeLabel.text = timeFormatter.string(from: timePicker.date)
        timeLabel.textColor = .black
        timeLabel.resignFirstResponder()
    }
    
    //MARK: - Help func
    
    private func applyMode() {
        switch mode {
        case .create:
            topLabel.text = "Будильник"
            doneButton.setTitle("Подтвердить", for: .normal)
            
        case .edit(let alarm):
            topLabel.text = "Редактировать"
            doneButton.setTitle("Сохранить", for: .normal)
            
            dateLabel.text = formatDate(alarm.date)
            dateLabel.textColor = .black
            
            timeLabel.text = alarm.time
            timeLabel.textColor = .black
            
            tagLabel.text = alarm.category
            tagLabel.textColor = .black
            
            colorPicker.selectColor(name: alarm.categoryHexColor)
            
            descriptionLabel.text = alarm.description
            descriptionLabel.textColor = .black
            
            if alarm.comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                commentLabel.text = "  Комментарий"
                commentLabel.textColor = .lightGray
            } else {
                commentLabel.text = alarm.comment
                commentLabel.textColor = .black
            }
        }
    }
    
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
    
    private func isAlarmDateTimeInFuture(dateText: String, timeText: String) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        formatter.isLenient = false
        
        guard let alarmDate = formatter.date(from: "\(dateText) \(timeText)") else {
            return false
        }
        
        return alarmDate > Date()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private func formatDate(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"
        
        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        } else {
            return input
        }
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private func isValidDate(_ text: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.date(from: text) != nil
    }
    
    private func isValidTime(_ text: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: text) != nil
    }
    
    func makePlaceholder(_ text: String) -> NSAttributedString {
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
    
}

