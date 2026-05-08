import UIKit

final class EnterPasswordScreenViewController: UIViewController {
    
    typealias Model = EnterPasswordScreenModel
    
    //MARK: - Constants
    private enum Constants {
        static let fatalError: String = "Ошибка создания"
        
        static let viewTopInset: CGFloat = 60
        static let viewBottomInset: CGFloat = 190
        static let viewLeftRightInset: CGFloat = 30
        static let viewCornerRadius: CGFloat = 20
        
        static let backButtonWidthConstant: CGFloat = 2.1
        static let backButtonTop: CGFloat = -60
        
        static let topLabelText: String = "Введите пароль от приватной комнаты"
        static let topLabelTop : CGFloat = 90
        static let topLabelLeft: CGFloat = 20
        static let topLabelWidth: CGFloat = 180
        static let topLabelHeight: CGFloat = 58
        static let topLabelFontSize: CGFloat = 16
        static let topLabelCornerRadius: CGFloat = 10
        
        static let textFieldHeight: CGFloat = 70
        
        static let doneButtonText: String = "Подтвердить"
        static let doneButtonTop : CGFloat = 20
        static let doneButtonLeftRight: CGFloat = 110
        
        static let purple: String = "#9F5FFC"
        static let lightPurple: String = "#D0B9FF"
        static let lightLightPurple: String = "#E8D8FF"
        static let pinkLightPurple: String = "#EDD1FF"
        static let green: String = "#40A27B"
        
        static let tinosBold : String = "Tinos-Bold"
        static let yanoneKaffeesatzBold: String = "YanoneKaffeesatz-ExtraLight_Bold"
        static let pressRegular: String = "PressStart2P-Regular"
    }
    
    //MARK: - Fields
    
    var interactor : EnterPasswordScreenBusinessLogic
    
    var password: String
    var room: StudyResponse
    
    var backView: UIView = UIView()
    let customBackButton = UIButton(type: .system)
    
    private var topLabel : UILabel = {
        var label = UILabel()
        label.text = Constants.topLabelText
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: Constants.tinosBold, size: Constants.topLabelFontSize)
        label.setHeight(Constants.topLabelHeight)
        
        label.layer.borderWidth = 1
        label.layer.cornerRadius = Constants.topLabelCornerRadius
        label.layer.masksToBounds = true
        label.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.purple)
        return label
    }()
    
    var errorLabel : UILabel = {
        let label = UILabel()
        label.text = "Неверный пароль!"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont(name: Constants.yanoneKaffeesatzBold, size: 18)
        return label
    }()
    
    private var stackNumbers: UIStackView = UIStackView()
    
    private var firstNumberView : UITextField = {
        var field = UITextField()
        field.setHeight(Constants.textFieldHeight)
        field.setWidth(Constants.textFieldHeight)
        field.font = UIFont(name: Constants.pressRegular, size: 50)
        field.textAlignment = .center
        field.backgroundColor = .white
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.black.cgColor
        
        return field
    }()
    
    private var secondNumberView : UITextField = {
        var field = UITextField()
        field.setHeight(Constants.textFieldHeight)
        field.setWidth(Constants.textFieldHeight)
        field.font = UIFont(name: Constants.pressRegular, size: 50)
        field.textAlignment = .center
        field.backgroundColor = .white
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.black.cgColor
        
        return field
    }()
    
    private var thirdNumberView : UITextField = {
        var field = UITextField()
        field.setHeight(Constants.textFieldHeight)
        field.setWidth(Constants.textFieldHeight)
        field.font = UIFont(name: Constants.pressRegular, size: 50)
        field.textAlignment = .center
        field.backgroundColor = .white
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.black.cgColor
        
        return field
    }()
    
    private var fourthNumberView : UITextField = {
        var field = UITextField()
        field.setHeight(Constants.textFieldHeight)
        field.setWidth(Constants.textFieldHeight)
        field.font = UIFont(name: Constants.pressRegular, size: 50)
        field.textAlignment = .center
        field.backgroundColor = .white
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.black.cgColor
        
        return field
    }()
    
    var doneButton: UIButton = UIButton(type: .system)
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        for family in UIFont.familyNames {
            print("Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("  - \(name)")
            }
        }
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Lyfecycle
    init(interactor: EnterPasswordScreenBusinessLogic, password: String, room: StudyResponse) {
        self.interactor = interactor
        self.password = password
        self.room = room
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        configureView()
        configurebackButton()
        configureTopLabel()
        configureErrorLabel()
        configureStack()
        configureDoneButton()
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
    
    private func configureTopLabel() {
        view.addSubview(topLabel)
        topLabel.pinTop(to: backView.topAnchor, 60)
        topLabel.pinHorizontal(to: backView, 40)
    }
    
    private func configureErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.isHidden = true
        errorLabel.pinTop(to: topLabel.bottomAnchor, 20)
        errorLabel.pinCenterX(to: backView)
    }
    
    private func configureStack() {
        view.addSubview(stackNumbers)
        
        stackNumbers.addArrangedSubview(firstNumberView)
        stackNumbers.addArrangedSubview(secondNumberView)
        stackNumbers.addArrangedSubview(thirdNumberView)
        stackNumbers.addArrangedSubview(fourthNumberView)
        
        [firstNumberView, secondNumberView, thirdNumberView, fourthNumberView].forEach {
            $0.delegate = self
            $0.keyboardType = .numberPad
            addBottomLine(to: $0)
        }
        
        stackNumbers.pinTop(to: errorLabel.bottomAnchor, 10)
        stackNumbers.pinHorizontal(to: backView, 10)
        stackNumbers.axis = .horizontal
        stackNumbers.spacing = 6
        stackNumbers.distribution = .fillEqually
    }
    
    private func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.setTitle(Constants.doneButtonText, for: .normal)
        doneButton.titleLabel?.textAlignment = .center
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: Constants.yanoneKaffeesatzBold, size: 16)
        doneButton.pinTop(to: stackNumbers.bottomAnchor, Constants.doneButtonTop)
        doneButton.pinHorizontal(to: backView, Constants.doneButtonLeftRight)
        
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = 10
        doneButton.layer.masksToBounds = true
        doneButton.backgroundColor = ColorChangindMethods.getHEXColor(hex: Constants.lightLightPurple)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Target func
    @objc
    func goBack() {
        dismiss(animated: true)
    }
    
    @objc
    private func doneButtonTapped() {
        guard
            let first = firstNumberView.text,
            let second = secondNumberView.text,
            let third = thirdNumberView.text,
            let fourth = fourthNumberView.text
        else {
            errorLabel.isHidden = false
            return
        }
        let pass = first + second + third + fourth
        if pass != password {
            errorLabel.isHidden = true
            showMessage("Неверный пароль", "Ошибка")
            return
        } else {
            let vc = StudyRoomAssembly.build(room: room)
            vc.modalPresentationStyle = .fullScreen

            let parentVC = presentingViewController

            dismiss(animated: true) {
                parentVC?.present(vc, animated: true)
            }
        }
        
    }
    
    //MARK: - Help func
    private func addBottomLine(to field: UITextField) {
        let lineTag = 999
        
        if field.viewWithTag(lineTag) != nil { return }
        
        let line = UIView()
        line.tag = lineTag
        line.backgroundColor = .black
        
        field.addSubview(line)
        line.setHeight(1)
        line.pinBottom(to: field, 10)
        line.pinHorizontal(to: field, 10)
    }
    
    private func setBottomLineHidden(_ isHidden: Bool, for field: UITextField) {
        field.viewWithTag(999)?.isHidden = isHidden
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

extension EnterPasswordScreenViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        
        guard let textRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        if !string.isEmpty {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            guard allowedCharacters.isSuperset(of: characterSet) else {
                return false
            }
        }
        
        guard updatedText.count <= 1 else {
            return false
        }
        
        DispatchQueue.main.async {
            self.setBottomLineHidden(!updatedText.isEmpty, for: textField)
            
            if updatedText.count == 1 {
                switch textField {
                case self.firstNumberView:
                    self.secondNumberView.becomeFirstResponder()
                case self.secondNumberView:
                    self.thirdNumberView.becomeFirstResponder()
                case self.thirdNumberView:
                    self.fourthNumberView.becomeFirstResponder()
                case self.fourthNumberView:
                    textField.resignFirstResponder()
                default:
                    break
                }
            }
        }
        
        return true
    }
}
