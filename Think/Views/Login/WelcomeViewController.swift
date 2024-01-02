
<<<<<<< HEAD:Think/Views/Login/OriginViewController.swift
=======
import UIKit

class WelcomeViewController: UIViewController {

    let thinkImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "think")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo")
        image.contentMode = .scaleAspectFit
        return image
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "새학기를 준비하는 선생님들을 위한 서비스"
        label.textColor = .black
        label.textAlignment = .left
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
    }

    func setupWelcomeLabels() {
        view.addSubview(thinkImage)
        view.addSubview(descriptionLabel)
        view.addSubview(logoImage)
        
        
        thinkImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 89),
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 290),
            logoImage.widthAnchor.constraint(equalToConstant: 172),
            logoImage.heightAnchor.constraint(equalToConstant: 168)
        ])

        
        NSLayoutConstraint.activate([
            thinkImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            thinkImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 123),
            thinkImage.widthAnchor.constraint(equalToConstant: 183),
            thinkImage.heightAnchor.constraint(equalToConstant: 44)
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 198),
//            descriptionLabel.widthAnchor.constraint(equalToConstant: 315),
//            descriptionLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupButtons() {
        view.addSubview(loginButton)
        view.addSubview(signUpButton)

        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 521),
            loginButton.widthAnchor.constraint(equalToConstant: 343),
            loginButton.heightAnchor.constraint(equalToConstant: 43)
        ])

        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            signUpButton.widthAnchor.constraint(equalToConstant: 343),
            signUpButton.heightAnchor.constraint(equalToConstant: 43)
        ])
    }

    @objc func loginButtonTapped() {
        print("Login Button Tapped")
        let changeViewController = LoginViewController()
//        let navigationController = UINavigationController(rootViewController: changeViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(changeViewController, animated: true)
    }

    @objc func signUpButtonTapped() {
        print("Sign Up Button Tapped")
        let changeViewController = SignUpViewController()
//        let navigationController = UINavigationController(rootViewController: changeViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(changeViewController, animated: true)
    }
}
>>>>>>> a3398da1c14697a1147ad4444a8d78fecd810bb8:Think/Views/Login/WelcomeViewController.swift
