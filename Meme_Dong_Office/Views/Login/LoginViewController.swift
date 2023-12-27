//
//  LoginViewController.swift
//  Meme_Dong_Office
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class LoginViewController: UIViewController {

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "띵"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일 입력"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 입력 (영문/숫자/특수문자 조합 8-20자리)"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var signUpButton: UIButton = {
        let signUp = UIButton(type: .system)
        signUp.setTitle("로그인", for: .normal)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUp.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        signUp.setTitleColor(.black, for: .normal)
        signUp.layer.cornerRadius = 8

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

    }
    func setupWelcomeLabels() {
        view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupTextFields() {
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        view.addSubview(signUpButton)
        view.addSubview(findCredentialsButton)

        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            signUpButton.widthAnchor.constraint(equalToConstant: 300),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            findCredentialsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findCredentialsButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -8),
            emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8),
            passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])

    }
    
    @objc func signUpButtonTapped() {
        print("Sign Up Button Tapped")
        let changeViewController = SetNameViewController()
        let navigationController = UINavigationController(rootViewController: changeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func findCredentialsButtonTapped() {
        print("아이디/비밀번호 찾기 Button Tapped")
    }

}
