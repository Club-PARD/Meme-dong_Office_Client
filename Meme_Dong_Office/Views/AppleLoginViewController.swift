import UIKit
import AuthenticationServices

class AppleLoginViewController: UIViewController {
    private var viewModel = AppleLoginViewModel()

    lazy var appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In with Apple", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()

    lazy var userInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupButtonActions()
        registerForNotifications()
    }

    private func setupUI() {
        // Adding buttons and label to the view
        [appleLoginButton, logoutButton, userInfoLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Auto Layout constraints
        NSLayoutConstraint.activate([
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 200),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),

            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 20),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),

            userInfoLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
            userInfoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            userInfoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }

    private func setupButtonActions() {
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }

    @objc private func appleLoginButtonTapped() {
        viewModel.performAppleSignIn()
    }

    @objc private func logoutButtonTapped() {
        // Logout logic
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        updateUIForLoggedOutState()
    }

    private func updateUIForLoggedOutState() {
        // Update UI to reflect that the user is logged out
        userInfoLabel.text = "Logged out"
    }

    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLogin), name: .userDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLoginFailure), name: .userLoginFailed, object: nil)
    }

    @objc private func handleUserLogin(notification: Notification) {
        DispatchQueue.main.async {
            // Update UI on successful login
            self.userInfoLabel.text = "Logged in successfully"
        }
    }

    @objc private func handleUserLoginFailure(notification: Notification) {
        DispatchQueue.main.async {
            // Update UI on login failure
            self.userInfoLabel.text = "Login failed"
        }
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

