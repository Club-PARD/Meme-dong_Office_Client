//
//  ViewController.swift
//  Think
//
//  Created by hyungjin kim on 12/18/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemBlue
        
        let myButton = UIButton(type: .system)
        myButton.setTitle("Fetch UserData", for: .normal)
        myButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myButton)

        NSLayoutConstraint.activate([
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myButton.widthAnchor.constraint(equalToConstant: 400),
            myButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        myButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        let secondVC = AppleLoginViewController()
        present(secondVC, animated: true, completion: nil)
    }



}

