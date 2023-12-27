//
//  SetNameViewController.swift
//  Meme_Dong_Office
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class SetNameViewController: UIViewController {

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요 선생님에 대해 소개해주세요!"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름 입력"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var signUpButton: UIButton = {
        let signUp = UIButton(type: .system)
        signUp.setTitle("시작하기", for: .normal)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUp.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        signUp.setTitleColor(.black, for: .normal)
        signUp.layer.cornerRadius = 8

        return signUp
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
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signUpButton)

        NSLayoutConstraint.activate([
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 300),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            signUpButton.widthAnchor.constraint(equalToConstant: 300),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            confirmPasswordLabel.bottomAnchor.constraint(equalTo: confirmPasswordTextField.topAnchor, constant: -8),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor),
            confirmPasswordLabel.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor)
        ])
    }
    
    @objc func signUpButtonTapped() {
        print("Sign Up Button Tapped")
        let changeViewController = SetNameViewController()
        let navigationController = UINavigationController(rootViewController: changeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
