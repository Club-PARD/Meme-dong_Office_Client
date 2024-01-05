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
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        
        let symbolImage = UIImage(named: "profileIconCircle")
        button.setImage(symbolImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        
        //SF symbol에서 camera 아이콘 사용
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 122,weight: .ultraLight)
        let symbolImage = UIImage(systemName: "plus.circle", withConfiguration: symbolConfig)
        button.setImage(symbolImage, for: .normal)
        button.tintColor = UIColor.mainYellow
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
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
        logoLabel.text = userViewModel.user.name! + " 선생님"
        view.addSubview(thinkImage)
        view.addSubview(logoLabel)
        view.addSubview(profileButton)
        view.addSubview(addButton)
        view.addSubview(addLabel)
        view.addSubview(backgroundImage)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        thinkImage.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thinkImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            thinkImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            thinkImage.widthAnchor.constraint(equalToConstant: 68),
            thinkImage.heightAnchor.constraint(equalToConstant: 18),
            
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            profileButton.widthAnchor.constraint(equalToConstant: 32),
            profileButton.heightAnchor.constraint(equalToConstant: 32),
            
            logoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            logoLabel.topAnchor.constraint(equalTo: thinkImage.bottomAnchor, constant: 70),
            
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            
            
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
    }
    
    
    @objc func profileButtonAction() {
        
    }
    
    @objc func addButtonAction(){
        
        let changeViewController = AddStudentNameVIewController()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(changeViewController, animated: true)
    }
    
}
