import UIKit
import AuthenticationServices

final class AppleLoginViewController: UIViewController {
    
    private var viewModel = AppleLoginViewModel()
    private var appleUser = AppleUser(userIdentifier: "", fullName: "", email: "")
        
    lazy var appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In with Apple", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.backgroundColor = .black
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
        label.sizeToFit()
        return label
    }()
    
    var navTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setupUI()
        setAttributes()
        setupButtonActions()
        setupNotifications()
    }
    
    func setNavigationBar() {
        self.navigationItem.title = navTitle ?? ""
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(appleLoginButton)
        self.view.addSubview(logoutButton)
        self.view.addSubview(userInfoLabel)
    }
    
    func setAttributes() {
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleLoginButton.widthAnchor.constraint(equalToConstant: 200),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 20),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        userInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userInfoLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 40),
            userInfoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupButtonActions() {
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc func appleLoginButtonTapped() {
        viewModel.performAppleSignIn()
    }
    
    @objc func logoutButtonTapped() {
        logout()
    }

    func logout() {
        // 사용자 정보 삭제 및 UI 업데이트
        UserDefaults.standard.removeObject(forKey: "UserIdentifier")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .userDidLogout, object: nil)
        updateUIForLoggedOutState()
    }
    
    func updateUIForLoggedOutState() {
        // 로그아웃 상태에 맞는 UI 업데이트
        userInfoLabel.text = ""
        // 추가적인 UI 업데이트 로직 (예: 로그아웃 상태 표시)
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignInCompleted(_:)), name: AppleLoginViewModel.signInCompletedNotification, object: nil)
    }
    
    @objc func handleSignInCompleted(_ notification: Notification) {
        if let user = notification.object as? AppleUser {
            DispatchQueue.main.async {
                self.appleUser = user
                self.userInfoLabel.text = """
                    userIdentifier: \(user.userIdentifier)
                    fullName: \(user.fullName)
                    email: \(user.email)
                """
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}

