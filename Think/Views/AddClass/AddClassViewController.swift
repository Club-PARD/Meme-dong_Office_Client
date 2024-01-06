//
//  AddClassViewController.swift
//  Think
//
//  Created by 이신원 on 12/30/23.
//

import UIKit
import Vision
import UniformTypeIdentifiers

class AddClassViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let userViewModel = UserViewModel.shared
    
    let thinkImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "think")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "김땡땡 선생님 안녕하세요"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plus") // 'plus'라는 이름의 이미지를 불러옵니다.
        button.setImage(image, for: .normal) // 버튼에 이미지를 설정합니다.
        button.tintColor = UIColor.mainYellow // 버튼의 tint 색상을 설정합니다.
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside) // 버튼에 액션을 추가합니다.

        return button
    }()


    
    let addLabel:UILabel = {
        let label = UILabel()
        label.text = "버튼을 눌러 학생을 추가해주세요"
        label.textColor = UIColor.introGrey
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "thinkCharacter1")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        logoLabel.text = userViewModel.user.name! + " 선생님 안녕하세요"
        view.addSubview(thinkImage)
        view.addSubview(logoLabel)
        view.addSubview(addButton)
        view.addSubview(addLabel)
        view.addSubview(backgroundImage)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        thinkImage.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thinkImage.topAnchor.constraint(equalTo: view.topAnchor,constant: 73),
            thinkImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            thinkImage.widthAnchor.constraint(equalToConstant: 105),
            thinkImage.heightAnchor.constraint(equalToConstant: 28),
    
            logoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            logoLabel.topAnchor.constraint(equalTo: thinkImage.bottomAnchor, constant: 24),
            
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 122),
            addButton.heightAnchor.constraint(equalToConstant: 122),
            
            addLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 25),
            
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
    }
    
    
    @objc func addButtonAction(){
        
//        let changeViewController = AddStudentNameVIewController()
//        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        backBarButtonItem.tintColor = .black
//        navigationItem.backBarButtonItem = backBarButtonItem
//        navigationController?.pushViewController(changeViewController, animated: true)
        
        let changeViewController = AddStudentNameVIewController()
        let navigationController = UINavigationController(rootViewController: changeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
