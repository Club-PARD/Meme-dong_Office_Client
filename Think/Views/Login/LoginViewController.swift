//
//  LoginViewController.swift
//  Think
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class LoginViewController: UIViewController {
    var loginViewModel = LoginViewModel()
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "띵에 오신 것을 환영합니다!"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "띵은 학기초에 학생들의 이름을 쉽고 빨리 기억하게 해주는 선생님들은 위한 서비스예요."
        label.textColor = UIColor(
            red: 151 / 255.0,
            green: 151 / 255.0,
            blue: 151 / 255.0,
            alpha: 1.0
        ) // RGB values for #979797
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
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
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(findCredentialsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextFields()
        setupWelcomeLabels()
        configureSignUpButtonColor()
    }
    
    func configureSignUpButtonColor() {
        let isEmailTextFieldEmpty = emailTextField.text?.isEmpty ?? true
        let isPasswordTextFieldEmpty = passwordTextField.text?.isEmpty ?? true
        let shouldChangeButtonColor = !isEmailTextFieldEmpty && !isPasswordTextFieldEmpty

        // 색상 설정
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
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 86),
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 234),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 39),
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 181),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 315),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupTextFields() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        
        view.addSubview(findCredentialsButton)

        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 342),
            emailTextField.widthAnchor.constraint(equalToConstant: 343),
            emailTextField.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            passwordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 417),
            passwordTextField.widthAnchor.constraint(equalToConstant: 343),
            passwordTextField.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            signUpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 572),
            signUpButton.widthAnchor.constraint(equalToConstant: 343),
            signUpButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            findCredentialsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findCredentialsButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16)
        ])
    }
    
    @objc func signUpButtonTapped() {
        email = emailTextField.text!
        password = passwordTextField.text!

        let isLoginchecked = LoginAPICaller.shared.makeLoginRequest(with: email, password: password)
        
        if isLoginchecked {
            print("✅ success")
            
            let changeViewController = SetNameViewController()
            let navigationController = UINavigationController(rootViewController: changeViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
        
        else {
            print("🚨 Invalid Login")
        }
        
        print("Sign Up Button Tapped")
        let changeViewController = SetNameViewController()
//        let navigationController = UINavigationController(rootViewController: changeViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(changeViewController, animated: true)
    }
    
    @objc func findCredentialsButtonTapped() {
        print("아이디/비밀번호 찾기 Button Tapped")
    }

    @objc func textFieldDidChange() {
        configureSignUpButtonColor()
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // TextField의 입력이 변경될 때마다 호출되는 델리게이트 메서드
        // 여기에서는 textFieldDidChange 함수를 호출하여 SignUpButton의 색상을 업데이트합니다.
        textFieldDidChange()
        return true
    }
}
