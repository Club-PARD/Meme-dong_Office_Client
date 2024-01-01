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
    
    let cameraHandler = CameraHandler.shared
    
    let student_add_label:UILabel = {
        let label = UILabel()
        label.text = "학생명단 추가"
        return label
    }()
    
    let student_add_button:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        
        //SF symbol에서 camera 아이콘 사용
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50,weight: .bold)
        let symbolImage = UIImage(systemName: "camera", withConfiguration: symbolConfig)
        
        button.setImage(symbolImage, for: .normal)
        
        button.tintColor = .white
        
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(student_add_label)
        view.addSubview(student_add_button)
        
        student_add_button.addTarget(self, action: #selector(promptPhotoSelection), for: .touchUpInside)
        setupConstraints()
    }
    
    func setupConstraints(){
        student_add_label.translatesAutoresizingMaskIntoConstraints = false
        student_add_button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            student_add_button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            student_add_button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            student_add_label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            student_add_label.bottomAnchor.constraint(equalTo: student_add_button.topAnchor, constant: -20),
            
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
    
}
