//
//  ViewController.swift
//  Think
//
//  Created by 이신원 on 1/6/24.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
            super.viewDidLoad()

            // 전체 뷰의 배경색 설정
            view.backgroundColor = .white

            // 이미지 뷰 설정
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit // 이미지가 비율을 유지하며 화면에 맞춰짐
            imageView.image = UIImage(named: "AppIcon") // 'launchImage'는 Asset 카탈로그에 있는 이미지 이름
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)

            // 이미지 뷰의 제약조건 설정
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7), // 이미지 뷰의 너비를 뷰 너비의 30%로 설정
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor) // 이미지 뷰의 높이를 너비와 동일하게 설정
            ])
        }

    // 뷰가 나타난 후 3초 후에 메인 뷰 컨트롤러로 전환
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.switchToMainViewController()
        }
    }

    func switchToMainViewController() {
        // 메인 뷰 컨트롤러로 전환하는 로직
        // 예: self.view.window?.rootViewController = MainViewController()
        if let window = self.view.window {
            window.rootViewController = WelcomeViewController() // MainViewController는 메인 뷰 컨트롤러 클래스 이름
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)
        }
    }
}
