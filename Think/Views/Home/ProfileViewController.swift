//
//  ProfileViewController.swift
//  Think
//
//  Created by 김민섭 on 1/5/24.
//

import UIKit
class ProfileViewController:UIViewController {
     
     var bottomSheetPanMinTopConstant: CGFloat = 30.0
     private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant

    private let bottomSheetWidth: CGFloat = 200
    
    private var bottomSheetViewLeadingConstraint: NSLayoutConstraint!
    
     override func viewDidAppear(_ animated: Bool){
         super.viewDidAppear(animated)
         showBottomSheet()
     }
     
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark") // "closeIcon"은 에셋 카탈로그에 있는 이미지의 이름입니다
        button.setImage(image, for: .normal)
        button.tintColor = .black // 필요한 경우 이미지의 색상을 변경
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let newClassButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새 학급 만들기", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(newClassButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
        view.clipsToBounds
        return view
    }()

     
     
     private var bottomSheetViewTopConstraint: NSLayoutConstraint!
     
     private func setupUI(){
         view.addSubview(dimmedView)
         view.addSubview(bottomSheetView)
         view.addSubview(closeButton)
         view.addSubview(logoutButton)
         view.addSubview(newClassButton)

         setupLayout()
     }
     
    
    private func setupLayout(){
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        newClassButton.translatesAutoresizingMaskIntoConstraints = false

        
         NSLayoutConstraint.activate([
             dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
             dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         ])
        
        // In landscape mode, we will use the leading constraint instead of the top to slide from the right
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetViewLeadingConstraint = bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        NSLayoutConstraint.activate([
            bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetViewLeadingConstraint
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -30),
            closeButton.widthAnchor.constraint(equalToConstant: 17),
            closeButton.heightAnchor.constraint(equalToConstant: 17)
        ])
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 270),
            logoutButton.trailingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 0),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            newClassButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 80),
            newClassButton.trailingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 0),
            newClassButton.widthAnchor.constraint(equalToConstant: 200),
            newClassButton.heightAnchor.constraint(equalToConstant: 50)
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
         
         let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
             dimmedView.addGestureRecognizer(dimmedTap)
             dimmedView.isUserInteractionEnabled = true
         
         // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
         //let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
         
//         viewPan.delaysTouchesBegan = false
//             viewPan.delaysTouchesEnded = false
//             view.addGestureRecognizer(viewPan)
//         
//         
         
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

//     
//     @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
//         let translation = panGestureRecognizer.translation(in: self.view)
//         let screenWidth = UIScreen.main.bounds.width
//
//         switch panGestureRecognizer.state {
//         case .began:
//             bottomSheetPanStartingTopConstant = bottomSheetViewLeadingConstraint.constant
//         case .changed:
//             let newConstant = bottomSheetPanStartingTopConstant + translation.x
//             if newConstant <= 0 && screenWidth - newConstant >= 30.0 {
//                 bottomSheetViewLeadingConstraint.constant = newConstant
//             }
//         case .ended:
//             print("Drag Ended")
//         default:
//             break
//         }
//     }

    
    
    @objc private func closeButtonTapped() {
         hideBottomSheetAndGoBack()
    }
    
    @objc private func newClassButtonTapped() {
        print("새 학급 만들기 버튼이 눌렸습니다.")
    }
    
    @objc private func logoutButtonTapped() {
        print("로그아웃 버튼이 눌렸습니다.")
        TokenManager.shared.clearTokens() // 현재 토큰 삭제
        let detailVC = WelcomeViewController() // 첫 화면으로 이동
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: false, completion: nil)
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    // Override this method to only allow landscape orientation for this view controller
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

}

