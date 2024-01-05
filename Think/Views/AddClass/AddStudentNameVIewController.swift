//
//  AddStudnetNameVIewController.swift
//  Think
//
//  Created by 이신원 on 1/1/24.
//

import UIKit
import Vision


class AddStudentNameVIewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let cameraHandler = CameraHandler.shared

    
    let addLabel:UILabel = {
        let label = UILabel()
        label.text = "아이들의 이름이 잘 인식될 수 있도록\n명단을 화면 가까이에서 찍어주세요"
        label.numberOfLines = 2
        label.textColor = UIColor.introGrey
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let addCameraIconButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.mainYellow
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50,weight: .regular)
        let symbolImage = UIImage(systemName: "camera", withConfiguration: symbolConfig)
        
        button.setImage(symbolImage, for: .normal)
        button.tintColor = .white
        
        // 버튼의 전체 콘텐츠 주변에 패딩 추가
        button.contentEdgeInsets = UIEdgeInsets(top: 40, left: 30, bottom: 40, right: 30)
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(promptPhotoSelection), for: .touchUpInside)
        
        return button
    }()
    
    let addPlusIconButton:UIButton = {
        let button = UIButton(type: .system)
        
        //SF symbol에서 camera 아이콘 사용
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25,weight: .regular)
        let symbolImage = UIImage(systemName: "plus.circle.fill", withConfiguration: symbolConfig)
        
        button.setImage(symbolImage, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 50
        
        // 옵션: 그림자 추가
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        
        button.addTarget(self, action: #selector(promptPhotoSelection), for: .touchUpInside)
        
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundGrey
        setupNav()
        
        view.addSubview(addCameraIconButton)
        view.addSubview(addPlusIconButton)
        view.addSubview(addLabel)
        
        setupConstraints()
    }
    
    func setupNav(){
        navigationItem.title = "추가하기"
        
        //ios 15부터 적용
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white // 배경색을 흰색으로 설정
        
        appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
    }
    
    func setupConstraints(){
        addCameraIconButton.translatesAutoresizingMaskIntoConstraints = false
        addPlusIconButton.translatesAutoresizingMaskIntoConstraints = false
        addLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addCameraIconButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCameraIconButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addPlusIconButton.bottomAnchor.constraint(equalTo: addCameraIconButton.bottomAnchor, constant: 7),
            addPlusIconButton.trailingAnchor.constraint(equalTo: addCameraIconButton.trailingAnchor, constant: 7),
            
            addLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addLabel.topAnchor.constraint(equalTo: addCameraIconButton.bottomAnchor, constant: 30)
            
        ])
        
    }
    
    
    @objc func promptPhotoSelection() {
        cameraHandler.currentViewController = self // 현재 뷰 컨트롤러 참조 설정
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
                self.cameraHandler.openCamera()
            }
            alertController.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: "사진 보관함", style: .default) { _ in
            self.cameraHandler.openPhotoLibrary()
        }
        alertController.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
        
        
        
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    appDelegate.shouldSupportAllOrientation = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate.shouldSupportAllOrientation = false
    }
}
