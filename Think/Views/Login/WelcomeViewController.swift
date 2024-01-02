//
//  WelcomeViewController.swift
//  Think
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    func addLogoImage() {
        let logoImageView = UIImageView(image: UIImage(named: "think"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 105),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 119),
            logoImageView.widthAnchor.constraint(equalToConstant: 183),
            logoImageView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "새학기를 준비하는 선생님들을 위한 서비스"
        label.textColor = .black
        label.textAlignment = .center
        label.textColor = UIColor(
            red: 151 / 255.0,
            green: 151 / 255.0,
            blue: 151 / 255.0,
            alpha: 1.0
        )
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "계속함으로써 이용약관 및 개인정보처리방침에 동의합니다."
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loginButton: UIButton = {
        let login = UIButton(type: .system)
        login.setTitle("로그인", for: .normal)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        login.backgroundColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        login.setTitleColor(.black, for: .normal)
        login.layer.cornerRadius = 20.5
        login.titleLabel?.font = UIFont(name: "Pretendard", size: 17)
        login.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        return login
    }()

    lazy var signUpButton: UIButton = {
        let signUp = UIButton(type: .system)
        signUp.setTitle("회원가입", for: .normal)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUp.backgroundColor = .white
        signUp.setTitleColor(.black, for: .normal)
        signUp.layer.cornerRadius = 20.5
        signUp.layer.borderWidth = 2
        signUp.layer.borderColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0).cgColor
        signUp.titleLabel?.font = UIFont(name: "Pretendard", size: 17)
        signUp.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        return signUp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        setupWelcomeLabels()
        addLogoImage()
    }

    func setupWelcomeLabels() {
        view.addSubview(welcomeLabel)
        view.addSubview(descriptionLabel)
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 263),
            imageView.widthAnchor.constraint(equalToConstant: 173),
            imageView.heightAnchor.constraint(equalToConstant: 209)
        ])

        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70), // 좌측을 기준으로 70
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 790), // 상단을 기준으로 790
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 79),
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 187)
        ])
    }
    
    func setupButtons() {
        view.addSubview(loginButton)
        view.addSubview(signUpButton)

        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 534),
            loginButton.widthAnchor.constraint(equalToConstant: 343),
            loginButton.heightAnchor.constraint(equalToConstant: 43)
        ])

        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.widthAnchor.constraint(equalToConstant: 343),
            signUpButton.heightAnchor.constraint(equalToConstant: 43)
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
