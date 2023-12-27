//
//  OriginViewController.swift
//  Meme_Dong_Office
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class OriginViewController: UIViewController {

    lazy var loginButton: UIButton = {
        let login = UIButton(type: .system)
        login.setTitle("로그인", for: .normal)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        login.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        login.setTitleColor(.black, for: .normal)
        login.layer.cornerRadius = 8 // Adjust the corner radius for a rounded appearance

        return login
    }()

    lazy var signUpButton: UIButton = {
        let signUp = UIButton(type: .system)
        signUp.setTitle("회원가입", for: .normal)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUp.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        signUp.setTitleColor(.black, for: .normal)
        signUp.layer.cornerRadius = 8 // Adjust the corner radius for a rounded appearance

        return signUp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
    }

    func setupButtons() {
        view.addSubview(loginButton)
        view.addSubview(signUpButton)

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50), // Move up by 50 points
            loginButton.widthAnchor.constraint(equalToConstant: 300), // Adjust the width
            loginButton.heightAnchor.constraint(equalToConstant: 40) // Adjust the height
        ])

        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50), // Move down by 50 points
            signUpButton.widthAnchor.constraint(equalToConstant: 300), // Adjust the width
            signUpButton.heightAnchor.constraint(equalToConstant: 40) // Adjust the height
        ])
    }

    @objc func loginButtonTapped() {
        print("Login Button Tapped")
        let changeViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: changeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    @objc func signUpButtonTapped() {
        print("Sign Up Button Tapped")
        let changeViewController = SignUpViewController()
        let navigationController = UINavigationController(rootViewController: changeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

