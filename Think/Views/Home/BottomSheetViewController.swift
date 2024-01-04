//
//  BottomSheetViewController.swift
//  Think
//
//  Created by 김민섭 on 1/4/24.
//

import UIKit

class BottomSheetViewController:UIViewController {
     
     var bottomSheetPanMinTopConstant: CGFloat = 30.0
     private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant

    private let bottomSheetWidth: CGFloat = 200
    
    private var bottomSheetViewLeadingConstraint: NSLayoutConstraint!
    
     override func viewDidAppear(_ animated: Bool){
         super.viewDidAppear(animated)
         showBottomSheet()
     }
     
     private let dimmedView: UIView = {
         let view = UIView()
         view.backgroundColor = UIColor.clear
         return view
     }()
     
     private let bottomSheetView:UIView = {
         let view = UIView()
         view.backgroundColor = UIColor(red: 156/255, green: 197/255, blue: 231/255, alpha: 1.0)
         
         view.layer.cornerRadius = 10
         view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
         view.clipsToBounds = true
         return view
     }()


     private let dragIndicatorView: UIView = {
         let view = UIView()
         view.backgroundColor = .white
         view.layer.cornerRadius = 3
         return view
     }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Xmark") // "closeIcon"은 에셋 카탈로그에 있는 이미지의 이름입니다
        button.setImage(image, for: .normal)
        button.tintColor = .black // 필요한 경우 이미지의 색상을 변경
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
     
     private let roundBackgroundView: UIView = {
         let view = UIView()
         // Convert hex color #F0F0F0 to RGB and then to UIColor
         view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
         // Set the desired corner radius.
         view.layer.cornerRadius = 20
         view.clipsToBounds = true
         return view
     }()

     
     private let birthdateLabel: UILabel = {
          let label = UILabel()
          label.text = "생년월일 "
          label.font = UIFont.boldSystemFont(ofSize: 16)
          return label
     }()

     private let allergiesLabel: UILabel = {
          let label = UILabel()
          label.text = "알레르기 "
          label.font = UIFont.boldSystemFont(ofSize: 16)
          return label
     }()

     private let otherInfoLabel: UILabel = {
          let label = UILabel()
          label.text = "기타 "
          label.font = UIFont.boldSystemFont(ofSize: 16)
          return label
     }()
     
     private let updatedBirthdateLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 16)
         label.textColor = .black
         return label
     }()

     private let updatedAllergiesLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 16)
         label.textColor = .black
         return label
     }()

     private let updatedOtherInfoLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 16)
         label.textColor = .black
         return label
     }()

//     private let imageView: UIImageView = {
//          let imageView = UIImageView()
//          imageView.image = UIImage(named: "Image")
//          imageView.contentMode = .scaleAspectFit
//          imageView.clipsToBounds = true
//          return imageView
//     }()
     
    private let imageButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "Image") {
            button.setImage(image, for: .normal)
        }
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true

        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)

        return button
    }()

     private let editButton: UIButton = {
         let button = UIButton(type: .system)
         let image = UIImage(named: "pencil")
         button.setBackgroundImage(image, for: .normal)
         button.tintColor = .black
         button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
         return button
     }()

     private func configureLabelBackground(for label: UILabel) {
         label.backgroundColor = UIColor(red: 209/255.0, green: 234/255.0, blue: 255/255.0, alpha: 1.0)
         label.textColor = .black // 텍스트 색상 설정
         label.layer.cornerRadius = 5.0 // 둥근 모서리 설정
         label.clipsToBounds = true
     }


     
     private var bottomSheetViewTopConstraint: NSLayoutConstraint!
     
     private func setupUI(){
         view.addSubview(dimmedView)
         view.addSubview(bottomSheetView)
          view.addSubview(closeButton)
                  
         setupLayout()
     }
     
     private func setupLayout(){
          bottomSheetView.addSubview(roundBackgroundView)
          bottomSheetView.addSubview(birthdateLabel)
          bottomSheetView.addSubview(allergiesLabel)
          bottomSheetView.addSubview(otherInfoLabel)
          bottomSheetView.addSubview(imageButton)
          bottomSheetView.addSubview(editButton)
          bottomSheetView.addSubview(updatedAllergiesLabel)
          bottomSheetView.addSubview(updatedBirthdateLabel)
          bottomSheetView.addSubview(updatedOtherInfoLabel)
          

          birthdateLabel.translatesAutoresizingMaskIntoConstraints = false
          allergiesLabel.translatesAutoresizingMaskIntoConstraints = false
          otherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
          dimmedView.translatesAutoresizingMaskIntoConstraints = false
          roundBackgroundView.translatesAutoresizingMaskIntoConstraints = false
          closeButton.translatesAutoresizingMaskIntoConstraints = false

          updatedBirthdateLabel.translatesAutoresizingMaskIntoConstraints = false
          updatedAllergiesLabel.translatesAutoresizingMaskIntoConstraints = false
          updatedOtherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
          
          configureLabelBackground(for: updatedBirthdateLabel)
          configureLabelBackground(for: updatedAllergiesLabel)
          configureLabelBackground(for: updatedOtherInfoLabel)
          
          NSLayoutConstraint.activate([
              closeButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20),
              closeButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -30),
              closeButton.widthAnchor.constraint(equalToConstant: 17),
              closeButton.heightAnchor.constraint(equalToConstant: 17)
          ])
          
          NSLayoutConstraint.activate([
                  // Constraints for roundBackgroundView to define its position and size
                  roundBackgroundView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
                  roundBackgroundView.centerYAnchor.constraint(equalTo: bottomSheetView.centerYAnchor, constant: 100), // Adjust this as needed
                  roundBackgroundView.widthAnchor.constraint(equalToConstant: 200), // Adjust this as needed
                  roundBackgroundView.heightAnchor.constraint(equalToConstant: 160), // Adjust this based on the content
              ])

              // Constraints for birthdateLabel
              NSLayoutConstraint.activate([
                  birthdateLabel.topAnchor.constraint(equalTo: roundBackgroundView.topAnchor, constant: 20),
                  birthdateLabel.leadingAnchor.constraint(equalTo: roundBackgroundView.leadingAnchor, constant: 20),
                  birthdateLabel.trailingAnchor.constraint(equalTo: roundBackgroundView.trailingAnchor, constant: -20),
              ])

              // Constraints for allergiesLabel
              NSLayoutConstraint.activate([
                  allergiesLabel.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor, constant: 10),
                  allergiesLabel.leadingAnchor.constraint(equalTo: birthdateLabel.leadingAnchor),
                  allergiesLabel.trailingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor),
              ])

              // Constraints for otherInfoLabel
              NSLayoutConstraint.activate([
                  otherInfoLabel.topAnchor.constraint(equalTo: allergiesLabel.bottomAnchor, constant: 10),
                  otherInfoLabel.leadingAnchor.constraint(equalTo: birthdateLabel.leadingAnchor),
                  otherInfoLabel.trailingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor),
                  
                  updatedBirthdateLabel.leadingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor, constant: -95),
                  updatedBirthdateLabel.topAnchor.constraint(equalTo: birthdateLabel.topAnchor),
                     
                  updatedAllergiesLabel.leadingAnchor.constraint(equalTo: allergiesLabel.trailingAnchor, constant: -95),
                  updatedAllergiesLabel.topAnchor.constraint(equalTo: allergiesLabel.topAnchor),
                     
                  updatedOtherInfoLabel.leadingAnchor.constraint(equalTo: otherInfoLabel.trailingAnchor, constant: -125),
                  updatedOtherInfoLabel.topAnchor.constraint(equalTo: otherInfoLabel.topAnchor)
              ])


          
         NSLayoutConstraint.activate([
             dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
             dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
        
         imageButton.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 41),
            imageButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: -40),
            imageButton.heightAnchor.constraint(equalToConstant: 140)
          ])

          bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        
          bottomSheetViewLeadingConstraint = bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        NSLayoutConstraint.activate([
            bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetViewLeadingConstraint
        ])
          
          editButton.translatesAutoresizingMaskIntoConstraints = false
                  
                  // 연필 버튼 레이아웃 설정
          // Constraints for editButton
              NSLayoutConstraint.activate([
                  editButton.trailingAnchor.constraint(equalTo: roundBackgroundView.trailingAnchor, constant: -15),
                  editButton.bottomAnchor.constraint(equalTo: roundBackgroundView.bottomAnchor, constant: -10),
                  editButton.widthAnchor.constraint(equalToConstant: 20),
                  editButton.heightAnchor.constraint(equalToConstant: 20)
              ])
    }
    
    private func showBottomSheet(){
        // In landscape mode, the bottom sheet slides in from the right, so we change the leading constraint
        bottomSheetViewLeadingConstraint.constant = -bottomSheetWidth
        
        UIView.animate(withDuration: 0.25, delay:0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
     override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
         
         view.addSubview(dragIndicatorView)
         
         dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 dragIndicatorView.widthAnchor.constraint(equalToConstant: 5),
                 dragIndicatorView.heightAnchor.constraint(equalToConstant: 50),
                 dragIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                 dragIndicatorView.trailingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: -10)
             ])
         
         let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
             dimmedView.addGestureRecognizer(dimmedTap)
             dimmedView.isUserInteractionEnabled = true
         
         // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
         let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
         
         viewPan.delaysTouchesBegan = false
             viewPan.delaysTouchesEnded = false
             view.addGestureRecognizer(viewPan)
         
         
         
     }
     @objc private func closeButtonTapped() {
          hideBottomSheetAndGoBack()
     }

    @objc private func imageButtonTapped() {
         hideBottomSheetAndGoBack()
    }

     private func hideBottomSheetAndGoBack() {
         bottomSheetViewLeadingConstraint.constant = bottomSheetWidth

         UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
             self.view.layoutIfNeeded()
         }) { _ in
             if self.presentingViewController != nil {
                 self.dismiss(animated: false, completion: nil)
             }
         }
     }

     
     @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
         let translation = panGestureRecognizer.translation(in: self.view)
         let screenWidth = UIScreen.main.bounds.width

         switch panGestureRecognizer.state {
         case .began:
             bottomSheetPanStartingTopConstant = bottomSheetViewLeadingConstraint.constant
         case .changed:
             let newConstant = bottomSheetPanStartingTopConstant + translation.x
             if newConstant <= 0 && screenWidth - newConstant >= 30.0 {
                 bottomSheetViewLeadingConstraint.constant = newConstant
             }
         case .ended:
             print("Drag Ended")
         default:
             break
         }
     }

     @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
         hideBottomSheetAndGoBack()
     }

     @objc private func editButtonTapped() {
         let alertController = UIAlertController(title: "정보 수정", message: nil, preferredStyle: .alert)

         alertController.addTextField { textField in
             textField.placeholder = "생년월일"
             textField.text = ""
         }
         alertController.addTextField { textField in
             textField.placeholder = "알레르기"
             textField.text = ""
         }
         alertController.addTextField { textField in
             textField.placeholder = "기타"
             textField.text = ""
         }

          let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
               guard let self = self else { return }
               let birthdateText = alertController.textFields?[0].text ?? ""
               let allergiesText = alertController.textFields?[1].text ?? ""
               let otherInfoText = alertController.textFields?[2].text ?? ""
               
               // 새로운 라벨들 업데이트
               self.updatedBirthdateLabel.text = birthdateText
               self.updatedAllergiesLabel.text = allergiesText
               self.updatedOtherInfoLabel.text = otherInfoText
          }

         let cancelAction = UIAlertAction(title: "취소", style: .cancel)

         alertController.addAction(saveAction)
         alertController.addAction(cancelAction)

         self.present(alertController, animated: true)
     }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

}
