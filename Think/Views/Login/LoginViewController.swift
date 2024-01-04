//
//  LoginViewController.swift
//  Think
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class LoginViewController: UIViewController {
    var loginViewModel = LoginViewModel()
    let userViewModel = UserViewModel.shared
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "계정 정보를 입력해주세요 "
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func makeTextField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing // 오른쪽에 X 버튼 표시

        // Customize clear button
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark"), for: .normal) // 이미지 설정
            clearButton.tintColor = .gray // 색상 설정
            clearButton.contentMode = .scaleAspectFit
            clearButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                clearButton.widthAnchor.constraint(equalToConstant: 10), // 너비 조절
                clearButton.heightAnchor.constraint(equalToConstant: 10) // 높이 조절
            ])
        }
        
        // Add bottom line
        let bottomLine = UIView()
        bottomLine.backgroundColor = .black
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(bottomLine)

        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])

        return textField
    }
    
    lazy var emailTextField: UITextField = {
        return makeTextField(withPlaceholder: "이메일을 입력해주세요")
    }()

    lazy var passwordTextField: UITextField = {
        let textField = makeTextField(withPlaceholder: "비밀번호를 입력해주세요")
        textField.isSecureTextEntry = true
        return textField
    }()
    
//    lazy var saveLoginCheckbox: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
//        button.setImage(UIImage(named: "checkbox_checked"), for: .selected)
//        button.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
//        button.layer.cornerRadius = 4
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor(red: 0x97 / 255.0, green: 0x97 / 255.0, blue: 0x97 / 255.0, alpha: 1).cgColor
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()

//    lazy var saveLoginLabel: UILabel = {
//        let label = UILabel()
//        label.text = "로그인 정보 저장하기"
//        label.textColor = UIColor(red: 0xAB / 255.0, green: 0xAB / 255.0, blue: 0xAB / 255.0, alpha: 1)
//        
//        if let pretendardFont = UIFont(name: "Pretendard", size: 14) {
//            label.font = pretendardFont
//        } else {
//            label.font = UIFont.systemFont(ofSize: 14)
//        }
//        
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()


    lazy var signUpButton: UIButton = {
        let signUp = UIButton(type: .system)
        signUp.setTitle("로그인", for: .normal)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUp.backgroundColor = UIColor(
            red: 208 / 255.0,
            green: 208 / 255.0,
            blue: 208 / 255.0,
            alpha: 1.0
        )
        signUp.setTitleColor(.white, for: .normal)
        signUp.layer.cornerRadius = 20.5
        signUp.layer.borderWidth = 2
        signUp.layer.borderColor = UIColor.clear.cgColor
        signUp.titleLabel?.font = UIFont(name: "Pretendard", size: 17)
        signUp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        return signUp
    }()
    
    lazy var findCredentialsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("아이디/비밀번호 찾기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(
            red: 151 / 255.0,
            green: 151 / 255.0,
            blue: 151 / 255.0,
            alpha: 1.0
        ), for: .normal)
        button.addTarget(self, action: #selector(findCredentialsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.tintColor = .black // 버튼 색상 변경 (옵셔널)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc func backButtonTapped() {
        let loginViewcController = WelcomeViewController()
        let navigationController = UINavigationController(rootViewController: loginViewcController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    lazy var passwordWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일/비밀번호를 확인해주세요"
        
        label.textColor = UIColor(red: 0xFF / 255.0, green: 0x7A / 255.0, blue: 0x2E / 255.0, alpha: 1.0)
        
        label.textAlignment = .left

        // Pretendard 폰트 설정. 시스템 폰트로 대체하거나 필요 시 다운로드/임베딩
        if let pretendardFont = UIFont(name: "Pretendard", size: 11) {
            label.font = pretendardFont
        } else {
            label.font = UIFont.systemFont(ofSize: 11)
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // 처음에는 숨김 상태로 시작
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()
        setupTextFields()
        setupWelcomeLabels()
        configureSignUpButtonColor()
        hideKeyboardWhenTappedAround()
        emailTextField.delegate = self
        passwordTextField.delegate = self
//        setupCheckboxAndLabel()
    }
    
    func configureSignUpButtonColor() {
        let isEmailValid = isEmailValid(emailTextField.text ?? "")
        let isPasswordNotEmpty = !(passwordTextField.text?.isEmpty ?? true)

        let shouldChangeButtonColor = isEmailValid && isPasswordNotEmpty

        signUpButton.isEnabled = shouldChangeButtonColor

        signUpButton.backgroundColor = shouldChangeButtonColor ? UIColor(
            red: 255 / 255.0,
            green: 214 / 255.0,
            blue: 0 / 255.0,
            alpha: 1.0
        ) : UIColor(
            red: 208 / 255.0,
            green: 208 / 255.0,
            blue: 208 / 255.0,
            alpha: 1.0
        )

        signUpButton.setTitleColor(shouldChangeButtonColor ? .black : .white, for: .normal)
    }

    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,20}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isValid = passwordTest.evaluate(with: password)
        passwordWarningLabel.isHidden = isValid
        return isValid
    }

    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func setupWelcomeLabels() {
        view.addSubview(welcomeLabel)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 163),
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 59),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 70),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 138)
        ])
        
        let lineView = UIView()
        lineView.backgroundColor = .gray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lineView)
                
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 12), // Adjust the spacing as needed
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
//    func setupCheckboxAndLabel() {
//        view.addSubview(saveLoginCheckbox)
//        view.addSubview(saveLoginLabel)
//        
//        NSLayoutConstraint.activate([
//            saveLoginCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
//            saveLoginCheckbox.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 42),
//            saveLoginCheckbox.widthAnchor.constraint(equalToConstant: 20),
//            saveLoginCheckbox.heightAnchor.constraint(equalToConstant: 20)
//        ])
//        
//        NSLayoutConstraint.activate([
//            saveLoginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 54),
//            saveLoginLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 45)
//        ])
//    }
    
    func setupTextFields() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(findCredentialsButton)

        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.addSubview(passwordWarningLabel)
            
        NSLayoutConstraint.activate([
            passwordWarningLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordWarningLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 3),
            passwordWarningLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 235),
            emailTextField.widthAnchor.constraint(equalToConstant: 343),
            emailTextField.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            passwordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 315),
            passwordTextField.widthAnchor.constraint(equalToConstant: 343),
            passwordTextField.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            signUpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 768),
            signUpButton.widthAnchor.constraint(equalToConstant: 343),
            signUpButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            findCredentialsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 142),
            findCredentialsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 728)
        ])
    }
    
    @objc func signUpButtonTapped() {
        guard let email = emailTextField.text, isEmailValid(email),
              let password = passwordTextField.text
                else {
            print("🚨 Invalid input")
            return
        }

        guard isPasswordValid(password) else {
            print("🚨 Invalid password")
            return
        }
        
        print("visit!!")
        
        LoginAPICaller.shared.makeLoginRequest(with: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    print("success!!")
                    self.loadUserData()
                } else {
                    print("error!!")
                }
            }
        }

        
        
//        let changeViewController = AddClassViewController()
//        let navigationController = UINavigationController(rootViewController: changeViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
    }
    
    func loadUserData() {
        //userViewModel
        let userId = userViewModel.user.id // 사용자 ID
        userViewModel.loadUserData(userId: userId!) { [weak self] success, user in
                    DispatchQueue.main.async {
                        if success, let user = user {
                            print("✅ user")
                            print(user)
                        } else {
                            print("error")
                        }
                    }
                }
    }
    
    
    @objc func findCredentialsButtonTapped() {
        print("아이디/비밀번호 찾기 Button Tapped")
    }

    @objc func textFieldDidChange() {
        guard let password = passwordTextField.text else { return }
        _ = isPasswordValid(password)
        configureSignUpButtonColor()
    }

    


    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    @objc func toggleCheckbox() {
//        saveLoginCheckbox.isSelected = !saveLoginCheckbox.isSelected
//    }
    

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
