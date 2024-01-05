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

    // Adjust this property to set the width of the bottom sheet when it's visible
    private let bottomSheetWidth: CGFloat = 300
    
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
         view.clipsToBounds
         return view
     }()

     
     
     private var bottomSheetViewTopConstraint: NSLayoutConstraint!
     
     private func setupUI(){
         view.addSubview(dimmedView)
         view.addSubview(bottomSheetView)
         
         setupLayout()
     }
     
    
    private func setupLayout(){
         dimmedView.translatesAutoresizingMaskIntoConstraints = false
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




     @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
         hideBottomSheetAndGoBack()
     }
    
    // Override this method to only allow landscape orientation for this view controller
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

}

