//
//  FirstViewController.swift
//  Think
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let button = UIButton(type: .system)
        button.setTitle("Open Filter", for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        print("버튼이 눌렸습니다")
        
        let bottomSheetVC = BottomSheetViewController()
        // 1
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        // 2
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
}
