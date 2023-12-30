//
//  TestViewController.swift
//  Meme_Dong_Office
//
//  Created by 김민섭 on 12/27/23.
//

import UIKit

class HomeViewController: UIViewController {

    let buttonHeight: CGFloat = 200
    let spacing: CGFloat = 20

    lazy var button1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button 1", for: .normal)
        button.addTarget(self, action: #selector(button1Tapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var button2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button 2", for: .normal)
        button.addTarget(self, action: #selector(button2Tapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var button3: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button 3", for: .normal)
        button.addTarget(self, action: #selector(button3Tapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
    }

    func setupButtons() {
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)

        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.topAnchor.constraint(equalTo: view.topAnchor, constant: spacing + 50), // Move down by 50 points
            button1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            button1.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        NSLayoutConstraint.activate([
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: spacing),
            button2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            button2.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        NSLayoutConstraint.activate([
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: spacing),
            button3.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            button3.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }

    @objc func button1Tapped(_ sender: UIButton) {
        // Handle button 1 tap actions here
        print("Button 1 tapped")
        let ViewController = FirstViewController()
        let navigationController = UINavigationController(rootViewController: ViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    @objc func button2Tapped(_ sender: UIButton) {
        print("Button 2 tapped")
        let ViewController = OriginViewController()
        let navigationController = UINavigationController(rootViewController: ViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)    }

    @objc func button3Tapped(_ sender: UIButton) {
        print("Button 3 tapped")
        let ViewController = LearnViewController()
        let navigationController = UINavigationController(rootViewController: ViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)    }
}
