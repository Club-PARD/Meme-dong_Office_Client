//
//  LearnViewController.swift
//  Meme_Dong_Office
//
//  Created by 김민섭 on 12/28/23.
//

import UIKit

class LearnViewController: UIViewController {

    lazy var button1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button 1", for: .normal)
        button.addTarget(self, action: #selector(button1Tapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var student: UIButton = {
        let student = UIButton(type: .system)
        student.setTitle("student", for: .normal)
        student.addTarget(self, action: #selector(studentTapped(_:)), for: .touchUpInside)
        student.translatesAutoresizingMaskIntoConstraints = false
        return student
    }()

    var newButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
    }

    func setupButtons() {
        view.addSubview(button1)
        view.addSubview(student)

        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            button1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            student.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            student.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            student.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80)
        ])
    }

    @objc func button1Tapped(_ sender: UIButton) {
        print("Button 1 tapped")
        fetchDataAndUpdateButtons()

    }

    @objc func studentTapped(_ sender: UIButton) {
        print("student tapped")
        fetchDataAndUpdateButtons()
    }
    
    func fetchDataAndUpdateButtons() {
        fetchDataFromServer { result in
            DispatchQueue.main.async {
                self.updateButtonsWithData(result)
            }
        }
    }

    func updateButtonsWithData(_ data: [String]) {
        removeButtons()

        for (index, name) in data.enumerated() {
            let newButton = UIButton(type: .system)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.addTarget(self, action: #selector(newButtonTapped(_:)), for: .touchUpInside)
            newButton.setTitle(name, for: .normal)
            newButton.titleLabel?.numberOfLines = 0
            newButton.titleLabel?.lineBreakMode = .byWordWrapping
            newButton.backgroundColor = .gray
            newButton.setTitleColor(.black, for: .normal)

            newButtons.append(newButton)
            view.addSubview(newButton)

            NSLayoutConstraint.activate([
                newButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
                newButton.heightAnchor.constraint(equalToConstant: 40),
                newButton.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: CGFloat(30 * index)),
                newButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }



    func removeButtons() {
        for button in newButtons {
            button.removeFromSuperview()
        }
        newButtons.removeAll()
    }

    @objc func newButtonTapped(_ sender: UIButton) {
        print("New Button tapped")
        // Handle the tap event for the newly added button if needed
    }
    
    func fetchDataFromServer(completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "http://13.125.210.242:8080/api/v1/test/students") else {
            completion(["Failed to fetch data"])
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(["Failed to fetch data"])
                return
            }

            if let data = data {
                do {
                    // JSON 데이터를 파싱하여 배열로 변환
                    let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
                    
                    // 배열에서 랜덤으로 3개의 데이터 선택
                    let randomData = jsonArray.shuffled().prefix(3).compactMap { $0["name"] as? String }

                    completion(randomData)
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(["Failed to fetch data"])
                }
            } else {
                completion(["Failed to fetch data"])
            }
        }

        task.resume()
    }


    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.shouldSupportAllOrientation = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.shouldSupportAllOrientation = true
    }
}
