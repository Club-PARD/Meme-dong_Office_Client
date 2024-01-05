//
//  CameraHandler.swift
//  OpticalCharacterRecognition
//
//  Created by 이신원 on 12/30/23.
//

import UIKit

class CameraHandler: NSObject{
    static let shared = CameraHandler()
    weak var currentViewController: UIViewController?
    weak var detectTextViewController: DetectTextViewController?
//    weak var detailBottomSheetViewController: DetailBottomSheetViewController?
    
    var imagePicked: ((UIImage) -> Void)?
    
    func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                currentViewController!.present(imagePicker, animated: true)
            }
        }

        func openPhotoLibrary() {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                currentViewController!.present(imagePicker, animated: true)
            }
        }
    
}

extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicked?(image)
            
            if currentViewController is AddBottomSheetViewController {
                if let detectVC = detectTextViewController {
                    detectVC.updateImageView(with: image)
                }
            }
            else if currentViewController is DetailBottomSheetViewController {
                //none
            }
            else{
                let detectTextVC = DetectTextViewController()
                detectTextVC.incomingImage = image
                            
                let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                backBarButtonItem.tintColor = .black
                currentViewController!.navigationItem.backBarButtonItem = backBarButtonItem
                currentViewController!.navigationController?.pushViewController(detectTextVC, animated: true)
            }
            
        }
        
    
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
