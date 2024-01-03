//
//  SignUpViewController.swift
//  Think
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class SignUpViewController: UIViewController {
    var loginViewModel = LoginViewModel()

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
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
        textField.clearButtonMode = .whileEditing

        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            clearButton.tintColor = .gray
            clearButton.contentMode = .scaleAspectFit
            clearButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                clearButton.widthAnchor.constraint(equalToConstant: 10),
                clearButton.heightAnchor.constraint(equalToConstant: 10)
            ])
        }
            
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

    lazy var confirmPasswordTextField: UITextField = {
        let textField = makeTextField(withPlaceholder: "비밀번호를 확인해주세요")
        textField.isSecureTextEntry = true
        return textField
    }()


    lazy var confirmPasswordCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "영문/숫자 조합 8-20자리"
        label.textColor = UIColor(red: 0x97 / 255.0, green: 0x97 / 255.0, blue: 0x97 / 255.0, alpha: 1.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()


    lazy var signUpButton: UIButton = {
        let signUp = UIButton(type: .system)
        signUp.setTitle("회원가입", for: .normal)
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextFields()
        setupWelcomeLabels()
        configureSignUpButtonColor()
        hideKeyboardWhenTappedAround()
    }
    
    func configureSignUpButtonColor() {
        let isEmailTextFieldEmpty = emailTextField.text?.isEmpty ?? true
        let isPasswordTextFieldEmpty = passwordTextField.text?.isEmpty ?? true
        let isConfirmPasswordTextFieldEmpty = confirmPasswordTextField.text?.isEmpty ?? true

        let shouldChangeButtonColor = !isEmailTextFieldEmpty && !isPasswordTextFieldEmpty && !isConfirmPasswordTextFieldEmpty

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

    func setupWelcomeLabels() {
        view.addSubview(welcomeLabel)
        view.addSubview(descriptionLabel)
//        view.addSubview(backButton)
//
//        NSLayoutConstraint.activate([
//            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
//            backButton.widthAnchor.constraint(equalToConstant: 30),
//            backButton.heightAnchor.constraint(equalToConstant: 30)
//        ])
        
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
            lineView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8), // Adjust the spacing as needed
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,20}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    
    func setupTextFields() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(confirmPasswordCheckLabel)
        view.addSubview(signUpButton)

        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
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
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            confirmPasswordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 395),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 343),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            signUpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 768),
            signUpButton.widthAnchor.constraint(equalToConstant: 343),
            signUpButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            confirmPasswordCheckLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            confirmPasswordCheckLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            confirmPasswordCheckLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
    }
    
//    lazy var backButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
//        button.tintColor = .black
//        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    @objc func backButtonTapped() {
//        let changeViewController = SetNameViewController()
//        let navigationController = UINavigationController(rootViewController: changeViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
//    }
    
    @objc func signUpButtonTapped() {
        print("Sign Up Button Tapped")

        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            return
        }

        guard isPasswordValid(password) else {
            // 비밀번호가 조건에 맞지 않으면 경고 메시지를 표시하거나 처리할 로직을 추가할 수 있습니다.
            print("🚨 Invalid password")
            return
        }

        let changeViewController = SetNameViewController()
        changeViewController.email = email
        changeViewController.password = password
        let navigationController = UINavigationController(rootViewController: changeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    
    @objc func textFieldDidChange() {
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

        // 화면 터치 시 키보드를 숨기는 기능을 추가합니다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
}

// UITextFieldDelegate 프로토콜을 준수하는 부분을 확장하여 구현합니다.
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldDidChange()
        return true
    }
}
