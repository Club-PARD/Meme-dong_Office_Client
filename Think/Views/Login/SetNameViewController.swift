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
        label.text = "선생님에 대해 소개해주세요!"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "~~~ 실명을 입력해주세요."
        label.textColor = .black
        label.textColor = UIColor(
            red: 151 / 255.0,
            green: 151 / 255.0,
            blue: 151 / 255.0,
            alpha: 1.0
        ) // RGB values for #979797
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    lazy var confirmPasswordTextField: UITextField = {
    //        let textField = UITextField()
    //        textField.placeholder = "이름 입력"
    //        textField.isSecureTextEntry = true
    //        textField.borderStyle = .roundedRect
    //        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    //        textField.translatesAutoresizingMaskIntoConstraints = false
    //        return textField
    //    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextFields()
        setupWelcomeLabels()
        configureSignUpButtonColor() // 초기 색상 설정
    }
    
    func setupWelcomeLabels() {
        view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 86),
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 234), // Set width to 234
            welcomeLabel.heightAnchor.constraint(equalToConstant: 25), // Set height to 25
        ])
        
        
    }
    func setupTextFields() {
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signUpButton)
        
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            confirmPasswordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 439),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 343),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            signUpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 572),
            signUpButton.widthAnchor.constraint(equalToConstant: 343),
            signUpButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 94),
            confirmPasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 181),
            confirmPasswordLabel.widthAnchor.constraint(equalToConstant: 205), // Set width to 234
            confirmPasswordLabel.heightAnchor.constraint(equalToConstant: 20), // Set height to 25
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
    
    @objc func signUpButtonTapped() {
        print("Sign Up Button Tapped")
        
        name = confirmPasswordTextField.text!
        
        let isChecked = LoginAPICaller.shared.makeSignUpPostRequest(with: email, password: password, name: name)
        
        if isChecked {
            print("✅ success")

//            let isLoginchecked = LoginAPICaller.shared.makeLoginRequest(with: email, password: password)
//            
//            if isLoginchecked {
//                print("✅ success")
//                
            let changeViewController = SetNameViewController()
            let navigationController = UINavigationController(rootViewController: changeViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
//            }
//            else {
//                print("🚨 Invalid Login")
//            }
        }
        
        else {
            print("🚨 Invalid signUp")
        }
    }
}

extension SetNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // TextField의 입력이 변경될 때마다 호출되는 델리게이트 메서드
        // 여기에서는 textFieldDidChange 함수를 호출하여 SignUpButton의 색상을 업데이트합니다.
        textFieldDidChange()
        return true
    }
}

