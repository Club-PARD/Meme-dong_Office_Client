//
//  SetNameViewController.swift
//  Think
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class SetNameViewController: UIViewController {
    var loginViewModel = LoginViewModel()
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "선생님에 대해 소개해주세요"
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
    
    lazy var confirmPasswordTextField: UITextField = {
        return makeTextField(withPlaceholder: "이름을 입력해주세요")
    }()
    
    lazy var signUpButton: UIButton = {
        let signUp = UIButton(type: .system)
        signUp.setTitle("시작하기", for: .normal)
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
    
    func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.tintColor = .black // 버튼 색상 변경 (옵셔널)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc func backButtonTapped() {
        let loginViewcController = SignUpViewController()
        let navigationController = UINavigationController(rootViewController: loginViewcController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()
        setupTextFields()
        setupWelcomeLabels()
        configureSignUpButtonColor()
        hideKeyboardWhenTappedAround()
        confirmPasswordTextField.delegate = self
    }
    
    func setupWelcomeLabels() {
        view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 163),
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 59),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 70),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 24)
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
    func setupTextFields() {
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signUpButton)
        
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            confirmPasswordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 235),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 343),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            signUpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 768),
            signUpButton.widthAnchor.constraint(equalToConstant: 343),
            signUpButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            confirmPasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 138)
        ])
    }
    
    func configureSignUpButtonColor() {
        // TextField에 입력이 있는지 확인
        let isTextFieldEmpty = confirmPasswordTextField.text?.isEmpty ?? true
        
        // 색상 설정
        signUpButton.backgroundColor = isTextFieldEmpty ? UIColor(
            red: 208 / 255.0,
            green: 208 / 255.0,
            blue: 208 / 255.0,
            alpha: 1.0
        ) : UIColor(
            red: 255 / 255.0,
            green: 214 / 255.0,
            blue: 0 / 255.0,
            alpha: 1.0
        )
        
        signUpButton.setTitleColor(isTextFieldEmpty ? .white : .black, for: .normal)
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
    
    @objc func signUpButtonTapped() {
        print("Sign Up Button Tapped")
        
        name = confirmPasswordTextField.text!
        
        let isChecked = LoginAPICaller.shared.makeSignUpPostRequest(with: email, password: password, name: name)
        
        if isChecked {
            print("✅ success")
            
            // 실제 서버로부터 받은 액세스 토큰과 리프레시 토큰으로 교체
//            let accessToken = "yourAccessToken"
//            let refreshToken = "yourRefreshToken"
//            
//            // `TokenManager`를 사용하여 토큰 저장
//            TokenManager.shared.saveTokens(accessToken: accessToken)
            
            let changeViewController = AddClassViewController()
            let navigationController = UINavigationController(rootViewController: changeViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)

        } else {
            print("🚨 Invalid signUp")
        }
    }
}

//extension SetNameViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // TextField의 입력이 변경될 때마다 호출되는 델리게이트 메서드
//        // 여기에서는 textFieldDidChange 함수를 호출하여 SignUpButton의 색상을 업데이트합니다.
//        textFieldDidChange()
//        return true
//    }
//}

extension SetNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
